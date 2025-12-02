# Advent of Code 2020 - Day 6: Custom Customs
# https://adventofcode.com/2020/day/6
#
# Count unique/common yes answers in groups
#
# Ruby idioms demonstrated:
# - Set operations: union (|), intersection (&)
# - split with regex for paragraph parsing
# - chars.to_set: convert string to set of characters
# - reduce with set operations
# - inject(:&) for intersection across array
# - String#each_char vs chars

require 'set'

class Day06
  def initialize(input)
    # Split on blank lines to get groups
    @groups = input.split(/\n\n/).map do |group|
      # Each person's answers as an array of Sets
      group.lines.map { |line| line.strip.chars.to_set }
    end
  end

  # Part 1: Count questions where ANYONE in group answered yes (union)
  #
  # reduce(:|) merges all sets with union operator
  # Sum the sizes of all group unions
  def part1
    @groups.sum { |people| people.reduce(:|).size }
  end

  # Alternative: Using inject with Set.new
  def part1_inject
    @groups.sum do |people|
      people.inject(Set.new) { |acc, person| acc | person }.size
    end
  end

  # Part 2: Count questions where EVERYONE in group answered yes (intersection)
  #
  # reduce(:&) intersects all sets
  # Need to start with first person's answers as initial set
  def part2
    @groups.sum { |people| people.reduce(:&).size }
  end

  # Alternative: explicit intersection
  def part2_explicit
    @groups.sum do |people|
      common = people.first.dup
      people[1..].each { |person| common &= person }
      common.size
    end
  end
end

# Alternative implementation using strings directly (no Set)
class Day06String
  def initialize(input)
    @groups = input.split(/\n\n/)
  end

  # Part 1: Count unique chars across all lines in group
  def part1
    @groups.sum do |group|
      # Join all lines, remove newlines, get unique chars
      group.gsub(/\s/, '').chars.uniq.size
    end
  end

  # Part 2: Count chars appearing in every line
  def part2
    @groups.sum do |group|
      lines = group.lines.map(&:strip)
      # Start with chars from first line, keep only those in all lines
      lines.first.chars.count { |c| lines.all? { |line| line.include?(c) } }
    end
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day06.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
