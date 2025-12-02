require_relative '../solution'

RSpec.describe Day05 do
  let(:example_input) do
    <<~INPUT
      seeds: 79 14 55 13

      seed-to-soil map:
      50 98 2
      52 50 48

      soil-to-fertilizer map:
      0 15 37
      37 52 2
      39 0 15

      fertilizer-to-water map:
      49 53 8
      0 11 42
      42 0 7
      57 7 4

      water-to-light map:
      88 18 7
      18 25 70

      light-to-temperature map:
      45 77 23
      81 45 19
      68 64 13

      temperature-to-humidity map:
      0 69 1
      1 0 69

      humidity-to-location map:
      60 56 37
      56 93 4
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'finds lowest location' do
      # Seed 79 -> location 82
      # Seed 14 -> location 43
      # Seed 55 -> location 86
      # Seed 13 -> location 35
      expect(subject.part1).to eq(35)
    end
  end

  describe 'Ruby idiom: Struct' do
    it 'creates lightweight class' do
      Point = Struct.new(:x, :y)
      p = Point.new(3, 4)
      expect(p.x).to eq(3)
      expect(p.y).to eq(4)
    end

    it 'supports method definitions' do
      Point = Struct.new(:x, :y) do
        def distance = Math.sqrt(x**2 + y**2)
      end
      expect(Point.new(3, 4).distance).to eq(5.0)
    end

    it 'has keyword argument support' do
      Point = Struct.new(:x, :y, keyword_init: true)
      p = Point.new(x: 1, y: 2)
      expect(p.x).to eq(1)
    end
  end

  describe 'Ruby idiom: each_slice' do
    it 'groups elements into chunks' do
      expect([1, 2, 3, 4, 5, 6].each_slice(2).to_a).to eq([[1, 2], [3, 4], [5, 6]])
    end

    it 'handles uneven chunks' do
      expect([1, 2, 3, 4, 5].each_slice(2).to_a).to eq([[1, 2], [3, 4], [5]])
    end

    it 'is useful for pairs' do
      seeds = [79, 14, 55, 13]
      ranges = seeds.each_slice(2).map { |start, len| (start...start + len) }
      expect(ranges.first).to eq(79...93)
    end
  end

  describe 'Ruby idiom: Range#cover?' do
    it 'checks if value is in range' do
      expect((10...20).cover?(15)).to be true
      expect((10...20).cover?(10)).to be true
      expect((10...20).cover?(20)).to be false  # Exclusive end
    end
  end

  describe 'Ruby idiom: reduce through transforms' do
    it 'chains transformations' do
      transforms = [
        ->(x) { x + 1 },
        ->(x) { x * 2 },
        ->(x) { x - 3 }
      ]
      result = transforms.reduce(5) { |v, t| t.call(v) }
      # 5 -> 6 -> 12 -> 9
      expect(result).to eq(9)
    end
  end

  describe 'Ruby idiom: find for first match' do
    it 'returns first matching element' do
      arr = [1, 4, 7, 10]
      expect(arr.find { _1 > 5 }).to eq(7)
    end

    it 'returns nil if no match' do
      expect([1, 2, 3].find { _1 > 10 }).to be_nil
    end
  end
end
