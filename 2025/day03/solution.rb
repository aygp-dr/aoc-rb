# Advent of Code 2025 - Day 3: Lobby
# Find max joltage by selecting exactly two batteries per bank

require_relative '../../lib/aoc_utils'

def max_joltage(line)
  digits = line.chars.map(&:to_i)
  max = 0

  # Try all pairs of positions (i, j) where i < j
  (0...digits.length).each do |i|
    (i+1...digits.length).each do |j|
      # Form two-digit number from digits at positions i and j
      joltage = digits[i] * 10 + digits[j]
      max = joltage if joltage > max
    end
  end

  max
end

def solve_part1(input)
  input.lines.map(&:chomp).reject(&:empty?).sum { |line| max_joltage(line) }
end

# Test with example
example = <<~INPUT
987654321111111
811111111111119
234234234234278
8181819111121111
INPUT

puts "Example: #{solve_part1(example)}"
# Expected: 98 + 89 + 78 + 92 = 357

# Solve with actual input if available
if File.exist?('2025/day03/input.txt')
  input = File.read('2025/day03/input.txt')
  puts "Part 1: #{solve_part1(input)}"
end
