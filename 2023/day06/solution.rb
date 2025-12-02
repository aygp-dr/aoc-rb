# Advent of Code 2023 - Day 6: Wait For It
# https://adventofcode.com/2023/day/6
#
# Calculate winning strategies for boat races
#
# Ruby idioms demonstrated:
# - zip for pairing arrays
# - count with range
# - Quadratic formula for optimization
# - Integer square root (Ruby 3.0+)
# - gsub for string cleaning
# - reduce(:*) for product

class Day06
  def initialize(input)
    lines = input.lines.map(&:strip)
    @times = lines[0].scan(/\d+/).map(&:to_i)
    @distances = lines[1].scan(/\d+/).map(&:to_i)
  end

  # Part 1: Product of ways to win each race
  def part1
    @times.zip(@distances).map { |time, dist| count_wins(time, dist) }.reduce(:*)
  end

  # Part 2: Single race with numbers concatenated
  def part2
    time = @times.join.to_i
    dist = @distances.join.to_i
    count_wins(time, dist)
  end

  private

  # Count ways to beat the record
  #
  # Hold for h milliseconds -> speed = h mm/ms
  # Travel time = (time - h) ms
  # Distance = h * (time - h)
  #
  # We need: h * (time - h) > dist
  # Using quadratic formula for efficiency on large inputs
  def count_wins(time, dist)
    # h * (time - h) > dist
    # -h² + time*h - dist > 0
    # h² - time*h + dist < 0
    # Roots: h = (time ± sqrt(time² - 4*dist)) / 2

    discriminant = time * time - 4 * dist
    return 0 if discriminant < 0

    sqrt_d = Math.sqrt(discriminant)
    h_min = (time - sqrt_d) / 2.0
    h_max = (time + sqrt_d) / 2.0

    # We need strictly greater, so:
    # - If h_min is exactly an integer, we need h_min + 1
    # - Otherwise, ceil(h_min)
    min_hold = h_min == h_min.to_i ? h_min.to_i + 1 : h_min.ceil

    # - If h_max is exactly an integer, we need h_max - 1
    # - Otherwise, floor(h_max)
    max_hold = h_max == h_max.to_i ? h_max.to_i - 1 : h_max.floor

    [max_hold - min_hold + 1, 0].max
  end

  # Alternative: Brute force (simpler but slower for large inputs)
  def count_wins_brute(time, dist)
    (0..time).count { |hold| hold * (time - hold) > dist }
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day06.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
