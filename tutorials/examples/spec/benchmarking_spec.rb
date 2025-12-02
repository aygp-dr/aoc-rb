# frozen_string_literal: true

require_relative '../benchmarking'

RSpec.describe Benchmarking do
  describe '.allocations' do
    it 'tracks object allocations' do
      result = Benchmarking.allocations { Array.new(100) { |i| i.to_s } }

      expect(result[:result]).to be_an(Array)
      expect(result[:result].size).to eq(100)
      expect(result[:allocations]).to be_a(Hash)
      expect(result[:allocations][:T_STRING]).to be > 0
    end

    it 'returns empty allocations for simple operations' do
      result = Benchmarking.allocations { 1 + 1 }

      expect(result[:result]).to eq(2)
    end
  end

  describe '.gc_activity' do
    it 'tracks GC activity during execution' do
      result = Benchmarking.gc_activity do
        1000.times { |i| i.to_s }
      end

      expect(result[:result]).to be_nil # times returns nil
      expect(result).to have_key(:gc_count)
      expect(result).to have_key(:minor_gc)
      expect(result).to have_key(:major_gc)
      expect(result).to have_key(:allocated_objects)
    end
  end

  describe '.memsize' do
    it 'returns memory size of an array' do
      array = Array.new(100) { |i| i }
      size = Benchmarking.memsize(array)

      expect(size).to be > 0
      expect(size).to be_a(Integer)
    end

    it 'returns memory size of a hash' do
      hash = { a: 1, b: 2, c: 3 }
      size = Benchmarking.memsize(hash)

      expect(size).to be > 0
    end

    it 'returns memory size of a string' do
      string = 'x' * 1000
      size = Benchmarking.memsize(string)

      expect(size).to be >= 1000
    end
  end

  describe '.memsize_deep' do
    it 'includes referenced objects in size calculation' do
      array = Array.new(10) { |i| "string_#{i}" }

      shallow = Benchmarking.memsize(array)
      deep = Benchmarking.memsize_deep(array)

      expect(deep).to be > shallow
    end
  end
end
