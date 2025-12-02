#!/usr/bin/env ruby
# frozen_string_literal: true

# Debug demonstration for Day 01 solution
# Run: ruby 2025/day01/debug_demo.rb

require_relative '../../lib/aoc_debug'

puts '=' * 60
puts 'Day 01: Dial Rotation - Debug Demo'
puts '=' * 60

# The core algorithm
CODE = <<~'RUBY'
  position = 50
  rotations = ['R29', 'L43', 'R6']
  zero_count = 0

  rotations.each do |rot|
    dir = rot[0]
    amount = rot[1..].to_i
    position += (dir == 'L' ? -amount : amount)
    position %= 100
    zero_count += 1 if position == 0
  end

  [position, zero_count]
RUBY

puts "\n=== Source Code ==="
puts CODE

puts "\n=== YARV Bytecode ==="
AocDebug.disasm(CODE)

puts "\n=== AST Structure ==="
AocDebug.ast('position += (dir == "L" ? -amount : amount)')

puts "\n=== Line-by-Line Execution Trace ==="
AocDebug.trace_lines(CODE)

puts "\n=== Object Allocations ==="
result = AocDebug.allocations { eval(CODE) }
puts "Final state: position=#{result[:result][0]}, zeros=#{result[:result][1]}"
puts "Allocations: #{result[:allocations]}"

puts "\n=== Comparing Solution Approaches ==="
rotations = %w[R29 R6 L43 L6 R28 L42 L34 L32 L13 L15] * 1000

AocDebug.compare(
  iterations: 100,

  'imperative': -> {
    pos = 50
    count = 0
    rotations.each do |rot|
      dir, amt = rot[0], rot[1..].to_i
      pos = (pos + (dir == 'L' ? -amt : amt)) % 100
      count += 1 if pos == 0
    end
    count
  },

  'reduce': -> {
    rotations.reduce([50, 0]) do |(pos, count), rot|
      dir, amt = rot[0], rot[1..].to_i
      new_pos = (pos + (dir == 'L' ? -amt : amt)) % 100
      [new_pos, count + (new_pos == 0 ? 1 : 0)]
    end.last
  },

  'scan+count': -> {
    positions = rotations.reduce([50]) do |acc, rot|
      dir, amt = rot[0], rot[1..].to_i
      acc << (acc.last + (dir == 'L' ? -amt : amt)) % 100
    end
    positions.count(0)
  }
)

puts "\n=== Memory Impact of Different Approaches ==="
small_input = %w[R29 L43 R6]

puts "\nImperative (minimal allocations):"
result = AocDebug.allocations {
  pos = 50
  small_input.each { |r| pos = (pos + (r[0] == 'L' ? -r[1..].to_i : r[1..].to_i)) % 100 }
  pos
}
puts "  #{result[:allocations]}"

puts "\nFunctional with map (more allocations):"
result = AocDebug.allocations {
  deltas = small_input.map { |r| r[0] == 'L' ? -r[1..].to_i : r[1..].to_i }
  (50 + deltas.sum) % 100
}
puts "  #{result[:allocations]}"
