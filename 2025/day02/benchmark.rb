#!/usr/bin/env ruby
# Benchmark different strategies for Day 02: Gift Shop
#
# Generates synthetic data of varying sizes and measures performance
#
# Strategies:
#   - brute_force:    O(n) single-threaded, string split
#   - string_check:   O(n) single-threaded, regex backreference
#   - parallel_brute: O(n/p) multi-process via parallel gem
#   - ractor_brute:   O(n/p) multi-threaded via Ruby 3 Ractors
#   - multiplier:     O(log n) mathematical, uses 10^d + 1 formula

require 'benchmark'
require_relative 'solution'

# System info
def system_info
  info = []
  info << `uname -a`.strip

  # FreeBSD
  if File.exist?('/sbin/sysctl')
    model = `sysctl -n hw.model 2>/dev/null`.strip
    ncpu = `sysctl -n hw.ncpu 2>/dev/null`.strip
    mem = `sysctl -n hw.physmem 2>/dev/null`.strip.to_i / (1024**3)
    info << "CPU: #{model}, #{ncpu} cores, #{mem}GB RAM"
  end

  info << "Ruby: #{RUBY_VERSION} [#{RUBY_PLATFORM}]"
  info << "Parallel CPUs: #{Day02.cpu_count}"
  info.join("\n")
end

# Generate synthetic input with ranges of specified sizes
def generate_input(range_specs)
  range_specs.map { |start, size| "#{start}-#{start + size}" }.join(',')
end

# Different test scenarios
SCENARIOS = {
  tiny: [
    [10, 100],           # 10-110
    [1000, 500],         # 1000-1500
  ],
  small: [
    [0, 10_000],
    [100_000, 10_000],
    [1_000_000, 10_000],
  ],
  medium: [
    [0, 100_000],
    [1_000_000, 100_000],
    [10_000_000, 100_000],
  ],
  large: [
    [0, 1_000_000],
    [10_000_000, 1_000_000],
    [100_000_000, 1_000_000],
  ],
  huge: [
    [0, 10_000_000],
    [1_000_000_000, 10_000_000],
  ],
  extreme: [
    [0, 100_000_000],
    [1_000_000_000_000, 100_000_000],
  ],
}.freeze

def format_number(n)
  n.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

def run_benchmark(scenario_name, range_specs, strategies)
  input = generate_input(range_specs)
  total_numbers = range_specs.sum { |_, size| size }

  puts "\n#{'=' * 70}"
  puts "Scenario: #{scenario_name}"
  puts "Ranges: #{range_specs.map { |s, sz| "#{format_number(s)}-#{format_number(s + sz)}" }.join(', ')}"
  puts "Total numbers to check (brute force): #{format_number(total_numbers)}"
  puts '=' * 70

  results = {}

  Benchmark.bm(18) do |x|
    strategies.each do |strategy|
      # Skip single-threaded for very large inputs
      if %i[brute_force string_check].include?(strategy) && total_numbers > 20_000_000
        puts "  #{strategy.to_s.ljust(18)} (skipped - single-threaded too slow)"
        next
      end

      # Skip ractor for extreme (overhead not worth it)
      if strategy == :ractor_brute && total_numbers > 50_000_000
        puts "  #{strategy.to_s.ljust(18)} (skipped - ractor overhead too high)"
        next
      end

      result = nil
      time = x.report("#{strategy}:") do
        solver = Day02.new(input, strategy: strategy)
        result = solver.part1
      end
      results[strategy] = result
    end
  end

  # Verify all computed results match
  if results.values.uniq.size == 1
    puts "\nResult: #{format_number(results.values.first)}"
    puts "✓ All strategies agree"
  elsif results.size > 1
    puts "\n✗ MISMATCH:"
    results.each { |s, r| puts "  #{s}: #{r}" }
  end
end

# Main benchmark run
puts "Day 02: Gift Shop - Strategy Benchmark"
puts "-" * 70
puts system_info
puts "-" * 70
puts Time.now
puts

strategies = Day02::STRATEGIES

# Run progressively larger scenarios
[:tiny, :small, :medium, :large, :huge, :extreme].each do |scenario|
  run_benchmark(scenario, SCENARIOS[scenario], strategies)
end

# Special: timing comparison table
puts "\n\n#{'=' * 70}"
puts "TIMING SUMMARY: multiplier strategy on increasing range sizes"
puts '=' * 70
puts

sizes = [1_000, 10_000, 100_000, 1_000_000, 10_000_000, 100_000_000, 1_000_000_000]

puts "| Range Size      | Time (seconds) | Invalid IDs Found |"
puts "|-----------------|----------------|-------------------|"

sizes.each do |size|
  input = "0-#{size}"

  time = Benchmark.measure do
    @result = Day02.new(input, strategy: :multiplier).part1
  end

  puts "| #{format_number(size).rjust(15)} | #{time.real.round(6).to_s.ljust(14)} | #{format_number(@result).rjust(17)} |"
end

puts "\nNote: multiplier strategy is O(log n) - time barely increases with range size"

# Parallel scaling comparison
puts "\n\n#{'=' * 70}"
puts "PARALLEL SCALING: comparing single vs multi-core on 20M numbers"
puts '=' * 70
puts

input = "0-10000000,1000000000-1010000000"

puts "| Strategy         | Time (s)  | Speedup vs brute |"
puts "|------------------|-----------|------------------|"

times = {}
[:brute_force, :parallel_brute, :multiplier].each do |strategy|
  t = Benchmark.measure { Day02.new(input, strategy: strategy).part1 }
  times[strategy] = t.real
  speedup = strategy == :brute_force ? "1.0x" : "#{(times[:brute_force] / t.real).round(1)}x"
  puts "| #{strategy.to_s.ljust(16)} | #{t.real.round(3).to_s.ljust(9)} | #{speedup.rjust(16)} |"
end
