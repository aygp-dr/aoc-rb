require_relative '../solution'

RSpec.describe Day06 do
  let(:example_input) do
    <<~INPUT
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#..^.....
      ........#.
      #.........
      ......#...
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'counts distinct positions visited' do
      expect(subject.part1).to eq(41)
    end
  end

  describe '#part2' do
    it 'counts positions that create loops' do
      expect(subject.part2).to eq(6)
    end
  end

  describe 'Ruby idiom: direction cycling with modulo' do
    it 'cycles through directions' do
      dirs = [[-1, 0], [0, 1], [1, 0], [0, -1]]  # up, right, down, left
      dir = 0  # Start facing up

      dir = (dir + 1) % 4  # Turn right
      expect(dirs[dir]).to eq([0, 1])  # Now facing right

      dir = (dir + 1) % 4
      expect(dirs[dir]).to eq([1, 0])  # Now facing down

      dir = (dir + 1) % 4
      expect(dirs[dir]).to eq([0, -1])  # Now facing left

      dir = (dir + 1) % 4
      expect(dirs[dir]).to eq([-1, 0])  # Back to up
    end
  end

  describe 'Ruby idiom: Set for visited tracking' do
    it 'handles arrays as elements' do
      visited = Set.new
      visited.add([1, 2])
      visited.add([1, 2])  # Duplicate
      visited.add([3, 4])
      expect(visited.size).to eq(2)
    end

    it 'can store tuples for state tracking' do
      states = Set.new
      states.add([1, 2, 0])  # y, x, dir
      states.add([1, 2, 1])  # Same pos, different dir
      expect(states.size).to eq(2)
    end
  end

  describe 'Ruby idiom: loop with break' do
    it 'creates infinite loop until break' do
      count = 0
      result = loop do
        count += 1
        break count if count >= 5
      end
      expect(result).to eq(5)
    end

    it 'can return value from break' do
      result = loop do
        break :found
      end
      expect(result).to eq(:found)
    end
  end

  describe 'Ruby idiom: each_with_index on grid' do
    it 'iterates with row/col indices' do
      grid = ['ab', 'cd']
      cells = []
      grid.each_with_index do |row, y|
        row.chars.each_with_index do |char, x|
          cells << [char, x, y]
        end
      end
      expect(cells).to eq([
        ['a', 0, 0], ['b', 1, 0],
        ['c', 0, 1], ['d', 1, 1]
      ])
    end
  end

  describe 'Ruby idiom: Set difference with -' do
    it 'removes elements' do
      a = Set[1, 2, 3, 4]
      b = Set[2, 4]
      expect(a - b).to eq(Set[1, 3])
    end

    it 'can remove single element array' do
      positions = Set[[0, 0], [1, 1]]
      start = [0, 0]
      expect(positions - [start]).to eq(Set[[1, 1]])
    end
  end
end
