# Advent of Code 2018 - Day 3: No Matter How You Slice It
# https://adventofcode.com/2018/day/3
#
# Find overlapping fabric claims
#
# Ruby idioms demonstrated:
# - Hash with default value for counting
# - Regex with named captures for parsing
# - Range#each for iteration
# - count vs select.size
# - none? for checking uniqueness

class Day03
  CLAIM_PATTERN = /#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)/

  def initialize(input)
    @claims = input.lines.map { |line| parse_claim(line) }
  end

  # Part 1: Count square inches with 2+ claims
  #
  # Idiomatic: Hash.new(0) for counting, then count values >= 2
  def part1
    fabric = Hash.new(0)

    @claims.each do |claim|
      each_cell(claim) { |x, y| fabric[[x, y]] += 1 }
    end

    fabric.values.count { |v| v >= 2 }
  end

  # Part 2: Find claim that doesn't overlap with any other
  #
  # Idiomatic: find + none? for searching with condition
  def part2
    fabric = Hash.new(0)

    # First pass: count all claims per cell
    @claims.each do |claim|
      each_cell(claim) { |x, y| fabric[[x, y]] += 1 }
    end

    # Find claim where all cells have count 1
    @claims.find do |claim|
      all_cells_unique?(claim, fabric)
    end[:id]
  end

  private

  def parse_claim(line)
    match = line.match(CLAIM_PATTERN)
    {
      id: match[:id].to_i,
      x: match[:x].to_i,
      y: match[:y].to_i,
      w: match[:w].to_i,
      h: match[:h].to_i
    }
  end

  # Iterate over all cells in a claim
  def each_cell(claim)
    (claim[:x]...claim[:x] + claim[:w]).each do |x|
      (claim[:y]...claim[:y] + claim[:h]).each do |y|
        yield x, y
      end
    end
  end

  # Check if all cells in claim have count 1 (no overlap)
  def all_cells_unique?(claim, fabric)
    (claim[:x]...claim[:x] + claim[:w]).all? do |x|
      (claim[:y]...claim[:y] + claim[:h]).all? do |y|
        fabric[[x, y]] == 1
      end
    end
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day03.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
