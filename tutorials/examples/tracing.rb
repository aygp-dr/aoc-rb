#!/usr/bin/env ruby
# frozen_string_literal: true

# Ruby debugging and tracing tools
# Demonstrates TracePoint, caller, and binding inspection

module Tracing
  # Trace method calls with depth tracking
  def self.trace_calls(filter: nil, max_depth: 10, &block)
    depth = 0
    calls = []

    tracer = TracePoint.new(:call, :return) do |tp|
      # Skip internal Ruby methods
      next if tp.path.start_with?('<internal:')
      # Apply filter if provided
      next if filter && !tp.path.include?(filter)

      case tp.event
      when :call
        next if depth >= max_depth

        calls << {
          depth: depth,
          event: :call,
          class: tp.defined_class,
          method: tp.method_id,
          path: tp.path,
          line: tp.lineno
        }
        depth += 1
      when :return
        depth -= 1 if depth > 0
        calls << {
          depth: depth,
          event: :return,
          class: tp.defined_class,
          method: tp.method_id,
          return_value: tp.return_value.inspect[0..50]
        }
      end
    end

    tracer.enable(&block)
    calls
  end

  # Print call trace in tree format
  def self.print_trace(calls)
    calls.each do |c|
      indent = '  ' * c[:depth]
      case c[:event]
      when :call
        puts "#{indent}-> #{c[:class]}##{c[:method]}"
      when :return
        puts "#{indent}<- #{c[:method]} => #{c[:return_value]}"
      end
    end
  end

  # Trace line-by-line execution
  def self.trace_lines(code_string)
    lines = code_string.lines
    output = []

    tracer = TracePoint.new(:line) do |tp|
      next unless tp.path == '(eval)'

      src = lines[tp.lineno - 1]&.strip || ''
      vars = tp.binding.local_variables.map do |var|
        "#{var}=#{tp.binding.local_variable_get(var).inspect[0..15]}"
      end.join(', ')

      output << format('%2d: %-40s | %s', tp.lineno, src[0..39], vars[0..40])
    end

    result = tracer.enable { eval(code_string) } # rubocop:disable Security/Eval
    [output, result]
  end

  # Inspect current call stack
  def self.call_stack(limit: 10)
    caller.first(limit).map do |frame|
      if frame =~ /^(.+):(\d+):in `(.+)'$/
        { file: Regexp.last_match(1), line: Regexp.last_match(2).to_i, method: Regexp.last_match(3) }
      else
        { raw: frame }
      end
    end
  end

  # Inspect binding (local variables)
  def self.inspect_binding(binding_obj)
    binding_obj.local_variables.to_h do |var|
      [var, binding_obj.local_variable_get(var)]
    end
  end
end

# Example code to trace
def factorial(n)
  return 1 if n <= 1

  n * factorial(n - 1)
end

def fibonacci(n)
  return n if n <= 1

  fibonacci(n - 1) + fibonacci(n - 2)
end

if __FILE__ == $PROGRAM_NAME
  puts "Ruby Tracing and Debugging"
  puts "=" * 60

  puts "\n1. Method Call Tracing (factorial)"
  puts "-" * 40
  calls = Tracing.trace_calls(filter: 'tracing') { factorial(5) }
  Tracing.print_trace(calls.first(20))

  puts "\n2. Line-by-Line Tracing"
  puts "-" * 40
  code = <<~RUBY
    x = 1
    y = 2
    z = x + y
    result = z * 2
  RUBY
  output, result = Tracing.trace_lines(code)
  output.each { |line| puts line }
  puts "Final result: #{result}"

  puts "\n3. Call Stack Inspection"
  puts "-" * 40
  def outer
    inner
  end

  def inner
    Tracing.call_stack(limit: 5)
  end
  stack = outer
  stack.each { |frame| puts "  #{frame[:file]}:#{frame[:line]} in #{frame[:method]}" }

  puts "\n4. Binding Inspection"
  puts "-" * 40
  def example_method
    local_a = 42
    local_b = 'hello'
    local_c = [1, 2, 3]
    Tracing.inspect_binding(binding)
  end
  vars = example_method
  vars.each { |name, value| puts "  #{name} = #{value.inspect}" }
end
