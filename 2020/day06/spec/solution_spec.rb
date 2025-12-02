require_relative '../solution'

RSpec.describe Day06 do
  let(:example_input) do
    <<~INPUT
      abc

      a
      b
      c

      ab
      ac

      a
      a
      a
      a

      b
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'counts union of answers per group' do
      # Group 1: abc -> 3 unique
      # Group 2: a,b,c -> 3 unique (a|b|c)
      # Group 3: ab,ac -> 3 unique (a,b,c)
      # Group 4: a,a,a,a -> 1 unique
      # Group 5: b -> 1 unique
      # Total: 3+3+3+1+1 = 11
      expect(subject.part1).to eq(11)
    end
  end

  describe '#part2' do
    it 'counts intersection of answers per group' do
      # Group 1: abc -> 3 (all answered all)
      # Group 2: a,b,c -> 0 (no common)
      # Group 3: ab,ac -> 1 (only 'a' common)
      # Group 4: a,a,a,a -> 1 (all said 'a')
      # Group 5: b -> 1 (only person said 'b')
      # Total: 3+0+1+1+1 = 6
      expect(subject.part2).to eq(6)
    end
  end

  describe 'Ruby idiom: Set operations' do
    it 'union with | combines elements' do
      a = Set[1, 2, 3]
      b = Set[2, 3, 4]
      expect(a | b).to eq(Set[1, 2, 3, 4])
    end

    it 'intersection with & finds common elements' do
      a = Set[1, 2, 3]
      b = Set[2, 3, 4]
      expect(a & b).to eq(Set[2, 3])
    end

    it 'difference with - removes elements' do
      a = Set[1, 2, 3]
      b = Set[2, 3, 4]
      expect(a - b).to eq(Set[1])
    end
  end

  describe 'Ruby idiom: reduce with symbol operators' do
    it 'reduce(:|) for union across array of sets' do
      sets = [Set[1, 2], Set[2, 3], Set[3, 4]]
      expect(sets.reduce(:|)).to eq(Set[1, 2, 3, 4])
    end

    it 'reduce(:&) for intersection across array of sets' do
      sets = [Set[1, 2, 3], Set[2, 3, 4], Set[2, 3, 5]]
      expect(sets.reduce(:&)).to eq(Set[2, 3])
    end
  end

  describe 'Ruby idiom: chars.to_set' do
    it 'converts string to set of characters' do
      expect('abc'.chars.to_set).to eq(Set['a', 'b', 'c'])
      expect('aab'.chars.to_set).to eq(Set['a', 'b'])  # duplicates removed
    end
  end

  describe 'Ruby idiom: split on blank lines' do
    it 'splits paragraphs with /\\n\\n/' do
      text = "para1\n\npara2\n\npara3"
      expect(text.split(/\n\n/)).to eq(['para1', 'para2', 'para3'])
    end

    it 'handles multiple blank lines' do
      text = "a\n\n\nb"
      expect(text.split(/\n\n+/)).to eq(['a', 'b'])
    end
  end

  describe 'alternative string implementation' do
    let(:solver) { Day06String.new(example_input) }

    it 'part1 matches set implementation' do
      expect(solver.part1).to eq(11)
    end

    it 'part2 matches set implementation' do
      expect(solver.part2).to eq(6)
    end
  end
end
