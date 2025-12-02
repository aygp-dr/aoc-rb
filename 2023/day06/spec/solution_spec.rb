require_relative '../solution'

RSpec.describe Day06 do
  let(:example_input) do
    <<~INPUT
      Time:      7  15   30
      Distance:  9  40  200
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'calculates product of winning strategies' do
      # Race 1 (7ms, 9mm): 4 ways (hold 2,3,4,5)
      # Race 2 (15ms, 40mm): 8 ways
      # Race 3 (30ms, 200mm): 9 ways
      # 4 * 8 * 9 = 288
      expect(subject.part1).to eq(288)
    end
  end

  describe '#part2' do
    it 'treats as single race with concatenated numbers' do
      # Time: 71530, Distance: 940200
      expect(subject.part2).to eq(71503)
    end
  end

  describe 'race mechanics' do
    it 'calculates distance for hold time' do
      # Hold 2ms in 7ms race: speed=2, time=5, distance=10
      hold = 2
      time = 7
      distance = hold * (time - hold)
      expect(distance).to eq(10)
    end
  end

  describe 'Ruby idiom: zip for pairing' do
    it 'pairs elements from two arrays' do
      times = [7, 15, 30]
      distances = [9, 40, 200]
      expect(times.zip(distances)).to eq([[7, 9], [15, 40], [30, 200]])
    end

    it 'handles unequal lengths with nil' do
      expect([1, 2, 3].zip([4, 5])).to eq([[1, 4], [2, 5], [3, nil]])
    end
  end

  describe 'Ruby idiom: Array#join for concatenation' do
    it 'concatenates array elements as string' do
      expect([7, 15, 30].join).to eq('71530')
      expect([7, 15, 30].join.to_i).to eq(71530)
    end
  end

  describe 'Ruby idiom: Math.sqrt' do
    it 'calculates square root' do
      expect(Math.sqrt(16)).to eq(4.0)
      expect(Math.sqrt(2)).to be_within(0.001).of(1.414)
    end
  end

  describe 'Ruby idiom: reduce(:*) for product' do
    it 'multiplies all elements' do
      expect([4, 8, 9].reduce(:*)).to eq(288)
      expect([2, 3, 4].reduce(:*)).to eq(24)
    end

    it 'is equivalent to inject(:*)' do
      arr = [1, 2, 3, 4]
      expect(arr.reduce(:*)).to eq(arr.inject(:*))
    end
  end

  describe 'Ruby idiom: Range#count with block' do
    it 'counts matching elements in range' do
      # Count numbers 0-10 that are even
      expect((0..10).count(&:even?)).to eq(6)  # 0,2,4,6,8,10
    end
  end

  describe 'quadratic formula' do
    it 'solves ax² + bx + c = 0' do
      # x² - 5x + 6 = 0 has roots 2 and 3
      a, b, c = 1, -5, 6
      discriminant = b * b - 4 * a * c
      x1 = (-b + Math.sqrt(discriminant)) / (2 * a)
      x2 = (-b - Math.sqrt(discriminant)) / (2 * a)
      expect([x1, x2].sort).to eq([2.0, 3.0])
    end
  end
end
