# frozen_string_literal: true

# Advent of Code Ruby Utilities
# Load with: require_relative 'lib/aoc_utils'

module AocUtils
  # ============================================================
  # Input Reading
  # ============================================================

  def self.read_input(year, day)
    day_str = day.to_s.rjust(2, '0')
    File.read("#{year}/day#{day_str}/input.txt").strip
  end

  def self.read_lines(year, day)
    read_input(year, day).lines.map(&:chomp)
  end

  def self.read_integers(year, day)
    read_lines(year, day).map(&:to_i)
  end

  def self.read_grid(year, day)
    read_lines(year, day).map(&:chars)
  end

  def self.read_groups(year, day)
    read_input(year, day).split("\n\n").map { |g| g.lines.map(&:chomp) }
  end

  # ============================================================
  # Math Utilities
  # ============================================================

  def self.gcd(a, b)
    b.zero? ? a.abs : gcd(b, a % b)
  end

  def self.lcm(a, b)
    (a * b).abs / gcd(a, b)
  end

  def self.lcm_array(arr)
    arr.reduce(1) { |acc, n| lcm(acc, n) }
  end

  def self.mod_inverse(a, m)
    # Extended Euclidean Algorithm
    return 1 if m == 1

    m0, x0, x1 = m, 0, 1
    while a > 1
      q = a / m
      m, a = a % m, m
      x0, x1 = x1 - q * x0, x0
    end
    x1 += m0 if x1 < 0
    x1
  end

  def self.chinese_remainder_theorem(remainders, moduli)
    # Solve system of congruences: x ≡ r_i (mod m_i)
    prod = moduli.reduce(:*)
    remainders.zip(moduli).sum do |r, m|
      p = prod / m
      r * mod_inverse(p, m) * p
    end % prod
  end

  # Modular exponentiation: (base^exp) % mod
  def self.mod_pow(base, exp, mod)
    result = 1
    base = base % mod

    while exp > 0
      result = (result * base) % mod if exp.odd?
      exp >>= 1
      base = (base * base) % mod
    end

    result
  end

  # Prime check
  def self.prime?(n)
    return false if n < 2
    return true if n == 2
    return false if n.even?

    (3..Math.sqrt(n).to_i).step(2).none? { |i| (n % i).zero? }
  end

  # Prime factors
  def self.prime_factors(n)
    factors = []
    d = 2

    while d * d <= n
      while (n % d).zero?
        factors << d
        n /= d
      end
      d += 1
    end

    factors << n if n > 1
    factors
  end

  # Divisors of n
  def self.divisors(n)
    result = []
    (1..Math.sqrt(n).to_i).each do |i|
      if (n % i).zero?
        result << i
        result << n / i if i != n / i
      end
    end
    result.sort
  end

  # Sum of divisors
  def self.sum_of_divisors(n)
    divisors(n).sum
  end

  # Factorial
  def self.factorial(n)
    (1..n).reduce(1, :*)
  end

  # Binomial coefficient (n choose k)
  def self.binomial(n, k)
    return 0 if k > n
    return 1 if k == 0 || k == n

    # Use symmetry to minimize calculations
    k = n - k if k > n - k

    result = 1
    (0...k).each do |i|
      result = result * (n - i) / (i + 1)
    end
    result
  end

  # Fibonacci (with memoization)
  def self.fibonacci(n, memo = {})
    return n if n <= 1

    memo[n] ||= fibonacci(n - 1, memo) + fibonacci(n - 2, memo)
  end

  # ============================================================
  # Distance Functions
  # ============================================================

  def self.manhattan_distance(p1, p2)
    p1.zip(p2).sum { |a, b| (a - b).abs }
  end

  def self.chebyshev_distance(p1, p2)
    p1.zip(p2).map { |a, b| (a - b).abs }.max
  end

  def self.euclidean_distance(p1, p2)
    Math.sqrt(p1.zip(p2).sum { |a, b| (a - b)**2 })
  end

  # ============================================================
  # Grid Helpers
  # ============================================================

  # Cardinal directions [dr, dc] - row/col deltas
  DIRECTIONS_4 = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze
  DIRECTIONS_8 = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

  # Short aliases for convenience
  DIRS_4 = DIRECTIONS_4
  DIRS_8 = DIRECTIONS_8

  # Named direction mapping
  DIRECTION_NAMES = { 'N' => [-1, 0], 'S' => [1, 0], 'E' => [0, 1], 'W' => [0, -1],
                      'U' => [-1, 0], 'D' => [1, 0], 'R' => [0, 1], 'L' => [0, -1] }.freeze

  def self.neighbors_4(row, col)
    DIRECTIONS_4.map { |dr, dc| [row + dr, col + dc] }
  end

  def self.neighbors_8(row, col)
    DIRECTIONS_8.map { |dr, dc| [row + dr, col + dc] }
  end

  def self.in_bounds?(grid, row, col)
    row >= 0 && col >= 0 && row < grid.length && col < grid[0].length
  end

  def self.grid_find(grid, char)
    grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        return [r, c] if cell == char
      end
    end
    nil
  end

  def self.grid_find_all(grid, char)
    results = []
    grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        results << [r, c] if cell == char
      end
    end
    results
  end

  def self.rotate_grid_cw(grid)
    grid.transpose.map(&:reverse)
  end

  def self.rotate_grid_ccw(grid)
    grid.transpose.reverse
  end

  def self.flip_horizontal(grid)
    grid.map(&:reverse)
  end

  def self.flip_vertical(grid)
    grid.reverse
  end

  # ============================================================
  # Graph Algorithms
  # ============================================================

  # BFS - returns distances from start to all reachable nodes
  def self.bfs(start, neighbors_proc)
    distances = { start => 0 }
    queue = [start]

    until queue.empty?
      current = queue.shift
      neighbors_proc.call(current).each do |neighbor|
        next if distances.key?(neighbor)

        distances[neighbor] = distances[current] + 1
        queue << neighbor
      end
    end

    distances
  end

  # Dijkstra's algorithm - returns distances from start
  def self.dijkstra(start, neighbors_proc)
    require 'set'
    distances = Hash.new(Float::INFINITY)
    distances[start] = 0
    visited = Set.new
    pq = [[0, start]] # [distance, node]

    until pq.empty?
      pq.sort_by!(&:first)
      dist, current = pq.shift

      next if visited.include?(current)

      visited << current

      neighbors_proc.call(current).each do |neighbor, cost|
        new_dist = dist + cost
        if new_dist < distances[neighbor]
          distances[neighbor] = new_dist
          pq << [new_dist, neighbor]
        end
      end
    end

    distances
  end

  # A* search - returns shortest path length or nil
  def self.astar(start, goal, neighbors_proc, heuristic_proc)
    require 'set'
    g_score = Hash.new(Float::INFINITY)
    g_score[start] = 0
    f_score = Hash.new(Float::INFINITY)
    f_score[start] = heuristic_proc.call(start)

    open_set = [[f_score[start], start]]
    closed_set = Set.new

    until open_set.empty?
      open_set.sort_by!(&:first)
      _, current = open_set.shift

      return g_score[current] if current == goal
      next if closed_set.include?(current)

      closed_set << current

      neighbors_proc.call(current).each do |neighbor, cost|
        tentative_g = g_score[current] + cost
        if tentative_g < g_score[neighbor]
          g_score[neighbor] = tentative_g
          f_score[neighbor] = tentative_g + heuristic_proc.call(neighbor)
          open_set << [f_score[neighbor], neighbor]
        end
      end
    end

    nil
  end

  # Topological sort (Kahn's algorithm)
  def self.topological_sort(nodes, edges)
    in_degree = Hash.new(0)
    adjacency = Hash.new { |h, k| h[k] = [] }

    edges.each do |from, to|
      adjacency[from] << to
      in_degree[to] += 1
    end

    queue = nodes.select { |n| in_degree[n].zero? }
    result = []

    until queue.empty?
      node = queue.shift
      result << node
      adjacency[node].each do |neighbor|
        in_degree[neighbor] -= 1
        queue << neighbor if in_degree[neighbor].zero?
      end
    end

    result.length == nodes.length ? result : nil # nil if cycle detected
  end

  # ============================================================
  # Parsing Helpers
  # ============================================================

  def self.extract_integers(str)
    str.scan(/-?\d+/).map(&:to_i)
  end

  def self.extract_words(str)
    str.scan(/[a-zA-Z]+/)
  end

  # ============================================================
  # Combinatorics
  # ============================================================

  # All permutations of an array
  def self.permutations(arr)
    arr.permutation.to_a
  end

  # All combinations of size k
  def self.combinations(arr, k)
    arr.combination(k).to_a
  end

  # Cartesian product of arrays
  def self.cartesian_product(*arrays)
    arrays[0].product(*arrays[1..])
  end

  # Power set (all subsets)
  def self.power_set(arr)
    (0..arr.length).flat_map { |k| arr.combination(k).to_a }
  end

  # ============================================================
  # Sequence/Range Utilities
  # ============================================================

  # Check if ranges overlap
  def self.ranges_overlap?(r1, r2)
    r1.cover?(r2.begin) || r2.cover?(r1.begin)
  end

  # Merge overlapping ranges
  def self.merge_ranges(ranges)
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

  # Find cycle in sequence (returns [cycle_start, cycle_length])
  def self.find_cycle(initial_state, next_state_proc)
    seen = { initial_state => 0 }
    state = initial_state
    step = 0

    loop do
      step += 1
      state = next_state_proc.call(state)

      if seen.key?(state)
        cycle_start = seen[state]
        cycle_length = step - cycle_start
        return [cycle_start, cycle_length, state]
      end

      seen[state] = step
    end
  end

  # Get state after n iterations using cycle detection
  def self.state_after_n(initial_state, n, next_state_proc)
    cycle_start, cycle_length, _ = find_cycle(initial_state, next_state_proc)

    # If n is before cycle starts, just iterate
    if n < cycle_start
      state = initial_state
      n.times { state = next_state_proc.call(state) }
      return state
    end

    # Find equivalent position in cycle
    remaining = (n - cycle_start) % cycle_length
    state = initial_state
    (cycle_start + remaining).times { state = next_state_proc.call(state) }
    state
  end

  # ============================================================
  # String Utilities
  # ============================================================

  # Count character frequencies
  def self.char_frequencies(str)
    str.chars.tally
  end

  # Check if string is palindrome
  def self.palindrome?(str)
    str == str.reverse
  end

  # Hamming distance between two strings
  def self.hamming_distance(s1, s2)
    s1.chars.zip(s2.chars).count { |a, b| a != b }
  end

  # Levenshtein edit distance
  def self.edit_distance(s1, s2)
    m, n = s1.length, s2.length
    dp = Array.new(m + 1) { Array.new(n + 1, 0) }

    (0..m).each { |i| dp[i][0] = i }
    (0..n).each { |j| dp[0][j] = j }

    (1..m).each do |i|
      (1..n).each do |j|
        cost = s1[i - 1] == s2[j - 1] ? 0 : 1
        dp[i][j] = [
          dp[i - 1][j] + 1,      # deletion
          dp[i][j - 1] + 1,      # insertion
          dp[i - 1][j - 1] + cost # substitution
        ].min
      end
    end

    dp[m][n]
  end

  # ============================================================
  # Binary/Bit Operations
  # ============================================================

  # Count set bits
  def self.popcount(n)
    n.to_s(2).count('1')
  end

  # Get bit at position
  def self.get_bit(n, pos)
    (n >> pos) & 1
  end

  # Set bit at position
  def self.set_bit(n, pos)
    n | (1 << pos)
  end

  # Clear bit at position
  def self.clear_bit(n, pos)
    n & ~(1 << pos)
  end

  # Toggle bit at position
  def self.toggle_bit(n, pos)
    n ^ (1 << pos)
  end

  # Binary string to integer
  def self.bin_to_int(str)
    str.to_i(2)
  end

  # Integer to binary string
  def self.int_to_bin(n, width = nil)
    width ? n.to_s(2).rjust(width, '0') : n.to_s(2)
  end

  # ============================================================
  # Hash/Digest (for puzzles like 2015 Day 4)
  # ============================================================

  def self.md5(str)
    require 'digest'
    Digest::MD5.hexdigest(str)
  end

  def self.sha256(str)
    require 'digest'
    Digest::SHA256.hexdigest(str)
  end

  # ============================================================
  # Flood Fill / Connected Components
  # ============================================================

  def self.flood_fill(grid, start_row, start_col, target = nil, &block)
    require 'set'
    target ||= grid[start_row][start_col]
    visited = Set.new
    queue = [[start_row, start_col]]

    while (pos = queue.shift)
      row, col = pos
      next if visited.include?(pos)
      next unless in_bounds?(grid, row, col)
      next unless grid[row][col] == target

      visited << pos
      block.call(row, col) if block_given?

      neighbors_4(row, col).each { |n| queue << n }
    end

    visited
  end

  # Find all connected components in a grid
  def self.connected_components(grid, passable_chars = nil)
    require 'set'
    visited = Set.new
    components = []

    grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        next if visited.include?([r, c])
        next if passable_chars && !passable_chars.include?(cell)

        component = flood_fill(grid, r, c, cell)
        components << component unless component.empty?
        visited.merge(component)
      end
    end

    components
  end

  # ============================================================
  # Geometry
  # ============================================================

  # Shoelace formula for polygon area
  def self.polygon_area(vertices)
    n = vertices.length
    sum = 0

    (0...n).each do |i|
      j = (i + 1) % n
      sum += vertices[i][0] * vertices[j][1]
      sum -= vertices[j][0] * vertices[i][1]
    end

    sum.abs / 2.0
  end

  # Pick's theorem: interior points from area and boundary points
  # A = i + b/2 - 1, so i = A - b/2 + 1
  def self.interior_points(area, boundary_points)
    area - boundary_points / 2 + 1
  end

  # Point in polygon (ray casting)
  def self.point_in_polygon?(point, polygon)
    x, y = point
    n = polygon.length
    inside = false

    j = n - 1
    (0...n).each do |i|
      xi, yi = polygon[i]
      xj, yj = polygon[j]

      if ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
        inside = !inside
      end

      j = i
    end

    inside
  end

  # ============================================================
  # Interval/Coordinate Compression
  # ============================================================

  def self.compress_coordinates(values)
    sorted = values.uniq.sort
    mapping = sorted.each_with_index.to_h
    [mapping, sorted]
  end

  # ============================================================
  # Memoization
  # ============================================================

  def self.memoize(obj, method_name)
    original = obj.method(method_name)
    cache = {}

    obj.define_singleton_method(method_name) do |*args|
      cache[args] ||= original.call(*args)
    end
  end

  # ============================================================
  # Debug Helpers
  # ============================================================

  def self.print_grid(grid, highlight: {})
    grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        if highlight[[r, c]]
          print "\e[31m#{cell}\e[0m" # Red highlight
        else
          print cell
        end
      end
      puts
    end
  end

  def self.benchmark(label = nil, &block)
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    result = block.call
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
    puts "#{label || 'Elapsed'}: #{(elapsed * 1000).round(2)}ms"
    result
  end
