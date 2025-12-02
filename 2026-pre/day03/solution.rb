#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2026 (Pre) - Day 3: Pattern Vault
#
# Ruby Idioms: Pattern Matching (Ruby 2.7+, improved in 3.0+)
# - case/in expressions
# - Hash patterns with value capture
# - Array patterns with splat
# - Nested patterns
# - Guard clauses with if
# - Alternative patterns with |

class Day03
  def initialize(input)
    @entries = parse(input)
  end

  # Part 1: Extract values based on type patterns
  #
  # Uses basic pattern matching on hash structure
  def part1
    @entries.sum do |data|
      case data
      in {type: "gem", value:}
        value
      in {type: "ore", weight:}
        weight * 2
      in {type: "tool", durability:}
        durability
      in [*elements]
        elements.sum
      else
        0
      end
    end
  end

  # Part 2: Nested patterns with guards
  #
  # Deep gems (depth > 100): value × 3
  # Shallow gems: value × 1
  # Surface gems (no origin): value × 0.5
  # Batches: sum of item values
  def part2
    @entries.sum do |data|
      case data
      in {type: "gem", value:, origin: {depth:}} if depth > 100
        value * 3
      in {type: "gem", value:, origin: {depth:}}
        value
      in {type: "gem", value:, origin: nil}
        (value * 0.5).to_i
      in {type: "batch", items:}
        items.sum { |item| item[:value] || 0 }
      in {type: "ore", weight:}
        weight * 2
      in {type: "tool", durability:}
        durability
      in [*elements]
        elements.sum
      else
        0
      end
    end
  end

  private

  # Parse Ruby hash/array literals from input
  # WARNING: eval is used here for puzzle convenience - never in production!
  def parse(input)
    input.strip.lines.map do |line|
      line = line.strip
      next nil if line.empty?

      # Convert symbol keys to proper Ruby syntax and evaluate
      # This is safe for our controlled puzzle input
      eval(line) # rubocop:disable Security/Eval
    end.compact
  end
end

# Pattern Matching Examples (commented out to avoid syntax issues)
#
# These examples demonstrate various pattern matching features.
# They're documented here but not executed as some require specific Ruby versions.
#
# == Using => for single-pattern extraction (Ruby 3.0+) ==
#   data = {name: "Ruby", version: 3.3}
#   data => {name:, version:}
#   puts "#{name} #{version}"  # => "Ruby 3.3"
#
# == Using in as boolean check (Ruby 3.0+) ==
#   data = {type: "gem", value: 100}
#   if data in {type: "gem", value:}
#     puts "Found gem worth #{value}"
#   end
#
# == Alternative patterns with | ==
#   case status
#   in :success | :complete | :done then "Finished"
#   in :pending | :waiting then "In progress"
#   in :error | :failed then "Problem"
#   end
#
# == Pin operator ^ to match existing variable ==
#   expected_type = "gem"
#   case data
#   in {type: ^expected_type, value:}
#     puts "Found gem worth #{value}"
#   end
#
# == Array patterns with head/tail ==
#   case [1, 2, 3, 4, 5]
#   in [] then "empty"
#   in [single] then "one element"
#   in [first, *middle, last] then "first: #{first}, last: #{last}"
#   end
#
# == Find pattern (Ruby 3.0+) ==
#   case [1, 2, {special: true, value: 42}, 4, 5]
#   in [*, {special: true, value:}, *]
#     puts "Found special value: #{value}"
#   end
#
# == Pattern matching with Structs ==
#   Point = Struct.new(:x, :y)
#   case Point.new(3, 4)
#   in Point[x:, y:] if x == y then "On diagonal"
#   in Point[x: 0, y:] then "On Y axis"
#   in Point[x:, y:] then "At (#{x}, #{y})"
#   end

if __FILE__ == $PROGRAM_NAME
  input_file = ARGV[0] || File.join(__dir__, 'input.txt')
  input = File.read(input_file)

  solver = Day03.new(input)

  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
