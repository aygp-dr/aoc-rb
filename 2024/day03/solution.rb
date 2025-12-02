# Advent of Code 2024 - Day 3: Mull It Over
# https://adventofcode.com/2024/day/3
#
# Parse and execute mul instructions from corrupted memory
#
# Ruby idioms demonstrated:
# - scan with regex captures: extract all matches
# - Named capture groups: (?<name>pattern)
# - gsub for preprocessing
# - inject/reduce for accumulation with state
# - Regex alternation for multiple patterns

class Day03
  # Match valid mul(X,Y) where X,Y are 1-3 digit numbers
  MUL_PATTERN = /mul\((\d{1,3}),(\d{1,3})\)/

  # Part 2: Also match do() and don't()
  INSTRUCTION_PATTERN = /mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/

  def initialize(input)
    @memory = input
  end

  # Part 1: Sum all valid mul(X,Y) results
  #
  # Idiomatic: scan returns all matches with capture groups
  def part1
    @memory.scan(MUL_PATTERN).sum { |a, b| a.to_i * b.to_i }
  end

  # Alternative: Using named captures for clarity
  def part1_named
    pattern = /mul\((?<x>\d{1,3}),(?<y>\d{1,3})\)/
    @memory.scan(pattern).sum { |x, y| x.to_i * y.to_i }
  end

  # Part 2: Handle do()/don't() enable/disable instructions
  #
  # Idiomatic: scan + inject with state tracking
  def part2
    enabled = true
    total = 0

    @memory.scan(INSTRUCTION_PATTERN) do |match|
      instruction = Regexp.last_match[0]

      case instruction
      when "do()"
        enabled = true
      when "don't()"
        enabled = false
      else
        # It's a mul instruction
        total += match[0].to_i * match[1].to_i if enabled
      end
    end

    total
  end

  # Alternative: Using inject with state tuple
  def part2_functional
    @memory.scan(INSTRUCTION_PATTERN).inject([true, 0]) do |(enabled, sum), match|
      full_match = Regexp.last_match[0]

      case full_match
      when "do()"
        [true, sum]
      when "don't()"
        [false, sum]
      else
        product = enabled ? match[0].to_i * match[1].to_i : 0
        [enabled, sum + product]
      end
    end.last
  end

  # Alternative: Preprocess by removing disabled sections
  def part2_preprocess
    # Remove everything between don't() and do() (or end)
    cleaned = @memory.gsub(/don't\(\).*?(?:do\(\)|$)/m, '')
    cleaned.scan(MUL_PATTERN).sum { |a, b| a.to_i * b.to_i }
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day03.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
