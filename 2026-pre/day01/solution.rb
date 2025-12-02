#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2026 (Pre) - Day 1: Crystal Sorting
#
# Ruby Idioms: Enumerable mastery
# - select/reject for filtering
# - map for transformation
# - sum for aggregation
# - group_by for categorization
# - transform_values for hash manipulation
# - each_with_index for positional iteration
# - Method chaining for readable pipelines

Record = Struct.new(:category, :quantity, :priority, keyword_init: true)

class Day01
  attr_reader :records

  def initialize(input)
    @records = parse(input)
  end

  # Part 1: Sum of quantities for high-priority supplies (priority 1 or 2)
  #
  # Idiomatic Ruby: Chain select + sum
  def part1
    records
      .select { |r| r.priority <= 2 }
      .sum(&:quantity)
  end

  # Part 2: Inventory checksum
  #
  # Steps:
  # 1. Group by category
  # 2. Sum quantities per category
  # 3. Sort alphabetically
  # 4. Multiply each total by position (1-indexed)
  # 5. Sum the products
  #
  # Idiomatic Ruby: Chain group_by + transform_values + sort + each_with_index
  def part2
    records
      .group_by(&:category)
      .transform_values { |rs| rs.sum(&:quantity) }
      .sort
      .each_with_index
      .sum { |(_, qty), idx| qty * (idx + 1) }
  end

  private

  def parse(input)
    input.strip.lines.map do |line|
      cat, qty, pri = line.strip.split(':')
      Record.new(category: cat, quantity: qty.to_i, priority: pri.to_i)
    end
  end
end

# Alternative solutions demonstrating different Enumerable approaches
module AlternativeSolutions
  # Part 1 using reduce (more explicit accumulator)
  def part1_reduce(records)
    records.reduce(0) do |sum, r|
      r.priority <= 2 ? sum + r.quantity : sum
    end
  end

  # Part 1 using filter_map (Ruby 2.7+) - filter and transform in one pass
  def part1_filter_map(records)
    records
      .filter_map { |r| r.quantity if r.priority <= 2 }
      .sum
  end

  # Part 1 using partition (when you need both halves)
  def part1_partition(records)
    high, _low = records.partition { |r| r.priority <= 2 }
    high.sum(&:quantity)
  end

  # Part 2 using each_with_object (build hash explicitly)
  def part2_each_with_object(records)
    totals = records.each_with_object(Hash.new(0)) do |r, acc|
      acc[r.category] += r.quantity
    end

    totals
      .sort
      .map.with_index(1) { |(_, qty), idx| qty * idx }
      .sum
  end

  # Part 2 using tally for counting (when quantities are 1)
  # Not applicable here but good to know:
  # records.map(&:category).tally  # => {"F" => 10, "T" => 8, ...}
end

if __FILE__ == $PROGRAM_NAME
  input_file = ARGV[0] || File.join(__dir__, 'input.txt')
  input = File.read(input_file)

  solver = Day01.new(input)

  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
