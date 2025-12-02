# Advent of Code 2023 - Day 3: Gear Ratios
# https://adventofcode.com/2023/day/3
#
# Find numbers adjacent to symbols in engine schematic
#
# Ruby idioms demonstrated:
# - gsub with index for finding positions
# - MatchData#begin for match position
# - Enumerable#flat_map
# - Set for neighbor coordinates
# - Hash with array default for grouping

require 'set'

class Day03
  def initialize(input)
    @grid = input.lines.map(&:chomp)
    @height = @grid.length
    @width = @grid[0].length
  end

  # Part 1: Sum all part numbers (adjacent to symbols)
  def part1
    find_numbers.select { |num| adjacent_to_symbol?(num) }.sum { |num| num[:value] }
  end

  # Part 2: Sum gear ratios (products of exactly 2 numbers adjacent to *)
  def part2
    numbers = find_numbers
    gears = find_gears

    gears.sum do |gear_pos|
      adjacent = numbers.select { |num| adjacent_to?(num, gear_pos) }
      adjacent.size == 2 ? adjacent[0][:value] * adjacent[1][:value] : 0
    end
  end

  private

  # Find all numbers with their positions
  #
  # Idiomatic: scan with MatchData to get position info
  def find_numbers
    numbers = []
    @grid.each_with_index do |row, y|
      row.scan(/\d+/) do |match|
        x = Regexp.last_match.begin(0)
        numbers << {
          value: match.to_i,
          row: y,
          col_start: x,
          col_end: x + match.length - 1
        }
      end
    end
    numbers
  end

  # Find all gear (*) positions
  def find_gears
    positions = []
    @grid.each_with_index do |row, y|
      row.chars.each_with_index do |char, x|
        positions << [y, x] if char == '*'
      end
    end
    positions
  end

  # Check if number is adjacent to any symbol
  def adjacent_to_symbol?(num)
    neighbor_coords(num).any? { |y, x| symbol_at?(y, x) }
  end

  # Check if number is adjacent to specific position
  def adjacent_to?(num, pos)
    neighbor_coords(num).include?(pos)
  end

  # Get all neighboring coordinates for a number
  #
  # Idiomatic: flat_map + product for coordinate generation
  def neighbor_coords(num)
    coords = Set.new
    (num[:row] - 1..num[:row] + 1).each do |y|
      (num[:col_start] - 1..num[:col_end] + 1).each do |x|
        next if y == num[:row] && x >= num[:col_start] && x <= num[:col_end]
        coords.add([y, x]) if in_bounds?(y, x)
      end
    end
    coords
  end

  def symbol_at?(y, x)
    char = @grid[y][x]
    char != '.' && !char.match?(/\d/)
  end

  def in_bounds?(y, x)
    y >= 0 && y < @height && x >= 0 && x < @width
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day03.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
