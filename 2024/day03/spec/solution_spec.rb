require_relative '../solution'

RSpec.describe Day03 do
  describe '#part1' do
    let(:example_input) do
      "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    end

    it 'sums valid mul instructions' do
      solver = Day03.new(example_input)
      # Valid: mul(2,4)=8, mul(5,5)=25, mul(11,8)=88, mul(8,5)=40
      # Total: 8 + 25 + 88 + 40 = 161
      expect(solver.part1).to eq(161)
    end

    it 'ignores invalid formats' do
      solver = Day03.new("mul(4* mul(6,9! ?(12,34) mul ( 2 , 4 )")
      expect(solver.part1).to eq(0)
    end
  end

  describe '#part2' do
    let(:example_input) do
      "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()mul(8,5))"
    end

    it 'respects do/dont instructions' do
      solver = Day03.new(example_input)
      # mul(2,4)=8 (enabled)
      # don't() disables
      # mul(5,5), mul(11,8) skipped
      # do() enables
      # mul(8,5)=40 (enabled)
      # Total: 8 + 40 = 48
      expect(solver.part2).to eq(48)
    end
  end

  describe 'Ruby idiom: scan with captures' do
    it 'returns array of capture groups' do
      text = "mul(2,3) mul(10,20)"
      matches = text.scan(/mul\((\d+),(\d+)\)/)
      expect(matches).to eq([['2', '3'], ['10', '20']])
    end

    it 'returns flat array without captures' do
      text = "mul(2,3) mul(10,20)"
      matches = text.scan(/mul\(\d+,\d+\)/)
      expect(matches).to eq(['mul(2,3)', 'mul(10,20)'])
    end
  end

  describe 'Ruby idiom: Regexp.last_match' do
    it 'accesses last match data in scan block' do
      results = []
      "a1 b2 c3".scan(/(\w)(\d)/) do |letter, digit|
        results << Regexp.last_match[0]  # Full match
      end
      expect(results).to eq(['a1', 'b2', 'c3'])
    end
  end

  describe 'Ruby idiom: case with regex patterns' do
    it 'matches strings against patterns' do
      def classify(str)
        case str
        when /^do\(\)$/ then :enable
        when /^don't\(\)$/ then :disable
        when /^mul/ then :multiply
        else :unknown
        end
      end

      expect(classify("do()")).to eq(:enable)
      expect(classify("don't()")).to eq(:disable)
      expect(classify("mul(2,3)")).to eq(:multiply)
    end
  end

  describe 'Ruby idiom: gsub with regex for removal' do
    it 'removes matching sections' do
      text = "keep don't() remove do() keep"
      cleaned = text.gsub(/don't\(\).*?do\(\)/, '')
      expect(cleaned).to eq("keep  keep")
    end

    it 'uses non-greedy quantifier .*?' do
      text = "a don't() x do() b don't() y do() c"
      # Greedy .* would match from first don't to last do
      # Non-greedy .*? matches minimally
      cleaned = text.gsub(/don't\(\).*?do\(\)/, '')
      expect(cleaned).to eq("a  b  c")
    end
  end

  describe 'Ruby idiom: inject with tuple state' do
    it 'tracks multiple values through iteration' do
      # Count evens and sum odds
      result = [1, 2, 3, 4, 5].inject([0, 0]) do |(even_count, odd_sum), n|
        if n.even?
          [even_count + 1, odd_sum]
        else
          [even_count, odd_sum + n]
        end
      end
      expect(result).to eq([2, 9])  # 2 evens, 1+3+5=9
    end
  end
end
