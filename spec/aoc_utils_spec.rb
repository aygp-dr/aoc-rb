# frozen_string_literal: true

require_relative '../lib/aoc_utils'

RSpec.describe AocUtils do
  describe 'Math Utilities' do
    describe '.gcd' do
      it 'calculates greatest common divisor' do
        expect(AocUtils.gcd(12, 8)).to eq(4)
        expect(AocUtils.gcd(17, 13)).to eq(1)
        expect(AocUtils.gcd(100, 25)).to eq(25)
      end

      it 'handles zero' do
        expect(AocUtils.gcd(5, 0)).to eq(5)
        expect(AocUtils.gcd(0, 5)).to eq(5)
      end
    end

    describe '.lcm' do
      it 'calculates least common multiple' do
        expect(AocUtils.lcm(4, 6)).to eq(12)
        expect(AocUtils.lcm(3, 5)).to eq(15)
      end
    end

    describe '.lcm_array' do
      it 'calculates LCM of multiple numbers' do
        expect(AocUtils.lcm_array([2, 3, 4])).to eq(12)
        expect(AocUtils.lcm_array([5, 7, 10])).to eq(70)
      end
    end
  end

  describe 'Distance Functions' do
    describe '.manhattan_distance' do
      it 'calculates manhattan distance in 2D' do
        expect(AocUtils.manhattan_distance([0, 0], [3, 4])).to eq(7)
        expect(AocUtils.manhattan_distance([1, 1], [4, 5])).to eq(7)
      end

      it 'calculates manhattan distance in 3D' do
        expect(AocUtils.manhattan_distance([0, 0, 0], [1, 2, 3])).to eq(6)
      end
    end

    describe '.chebyshev_distance' do
      it 'calculates chebyshev distance' do
        expect(AocUtils.chebyshev_distance([0, 0], [3, 4])).to eq(4)
        expect(AocUtils.chebyshev_distance([0, 0], [5, 3])).to eq(5)
      end
    end
  end

  describe 'Grid Helpers' do
    describe '.neighbors_4' do
      it 'returns 4 orthogonal neighbors' do
        neighbors = AocUtils.neighbors_4(1, 1)
        expect(neighbors).to contain_exactly([1, 2], [2, 1], [1, 0], [0, 1])
      end
    end

    describe '.neighbors_8' do
      it 'returns 8 neighbors including diagonals' do
        neighbors = AocUtils.neighbors_8(1, 1)
        expect(neighbors.length).to eq(8)
        expect(neighbors).to include([0, 0], [0, 1], [0, 2])
        expect(neighbors).to include([1, 0], [1, 2])
        expect(neighbors).to include([2, 0], [2, 1], [2, 2])
      end
    end

    describe '.in_bounds?' do
      let(:grid) { [[1, 2, 3], [4, 5, 6]] }

      it 'returns true for valid positions' do
        expect(AocUtils.in_bounds?(grid, 0, 0)).to be true
        expect(AocUtils.in_bounds?(grid, 1, 2)).to be true
      end

      it 'returns false for invalid positions' do
        expect(AocUtils.in_bounds?(grid, -1, 0)).to be false
        expect(AocUtils.in_bounds?(grid, 2, 0)).to be false
        expect(AocUtils.in_bounds?(grid, 0, 3)).to be false
      end
    end

    describe '.grid_find' do
      let(:grid) { [['a', 'b'], ['c', 'd']] }

      it 'finds a character in the grid' do
        expect(AocUtils.grid_find(grid, 'c')).to eq([1, 0])
        expect(AocUtils.grid_find(grid, 'a')).to eq([0, 0])
      end

      it 'returns nil if not found' do
        expect(AocUtils.grid_find(grid, 'z')).to be_nil
      end
    end
  end

  describe 'Parsing Helpers' do
    describe '.extract_integers' do
      it 'extracts integers from a string' do
        expect(AocUtils.extract_integers('x=5, y=10')).to eq([5, 10])
        expect(AocUtils.extract_integers('move -3 to 42')).to eq([-3, 42])
      end
    end

    describe '.extract_words' do
      it 'extracts words from a string' do
        expect(AocUtils.extract_words('hello-world 123')).to eq(%w[hello world])
      end
    end
  end

  describe 'Graph Algorithms' do
    describe '.bfs' do
      it 'finds distances in a simple graph' do
        # Graph: 0 -- 1 -- 2
        #        |
        #        3
        neighbors = ->(node) {
          case node
          when 0 then [1, 3]
          when 1 then [0, 2]
          when 2 then [1]
          when 3 then [0]
          end
        }

        distances = AocUtils.bfs(0, neighbors)
        expect(distances[0]).to eq(0)
        expect(distances[1]).to eq(1)
        expect(distances[2]).to eq(2)
        expect(distances[3]).to eq(1)
      end
    end

    describe '.topological_sort' do
      it 'sorts a DAG topologically' do
        nodes = %w[a b c d]
        edges = [['a', 'b'], ['a', 'c'], ['b', 'd'], ['c', 'd']]

        result = AocUtils.topological_sort(nodes, edges)
        expect(result.index('a')).to be < result.index('b')
        expect(result.index('a')).to be < result.index('c')
        expect(result.index('b')).to be < result.index('d')
        expect(result.index('c')).to be < result.index('d')
      end

      it 'returns nil for cyclic graphs' do
        nodes = %w[a b c]
        edges = [['a', 'b'], ['b', 'c'], ['c', 'a']]

        expect(AocUtils.topological_sort(nodes, edges)).to be_nil
      end
    end
  end
