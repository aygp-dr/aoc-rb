require_relative '../solution'

RSpec.describe Day01 do
  let(:example_input) do
    <<~INPUT
      1721
      979
      366
      299
      675
      1456
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'finds product of two entries summing to 2020' do
      # 1721 + 299 = 2020
      # 1721 * 299 = 514579
      expect(subject.part1).to eq(514579)
    end
  end

  describe '#part1_optimized' do
    it 'uses hash-based approach for O(n) solution' do
      expect(subject.part1_optimized).to eq(514579)
    end
  end

  describe '#part2' do
    it 'finds product of three entries summing to 2020' do
      # 979 + 366 + 675 = 2020
      # 979 * 366 * 675 = 241861950
      expect(subject.part2).to eq(241861950)
    end
  end

  describe 'Ruby idiom: combination' do
    it 'generates all k-element combinations' do
      arr = [1, 2, 3, 4]
      pairs = arr.combination(2).to_a
      expect(pairs).to eq([[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]])
    end

    it 'generates triplets' do
      arr = [1, 2, 3, 4]
      triplets = arr.combination(3).to_a
      expect(triplets).to eq([[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]])
    end
  end

  describe 'Ruby idiom: reduce with symbol' do
    it 'multiplies array elements' do
      expect([2, 3, 4].reduce(:*)).to eq(24)
    end

    it 'sums array elements' do
      expect([1, 2, 3].reduce(:+)).to eq(6)
    end
  end
end
