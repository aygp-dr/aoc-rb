#!/usr/bin/env ruby
# frozen_string_literal: true

# AST Generation and Analysis with Ripper
# Demonstrates Ruby's built-in parsing capabilities

require 'ripper'
require 'pp'

# Custom AST visitor to find method definitions
class MethodFinder < Ripper::SexpBuilder
  attr_reader :methods

  def initialize(src)
    super(src)
    @methods = []
  end

  def on_def(name, params, body)
    @methods << { name: name, params: params }
    super
  end
end

# Find all method definitions in code
def find_methods(code)
  finder = MethodFinder.new(code)
  finder.parse
  finder.methods.map { |m| m[:name][1] } # Extract method name from [:@ident, "name", [line, col]]
end

# Get S-expression AST
def sexp(code)
  Ripper.sexp(code)
end

# Get tokens
def tokenize(code)
  Ripper.tokenize(code)
end

# Get lexical tokens with position info
def lex(code)
  Ripper.lex(code)
end

if __FILE__ == $PROGRAM_NAME
  puts "AST Analysis with Ripper"
  puts "=" * 60

  code = <<~RUBY
    def factorial(n)
      return 1 if n <= 1
      n * factorial(n - 1)
    end

    def fibonacci(n, memo = {})
      return n if n <= 1
      memo[n] ||= fibonacci(n - 1, memo) + fibonacci(n - 2, memo)
    end
  RUBY

  puts "\nSource code:"
  puts code

  puts "\n" + "=" * 60
  puts "1. S-Expression AST"
  puts "=" * 60
  pp sexp(code)

  puts "\n" + "=" * 60
  puts "2. Tokens"
  puts "=" * 60
  puts tokenize(code).inspect

  puts "\n" + "=" * 60
  puts "3. Lexical Analysis (first 10)"
  puts "=" * 60
  lex(code).first(10).each do |token|
    pos, type, value, state = token
    printf "  Line %d, Col %d: %-20s %s\n", pos[0], pos[1], type, value.inspect
  end

  puts "\n" + "=" * 60
  puts "4. Method Finder"
  puts "=" * 60
  methods = find_methods(code)
  puts "Methods found: #{methods.inspect}"
end
