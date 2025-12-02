# Advent of Code 2023 - Day 1: Trebuchet?!
# https://adventofcode.com/2023/day/1
#
# Extract calibration values from text by finding first and last digits
#
# Ruby idioms demonstrated:
# - Regular expressions with scan, match, []
# - String#[] with regex for extraction
# - gsub with hash for replacements
# - Lookahead assertions in regex
# - freeze for immutable constants
# - then (yield_self) for method chaining

class Day01
  WORD_TO_DIGIT = {
    'one' => '1', 'two' => '2', 'three' => '3',
    'four' => '4', 'five' => '5', 'six' => '6',
    'seven' => '7', 'eight' => '8', 'nine' => '9'
  }.freeze

  # Build regex pattern for digit words (used in part2)
  DIGIT_WORDS = WORD_TO_DIGIT.keys.join('|').freeze
  DIGIT_PATTERN = /\d|#{DIGIT_WORDS}/.freeze

  def initialize(input)
    @lines = input.lines.map(&:chomp)
  end

  # Part 1: Find first and last numeric digit in each line
  #
  # String#[] with regex extracts first match
  # String#reverse + pattern reversal finds last
  def part1
    @lines.sum do |line|
      first = line[/\d/]
      last = line.reverse[/\d/]
      (first + last).to_i
    end
  end

  # Alternative using scan
  def part1_scan
    @lines.sum do |line|
      digits = line.scan(/\d/)
      (digits.first + digits.last).to_i
    end
  end

  # Part 2: Digits can be spelled out
  #
  # Tricky: "oneight" should find both "one" and "eight"
  # Use positive lookahead to avoid consuming characters
  def part2
    @lines.sum do |line|
      # Lookahead (?=...) matches without consuming
      # This allows overlapping matches like "oneight" -> ["one", "eight"]
      matches = line.scan(/(?=(\d|#{DIGIT_WORDS}))/).flatten
      first = to_digit(matches.first)
      last = to_digit(matches.last)
      (first + last).to_i
    end
  end

  # Alternative: find first/last separately with different patterns
  def part2_separate
    @lines.sum do |line|
      # Find first digit or word
      first_match = line.match(/\d|#{DIGIT_WORDS}/)
      first = to_digit(first_match[0])

      # Find last: reverse string, use reversed pattern
      # "eight" reversed is "thgie"
      reversed_words = WORD_TO_DIGIT.keys.map(&:reverse).join('|')
      last_match = line.reverse.match(/\d|#{reversed_words}/)
      last = to_digit(last_match[0].reverse)

      (first + last).to_i
    end
  end

  private

  def to_digit(str) = WORD_TO_DIGIT.fetch(str, str)
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
