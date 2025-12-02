require_relative '../solution'

RSpec.describe Day04 do
  let(:example_input) do
    <<~INPUT
      aaaaa-bbb-z-y-x-123[abxyz]
      a-b-c-d-e-f-g-h-987[abcde]
      not-a-real-room-404[oarel]
      totally-real-room-200[decoy]
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'sums sector IDs of valid rooms' do
      # Valid: 123, 987, 404 (first three)
      # Invalid: 200 (decoy checksum wrong)
      expect(subject.part1).to eq(1514)
    end
  end

  describe 'checksum validation' do
    it 'validates aaaaa-bbb-z-y-x with checksum abxyz' do
      solver = Day04.new("aaaaa-bbb-z-y-x-123[abxyz]")
      expect(solver.part1).to eq(123)
    end

    it 'validates not-a-real-room with checksum oarel' do
      solver = Day04.new("not-a-real-room-404[oarel]")
      expect(solver.part1).to eq(404)
    end

    it 'rejects invalid checksum' do
      solver = Day04.new("totally-real-room-200[decoy]")
      expect(solver.part1).to eq(0)
    end
  end

  describe 'Ruby idiom: tally for frequency' do
    it 'counts character occurrences' do
      expect('aabbc'.chars.tally).to eq({ 'a' => 2, 'b' => 2, 'c' => 1 })
    end
  end

  describe 'Ruby idiom: sort_by with compound key' do
    it 'sorts by multiple criteria' do
      data = { 'a' => 2, 'b' => 3, 'c' => 2 }
      # Sort by: count descending (-count), then letter ascending
      sorted = data.sort_by { |char, count| [-count, char] }
      expect(sorted.map(&:first)).to eq(['b', 'a', 'c'])
    end
  end

  describe 'Ruby idiom: match with named captures' do
    it 'extracts named groups' do
      pattern = /(?<name>\w+)-(?<id>\d+)/
      match = 'hello-123'.match(pattern)
      expect(match[:name]).to eq('hello')
      expect(match[:id]).to eq('123')
    end
  end

  describe 'Ruby idiom: gsub with block' do
    it 'transforms each match' do
      result = 'abc'.gsub(/[a-z]/) { |c| c.upcase }
      expect(result).to eq('ABC')
    end

    it 'can do character rotation' do
      # ROT13
      result = 'abc'.gsub(/[a-z]/) { |c| ((c.ord - 'a'.ord + 13) % 26 + 'a'.ord).chr }
      expect(result).to eq('nop')
    end
  end

  describe 'Ruby idiom: ord and chr' do
    it 'converts char to number and back' do
      expect('a'.ord).to eq(97)
      expect(97.chr).to eq('a')
    end

    it 'enables character arithmetic' do
      # Next character
      expect(('b'.ord + 1).chr).to eq('c')
      # Wrap around
      expect((('z'.ord - 'a'.ord + 1) % 26 + 'a'.ord).chr).to eq('a')
    end
  end

  describe 'Ruby idiom: dig for nested access' do
    it 'safely accesses nested values' do
      data = { room: { sector: 123 } }
      expect(data.dig(:room, :sector)).to eq(123)
      expect(data.dig(:room, :missing)).to be_nil
    end
  end
end
