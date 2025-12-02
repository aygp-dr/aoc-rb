require_relative '../solution'

RSpec.describe Day05 do
  let(:example_input) do
    <<~INPUT
      47|53
      97|13
      97|61
      97|47
      75|29
      61|13
      75|53
      29|13
      97|29
      53|29
      61|53
      97|53
      61|29
      47|13
      75|47
      97|75
      47|61
      75|61
      47|29
      75|13
      53|13

      75,47,61,53,29
      97,61,53,29,13
      75,29,13
      75,97,47,61,53
      61,13,29
      97,13,75,29,47
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'sums middle pages of valid updates' do
      # Valid: 75,47,61,53,29 (middle=61)
      # Valid: 97,61,53,29,13 (middle=53)
      # Valid: 75,29,13 (middle=29)
      # 61 + 53 + 29 = 143
      expect(subject.part1).to eq(143)
    end
  end

  describe '#part2' do
    it 'fixes invalid updates and sums middle pages' do
      # Fixed updates have middle pages summing to 123
      expect(subject.part2).to eq(123)
    end
  end

  describe 'Ruby idiom: partition' do
    it 'splits array by predicate' do
      evens, odds = [1, 2, 3, 4, 5].partition(&:even?)
      expect(evens).to eq([2, 4])
      expect(odds).to eq([1, 3, 5])
    end

    it 'returns two arrays' do
      result = [1, 2, 3].partition { _1 > 1 }
      expect(result).to eq([[2, 3], [1]])
    end
  end

  describe 'Ruby idiom: Hash.new with block' do
    it 'creates default values on access' do
      h = Hash.new { |hash, key| hash[key] = Set.new }
      h[:a].add(1)
      h[:a].add(2)
      h[:b].add(3)
      expect(h[:a]).to eq(Set[1, 2])
      expect(h[:b]).to eq(Set[3])
      expect(h[:c]).to eq(Set[])  # Auto-created
    end
  end

  describe 'Ruby idiom: sort with <=> block' do
    it 'sorts with custom comparison' do
      # Sort by absolute value
      arr = [-5, 2, -3, 4, -1]
      sorted = arr.sort { |a, b| a.abs <=> b.abs }
      expect(sorted).to eq([-1, 2, -3, 4, -5])
    end

    it 'uses -1, 0, 1 convention' do
      # -1: a before b
      #  0: equal
      #  1: a after b
      arr = ['bb', 'aaa', 'c']
      sorted = arr.sort { |a, b| a.length <=> b.length }
      expect(sorted).to eq(['c', 'bb', 'aaa'])
    end
  end

  describe 'Ruby idiom: each_with_object' do
    it 'builds collection with accumulator' do
      result = [1, 2, 3].each_with_object({}) { |n, h| h[n] = n * 2 }
      expect(result).to eq({ 1 => 2, 2 => 4, 3 => 6 })
    end

    it 'is cleaner than inject for mutation' do
      # inject requires returning accumulator
      result1 = [1, 2].inject({}) { |h, n| h[n] = n; h }
      # each_with_object doesn't
      result2 = [1, 2].each_with_object({}) { |n, h| h[n] = n }
      expect(result1).to eq(result2)
    end
  end

  describe 'Ruby idiom: middle element access' do
    it 'uses size/2 for middle index' do
      expect([1, 2, 3][3 / 2]).to eq(2)      # index 1
      expect([1, 2, 3, 4, 5][5 / 2]).to eq(3) # index 2
    end
  end
end
