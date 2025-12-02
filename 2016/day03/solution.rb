# Advent of Code 2016 - Day 3: Squares With Three Sides
# https://adventofcode.com/2016/day/3
#
# Validate triangles by side lengths
#
# Ruby idioms demonstrated:
# - sort for ordering sides
# - scan for number extraction
# - transpose for column-wise reading
# - each_slice for grouping
# - count with block predicate

class Day03
  def initialize(input)
    @lines = input.lines.map { |line| line.scan(/\d+/).map(&:to_i) }
  end

  # Part 1: Count valid triangles (read horizontally)
  def part1
    @lines.count { |sides| valid_triangle?(sides) }
  end

  # Part 2: Read triangles vertically (columns, then groups of 3)
  #
  # Idiomatic: transpose + flatten + each_slice
  def part2
    # Transpose to read columns, flatten, then group by 3
    @lines.transpose.flatten.each_slice(3).count { |sides| valid_triangle?(sides) }
  end

  private

  # A valid triangle has sum of any two sides > third side
  # Shortcut: just check if two smallest > largest
  #
  # Idiomatic: sort then check first two vs last
  def valid_triangle?(sides)
    a, b, c = sides.sort
    a + b > c
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day03.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
