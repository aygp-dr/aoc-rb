require_relative '../solution'

RSpec.describe Day06 do
  let(:example_input) { '3,4,3,1,2' }
  subject { described_class.new(example_input) }

  describe '#simulate' do
    it 'has 26 fish after 18 days' do
      expect(subject.simulate(18)).to eq(26)
    end

    it 'has 5934 fish after 80 days' do
      expect(subject.simulate(80)).to eq(5934)
    end
  end

  describe '#part1' do
    it 'returns fish count after 80 days' do
      expect(subject.part1).to eq(5934)
    end
  end

  describe '#part2' do
    it 'returns fish count after 256 days' do
      expect(subject.part2).to eq(26984457539)
    end
  end

  describe 'Ruby idiom: tally' do
    it 'counts occurrences in array' do
      expect([3, 4, 3, 1, 2].tally).to eq({ 3 => 2, 4 => 1, 1 => 1, 2 => 1 })
    end

    it 'works with strings' do
      expect('hello'.chars.tally).to eq({ 'h' => 1, 'e' => 1, 'l' => 2, 'o' => 1 })
    end
  end

  describe 'Ruby idiom: Hash.new(0)' do
    it 'provides default value for missing keys' do
      h = Hash.new(0)
      h[:a] += 1
      h[:a] += 1
      h[:b] += 5
      expect(h).to eq({ a: 2, b: 5 })
    end

    it 'avoids nil errors' do
      h = Hash.new(0)
      expect(h[:missing]).to eq(0)
    end
  end

  describe 'Ruby idiom: Array#rotate' do
    it 'moves first element to end' do
      expect([0, 1, 2, 3].rotate(1)).to eq([1, 2, 3, 0])
    end

    it 'can rotate by n positions' do
      expect([0, 1, 2, 3].rotate(2)).to eq([2, 3, 0, 1])
    end

    it 'models timer decrement elegantly' do
      # Timer values [count_at_0, count_at_1, ..., count_at_8]
      # After one day, timer 1 becomes timer 0, etc.
      # rotate(1) achieves this!
      fish = [2, 0, 0, 0, 0, 0, 1, 0, 0]  # 2 fish at timer 0, 1 at timer 6
      rotated = fish.rotate(1)
      expect(rotated).to eq([0, 0, 0, 0, 0, 1, 0, 0, 2])
      # The 2 fish that were at timer 0 are now at position 8 (new fish)
    end
  end

  describe 'Ruby idiom: times.reduce' do
    it 'applies transformation n times' do
      # Double a value 3 times: 1 -> 2 -> 4 -> 8
      result = 3.times.reduce(1) { |acc, _| acc * 2 }
      expect(result).to eq(8)
    end

    it 'accumulates through iterations' do
      # Sum of 1..5 using reduce
      result = 5.times.reduce(0) { |sum, i| sum + i + 1 }
      expect(result).to eq(15)
    end
  end

  describe 'alternative implementations' do
    let(:array_solver) { Day06Array.new(example_input) }
    let(:functional_solver) { Day06Functional.new(example_input) }

    it 'array version matches' do
      expect(array_solver.simulate(80)).to eq(5934)
      expect(array_solver.simulate(256)).to eq(26984457539)
    end

    it 'functional version matches' do
      expect(functional_solver.simulate(80)).to eq(5934)
      expect(functional_solver.simulate(256)).to eq(26984457539)
    end
  end

  describe 'performance consideration' do
    it 'handles large day counts efficiently' do
      solver = Day06.new(example_input)
      # This would be impossibly slow with naive simulation
      # 26 trillion fish after 256 days!
      expect { solver.simulate(256) }.not_to raise_error
    end
  end
end
