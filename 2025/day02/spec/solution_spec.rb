require_relative '../solution'

RSpec.describe Day02 do
  let(:example_input) do
    <<~INPUT
      11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
      1698522-1698528,446443-446449,38593856-38593862,565653-565659,
      824824821-824824827,2121212118-2121212124
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'sums all invalid IDs in ranges' do
      # Invalid IDs found:
      # 11, 22 (from 11-22)
      # 99 (from 95-115)
      # 1010 (from 998-1012)
      # 1188511885 (from 1188511880-1188511890)
      # 222222 (from 222220-222224)
      # ... and more
      expect(subject.part1).to eq(1227775554)
    end
  end

  describe 'invalid_id? detection' do
    let(:solver) { Day02.new('1-1') }

    it 'detects 2-digit repeats' do
      expect(solver.send(:invalid_id?, 11)).to be true
      expect(solver.send(:invalid_id?, 22)).to be true
      expect(solver.send(:invalid_id?, 99)).to be true
      expect(solver.send(:invalid_id?, 12)).to be false
    end

    it 'detects 4-digit repeats' do
      expect(solver.send(:invalid_id?, 6464)).to be true
      expect(solver.send(:invalid_id?, 1010)).to be true
      expect(solver.send(:invalid_id?, 1234)).to be false
    end

    it 'detects 6-digit repeats' do
      expect(solver.send(:invalid_id?, 123123)).to be true
      expect(solver.send(:invalid_id?, 456456)).to be true
      expect(solver.send(:invalid_id?, 123456)).to be false
    end

    it 'rejects odd-length numbers' do
      expect(solver.send(:invalid_id?, 1)).to be false
      expect(solver.send(:invalid_id?, 111)).to be false
      expect(solver.send(:invalid_id?, 12345)).to be false
    end
  end

  describe 'Ruby idiom: String slicing' do
    it 'extracts substrings with [start, length]' do
      s = '123456'
      expect(s[0, 3]).to eq('123')
      expect(s[3, 3]).to eq('456')
    end

    it 'compares halves of even-length string' do
      s = '6464'
      half = s.length / 2
      expect(s[0, half]).to eq('64')
      expect(s[half, half]).to eq('64')
      expect(s[0, half] == s[half, half]).to be true
    end
  end

  describe 'Ruby idiom: scan for parsing' do
    it 'extracts all matches with capture groups' do
      input = '11-22,95-115,998-1012'
      matches = input.scan(/(\d+)-(\d+)/)
      expect(matches).to eq([['11', '22'], ['95', '115'], ['998', '1012']])
    end

    it 'handles multiline input' do
      input = "11-22,\n95-115"
      matches = input.scan(/(\d+)-(\d+)/)
      expect(matches.length).to eq(2)
    end
  end

  describe 'Ruby idiom: Range iteration' do
    it 'iterates inclusive range' do
      expect((11..15).to_a).to eq([11, 12, 13, 14, 15])
    end

    it 'works with select for filtering' do
      evens = (1..10).select(&:even?)
      expect(evens).to eq([2, 4, 6, 8, 10])
    end
  end

  describe 'Ruby idiom: nested sum' do
    it 'sums results from multiple ranges' do
      ranges = [(1..3), (10..12)]
      total = ranges.sum { |r| r.sum }
      expect(total).to eq(1 + 2 + 3 + 10 + 11 + 12)
    end

    it 'combines select and sum' do
      range = (10..20)
      sum_of_evens = range.select(&:even?).sum
      expect(sum_of_evens).to eq(10 + 12 + 14 + 16 + 18 + 20)
    end
  end
end
