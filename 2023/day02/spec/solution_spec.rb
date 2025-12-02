require_relative '../solution'

RSpec.describe Day02 do
  let(:example_input) do
    <<~INPUT
      Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
      Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
      Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
      Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
      Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'sums IDs of possible games' do
      # Possible: 1, 2, 5 (total 8)
      # Impossible: 3 (20 red), 4 (15 blue, 14 red)
      expect(subject.part1).to eq(8)
    end
  end

  describe '#part2' do
    it 'sums power of minimum cube sets' do
      # Game 1: min 4 red, 2 green, 6 blue = 48
      # Game 2: min 1 red, 3 green, 4 blue = 12
      # Game 3: min 20 red, 13 green, 6 blue = 1560
      # Game 4: min 14 red, 3 green, 15 blue = 630
      # Game 5: min 6 red, 3 green, 2 blue = 36
      # Total: 2286
      expect(subject.part2).to eq(2286)
    end
  end

  describe 'Ruby idiom: scan to_h' do
    it 'converts scan results to hash' do
      text = "3 blue, 4 red"
      result = text.scan(/(\d+) (\w+)/).to_h { |count, color| [color, count.to_i] }
      expect(result).to eq({ 'blue' => 3, 'red' => 4 })
    end
  end

  describe 'Ruby idiom: String#[] with regex capture' do
    it 'extracts capture group' do
      line = "Game 42: stuff"
      expect(line[/Game (\d+)/, 1]).to eq('42')
    end
  end

  describe 'Ruby idiom: Hash#merge with block' do
    it 'combines hashes with custom logic' do
      a = { red: 3, blue: 2 }
      b = { red: 5, green: 1 }
      # Block receives: key, old_value, new_value
      result = a.merge(b) { |_k, old, new| [old, new].max }
      expect(result).to eq({ red: 5, blue: 2, green: 1 })
    end

    it 'is useful for finding max per key' do
      reveals = [{ 'red' => 3 }, { 'red' => 5, 'blue' => 2 }]
      maxes = reveals.reduce({}) { |acc, r| acc.merge(r) { |_, o, n| [o, n].max } }
      expect(maxes).to eq({ 'red' => 5, 'blue' => 2 })
    end
  end

  describe 'Ruby idiom: Hash#fetch with default' do
    it 'returns default for missing keys' do
      limits = { 'red' => 12 }
      expect(limits.fetch('red', 0)).to eq(12)
      expect(limits.fetch('blue', 0)).to eq(0)
    end
  end

  describe 'Ruby idiom: values.reduce for product' do
    it 'multiplies all values' do
      h = { a: 2, b: 3, c: 4 }
      expect(h.values.reduce(1, :*)).to eq(24)
    end
  end
end
