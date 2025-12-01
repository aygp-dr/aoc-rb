require_relative '../solution'

RSpec.describe Day10 do
  describe '#look_and_say' do
    let(:solver) { Day10.new('1') }

    it 'transforms 1 to 11' do
      expect(solver.look_and_say('1')).to eq('11')
    end

    it 'transforms 11 to 21' do
      expect(solver.look_and_say('11')).to eq('21')
    end

    it 'transforms 21 to 1211' do
      expect(solver.look_and_say('21')).to eq('1211')
    end

    it 'transforms 1211 to 111221' do
      expect(solver.look_and_say('1211')).to eq('111221')
    end

    it 'transforms 111221 to 312211' do
      expect(solver.look_and_say('111221')).to eq('312211')
    end
  end

  describe '#iterate' do
    it 'applies transformation n times starting from 1' do
      solver = Day10.new('1')
      expect(solver.iterate(1)).to eq('11')
      expect(solver.iterate(2)).to eq('21')
      expect(solver.iterate(3)).to eq('1211')
      expect(solver.iterate(4)).to eq('111221')
      expect(solver.iterate(5)).to eq('312211')
    end
  end

  describe 'sequence growth' do
    it 'shows expected growth pattern' do
      solver = Day10.new('1')
      # The sequence grows roughly by a factor of 1.3 each iteration
      lengths = (0..10).map { |n| solver.iterate(n).length }
      expect(lengths).to eq([1, 2, 2, 4, 6, 6, 8, 10, 14, 20, 26])
    end
  end
end
