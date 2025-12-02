require_relative '../solution'

RSpec.describe Day04 do
  let(:example_input) do
    <<~INPUT
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'counts all XMAS occurrences' do
      expect(subject.part1).to eq(18)
    end

    it 'finds horizontal XMAS' do
      solver = Day04.new("XMAS")
      expect(solver.part1).to eq(1)
    end

    it 'finds reversed XMAS' do
      solver = Day04.new("SAMX")
      expect(solver.part1).to eq(1)
    end

    it 'finds vertical XMAS' do
      solver = Day04.new("X\nM\nA\nS")
      expect(solver.part1).to eq(1)
    end

    it 'finds diagonal XMAS' do
      grid = <<~GRID
        X...
        .M..
        ..A.
        ...S
      GRID
      solver = Day04.new(grid)
      expect(solver.part1).to eq(1)
    end
  end

  describe '#part2' do
    it 'counts X-MAS patterns' do
      expect(subject.part2).to eq(9)
    end

    it 'finds basic X-MAS' do
      grid = <<~GRID
        M.S
        .A.
        M.S
      GRID
      solver = Day04.new(grid)
      expect(solver.part2).to eq(1)
    end
  end

  describe 'Ruby idiom: Array#product' do
    it 'generates cartesian product' do
      rows = [0, 1]
      cols = [0, 1, 2]
      expect(rows.product(cols)).to eq([
        [0, 0], [0, 1], [0, 2],
        [1, 0], [1, 1], [1, 2]
      ])
    end

    it 'is useful for grid iteration' do
      grid = [[:a, :b], [:c, :d]]
      coords = (0...2).to_a.product((0...2).to_a)
      values = coords.map { |r, c| grid[r][c] }
      expect(values).to eq([:a, :b, :c, :d])
    end
  end

  describe 'Ruby idiom: each_char.with_index' do
    it 'iterates characters with position' do
      result = []
      'abc'.each_char.with_index { |c, i| result << [c, i] }
      expect(result).to eq([['a', 0], ['b', 1], ['c', 2]])
    end
  end

  describe 'Ruby idiom: sort.join for order-independent comparison' do
    it 'normalizes for comparison' do
      expect(['M', 'S'].sort.join).to eq('MS')
      expect(['S', 'M'].sort.join).to eq('MS')
    end
  end

  describe 'Ruby idiom: count with block' do
    it 'counts matching elements' do
      expect([1, 2, 3, 4, 5].count(&:even?)).to eq(2)
    end

    it 'is cleaner than select.size' do
      arr = [1, 2, 3, 4, 5]
      expect(arr.count { _1 > 2 }).to eq(3)
      expect(arr.select { _1 > 2 }.size).to eq(3)  # Same but allocates array
    end
  end
end
