require_relative '../solution'

RSpec.describe Day02 do
  let(:example_input) do
    <<~INPUT
      7 6 4 2 1
      1 2 7 8 9
      9 7 6 2 1
      1 3 2 4 5
      8 6 4 4 1
      1 3 6 7 9
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'counts safe reports' do
      # Safe: 7 6 4 2 1 (decreasing by 1-2)
      # Unsafe: 1 2 7 8 9 (jump of 5)
      # Unsafe: 9 7 6 2 1 (jump of 4)
      # Unsafe: 1 3 2 4 5 (not monotonic)
      # Unsafe: 8 6 4 4 1 (no change 4->4)
      # Safe: 1 3 6 7 9 (increasing by 2,3,1,2)
      expect(subject.part1).to eq(2)
    end
  end

  describe '#part2' do
    it 'counts safe reports with dampener' do
      # Now 4 are safe (can remove one bad level)
      expect(subject.part2).to eq(4)
    end
  end

  describe 'Ruby idiom: Range#cover?' do
    it 'checks if value is within range' do
      expect((1..3).cover?(2)).to be true
      expect((1..3).cover?(0)).to be false
      expect((1..3).cover?(4)).to be false
    end

    it 'works with negative ranges' do
      expect((-3..-1).cover?(-2)).to be true
      expect((-3..-1).cover?(0)).to be false
    end

    it 'is faster than include? for continuous ranges' do
      # cover? is O(1) - just checks bounds
      # include? iterates through range
      r = (1..1_000_000)
      expect(r.cover?(500_000)).to be true
    end
  end

  describe 'Ruby idiom: all? with block' do
    it 'returns true if all elements match' do
      expect([2, 4, 6].all?(&:even?)).to be true
      expect([2, 3, 6].all?(&:even?)).to be false
    end

    it 'short-circuits on first false' do
      checked = []
      [1, 2, 3].all? { |n| checked << n; n < 2 }
      expect(checked).to eq([1, 2])  # Stopped at 2
    end
  end

  describe 'Ruby idiom: combination for subsets' do
    it 'generates all k-element subsets' do
      arr = [1, 2, 3, 4]
      subsets = arr.combination(3).to_a
      expect(subsets).to eq([
        [1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]
      ])
    end

    it 'is useful for "remove one" problems' do
      arr = [:a, :b, :c]
      # All ways to remove one element = all subsets of size n-1
      expect(arr.combination(2).to_a).to eq([
        [:a, :b], [:a, :c], [:b, :c]
      ])
    end
  end

  describe 'Ruby idiom: numbered parameters in map' do
    it 'uses _1, _2 for pair elements' do
      pairs = [[1, 2], [3, 4], [5, 6]]
      diffs = pairs.map { _2 - _1 }
      expect(diffs).to eq([1, 1, 1])
    end
  end
end
