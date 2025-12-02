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
  STRATEGIES = %i[brute_force string_check multiplier].freeze

  def initialize(input, strategy: :multiplier)
    @ranges = parse_ranges(input)
    @strategy = strategy
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
