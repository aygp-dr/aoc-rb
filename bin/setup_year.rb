#!/usr/bin/env ruby
require 'fileutils'

year = ARGV[0] || Time.now.year

(1..25).each do |day|
  day_str = day.to_s.rjust(2, '0')
  dir = "#{year}/day#{day_str}"
  
  FileUtils.mkdir_p(dir)
  FileUtils.mkdir_p("#{dir}/spec")
  
  # Create main solution file
  File.write("#{dir}/solution.rb", <<~RUBY)
    # Advent of Code #{year} - Day #{day}
    
    class Day#{day_str}
      def initialize(input)
        @input = input
      end
      
      def part1
        # TODO: Implement part 1
      end
      
      def part2
        # TODO: Implement part 2
      end
    end
    
    if __FILE__ == $0
      input = File.read('input.txt')
      solver = Day#{day_str}.new(input)
      puts "Part 1: \#{solver.part1}"
      puts "Part 2: \#{solver.part2}"
    end
  RUBY
  
  # Create spec file
  File.write("#{dir}/spec/solution_spec.rb", <<~RUBY)
    require_relative '../solution'
    
    RSpec.describe Day#{day_str} do
      let(:example_input) { <<~INPUT }
        # TODO: Add example input
      INPUT
      
      subject { described_class.new(example_input) }
      
      describe '#part1' do
        it 'solves the example' do
          skip 'Not implemented yet'
          expect(subject.part1).to eq(nil)
        end
      end
      
      describe '#part2' do
        it 'solves the example' do
          skip 'Not implemented yet'
          expect(subject.part2).to eq(nil)
        end
      end
    end
  RUBY
  
  # Create placeholder files
  FileUtils.touch("#{dir}/input.txt")
  FileUtils.touch("#{dir}/README.md")
end

puts "Setup complete for year #{year}!"
