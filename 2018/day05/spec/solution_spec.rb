require_relative '../solution'

RSpec.describe Day05 do
  let(:example_input) { 'dabAcCaCBAcCcaDA' }

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'returns length after full reaction' do
      # dabAcCaCBAcCcaDA
      # dabAaCBAcCcaDA (cC reacts)
      # dabCBAcCcaDA (Aa reacts)
      # dabCBAcaDA (cC reacts)
      # dabCBAcaDA (10 chars remain)
      expect(subject.part1).to eq(10)
    end
  end

  describe '#part2' do
    it 'finds shortest polymer after removing one unit type' do
      # Removing 'a'/'A': dbcCCBcCcD -> dbCBcD (6)
      # Removing 'b'/'B': daAcCaCAcCcaDA -> daCAcaDA (8)
      # Removing 'c'/'C': dabAaBAaDA -> daDA (4) <- shortest
      # Removing 'd'/'D': abAcCaCBAcCcaA -> abCBAc (6)
      expect(subject.part2).to eq(4)
    end
  end

  describe 'Ruby idiom: XOR for case flip' do
    it 'uses XOR 32 to flip ASCII case bit' do
      # ASCII: 'a' = 97, 'A' = 65, difference is 32
      expect('a'.ord ^ 32).to eq('A'.ord)
      expect('A'.ord ^ 32).to eq('a'.ord)
      expect('z'.ord ^ 32).to eq('Z'.ord)
    end

    it 'detects same letter different case' do
      reacts = ->(a, b) { (a.ord ^ b.ord) == 32 }
      expect(reacts.call('a', 'A')).to be true
      expect(reacts.call('A', 'a')).to be true
      expect(reacts.call('a', 'a')).to be false
      expect(reacts.call('a', 'B')).to be false
    end
  end

  describe 'Ruby idiom: each_with_object for stack' do
    it 'builds result while iterating' do
      # Simpler example: remove consecutive duplicates
      result = 'aabbcc'.chars.each_with_object([]) do |char, stack|
        if stack.last == char
          stack.pop
        else
          stack << char
        end
      end
      expect(result).to eq([])  # All pairs removed
    end

    it 'keeps non-matching elements' do
      result = 'abba'.chars.each_with_object([]) do |char, stack|
        if stack.last == char
          stack.pop
        else
          stack << char
        end
      end
      expect(result).to eq([])  # a, then b, then b matches (pop), then a matches (pop)
    end
  end

  describe 'Ruby idiom: String#delete for multiple chars' do
    it 'removes all occurrences' do
      expect('aAbBcC'.delete('a')).to eq('AbBcC')
      expect('aAbBcC'.delete('a').delete('A')).to eq('bBcC')
    end

    it 'can chain deletions' do
      str = 'aAbBcC'
      expect(str.delete('aA')).to eq('bBcC')  # Delete multiple chars at once
    end
  end

  describe 'Ruby idiom: Range of letters' do
    it 'iterates lowercase alphabet' do
      expect(('a'..'c').to_a).to eq(['a', 'b', 'c'])
    end

    it 'is useful for checking all unit types' do
      polymer = 'aAbBcC'
      lengths = ('a'..'c').map do |char|
        polymer.delete(char).delete(char.upcase).length
      end
      expect(lengths).to eq([4, 4, 4])  # Each removal leaves 4 chars
    end
  end
end
