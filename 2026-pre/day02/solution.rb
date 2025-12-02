#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2026 (Pre) - Day 2: Gem Transformer
#
# Ruby Idioms: Blocks, Procs, and Lambdas
# - Stabby lambda syntax: ->(x) { ... }
# - Proc composition with >> and <<
# - Closures capturing variables
# - Building operation hashes
# - reduce for sequential application

class Day02
  # Base operations as lambdas
  OPERATIONS = {
    'double' => ->(x) { x * 2 },
    'square' => ->(x) { x ** 2 },
    'neg'    => ->(x) { -x },
    'abs'    => ->(x) { x.abs },
    'inc'    => ->(x) { x + 1 },
    'dec'    => ->(x) { x - 1 }
  }.freeze

  def initialize(input)
    @input = input.strip
  end

  # Part 1: Apply operations in sequence, sum results
  #
  # Input format: "value | op1 op2 op3"
  def part1
    @input.lines.reject { |l| l.start_with?('COMPOSE') }.sum do |line|
      next 0 unless line.include?('|')

      value, ops_str = line.split('|').map(&:strip)
      ops = parse_ops(ops_str.split)

      apply_ops(value.to_i, ops)
    end
  end

  # Part 2: Compose functions from COMPOSE lines, apply to all values
  #
  # Input format:
  #   COMPOSE name = op1 op2 op3
  #   value1
  #   value2
  def part2
    lines = @input.lines.map(&:strip)

    # Find COMPOSE line and build composed function
    compose_line = lines.find { |l| l.start_with?('COMPOSE') }
    return part1 unless compose_line

    # Parse: "COMPOSE name = op1 op2 op3"
    ops_str = compose_line.split('=').last.strip
    ops = parse_ops(ops_str.split)
    composed = compose_lambdas(ops)

    # Apply to all value lines
    lines
      .reject { |l| l.start_with?('COMPOSE') || l.empty? }
      .sum { |l| composed.call(l.to_i) }
  end

  private

  # Parse operation strings into lambdas
  # Handles parametric ops like "add:5" and "mod:7"
  def parse_ops(op_strings)
    op_strings.map do |op_str|
      if op_str.include?(':')
        name, param = op_str.split(':')
        parametric_op(name, param.to_i)
      else
        OPERATIONS[op_str] || ->(x) { x }
      end
    end
  end

  # Create parametric lambdas (closures capturing the parameter)
  def parametric_op(name, param)
    case name
    when 'add' then ->(x) { x + param }
    when 'sub' then ->(x) { x - param }
    when 'mul' then ->(x) { x * param }
    when 'div' then ->(x) { x / param }
    when 'mod' then ->(x) { x % param }
    when 'pow' then ->(x) { x ** param }
    else ->(x) { x }
    end
  end

  # Apply operations sequentially using reduce
  def apply_ops(initial, ops)
    ops.reduce(initial) { |val, op| op.call(val) }
  end

  # Compose multiple lambdas into one using >>
  # f >> g means: apply f, then apply g to result
  def compose_lambdas(ops)
    ops.reduce(->(x) { x }) { |composed, op| composed >> op }
  end
end

# Alternative implementations demonstrating different approaches
module AlternativeSolutions
  # Using << instead of >> (reverse composition order)
  def compose_with_left_arrow(ops)
    # << composes right-to-left, so reverse the array
    ops.reverse.reduce(->(x) { x }) { |composed, op| composed << op }
  end

  # Using Proc#curry for partial application
  def curried_add
    add = ->(a, b) { a + b }
    add5 = add.curry.call(5)  # Returns a proc that adds 5
    add5.call(10)  # => 15
  end

  # Converting methods to procs
  def method_to_proc_example
    # Given a method:
    def triple(x) = x * 3

    # Convert to proc:
    tripler = method(:triple)
    [1, 2, 3].map(&tripler)  # => [3, 6, 9]
  end

  # Using Symbol#to_proc (& operator)
  def symbol_to_proc_example
    # :to_s.to_proc creates a proc that calls to_s on its argument
    [1, 2, 3].map(&:to_s)  # => ["1", "2", "3"]

    # Equivalent to:
    [1, 2, 3].map { |n| n.to_s }
  end

  # Proc vs Lambda differences
  def proc_vs_lambda
    # Lambda checks argument count
    lam = ->(x) { x * 2 }
    # lam.call       # ArgumentError!
    # lam.call(1, 2) # ArgumentError!

    # Proc is lenient
    prc = proc { |x| x.to_i * 2 }
    prc.call       # => 0 (nil.to_i * 2)
    prc.call(1, 2) # => 2 (ignores extra arg)

    # Lambda return exits lambda
    # Proc return exits enclosing method!
  end
end

if __FILE__ == $PROGRAM_NAME
  input_file = ARGV[0] || File.join(__dir__, 'input.txt')
  input = File.read(input_file)

  solver = Day02.new(input)

  puts "Part 1: #{solver.part1}"
  puts "Part 2: #{solver.part2}"
end
