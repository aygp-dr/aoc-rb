require_relative '../solution'

RSpec.describe Day01 do
  describe '#part1' do
    it 'returns 0 for (()) and ()()' do
      expect(Day01.new('(())').part1).to eq(0)
      expect(Day01.new('()()').part1).to eq(0)
    end

    it 'returns 3 for ((( and (()(()(' do
      expect(Day01.new('(((').part1).to eq(3)
      expect(Day01.new('(()(()(').part1).to eq(3)
    end

    it 'returns 3 for ))(((((' do
      expect(Day01.new('))(((((').part1).to eq(3)
    end

    it 'returns -1 for ()) and ))(' do
      expect(Day01.new('())').part1).to eq(-1)
      expect(Day01.new('))(').part1).to eq(-1)
    end

    it 'returns -3 for ))) and )())())' do
      expect(Day01.new(')))').part1).to eq(-3)
      expect(Day01.new(')())())').part1).to eq(-3)
    end
  end

  describe '#part2' do
    it 'returns 1 when first character causes basement entry' do
      expect(Day01.new(')').part2).to eq(1)
    end

    it 'returns 5 for ()())' do
      expect(Day01.new('()())').part2).to eq(5)
    end

    it 'returns nil when Santa never enters basement' do
      expect(Day01.new('(((').part2).to be_nil
    end
  end
end