end

RSpec.describe Grid do
  let(:input) do
    <<~GRID
      abc
      def
      ghi
    GRID
  end

  subject { Grid.new(input) }

  describe '#initialize' do
    it 'parses the grid correctly' do
      expect(subject.height).to eq(3)
      expect(subject.width).to eq(3)
    end
  end

  describe '#[]' do
    it 'accesses cells by row and column' do
      expect(subject[0, 0]).to eq('a')
      expect(subject[1, 1]).to eq('e')
      expect(subject[2, 2]).to eq('i')
    end

    it 'returns nil for out of bounds' do
      expect(subject[-1, 0]).to be_nil
      expect(subject[3, 0]).to be_nil
    end
  end

  describe '#find' do
    it 'finds a character' do
      expect(subject.find('e')).to eq([1, 1])
      expect(subject.find('z')).to be_nil
    end
  end

  describe '#find_all' do
    let(:input) { "aXa\nXaX\naXa" }

    it 'finds all occurrences' do
      grid = Grid.new(input)
      positions = grid.find_all('X')
      expect(positions.length).to eq(4)
      expect(positions).to include([0, 1], [1, 0], [1, 2], [2, 1])
    end
  end

  describe '#neighbors_4' do
    it 'returns valid 4-neighbors' do
      expect(subject.neighbors_4(1, 1)).to contain_exactly([0, 1], [1, 0], [1, 2], [2, 1])
    end

    it 'excludes out of bounds neighbors' do
      expect(subject.neighbors_4(0, 0)).to contain_exactly([0, 1], [1, 0])
    end
  end
end

