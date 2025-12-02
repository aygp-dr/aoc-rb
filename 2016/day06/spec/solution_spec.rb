require_relative '../solution'

RSpec.describe Day06 do
  let(:example_input) do
    <<~INPUT
      eedadn
      drvtee
      eandsr
      raavrd
      atevrs
      tsrnev
      sdttsa
      rasrtv
      nssdts
      ntnada
      svetve
      tesnvt
      vntsnd
      vrdear
      dvrsen
      enarar
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'finds most common char per column' do
      expect(subject.part1).to eq('easter')
    end
  end

  describe '#part2' do
    it 'finds least common char per column' do
      expect(subject.part2).to eq('advent')
    end
  end

  describe 'Ruby idiom: transpose for columns' do
    it 'converts rows to columns' do
      rows = [
        ['a', 'b', 'c'],
        ['d', 'e', 'f'],
        ['g', 'h', 'i']
      ]
      columns = rows.transpose
      expect(columns[0]).to eq(['a', 'd', 'g'])
      expect(columns[1]).to eq(['b', 'e', 'h'])
    end

    it 'works with strings via chars' do
      lines = ['abc', 'def'].map(&:chars)
      expect(lines.transpose.map(&:join)).to eq(['ad', 'be', 'cf'])
    end
  end

  describe 'Ruby idiom: tally + max_by/min_by' do
    it 'finds most common element' do
      chars = ['a', 'b', 'a', 'c', 'a', 'b']
      most = chars.tally.max_by { |_, count| count }.first
      expect(most).to eq('a')
    end

    it 'finds least common element' do
      chars = ['a', 'b', 'a', 'c', 'a', 'b']
      least = chars.tally.min_by { |_, count| count }.first
      expect(least).to eq('c')
    end
  end

  describe 'Ruby idiom: map + join for string building' do
    it 'transforms and concatenates' do
      columns = [['a', 'b'], ['c', 'd'], ['e', 'f']]
      result = columns.map(&:first).join
      expect(result).to eq('ace')
    end
  end

  describe 'Ruby idiom: max_by vs max' do
    it 'max returns maximum element' do
      expect([1, 3, 2].max).to eq(3)
    end

    it 'max_by returns element with max computed value' do
      words = ['a', 'bbb', 'cc']
      expect(words.max_by(&:length)).to eq('bbb')
    end

    it 'max_by on hash entries returns [key, value] pair' do
      freq = { 'a' => 3, 'b' => 1 }
      expect(freq.max_by { |_, v| v }).to eq(['a', 3])
    end
  end
end
