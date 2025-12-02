# Advent of Code 2023 - Day 4: Scratchcards
# https://adventofcode.com/2023/day/4
#
# Calculate scratchcard points and copies
#
# Ruby idioms demonstrated:
# - Set intersection with &
# - Exponential with ** or bit shift <<
# - Array.new(n, value) for initialization
# - each_with_index for card processing
# - split with regex for flexible parsing

require 'set'

class Day04
  def initialize(input)
    @cards = input.lines.map { |line| parse_card(line) }
  end

  # Part 1: Sum points (1 for first match, doubled for each additional)
  #
  # Idiomatic: Bit shift for powers of 2
  def part1
    @cards.sum do |card|
      matches = count_matches(card)
      matches > 0 ? 1 << (matches - 1) : 0
    end
  end

  # Alternative: Using exponentiation
  def part1_exp
    @cards.sum do |card|
      matches = count_matches(card)
      matches > 0 ? 2**(matches - 1) : 0
    end
  end

  # Part 2: Count total cards after winning copies
  def part2
    # copies[i] = number of copies of card i
    copies = Array.new(@cards.length, 1)

    @cards.each_with_index do |card, i|
      matches = count_matches(card)
      # Win copies of next `matches` cards
      (1..matches).each do |offset|
        next_idx = i + offset
        copies[next_idx] += copies[i] if next_idx < @cards.length
      end
    end

    copies.sum
  end

  private

  # Parse "Card 1: 41 48 | 83 86"
  def parse_card(line)
    _, numbers = line.split(': ')
    winning, have = numbers.split(' | ')

    {
      winning: winning.split.map(&:to_i).to_set,
      have: have.split.map(&:to_i).to_set
    }
  end

  # Count matching numbers using set intersection
  def count_matches(card)
    (card[:winning] & card[:have]).size
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day04.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
