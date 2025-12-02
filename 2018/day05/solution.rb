# Advent of Code 2018 - Day 5: Alchemical Reduction
# https://adventofcode.com/2018/day/5
#
# React polymer units that are same letter with opposite case
#
# Ruby idioms demonstrated:
# - String#chars with each_with_object for stack-based processing
# - Character case checking with upcase/downcase or ASCII math
# - Range ('a'..'z') for iterating letters
# - delete for removing characters
# - min_by for finding best result

class Day05
  def initialize(input)
    @polymer = input.strip
  end

  # Part 1: Fully react polymer, return remaining length
  #
  # Idiomatic: Stack-based reduction using each_with_object
  def part1
    react(@polymer).length
  end

  # Part 2: Remove one unit type, find shortest result
  #
  # Idiomatic: Range of letters, min_by for optimization
  def part2
    ('a'..'z').map do |char|
      cleaned = @polymer.delete(char).delete(char.upcase)
      react(cleaned).length
    end.min
  end

  private

  # React polymer using stack - O(n) time
  #
  # Two units react if same letter but different case (aA, Bb, etc.)
  # Idiomatic: each_with_object builds result, checking last char
  def react(polymer)
    polymer.chars.each_with_object([]) do |char, stack|
      if stack.last && reacts?(stack.last, char)
        stack.pop
      else
        stack << char
      end
    end.join
  end

  # Check if two characters react (same letter, opposite case)
  #
  # Idiomatic: XOR with 32 flips case bit in ASCII
  # 'a'.ord ^ 32 == 'A'.ord and vice versa
  def reacts?(a, b)
    (a.ord ^ b.ord) == 32
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day05.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
