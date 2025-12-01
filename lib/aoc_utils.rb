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

  DIRECTIONS_4 = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze
  DIRECTIONS_8 = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze
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
