# Advent of Code 2021 - Day 1: Sonar Sweep
# https://adventofcode.com/2021/day/1
#
# Count depth increases in sonar readings
#
# Ruby idioms demonstrated:
# - each_cons(n): sliding window over consecutive elements
# - Numbered block parameters (_1, _2): Ruby 3.0+ shorthand
# - Method chaining: functional pipeline style
# - count with block: counting elements matching condition

class Day01
  def initialize(input)
    @depths = input.lines.map(&:to_i)
  end

  # Part 1: Count times depth increases from previous reading
  #
  # Idiomatic: each_cons(2) creates pairs of consecutive elements
  # [199, 200, 208] -> [[199, 200], [200, 208]]
  # Then count where second > first using numbered params _1, _2
  def part1 = @depths.each_cons(2).count { _2 > _1 }

  # Part 2: Count increases using 3-measurement sliding window sums
  #
  # each_cons(3) creates triplets, map(&:sum) converts to sums,
  # then apply same logic as part1
  def part2 = @depths.each_cons(3).map(&:sum).each_cons(2).count { _2 > _1 }

  # Alternative part2 - more efficient (avoids intermediate array)
  # Insight: comparing sums of [a,b,c] vs [b,c,d] simplifies to a vs d
  # since b+c cancels out
  def part2_optimized = @depths.each_cons(4).count { _4 > _1 }
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day01.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
