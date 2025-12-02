# frozen_string_literal: true

# REPL Helpers - Shell-like commands and AoC utilities for IRB
# Load with: require_relative 'lib/repl_helpers'
# Or automatically via gmake repl

require 'fileutils'
require 'pathname'
require 'benchmark'

module ReplHelpers
  extend self

  # ============================================================
  # File System Navigation (shell-like commands)
  # ============================================================

  # List directory contents (ls equivalent)
  def ls(path = '.', long: false, all: false)
    pattern = all ? '{.,}*' : '*'
    entries = Dir.glob(File.join(path, pattern)).sort

    if long
      entries.each do |file|
        next if file.end_with?('/..') && !all

        stat = File.stat(file) rescue next
        type = File.directory?(file) ? 'd' : (File.symlink?(file) ? 'l' : '-')
        perms = format('%03o', stat.mode & 0o777)
        size = stat.size
        time = stat.mtime.strftime('%b %e %H:%M')
        name = File.basename(file)
        name += '/' if File.directory?(file)
        printf("%s%s %8d %s %s\n", type, perms, size, time, name)
      end
    else
      entries.map { |f| File.basename(f) + (File.directory?(f) ? '/' : '') }
    end
  end

  # Detailed ls (ls -l)
  def ll(path = '.')
    ls(path, long: true)
  end

  # List all including hidden (ls -a)
  def la(path = '.')
    ls(path, all: true)
  end

  # Print working directory
  def pwd
    Dir.pwd
  end

  # Change directory
  def cd(path = ENV['HOME'])
    Dir.chdir(File.expand_path(path))
    pwd
  end

  # Print file contents
  def cat(*files)
    files.each do |file|
      puts File.read(file)
    end
    nil
  end

  # Print first n lines
  def head(file, n = 10)
    File.readlines(file).first(n).each { |line| puts line }
    nil
  end

  # Print last n lines
  def tail(file, n = 10)
    File.readlines(file).last(n).each { |line| puts line }
    nil
  end

  # Word count (lines, words, chars)
  def wc(file)
    content = File.read(file)
    lines = content.lines.count
    words = content.split.count
    chars = content.length
    printf("%8d %8d %8d %s\n", lines, words, chars, file)
    { lines: lines, words: words, chars: chars }
  end

  # ============================================================
  # File Search (find/grep equivalents)
  # ============================================================

  # Find files by pattern
  def find(pattern = '*', path = '.')
    Dir.glob(File.join(path, '**', pattern))
  end

  # Grep in files
  def grep(pattern, *files)
    pattern = Regexp.new(pattern) if pattern.is_a?(String)
    files = Dir.glob('*') if files.empty?

    files.flatten.each do |file|
      next unless File.file?(file)

      File.readlines(file).each_with_index do |line, idx|
        if line.match?(pattern)
          puts "\e[35m#{file}\e[0m:\e[32m#{idx + 1}\e[0m: #{line.gsub(pattern) { |m| "\e[31m#{m}\e[0m" }}"
        end
      end
    end
    nil
  end

  # Recursive grep
  def rgrep(pattern, path = '.', glob: '**/*')
    files = Dir.glob(File.join(path, glob)).select { |f| File.file?(f) }
    grep(pattern, files)
  end

  # ============================================================
  # File Operations
  # ============================================================

  # Copy file(s)
  def cp(src, dest)
    FileUtils.cp(src, dest)
  end

  # Move/rename file(s)
  def mv(src, dest)
    FileUtils.mv(src, dest)
  end

  # Remove file(s)
  def rm(*files)
    FileUtils.rm(files)
  end

  # Make directory
  def mkdir(path)
    FileUtils.mkdir_p(path)
  end

  # Remove directory
  def rmdir(path)
    FileUtils.rm_rf(path)
  end

  # Touch file (create or update mtime)
  def touch(file)
    FileUtils.touch(file)
  end

  # ============================================================
  # AoC-Specific Helpers
  # ============================================================

  # Read input for a day
  def input(year_or_day, day = nil)
    if day
      year = year_or_day
      path = "#{year}/day#{day.to_s.rjust(2, '0')}/input.txt"
    else
      day = year_or_day
      # Try current directory first, then common locations
      paths = [
        "input.txt",
        "day#{day.to_s.rjust(2, '0')}/input.txt",
        "day#{day.to_s.rjust(2, '0')}_input.txt"
      ]
      path = paths.find { |p| File.exist?(p) } || paths.first
    end
    File.read(path).strip
  end

  # Read input as lines
  def lines(year_or_day, day = nil)
    input(year_or_day, day).lines.map(&:chomp)
  end

  # Read input as integers
  def ints(year_or_day, day = nil)
    lines(year_or_day, day).map(&:to_i)
  end

  # Read input as 2D grid
  def grid(year_or_day, day = nil)
    lines(year_or_day, day).map(&:chars)
  end

  # Read input as groups (separated by blank lines)
  def groups(year_or_day, day = nil)
    input(year_or_day, day).split("\n\n").map { |g| g.lines.map(&:chomp) }
  end

  # Parse integers from a string
  def extract_ints(str)
    str.scan(/-?\d+/).map(&:to_i)
  end

  # ============================================================
  # Benchmarking and Timing
  # ============================================================

  # Time a block
  def time(label = 'Block', &block)
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    result = block.call
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
    puts "#{label}: #{(elapsed * 1000).round(3)}ms"
    result
  end

  # Compare multiple approaches
  def compare(iterations: 100, **approaches)
    Benchmark.bmbm(20) do |x|
      approaches.each do |name, block|
        x.report("#{name}:") { iterations.times { block.call } }
      end
    end
  end

  # ============================================================
  # Object Inspection
  # ============================================================

  # Pretty print with truncation
  def pp_short(obj, max_length: 100)
    str = obj.inspect
    str.length > max_length ? "#{str[0...max_length]}..." : str
  end

  # Show methods matching pattern
  def methods_matching(obj, pattern)
    obj.methods.grep(Regexp.new(pattern.to_s)).sort
  end

  # Source location of a method
  def where(obj, method_name)
    m = obj.method(method_name)
    loc = m.source_location
    if loc
      puts "#{m.owner}##{m.name}"
      puts "  #{loc.join(':')}"
    else
      puts "#{m.owner}##{m.name} (native)"
    end
  end

  # ============================================================
  # Shell Command Execution
  # ============================================================

  # Execute shell command and return output
  def sh(cmd)
    `#{cmd}`.chomp
  end

  # Execute shell command with live output
  def shell(cmd)
    system(cmd)
  end

  # ============================================================
  # Clipboard Operations (if available)
  # ============================================================

  # Copy to clipboard (macOS/Linux)
  def pbcopy(text)
    cmd = RUBY_PLATFORM.include?('darwin') ? 'pbcopy' : 'xclip -selection clipboard'
    IO.popen(cmd, 'w') { |io| io.write(text) }
    text
  end

  # Paste from clipboard
  def pbpaste
    cmd = RUBY_PLATFORM.include?('darwin') ? 'pbpaste' : 'xclip -selection clipboard -o'
    `#{cmd}`.chomp
  end

  # ============================================================
  # History and Session
  # ============================================================

  # Clear screen
  def clear
    system('clear') || system('cls')
  end

  # Reload file
  def reload(file)
    load file
  end

  # Show Ruby version info
  def ruby_info
    puts "Ruby: #{RUBY_VERSION} (#{RUBY_PLATFORM})"
    puts "PWD:  #{Dir.pwd}"
    puts "PID:  #{Process.pid}"
  end

  # ============================================================
  # Data Structure Helpers
  # ============================================================

  # Pretty table display
  def table(data, headers: nil)
    return if data.empty?

    data = [headers] + data if headers
    widths = data.transpose.map { |col| col.map { |c| c.to_s.length }.max }

    data.each_with_index do |row, i|
      puts row.zip(widths).map { |cell, w| cell.to_s.ljust(w) }.join(' | ')
      puts widths.map { |w| '-' * w }.join('-+-') if headers && i == 0
    end
    nil
  end

  # Histogram of values
  def histogram(data, width: 40)
    counts = data.tally.sort_by { |k, _| k }
    max_count = counts.map(&:last).max
    max_label = counts.map { |k, _| k.to_s.length }.max

    counts.each do |value, count|
      bar_width = (count.to_f / max_count * width).round
      printf "%#{max_label}s | %s %d\n", value, '#' * bar_width, count
    end
    nil
  end

  # Frequencies with percentages
  def freq(data)
    total = data.size.to_f
    data.tally.sort_by { |_, v| -v }.each do |value, count|
      printf "%6.2f%% (%4d) %s\n", count / total * 100, count, value.inspect
    end
    nil
  end

  # ============================================================
  # Math Helpers
  # ============================================================

  # Greatest common divisor
  def gcd(a, b)
    b.zero? ? a.abs : gcd(b, a % b)
  end

  # Least common multiple
  def lcm(a, b)
    (a * b).abs / gcd(a, b)
  end

  # Prime check
  def prime?(n)
    return false if n < 2
    return true if n == 2
    return false if n.even?

    (3..Math.sqrt(n).to_i).step(2).none? { |i| (n % i).zero? }
  end

  # Divisors
  def divisors(n)
    (1..Math.sqrt(n)).each_with_object([]) do |i, divs|
      if (n % i).zero?
        divs << i
        divs << n / i if i != n / i
      end
    end.sort
  end

  # ============================================================
  # String/Parsing Helpers
  # ============================================================

  # Parse integers from string
  def nums(str)
    str.scan(/-?\d+/).map(&:to_i)
  end

  # Parse floats from string
  def floats(str)
    str.scan(/-?\d+\.?\d*/).map(&:to_f)
  end

  # Split on whitespace, multiple spaces ok
  def words(str)
    str.split
  end

  # Character frequency
  def char_freq(str)
    str.chars.tally.sort_by { |_, v| -v }
  end

  # ============================================================
  # Complex Number Navigation (for 2D grid problems)
  # ============================================================

  # Direction constants as Complex numbers
  # Complex(real, imag) where real=col(x), imag=row(y)
  # Note: "up" decreases row in typical grid representation
  NORTH = Complex(0, -1)
  SOUTH = Complex(0, 1)
  EAST  = Complex(1, 0)
  WEST  = Complex(-1, 0)

  # Aliases for different conventions
  UP    = NORTH
  DOWN  = SOUTH
  RIGHT = EAST
  LEFT  = WEST

  # Cardinal directions array (for iteration)
  CARDINALS = [NORTH, EAST, SOUTH, WEST].freeze
  DIAGONALS = [Complex(1, -1), Complex(1, 1), Complex(-1, 1), Complex(-1, -1)].freeze
  ALL_DIRS  = (CARDINALS + DIAGONALS).freeze

  # Turn 90 degrees
  def turn_right(dir)
    dir * Complex(0, 1)  # Multiply by i rotates 90° clockwise
  end

  def turn_left(dir)
    dir * Complex(0, -1) # Multiply by -i rotates 90° counter-clockwise
  end

  def turn_around(dir)
    -dir
  end

  # Parse direction from character
  def parse_dir(char)
    case char.to_s.upcase
    when 'N', 'U', '^' then NORTH
    when 'S', 'D', 'v' then SOUTH
    when 'E', 'R', '>' then EAST
    when 'W', 'L', '<' then WEST
    else raise ArgumentError, "Unknown direction: #{char}"
    end
  end

  # Manhattan distance for complex numbers
  def manhattan(c1, c2 = Complex(0, 0))
    (c1.real - c2.real).abs + (c1.imag - c2.imag).abs
  end

  # Convert between [row, col] and Complex
  def to_complex(row, col)
    Complex(col, row)
  end

  def to_rc(c)
    [c.imag.to_i, c.real.to_i]
  end

  # Get neighbors as complex numbers
  def neighbors4(pos)
    CARDINALS.map { |d| pos + d }
  end

  def neighbors8(pos)
    ALL_DIRS.map { |d| pos + d }
  end

  # ============================================================
  # Position-Aware Scanning (for schematic/grid problems)
  # ============================================================

  # Scan with positions - returns [[match, line_num, col_start, col_end], ...]
  def scan_positions(text, pattern)
    pattern = Regexp.new(pattern) if pattern.is_a?(String)
    results = []

    text.lines.each_with_index do |line, line_num|
      line.to_enum(:scan, pattern).each do
        m = Regexp.last_match
        results << [m[0], line_num, m.begin(0), m.end(0) - 1]
      end
    end

    results
  end

  # Find all numbers with their positions
  def scan_numbers(text)
    scan_positions(text, /-?\d+/).map { |m, r, c1, c2| [m.to_i, r, c1, c2] }
  end

  # Find symbols (non-digit, non-period, non-newline)
  def scan_symbols(text)
    scan_positions(text, /[^\d.\n]/)
  end

  # Check if position is adjacent to any in a set (for gear problems)
  def adjacent_to?(row, col, positions, include_diag: true)
    deltas = include_diag ? [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]] : [[-1,0],[0,-1],[0,1],[1,0]]
    deltas.any? { |dr, dc| positions.include?([row + dr, col + dc]) }
  end

  # Get all adjacent positions for a span (like a multi-digit number)
  def span_neighbors(row, col_start, col_end, include_diag: true)
    neighbors = Set.new
    (col_start..col_end).each do |col|
      deltas = include_diag ? [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]] : [[-1,0],[0,-1],[0,1],[1,0]]
      deltas.each { |dr, dc| neighbors << [row + dr, col + dc] }
    end
    # Remove the span itself
    (col_start..col_end).each { |c| neighbors.delete([row, c]) }
    neighbors
  end

  # ============================================================
  # Cycle Detection Shortcuts (expose aoc_utils helpers)
  # ============================================================

  # Detect cycle and return [cycle_start, cycle_length]
  def detect_cycle(initial, &next_state)
    seen = { initial => 0 }
    state = initial
    step = 0

    loop do
      step += 1
      state = next_state.call(state)

      if seen.key?(state)
        cycle_start = seen[state]
        cycle_length = step - cycle_start
        return { start: cycle_start, length: cycle_length, state: state }
      end

      seen[state] = step
    end
  end

  # Fast-forward to iteration N using cycle detection
  def fast_forward(initial, n, &next_state)
    cycle = detect_cycle(initial, &next_state)

    if n < cycle[:start]
      state = initial
      n.times { state = next_state.call(state) }
      return state
    end

    remaining = (n - cycle[:start]) % cycle[:length]
    state = initial
    (cycle[:start] + remaining).times { state = next_state.call(state) }
    state
  end

  # ============================================================
  # Range/Interval Helpers
  # ============================================================

  # Check if two ranges overlap
  def ranges_overlap?(r1, r2)
    r1.cover?(r2.begin) || r2.cover?(r1.begin)
  end

  # Get intersection of two ranges (nil if no overlap)
  def range_intersect(r1, r2)
    return nil unless ranges_overlap?(r1, r2)
    ([r1.begin, r2.begin].max)..([r1.end, r2.end].min)
  end

  # Merge overlapping/adjacent ranges
  def merge_ranges(ranges)
    sorted = ranges.sort_by(&:begin)
    merged = [sorted.first]

    sorted[1..].each do |range|
      if merged.last.end >= range.begin - 1
        merged[-1] = (merged.last.begin..[merged.last.end, range.end].max)
      else
        merged << range
      end
    end

    merged
  end

  # Subtract range r2 from r1 (returns array of remaining ranges)
  def range_subtract(r1, r2)
    return [r1] unless ranges_overlap?(r1, r2)

    result = []
    result << (r1.begin..(r2.begin - 1)) if r1.begin < r2.begin
    result << ((r2.end + 1)..r1.end) if r1.end > r2.end
    result
  end

  # ============================================================
  # Modular Arithmetic / Dial Problems
  # ============================================================

  # Simulate positions on a circular dial
  def dial_positions(start, turns, mod: 100)
    turns.reduce([start]) { |acc, t| acc << ((acc.last + t) % mod) }
  end

  # Count how many times we cross/land on a target during rotation
  # Note: "crossing" means passing through target, landing on it counts as crossing once
  def count_crossings(start, turn, target: 0, mod: 100)
    return 0 if turn == 0

    end_pos = (start + turn) % mod

    # Complete cycles (each full rotation crosses target once)
    complete_cycles = turn.abs / mod

    # Does the partial rotation cross target?
    # For right turn (positive): we cross 0 if we wrap (start > end_pos)
    # For left turn (negative): we cross 0 if we wrap (start < end_pos)
    # But if we START at target, that doesn't count as a crossing
    # If we END at target, that DOES count (we crossed onto it)
    partial = turn.abs % mod

    crosses = if turn > 0 # Clockwise/right
                # Cross 0 if: start to end wraps, OR end == target
                (end_pos < start && target < start && target >= end_pos) ||
                (end_pos < start && target >= end_pos && start != target) ? 1 : 0
              else # Counter-clockwise/left
                (end_pos > start && target > start && target <= end_pos) ||
                (end_pos > start && target <= end_pos && start != target) ? 1 : 0
              end

    # Simpler approach: just check if target is in the arc we traveled
    # Actually let me use the original simpler logic but not double-count
    crosses = if turn > 0
                (start > end_pos || end_pos == target) && start != target ? 1 : 0
              else
                (start < end_pos || end_pos == target) && start != target ? 1 : 0
              end

    complete_cycles + crosses
  end

  # Solve dial rotation problem (Part 2 style - count all crossings)
  def dial_solve(start, turns, target: 0, mod: 100, verbose: false)
    pos = start
    total = 0

    turns.each do |turn|
      crossings = count_crossings(pos, turn, target: target, mod: mod)
      new_pos = (pos + turn) % mod
      puts "pos=#{pos}, turn=#{turn}, new=#{new_pos}, crossings=#{crossings}" if verbose
      total += crossings
      pos = new_pos
    end

    total
  end

  # ============================================================
  # Debug Printing
  # ============================================================

  # Debug print with label
  def d(label, value = nil)
    if value.nil?
      puts "DEBUG: #{label.inspect}"
    else
      puts "#{label}: #{value.inspect}"
    end
    value || label
  end

  # Print grid nicely
  def print_grid(grid, sep: '')
    grid.each { |row| puts row.join(sep) }
    nil
  end

  # Highlight positions in grid
  def highlight_grid(grid, positions, char: "\e[31m%s\e[0m")
    positions = positions.to_set if positions.respond_to?(:to_set)
    grid.each_with_index do |row, r|
      line = row.each_with_index.map do |cell, c|
        positions.include?([r, c]) ? (char % cell) : cell
      end.join
      puts line
    end
    nil
  end
end

# Include helpers at top level for convenience
include ReplHelpers

# Print welcome message
puts "REPL Helpers loaded! Available commands:"
puts "  Navigation: ls, ll, la, pwd, cd, cat, head, tail, wc"
puts "  Search:     find, grep, rgrep"
puts "  Files:      cp, mv, rm, mkdir, rmdir, touch"
puts "  AoC:        input, lines, ints, grid, groups, extract_ints"
puts "  Parse:      nums, floats, words, char_freq, scan_numbers, scan_symbols"
puts "  Math:       gcd, lcm, prime?, divisors, manhattan"
puts "  Directions: NORTH/SOUTH/EAST/WEST, turn_left, turn_right, parse_dir"
puts "  Complex:    to_complex, to_rc, neighbors4, neighbors8"
puts "  Ranges:     ranges_overlap?, range_intersect, merge_ranges, range_subtract"
puts "  Cycles:     detect_cycle, fast_forward"
puts "  Dial:       dial_positions, dial_solve, count_crossings"
puts "  Display:    table, histogram, freq, print_grid, highlight_grid"
puts "  Debug:      time, compare, where, methods_matching, d"
puts "  Shell:      sh, shell, clear, pbcopy, pbpaste"
puts ""
