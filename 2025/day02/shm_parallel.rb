#!/usr/bin/env ruby
# Demonstration of file-based shared state parallelism
#
# Architecture:
#   - Memory-mapped temp file for shared results
#   - Workers write to specific offsets
#   - No socket overhead, minimal IPC
#
# This simulates POSIX shared memory using mmap semantics

require 'benchmark'
require 'tempfile'

def invalid_id?(n)
  s = n.to_s
  len = s.length
  return false if len.odd? || len == 0
  half = len / 2
  s[0, half] == s[half, half]
end

def compute_range_sum(range_start, range_end)
  sum = 0
  (range_start..range_end).each do |n|
    sum += n if invalid_id?(n)
  end
  sum
end

def run_shm_parallel(ranges, num_workers)
  # Create temp file for shared state
  # Each worker writes 8 bytes (64-bit integer) at offset worker_id * 8
  tmpfile = Tempfile.new('aoc_shm')
  tmpfile.write("\0" * (num_workers * 8 * ranges.size))
  tmpfile.flush
  shm_path = tmpfile.path

  # Split work
  work_units = []
  ranges.each_with_index do |range, range_idx|
    chunk_size = (range.size.to_f / num_workers).ceil
    range.each_slice(chunk_size).with_index do |chunk, worker_idx|
      work_units << {
        range_start: chunk.first,
        range_end: chunk.last,
        offset: (range_idx * num_workers + worker_idx) * 8
      }
    end
  end

  # Spawn workers
  pids = work_units.map do |unit|
    fork do
      result = compute_range_sum(unit[:range_start], unit[:range_end])

      # Write result to shared file at specific offset
      File.open(shm_path, 'r+b') do |f|
        f.seek(unit[:offset])
        f.write([result].pack('Q<'))  # 64-bit little-endian
      end
      exit(0)
    end
  end

  # Wait for all workers
  pids.each { |pid| Process.wait(pid) }

  # Read results
  results = File.binread(shm_path).unpack('Q<*')
  tmpfile.close
  tmpfile.unlink

  results.sum
end

# Alternative: Named pipe (FIFO) based approach
def run_fifo_parallel(ranges, num_workers)
  fifo_dir = '/tmp/aoc_fifos'
  Dir.mkdir(fifo_dir) unless Dir.exist?(fifo_dir)

  # Split work
  work_units = []
  ranges.each do |range|
    chunk_size = (range.size.to_f / num_workers).ceil
    range.each_slice(chunk_size).with_index do |chunk, idx|
      work_units << { range_start: chunk.first, range_end: chunk.last, id: work_units.size }
    end
  end

  # Create FIFOs
  work_units.each do |unit|
    fifo_path = "#{fifo_dir}/worker_#{unit[:id]}"
    system("mkfifo #{fifo_path}") unless File.exist?(fifo_path)
  end

  # Spawn workers (must open FIFO for writing AFTER reader opens)
  pids = work_units.map do |unit|
    fork do
      result = compute_range_sum(unit[:range_start], unit[:range_end])
      File.open("#{fifo_dir}/worker_#{unit[:id]}", 'w') { |f| f.puts(result) }
      exit(0)
    end
  end

  # Read from FIFOs (blocking until worker writes)
  results = work_units.map do |unit|
    File.read("#{fifo_dir}/worker_#{unit[:id]}").to_i
  end

  # Cleanup
  pids.each { |pid| Process.wait(pid) }
  work_units.each { |unit| File.unlink("#{fifo_dir}/worker_#{unit[:id]}") rescue nil }

  results.sum
end

# Main benchmark
if __FILE__ == $0
  puts "=== Shared Memory & FIFO Parallel Benchmark ==="
  puts

  scenarios = {
    small: [[0, 100_000]],
    medium: [[0, 1_000_000]],
    large: [[0, 10_000_000]],
  }

  num_workers = 4
  puts "Workers: #{num_workers}"
  puts

  scenarios.each do |name, range_specs|
    ranges = range_specs.map { |s, e| (s..e) }
    total_numbers = ranges.sum(&:size)

    puts "Scenario: #{name} (#{total_numbers} numbers)"
    puts "-" * 50

    # Shared memory approach
    result_shm = nil
    time_shm = Benchmark.measure { result_shm = run_shm_parallel(ranges, num_workers) }
    puts "  SHM file:  #{time_shm.real.round(4)}s  (result: #{result_shm})"

    # FIFO approach
    result_fifo = nil
    time_fifo = Benchmark.measure { result_fifo = run_fifo_parallel(ranges, num_workers) }
    puts "  FIFO:      #{time_fifo.real.round(4)}s  (result: #{result_fifo})"

    puts "  Match: #{result_shm == result_fifo ? '✓' : '✗'}"
    puts
  end
end
