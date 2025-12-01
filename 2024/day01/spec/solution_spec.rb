require_relative '../solution'

RSpec.describe Day01 do
  let(:example_input) do
    <<~INPUT
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'calculates total distance between sorted pairs' do
      # Sorted left:  [1, 2, 3, 3, 3, 4]
      # Sorted right: [3, 3, 3, 4, 5, 9]
      # Distances:    [2, 1, 0, 1, 2, 5] = 11
      expect(subject.part1).to eq(11)
    end
  end

  describe '#part2' do
    it 'calculates similarity score' do
      # Left list: [3, 4, 2, 1, 3, 3]
      # Right list frequency: {4=>1, 3=>3, 5=>1, 9=>1}
      # 3 appears 3 times in right: 3*3 = 9
      # 4 appears 1 time in right:  4*1 = 4
      # 2 appears 0 times in right: 2*0 = 0
      # 1 appears 0 times in right: 1*0 = 0
      # 3 appears 3 times in right: 3*3 = 9
      # 3 appears 3 times in right: 3*3 = 9
      # Total: 9 + 4 + 0 + 0 + 9 + 9 = 31
      expect(subject.part2).to eq(31)
    end
  end
end
