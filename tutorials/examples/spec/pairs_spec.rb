# frozen_string_literal: true

require_relative '../pairs'

RSpec.describe 'Church-encoded Pairs' do
  describe '#pair, #first, #second' do
    it 'creates a pair and extracts first element' do
      p = pair(42, 'hello')
      expect(first(p)).to eq(42)
    end

    it 'creates a pair and extracts second element' do
      p = pair(42, 'hello')
      expect(second(p)).to eq('hello')
    end

    it 'works with different types' do
      p = pair([1, 2, 3], { a: 1 })
      expect(first(p)).to eq([1, 2, 3])
      expect(second(p)).to eq({ a: 1 })
    end

    it 'handles nil values' do
      p = pair(nil, nil)
      expect(first(p)).to be_nil
      expect(second(p)).to be_nil
    end
  end

  describe 'nested pairs' do
    it 'supports nested pairs (2x2 matrix)' do
      nested = pair(pair(1, 2), pair(3, 4))

      expect(first(first(nested))).to eq(1)
      expect(second(first(nested))).to eq(2)
      expect(first(second(nested))).to eq(3)
      expect(second(second(nested))).to eq(4)
    end
  end

  describe '#pair_to_array' do
    it 'converts a pair to an array' do
      p = pair(1, 2)
      expect(pair_to_array(p)).to eq([1, 2])
    end
  end

  describe 'Lisp-style list operations' do
    describe '#cons, #car, #cdr' do
      it 'builds and traverses a list' do
        list = cons(1, cons(2, cons(3, nil)))

        expect(car(list)).to eq(1)
        expect(car(cdr(list))).to eq(2)
        expect(car(cdr(cdr(list)))).to eq(3)
        expect(cdr(cdr(cdr(list)))).to be_nil
      end
    end
  end
end
