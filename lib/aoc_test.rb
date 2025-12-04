# frozen_string_literal: true

# Lightweight Testing for Advent of Code
# No external gems required - pure Ruby assertions
#
# Usage in solution files:
#   require_relative '../../lib/aoc_test'
#   include AocAssert
#
#   assert_eq 357, solve_part1(EXAMPLE), "Example"
#
# Or use table-driven tests:
#   run_table([
#     { input: "11", expected: true, name: "repeat" },
#   ]) { |input| is_repeat?(input) }

# Simple inline testing - no gems needed
module AocAssert
  module_function

  def assert_eq(expected, actual, label = nil)
    if expected == actual
      puts "\e[32m✓\e[0m #{label || 'passed'}"
      true
    else
      puts "\e[31m✗\e[0m #{label || 'failed'}: expected #{expected.inspect}, got #{actual.inspect}"
      false
    end
  end

  def assert_true(condition, label = nil)
    assert_eq(true, condition, label)
  end

  def assert_false(condition, label = nil)
    assert_eq(false, condition, label)
  end

  # Run multiple test cases
  # tests = [
  #   [expected, actual, "description"],
  #   ...
  # ]
  def run_tests(tests)
    passed = 0
    failed = 0
    tests.each do |expected, actual, desc|
      if assert_eq(expected, actual, desc)
        passed += 1
      else
        failed += 1
      end
    end
    puts "\n#{passed} passed, #{failed} failed"
    failed == 0
  end

  # Table-driven testing (Go-style)
  # cases = [
  #   { input: ..., expected: ..., name: "..." },
  #   ...
  # ]
  def run_table(cases, &block)
    passed = 0
    failed = 0
    cases.each do |tc|
      result = block.call(tc[:input])
      if assert_eq(tc[:expected], result, tc[:name])
        passed += 1
      else
        failed += 1
      end
    end
    puts "\n#{passed} passed, #{failed} failed"
    failed == 0
  end
end

# Example usage patterns for AoC solutions:
#
# Pattern 1: Inline assertions (simplest)
# -----------------------------------------
#   require_relative '../../lib/aoc_test'
#   include AocAssert
#
#   EXAMPLE = "..."
#   assert_eq 357, solve_part1(EXAMPLE), "Part 1 example"
#   assert_eq 42, solve_part2(EXAMPLE), "Part 2 example"
#
#
# Pattern 2: Table-driven tests (Go-style)
# -----------------------------------------
#   require_relative '../../lib/aoc_test'
#   include AocAssert
#
#   CASES = [
#     { input: "11", expected: true, name: "simple repeat" },
#     { input: "12", expected: false, name: "no repeat" },
#     { input: "6464", expected: true, name: "two-digit repeat" },
#   ]
#
#   run_table(CASES) { |input| is_invalid?(input) }
#
#
# Pattern 3: Batch tests with summary
# -----------------------------------------
#   require_relative '../../lib/aoc_test'
#   include AocAssert
#
#   run_tests([
#     [98, max_joltage("987654321"), "first case"],
#     [89, max_joltage("819"), "second case"],
#   ])