RSpec.describe 'AocUtils Extended' do
  describe 'Math Extensions' do
    describe '.mod_pow' do
      it 'calculates modular exponentiation' do
        expect(AocUtils.mod_pow(2, 10, 1000)).to eq(24)
        expect(AocUtils.mod_pow(3, 7, 13)).to eq(3)
      end
    end

    describe '.prime?' do
      it 'identifies primes correctly' do
        expect(AocUtils.prime?(2)).to be true
        expect(AocUtils.prime?(17)).to be true
        expect(AocUtils.prime?(4)).to be false
        expect(AocUtils.prime?(1)).to be false
      end
    end

    describe '.prime_factors' do
      it 'returns prime factors' do
        expect(AocUtils.prime_factors(12)).to eq([2, 2, 3])
        expect(AocUtils.prime_factors(17)).to eq([17])
      end
    end

    describe '.divisors' do
      it 'returns all divisors' do
        expect(AocUtils.divisors(12)).to eq([1, 2, 3, 4, 6, 12])
      end
    end

    describe '.binomial' do
      it 'calculates binomial coefficients' do
        expect(AocUtils.binomial(5, 2)).to eq(10)
        expect(AocUtils.binomial(10, 3)).to eq(120)
      end
    end
  end

  describe 'String Utilities' do
    describe '.char_frequencies' do
      it 'counts character frequencies' do
        expect(AocUtils.char_frequencies('aabbc')).to eq({ 'a' => 2, 'b' => 2, 'c' => 1 })
      end
    end

    describe '.hamming_distance' do
      it 'calculates hamming distance' do
        expect(AocUtils.hamming_distance('abc', 'axc')).to eq(1)
        expect(AocUtils.hamming_distance('abc', 'xyz')).to eq(3)
      end
    end

    describe '.edit_distance' do
      it 'calculates edit distance' do
        expect(AocUtils.edit_distance('kitten', 'sitting')).to eq(3)
        expect(AocUtils.edit_distance('abc', 'abc')).to eq(0)
      end
    end
  end

  describe 'Bit Operations' do
    describe '.popcount' do
      it 'counts set bits' do
        expect(AocUtils.popcount(7)).to eq(3)   # 111
        expect(AocUtils.popcount(8)).to eq(1)   # 1000
      end
    end

    describe '.bin_to_int' do
      it 'converts binary string to integer' do
        expect(AocUtils.bin_to_int('1010')).to eq(10)
      end
    end

    describe '.int_to_bin' do
      it 'converts integer to binary string' do
        expect(AocUtils.int_to_bin(10)).to eq('1010')
        expect(AocUtils.int_to_bin(5, 8)).to eq('00000101')
      end
    end
  end

  describe 'Combinatorics' do
    describe '.power_set' do
      it 'generates all subsets' do
        result = AocUtils.power_set([1, 2])
        expect(result).to contain_exactly([], [1], [2], [1, 2])
      end
    end
  end

  describe 'Ranges' do
    describe '.ranges_overlap?' do
      it 'detects overlapping ranges' do
        expect(AocUtils.ranges_overlap?(1..5, 3..7)).to be true
        expect(AocUtils.ranges_overlap?(1..3, 5..7)).to be false
      end
    end

    describe '.merge_ranges' do
      it 'merges overlapping ranges' do
        result = AocUtils.merge_ranges([1..3, 2..5, 7..9])
        expect(result).to eq([1..5, 7..9])
      end
    end
  end

  describe 'Hashing' do
    describe '.md5' do
      it 'calculates MD5 hash' do
        expect(AocUtils.md5('advent')).to eq('79181e621a6def7d3001234738c8b1ca')
      end
    end
  end

  describe 'Geometry' do
    describe '.polygon_area' do
      it 'calculates polygon area using shoelace formula' do
        # Square with vertices (0,0), (4,0), (4,4), (0,4) = area 16
        vertices = [[0, 0], [4, 0], [4, 4], [0, 4]]
        expect(AocUtils.polygon_area(vertices)).to eq(16.0)
      end
    end
  end
end

RSpec.describe PriorityQueue do
  describe 'min-heap behavior' do
    it 'pops items in priority order' do
      pq = PriorityQueue.new
      pq.push(5, 'five')
      pq.push(1, 'one')
      pq.push(3, 'three')
      pq.push(2, 'two')

      expect(pq.pop).to eq([1, 'one'])
      expect(pq.pop).to eq([2, 'two'])
      expect(pq.pop).to eq([3, 'three'])
      expect(pq.pop).to eq([5, 'five'])
    end

    it 'handles empty queue' do
      pq = PriorityQueue.new
      expect(pq.pop).to be_nil
      expect(pq.empty?).to be true
    end
  end
end
