# Advent of Code 2025 - Day 2: Gift Shop
# https://adventofcode.com/2025/day/2
#
# Find invalid product IDs (digit sequence repeated exactly twice)
#
# Ruby idioms demonstrated:
# - scan for parsing with regex
# - Range for iteration
# - String slicing for pattern detection
# - select + sum for filtering and aggregating
# - divmod for splitting numbers

class Day02
  def initialize(input)
    @ranges = parse_ranges(input)
  end

  # Part 1: Sum of all invalid IDs in ranges
  #
  # Invalid = digit sequence repeated exactly twice (11, 6464, 123123)
  def part1
    @ranges.sum do |range|
      range.select { |id| invalid_id?(id) }.sum
    end
  end

  # Part 2: Placeholder (puzzle may have part 2)
  def part2
    nil
  end

  private

  # Parse comma-separated ranges like "11-22,95-115"
  #
  # Idiomatic: scan with regex, map to Range objects
  def parse_ranges(input)
    input.scan(/(\d+)-(\d+)/).map do |start, finish|
      (start.to_i..finish.to_i)
    end
  end

  # Check if ID is invalid (repeated pattern)
  #
  # A number like 6464 or 123123 is invalid
  # Must be even length and first half == second half
  def invalid_id?(n)
    s = n.to_s
    len = s.length
    return false if len.odd? || len == 0

    half = len / 2
    s[0, half] == s[half, half]
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day02.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}" if solver.part2
end
