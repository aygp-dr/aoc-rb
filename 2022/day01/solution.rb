# Advent of Code 2022 - Day 1: Calorie Counting
# https://adventofcode.com/2022/day/1
#
# Elves are carrying food items with calorie counts.
# Each Elf's inventory is separated by blank lines.
# Find the Elf carrying the most Calories.

class Day01
  def initialize(input)
    @input = input.strip
  end

  # Parse input into groups of calories per elf
  def parse_elves
    @input.split("\n\n").map do |elf_section|
      elf_section.lines.map { |line| line.strip.to_i }
    end
  end

  # Calculate total calories for each elf
  def elf_totals
    parse_elves.map(&:sum)
  end

  # Part 1: Find the Elf carrying the most Calories
  def part1
    elf_totals.max
  end

  # Part 2: Find the top three Elves carrying the most Calories
  # Return the sum of their total Calories
  def part2
    elf_totals.sort.reverse.take(3).sum
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
