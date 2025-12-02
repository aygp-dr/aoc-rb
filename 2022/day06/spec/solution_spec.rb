require_relative '../solution'

RSpec.describe Day06 do
  describe '#part1' do
    [
      ['mjqjpqmgbljsphdztnvjfqwrcgsmlb', 7],
      ['bvwbjplbgvbhsrlpgdmjqwftvncz', 5],
      ['nppdvjthqldpwncqszvftbrmjlhg', 6],
      ['nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', 10],
      ['zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw', 11]
    ].each do |signal, expected|
      it "finds #{expected} for #{signal[0..20]}..." do
        expect(Day06.new(signal).part1).to eq(expected)
      end
    end
  end

  describe '#part2' do
    [
      ['mjqjpqmgbljsphdztnvjfqwrcgsmlb', 19],
      ['bvwbjplbgvbhsrlpgdmjqwftvncz', 23],
      ['nppdvjthqldpwncqszvftbrmjlhg', 23],
      ['nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', 29],
      ['zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw', 26]
    ].each do |signal, expected|
      it "finds #{expected} for #{signal[0..20]}..." do
        expect(Day06.new(signal).part2).to eq(expected)
      end
    end
  end

  describe 'alternative implementations' do
    let(:solver) { Day06.new('mjqjpqmgbljsphdztnvjfqwrcgsmlb') }

    it 'set version matches' do
      expect(solver.find_marker_set(4)).to eq(7)
    end

    it 'functional version matches' do
      expect(solver.find_marker_functional(4)).to eq(7)
    end

    it 'traditional version matches' do
      expect(solver.find_marker_traditional(4)).to eq(7)
    end
  end

  describe 'Ruby idiom: each_cons with_index' do
    it 'creates sliding windows with positions' do
      result = 'abcde'.chars.each_cons(3).with_index.to_a
      expect(result).to eq([
        [['a', 'b', 'c'], 0],
        [['b', 'c', 'd'], 1],
        [['c', 'd', 'e'], 2]
      ])
    end
  end

  describe 'Ruby idiom: uniq for uniqueness check' do
    it 'removes duplicates preserving order' do
      expect([1, 2, 2, 3, 1].uniq).to eq([1, 2, 3])
    end

    it 'can check if all elements unique' do
      expect([1, 2, 3].uniq == [1, 2, 3]).to be true
      expect([1, 2, 2].uniq == [1, 2, 2]).to be false
    end

    it 'comparing size is simpler' do
      arr = [1, 2, 3]
      expect(arr.uniq.size == arr.size).to be true
    end
  end

  describe 'Ruby idiom: String#[] with length' do
    it 'extracts substring' do
      expect('hello'[1, 3]).to eq('ell')
      expect('hello'[0, 2]).to eq('he')
    end
  end

  describe 'Ruby idiom: find_index' do
    it 'returns index of first match' do
      arr = [1, 3, 5, 7, 9]
      expect(arr.find_index { |n| n > 4 }).to eq(2)  # index of 5
    end

    it 'returns nil if no match' do
      expect([1, 2, 3].find_index { |n| n > 10 }).to be_nil
    end
  end
end
