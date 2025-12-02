require_relative '../solution'

RSpec.describe Day03 do
  let(:example_input) do
    <<~INPUT
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'sums part numbers adjacent to symbols' do
      # Not adjacent: 114, 58
      # Adjacent: 467, 35, 633, 617, 592, 755, 664, 598
      expect(subject.part1).to eq(4361)
    end
  end

  describe '#part2' do
    it 'sums gear ratios' do
      # Gear at row 1: 467 * 35 = 16345
      # Gear at row 8: 755 * 598 = 451490
      # Total: 467835
      expect(subject.part2).to eq(467835)
    end
  end

  describe 'Ruby idiom: scan with Regexp.last_match' do
    it 'accesses match position' do
      text = "abc123def456"
      positions = []
      text.scan(/\d+/) do |match|
        positions << [match, Regexp.last_match.begin(0)]
      end
      expect(positions).to eq([['123', 3], ['456', 9]])
    end
  end

  describe 'Ruby idiom: MatchData#begin' do
    it 'returns start index of match' do
      m = "hello world".match(/world/)
      expect(m.begin(0)).to eq(6)
    end

    it 'works with captures' do
      m = "hello world".match(/(wor)(ld)/)
      expect(m.begin(0)).to eq(6)  # Whole match
      expect(m.begin(1)).to eq(6)  # First capture
      expect(m.begin(2)).to eq(9)  # Second capture
    end
  end

  describe 'Ruby idiom: String#match?' do
    it 'returns boolean without creating MatchData' do
      expect('123'.match?(/\d+/)).to be true
      expect('abc'.match?(/\d+/)).to be false
    end

    it 'is faster than match for simple checks' do
      # match? doesn't allocate MatchData object
      str = 'test123'
      expect(str.match?(/\d/)).to be true
    end
  end

  describe 'Ruby idiom: Set for coordinate storage' do
    it 'eliminates duplicate coordinates' do
      coords = Set.new
      coords.add([1, 2])
      coords.add([1, 2])
      coords.add([3, 4])
      expect(coords.size).to eq(2)
    end

    it 'supports include? check' do
      coords = Set[[1, 2], [3, 4]]
      expect(coords.include?([1, 2])).to be true
      expect(coords.include?([5, 6])).to be false
    end
  end

  describe 'Ruby idiom: nested range iteration' do
    it 'iterates over 2D region' do
      coords = []
      (0..1).each do |y|
        (0..2).each do |x|
          coords << [y, x]
        end
      end
      expect(coords).to eq([[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2]])
    end
  end
end
