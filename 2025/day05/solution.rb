# Advent of Code 2025 - Day 5: Cafeteria
# Check which ingredient IDs fall within fresh ranges
#
# Ruby idioms demonstrated:
# - Range#cover? for membership testing
# - split("\n\n") for group parsing
# - any? with block for checking multiple conditions
# - Parsing ranges from "start-end" format

def parse_input(input)
  ranges_section, ids_section = input.strip.split("\n\n")

  # Parse "3-5" into (3..5)
  ranges = ranges_section.lines.map do |line|
    start, finish = line.scan(/\d+/).map(&:to_i)
    (start..finish)
  end

  ids = ids_section.lines.map { |line| line.to_i }

  [ranges, ids]
end

def fresh?(id, ranges)
  # Ruby idiom: any? with Range#cover?
  ranges.any? { |range| range.cover?(id) }
end

def solve_part1(input)
  ranges, ids = parse_input(input)
  ids.count { |id| fresh?(id, ranges) }
end

# ==========================================================================
# Tests
# ==========================================================================
if __FILE__ == $0
  require_relative '../../lib/aoc_test'
  include AocAssert

  EXAMPLE = <<~INPUT
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
  INPUT

  puts "Testing parse_input:"
  ranges, ids = parse_input(EXAMPLE)
  assert_eq 4, ranges.length, "4 ranges parsed"
  assert_eq (3..5), ranges[0], "first range is 3..5"
  assert_eq 6, ids.length, "6 IDs parsed"

  puts "\nTesting fresh?:"
  assert_eq false, fresh?(1, ranges), "ID 1 is spoiled"
  assert_eq true, fresh?(5, ranges), "ID 5 is fresh (in 3-5)"
  assert_eq false, fresh?(8, ranges), "ID 8 is spoiled"
  assert_eq true, fresh?(11, ranges), "ID 11 is fresh (in 10-14)"
  assert_eq true, fresh?(17, ranges), "ID 17 is fresh (in 16-20 and 12-18)"
  assert_eq false, fresh?(32, ranges), "ID 32 is spoiled"

  puts "\nTesting solve_part1:"
  assert_eq 3, solve_part1(EXAMPLE), "Example: 3 fresh ingredients"

  # Edge cases
  puts "\nEdge cases:"
  assert_eq true, fresh?(3, [(3..5)]), "boundary: start of range"
  assert_eq true, fresh?(5, [(3..5)]), "boundary: end of range"
  assert_eq false, fresh?(2, [(3..5)]), "boundary: just before range"
  assert_eq false, fresh?(6, [(3..5)]), "boundary: just after range"

  # Solve with actual input if available
  if File.exist?(File.join(__dir__, 'input.txt'))
    input = File.read(File.join(__dir__, 'input.txt'))
    puts "\nPart 1: #{solve_part1(input)}"
  end
end
