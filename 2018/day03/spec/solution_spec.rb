require_relative '../solution'

RSpec.describe Day03 do
  let(:example_input) do
    <<~INPUT
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'counts overlapping square inches' do
      # Claims 1 and 2 overlap in a 2x2 area
      expect(subject.part1).to eq(4)
    end
  end

  describe '#part2' do
    it 'finds non-overlapping claim' do
      expect(subject.part2).to eq(3)
    end
  end

  describe 'Ruby idiom: Hash.new(0) for counting' do
    it 'provides default value for missing keys' do
      counts = Hash.new(0)
      counts[:a] += 1
      counts[:a] += 1
      counts[:b] += 1
      expect(counts[:a]).to eq(2)
      expect(counts[:b]).to eq(1)
      expect(counts[:c]).to eq(0)  # Default, not stored
    end

    it 'is cleaner than fetch with default' do
      h = Hash.new(0)
      h[:x] += 5
      expect(h[:x]).to eq(5)
    end
  end

  describe 'Ruby idiom: tuple as hash key' do
    it 'uses array as coordinate key' do
      grid = Hash.new(0)
      grid[[1, 2]] += 1
      grid[[1, 2]] += 1
      grid[[3, 4]] += 1
      expect(grid[[1, 2]]).to eq(2)
    end
  end

  describe 'Ruby idiom: named captures in regex' do
    it 'extracts named groups' do
      pattern = /#(?<id>\d+) @ (?<x>\d+),(?<y>\d+)/
      match = '#123 @ 5,10'.match(pattern)
      expect(match[:id]).to eq('123')
      expect(match[:x]).to eq('5')
      expect(match[:y]).to eq('10')
    end
  end

  describe 'Ruby idiom: nested all? for 2D check' do
    it 'checks all cells in rectangle' do
      grid = { [0, 0] => 1, [0, 1] => 1, [1, 0] => 1, [1, 1] => 2 }
      all_ones = (0..1).all? { |x| (0..1).all? { |y| grid[[x, y]] == 1 } }
      expect(all_ones).to be false
    end
  end

  describe 'Ruby idiom: count vs select.size' do
    it 'count with block is more efficient' do
      arr = [1, 2, 3, 4, 5]
      # Both work, but count doesn't create intermediate array
      expect(arr.count { |n| n > 2 }).to eq(3)
      expect(arr.select { |n| n > 2 }.size).to eq(3)
    end
  end

  describe 'Ruby idiom: exclusive range for iteration' do
    it 'excludes end value' do
      result = (0...3).to_a
      expect(result).to eq([0, 1, 2])
    end

    it 'is useful for x to x+width' do
      x, w = 5, 3
      expect((x...x + w).to_a).to eq([5, 6, 7])
    end
  end
end
