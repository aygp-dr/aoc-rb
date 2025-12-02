require_relative '../solution'

RSpec.describe Day03 do
  describe '#part1' do
    it 'finds distance 6 for first example' do
      input = "R8,U5,L5,D3\nU7,R6,D4,L4"
      expect(Day03.new(input).part1).to eq(6)
    end

    it 'finds distance 159 for second example' do
      input = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
      expect(Day03.new(input).part1).to eq(159)
    end

    it 'finds distance 135 for third example' do
      input = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
      expect(Day03.new(input).part1).to eq(135)
    end
  end

  describe '#part2' do
    it 'finds 30 steps for first example' do
      input = "R8,U5,L5,D3\nU7,R6,D4,L4"
      expect(Day03.new(input).part2).to eq(30)
    end

    it 'finds 610 steps for second example' do
      input = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
      expect(Day03.new(input).part2).to eq(610)
    end

    it 'finds 410 steps for third example' do
      input = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
      expect(Day03.new(input).part2).to eq(410)
    end
  end

  describe 'Ruby idiom: Set intersection' do
    it 'finds common elements with &' do
      a = Set[1, 2, 3, 4]
      b = Set[3, 4, 5, 6]
      expect(a & b).to eq(Set[3, 4])
    end

    it 'works with Complex numbers' do
      a = Set[Complex(1, 2), Complex(3, 4)]
      b = Set[Complex(3, 4), Complex(5, 6)]
      expect(a & b).to eq(Set[Complex(3, 4)])
    end
  end

  describe 'Ruby idiom: Hash with ||= for first value' do
    it 'only sets value if key missing' do
      h = {}
      h[:a] ||= 1  # Sets to 1
      h[:a] ||= 2  # Does not change (already set)
      expect(h[:a]).to eq(1)
    end

    it 'records first visit in wire tracing' do
      steps = {}
      [[0, 1], [0, 1], [0, 1]].each_with_index do |pos, i|
        steps[pos] ||= i + 1
      end
      expect(steps[[0, 1]]).to eq(1)  # First visit at step 1
    end
  end

  describe 'Ruby idiom: Complex for 2D math' do
    it 'supports addition for movement' do
      pos = Complex(0, 0)
      up = Complex(0, 1)
      expect(pos + up).to eq(Complex(0, 1))
      expect(pos + up + up).to eq(Complex(0, 2))
    end

    it 'can be used as hash keys' do
      h = { Complex(1, 2) => 'visited' }
      expect(h[Complex(1, 2)]).to eq('visited')
    end
  end

  describe 'Ruby idiom: String slicing for parsing' do
    it 'extracts direction and distance' do
      instruction = 'R75'
      dir = instruction[0]
      distance = instruction[1..].to_i
      expect(dir).to eq('R')
      expect(distance).to eq(75)
    end
  end

  describe 'alternative array implementation' do
    it 'matches Complex implementation for part1' do
      input = "R8,U5,L5,D3\nU7,R6,D4,L4"
      expect(Day03Array.new(input).part1).to eq(6)
    end

    it 'matches Complex implementation for part2' do
      input = "R8,U5,L5,D3\nU7,R6,D4,L4"
      expect(Day03Array.new(input).part2).to eq(30)
    end
  end

  describe 'Ruby idiom: Array as Hash key' do
    it 'arrays with same content map to same key' do
      h = {}
      h[[1, 2]] = 'first'
      expect(h[[1, 2]]).to eq('first')
    end

    it 'is convenient for grid positions' do
      visited = {}
      visited[[0, 0]] = 0
      visited[[1, 0]] = 1
      visited[[1, 1]] = 2
      expect(visited.keys).to eq([[0, 0], [1, 0], [1, 1]])
    end
  end
end
