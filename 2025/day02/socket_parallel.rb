#!/usr/bin/env ruby
# Demonstration of Unix Domain Socket-based parallelism
#
# Architecture:
#   Coordinator spawns N workers
#   Each worker computes a subrange and sends result via socket
#   Coordinator aggregates results
#
# This bypasses Ruby's GVL completely (separate processes)
# and demonstrates IPC patterns on FreeBSD/Unix

require 'socket'
require 'benchmark'

SOCKET_PATH = '/tmp/aoc_day02.sock'

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

def run_coordinator(ranges, num_workers)
  # Clean up any existing socket
  File.unlink(SOCKET_PATH) if File.exist?(SOCKET_PATH)

  # Create Unix domain socket server
  server = UNIXServer.new(SOCKET_PATH)

  # Split work among workers
  all_ranges = ranges.flat_map do |range|
    chunk_size = (range.size.to_f / num_workers).ceil
    range.each_slice(chunk_size).map do |chunk|
      [chunk.first, chunk.last]
    end
  end

  # Spawn workers
  worker_pids = all_ranges.map.with_index do |(range_start, range_end), i|
    fork do
      # Worker process
      socket = UNIXSocket.new(SOCKET_PATH)
      result = compute_range_sum(range_start, range_end)
      socket.puts("#{i}:#{result}")
      socket.close
      exit(0)
    end
  end

  # Collect results
  results = {}
  all_ranges.size.times do
    client = server.accept
    msg = client.gets.strip
    worker_id, result = msg.split(':')
    results[worker_id.to_i] = result.to_i
    client.close
  end

  # Wait for all workers
  worker_pids.each { |pid| Process.wait(pid) }

  # Cleanup
  server.close
  File.unlink(SOCKET_PATH)

  results.values.sum
end

# Main benchmark
if __FILE__ == $0
  puts "=== Unix Socket Parallel Benchmark ==="
  puts "Socket path: #{SOCKET_PATH}"
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

    result = nil
    time = Benchmark.measure do
      result = run_coordinator(ranges, num_workers)
    end

    puts "  Result: #{result}"
    puts "  Time:   #{time.real.round(4)}s"
    puts
  end
end
