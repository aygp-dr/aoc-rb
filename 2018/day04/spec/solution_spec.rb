require_relative '../solution'

RSpec.describe Day04 do
  let(:example_input) do
    <<~INPUT
      [1518-11-01 00:00] Guard #10 begins shift
      [1518-11-01 00:05] falls asleep
      [1518-11-01 00:25] wakes up
      [1518-11-01 00:30] falls asleep
      [1518-11-01 00:55] wakes up
      [1518-11-01 23:58] Guard #99 begins shift
      [1518-11-02 00:40] falls asleep
      [1518-11-02 00:50] wakes up
      [1518-11-03 00:05] Guard #10 begins shift
      [1518-11-03 00:24] falls asleep
      [1518-11-03 00:29] wakes up
      [1518-11-04 00:02] Guard #99 begins shift
      [1518-11-04 00:36] falls asleep
      [1518-11-04 00:46] wakes up
      [1518-11-05 00:03] Guard #99 begins shift
      [1518-11-05 00:45] falls asleep
      [1518-11-05 00:55] wakes up
    INPUT
  end

  subject { described_class.new(example_input) }

  describe '#part1' do
    it 'finds sleepiest guard * most common minute' do
      # Guard #10 slept 50 mins total, most on minute 24
      # 10 * 24 = 240
      expect(subject.part1).to eq(240)
    end
  end

  describe '#part2' do
    it 'finds guard most frequently on same minute' do
      # Guard #99 was asleep on minute 45 three times
      # 99 * 45 = 4455
      expect(subject.part2).to eq(4455)
    end
  end

  describe 'Ruby idiom: sort for chronological order' do
    it 'sorts strings lexicographically (works for ISO dates)' do
      events = [
        '[1518-11-03 00:05]',
        '[1518-11-01 00:00]',
        '[1518-11-02 00:40]'
      ]
      expect(events.sort.first).to eq('[1518-11-01 00:00]')
    end
  end

  describe 'Ruby idiom: Hash.new with block' do
    it 'creates new array for each key' do
      h = Hash.new { |hash, key| hash[key] = Array.new(3, 0) }
      h[:a][0] += 1
      h[:b][1] += 1
      expect(h[:a]).to eq([1, 0, 0])
      expect(h[:b]).to eq([0, 1, 0])
      # Each key has independent array
    end
  end

  describe 'Ruby idiom: each_with_index.max_by' do
    it 'finds index of maximum value' do
      arr = [3, 7, 2, 9, 4]
      max_idx = arr.each_with_index.max_by { |val, _| val }.last
      expect(max_idx).to eq(3)  # Index of 9
    end

    it 'returns [value, index] pair' do
      arr = [3, 7, 2, 9, 4]
      result = arr.each_with_index.max_by { |val, _| val }
      expect(result).to eq([9, 3])
    end
  end

  describe 'Ruby idiom: case for event dispatch' do
    it 'matches symbols efficiently' do
      event = { type: :sleep, minute: 5 }
      result = case event[:type]
               when :shift then 'new guard'
               when :sleep then 'sleeping'
               when :wake then 'waking'
               end
      expect(result).to eq('sleeping')
    end
  end

  describe 'Ruby idiom: range iteration for minutes' do
    it 'iterates exclusive range' do
      sleep_start = 5
      wake = 10
      minutes = []
      (sleep_start...wake).each { |m| minutes << m }
      expect(minutes).to eq([5, 6, 7, 8, 9])
    end
  end
end
