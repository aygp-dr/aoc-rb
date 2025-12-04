# Advent of Code 2025 - Day 3: Lobby
# Find max joltage by selecting exactly two batteries per bank

require_relative '../../lib/aoc_utils'

def max_joltage(line)
  digits = line.chars.map(&:to_i)
  max = 0

  # Try all pairs of positions (i, j) where i < j
  (0...digits.length).each do |i|
    (i+1...digits.length).each do |j|
      # Form two-digit number from digits at positions i and j
      joltage = digits[i] * 10 + digits[j]
      max = joltage if joltage > max
    end
  end

  max
end

def solve_part1(input)
  input.lines.map(&:chomp).reject(&:empty?).sum { |line| max_joltage(line) }
end

# ==========================================================================
# Tests
# ==========================================================================
if __FILE__ == $0
  require_relative '../../lib/aoc_test'
  include AocAssert

  EXAMPLE = <<~INPUT
    987654321111111
    811111111111119
    234234234234278
    8181819111121111
  INPUT

  # Individual line tests
  puts "Testing max_joltage per line:"
  run_tests([
    [98, max_joltage("987654321111111"), "first two digits"],
    [89, max_joltage("811111111111119"), "first and last"],
    [78, max_joltage("234234234234278"), "last two"],
    [92, max_joltage("8181819111121111"), "positions 7 and 12"],
  ])

  # Full example
  puts "\nTesting solve_part1:"
  assert_eq 357, solve_part1(EXAMPLE), "Example sum"

  # Edge cases
  puts "\nEdge cases:"
  assert_eq 99, max_joltage("99"), "two nines"
  assert_eq 19, max_joltage("19"), "1 then 9 = 19 (can't rearrange)"
  assert_eq 91, max_joltage("91"), "9 then 1 = 91"
  assert_eq 11, max_joltage("11"), "minimum possible"

  # Solve with actual input if available
  if File.exist?(File.join(__dir__, 'input.txt'))
    input = File.read(File.join(__dir__, 'input.txt'))
    puts "\nPart 1: #{solve_part1(input)}"
  end
end
