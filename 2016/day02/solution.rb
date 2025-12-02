# Advent of Code 2016 - Day 2: Bathroom Security
# https://adventofcode.com/2016/day/2
#
# Navigate a keypad to find bathroom code
#
# Ruby idioms demonstrated:
# - Hash for keypad layout and movement
# - fetch with default for boundary handling
# - chars.each for character iteration
# - inject/reduce for state accumulation

class Day02
  # Part 1: Standard 3x3 keypad
  KEYPAD1 = {
    '1' => { 'U' => '1', 'D' => '4', 'L' => '1', 'R' => '2' },
    '2' => { 'U' => '2', 'D' => '5', 'L' => '1', 'R' => '3' },
    '3' => { 'U' => '3', 'D' => '6', 'L' => '2', 'R' => '3' },
    '4' => { 'U' => '1', 'D' => '7', 'L' => '4', 'R' => '5' },
    '5' => { 'U' => '2', 'D' => '8', 'L' => '4', 'R' => '6' },
    '6' => { 'U' => '3', 'D' => '9', 'L' => '5', 'R' => '6' },
    '7' => { 'U' => '4', 'D' => '7', 'L' => '7', 'R' => '8' },
    '8' => { 'U' => '5', 'D' => '8', 'L' => '7', 'R' => '9' },
    '9' => { 'U' => '6', 'D' => '9', 'L' => '8', 'R' => '9' }
  }.freeze

  # Part 2: Diamond keypad
  #     1
  #   2 3 4
  # 5 6 7 8 9
  #   A B C
  #     D
  KEYPAD2 = {
    '1' => { 'U' => '1', 'D' => '3', 'L' => '1', 'R' => '1' },
    '2' => { 'U' => '2', 'D' => '6', 'L' => '2', 'R' => '3' },
    '3' => { 'U' => '1', 'D' => '7', 'L' => '2', 'R' => '4' },
    '4' => { 'U' => '4', 'D' => '8', 'L' => '3', 'R' => '4' },
    '5' => { 'U' => '5', 'D' => '5', 'L' => '5', 'R' => '6' },
    '6' => { 'U' => '2', 'D' => 'A', 'L' => '5', 'R' => '7' },
    '7' => { 'U' => '3', 'D' => 'B', 'L' => '6', 'R' => '8' },
    '8' => { 'U' => '4', 'D' => 'C', 'L' => '7', 'R' => '9' },
    '9' => { 'U' => '9', 'D' => '9', 'L' => '8', 'R' => '9' },
    'A' => { 'U' => '6', 'D' => 'A', 'L' => 'A', 'R' => 'B' },
    'B' => { 'U' => '7', 'D' => 'D', 'L' => 'A', 'R' => 'C' },
    'C' => { 'U' => '8', 'D' => 'C', 'L' => 'B', 'R' => 'C' },
    'D' => { 'U' => 'B', 'D' => 'D', 'L' => 'D', 'R' => 'D' }
  }.freeze

  def initialize(input)
    @instructions = input.lines.map(&:strip)
  end

  # Part 1: Navigate standard keypad
  def part1
    solve_keypad(KEYPAD1, '5')
  end

  # Part 2: Navigate diamond keypad
  def part2
    solve_keypad(KEYPAD2, '5')
  end

  private

  # Solve for any keypad layout
  #
  # Idiomatic: inject builds code string, inner reduce handles each line
  def solve_keypad(keypad, start)
    @instructions.inject(['', start]) do |(code, pos), line|
      # Process each direction in the line
      final_pos = line.chars.reduce(pos) { |p, dir| keypad[p][dir] }
      [code + final_pos, final_pos]
    end.first
  end

  # Alternative: more explicit with each
  def solve_keypad_explicit(keypad, start)
    code = ''
    pos = start

    @instructions.each do |line|
      line.each_char { |dir| pos = keypad[pos][dir] }
      code += pos
    end

    code
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day02.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
