# Advent of Code 2024 - Day 2: Red-Nosed Reports
# https://adventofcode.com/2024/day/2
#
# Analyze reactor safety reports
#
# Ruby idioms demonstrated:
# - each_cons(2): adjacent pair comparison
# - all? / any?: predicate testing across collection
# - Range#cover?: check if value within range
# - one?: exactly one element matches
# - combination for "remove one" variations

class Day02
  def initialize(input)
    @reports = input.lines.map { |line| line.split.map(&:to_i) }
  end

  # Part 1: Count safe reports
  # Safe = all increasing or all decreasing, with differences 1-3
  def part1
    @reports.count { |report| safe?(report) }
  end

  # Part 2: Count safe reports with Problem Dampener
  # Can tolerate removing one level
  def part2
    @reports.count { |report| safe_with_dampener?(report) }
  end

  private

  # Check if report is safe
  #
  # Idiomatic: each_cons(2) + all? for adjacent pair validation
  def safe?(levels)
    diffs = levels.each_cons(2).map { |a, b| b - a }

    # All increasing (1..3) or all decreasing (-3..-1)
    diffs.all? { (1..3).cover?(_1) } || diffs.all? { (-3..-1).cover?(_1) }
  end

  # Alternative: more explicit with named predicates
  def safe_explicit?(levels)
    diffs = levels.each_cons(2).map { _2 - _1 }

    all_increasing = diffs.all? { _1 >= 1 && _1 <= 3 }
    all_decreasing = diffs.all? { _1 >= -3 && _1 <= -1 }

    all_increasing || all_decreasing
  end

  # Check if safe, or safe after removing one level
  #
  # Idiomatic: combination(n-1) generates all "remove one" variants
  def safe_with_dampener?(levels)
    return true if safe?(levels)

    # Try removing each level one at a time
    # combination(levels.size - 1) gives all subsets of size n-1
    levels.combination(levels.size - 1).any? { |subset| safe?(subset) }
  end

  # Alternative: index-based removal (more explicit)
  def safe_with_dampener_explicit?(levels)
    return true if safe?(levels)

    levels.each_index.any? do |i|
      # Create copy without element at index i
      reduced = levels[0...i] + levels[i + 1..]
      safe?(reduced)
    end
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day02.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
