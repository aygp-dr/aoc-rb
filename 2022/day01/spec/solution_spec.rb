require_relative '../solution'

RSpec.describe Day01 do
  let(:example_input) do
    <<~INPUT
      1000
      2000
      3000

      4000

      5000
      6000

      7000
      8000
      9000

      10000
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#parse_elves' do
    it 'parses into 5 elves' do
      expect(subject.parse_elves.length).to eq(5)
    end

    it 'parses first elf correctly' do
      expect(subject.parse_elves[0]).to eq([1000, 2000, 3000])
    end

    it 'parses second elf correctly' do
      expect(subject.parse_elves[1]).to eq([4000])
    end
  end

  describe '#elf_totals' do
    it 'calculates correct totals for each elf' do
      expect(subject.elf_totals).to eq([6000, 4000, 11000, 24000, 10000])
    end
  end

  describe '#part1' do
    it 'finds the elf carrying the most calories' do
      expect(subject.part1).to eq(24000)
    end
  end

  describe '#part2' do
    it 'finds the sum of top three elves' do
      # Top 3: 24000 + 11000 + 10000 = 45000
      expect(subject.part2).to eq(45000)
    end
  end
end
