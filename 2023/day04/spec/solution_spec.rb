require_relative '../solution'

RSpec.describe Day04 do
  let(:example_input) do
    <<~INPUT
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'sums card points' do
      # Card 1: 4 matches = 8 points
      # Card 2: 2 matches = 2 points
      # Card 3: 2 matches = 2 points
      # Card 4: 1 match = 1 point
      # Card 5: 0 matches = 0 points
      # Card 6: 0 matches = 0 points
      # Total: 13
      expect(subject.part1).to eq(13)
    end
  end

  describe '#part2' do
    it 'counts total cards with copies' do
      expect(subject.part2).to eq(30)
    end
  end

  describe 'Ruby idiom: bit shift for powers of 2' do
    it 'calculates 2^n efficiently' do
      expect(1 << 0).to eq(1)   # 2^0
      expect(1 << 1).to eq(2)   # 2^1
      expect(1 << 2).to eq(4)   # 2^2
      expect(1 << 3).to eq(8)   # 2^3
      expect(1 << 10).to eq(1024)
    end

    it 'is equivalent to 2**n' do
      (0..10).each do |n|
        expect(1 << n).to eq(2**n)
      end
    end
  end

  describe 'Ruby idiom: Set intersection' do
    it 'finds common elements with &' do
      a = Set[1, 2, 3, 4]
      b = Set[3, 4, 5, 6]
      expect(a & b).to eq(Set[3, 4])
    end

    it 'works with array intersection too' do
      a = [1, 2, 3, 4]
      b = [3, 4, 5, 6]
      expect(a & b).to eq([3, 4])
    end
  end

  describe 'Ruby idiom: Array.new with value' do
    it 'creates array with initial values' do
      expect(Array.new(3, 0)).to eq([0, 0, 0])
      expect(Array.new(4, 1)).to eq([1, 1, 1, 1])
    end

    it 'shares same object reference (careful with mutable!)' do
      arr = Array.new(3, [])
      arr[0] << 1
      # All elements point to same array!
      expect(arr).to eq([[1], [1], [1]])
    end

    it 'uses block for independent objects' do
      arr = Array.new(3) { [] }
      arr[0] << 1
      expect(arr).to eq([[1], [], []])
    end
  end

  describe 'Ruby idiom: split with multiple spaces' do
    it 'splits on whitespace by default' do
      # split with no argument splits on whitespace and removes empty strings
      expect("1  2   3".split).to eq(['1', '2', '3'])
    end
  end

  describe 'Ruby idiom: to_set for conversion' do
    it 'converts array to set' do
      arr = [1, 2, 2, 3]
      expect(arr.to_set).to eq(Set[1, 2, 3])
    end
  end
end
