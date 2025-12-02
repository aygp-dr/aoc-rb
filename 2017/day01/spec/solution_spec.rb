require_relative '../solution'

RSpec.describe Day01 do
  describe '#part1' do
    it 'handles 1122 -> 3' do
      # First 1 matches second 1, third 2 matches fourth 2
      expect(Day01.new('1122').part1).to eq(3)
    end

    it 'handles 1111 -> 4' do
      # All digits match their neighbor
      expect(Day01.new('1111').part1).to eq(4)
    end

    it 'handles 1234 -> 0' do
      # No consecutive matches
      expect(Day01.new('1234').part1).to eq(0)
    end

    it 'handles 91212129 -> 9' do
      # Only the last 9 matches first 9 (circular)
      expect(Day01.new('91212129').part1).to eq(9)
    end
  end

  describe '#part2' do
    it 'handles 1212 -> 6' do
      # Each digit matches its opposite: 1=1, 2=2, 1=1, 2=2
      expect(Day01.new('1212').part2).to eq(6)
    end

    it 'handles 1221 -> 0' do
      # No matches halfway around
      expect(Day01.new('1221').part2).to eq(0)
    end

    it 'handles 123425 -> 4' do
      # Position 2 (3) doesn't match position 5 (5)
      # Position 3 (4) matches position 0 (but we check 3's pair which is 2)
      # Actually: 1-2, 2-5, 3-4, 4-1, 2-2, 5-3 -> only 2 matches 2 twice
      expect(Day01.new('123425').part2).to eq(4)
    end

    it 'handles 123123 -> 12' do
      # All positions match their opposite
      expect(Day01.new('123123').part2).to eq(12)
    end

    it 'handles 12131415 -> 4' do
      # Only the 1s match
      expect(Day01.new('12131415').part2).to eq(4)
    end
  end

  describe 'alternative implementations match' do
    let(:solver) { Day01.new('91212129') }

    it 'part1 variants agree' do
      expect(solver.part1_each_cons).to eq(solver.part1)
      expect(solver.part1_modulo).to eq(solver.part1)
    end

    it 'part2 variants agree' do
      solver2 = Day01.new('123123')
      expect(solver2.part2_modulo).to eq(solver2.part2)
    end
  end

  describe 'Ruby idiom: rotate' do
    it 'rotates array elements left' do
      expect([1, 2, 3, 4].rotate(1)).to eq([2, 3, 4, 1])
      expect([1, 2, 3, 4].rotate(2)).to eq([3, 4, 1, 2])
    end

    it 'rotates right with negative' do
      expect([1, 2, 3, 4].rotate(-1)).to eq([4, 1, 2, 3])
    end
  end

  describe 'Ruby idiom: zip' do
    it 'pairs elements from two arrays' do
      a = [1, 2, 3]
      b = ['a', 'b', 'c']
      expect(a.zip(b)).to eq([[1, 'a'], [2, 'b'], [3, 'c']])
    end

    it 'combines with rotate for circular pairing' do
      arr = [1, 2, 3, 4]
      # Pair each element with its neighbor (circular)
      pairs = arr.zip(arr.rotate(1))
      expect(pairs).to eq([[1, 2], [2, 3], [3, 4], [4, 1]])
    end
  end

  describe 'Ruby idiom: chars and map(&:to_i)' do
    it 'converts string to digit array' do
      expect('1234'.chars.map(&:to_i)).to eq([1, 2, 3, 4])
    end

    it 'symbol-to-proc works with any method' do
      expect(['hello', 'world'].map(&:upcase)).to eq(['HELLO', 'WORLD'])
      expect(['hello', 'world'].map(&:length)).to eq([5, 5])
    end
  end
end
