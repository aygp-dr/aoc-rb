# Advent of Code 2025 - Day 1: Secret Entrance
# https://adventofcode.com/2025/day/1
#
# A circular dial (0-99) starts at position 50.
# Rotations: L# (left/subtract) or R# (right/add)
# Dial wraps around (modulo 100)
#
# Part 1: Count how many times the dial lands on 0 after any rotation

class Day01
  DIAL_SIZE = 100
  START_POSITION = 50

  def initialize(input)
    @input = input.strip
    @rotations = parse_rotations
  end

  def parse_rotations
    # Parse rotations like "L68", "R48", etc.
    # Can be separated by newlines, spaces, or commas
    @input.scan(/[LR]\d+/).map do |rotation|
      direction = rotation[0]
      amount = rotation[1..].to_i
      [direction, amount]
    end
  end

  # Part 1: Count times dial lands on 0 after any rotation
  def part1
    position = START_POSITION
    zero_count = 0

    @rotations.each do |direction, amount|
      if direction == 'L'
        position = (position - amount) % DIAL_SIZE
      else # 'R'
        position = (position + amount) % DIAL_SIZE
      end

      zero_count += 1 if position == 0
    end

    zero_count
  end

  # Part 2: TBD - unlocks after Part 1
  def part2
    # Placeholder for Part 2
    nil
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  result2 = solver.part2
  puts "Part 2: #{result2}" if result2
end
