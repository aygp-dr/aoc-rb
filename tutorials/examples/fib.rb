#!/usr/bin/env ruby
# frozen_string_literal: true

# Memoized Fibonacci - demonstrates Hash-based memoization
# This pattern is useful for many AoC dynamic programming problems

def fib(n, memo = {})
  return n if n <= 1

  memo[n] ||= fib(n - 1, memo) + fib(n - 2, memo)
end

# Alternative: Hash with default block for automatic memoization
FIB = Hash.new { |h, n| h[n] = n < 2 ? n : h[n - 1] + h[n - 2] }

if __FILE__ == $PROGRAM_NAME
  puts "Memoized Fibonacci:"
  puts "fib(10) = #{fib(10)}"   # => 55
  puts "fib(20) = #{fib(20)}"   # => 6765
  puts "fib(30) = #{fib(30)}"   # => 832040

  puts "\nHash-based Fibonacci:"
  puts "FIB[10] = #{FIB[10]}"   # => 55
  puts "FIB[20] = #{FIB[20]}"   # => 6765
end

