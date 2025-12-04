# Advent of Code 2025 - Day 4: Printing Department
# Count paper rolls accessible by forklift (fewer than 4 neighbors)

require_relative '../../lib/aoc_utils'

def solve_part1(input)
  grid = input.lines.map { |l| l.chomp.chars }
  rows = grid.length
  cols = grid[0]&.length || 0

  accessible = 0

  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      next unless cell == '@'

      # Count adjacent paper rolls using library DIRECTIONS_8
      neighbor_count = AocUtils::DIRECTIONS_8.count do |dr, dc|
        nr, nc = r + dr, c + dc
        AocUtils.in_bounds?(grid, nr, nc) && grid[nr][nc] == '@'
      end

      # Accessible if fewer than 4 neighbors
      accessible += 1 if neighbor_count < 4
    end
  end

  accessible
end

# Test with example
example = <<~INPUT
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
INPUT

puts "Example: #{solve_part1(example)}"
# Expected: 13

# Solve with actual input if available
if File.exist?('2025/day04/input.txt')
  input = File.read('2025/day04/input.txt')
  puts "Part 1: #{solve_part1(input)}"
end
