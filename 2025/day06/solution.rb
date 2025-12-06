# Advent of Code 2025 - Day 6: Trash Compactor
# Parse vertical math problems and compute grand total
#
# Ruby idioms demonstrated:
# - transpose for column-based parsing
# - slice_when for splitting on separators
# - reduce with operators (:+, :*)
# - regex for digit extraction

def parse_problems(input)
  lines = input.lines.map(&:chomp)
  return [] if lines.empty?

  # Pad all lines to same length
  max_len = lines.map(&:length).max
  grid = lines.map { |l| l.ljust(max_len).chars }

  # Transpose to work with columns
  columns = grid.transpose

  # A separator is a FULL column of spaces (all rows are space)
  # Split into problem groups at separator columns
  problem_groups = []
  current_group = []

  columns.each do |col|
    all_space = col.all? { |c| c == ' ' }
    if all_space && !current_group.empty?
      # Hit a separator - save current group and start new
      problem_groups << current_group
      current_group = []
    elsif !all_space
      current_group << col
    end
    # Skip consecutive separator columns
  end
  problem_groups << current_group unless current_group.empty?

  # Parse each problem group
  problem_groups.map do |cols|
    # Transpose back to rows for this problem
    rows = cols.transpose

    # Find the operator (last row typically, or row with * or +)
    operator = :+  # default
    rows.each do |row|
      text = row.join
      if text.include?('*')
        operator = :*
        break
      elsif text.include?('+')
        operator = :+
        break
      end
    end

    # Each column is one number, digits stacked vertically
    numbers = cols.map do |col|
      digits = col.select { |c| c =~ /\d/ }.join
      digits.empty? ? 0 : digits.to_i
    end
    numbers.reject!(&:zero?)

    { numbers: numbers, operator: operator }
  end
end

def solve_problem(problem)
  problem[:numbers].reduce(problem[:operator])
end

def solve_part1(input)
  problems = parse_problems(input)
  problems.sum { |p| solve_problem(p) }
end

# ==========================================================================
# Tests
# ==========================================================================
if __FILE__ == $0
  require_relative '../../lib/aoc_test'
  include AocAssert

  # Format: numbers stacked vertically, operator at bottom
  # Problems are separated by 2+ consecutive space columns
  # Within a problem, numbers are in adjacent columns (no space column between)

  # Single problem: 123 * 45 * 6 = 33210
  # Numbers are adjacent (no separator between them)
  ONE_PROBLEM = <<~INPUT
    146
    25
    3
    ***
  INPUT

  puts "Testing single problem (123 * 45 * 6):"
  problems = parse_problems(ONE_PROBLEM)
  puts "Parsed: #{problems.inspect}"
  if problems.length == 1 && problems[0][:numbers] == [1, 4, 6] # Wait, that's wrong too
    # Actually the digits stack: col0=[1,2,3], col1=[4,5], col2=[6]
    # So numbers are 123, 45, 6
  end

  # Actually I think each digit column IS a number
  # Let me re-read: "123 × 45 × 6"
  # This is three numbers: 123, 45, 6
  # Vertically:
  #   1 4 6
  #   2 5
  #   3
  # Reading each column gives: 123, 45, 6

  # Single problem test with clear structure
  SIMPLE = <<~INPUT
    12
    *
  INPUT

  puts "\nSimple test (12 multiplied - single number returns itself):"
  problems = parse_problems(SIMPLE)
  puts "Parsed: #{problems.inspect}"
  # Should be: numbers=[12], operator=:*, result=12

  # Two numbers multiplied: 2 * 3 = 6
  TWO_NUMS = <<~INPUT
    23
    **
  INPUT

  puts "\nTwo numbers (2 * 3 = 6):"
  problems = parse_problems(TWO_NUMS)
  puts "Parsed: #{problems.inspect}"
  if problems.length == 1
    result = solve_problem(problems[0])
    puts "Result: #{result}"
    assert_eq 6, result, "2 * 3 = 6"
  end

  # Three numbers: 1 * 2 * 3 = 6
  THREE_NUMS = <<~INPUT
    123
    ***
  INPUT

  puts "\nThree numbers (1 * 2 * 3 = 6):"
  problems = parse_problems(THREE_NUMS)
  puts "Parsed: #{problems.inspect}"
  if problems.length == 1
    result = solve_problem(problems[0])
    puts "Result: #{result}"
    assert_eq 6, result, "1 * 2 * 3 = 6"
  end

  # Multi-digit: 12 * 34 = 408
  MULTI_DIGIT = <<~INPUT
    13
    24
    **
  INPUT

  puts "\nMulti-digit (12 * 34 = 408):"
  problems = parse_problems(MULTI_DIGIT)
  puts "Parsed: #{problems.inspect}"
  if problems.length == 1
    result = solve_problem(problems[0])
    puts "Result: #{result}"
    assert_eq 408, result, "12 * 34 = 408"
  end

  # Two problems separated by empty column(s)
  # Numbers stack vertically: col0=[1,2]=12, col1=[3,4]=34
  TWO_PROBS = <<~INPUT
    13  57
    24  68
    **  ++
  INPUT

  puts "\nTwo problems (12*34=408, 56+78=134):"
  problems = parse_problems(TWO_PROBS)
  puts "Parsed: #{problems.inspect}"
  if problems.length == 2
    r1 = solve_problem(problems[0])
    r2 = solve_problem(problems[1])
    puts "Results: #{r1}, #{r2}"
    assert_eq 408, r1, "12 * 34 = 408"
    assert_eq 134, r2, "56 + 78 = 134"
    assert_eq 542, r1 + r2, "Total = 542"
  end

  # The example from puzzle:
  # 123 * 45 * 6 = 33210
  # Numbers stacked:
  #   1 4 6
  #   2 5
  #   3
  PUZZLE_EXAMPLE = <<~INPUT
    146
    25
    3
    ***
  INPUT

  puts "\nPuzzle example (123 * 45 * 6 = 33210):"
  problems = parse_problems(PUZZLE_EXAMPLE)
  puts "Parsed: #{problems.inspect}"
  if problems.length == 1
    result = solve_problem(problems[0])
    puts "Result: #{result}"
    assert_eq 33210, result, "123 * 45 * 6 = 33210"
  end

  # Solve with actual input if available
  if File.exist?(File.join(__dir__, 'input.txt'))
    input = File.read(File.join(__dir__, 'input.txt'))
    puts "\nPart 1: #{solve_part1(input)}"
  end
end
