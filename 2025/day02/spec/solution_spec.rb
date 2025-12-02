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
    it 'sums all invalid IDs in ranges (default strategy)' do
      expect(subject.part1).to eq(1227775554)
    end

    Day02::STRATEGIES.each do |strategy|
      it "works with #{strategy} strategy" do
        solver = Day02.new(example_input, strategy: strategy)
        expect(solver.part1).to eq(1227775554)
      end
    end
  end

  describe 'strategy comparison' do
    let(:simple_input) { '0-10000' }

    it 'all strategies produce same result' do
      results = Day02::STRATEGIES.map do |strategy|
        Day02.new(simple_input, strategy: strategy).part1
      end
      expect(results.uniq.size).to eq(1)
    end

    it 'finds correct sum in 0-10000' do
      # 2-digit: 11,22,...99 = 9 numbers, sum = 495
      # 4-digit: 1010,1111,...9999 = 90 numbers, sum = 495405
      # Total sum: 495900
      solver = Day02.new(simple_input, strategy: :multiplier)
      expect(solver.part1).to eq(495900)
    end
  end

  describe 'invalid_id? detection (brute_force strategy)' do
    let(:solver) { Day02.new('1-1', strategy: :brute_force) }

    it 'detects 2-digit repeats' do
      expect(solver.send(:invalid_id_string?, 11)).to be true
      expect(solver.send(:invalid_id_string?, 22)).to be true
      expect(solver.send(:invalid_id_string?, 99)).to be true
      expect(solver.send(:invalid_id_string?, 12)).to be false
    end

    it 'detects 4-digit repeats' do
      expect(solver.send(:invalid_id_string?, 6464)).to be true
      expect(solver.send(:invalid_id_string?, 1010)).to be true
      expect(solver.send(:invalid_id_string?, 1234)).to be false
    end

    it 'detects 6-digit repeats' do
      expect(solver.send(:invalid_id_string?, 123123)).to be true
      expect(solver.send(:invalid_id_string?, 456456)).to be true
      expect(solver.send(:invalid_id_string?, 123456)).to be false
    end

    it 'rejects odd-length numbers' do
      expect(solver.send(:invalid_id_string?, 1)).to be false
      expect(solver.send(:invalid_id_string?, 111)).to be false
      expect(solver.send(:invalid_id_string?, 12345)).to be false
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

  describe 'Ruby idiom: multiplier formula 10^d + 1' do
    it 'generates correct multipliers' do
      expect(10 ** 1 + 1).to eq(11)
      expect(10 ** 2 + 1).to eq(101)
      expect(10 ** 3 + 1).to eq(1001)
      expect(10 ** 4 + 1).to eq(10001)
    end

    it 'creates repeated numbers via multiplication' do
      expect(5 * 11).to eq(55)
      expect(64 * 101).to eq(6464)
      expect(123 * 1001).to eq(123123)
    end
  end

  describe 'Ruby idiom: arithmetic series for sum' do
    it 'sums consecutive integers without iteration' do
      # Sum of 1..100 = n*(n+1)/2
      expect((1..100).sum).to eq(100 * 101 / 2)

      # Sum of lo..hi = count * (lo + hi) / 2
      lo, hi = 10, 99
      count = hi - lo + 1
      expect((lo..hi).sum).to eq(count * (lo + hi) / 2)
    end
  end

  describe 'Ruby idiom: regex backreference' do
    it 'detects repeated patterns with \\1' do
      # (.+) captures any chars, \1 matches same again
      expect('abab').to match(/^(.+)\1$/)
      expect('abcabc').to match(/^(.+)\1$/)
      expect('abcd').not_to match(/^(.+)\1$/)
    end
  end
end
