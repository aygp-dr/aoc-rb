require_relative '../solution'

RSpec.describe Day04 do
  describe '#part1' do
    it 'finds 609043 for secret abcdef' do
      expect(Day04.new('abcdef').part1).to eq(609043)
    end

    it 'finds 1048970 for secret pqrstuv' do
      expect(Day04.new('pqrstuv').part1).to eq(1048970)
    end
  end

  describe 'MD5 hash verification' do
    it 'produces hash starting with 5 zeros for abcdef609043' do
      hash = Digest::MD5.hexdigest('abcdef609043')
      expect(hash).to start_with('00000')
    end

    it 'produces hash starting with 5 zeros for pqrstuv1048970' do
      hash = Digest::MD5.hexdigest('pqrstuv1048970')
      expect(hash).to start_with('00000')
    end
  end

  describe 'Ruby idiom: Digest::MD5' do
    it 'computes MD5 hexdigest' do
      expect(Digest::MD5.hexdigest('hello')).to eq('5d41402abc4b2a76b9719d911017c592')
    end

    it 'returns 32 character hex string' do
      hash = Digest::MD5.hexdigest('anything')
      expect(hash.length).to eq(32)
      expect(hash).to match(/\A[0-9a-f]{32}\z/)
    end
  end

  describe 'Ruby idiom: infinite range (1..)' do
    it 'finds first match with find' do
      # Find first number > 100 divisible by 7
      result = (1..).find { |n| n > 100 && n % 7 == 0 }
      expect(result).to eq(105)
    end

    it 'is lazy by default in Ruby 2.6+' do
      # This doesn't hang because find stops at first match
      result = (1..).find { |n| n == 10 }
      expect(result).to eq(10)
    end
  end

  describe 'Ruby idiom: start_with?' do
    it 'checks string prefix' do
      expect('00000abc'.start_with?('00000')).to be true
      expect('0000abc'.start_with?('00000')).to be false
    end

    it 'accepts multiple prefixes' do
      expect('hello'.start_with?('he', 'hi', 'ho')).to be true
    end
  end

  describe 'Ruby idiom: String slicing vs start_with?' do
    it 'slice comparison works but is less readable' do
      hash = '00000abcdef'
      expect(hash[0, 5]).to eq('00000')
      expect(hash[0...5]).to eq('00000')
    end
  end
end
