require_relative '../solution'

RSpec.describe Day01 do
  let(:example_input) do
    <<~INPUT
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'counts depth increases' do
      # 199→200 (+), 200→208 (+), 208→210 (+), 210→200 (-),
      # 200→207 (+), 207→240 (+), 240→269 (+), 269→260 (-), 260→263 (+)
      # = 7 increases
      expect(subject.part1).to eq(7)
    end
  end

  describe '#part2' do
    it 'counts increases in 3-measurement sliding window sums' do
      # Windows: [199+200+208=607], [200+208+210=618], ...
      # 607→618 (+), 618→618 (=), 618→617 (-), 617→647 (+), 647→716 (+)
      # = 5 increases
      expect(subject.part2).to eq(5)
    end
  end

  describe 'Ruby idiom: each_cons' do
    it 'demonstrates sliding window behavior' do
      arr = [1, 2, 3, 4, 5]
      pairs = arr.each_cons(2).to_a
      expect(pairs).to eq([[1, 2], [2, 3], [3, 4], [4, 5]])
    end

    it 'demonstrates triplet windows' do
      arr = [1, 2, 3, 4, 5]
      triplets = arr.each_cons(3).to_a
      expect(triplets).to eq([[1, 2, 3], [2, 3, 4], [3, 4, 5]])
    end
  end

  describe 'Ruby idiom: numbered parameters' do
    it 'demonstrates _1, _2 in blocks' do
      # _1 is first param, _2 is second
      result = [[1, 2], [3, 1], [5, 6]].count { _2 > _1 }
      expect(result).to eq(2)  # 2>1 and 6>5
    end
  end
end
