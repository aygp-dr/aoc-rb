require_relative '../solution'

RSpec.describe Day01 do
  describe '#part1' do
    it 'sums positive and negative changes' do
      solver = Day01.new("+1\n-2\n+3\n+1")
      expect(solver.part1).to eq(3)
    end

    it 'handles all positive' do
      solver = Day01.new("+1\n+1\n+1")
      expect(solver.part1).to eq(3)
    end

    it 'handles all negative' do
      solver = Day01.new("-1\n-2\n-3")
      expect(solver.part1).to eq(-6)
    end

    it 'handles net zero' do
      solver = Day01.new("+1\n+1\n-2")
      expect(solver.part1).to eq(0)
    end
  end

  describe '#part2' do
    it 'finds first repeated frequency with +1, -1' do
      # 0 -> 1 -> 0 (repeated!)
      solver = Day01.new("+1\n-1")
      expect(solver.part2).to eq(0)
    end

    it 'finds first repeated frequency with longer cycle' do
      # 0 -> 3 -> 6 -> 9 -> 6 -> 3 -> 0 -> ...
      # -3 brings us back down, cycling through: 0,3,6,9,6,3,0,3,6,...
      # First repeat: need to trace carefully
      # +3,-3,+6,-6: 0->3->0 first repeat is 0
      solver = Day01.new("+3\n+3\n+4\n-2\n-4")
      expect(solver.part2).to eq(10)
    end

    it 'finds 10 as first repeated with example' do
      # 0 → 3 → 6 → 10 → 8 → 4 → 7 → 10 (first repeat)
      solver = Day01.new("+3\n+3\n+4\n-2\n-4")
      expect(solver.part2).to eq(10)
    end

    it 'finds 5 as repeated frequency' do
      solver = Day01.new("-6\n+3\n+8\n+5\n-6")
      expect(solver.part2).to eq(5)
    end

    it 'finds 14 as repeated frequency' do
      solver = Day01.new("+7\n+7\n-2\n-7\n-4")
      expect(solver.part2).to eq(14)
    end
  end

  describe 'Ruby idiom: cycle' do
    it 'creates infinite iterator' do
      iter = [1, 2, 3].cycle
      results = 7.times.map { iter.next }
      expect(results).to eq([1, 2, 3, 1, 2, 3, 1])
    end
  end

  describe 'Ruby idiom: Set#add?' do
    it 'returns element if new, nil if duplicate' do
      s = Set.new
      expect(s.add?(1)).to eq(Set[1])  # returns the set
      expect(s.add?(2)).to eq(Set[1, 2])
      expect(s.add?(1)).to be_nil  # already present
    end
  end

  describe 'Ruby idiom: Array#sum vs reduce' do
    it 'sum is cleaner than reduce(:+)' do
      arr = [1, 2, 3, 4, 5]
      expect(arr.sum).to eq(15)
      expect(arr.reduce(:+)).to eq(15)
      expect(arr.reduce(0, :+)).to eq(15)
    end
  end
end
