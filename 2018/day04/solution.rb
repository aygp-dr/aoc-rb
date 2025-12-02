# Advent of Code 2018 - Day 4: Repose Record
# https://adventofcode.com/2018/day/4
#
# Analyze guard sleep patterns
#
# Ruby idioms demonstrated:
# - sort for chronological ordering
# - group_by for organizing by guard
# - max_by for finding extremes
# - Range#each for minute iteration
# - Hash.new { Array.new } for nested defaults

class Day04
  def initialize(input)
    @events = input.lines.map(&:strip).sort.map { |line| parse_event(line) }
    @sleep_data = build_sleep_data
  end

  # Part 1: Guard with most minutes asleep * their most common minute
  #
  # Strategy 1: Find sleepiest guard, then their most common minute
  def part1
    guard_id = @sleep_data.max_by { |_id, minutes| minutes.sum }.first
    most_common_minute = find_most_common_minute(@sleep_data[guard_id])
    guard_id * most_common_minute
  end

  # Part 2: Guard most frequently asleep on same minute * that minute
  #
  # Strategy 2: Find (guard, minute) with highest frequency
  def part2
    best_guard = nil
    best_minute = nil
    best_count = 0

    @sleep_data.each do |guard_id, minutes|
      minute = minutes.each_with_index.max_by { |count, _| count }&.last
      count = minutes[minute] if minute

      if count && count > best_count
        best_guard = guard_id
        best_minute = minute
        best_count = count
      end
    end

    best_guard * best_minute
  end

  private

  def parse_event(line)
    time = line[/\d{4}-\d{2}-\d{2} \d{2}:(\d{2})/, 1].to_i  # Just need minute
    if line.include?('Guard')
      { type: :shift, guard: line[/Guard #(\d+)/, 1].to_i }
    elsif line.include?('falls')
      { type: :sleep, minute: time }
    else
      { type: :wake, minute: time }
    end
  end

  # Build hash: guard_id => array of 60 minute counts
  def build_sleep_data
    data = Hash.new { |h, k| h[k] = Array.new(60, 0) }
    current_guard = nil
    sleep_start = nil

    @events.each do |event|
      case event[:type]
      when :shift
        current_guard = event[:guard]
      when :sleep
        sleep_start = event[:minute]
      when :wake
        (sleep_start...event[:minute]).each { |m| data[current_guard][m] += 1 }
      end
    end

    data
  end

  def find_most_common_minute(minutes)
    minutes.each_with_index.max_by { |count, _| count }.last
  end
end

if __FILE__ == $0
  input = File.read(File.join(__dir__, 'input.txt'))
  solver = Day04.new(input)
  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
