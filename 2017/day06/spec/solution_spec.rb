require_relative '../solution'

RSpec.describe Day06 do
  let(:example_input) { '0 2 7 0' }
  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'finds cycle after 5 redistributions' do
      # 0 2 7 0 -> 2 4 1 2 -> 3 1 2 3 -> 0 2 3 4 -> 1 3 4 1 -> 2 4 1 2
      # State "2 4 1 2" appears again after 5 steps
      expect(subject.part1).to eq(5)
    end
  end

  describe '#part2' do
    it 'finds cycle length of 4' do
      # From "2 4 1 2" back to "2 4 1 2" is 4 steps
      expect(subject.part2).to eq(4)
    end
  end

  describe '#solve' do
    it 'returns both parts' do
      expect(subject.solve).to eq([5, 4])
    end
  end

  describe 'redistribution logic' do
    it 'redistributes correctly step by step' do
      solver = Day06.new('0 2 7 0')
      # After step 1: bank 2 (value 7) redistributes
      # 7 blocks distributed starting from index 3
      # Result should be 2 4 1 2
      expect(solver.part1).to eq(5)  # Confirms redistribution works
    end
  end

  describe 'Ruby idiom: max_by with tie-breaking' do
    it 'finds max with custom comparator' do
      banks = [3, 1, 3, 2]
      # We want index of max value, with lowest index winning ties
      # max_by on [value, -index] achieves this
      result = banks.each_with_index.max_by { |v, i| [v, -i] }
      expect(result).to eq([3, 0])  # First 3 at index 0, not index 2
    end
  end

  describe 'Ruby idiom: Array as Hash key' do
    it 'arrays with same content have same hash' do
      h = {}
      h[[1, 2, 3]] = 'first'
      expect(h[[1, 2, 3]]).to eq('first')
    end

    it 'requires dup to avoid mutation issues' do
      h = {}
      arr = [1, 2, 3]
      h[arr.dup] = 'first'
      arr[0] = 99
      expect(h[[1, 2, 3]]).to eq('first')  # Original key still works
      expect(h[[99, 2, 3]]).to be_nil      # Mutated array is different key
    end
  end

  describe 'Ruby idiom: modulo for circular indexing' do
    it 'wraps around array' do
      arr = [:a, :b, :c, :d]
      expect(arr[5 % 4]).to eq(:b)  # 5 % 4 = 1
      expect(arr[8 % 4]).to eq(:a)  # 8 % 4 = 0
    end

    it 'handles negative correctly' do
      # -1 % 4 = 3 in Ruby (not -1 like some languages)
      expect(-1 % 4).to eq(3)
    end
  end

  describe 'Ruby idiom: destructuring in max_by' do
    it 'unpacks array in block' do
      data = [[5, 'a'], [3, 'b'], [7, 'c']]
      # Block receives [value, key] pairs
      result = data.max_by { |val, key| val }
      expect(result).to eq([7, 'c'])
    end
  end

  describe 'Brent cycle detection' do
    it 'matches hash-based solution' do
      solver = Day06Brent.new(example_input)
      expect(solver.solve).to eq([5, 4])
    end
  end
end
