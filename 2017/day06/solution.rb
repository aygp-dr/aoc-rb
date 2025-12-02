# Advent of Code 2017 - Day 6: Memory Reallocation
# https://adventofcode.com/2017/day/6
#
# Detect cycle in memory bank redistribution
#
# Ruby idioms demonstrated:
# - Hash for state memoization (cycle detection)
# - max_by with index for finding maximum
# - each_with_index vs with_index
# - dup for copying arrays
# - modulo for circular indexing
# - Destructuring assignment

class Day06
  def initialize(input)
    @banks = input.split.map(&:to_i)
  end

  # Part 1: Count steps until we see a repeated configuration
  #
  # Uses Hash to track seen states and their step numbers
  # Key insight: Array#hash provides unique hash for array contents
  def part1
    banks = @banks.dup
    seen = { banks.dup => 0 }
    steps = 0

    loop do
      redistribute!(banks)
      steps += 1
      break steps if seen.key?(banks)
      seen[banks.dup] = steps
    end
  end

  # Part 2: Find loop size (steps between first and second occurrence)
  def part2
    banks = @banks.dup
    seen = { banks.dup => 0 }
    steps = 0

    loop do
      redistribute!(banks)
      steps += 1
      if seen.key?(banks)
        return steps - seen[banks]
      end
      seen[banks.dup] = steps
    end
  end

  # Solve both parts at once (optimization)
  def solve
    banks = @banks.dup
    seen = { banks.dup => 0 }
    steps = 0

    loop do
      redistribute!(banks)
      steps += 1
      if seen.key?(banks)
        return [steps, steps - seen[banks]]
      end
      seen[banks.dup] = steps
    end
  end

  private

  # Redistribute blocks from bank with most blocks
  #
  # Idiomatic: each_with_index.max_by for finding max with tie-breaking
  def redistribute!(banks)
    # Find bank with most blocks (ties: lowest index wins)
    # max_by returns [value, index], we want index of max value
    # Negate index for correct tie-breaking (lower index = higher priority)
    max_idx = banks.each_with_index.max_by { |val, idx| [val, -idx] }.last

    # Take all blocks from that bank
    blocks = banks[max_idx]
    banks[max_idx] = 0

    # Distribute one block at a time, wrapping around
    idx = max_idx
    blocks.times do
      idx = (idx + 1) % banks.length
      banks[idx] += 1
    end
  end
end

# Alternative: Using Brent's cycle detection (O(1) space)
class Day06Brent
  def initialize(input)
    @initial = input.split.map(&:to_i)
  end

  def solve
    # Brent's algorithm finds cycle without storing all states
    power = lam = 1
    tortoise = @initial.dup
    hare = redistribute(tortoise.dup)

    while tortoise != hare
      if power == lam
        tortoise = hare.dup
        power *= 2
        lam = 0
      end
      hare = redistribute(hare)
      lam += 1
    end

    # lam is cycle length, now find cycle start (mu)
    mu = 0
    tortoise = @initial.dup
    hare = @initial.dup
    lam.times { hare = redistribute(hare) }

    while tortoise != hare
      tortoise = redistribute(tortoise)
      hare = redistribute(hare)
      mu += 1
    end

    [mu + lam, lam]  # [part1, part2]
  end

  private

  def redistribute(banks)
    banks = banks.dup
    max_idx = banks.each_with_index.max_by { |v, i| [v, -i] }.last
    blocks = banks[max_idx]
    banks[max_idx] = 0
    idx = max_idx
    blocks.times { idx = (idx + 1) % banks.length; banks[idx] += 1 }
    banks
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day06.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
