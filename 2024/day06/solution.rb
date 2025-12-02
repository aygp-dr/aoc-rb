# Advent of Code 2024 - Day 6: Guard Gallivant
# https://adventofcode.com/2024/day/6
#
# Simulate guard patrol path
#
# Ruby idioms demonstrated:
# - Direction cycling with array index
# - Set for tracking visited positions
# - loop with break for simulation
# - find for locating start position
# - Hash for direction lookup

require 'set'

class Day06
  # Directions in clockwise order: up, right, down, left
  # Using [dy, dx] format for screen coordinates (y increases downward)
  DIRS = [[-1, 0], [0, 1], [1, 0], [0, -1]].freeze  # up, right, down, left
  DIR_CHARS = { '^' => 0, '>' => 1, 'v' => 2, '<' => 3 }.freeze

  def initialize(input)
    @grid = input.lines.map(&:chomp)
    @height = @grid.length
    @width = @grid[0].length
    @start_y, @start_x, @start_dir = find_guard
  end

  # Part 1: Count distinct positions visited before leaving
  def part1
    visited, _ = simulate
    visited.size
  end

  # Part 2: Count positions where adding obstacle creates loop
  def part2
    # Get original path to know where obstacles might matter
    original_path, _ = simulate

    # Try adding obstacle at each position on the original path
    (original_path - [[@start_y, @start_x]]).count do |obstacle_pos|
      creates_loop?(obstacle_pos)
    end
  end

  private

  # Find guard position and direction index
  def find_guard
    @grid.each_with_index do |row, y|
      row.chars.each_with_index do |char, x|
        if DIR_CHARS.key?(char)
          return [y, x, DIR_CHARS[char]]
        end
      end
    end
  end

  # Simulate guard movement
  # Returns [visited_positions, looped?]
  def simulate(extra_obstacle = nil)
    y, x, dir = @start_y, @start_x, @start_dir
    visited = Set.new
    states = Set.new  # Track (y, x, dir) for loop detection

    loop do
      state = [y, x, dir]
      return [visited, true] if states.include?(state)  # Loop detected

      states.add(state)
      visited.add([y, x])

      dy, dx = DIRS[dir]
      ny, nx = y + dy, x + dx

      # Check if leaving grid
      unless in_bounds?(ny, nx)
        return [visited, false]
      end

      # Check for obstacle
      if obstacle?(ny, nx) || [ny, nx] == extra_obstacle
        dir = (dir + 1) % 4  # Turn right (cycle through directions)
      else
        y, x = ny, nx  # Move forward
      end
    end
  end

  def creates_loop?(obstacle_pos)
    _, looped = simulate(obstacle_pos)
    looped
  end

  def in_bounds?(y, x)
    y >= 0 && y < @height && x >= 0 && x < @width
  end

  def obstacle?(y, x)
    @grid[y][x] == '#'
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day06.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
