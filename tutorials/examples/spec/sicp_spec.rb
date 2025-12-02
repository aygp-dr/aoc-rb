# frozen_string_literal: true

require_relative '../sicp'

RSpec.describe 'SICP-style List Operations' do
  describe '#accumulate' do
    it 'sums a list' do
      result = accumulate(:+.to_proc, 0, [1, 2, 3, 4, 5])
      expect(result).to eq(15)
    end

    it 'multiplies a list' do
      result = accumulate(:*.to_proc, 1, [1, 2, 3, 4, 5])
      expect(result).to eq(120)
    end

    it 'returns initial value for empty list' do
      result = accumulate(:+.to_proc, 42, [])
      expect(result).to eq(42)
    end
  end

  describe '#map_acc' do
    it 'maps a function over a list' do
      result = map_acc(->(x) { x * x }, [1, 2, 3, 4, 5])
      expect(result).to eq([1, 4, 9, 16, 25])
    end

    it 'returns empty array for empty input' do
      result = map_acc(->(x) { x * 2 }, [])
      expect(result).to eq([])
    end
  end

  describe '#filter_acc' do
    it 'filters elements matching predicate' do
      result = filter_acc(->(x) { x.odd? }, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
      expect(result).to eq([1, 3, 5, 7, 9])
    end

    it 'returns empty array when nothing matches' do
      result = filter_acc(->(x) { x > 100 }, [1, 2, 3])
      expect(result).to eq([])
    end
  end

  describe '#append' do
    it 'concatenates two lists' do
      result = append([1, 2, 3], [4, 5, 6])
      expect(result).to eq([1, 2, 3, 4, 5, 6])
    end

    it 'handles empty first list' do
      result = append([], [1, 2, 3])
      expect(result).to eq([1, 2, 3])
    end

    it 'handles empty second list' do
      result = append([1, 2, 3], [])
      expect(result).to eq([1, 2, 3])
    end
  end

  describe '#length' do
    it 'returns length of list' do
      expect(length([1, 2, 3, 4, 5])).to eq(5)
    end

    it 'returns 0 for empty list' do
      expect(length([])).to eq(0)
    end
  end

  describe '#reverse_list' do
    it 'reverses a list' do
      result = reverse_list([1, 2, 3, 4, 5])
      expect(result).to eq([5, 4, 3, 2, 1])
    end

    it 'handles empty list' do
      expect(reverse_list([])).to eq([])
    end

    it 'handles single element' do
      expect(reverse_list([42])).to eq([42])
    end
  end

  describe '#flatmap' do
    it 'maps and flattens results' do
      result = flatmap(->(i) { [[i, i * i]] }, [1, 2, 3])
      expect(result).to eq([[1, 1], [2, 4], [3, 9]])
    end
  end
end
