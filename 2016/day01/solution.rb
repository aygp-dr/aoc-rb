# Advent of Code 2016 - Day 1: No Time for a Taxicab
# https://adventofcode.com/2016/day/1
#
# Navigate a grid following L/R turn instructions
#
# Ruby idioms demonstrated:
# - Complex numbers for 2D coordinates and rotations
# - scan with regex: extract patterns from string
# - case/when with ranges and patterns
# - Struct for lightweight data objects
# - Set for tracking visited locations
# - throw/catch for early return from nested loops

require 'set'

class Day01
  # Using Complex numbers for elegant 2D math:
  # - Position: Complex(x, y)
  # - Direction: Complex(0,1)=N, Complex(1,0)=E, Complex(0,-1)=S, Complex(-1,0)=W
  # - Turn left: multiply by Complex(0,1) (i)
  # - Turn right: multiply by Complex(0,-1) (-i)

  NORTH = Complex(0, 1)
  TURN_LEFT = Complex(0, 1)   # Multiply by i rotates 90° counter-clockwise
  TURN_RIGHT = Complex(0, -1) # Multiply by -i rotates 90° clockwise

  def initialize(input)
    # Parse "R2, L3" into [['R', 2], ['L', 3]]
    @instructions = input.scan(/([LR])(\d+)/).map { |dir, dist| [dir, dist.to_i] }
  end

  # Part 1: Manhattan distance to final position
  def part1
    pos = Complex(0, 0)
    dir = NORTH

    @instructions.each do |turn, distance|
      dir *= turn == 'L' ? TURN_LEFT : TURN_RIGHT
      pos += dir * distance
    end

    manhattan(pos)
  end

  # Part 2: First location visited twice
  #
  # Track every position along the path, not just after each instruction
  def part2
    pos = Complex(0, 0)
    dir = NORTH
    visited = Set[pos]

    @instructions.each do |turn, distance|
      dir *= turn == 'L' ? TURN_LEFT : TURN_RIGHT

      # Walk step by step to track every position
      distance.times do
        pos += dir
        return manhattan(pos) unless visited.add?(pos)
      end
    end

    nil  # No location visited twice
  end

  # Alternative part2 using catch/throw for early return
  def part2_catch_throw
    pos = Complex(0, 0)
    dir = NORTH
    visited = Set[pos]

    catch(:found) do
      @instructions.each do |turn, distance|
        dir *= turn == 'L' ? TURN_LEFT : TURN_RIGHT
        distance.times do
          pos += dir
          throw(:found, manhattan(pos)) unless visited.add?(pos)
        end
      end
      nil
    end
  end

  private

  def manhattan(pos) = pos.real.abs + pos.imag.abs
end

# Alternative implementation using Struct for position
class Day01Struct
  Position = Struct.new(:x, :y) do
    def +(other) = Position.new(x + other.x, y + other.y)
    def *(scalar) = Position.new(x * scalar, y * scalar)
    def manhattan = x.abs + y.abs
  end

  # Directions as [dx, dy] mapped to indices 0=N, 1=E, 2=S, 3=W
  DIRECTIONS = [Position.new(0, 1), Position.new(1, 0),
                Position.new(0, -1), Position.new(-1, 0)]

  def initialize(input)
    @instructions = input.scan(/([LR])(\d+)/).map { |d, n| [d, n.to_i] }
  end

  def part1
    pos = Position.new(0, 0)
    dir_idx = 0  # Start facing North

    @instructions.each do |turn, distance|
      dir_idx = (dir_idx + (turn == 'R' ? 1 : -1)) % 4
      pos = pos + DIRECTIONS[dir_idx] * distance
    end

    pos.manhattan
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
