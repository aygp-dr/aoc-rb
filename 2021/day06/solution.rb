# Advent of Code 2021 - Day 6: Lanternfish
# https://adventofcode.com/2021/day/6
#
# Simulate exponential fish population growth
#
# Ruby idioms demonstrated:
# - tally: count occurrences (Ruby 2.7+)
# - Hash.new(0): default value for missing keys
# - transform_keys: modify hash keys
# - rotate for array cycling
# - times.reduce for iterative transformation
# - Array initialization with default values

class Day06
  def initialize(input)
    @initial = input.strip.split(',').map(&:to_i)
  end

  # Part 1: Count fish after 80 days
  def part1
    simulate(80)
  end

  # Part 2: Count fish after 256 days
  def part2
    simulate(256)
  end

  # Efficient simulation using fish count per timer value
  #
  # Key insight: We don't track individual fish, just counts per timer value
  # This makes it O(days * 9) instead of O(days * fish_count)
  #
  # Idiomatic: tally creates frequency hash from array
  def simulate(days)
    # tally returns {timer_value => count}
    # e.g., [3,4,3,1,2].tally => {3=>2, 4=>1, 1=>1, 2=>1}
    fish = @initial.tally

    days.times do
      fish = simulate_day(fish)
    end

    fish.values.sum
  end

  private

  # One day of simulation
  #
  # Fish at timer 0 spawn new fish (timer 8) and reset to timer 6
  # All other fish decrease timer by 1
  def simulate_day(fish)
    new_fish = Hash.new(0)

    fish.each do |timer, count|
      if timer == 0
        new_fish[6] += count  # Reset to 6
        new_fish[8] += count  # Spawn new fish at 8
      else
        new_fish[timer - 1] += count  # Decrease timer
      end
    end

    new_fish
  end
end

# Alternative: Array-based simulation (more elegant)
class Day06Array
  def initialize(input)
    @initial = input.strip.split(',').map(&:to_i)
  end

  def simulate(days)
    # Array where index = timer value, value = fish count
    # [count_at_0, count_at_1, ..., count_at_8]
    fish = Array.new(9, 0)
    @initial.each { |timer| fish[timer] += 1 }

    days.times do
      # rotate(1) moves first element to end
      # This naturally decrements all timers!
      # Fish at 0 go to end (position 8) = new fish
      # We also need to add them back at position 6
      spawning = fish[0]
      fish = fish.rotate(1)
      fish[6] += spawning  # Reset spawning fish to timer 6
    end

    fish.sum
  end
end

# Alternative: Using times.reduce (functional style)
class Day06Functional
  def initialize(input)
    @initial = input.strip.split(',').map(&:to_i)
  end

  def simulate(days)
    fish = Array.new(9, 0)
    @initial.each { |t| fish[t] += 1 }

    # times.reduce applies transformation n times
    result = days.times.reduce(fish) do |f, _|
      spawning = f[0]
      rotated = f.rotate(1)
      rotated[6] += spawning
      rotated
    end

    result.sum
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day06.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
