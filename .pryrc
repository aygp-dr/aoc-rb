# Pry configuration for Advent of Code development
# This file is loaded automatically by Pry

# Pretty printing
Pry.config.print = proc do |output, value, _pry_|
  output.puts "=> #{value.inspect}"
end

# Custom prompt showing current context
Pry.config.prompt = Pry::Prompt.new(
  'aoc',
  'AoC prompt',
  [
    proc { |target_self, nest_level, pry|
      "[AoC] #{pry.input_ring.count}> "
    },
    proc { |target_self, nest_level, pry|
      "[AoC] #{pry.input_ring.count}* "
    }
  ]
)

# Useful aliases
Pry::Commands.create_command 'day' do
  description 'Load a specific day: day 2015 1'

  def process
    args = arg_string.split
    if args.length >= 2
      year, day = args[0].to_i, args[1].to_i
      solver = load_day(year, day)
      target.eval("solver = ObjectSpace._id2ref(#{solver.__id__})") if solver
    else
      output.puts "Usage: day YEAR DAY (e.g., day 2015 1)"
    end
  end
end

Pry::Commands.create_command 'run' do
  description 'Run current solver: run or run 1 or run 2'

  def process
    part = arg_string.strip
    if target.eval('defined?(solver)')
      solver = target.eval('solver')
      case part
      when '1', ''
        result = solver.part1
        output.puts "Part 1: #{result}"
      when '2'
        result = solver.part2
        output.puts "Part 2: #{result}"
      when 'both'
        output.puts "Part 1: #{solver.part1}"
        output.puts "Part 2: #{solver.part2}"
      end
    else
      output.puts "No solver loaded. Use: load_day(year, day)"
    end
  end
end

Pry::Commands.create_command 'bench' do
  description 'Benchmark solver: bench or bench 1 or bench 2'

  def process
    part = arg_string.strip.empty? ? 'both' : arg_string.strip
    if target.eval('defined?(solver)')
      solver = target.eval('solver')
      require 'benchmark'

      case part
      when '1'
        result = Benchmark.measure { solver.part1 }
        output.puts "Part 1: #{result}"
      when '2'
        result = Benchmark.measure { solver.part2 }
        output.puts "Part 2: #{result}"
      else
        output.puts "Part 1:"
        output.puts Benchmark.measure { solver.part1 }
        output.puts "Part 2:"
        output.puts Benchmark.measure { solver.part2 }
      end
    else
      output.puts "No solver loaded."
    end
  end
end

# Load utilities if available
begin
  $LOAD_PATH.unshift File.expand_path('lib', Dir.pwd)
  require 'aoc_utils'
  puts "AocUtils loaded."
rescue LoadError
  # Ignore if not in project directory
end
