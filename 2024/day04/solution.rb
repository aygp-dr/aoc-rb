# Advent of Code 2024 - Day 4: Ceres Search
# https://adventofcode.com/2024/day/4
#
# Word search puzzle - find all "XMAS" occurrences
#
# Ruby idioms demonstrated:
# - Grid as array of arrays
# - product for generating coordinate pairs
# - dig for safe nested access
# - Enumerable#count with block
# - Direction vectors as constants

require_relative '../../lib/aoc_utils'

class Day04
  # All 8 directions from library (includes cardinals + diagonals)
  DIRECTIONS = AocUtils::DIRS_8.freeze

  TARGET = 'XMAS'.freeze

  def initialize(input)
    @grid = input.lines.map { |line| line.chomp.chars }
    @height = @grid.length
    @width = @grid[0]&.length || 0
  end

  # Part 1: Count all occurrences of XMAS in all 8 directions
  #
  # Idiomatic: product generates all (row, col) pairs
  def part1
    (0...@height).to_a.product((0...@width).to_a).sum do |row, col|
      count_xmas_at(row, col)
    end
  end

  # Part 2: Count X-MAS patterns (two MAS in X shape)
  def part2
    # Check all positions that could be center of X
    (1...@height - 1).to_a.product((1...@width - 1).to_a).count do |row, col|
      x_mas_at?(row, col)
    end
  end

  private

  # Count XMAS starting at position in all directions
  def count_xmas_at(row, col)
    return 0 unless @grid[row][col] == 'X'

    DIRECTIONS.count { |dr, dc| word_at?(row, col, dr, dc, TARGET) }
  end

  # Check if word exists starting at position in given direction
  #
  # Idiomatic: each_char.with_index + all? for character validation
  def word_at?(row, col, dr, dc, word)
    word.each_char.with_index.all? do |char, i|
      r = row + dr * i
      c = col + dc * i
      in_bounds?(r, c) && @grid[r][c] == char
    end
  end

  # Check for X-MAS pattern centered at position
  # Two MAS crossing diagonally, can be forward or backward
  def x_mas_at?(row, col)
    return false unless @grid[row][col] == 'A'

    # Diagonal 1: top-left to bottom-right
    diag1 = [@grid[row - 1][col - 1], @grid[row + 1][col + 1]].sort.join
    # Diagonal 2: top-right to bottom-left
    diag2 = [@grid[row - 1][col + 1], @grid[row + 1][col - 1]].sort.join

    # Both diagonals must be M and S (in any order)
    diag1 == 'MS' && diag2 == 'MS'
  end

  def in_bounds?(row, col)
    row >= 0 && row < @height && col >= 0 && col < @width
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day04.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
