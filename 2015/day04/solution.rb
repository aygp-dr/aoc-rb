# Advent of Code 2015 - Day 4: The Ideal Stocking Stuffer
# https://adventofcode.com/2015/day/4
#
# Find MD5 hash with leading zeros (mining-like problem)
#
# Ruby idioms demonstrated:
# - require 'digest': standard library for hashing
# - Digest::MD5.hexdigest: one-liner hash
# - Integer#times with block vs (1..).find
# - start_with? for string prefix matching
# - Lazy enumeration with (1..).lazy
# - Parallel iteration possibilities with Ractor (Ruby 3.0+)

require 'digest'

class Day04
  def initialize(input)
    @secret = input.strip
  end

  # Part 1: Find lowest positive integer where MD5(secret + n) starts with 5 zeros
  #
  # Idiomatic: (1..).find - infinite range with find for first match
  # start_with? is cleaner than regex or slice comparison
  def part1
    (1..).find { |n| Digest::MD5.hexdigest("#{@secret}#{n}").start_with?('00000') }
  end

  # Part 2: Find hash starting with 6 zeros
  def part2
    (1..).find { |n| Digest::MD5.hexdigest("#{@secret}#{n}").start_with?('000000') }
  end

  # Alternative: Using lazy enumeration explicitly
  # Lazy prevents generating all integers upfront
  def part1_lazy
    (1..)
      .lazy
      .find { |n| md5_hex(n).start_with?('00000') }
  end

  # Alternative: Pre-compute prefix check (micro-optimization)
  # Checking hex chars is slightly faster than start_with? on full string
  def part1_optimized
    (1..).find do |n|
      hash = Digest::MD5.hexdigest("#{@secret}#{n}")
      hash[0, 5] == '00000'
    end
  end

  # Continue from part1 result for part2 (optimization)
  def part2_from(start)
    (start..).find { |n| Digest::MD5.hexdigest("#{@secret}#{n}").start_with?('000000') }
  end

  private

  def md5_hex(n) = Digest::MD5.hexdigest("#{@secret}#{n}")
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day04.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
