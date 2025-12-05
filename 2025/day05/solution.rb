# Advent of Code 2025 - Day 5: Cafeteria
# Check which ingredient IDs fall within fresh ranges
#
# Multiple approaches demonstrated for range membership testing

def parse_input(input)
  ranges_section, ids_section = input.strip.split("\n\n")

  ranges = ranges_section.lines.map do |line|
    start, finish = line.scan(/\d+/).map(&:to_i)
    (start..finish)
  end

  ids = ids_section.lines.map { |line| line.to_i }

  [ranges, ids]
end

# ==========================================================================
# Approach 1: Range#cover? with any?
# O(r) per lookup where r = number of ranges
# Clean, idiomatic Ruby
# ==========================================================================
def fresh_cover?(id, ranges)
  ranges.any? { |range| range.cover?(id) }
end

# ==========================================================================
# Approach 2: Set-based lookup
# O(1) per lookup after O(n) preprocessing where n = total range size
# Best when checking many IDs against same ranges
# Trade-off: memory vs speed
# ==========================================================================
def build_fresh_set(ranges)
  require 'set'
  ranges.each_with_object(Set.new) { |r, set| set.merge(r.to_a) }
end

def fresh_set?(id, fresh_set)
  fresh_set.include?(id)
end

# ==========================================================================
# Approach 3: Merged ranges with binary search
# O(log r) per lookup after O(r log r) preprocessing
# Best for large number of ranges, sparse IDs
# ==========================================================================
def merge_ranges(ranges)
  sorted = ranges.sort_by(&:begin)
  sorted.each_with_object([]) do |range, merged|
    if merged.empty? || merged.last.end < range.begin - 1
      merged << range
    else
      # Extend the last range
      merged[-1] = (merged.last.begin..[merged.last.end, range.end].max)
    end
  end
end

def fresh_binary?(id, merged_ranges)
  # Binary search for the range that might contain id
  idx = merged_ranges.bsearch_index { |r| r.end >= id }
  idx && merged_ranges[idx].cover?(id)
end

# ==========================================================================
# Approach 4: Interval tree (for very large datasets)
# O(log r + k) where k = overlapping intervals
# Ruby doesn't have built-in, but shows the concept
# ==========================================================================
class SimpleIntervalTree
  def initialize(ranges)
    @ranges = ranges.sort_by(&:begin)
  end

  def include?(id)
    # Simple linear scan - real impl would use tree structure
    @ranges.any? { |r| r.cover?(id) }
  end
end

# ==========================================================================
# Approach 5: Functional with reduce
# Demonstrates reduce pattern, not optimal
# ==========================================================================
def fresh_reduce?(id, ranges)
  ranges.reduce(false) { |found, r| found || r.cover?(id) }
end

# ==========================================================================
# Approach 6: Pattern matching (Ruby 3.x)
# Shows case/in syntax - works better for destructuring
# ==========================================================================
def fresh_pattern?(id, ranges)
  # Pattern matching is better for destructuring than range checks
  # This shows the syntax even though cover? is cleaner here
  ranges.any? do |range|
    id >= range.begin && id <= range.end
  end
end

# ==========================================================================
# Approach 7: Using our library's range helpers
# ==========================================================================
def fresh_library?(id, ranges)
  require_relative '../../lib/aoc_utils'
  # Check if id falls in any range using library
  ranges.any? { |r| r.cover?(id) }
end

# ==========================================================================
# Default solution using Approach 1
# ==========================================================================
def solve_part1(input, approach: :cover)
  ranges, ids = parse_input(input)

  case approach
  when :cover
    ids.count { |id| fresh_cover?(id, ranges) }
  when :set
    fresh_set = build_fresh_set(ranges)
    ids.count { |id| fresh_set?(id, fresh_set) }
  when :binary
    merged = merge_ranges(ranges)
    ids.count { |id| fresh_binary?(id, merged) }
  when :reduce
    ids.count { |id| fresh_reduce?(id, ranges) }
  else
    ids.count { |id| fresh_cover?(id, ranges) }
  end
end

# ==========================================================================
# Tests
# ==========================================================================
if __FILE__ == $0
  require_relative '../../lib/aoc_test'
  include AocAssert

  EXAMPLE = <<~INPUT
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
  INPUT

  puts "Testing parse_input:"
  ranges, ids = parse_input(EXAMPLE)
  assert_eq 4, ranges.length, "4 ranges parsed"
  assert_eq (3..5), ranges[0], "first range is 3..5"
  assert_eq 6, ids.length, "6 IDs parsed"

  puts "\nTesting Approach 1 (cover?):"
  assert_eq false, fresh_cover?(1, ranges), "ID 1 is spoiled"
  assert_eq true, fresh_cover?(5, ranges), "ID 5 is fresh"
  assert_eq true, fresh_cover?(17, ranges), "ID 17 is fresh (overlapping)"

  puts "\nTesting Approach 2 (Set):"
  fresh_set = build_fresh_set(ranges)
  assert_eq false, fresh_set?(1, fresh_set), "ID 1 is spoiled"
  assert_eq true, fresh_set?(5, fresh_set), "ID 5 is fresh"
  assert_eq true, fresh_set?(17, fresh_set), "ID 17 is fresh"

  puts "\nTesting Approach 3 (merged + binary search):"
  merged = merge_ranges(ranges)
  assert_eq 2, merged.length, "4 ranges merge to 2"
  assert_eq (3..5), merged[0], "first merged range"
  assert_eq (10..20), merged[1], "second merged range (10-14 + 12-18 + 16-20)"
  assert_eq false, fresh_binary?(1, merged), "ID 1 is spoiled"
  assert_eq true, fresh_binary?(5, merged), "ID 5 is fresh"
  assert_eq true, fresh_binary?(17, merged), "ID 17 is fresh"

  puts "\nTesting Approach 5 (reduce):"
  assert_eq false, fresh_reduce?(1, ranges), "ID 1 is spoiled"
  assert_eq true, fresh_reduce?(5, ranges), "ID 5 is fresh"

  puts "\nTesting all approaches give same answer:"
  [:cover, :set, :binary, :reduce].each do |approach|
    assert_eq 3, solve_part1(EXAMPLE, approach: approach), "Approach #{approach}"
  end

  puts "\nEdge cases:"
  assert_eq true, fresh_cover?(3, [(3..5)]), "boundary: start of range"
  assert_eq true, fresh_cover?(5, [(3..5)]), "boundary: end of range"
  assert_eq false, fresh_cover?(2, [(3..5)]), "boundary: just before"
  assert_eq false, fresh_cover?(6, [(3..5)]), "boundary: just after"

  # Benchmark comparison (optional)
  if ARGV.include?('--bench')
    require 'benchmark'
    large_ranges = (1..1000).map { |i| (i*100..(i*100+50)) }
    large_ids = (1..10000).to_a.shuffle

    puts "\nBenchmark (1000 ranges, 10000 IDs):"
    Benchmark.bm(12) do |x|
      x.report("cover?:")  { large_ids.count { |id| fresh_cover?(id, large_ranges) } }
      x.report("set:")     { s = build_fresh_set(large_ranges); large_ids.count { |id| s.include?(id) } }
      x.report("binary:")  { m = merge_ranges(large_ranges); large_ids.count { |id| fresh_binary?(id, m) } }
    end
  end

  # Solve with actual input if available
  if File.exist?(File.join(__dir__, 'input.txt'))
    input = File.read(File.join(__dir__, 'input.txt'))
    puts "\nPart 1: #{solve_part1(input)}"
  end
end
