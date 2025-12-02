# frozen_string_literal: true

require_relative '../threading'

RSpec.describe Threading do
  describe Threading::ThreadPool do
    it 'executes jobs across threads' do
      results = []
      mutex = Mutex.new
      pool = Threading::ThreadPool.new(2)

      5.times do |i|
        pool.schedule(i) do |num|
          mutex.synchronize { results << num }
        end
      end

      pool.shutdown

      expect(results.sort).to eq([0, 1, 2, 3, 4])
    end
  end

  describe Threading::Counter do
    it 'starts at initial value' do
      counter = Threading::Counter.new(10)
      expect(counter.value).to eq(10)
    end

    it 'increments atomically' do
      counter = Threading::Counter.new

      threads = 10.times.map do
        Thread.new { 100.times { counter.increment } }
      end
      threads.each(&:join)

      expect(counter.value).to eq(1000)
    end

    it 'decrements atomically' do
      counter = Threading::Counter.new(1000)

      threads = 10.times.map do
        Thread.new { 100.times { counter.decrement } }
      end
      threads.each(&:join)

      expect(counter.value).to eq(0)
    end
  end

  describe '.parallel_map' do
    it 'maps function over items in parallel' do
      items = (1..10).to_a
      results = Threading.parallel_map(items, num_threads: 4) { |n| n * n }

      expect(results).to eq([1, 4, 9, 16, 25, 36, 49, 64, 81, 100])
    end

    it 'preserves order' do
      items = (1..100).to_a
      results = Threading.parallel_map(items, num_threads: 8, &:itself)

      expect(results).to eq(items)
    end

    it 'handles empty input' do
      results = Threading.parallel_map([], num_threads: 4) { |n| n * 2 }

      expect(results).to eq([])
    end
  end

  describe Threading::ProducerConsumer do
    it 'produces and consumes items' do
      pc = Threading::ProducerConsumer.new(buffer_size: 5)
      items = (1..5).to_a
      consumed = []
      mutex = Mutex.new

      producer = pc.produce(items)
      consumer = pc.consume { |item| mutex.synchronize { consumed << item } }

      producer.join
      sleep 0.1
      consumer.kill

      expect(consumed.sort).to eq(items)
    end
  end
end
