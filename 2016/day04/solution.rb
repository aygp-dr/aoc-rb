# Advent of Code 2016 - Day 4: Security Through Obscurity
# https://adventofcode.com/2016/day/4
#
# Validate room names with checksums
#
# Ruby idioms demonstrated:
# - tally for character frequency
# - sort_by with multiple criteria
# - match with named captures
# - gsub with block for decryption
# - String#ord and Integer#chr for character math

class Day04
  ROOM_PATTERN = /^(?<name>[a-z-]+)-(?<sector>\d+)\[(?<checksum>[a-z]+)\]$/

  def initialize(input)
    @rooms = input.lines.map { |line| parse_room(line.strip) }.compact
  end

  # Part 1: Sum sector IDs of real rooms
  def part1
    @rooms.select { |room| valid_room?(room) }.sum { |room| room[:sector] }
  end

  # Part 2: Find room where decrypted name contains "north"
  def part2
    @rooms.find do |room|
      valid_room?(room) && decrypt(room[:name], room[:sector]).include?('north')
    end&.dig(:sector)
  end

  private

  def parse_room(line)
    match = line.match(ROOM_PATTERN)
    return nil unless match

    {
      name: match[:name],
      sector: match[:sector].to_i,
      checksum: match[:checksum]
    }
  end

  # Check if checksum matches top 5 letters by frequency
  #
  # Idiomatic: tally + sort_by with compound key
  def valid_room?(room)
    letters = room[:name].delete('-')

    # Get frequency of each letter
    freq = letters.chars.tally

    # Sort by: frequency descending, then letter ascending
    # Take top 5, join to form expected checksum
    expected = freq.sort_by { |char, count| [-count, char] }
                   .take(5)
                   .map(&:first)
                   .join

    expected == room[:checksum]
  end

  # Decrypt room name using Caesar cipher with sector ID as shift
  #
  # Idiomatic: gsub with block, ord/chr for character rotation
  def decrypt(name, shift)
    name.gsub(/[a-z]/) do |char|
      # Rotate character by shift positions (wrapping at 'z')
      ((char.ord - 'a'.ord + shift) % 26 + 'a'.ord).chr
    end.tr('-', ' ')
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day04.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
