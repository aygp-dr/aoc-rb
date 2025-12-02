# Advent of Code 2016 - Day 6: Signals and Noise
# https://adventofcode.com/2016/day/6
#
# Decode message using character frequency per column
#
# Ruby idioms demonstrated:
# - transpose for column-wise processing
# - tally for character frequency
# - max_by / min_by for finding extremes
# - map + join for string building

class Day06
  def initialize(input)
    @lines = input.lines.map { |line| line.strip.chars }
  end

  # Part 1: Most common character per column
  #
  # Idiomatic: transpose + map with max_by + join
  def part1
    @lines.transpose.map { |col| most_common(col) }.join
  end

  # Part 2: Least common character per column
  def part2
    @lines.transpose.map { |col| least_common(col) }.join
  end

  private

  # Find most common character in array
  #
  # Idiomatic: tally + max_by on count
  def most_common(chars)
    chars.tally.max_by { |_char, count| count }.first
  end

  # Find least common character
  def least_common(chars)
    chars.tally.min_by { |_char, count| count }.first
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day06.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
