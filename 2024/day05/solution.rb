# Advent of Code 2024 - Day 5: Print Queue
# https://adventofcode.com/2024/day/5
#
# Validate page ordering based on rules
#
# Ruby idioms demonstrated:
# - Hash with Set values for rule lookup
# - partition: split collection by predicate
# - sort with custom comparator (<=>)
# - Topological sort concepts
# - middle element access with array[size/2]

require 'set'

class Day05
  def initialize(input)
    parts = input.split("\n\n")
    @rules = parse_rules(parts[0])
    @updates = parts[1].lines.map { |line| line.strip.split(',').map(&:to_i) }
  end

  # Part 1: Sum middle pages of correctly ordered updates
  def part1
    valid, _ = @updates.partition { |update| valid_order?(update) }
    valid.sum { |update| middle(update) }
  end

  # Part 2: Fix incorrectly ordered updates, sum their middle pages
  def part2
    _, invalid = @updates.partition { |update| valid_order?(update) }
    invalid.map { |update| fix_order(update) }.sum { |update| middle(update) }
  end

  private

  # Parse rules into Hash: page => Set of pages that must come after
  #
  # Idiomatic: each_with_object builds hash incrementally
  def parse_rules(text)
    text.lines.each_with_object(Hash.new { |h, k| h[k] = Set.new }) do |line, rules|
      before, after = line.strip.split('|').map(&:to_i)
      rules[before].add(after)
    end
  end

  # Check if update respects all applicable rules
  #
  # For each pair of pages, verify ordering rule isn't violated
  def valid_order?(update)
    update.each_with_index.all? do |page, i|
      # Pages after this one shouldn't be required to come before
      update[0...i].none? { |prev| @rules[page].include?(prev) }
    end
  end

  # Alternative: using combination
  def valid_order_combination?(update)
    update.combination(2).all? do |before, after|
      !@rules[after].include?(before)
    end
  end

  # Fix ordering by sorting with rule-based comparator
  #
  # Idiomatic: sort with <=> block using rules
  def fix_order(update)
    update.sort do |a, b|
      if @rules[a].include?(b)
        -1  # a must come before b
      elsif @rules[b].include?(a)
        1   # b must come before a
      else
        0   # no rule, maintain relative order
      end
    end
  end

  # Get middle element
  def middle(arr) = arr[arr.size / 2]
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day05.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
