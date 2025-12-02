require_relative '../solution'

RSpec.describe Day03 do
  describe '#part1' do
    it 'rejects impossible triangle' do
      solver = Day03.new("5 10 25")
      expect(solver.part1).to eq(0)  # 5 + 10 = 15 < 25
    end

    it 'accepts valid triangle' do
      solver = Day03.new("3 4 5")
      expect(solver.part1).to eq(1)
    end

    it 'counts multiple triangles' do
      input = <<~INPUT
        3 4 5
        5 10 25
        5 5 5
      INPUT
      solver = Day03.new(input)
      expect(solver.part1).to eq(2)  # First and third are valid
    end
  end

  describe '#part2' do
    it 'reads triangles vertically' do
      input = <<~INPUT
        101 301 501
        102 302 502
        103 303 503
        201 401 601
        202 402 602
        203 403 603
      INPUT
      # Column 1: [101,102,103], [201,202,203]
      # Column 2: [301,302,303], [401,402,403]
      # Column 3: [501,502,503], [601,602,603]
      solver = Day03.new(input)
      # All are valid (consecutive numbers)
      expect(solver.part2).to eq(6)
    end
  end

  describe 'Ruby idiom: transpose' do
    it 'swaps rows and columns' do
      matrix = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]
      expect(matrix.transpose).to eq([
        [1, 4, 7],
        [2, 5, 8],
        [3, 6, 9]
      ])
    end

    it 'converts row-wise to column-wise data' do
      rows = [[1, 2], [3, 4], [5, 6]]
      columns = rows.transpose
      expect(columns).to eq([[1, 3, 5], [2, 4, 6]])
    end
  end

  describe 'Ruby idiom: flatten + each_slice' do
    it 'regroups data' do
      columns = [[1, 2, 3], [4, 5, 6]]
      # Flatten then group by 2
      groups = columns.flatten.each_slice(2).to_a
      expect(groups).to eq([[1, 2], [3, 4], [5, 6]])
    end
  end

  describe 'Ruby idiom: sort for comparison' do
    it 'orders elements for easy comparison' do
      sides = [10, 5, 25]
      a, b, c = sides.sort
      expect(a).to eq(5)
      expect(b).to eq(10)
      expect(c).to eq(25)
    end
  end

  describe 'Ruby idiom: scan for number extraction' do
    it 'extracts all numbers from string' do
      expect("  5  10  25".scan(/\d+/)).to eq(['5', '10', '25'])
    end

    it 'handles varying whitespace' do
      expect("1   2     3".scan(/\d+/).map(&:to_i)).to eq([1, 2, 3])
    end
  end
end
