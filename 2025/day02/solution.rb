# Advent of Code 2025 - Day 2: Gift Shop
# https://adventofcode.com/2025/day/2
#
# Find invalid product IDs (digit sequence repeated exactly twice)
#
# Ruby idioms demonstrated:
# - scan for parsing with regex
# - Range for iteration
# - String slicing for pattern detection
# - Mathematical approach: pattern * (10^d + 1)
# - Strategy pattern for algorithm selection

class Day02
  STRATEGIES = %i[brute_force string_check multiplier parallel_brute ractor_brute ractor_optimized hybrid].freeze

  def initialize(input, strategy: :multiplier)
    @ranges = parse_ranges(input)
    @strategy = strategy
  end

  def self.cpu_count
    @cpu_count ||= begin
      if File.exist?('/sbin/sysctl')
        `sysctl -n hw.ncpu 2>/dev/null`.to_i
      elsif File.exist?('/proc/cpuinfo')
        File.read('/proc/cpuinfo').scan(/^processor/).count
      else
        4
      end
    end
  end

  # Part 1: Sum of all invalid IDs in ranges
  #
  # Invalid = digit sequence repeated exactly twice (11, 6464, 123123)
  def part1
    @ranges.sum { |range| sum_invalid_in_range(range) }
  end

  # Part 2: Placeholder (puzzle may have part 2)
  def part2
    nil
  end

  private

  def sum_invalid_in_range(range)
    case @strategy
    when :brute_force
      brute_force_sum(range)
    when :string_check
      string_check_sum(range)
    when :multiplier
      multiplier_sum(range)
    when :parallel_brute
      parallel_brute_sum(range)
    when :ractor_brute
      ractor_brute_sum(range)
    when :ractor_optimized
      ractor_optimized_sum(range)
    when :hybrid
      hybrid_sum(range)
    end
  end

  # ==========================================================================
  # Strategy 1: Brute Force
  # O(n) where n = range size
  # Iterate every number, convert to string, check if repeated
  # ==========================================================================
  def brute_force_sum(range)
    range.select { |id| invalid_id_string?(id) }.sum
  end

  def invalid_id_string?(n)
    s = n.to_s
    len = s.length
    return false if len.odd? || len == 0

    half = len / 2
    s[0, half] == s[half, half]
  end

  # ==========================================================================
  # Strategy 2: String Check with Early Exit
  # O(n) but faster per-check using regex
  # ==========================================================================
  def string_check_sum(range)
    range.select { |id| invalid_id_regex?(id) }.sum
  end

  def invalid_id_regex?(n)
    s = n.to_s
    return false if s.length.odd?

    # Regex: capture first half, backreference must match rest
    s.match?(/^(.+)\1$/)
  end

  # ==========================================================================
  # Strategy 3: Multiplier (Optimal)
  # O(d * p) where d = digit lengths, p = patterns per length
  # Key insight: repeated number = pattern * (10^d + 1)
  #
  # For d-digit pattern:
  #   multiplier = 10^d + 1  (e.g., d=2 → 101)
  #   pattern range = 10^(d-1) to 10^d - 1  (e.g., d=2 → 10..99)
  #   result = pattern * multiplier  (e.g., 64 * 101 = 6464)
  # ==========================================================================
  def multiplier_sum(range)
    return 0 if range.end < 11  # Smallest repeated number is 11

    max_d = range.end.to_s.length / 2
    total = 0

    (1..max_d).each do |d|
      mult = 10 ** d + 1
      min_pattern = d == 1 ? 1 : 10 ** (d - 1)
      max_pattern = 10 ** d - 1

      # Clamp pattern range to fit within the given range
      lo = [(range.begin.to_f / mult).ceil, min_pattern].max
      hi = [range.end / mult, max_pattern].min

      next if lo > hi

      # Sum all valid candidates: pattern * mult for pattern in lo..hi
      # Arithmetic series: sum = (count * (first + last)) / 2, then * mult
      count = hi - lo + 1
      pattern_sum = count * (lo + hi) / 2
      total += pattern_sum * mult
    end

    total
  end

  # ==========================================================================
  # Strategy 4: Parallel Brute Force (using parallel gem)
  # O(n/p) where p = number of processors
  # Splits range into chunks, processes in parallel
  # ==========================================================================
  def parallel_brute_sum(range)
    require 'parallel'

    chunk_size = [(range.size / Day02.cpu_count), 1000].max
    chunks = range.each_slice(chunk_size).to_a

    Parallel.map(chunks, in_processes: Day02.cpu_count) do |chunk|
      chunk.select { |id| invalid_id_string?(id) }.sum
    end.sum
  end

  # ==========================================================================
  # Strategy 5: Ractor Brute Force (Ruby 3.x native parallelism)
  # O(n/p) where p = number of ractors
  # Uses Ractor for true parallel execution without GVL
  # ==========================================================================
  def ractor_brute_sum(range)
    num_ractors = Day02.cpu_count
    chunk_size = [(range.size / num_ractors), 1000].max

    ractors = range.each_slice(chunk_size).map do |chunk|
      chunk_array = chunk.to_a
      Ractor.new(chunk_array) do |nums|
        nums.select do |n|
          s = n.to_s
          len = s.length
          next false if len.odd? || len == 0
          half = len / 2
          s[0, half] == s[half, half]
        end.sum
      end
    end

    ractors.map(&:take).sum
  end

  # ==========================================================================
  # Strategy 6: Ractor Optimized
  # Key improvements over ractor_brute:
  # - Pass range bounds instead of array (no serialization of millions of elements)
  # - Exactly N ractors where N = CPU count (no overhead from spawning many)
  # - Each ractor computes its own subrange
  # ==========================================================================
  def ractor_optimized_sum(range)
    num_ractors = Day02.cpu_count
    range_size = range.size
    chunk_size = (range_size.to_f / num_ractors).ceil

    ractors = num_ractors.times.map do |i|
      start_offset = i * chunk_size
      end_offset = [(i + 1) * chunk_size - 1, range_size - 1].min

      subrange_start = range.begin + start_offset
      subrange_end = range.begin + end_offset

      # Pass only the bounds, not the data!
      Ractor.new(subrange_start, subrange_end) do |lo, hi|
        sum = 0
        (lo..hi).each do |n|
          s = n.to_s
          len = s.length
          next if len.odd? || len == 0
          half = len / 2
          sum += n if s[0, half] == s[half, half]
        end
        sum
      end
    end

    ractors.map(&:take).sum
  end

  # ==========================================================================
  # Strategy 7: Hybrid (Parallel + Multiplier fallback)
  # Uses parallel for ranges that benefit from it, multiplier for huge ranges
  # - Small ranges (< 100K): single-threaded brute force
  # - Medium ranges (100K - 10M): parallel brute force
  # - Large ranges (> 10M): multiplier (mathematical)
  # ==========================================================================
  def hybrid_sum(range)
    case range.size
    when 0...100_000
      brute_force_sum(range)
    when 100_000...10_000_000
      parallel_brute_sum(range)
    else
      multiplier_sum(range)
    end
  end

  # ==========================================================================
  # Parsing
  # ==========================================================================
  def parse_ranges(input)
    input.scan(/(\d+)-(\d+)/).map do |start, finish|
      (start.to_i..finish.to_i)
    end
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day02.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}" if solver.part2
end
