require_relative '../solution'

RSpec.describe Day01 do
  describe '#part1' do
    it 'handles R2, L3 -> 5 blocks' do
      expect(Day01.new('R2, L3').part1).to eq(5)
    end

    it 'handles R2, R2, R2 -> 2 blocks' do
      # Turn right 3 times = turn left once, end up 2 south
      expect(Day01.new('R2, R2, R2').part1).to eq(2)
    end

    it 'handles R5, L5, R5, R3 -> 12 blocks' do
      expect(Day01.new('R5, L5, R5, R3').part1).to eq(12)
    end
  end

  describe '#part2' do
    it 'finds first location visited twice' do
      # R8: go east 8 -> (8,0)
      # R4: turn south, go 4 -> (8,-4)
      # R4: turn west, go 4 -> (4,-4)
      # R8: turn north, go 8 -> crosses at (4,0) then continues to (4,4)
      # First revisit is at (4,0) which is 4 blocks away
      expect(Day01.new('R8, R4, R4, R8').part2).to eq(4)
    end
  end

  describe 'Ruby idiom: Complex numbers for 2D' do
    it 'represents points as Complex(x, y)' do
      pos = Complex(3, 4)
      expect(pos.real).to eq(3)  # x
      expect(pos.imag).to eq(4)  # y
    end

    it 'adds positions with +' do
      p1 = Complex(1, 2)
      p2 = Complex(3, 4)
      expect(p1 + p2).to eq(Complex(4, 6))
    end

    it 'rotates by multiplying by i or -i' do
      north = Complex(0, 1)
      # Turn right (clockwise) = multiply by -i
      east = north * Complex(0, -1)
      expect(east).to eq(Complex(1, 0))
      # Turn right again
      south = east * Complex(0, -1)
      expect(south).to eq(Complex(0, -1))
    end

    it 'scales direction by distance' do
      dir = Complex(1, 0)  # east
      expect(dir * 5).to eq(Complex(5, 0))
    end
  end

  describe 'Ruby idiom: scan with regex' do
    it 'extracts all matches' do
      input = 'R2, L3, R10'
      matches = input.scan(/([LR])(\d+)/)
      expect(matches).to eq([['R', '2'], ['L', '3'], ['R', '10']])
    end

    it 'returns capture groups' do
      'hello123world456'.scan(/([a-z]+)(\d+)/)
      # => [["hello", "123"], ["world", "456"]]
    end
  end

  describe 'Ruby idiom: Struct' do
    it 'creates lightweight classes' do
      Point = Struct.new(:x, :y)
      p = Point.new(3, 4)
      expect(p.x).to eq(3)
      expect(p.y).to eq(4)
    end

    it 'allows method definitions in block' do
      Point = Struct.new(:x, :y) do
        def manhattan = x.abs + y.abs
      end
      expect(Point.new(-3, 4).manhattan).to eq(7)
    end
  end

  describe 'Ruby idiom: catch/throw' do
    it 'provides non-local return' do
      result = catch(:done) do
        (1..100).each do |i|
          throw(:done, i) if i == 42
        end
        :not_found
      end
      expect(result).to eq(42)
    end
  end

  describe 'alternative Struct implementation' do
    it 'produces same result' do
      solver1 = Day01.new('R5, L5, R5, R3')
      solver2 = Day01Struct.new('R5, L5, R5, R3')
      expect(solver2.part1).to eq(solver1.part1)
    end
  end
end
