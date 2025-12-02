# frozen_string_literal: true

require_relative '../fib'

RSpec.describe 'Fibonacci' do
  describe '#fib' do
    it 'returns 0 for fib(0)' do
      expect(fib(0)).to eq(0)
    end

    it 'returns 1 for fib(1)' do
      expect(fib(1)).to eq(1)
    end

    it 'returns 1 for fib(2)' do
      expect(fib(2)).to eq(1)
    end

    it 'returns 55 for fib(10)' do
      expect(fib(10)).to eq(55)
    end

    it 'returns 6765 for fib(20)' do
      expect(fib(20)).to eq(6765)
    end

    it 'returns 832040 for fib(30)' do
      expect(fib(30)).to eq(832_040)
    end
  end

  describe 'FIB constant (Hash-based memoization)' do
    it 'calculates fib(10) correctly' do
      expect(FIB[10]).to eq(55)
    end

    it 'calculates fib(20) correctly' do
      expect(FIB[20]).to eq(6765)
    end

    it 'memoizes values' do
      # Access fib(15) twice
      first = FIB[15]
      second = FIB[15]
      expect(first).to eq(second)
      expect(first).to eq(610)
    end
  end
end
