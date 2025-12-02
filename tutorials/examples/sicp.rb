#!/usr/bin/env ruby
# frozen_string_literal: true

# SICP-style recursive list operations
# Demonstrates functional programming patterns

# Higher-order function: accumulate (fold)
def accumulate(op, initial, sequence)
  return initial if sequence.empty?

  op.call(sequence.first, accumulate(op, initial, sequence[1..]))
end

# Map using accumulate
def map_acc(proc, sequence)
  accumulate(
    ->(x, rest) { [proc.call(x)] + rest },
    [],
    sequence
  )
end

# Filter using accumulate
def filter_acc(predicate, sequence)
  accumulate(
    ->(x, rest) { predicate.call(x) ? [x] + rest : rest },
    [],
    sequence
  )
end

# Append (non-destructive)
def append(l1, l2)
  accumulate(->(x, rest) { [x] + rest }, l2, l1)
end

# Length
def length(sequence)
  accumulate(->(_x, rest) { 1 + rest }, 0, sequence)
end

# Reverse
def reverse_list(sequence)
  accumulate(->(x, rest) { rest + [x] }, [], sequence)
end

# Flatmap
def flatmap(proc, sequence)
  accumulate(:+.to_proc, [], map_acc(proc, sequence))
end

if __FILE__ == $PROGRAM_NAME
  puts "SICP-style List Operations"
  puts "=" * 40

  # Accumulate examples
  puts "\naccumulate (fold):"
  puts "sum [1,2,3,4,5] = #{accumulate(:+.to_proc, 0, [1, 2, 3, 4, 5])}"
  puts "product [1,2,3,4,5] = #{accumulate(:*.to_proc, 1, [1, 2, 3, 4, 5])}"

  # Map
  puts "\nmap (square):"
  squares = map_acc(->(x) { x * x }, [1, 2, 3, 4, 5])
  puts "[1,2,3,4,5].map(&:square) = #{squares.inspect}"

  # Filter
  puts "\nfilter (odd?):"
  odds = filter_acc(->(x) { x.odd? }, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  puts "[1..10].filter(&:odd?) = #{odds.inspect}"

  # Append
  puts "\nappend:"
  result = append([1, 2, 3], [4, 5, 6])
  puts "[1,2,3] + [4,5,6] = #{result.inspect}"

  # Length and reverse
  puts "\nlength and reverse:"
  puts "length([1,2,3,4,5]) = #{length([1, 2, 3, 4, 5])}"
  puts "reverse([1,2,3,4,5]) = #{reverse_list([1, 2, 3, 4, 5]).inspect}"

  # Flatmap
  puts "\nflatmap:"
  pairs = flatmap(->(i) { [[i, i * i]] }, [1, 2, 3])
  puts "flatmap(n -> [[n, n^2]], [1,2,3]) = #{pairs.inspect}"
end
