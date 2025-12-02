#!/usr/bin/env ruby
# frozen_string_literal: true

# Ruby threading and concurrency examples
# Demonstrates Thread, Mutex, Queue, and ConditionVariable

require 'thread'

module Threading
  # Simple thread pool implementation
  class ThreadPool
    def initialize(size)
      @size = size
      @jobs = Queue.new
      @pool = Array.new(size) do
        Thread.new do
          catch(:exit) do
            loop do
              job, args = @jobs.pop
              throw :exit if job == :exit
              job.call(*args)
            end
          end
        end
      end
    end

    def schedule(*args, &block)
      @jobs << [block, args]
    end

    def shutdown
      @size.times { @jobs << [:exit, nil] }
      @pool.each(&:join)
    end
  end

  # Producer-Consumer pattern
  class ProducerConsumer
    def initialize(buffer_size: 10)
      @buffer = SizedQueue.new(buffer_size)
      @done = false
    end

    def produce(items)
      Thread.new do
        items.each do |item|
          @buffer << item
          yield item if block_given?
        end
        @done = true
      end
    end

    def consume(&block)
      Thread.new do
        loop do
          break if @done && @buffer.empty?

          begin
            item = @buffer.pop(true)
            block.call(item)
          rescue ThreadError
            sleep 0.01 # Buffer empty, wait a bit
          end
        end
      end
    end
  end

  # Parallel map using threads
  def self.parallel_map(items, num_threads: 4, &block)
    results = Array.new(items.size)
    mutex = Mutex.new
    index = -1

    threads = Array.new(num_threads) do
      Thread.new do
        loop do
          i = mutex.synchronize { index += 1 }
          break if i >= items.size

          results[i] = block.call(items[i])
        end
      end
    end

    threads.each(&:join)
    results
  end

  # Thread-safe counter
  class Counter
    def initialize(initial = 0)
      @value = initial
      @mutex = Mutex.new
    end

    def increment(by = 1)
      @mutex.synchronize { @value += by }
    end

    def decrement(by = 1)
      @mutex.synchronize { @value -= by }
    end

    def value
      @mutex.synchronize { @value }
    end
  end

  # Read-write lock (allows multiple readers, single writer)
  class ReadWriteLock
    def initialize
      @mutex = Mutex.new
      @readers = 0
      @writers_waiting = 0
      @writer_active = false
      @read_ok = ConditionVariable.new
      @write_ok = ConditionVariable.new
    end

    def read_lock
      @mutex.synchronize do
        @read_ok.wait(@mutex) while @writer_active || @writers_waiting > 0
        @readers += 1
      end
    end

    def read_unlock
      @mutex.synchronize do
        @readers -= 1
        @write_ok.signal if @readers.zero?
      end
    end

    def write_lock
      @mutex.synchronize do
        @writers_waiting += 1
        @write_ok.wait(@mutex) while @writer_active || @readers > 0
        @writers_waiting -= 1
        @writer_active = true
      end
    end

    def write_unlock
      @mutex.synchronize do
        @writer_active = false
        @write_ok.signal
        @read_ok.broadcast
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Ruby Threading Examples"
  puts "=" * 60

  puts "\n1. Basic Threading"
  puts "-" * 40
  threads = 5.times.map do |i|
    Thread.new(i) do |num|
      sleep(rand * 0.1)
      "Thread #{num} done"
    end
  end
  results = threads.map(&:value)
  puts "Results: #{results.inspect}"

  puts "\n2. Mutex Synchronization"
  puts "-" * 40
  counter = Threading::Counter.new
  threads = 10.times.map do
    Thread.new { 100.times { counter.increment } }
  end
  threads.each(&:join)
  puts "Counter (should be 1000): #{counter.value}"

  puts "\n3. Thread Pool"
  puts "-" * 40
  pool = Threading::ThreadPool.new(3)
  results = []
  mutex = Mutex.new

  5.times do |i|
    pool.schedule(i) do |num|
      sleep(0.05)
      mutex.synchronize { results << "Job #{num} done by #{Thread.current.object_id}" }
    end
  end

  pool.shutdown
  results.each { |r| puts "  #{r}" }

  puts "\n4. Parallel Map"
  puts "-" * 40
  data = (1..10).to_a
  squares = Threading.parallel_map(data, num_threads: 4) { |n| n * n }
  puts "Input:  #{data.inspect}"
  puts "Output: #{squares.inspect}"

  puts "\n5. Producer-Consumer"
  puts "-" * 40
  pc = Threading::ProducerConsumer.new(buffer_size: 5)
  items = (1..10).to_a
  consumed = []
  consumed_mutex = Mutex.new

  producer = pc.produce(items) { |i| puts "  Produced: #{i}" }
  consumer = pc.consume do |item|
    consumed_mutex.synchronize { consumed << item }
    puts "  Consumed: #{item}"
  end

  producer.join
  sleep 0.1 # Give consumer time to finish
  consumer.kill
  puts "Consumed items: #{consumed.sort.inspect}"
end
