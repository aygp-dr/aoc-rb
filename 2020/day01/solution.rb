# Advent of Code 2020 - Day 1: Report Repair
# https://adventofcode.com/2020/day/1
#
# Find entries that sum to 2020, return their product
#
# Ruby idioms demonstrated:
# - combination(n): generates all n-element combinations
# - find with block: returns first matching element
# - reduce(:*): multiplies all elements using symbol-to-proc
# - Endless method definitions (Ruby 3.0+): def method = expression
# - Set for O(1) lookups in two-sum pattern

require 'set'

class Day01
  def initialize(input)
    @entries = input.lines.map(&:to_i)
  end

  # Part 1: Find two entries summing to 2020
  #
  # Approach 1: combination(2) - elegant but O(n²)
  # combination(2) generates all 2-element combinations
  def part1
    @entries.combination(2).find { _1 + _2 == 2020 }.reduce(:*)
  end

  # Alternative: Hash-based two-sum - O(n) time
  # Build set of complements, check if current number's complement exists
  def part1_optimized
    seen = Set.new
    @entries.each do |n|
      complement = 2020 - n
      return n * complement if seen.include?(complement)
      seen.add(n)
    end
  end

  # Part 2: Find three entries summing to 2020
  #
  # combination(3) generates all 3-element combinations
  # Then find the one that sums to 2020 and return product
  def part2
    @entries.combination(3).find { _1 + _2 + _3 == 2020 }.reduce(:*)
  end

  # Alternative using destructuring in block
  def part2_explicit
    @entries.combination(3).find { |a, b, c| a + b + c == 2020 }.reduce(:*)
  end
end

# Endless method style (Ruby 3.0+) - for comparison
# These could replace the methods above for a more concise class
class Day01Endless
  def initialize(input) = @entries = input.lines.map(&:to_i)

  def part1 = @entries.combination(2).find { _1 + _2 == 2020 }.reduce(:*)
  def part2 = @entries.combination(3).find { _1 + _2 + _3 == 2020 }.reduce(:*)
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
