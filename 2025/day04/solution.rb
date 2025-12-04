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

# ==========================================================================
# Tests
# ==========================================================================
if __FILE__ == $0
  require_relative '../../lib/aoc_test'
  include AocAssert

  EXAMPLE = <<~INPUT
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

  puts "Testing solve_part1:"
  assert_eq 13, solve_part1(EXAMPLE), "Example grid"

  # Edge cases
  puts "\nEdge cases:"
  assert_eq 1, solve_part1("@"), "single roll - 0 neighbors"
  assert_eq 2, solve_part1("@@"), "two adjacent - 1 neighbor each"
  assert_eq 4, solve_part1("@@@\n@@@\n@@@"), "3x3 full - corners have 3 neighbors"
  assert_eq 4, solve_part1("@@\n@@"), "2x2 - each has 3 neighbors"

  # Solve with actual input if available
  if File.exist?(File.join(__dir__, 'input.txt'))
    input = File.read(File.join(__dir__, 'input.txt'))
    puts "\nPart 1: #{solve_part1(input)}"
  end
end
