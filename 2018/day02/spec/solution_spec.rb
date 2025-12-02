require_relative '../solution'

RSpec.describe Day02 do
  describe '#part1' do
    let(:example_input) do
      <<~INPUT
        abcdef
        bababc
        abbcde
        abcccd
        aabcdd
        abcdee
        ababab
      INPUT
    end

    it 'calculates checksum' do
      solver = Day02.new(example_input)
      # Has 2 of letter: bababc, abbcde, aabcdd, abcdee (4)
      # Has 3 of letter: bababc, abcccd, ababab (3)
      # Checksum: 4 * 3 = 12
      expect(solver.part1).to eq(12)
    end
  end

  describe '#part2' do
    let(:example_input) do
      <<~INPUT
        abcde
        fghij
        klmno
        pqrst
        fguij
        axcye
        wvxyz
      INPUT
    end

    it 'finds common letters of similar IDs' do
      solver = Day02.new(example_input)
      # fghij and fguij differ by one char (h vs u at position 2)
      # Common: fgij
      expect(solver.part2).to eq('fgij')
    end
  end

  describe 'Ruby idiom: tally.values.include?' do
    it 'checks if any character appears n times' do
      expect('aabbc'.chars.tally.values.include?(2)).to be true   # a and b appear twice
      expect('aabbc'.chars.tally.values.include?(3)).to be false  # none appear 3 times
    end
  end

  describe 'Ruby idiom: zip for parallel iteration' do
    it 'pairs elements from two arrays' do
      expect([1, 2, 3].zip([4, 5, 6])).to eq([[1, 4], [2, 5], [3, 6]])
    end

    it 'pairs characters from strings' do
      s1, s2 = 'abc', 'axc'
      pairs = s1.chars.zip(s2.chars)
      expect(pairs).to eq([['a', 'a'], ['b', 'x'], ['c', 'c']])
    end

    it 'finds differing positions' do
      s1, s2 = 'abc', 'axc'
      diffs = s1.chars.zip(s2.chars).select { |a, b| a != b }
      expect(diffs).to eq([['b', 'x']])
    end
  end

  describe 'Ruby idiom: combination(2) for pairs' do
    it 'generates all unique pairs' do
      items = ['a', 'b', 'c']
      pairs = items.combination(2).to_a
      expect(pairs).to eq([['a', 'b'], ['a', 'c'], ['b', 'c']])
    end

    it 'is efficient for finding matching pair' do
      ids = ['abc', 'def', 'abx']
      found = ids.combination(2).find { |a, b| a[0..1] == b[0..1] }
      expect(found).to eq(['abc', 'abx'])
    end
  end

  describe 'Ruby idiom: select + map chain' do
    it 'filters then transforms' do
      pairs = [['a', 'a'], ['b', 'x'], ['c', 'c']]
      matches = pairs.select { |a, b| a == b }.map(&:first)
      expect(matches).to eq(['a', 'c'])
    end
  end
end
