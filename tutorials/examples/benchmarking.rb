#!/usr/bin/env ruby
# frozen_string_literal: true

# Ruby benchmarking and profiling examples
# Demonstrates Benchmark, GC stats, and memory analysis

require 'benchmark'
require 'objspace'

module Benchmarking
  # Compare multiple approaches
  def self.compare(iterations: 1000, **approaches)
    puts "Comparing #{approaches.size} approaches (#{iterations} iterations each):"
    puts '-' * 60

    results = {}
    Benchmark.bmbm(20) do |x|
      approaches.each do |name, block|
        results[name] = nil
        x.report("#{name}:") { iterations.times { results[name] = block.call } }
      end
    end

    # Verify all results match
    values = results.values.uniq
    if values.size == 1
      puts "\nAll approaches return: #{values.first.inspect[0..50]}"
    else
      puts "\nWARNING: Results differ!"
      results.each { |name, val| puts "  #{name}: #{val.inspect[0..50]}" }
    end
  end

  # Time a single block
  def self.time(label = 'Block', iterations = 1)
    result = nil
    total = Benchmark.measure { iterations.times { result = yield } }
    avg_ms = (total.real / iterations) * 1000

    puts format('%-20s %8.3fms (avg of %d)', "#{label}:", avg_ms, iterations)
    result
  end

  # Track memory allocations
  def self.allocations
    GC.disable
    before = ObjectSpace.count_objects.dup
    result = yield
    after = ObjectSpace.count_objects
    GC.enable

    diff = {}
    after.each do |type, count|
      delta = count - before[type]
      diff[type] = delta if delta != 0
    end

    { result: result, allocations: diff }
  end

  # Track GC activity
  def self.gc_activity
    GC.start
    before = GC.stat.dup

    result = yield

    after = GC.stat
    {
      result: result,
      gc_count: after[:count] - before[:count],
      minor_gc: after[:minor_gc_count] - before[:minor_gc_count],
      major_gc: after[:major_gc_count] - before[:major_gc_count],
      allocated_objects: after[:total_allocated_objects] - before[:total_allocated_objects]
    }
  end

  # Memory size of object (shallow)
  def self.memsize(obj)
    ObjectSpace.memsize_of(obj)
  end

  # Memory size including all referenced objects
  def self.memsize_deep(obj)
    seen = {}
    queue = [obj]
    total = 0

    while (current = queue.shift)
      next if seen[current.object_id]

      seen[current.object_id] = true
      total += ObjectSpace.memsize_of(current)

      # Queue referenced objects
      case current
      when Array
        current.each { |item| queue << item }
      when Hash
        current.each { |k, v| queue << k << v }
      end
    end

    total
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Ruby Benchmarking Examples"
  puts "=" * 60

  puts "\n1. Benchmark Comparison"
  puts "-" * 40
  data = (1..10_000).to_a

  Benchmarking.compare(
    iterations: 100,
    'each loop': lambda {
      sum = 0
      data.each { |n| sum += n }
      sum
    },
    'reduce': -> { data.reduce(0, :+) },
    'sum': -> { data.sum },
    'inject': -> { data.inject(:+) }
  )

  puts "\n2. Simple Timing"
  puts "-" * 40
  Benchmarking.time('Array creation', 1000) { Array.new(1000) { rand } }
  Benchmarking.time('Hash creation', 1000) { Hash[(1..100).map { |i| [i, i * i] }] }
  Benchmarking.time('String concat', 1000) { (1..100).map(&:to_s).join(',') }

  puts "\n3. Memory Allocations"
  puts "-" * 40
  result = Benchmarking.allocations { Array.new(1000) { |i| "string_#{i}" } }
  puts "Creating 1000 strings:"
  result[:allocations].each { |type, count| puts "  #{type}: #{count}" if count > 0 }

  puts "\n4. GC Activity"
  puts "-" * 40
  result = Benchmarking.gc_activity do
    1_000_000.times { |i| i.to_s }
  end
  puts "1M integer-to-string conversions:"
  puts "  GC runs: #{result[:gc_count]}"
  puts "  Minor GC: #{result[:minor_gc]}"
  puts "  Major GC: #{result[:major_gc]}"
  puts "  Objects allocated: #{result[:allocated_objects]}"

  puts "\n5. Memory Size Analysis"
  puts "-" * 40
  array = Array.new(1000) { |i| i }
  hash = Hash[(1..1000).map { |i| [i, i * i] }]
  string = 'x' * 10_000

  puts "Array of 1000 integers: #{Benchmarking.memsize(array)} bytes"
  puts "Hash with 1000 entries: #{Benchmarking.memsize(hash)} bytes"
  puts "String of 10000 chars: #{Benchmarking.memsize(string)} bytes"

  puts "\n6. Benchmark.bm vs Benchmark.bmbm"
  puts "-" * 40
  puts "bmbm runs a rehearsal to warm up the JIT:"
  n = 50_000
  Benchmark.bmbm(15) do |x|
    x.report('for loop:') { for i in 1..n; a = i; end } # rubocop:disable Style/For
    x.report('times:') { n.times { |i| a = i } }
    x.report('upto:') { 1.upto(n) { |i| a = i } }
  end
end
