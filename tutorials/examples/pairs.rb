#!/usr/bin/env ruby
# frozen_string_literal: true

# Church-encoded pairs (SICP 2.1.3)
# Demonstrates that data structures can be built from pure functions
# This is foundational to understanding closures and lambdas

def pair(f, r)
  lambda { |p| p.call(f, r) }
end

def first(p)
  p.call(lambda { |f, _r| f })
end

def second(p)
  p.call(lambda { |_f, r| r })
end

# Convenience: convert pair to array
def pair_to_array(p)
  [first(p), second(p)]
end

# Build a list from pairs (nil-terminated)
def cons(head, tail)
  pair(head, tail)
end

def car(list)
  first(list)
end

def cdr(list)
  second(list)
end

if __FILE__ == $PROGRAM_NAME
  puts "Church-encoded Pairs (SICP)"
  puts "=" * 40

  # Basic pair
  my_pair = pair(42, "hello")
  puts "\nBasic pair:"
  puts "first(pair(42, 'hello')) = #{first(my_pair)}"
  puts "second(pair(42, 'hello')) = #{second(my_pair)}"

  # Nested pairs (2x2 matrix representation)
  nested = pair(pair(1, 2), pair(3, 4))
  puts "\nNested pairs (2x2 matrix):"
  puts "[[1,2],[3,4]][0][0] = #{first(first(nested))}"
  puts "[[1,2],[3,4]][0][1] = #{second(first(nested))}"
  puts "[[1,2],[3,4]][1][0] = #{first(second(nested))}"
  puts "[[1,2],[3,4]][1][1] = #{second(second(nested))}"

  # Lisp-style list
  list = cons(1, cons(2, cons(3, nil)))
  puts "\nLisp-style list (1 2 3):"
  puts "car: #{car(list)}"
  puts "cadr: #{car(cdr(list))}"
  puts "caddr: #{car(cdr(cdr(list)))}"
end
