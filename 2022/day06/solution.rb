# Advent of Code 2022 - Day 6: Tuning Trouble
# https://adventofcode.com/2022/day/6
#
# Find first position where N consecutive characters are all unique
#
# Ruby idioms demonstrated:
# - each_cons(n): sliding window of n elements
# - uniq: remove duplicates
# - find_index: find position of first match
# - chars: string to array of characters
# - with_index: add index to enumeration
# - Set for O(1) uniqueness check

require 'set'

class Day06
  def initialize(input)
    @signal = input.strip
  end

  # Part 1: Find first position where 4 consecutive chars are unique
  # (start-of-packet marker)
  #
  # each_cons(4) creates sliding windows of 4 chars
  # find_index finds first window where all chars unique
  # Add 4 because we want position AFTER the marker
  def part1
    find_marker(4)
  end

  # Part 2: Find position of 14 unique consecutive chars
  # (start-of-message marker)
  def part2
    find_marker(14)
  end

  # Generic marker finder using each_cons
  #
  # Idiomatic: each_cons + with_index + find for elegant iteration
  def find_marker(size)
    @signal.chars.each_cons(size).with_index do |window, i|
      return i + size if window.uniq.size == size
    end
  end

  # Alternative: Using Set for uniqueness check (O(n) vs O(n²))
  def find_marker_set(size)
    @signal.chars.each_cons(size).with_index do |window, i|
      return i + size if window.to_set.size == size
    end
  end

  # Alternative: Using find_index (more functional style)
  def find_marker_functional(size)
    index = @signal.chars.each_cons(size).find_index { |w| w.uniq == w }
    index + size
  end

  # Alternative: Index-based sliding window (traditional approach)
  def find_marker_traditional(size)
    (0..@signal.length - size).each do |i|
      window = @signal[i, size]
      return i + size if window.chars.uniq.size == size
    end
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day06.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
