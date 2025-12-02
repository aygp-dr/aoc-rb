# Advent of Code 2019 - Day 3: Crossed Wires
# https://adventofcode.com/2019/day/3
#
# Find intersections of two wire paths on a grid
#
# Ruby idioms demonstrated:
# - Set intersection (&) for finding common points
# - Complex numbers for 2D coordinates
# - Hash for storing step counts per position
# - split and map for parsing
# - min_by for finding minimum by criterion
# - compact for removing nils

require 'set'

class Day03
  DIRECTIONS = {
    'U' => Complex(0, 1),
    'D' => Complex(0, -1),
    'L' => Complex(-1, 0),
    'R' => Complex(1, 0)
  }.freeze

  def initialize(input)
    lines = input.lines.map(&:strip)
    @wire1 = parse_wire(lines[0])
    @wire2 = parse_wire(lines[1])
  end

  # Part 1: Manhattan distance to closest intersection
  def part1
    intersections = @wire1[:positions] & @wire2[:positions]
    intersections.map { |pos| manhattan(pos) }.min
  end

  # Part 2: Minimum combined steps to reach an intersection
  #
  # For each intersection, sum the steps each wire took to reach it
  def part2
    intersections = @wire1[:positions] & @wire2[:positions]
    intersections.map do |pos|
      @wire1[:steps][pos] + @wire2[:steps][pos]
    end.min
  end

  private

  # Parse wire path, tracking all positions and step counts
  #
  # Returns { positions: Set of all visited points, steps: Hash of first visit step }
  def parse_wire(path)
    positions = Set.new
    steps = {}
    pos = Complex(0, 0)
    step = 0

    path.split(',').each do |instruction|
      dir = DIRECTIONS[instruction[0]]
      distance = instruction[1..].to_i

      distance.times do
        pos += dir
        step += 1
        positions.add(pos)
        # Only record first visit (for part 2)
        steps[pos] ||= step
      end
    end

    { positions: positions, steps: steps }
  end

  def manhattan(pos) = pos.real.abs + pos.imag.abs
end

# Alternative: Using arrays instead of Complex (more traditional)
class Day03Array
  DIRECTIONS = {
    'U' => [0, 1], 'D' => [0, -1],
    'L' => [-1, 0], 'R' => [1, 0]
  }.freeze

  def initialize(input)
    lines = input.lines.map(&:strip)
    @wire1 = trace_wire(lines[0])
    @wire2 = trace_wire(lines[1])
  end

  def part1
    (@wire1.keys.to_set & @wire2.keys.to_set)
      .map { |x, y| x.abs + y.abs }
      .min
  end

  def part2
    (@wire1.keys.to_set & @wire2.keys.to_set)
      .map { |pos| @wire1[pos] + @wire2[pos] }
      .min
  end

  private

  # Returns Hash mapping [x,y] => first_step_count
  def trace_wire(path)
    visited = {}
    x, y = 0, 0
    step = 0

    path.split(',').each do |instruction|
      dx, dy = DIRECTIONS[instruction[0]]
      distance = instruction[1..].to_i

      distance.times do
        x += dx
        y += dy
        step += 1
        visited[[x, y]] ||= step
      end
    end

    visited
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day03.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
