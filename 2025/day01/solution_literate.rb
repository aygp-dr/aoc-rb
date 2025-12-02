#!/usr/bin/env ruby
# Advent of Code 2025 - Day 01: Secret Entrance
# Tangled from solution.org

DIAL_SIZE = 100
START_POSITION = 50

def solve(input)
  position = START_POSITION
  zero_count = 0

  input.each_line do |line|
    line = line.strip
    next if line.empty?

    direction = line[0]
    amount = line[1..].to_i

    position += (direction == 'L' ? -amount : amount)
    position %= DIAL_SIZE

    zero_count += 1 if position == 0
  end

  zero_count
end

if __FILE__ == $0
  input_file = ARGV[0] || 'input.txt'
  input = File.read(input_file)
  puts "Part 1: #{solve(input)}"
end
