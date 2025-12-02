# Advent of Code 2023 - Day 2: Cube Conundrum
# https://adventofcode.com/2023/day/2
#
# Analyze cube game reveals
#
# Ruby idioms demonstrated:
# - scan with named captures
# - Hash#transform_values
# - Hash#merge with block for combining
# - max for finding maximum across reveals
# - values.reduce(:*) for product

class Day02
  LIMITS = { 'red' => 12, 'green' => 13, 'blue' => 14 }.freeze

  def initialize(input)
    @games = input.lines.map { |line| parse_game(line) }
  end

  # Part 1: Sum IDs of possible games
  def part1
    @games.sum do |game|
      possible?(game[:reveals]) ? game[:id] : 0
    end
  end

  # Part 2: Sum power of minimum cube sets
  def part2
    @games.sum { |game| power(minimum_cubes(game[:reveals])) }
  end

  private

  # Parse "Game 1: 3 blue, 4 red; 1 red, 2 green"
  #
  # Idiomatic: Use scan to extract all color/count pairs
  def parse_game(line)
    id = line[/Game (\d+)/, 1].to_i

    reveals = line.split(': ').last.split('; ').map do |reveal|
      reveal.scan(/(\d+) (\w+)/).to_h { |count, color| [color, count.to_i] }
    end

    { id: id, reveals: reveals }
  end

  # Check if all reveals are within limits
  def possible?(reveals)
    reveals.all? do |reveal|
      reveal.all? { |color, count| count <= LIMITS.fetch(color, 0) }
    end
  end

  # Find minimum cubes needed for each color
  #
  # Idiomatic: merge with block takes max of each color
  def minimum_cubes(reveals)
    reveals.reduce({}) do |mins, reveal|
      mins.merge(reveal) { |_key, old, new| [old, new].max }
    end
  end

  # Calculate power (product of all values)
  def power(cubes)
    cubes.values.reduce(1, :*)
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day02.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
