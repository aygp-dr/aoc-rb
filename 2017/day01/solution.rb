# Advent of Code 2017 - Day 1: Inverse Captcha
# https://adventofcode.com/2017/day/1
#
# Find sum of digits that match next digit (circular)
#
# Ruby idioms demonstrated:
# - chars: convert string to array of characters
# - rotate: circular array rotation
# - zip: pair elements from multiple arrays
# - select with block: filter elements
# - map(&:to_i): symbol-to-proc conversion
# - Circular indexing with modulo %

class Day01
  def initialize(input)
    @digits = input.strip.chars.map(&:to_i)
  end

  # Part 1: Sum digits that match the next digit (circular)
  #
  # Approach 1: zip with rotated array
  # rotate(1) shifts elements left by 1, wrapping first to end
  # zip pairs original with rotated, then sum matches
  def part1
    @digits.zip(@digits.rotate(1))
           .select { _1 == _2 }
           .sum(&:first)
  end

  # Alternative: each_cons with special handling for wrap-around
  def part1_each_cons
    # Append first digit to handle circular check
    extended = @digits + [@digits.first]
    extended.each_cons(2).select { _1 == _2 }.sum(&:first)
  end

  # Alternative: index-based with modulo for circular access
  def part1_modulo
    @digits.each_with_index.sum do |digit, i|
      next_digit = @digits[(i + 1) % @digits.length]
      digit == next_digit ? digit : 0
    end
  end

  # Part 2: Sum digits that match digit halfway around
  #
  # zip with rotate(n/2) - elegant use of rotate
  def part2
    half = @digits.length / 2
    @digits.zip(@digits.rotate(half))
           .select { _1 == _2 }
           .sum(&:first)
  end

  # Alternative: modulo indexing
  def part2_modulo
    half = @digits.length / 2
    @digits.each_with_index.sum do |digit, i|
      opposite = @digits[(i + half) % @digits.length]
      digit == opposite ? digit : 0
    end
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
