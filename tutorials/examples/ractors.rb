#!/usr/bin/env ruby
# frozen_string_literal: true

# Ruby Ractors - True parallel execution (Ruby 3.0+)
# Ractors avoid the GVL and enable real parallelism

# Check Ruby version
if RUBY_VERSION < '3.0.0'
  puts "Ractors require Ruby 3.0+. Current version: #{RUBY_VERSION}"
  puts "This file demonstrates Ractor concepts but won't run on older Ruby."
  exit 0
end

module RactorExamples
  # Simple computation in a Ractor
  def self.basic_example
    r = Ractor.new do
      # This runs in a separate Ractor (parallel)
      sum = (1..1_000_000).sum
      Ractor.yield sum
    end

    # Get the result
    r.take
  end

  # Send/receive communication (push model)
  def self.send_receive_example
    r = Ractor.new do
      msg = Ractor.receive
      "Received: #{msg}"
    end

    r.send('Hello from main!')
    r.take
  end

  # Multiple Ractors for parallel work
  def self.parallel_sum(ranges)
    ractors = ranges.map do |range|
      Ractor.new(range) do |r|
        r.sum
      end
    end

    ractors.map(&:take).sum
  end

  # Pipeline pattern
  def self.pipeline_example
    # Stage 1: Double numbers
    stage1 = Ractor.new do
      loop do
        n = Ractor.receive
        break if n == :done

        Ractor.yield n * 2
      end
    end

    # Stage 2: Square numbers
    stage2 = Ractor.new(stage1) do |input|
      loop do
        n = input.take
        break if n == :done

        Ractor.yield n * n
      rescue Ractor::ClosedError
        break
      end
    end

    # Send data through pipeline
    results = []
    [1, 2, 3, 4, 5].each { |n| stage1.send(n) }
    stage1.send(:done)

    5.times { results << stage2.take }

    results
  end

  # Worker pool pattern
  def self.worker_pool(jobs, num_workers: 4)
    # Create workers
    workers = Array.new(num_workers) do
      Ractor.new do
        loop do
          job = Ractor.receive
          break if job == :stop

          # Process job (in this example, just compute factorial)
          result = (1..job).reduce(1, :*)
          Ractor.yield [job, result]
        end
      end
    end

    # Distribute jobs round-robin
    jobs.each_with_index do |job, i|
      workers[i % num_workers].send(job)
    end

    # Collect results
    results = jobs.map { Ractor.select(*workers)[1] }

    # Stop workers
    workers.each { |w| w.send(:stop) }

    results
  end

  # Shareable objects
  def self.shareable_example
    # Make an object shareable (must be frozen)
    config = Ractor.make_shareable({
      max_iterations: 1000,
      timeout: 30
    }.freeze)

    r = Ractor.new(config) do |cfg|
      "Config has #{cfg.keys.size} keys, max_iterations=#{cfg[:max_iterations]}"
    end

    r.take
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Ruby Ractor Examples (Ruby #{RUBY_VERSION})"
  puts "=" * 60

  puts "\n1. Basic Ractor"
  puts "-" * 40
  result = RactorExamples.basic_example
  puts "Sum of 1..1_000_000 = #{result}"

  puts "\n2. Send/Receive Communication"
  puts "-" * 40
  result = RactorExamples.send_receive_example
  puts result

  puts "\n3. Parallel Sum"
  puts "-" * 40
  chunks = [1..250_000, 250_001..500_000, 500_001..750_000, 750_001..1_000_000]
  result = RactorExamples.parallel_sum(chunks)
  puts "Parallel sum 1..1_000_000 = #{result}"
  puts "Verify: #{(1..1_000_000).sum}"

  puts "\n4. Pipeline Processing"
  puts "-" * 40
  # Note: Pipeline example may not work in all Ruby builds
  begin
    results = RactorExamples.pipeline_example
    puts "Pipeline results (double then square): #{results.inspect}"
  rescue StandardError => e
    puts "Pipeline example error: #{e.message}"
  end

  puts "\n5. Shareable Objects"
  puts "-" * 40
  result = RactorExamples.shareable_example
  puts result

  puts "\n6. Shareable Constants"
  puts "-" * 40
  # Constants that can cross Ractor boundaries
  SHAREABLE_CONST = Ractor.make_shareable([1, 2, 3].freeze)
  r = Ractor.new { SHAREABLE_CONST.sum }
  puts "Sum of shareable constant: #{r.take}"
end
