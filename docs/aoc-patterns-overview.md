# Advent of Code: Patterns & Tools Reference

A comprehensive guide to common patterns, algorithms, and data structures encountered across 10 years of Advent of Code (2015-2024), with Ruby REPL helpers for interactive problem solving.

---

## Table of Contents

1. [Input Parsing Patterns](#input-parsing-patterns)
2. [Data Structures](#data-structures)
3. [Core Algorithms](#core-algorithms)
4. [Mathematical Concepts](#mathematical-concepts)
5. [String & Text Processing](#string--text-processing)
6. [Grid & Navigation Problems](#grid--navigation-problems)
7. [Graph Algorithms](#graph-algorithms)
8. [Optimization Techniques](#optimization-techniques)
9. [REPL Helper Reference](#repl-helper-reference)
10. [Year-by-Year Highlights](#year-by-year-highlights)

---

## Input Parsing Patterns

### Common Input Formats

| Format | Example | REPL Helper |
|--------|---------|-------------|
| Single integers per line | `123\n456\n789` | `ints(year, day)` |
| Comma-separated values | `1,2,3,4,5` | `nums(str)` |
| Character grid | `##.\n.#.\n...` | `grid(year, day)` |
| Groups separated by blank lines | `group1\n\ngroup2` | `groups(year, day)` |
| Direction sequences | `R29\nL6\nR43` | `lines(year, day)` |
| Structured instructions | `move 5 from 1 to 2` | `extract_ints(line)` |

### Parsing Code Patterns

```ruby
# Read all integers from a line
line.scan(/-?\d+/).map(&:to_i)

# Parse direction + distance
line.match(/([UDLR])(\d+)/) { [$1, $2.to_i] }

# Split by blank lines into groups
input.split("\n\n").map { |g| g.lines.map(&:chomp) }

# Character grid to 2D array
input.lines.map { |l| l.chomp.chars }
```

---

## Data Structures

### Sets (O(1) Membership Testing)

Essential for tracking visited states, detecting duplicates, and cycle detection.

```ruby
require 'set'
visited = Set.new
return x unless visited.add?(pos)  # Returns nil if already present
```

**Common Uses:**
- Visited states in BFS/DFS
- Detecting first duplicate (2018 Day 1)
- Tracking positions in grid traversal

### Hash with Default Values

Perfect for frequency counting and sparse data.

```ruby
# Frequency counting
freq = Hash.new(0)
items.each { |x| freq[x] += 1 }

# Same as tally (Ruby 2.7+)
items.tally

# Adjacency list
graph = Hash.new { |h, k| h[k] = [] }
graph[from] << to
```

### Complex Numbers for 2D Coordinates

Elegant representation for grid navigation.

```ruby
pos = Complex(0, 0)      # Start at origin
dir = Complex(0, 1)       # Facing north
pos += dir * distance     # Move forward
dir *= Complex(0, 1)      # Turn right (multiply by i)
dir *= Complex(0, -1)     # Turn left (multiply by -i)
```

**Advantages:**
- Rotation is just multiplication
- Addition moves position
- Built-in equality and hashing

### Priority Queue

For Dijkstra's algorithm and A* search.

```ruby
# Simple approach (sort each iteration)
pq = [[0, start]]
until pq.empty?
  pq.sort_by!(&:first)
  cost, node = pq.shift
  # ... process
end

# Or use the PriorityQueue class from aoc_utils
```

---

## Core Algorithms

### Breadth-First Search (BFS)

Find shortest path in unweighted graphs.

```ruby
def bfs(start, &neighbors)
  distances = { start => 0 }
  queue = [start]

  until queue.empty?
    current = queue.shift
    neighbors.call(current).each do |neighbor|
      next if distances.key?(neighbor)
      distances[neighbor] = distances[current] + 1
      queue << neighbor
    end
  end

  distances
end
```

**Common Uses:**
- Shortest path in maze
- Flood fill / connected components
- Level-order traversal

### Cycle Detection

For problems requiring billions of iterations.

```ruby
# Find when state repeats
cycle = detect_cycle(initial) { |state| next_state(state) }
# => {start: 10, length: 7, state: ...}

# Fast-forward to iteration N
final = fast_forward(initial, 1_000_000_000) { |s| next_state(s) }
```

**Common Uses:**
- 2017 Day 6 (memory reallocation)
- 2018 Day 1 (first repeated frequency)
- Any "do this 10^9 times" problem

### Dynamic Programming

Memoization pattern for overlapping subproblems.

```ruby
# Hash-based memoization
@memo = {}
def solve(state)
  return @memo[state] if @memo.key?(state)
  @memo[state] = # ... compute result
end

# Or use Hash with default block
fib = Hash.new { |h, n| h[n] = n <= 1 ? n : h[n-1] + h[n-2] }
fib[100]  # Computed with memoization
```

---

## Mathematical Concepts

### Modular Arithmetic

Essential for dial/rotation and large number problems.

```ruby
# Position on circular dial
pos = (pos + turn) % 100

# Modular exponentiation
def mod_pow(base, exp, mod)
  result = 1
  base %= mod
  while exp > 0
    result = (result * base) % mod if exp.odd?
    exp >>= 1
    base = (base * base) % mod
  end
  result
end
```

### GCD / LCM

For cycle synchronization and fraction problems.

```ruby
def gcd(a, b)
  b.zero? ? a.abs : gcd(b, a % b)
end

def lcm(a, b)
  (a * b).abs / gcd(a, b)
end

# When do multiple cycles align?
[cycle1, cycle2, cycle3].reduce(1) { |acc, n| lcm(acc, n) }
```

### Chinese Remainder Theorem

Solve systems of modular equations.

```ruby
# x ≡ r₁ (mod m₁)
# x ≡ r₂ (mod m₂)
# ...
AocUtils.chinese_remainder_theorem(remainders, moduli)
```

### Combinatorics

```ruby
# All permutations
arr.permutation.to_a

# Choose k items
arr.combination(k).to_a

# Cartesian product
arrays[0].product(*arrays[1..])

# Power set (all subsets)
(0..arr.length).flat_map { |k| arr.combination(k).to_a }
```

---

## String & Text Processing

### Regular Expressions

```ruby
# Extract all integers (including negative)
str.scan(/-?\d+/).map(&:to_i)

# Named captures
if match = line.match(/(?<cmd>\w+) (?<val>\d+)/)
  cmd, val = match[:cmd], match[:val].to_i
end

# Overlapping matches (lookahead)
"121".scan(/(?=(\d\d))/).flatten  # => ["12", "21"]

# Find last match
line.reverse[/\d/]  # Last digit
```

### Position-Aware Scanning

For schematic/grid problems where position matters.

```ruby
# Find all numbers with their positions
scan_numbers(text)  # => [[467, row, col_start, col_end], ...]

# Find all symbols
scan_symbols(text)  # => [["*", row, col], ...]

# Check adjacency for gear problems
span_neighbors(row, col_start, col_end)  # All adjacent cells
```

---

## Grid & Navigation Problems

### Direction Constants

```ruby
# As [row, col] deltas
DIRS_4 = [[0, 1], [1, 0], [0, -1], [-1, 0]]
DIRS_8 = [[-1,-1], [-1,0], [-1,1], [0,-1], [0,1], [1,-1], [1,0], [1,1]]

# As Complex numbers (col + row*i)
NORTH = Complex(0, -1)
SOUTH = Complex(0, 1)
EAST  = Complex(1, 0)
WEST  = Complex(-1, 0)
```

### Grid Operations

```ruby
# Bounds checking
def in_bounds?(grid, r, c)
  r >= 0 && c >= 0 && r < grid.length && c < grid[0].length
end

# Get neighbors
def neighbors4(grid, r, c)
  DIRS_4.map { |dr, dc| [r + dr, c + dc] }
        .select { |nr, nc| in_bounds?(grid, nr, nc) }
end

# Find character in grid
grid.each_with_index do |row, r|
  row.each_with_index { |cell, c| return [r, c] if cell == target }
end

# Rotate grid 90° clockwise
grid.transpose.map(&:reverse)
```

### Navigation with Complex Numbers

```ruby
pos = Complex(0, 0)
dir = NORTH

instructions.each do |cmd|
  case cmd
  when 'L' then dir = turn_left(dir)
  when 'R' then dir = turn_right(dir)
  when 'F' then pos += dir
  end
end

manhattan(pos)  # Manhattan distance from origin
```

---

## Graph Algorithms

### Dijkstra's Algorithm

Shortest path with weighted edges.

```ruby
def dijkstra(start, &neighbors)
  dist = Hash.new(Float::INFINITY)
  dist[start] = 0
  pq = [[0, start]]
  visited = Set.new

  until pq.empty?
    pq.sort_by!(&:first)
    d, u = pq.shift
    next if visited.include?(u)
    visited << u

    neighbors.call(u).each do |v, cost|
      alt = d + cost
      if alt < dist[v]
        dist[v] = alt
        pq << [alt, v]
      end
    end
  end

  dist
end
```

### A* Search

Dijkstra with heuristic for goal-directed search.

```ruby
# Heuristic: estimated cost to goal (must not overestimate)
heuristic = ->(pos) { manhattan(pos, goal) }

AocUtils.astar(start, goal, neighbors_proc, heuristic)
```

### Topological Sort

Order nodes respecting dependencies.

```ruby
AocUtils.topological_sort(nodes, edges)
# Returns nil if cycle detected
```

### Flood Fill / Connected Components

```ruby
component = AocUtils.flood_fill(grid, start_row, start_col)
all_components = AocUtils.connected_components(grid)
```

---

## Optimization Techniques

### Lazy Evaluation

For potentially infinite sequences.

```ruby
# Find first hash starting with "00000"
(1..).lazy.find { |n| md5("#{key}#{n}").start_with?("00000") }
```

### Frequency Maps Instead of Arrays

For sparse data or large indices.

```ruby
# Instead of: fish = Array.new(9, 0)
fish = Hash.new(0)
input.each { |timer| fish[timer] += 1 }

# Simulate one day
new_fish = Hash.new(0)
fish.each do |timer, count|
  if timer == 0
    new_fish[6] += count
    new_fish[8] += count
  else
    new_fish[timer - 1] += count
  end
end
```

### Early Termination

```ruby
# Stop as soon as found
arr.find { |x| expensive_check(x) }

# With index
arr.each_with_index { |x, i| return i if condition(x) }
```

### Coordinate Compression

For sparse coordinate problems.

```ruby
mapping, sorted = AocUtils.compress_coordinates(all_x_values)
# mapping: value -> compressed_index
# sorted: compressed_index -> value
```

---

## REPL Helper Reference

### Quick Reference Card

```ruby
# Start REPL
gmake repl

# Input loading
input(2024, 1)     # Raw input string
lines(2024, 1)     # Array of lines
ints(2024, 1)      # Array of integers
grid(2024, 1)      # 2D character array
groups(2024, 1)    # Groups split by blank lines

# Parsing
nums("1, 2, 3")       # => [1, 2, 3]
extract_ints("5x3")   # => [5, 3]
scan_numbers(text)    # With positions
scan_symbols(text)    # Non-digit symbols

# Math
gcd(12, 8)            # => 4
lcm(3, 4)             # => 12
prime?(17)            # => true
divisors(12)          # => [1, 2, 3, 4, 6, 12]

# Navigation
pos = Complex(0, 0)
dir = NORTH
dir = turn_right(dir)
dir = parse_dir('R')
manhattan(pos)

# Ranges
ranges_overlap?(1..5, 4..8)
range_intersect(1..5, 4..8)
merge_ranges([1..3, 2..5])

# Cycles
detect_cycle(state) { |s| next_state(s) }
fast_forward(state, 1_000_000) { |s| next_state(s) }

# Display
print_grid(grid)
highlight_grid(grid, {[0,0] => true})
histogram(values)
table(data, headers)
```

---

## Year-by-Year Highlights

### 2015 - The Beginning
- **Day 4**: MD5 hashing (mining)
- **Day 6**: Large grid toggling
- **Day 10**: Look-and-say sequences

### 2016 - Assembly & Crypto
- **Day 1**: Complex number navigation
- **Day 12**: Assembunny interpreter
- **Day 14**: Hash stretching

### 2017 - Knot Hash & Fractals
- **Day 6**: Cycle detection
- **Day 10**: Knot hash algorithm
- **Day 21**: Fractal art / pattern matching

### 2018 - Time Travel
- **Day 1**: Frequency cycles
- **Day 4**: Event log parsing
- **Day 23**: 3D coordinate problems

### 2019 - Intcode Computer
- **Day 2-25**: Intcode VM (full computer)
- **Day 3**: Wire intersection (Complex numbers)
- **Day 12**: N-body simulation with LCM

### 2020 - Game of Life Variants
- **Day 1**: Two-sum / three-sum
- **Day 6**: Set operations
- **Day 11**: Cellular automata

### 2021 - Marine Biology
- **Day 1**: Sliding windows
- **Day 6**: Lanternfish (frequency map optimization)
- **Day 15**: Dijkstra on large grids

### 2022 - Expedition
- **Day 1**: Group summing
- **Day 6**: Sliding window uniqueness
- **Day 12**: BFS pathfinding

### 2023 - Lava & Gears
- **Day 1**: Overlapping regex
- **Day 3**: Schematic parsing (position-aware)
- **Day 5**: Range splitting/mapping

### 2024 - Latest Challenges
- **Day 1**: Column parsing
- **Day 3**: Mul instruction parsing
- **Day 6**: Guard patrol simulation

---

## Problem Categories Summary

| Category | Key Techniques | Example Problems |
|----------|----------------|------------------|
| **Parsing** | Regex, scan, split | Most Day 1s |
| **Grid Traversal** | BFS, flood fill | 2022 Day 12, 2024 Day 6 |
| **Navigation** | Complex numbers | 2016 Day 1, 2019 Day 3 |
| **Cycle Finding** | Floyd/Brent, hash | 2017 Day 6, 2018 Day 1 |
| **Optimization** | Dijkstra, A* | 2021 Day 15, 2023 Day 17 |
| **Simulation** | State machines | 2021 Day 6, 2019 Intcode |
| **Combinatorics** | Permutation, subset | 2020 Day 1, many Day 25s |
| **Math** | Modular, CRT, LCM | 2019 Day 12, 2020 Day 13 |

---

## Getting Started

```bash
# Clone the repository
git clone https://github.com/aygp-dr/aoc-rb.git
cd aoc-rb

# Start the interactive REPL
gmake repl

# Load a specific day's input
input(2024, 1)

# Explore with helpers
lines(2024, 1).first(5)
```

---

*Document generated from analysis of AoC solutions 2015-2024*
