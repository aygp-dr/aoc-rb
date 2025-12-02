require_relative '../solution'

RSpec.describe Day01 do
  describe '#part1' do
    let(:example_input) do
      <<~INPUT
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
      INPUT
    end

    it 'extracts first and last digits' do
      solver = Day01.new(example_input)
      # 12 + 38 + 15 + 77 = 142
      expect(solver.part1).to eq(142)
    end

    it 'handles single digit (same first and last)' do
      expect(Day01.new('abc5def').part1).to eq(55)
    end
  end

  describe '#part2' do
    let(:example_input) do
      <<~INPUT
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
      INPUT
    end

    it 'handles spelled-out digits' do
      solver = Day01.new(example_input)
      # 29 + 83 + 13 + 24 + 42 + 14 + 76 = 281
      expect(solver.part2).to eq(281)
    end

    it 'handles overlapping words like oneight' do
      # "oneight" contains both "one" (first) and "eight" (last)
      expect(Day01.new('oneight').part2).to eq(18)
    end

    it 'handles twone' do
      expect(Day01.new('twone').part2).to eq(21)
    end

    it 'handles eightwo' do
      expect(Day01.new('eightwo').part2).to eq(82)
    end
  end

  describe 'alternative implementations' do
    it 'part1_scan matches part1' do
      solver = Day01.new("1abc2\npqr3stu8vwx")
      expect(solver.part1_scan).to eq(solver.part1)
    end
  end

  describe 'Ruby idiom: String#[] with regex' do
    it 'extracts first match' do
      expect('abc123def'[/\d+/]).to eq('123')
      expect('hello'[/\d+/]).to be_nil
    end

    it 'extracts capture group with index' do
      expect('hello123'[/(\d+)/, 1]).to eq('123')
    end
  end

  describe 'Ruby idiom: lookahead in regex' do
    it 'positive lookahead matches without consuming' do
      # Without lookahead: "oneight".scan(/one|eight/) => ["one"]
      # Because "one" consumes characters, "eight" starting at index 2 is missed

      # With lookahead: captures overlapping matches
      result = 'oneight'.scan(/(?=(one|eight))/).flatten
      expect(result).to eq(['one', 'eight'])
    end

    it 'finds all overlapping matches' do
      # "aaa".scan(/aa/) => ["aa"] (one match)
      # "aaa".scan(/(?=(aa))/).flatten => ["aa", "aa"] (two overlapping)
      expect('aaa'.scan(/(?=(aa))/).flatten).to eq(['aa', 'aa'])
    end
  end

  describe 'Ruby idiom: Hash#fetch with default' do
    it 'returns value if key exists' do
      h = { 'one' => '1', 'two' => '2' }
      expect(h.fetch('one', 'one')).to eq('1')
    end

    it 'returns default if key missing' do
      h = { 'one' => '1' }
      expect(h.fetch('5', '5')).to eq('5')
    end
  end

  describe 'Ruby idiom: freeze for immutable constants' do
    it 'prevents modification' do
      frozen_hash = { a: 1 }.freeze
      expect { frozen_hash[:b] = 2 }.to raise_error(FrozenError)
    end

    it 'is good practice for module/class constants' do
      # Constants should be frozen to prevent accidental modification
      expect(Day01::WORD_TO_DIGIT).to be_frozen
    end
  end
end
