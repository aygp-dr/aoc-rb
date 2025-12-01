class Solution
  attr_reader :input
  
  def initialize(input)
    @input = input.strip.lines.map(&:chomp)
  end
  
  def part1
    input.each_with_object(0) do |line, acc|
      # Process line
    end
  end
  
  def part2
    # Usually builds on part1
  end
  
  private
  
  def parse_line(line)
    # Common parsing logic
  end
end
