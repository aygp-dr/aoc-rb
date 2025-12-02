# frozen_string_literal: true

# Debug utilities for Advent of Code solutions
# Usage:
#   require_relative '../lib/aoc_debug'
#   AocDebug.disasm('arr.map(&:to_i).sum')
#   AocDebug.trace_calls { solve(input) }

module AocDebug
  class << self
    # Disassemble a method or code string to YARV bytecode
    def disasm(code_string)
      iseq = RubyVM::InstructionSequence.compile(code_string)
      puts iseq.disasm
    end

    # Show S-expression AST for code using Ripper
    def ast(code_string)
      require 'ripper'
      require 'pp'
      pp Ripper.sexp(code_string)
    end

    # Show lexical tokens
    def lex(code_string)
      require 'ripper'
      puts "Tokens for: #{code_string}"
      Ripper.lex(code_string).each do |pos, type, token, state|
        printf "  %-15s %-20s %s\n", type, token.inspect, state
      end
    end

    # Trace method calls during block execution
    def trace_calls(filter: nil, &block)
      depth = 0
      tracer = TracePoint.new(:call, :return) do |tp|
        # Filter by path if specified
        next if filter && !tp.path.include?(filter)
        # Skip internal Ruby methods
        next if tp.path.start_with?('<internal:')

        case tp.event
        when :call
          args = tp.binding.local_variables
            .map { |v| "#{v}=#{tp.binding.local_variable_get(v).inspect[0..20]}" }
            .join(', ')
          puts "#{'  ' * depth}→ #{tp.method_id}(#{args})"
          depth += 1
        when :return
          depth -= 1
          ret = tp.return_value.inspect[0..50]
          puts "#{'  ' * depth}← #{tp.method_id} => #{ret}"
        end
      end
      tracer.enable(&block)
    end

    # Trace line-by-line execution
    def trace_lines(code_string)
      lines = code_string.lines
      tracer = TracePoint.new(:line) do |tp|
        next unless tp.path == '(eval)'
        src = lines[tp.lineno - 1]&.strip || ''
        vars = tp.binding.local_variables
          .map { |v| "#{v}=#{tp.binding.local_variable_get(v).inspect[0..15]}" }
          .join(', ')
        printf "%2d: %-40s | %s\n", tp.lineno, src[0..39], vars[0..40]
      end
      tracer.enable { eval(code_string) }
    end

    # Count object allocations during block execution
    def allocations(&block)
      require 'objspace'
      GC.disable
      before = ObjectSpace.count_objects
      result = yield
      after = ObjectSpace.count_objects
      GC.enable

      diff = after.map { |k, v| [k, v - before[k]] }.to_h.reject { |_, v| v == 0 }
      { result: result, allocations: diff }
    end

    # Simple benchmark helper
    def time(label = 'Block', iterations = 1)
      require 'benchmark'
      result = nil
      total_time = Benchmark.measure { iterations.times { result = yield } }
      avg_ms = (total_time.real / iterations) * 1000

      puts format("%-20s %8.3fms (avg of %d)", "#{label}:", avg_ms, iterations)
      result
    end

    # Compare multiple approaches
    def compare(iterations: 100, **approaches)
      require 'benchmark'

      puts "Comparing #{approaches.size} approaches (#{iterations} iterations each):"
      puts '-' * 50

      results = {}
      Benchmark.bm(20) do |x|
        approaches.each do |name, block|
          results[name] = nil
          x.report("#{name}:") { iterations.times { results[name] = block.call } }
        end
      end

      # Verify all results match
      values = results.values.uniq
      if values.size == 1
        puts "\nAll approaches return: #{values.first.inspect[0..50]}"
      else
        puts "\nWARNING: Results differ!"
        results.each { |name, val| puts "  #{name}: #{val.inspect[0..50]}" }
      end
    end

    # Memory size of an object
    def memsize(obj)
      require 'objspace'
      ObjectSpace.memsize_of(obj)
    end

    # Show method source location
    def where(obj, method_name)
      m = obj.method(method_name)
      puts "#{m.owner}##{m.name}"
      puts "  Location: #{m.source_location&.join(':') || 'native'}"
      puts "  Arity: #{m.arity}"
      puts "  Parameters: #{m.parameters}"
    end
  end
end

# Example usage when run directly
if __FILE__ == $PROGRAM_NAME
  puts '=' * 60
  puts 'AocDebug Module Demo'
  puts '=' * 60

  puts "\n=== Bytecode Disassembly ==="
  AocDebug.disasm('[1,2,3].map { |x| x * 2 }.sum')

  puts "\n=== AST (S-expression) ==="
  AocDebug.ast('arr.select { |n| n > 5 }')

  puts "\n=== Lexical Tokens ==="
  AocDebug.lex('n.odd? ? n * 3 : n / 2')

  puts "\n=== Object Allocations ==="
  result = AocDebug.allocations { (1..100).map(&:to_s) }
  puts "Result size: #{result[:result].size}"
  puts "Allocations: #{result[:allocations]}"

  puts "\n=== Timing ==="
  AocDebug.time('Sum 1..10000', 100) { (1..10_000).sum }

  puts "\n=== Compare Approaches ==="
  data = (1..1000).to_a
  AocDebug.compare(
    iterations: 1000,
    'each loop': -> {
      sum = 0
      data.each { |n| sum += n }
      sum
    },
    'reduce': -> { data.reduce(0, :+) },
    'sum': -> { data.sum }
  )

  puts "\n=== Method Location ==="
  AocDebug.where([1, 2, 3], :map)
end
