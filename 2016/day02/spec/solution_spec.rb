require_relative '../solution'

RSpec.describe Day02 do
  let(:example_input) do
    <<~INPUT
      ULL
      RRDDD
      LURDL
      UUUUD
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'finds bathroom code on standard keypad' do
      expect(subject.part1).to eq('1985')
    end
  end

  describe '#part2' do
    it 'finds bathroom code on diamond keypad' do
      expect(subject.part2).to eq('5DB3')
    end
  end

  describe 'Ruby idiom: nested inject/reduce' do
    it 'accumulates through multiple levels' do
      lines = ['ab', 'cd']
      # Outer inject: accumulate result across lines
      # Inner reduce: process each character
      result = lines.inject('') do |acc, line|
        acc + line.chars.reduce('') { |s, c| s + c.upcase }
      end
      expect(result).to eq('ABCD')
    end
  end

  describe 'Ruby idiom: Hash for state machine' do
    it 'maps state + input to new state' do
      transitions = {
        'A' => { 'x' => 'B', 'y' => 'A' },
        'B' => { 'x' => 'A', 'y' => 'B' }
      }
      state = 'A'
      'xxy'.each_char { |c| state = transitions[state][c] }
      expect(state).to eq('B')  # A->B->A->B
    end
  end

  describe 'Ruby idiom: each_char vs chars.each' do
    it 'iterates over characters' do
      result = []
      'abc'.each_char { |c| result << c }
      expect(result).to eq(['a', 'b', 'c'])
    end

    it 'chars returns array for chaining' do
      expect('abc'.chars.map(&:upcase)).to eq(['A', 'B', 'C'])
    end
  end

  describe 'Ruby idiom: inject with array accumulator' do
    it 'tracks multiple values through iteration' do
      # Track both sum and count
      sum, count = [1, 2, 3, 4].inject([0, 0]) do |(s, c), n|
        [s + n, c + 1]
      end
      expect(sum).to eq(10)
      expect(count).to eq(4)
    end
  end
end
