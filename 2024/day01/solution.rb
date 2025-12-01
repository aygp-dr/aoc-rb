# Advent of Code 2024 - Day 1: Historian Hysteria
# https://adventofcode.com/2024/day/1
#
# Two lists of location IDs need to be reconciled.
# Part 1: Calculate total distance between paired numbers (sorted)
# Part 2: Calculate similarity score based on frequency matching

class Day01
  def initialize(input)
    @input = input.strip
    parse_lists
  end

  def parse_lists
    @left = []
    @right = []

    @input.each_line do |line|
      nums = line.split.map(&:to_i)
      @left << nums[0]
      @right << nums[1]
    end
  end

  # Part 1: Sort both lists and sum absolute differences of paired elements
  def part1
    left_sorted = @left.sort
    right_sorted = @right.sort

    left_sorted.zip(right_sorted).sum { |l, r| (l - r).abs }
  end

  # Part 2: Similarity score - for each left number, multiply by its
  # frequency in the right list, then sum all products
  def part2
    right_counts = @right.tally

    @left.sum { |num| num * right_counts.fetch(num, 0) }
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
