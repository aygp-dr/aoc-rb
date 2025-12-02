# Advent of Code 2019 - Day 1: The Tyranny of the Rocket Equation
# https://adventofcode.com/2019/day/1
#
# Calculate fuel requirements for modules
# Fuel = floor(mass / 3) - 2
#
# Ruby idioms demonstrated:
# - Integer division with / (auto-floors for integers)
# - sum with block: combines map + sum
# - Recursive vs iterative approaches
# - Method references with method(:name)
# - Kernel#loop with break for iterative solutions
# - unfold pattern (custom implementation)

class Day01
  def initialize(input)
    @masses = input.lines.map(&:to_i)
  end

  # Fuel formula: floor(mass / 3) - 2
  # Integer division in Ruby automatically floors
  def fuel_for_mass(mass) = mass / 3 - 2

  # Part 1: Sum fuel requirements for all modules
  #
  # Idiomatic: sum with block (combines map + sum)
  def part1 = @masses.sum { fuel_for_mass(_1) }

  # Alternative using method reference
  def part1_method_ref = @masses.sum(&method(:fuel_for_mass))

  # Part 2: Account for fuel's own mass recursively
  # Fuel also needs fuel, until fuel requirement is 0 or negative
  #
  # Recursive approach - elegant but may stack overflow for huge inputs
  def fuel_for_mass_recursive(mass)
    fuel = fuel_for_mass(mass)
    return 0 if fuel <= 0
    fuel + fuel_for_mass_recursive(fuel)
  end

  # Iterative approach using loop + break
  def fuel_for_mass_iterative(mass)
    total = 0
    fuel = fuel_for_mass(mass)
    while fuel > 0
      total += fuel
      fuel = fuel_for_mass(fuel)
    end
    total
  end

  # Functional approach: Generate sequence, sum until non-positive
  # Uses unfold-like pattern with iterate (Ruby 2.7+)
  def fuel_for_mass_functional(mass)
    # Generate infinite sequence of fuel requirements
    # Each iteration computes fuel for previous fuel amount
    sequence = Enumerator.produce(fuel_for_mass(mass)) { fuel_for_mass(_1) }

    # Take while positive and sum
    sequence.take_while(&:positive?).sum
  end

  def part2 = @masses.sum { fuel_for_mass_recursive(_1) }

  # Alternative implementations
  def part2_iterative = @masses.sum { fuel_for_mass_iterative(_1) }
  def part2_functional = @masses.sum { fuel_for_mass_functional(_1) }
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
