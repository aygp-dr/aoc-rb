require_relative '../solution'

RSpec.describe Day01 do
  let(:example_input) do
    <<~INPUT
      12
      14
      1969
      100756
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#fuel_for_mass' do
    it 'calculates fuel for mass 12' do
      expect(subject.fuel_for_mass(12)).to eq(2)  # 12/3 - 2 = 2
    end

    it 'calculates fuel for mass 14' do
      expect(subject.fuel_for_mass(14)).to eq(2)  # 14/3 - 2 = 2
    end

    it 'calculates fuel for mass 1969' do
      expect(subject.fuel_for_mass(1969)).to eq(654)
    end

    it 'calculates fuel for mass 100756' do
      expect(subject.fuel_for_mass(100756)).to eq(33583)
    end
  end

  describe '#part1' do
    it 'sums fuel requirements' do
      expect(subject.part1).to eq(2 + 2 + 654 + 33583)
    end
  end

  describe '#fuel_for_mass_recursive' do
    it 'calculates recursive fuel for mass 14' do
      expect(subject.fuel_for_mass_recursive(14)).to eq(2)
    end

    it 'calculates recursive fuel for mass 1969' do
      # 1969 -> 654 -> 216 -> 70 -> 21 -> 5 -> 0
      # Sum: 654 + 216 + 70 + 21 + 5 = 966
      expect(subject.fuel_for_mass_recursive(1969)).to eq(966)
    end

    it 'calculates recursive fuel for mass 100756' do
      expect(subject.fuel_for_mass_recursive(100756)).to eq(50346)
    end
  end

  describe '#part2' do
    it 'sums recursive fuel requirements' do
      # 12 -> 2 (then 2/3-2 = -2, stop) = 2
      # 14 -> 2 = 2
      # 1969 -> 966
      # 100756 -> 50346
      expect(subject.part2).to eq(2 + 2 + 966 + 50346)
    end
  end

  describe 'alternative implementations' do
    it 'iterative matches recursive' do
      expect(subject.part2_iterative).to eq(subject.part2)
    end

    it 'functional matches recursive' do
      expect(subject.part2_functional).to eq(subject.part2)
    end
  end

  describe 'Ruby idiom: Integer division' do
    it 'automatically floors' do
      expect(7 / 3).to eq(2)   # not 2.333...
      expect(14 / 3).to eq(4)  # not 4.666...
      expect(-7 / 3).to eq(-3) # floors toward negative infinity
    end
  end

  describe 'Ruby idiom: Enumerator.produce' do
    it 'creates infinite sequence from initial value and block' do
      # Fibonacci-like: 1, 1, 2, 3, 5, 8...
      fibs = Enumerator.produce([0, 1]) { |a, b| [b, a + b] }
      first_10 = fibs.take(10).map(&:last)
      expect(first_10).to eq([1, 1, 2, 3, 5, 8, 13, 21, 34, 55])
    end

    it 'can be combined with take_while' do
      # Powers of 2 less than 100
      powers = Enumerator.produce(1) { _1 * 2 }
      result = powers.take_while { _1 < 100 }.to_a
      expect(result).to eq([1, 2, 4, 8, 16, 32, 64])
    end
  end

  describe 'Ruby idiom: sum with block' do
    it 'combines map and sum' do
      arr = [1, 2, 3, 4]
      # These are equivalent:
      expect(arr.map { _1 * 2 }.sum).to eq(20)
      expect(arr.sum { _1 * 2 }).to eq(20)
    end
  end
end
