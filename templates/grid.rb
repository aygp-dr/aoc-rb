class GridSolution
  def initialize(input)
    @grid = input.strip.lines.map { |line| line.chomp.chars }
    @height = @grid.length
    @width = @grid[0].length
  end
  
  def at(row, col)
    return nil if row < 0 || col < 0 || row >= @height || col >= @width
    @grid[row][col]
  end
  
  def neighbors(row, col, diagonal: false)
    deltas = diagonal ? 
      [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]] :
      [[-1,0],[0,-1],[0,1],[1,0]]
    
    deltas.map { |dr, dc| [row + dr, col + dc] }
          .select { |r, c| at(r, c) }
  end
end