end

# Convenience class for grid-based problems
class Grid
  attr_reader :data, :height, :width

  def initialize(input)
    @data = input.is_a?(String) ? input.strip.lines.map { |l| l.chomp.chars } : input
    @height = @data.length
    @width = @data[0]&.length || 0
  end

  def [](row, col = nil)
    if col
      return nil unless in_bounds?(row, col)

      @data[row][col]
    else
      @data[row]
    end
  end

  def []=(row, col, val)
    @data[row][col] = val if in_bounds?(row, col)
  end

  def in_bounds?(row, col)
    row >= 0 && col >= 0 && row < @height && col < @width
  end

  def neighbors_4(row, col)
    AocUtils::DIRECTIONS_4.map { |dr, dc| [row + dr, col + dc] }
                          .select { |r, c| in_bounds?(r, c) }
  end

  def neighbors_8(row, col)
    AocUtils::DIRECTIONS_8.map { |dr, dc| [row + dr, col + dc] }
                          .select { |r, c| in_bounds?(r, c) }
  end

  def find(char)
    each_cell { |r, c, v| return [r, c] if v == char }
    nil
  end

  def find_all(char)
    results = []
    each_cell { |r, c, v| results << [r, c] if v == char }
    results
  end

  def each_cell
    @data.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        yield r, c, cell
      end
    end
  end

  def to_s
    @data.map(&:join).join("\n")
  end

  def dup
    Grid.new(@data.map(&:dup))
  end
end

# Priority Queue for Dijkstra/A*
class PriorityQueue
  def initialize
    @heap = []
  end

  def push(priority, item)
    @heap << [priority, item]
    bubble_up(@heap.length - 1)
  end

  def pop
    return nil if @heap.empty?

    swap(0, @heap.length - 1)
    priority, item = @heap.pop
    bubble_down(0) unless @heap.empty?
    [priority, item]
  end

  def empty?
    @heap.empty?
  end

  def length
    @heap.length
  end

  private

  def bubble_up(index)
    parent = (index - 1) / 2
    return if index <= 0 || @heap[parent][0] <= @heap[index][0]

    swap(index, parent)
    bubble_up(parent)
  end

  def bubble_down(index)
    left = 2 * index + 1
    right = 2 * index + 2
    smallest = index

    smallest = left if left < @heap.length && @heap[left][0] < @heap[smallest][0]
    smallest = right if right < @heap.length && @heap[right][0] < @heap[smallest][0]

    return if smallest == index

    swap(index, smallest)
    bubble_down(smallest)
  end

  def swap(i, j)
    @heap[i], @heap[j] = @heap[j], @heap[i]
  end
end
