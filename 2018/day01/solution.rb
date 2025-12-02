# Advent of Code 2018 - Day 1: Chronal Calibration
# https://adventofcode.com/2018/day/1
#
# Apply frequency changes starting from 0
#
# Ruby idioms demonstrated:
# - sum: built-in method to sum enumerable
# - cycle: infinite iterator over collection
# - lazy: deferred evaluation for infinite sequences
# - detect/find: return first matching element
# - Set for O(1) membership testing
# - scan (from Enumerable extension): running accumulation

require 'set'

class Day01
  def initialize(input)
    # Parse "+1" and "-2" directly - to_i handles the sign
    @changes = input.lines.map(&:to_i)
  end

  # Part 1: Sum all frequency changes
  #
  # Idiomatic: Array#sum is cleaner than reduce(:+)
  def part1 = @changes.sum

  # Part 2: Find first frequency reached twice
  #
  # Uses cycle for infinite repetition, inject for running total,
  # and Set for O(1) duplicate detection
  def part2
    seen = Set[0]  # Set literal syntax - starts with 0
    freq = 0

    @changes.cycle do |change|
      freq += change
      return freq unless seen.add?(freq)  # add? returns nil if already present
    end
  end

  # Alternative: Using lazy enumeration (more functional style)
  # cycle.lazy creates infinite lazy enumerator
  def part2_lazy
    seen = Set[0]
    @changes
      .cycle
      .lazy
      .inject(0) do |freq, change|
        new_freq = freq + change
        throw(:found, new_freq) unless seen.add?(new_freq)
        new_freq
      end
  rescue UncaughtThrowError => e
    e.value
  end

  # Alternative: scan-like approach using inject to build running sums
  # Note: Ruby doesn't have scan built-in, but we can simulate it
  def part2_with_scan
    seen = Set[0]

    # Build running sum sequence, cycling until duplicate found
    catch(:found) do
      @changes.cycle.inject(0) do |acc, change|
        new_acc = acc + change
        throw(:found, new_acc) unless seen.add?(new_acc)
        new_acc
      end
    end
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
