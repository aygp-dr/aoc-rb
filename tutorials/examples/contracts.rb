#!/usr/bin/env ruby
# frozen_string_literal: true

# Simple contracts/validation system
# Demonstrates Ruby metaprogramming for runtime checks

module Contracts
  class ValidationError < StandardError; end

  # Type checking
  def self.check_type(value, expected_type, name = 'value')
    return value if value.is_a?(expected_type)

    raise ValidationError, "#{name}: expected #{expected_type}, got #{value.class}"
  end

  # Predicate checking
  def self.check(value, predicate, message)
    return value if predicate.call(value)

    raise ValidationError, message
  end

  # Common validators
  def self.positive(value, name = 'value')
    check(value, ->(v) { v.is_a?(Numeric) && v > 0 }, "#{name}: must be positive")
  end

  def self.non_negative(value, name = 'value')
    check(value, ->(v) { v.is_a?(Numeric) && v >= 0 }, "#{name}: must be non-negative")
  end

  def self.in_range(value, range, name = 'value')
    check(value, ->(v) { range.cover?(v) }, "#{name}: must be in #{range}")
  end

  def self.not_empty(value, name = 'value')
    check(value, ->(v) { !v.nil? && !v.empty? }, "#{name}: must not be empty")
  end

  def self.matches(value, pattern, name = 'value')
    check(value, ->(v) { pattern.match?(v.to_s) }, "#{name}: must match #{pattern}")
  end
end

# Mixin for adding contracts to methods
module Contractable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def contract(method_name, **checks)
      original = instance_method(method_name)

      define_method(method_name) do |*args, **kwargs, &block|
        # Validate arguments
        checks[:args]&.each_with_index do |(name, validator), i|
          validator.call(args[i], name.to_s)
        end

        # Validate keyword arguments
        checks[:kwargs]&.each do |name, validator|
          validator.call(kwargs[name], name.to_s) if kwargs.key?(name)
        end

        # Call original method
        result = original.bind(self).call(*args, **kwargs, &block)

        # Validate return value
        checks[:returns]&.call(result, 'return value')

        result
      end
    end
  end
end

# Example usage
class Calculator
  include Contractable

  def divide(a, b)
    a.to_f / b
  end

  contract :divide,
           args: {
             a: ->(v, n) { Contracts.check_type(v, Numeric, n) },
             b: ->(v, n) { Contracts.positive(v, n) }
           },
           returns: ->(v, n) { Contracts.check_type(v, Numeric, n) }

  def sqrt(n)
    Math.sqrt(n)
  end

  contract :sqrt,
           args: { n: ->(v, n) { Contracts.non_negative(v, n) } }
end

if __FILE__ == $PROGRAM_NAME
  puts "Contracts and Validation"
  puts "=" * 60

  calc = Calculator.new

  puts "\nValid operations:"
  puts "divide(10, 2) = #{calc.divide(10, 2)}"
  puts "sqrt(16) = #{calc.sqrt(16)}"

  puts "\nInvalid operations:"

  begin
    calc.divide(10, 0)
  rescue Contracts::ValidationError => e
    puts "divide(10, 0) -> #{e.message}"
  end

  begin
    calc.divide(10, -5)
  rescue Contracts::ValidationError => e
    puts "divide(10, -5) -> #{e.message}"
  end

  begin
    calc.sqrt(-4)
  rescue Contracts::ValidationError => e
    puts "sqrt(-4) -> #{e.message}"
  end

  puts "\nDirect contract usage:"
  begin
    Contracts.in_range(150, 0..100, 'percentage')
  rescue Contracts::ValidationError => e
    puts "in_range(150, 0..100) -> #{e.message}"
  end
end
