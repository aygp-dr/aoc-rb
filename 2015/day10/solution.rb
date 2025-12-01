# Advent of Code 2015 - Day 10: Elves Look, Elves Say
# https://adventofcode.com/2015/day/10
#
# The Look-and-Say sequence: describe runs of digits.
# For each run of identical digits, output the count followed by the digit.
#
# Examples:
#   1 -> 11 (one 1)
#   11 -> 21 (two 1s)
#   21 -> 1211 (one 2, one 1)
#   1211 -> 111221 (one 1, one 2, two 1s)
#   111221 -> 312211 (three 1s, two 2s, one 1)

class Day10
  def initialize(input)
    @input = input.strip
  end

  # Apply look-and-say transformation once
  def look_and_say(sequence)
    result = []
    i = 0

    while i < sequence.length
      digit = sequence[i]
      count = 1

      # Count consecutive identical digits
      while i + count < sequence.length && sequence[i + count] == digit
        count += 1
      end

      result << count.to_s << digit
      i += count
    end

    result.join
  end

  # Apply look-and-say transformation n times
  def iterate(n)
    sequence = @input
    n.times { sequence = look_and_say(sequence) }
    sequence
  end

  # Part 1: Apply 40 iterations and return length
  def part1
    iterate(40).length
  end

  # Part 2: Apply 50 iterations and return length
  def part2
    iterate(50).length
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day10.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
