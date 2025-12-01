# Advent of Code 2015 - Day 1: Not Quite Lisp
# https://adventofcode.com/2015/day/1
#
# Santa is trying to deliver presents in a large apartment building.
# Instructions:
#   ( = go up one floor
#   ) = go down one floor
# Santa starts on floor 0 (ground floor).

class Day01
  def initialize(input)
    @input = input.strip
  end

  # Part 1: What floor do the instructions take Santa?
  def part1
    @input.chars.sum { |c| c == '(' ? 1 : -1 }
  end

  # Part 2: Find the position of the first character that causes
  # Santa to enter the basement (floor -1).
  def part2
    floor = 0
    @input.chars.each_with_index do |c, i|
      floor += (c == '(' ? 1 : -1)
      return i + 1 if floor == -1
    end
    nil
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
