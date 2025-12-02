require_relative '../solution'

RSpec.describe Day01 do
  let(:example_input) do
    <<~INPUT
      L68
      L30
      R48
      L5
      R60
      L55
      L1
      L99
      R14
      L82
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#parse_rotations' do
    it 'parses rotation commands correctly' do
      expect(subject.parse_rotations).to eq([
        ['L', 68], ['L', 30], ['R', 48], ['L', 5], ['R', 60],
        ['L', 55], ['L', 1], ['L', 99], ['R', 14], ['L', 82]
      ])
    end
  end

  describe '#part1' do
    it 'counts times dial lands on 0' do
      # Starting at 50:
      # L68 → (50 - 68) % 100 = 82
      # L30 → (82 - 30) % 100 = 52
      # R48 → (52 + 48) % 100 = 0  ← count 1
      # L5  → (0 - 5) % 100 = 95
      # R60 → (95 + 60) % 100 = 55
      # L55 → (55 - 55) % 100 = 0  ← count 2
      # L1  → (0 - 1) % 100 = 99
      # L99 → (99 - 99) % 100 = 0  ← count 3
      # R14 → (0 + 14) % 100 = 14
      # L82 → (14 - 82) % 100 = 32
      expect(subject.part1).to eq(3)
    end
  end

  describe 'edge cases' do
    it 'handles single rotation to 0' do
      solver = Day01.new('L50')
      expect(solver.part1).to eq(1)
    end

    it 'handles wrap around from right' do
      solver = Day01.new('R50')  # 50 + 50 = 100 % 100 = 0
      expect(solver.part1).to eq(1)
    end

    it 'handles multiple rotations on same line' do
      solver = Day01.new('L50 R100')  # Both land on 0
      expect(solver.part1).to eq(2)
    end
  end
end
