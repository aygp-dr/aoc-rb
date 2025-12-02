# Advent of Code 2018 - Day 2: Inventory Management System
# https://adventofcode.com/2018/day/2
#
# Checksum from letter frequencies, find similar box IDs
#
# Ruby idioms demonstrated:
# - tally for character frequency
# - values.include? for checking frequencies
# - combination(2) for all pairs
# - zip for character-by-character comparison
# - count with block

class Day02
  def initialize(input)
    @ids = input.lines.map(&:strip)
  end

  # Part 1: Count IDs with exactly 2 of any letter * count with exactly 3
  #
  # Idiomatic: tally.values.include? to check for frequency
  def part1
    twos = @ids.count { |id| id.chars.tally.values.include?(2) }
    threes = @ids.count { |id| id.chars.tally.values.include?(3) }
    twos * threes
  end

  # Part 2: Find two IDs differing by exactly one character
  # Return the common letters
  #
  # Idiomatic: combination(2) + zip for character comparison
  def part2
    @ids.combination(2).each do |id1, id2|
      common = common_chars(id1, id2)
      return common if common.length == id1.length - 1
    end
    nil
  end

  private

  # Get characters that match at same position
  #
  # Idiomatic: zip pairs corresponding chars, select matches
  def common_chars(s1, s2)
    s1.chars.zip(s2.chars)
      .select { |c1, c2| c1 == c2 }
      .map(&:first)
      .join
  end

  # Alternative: count differences
  def diff_count(s1, s2)
    s1.chars.zip(s2.chars).count { |c1, c2| c1 != c2 }
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day02.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
