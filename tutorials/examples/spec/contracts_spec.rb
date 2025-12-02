# frozen_string_literal: true

require_relative '../contracts'

RSpec.describe Contracts do
  describe '.check_type' do
    it 'returns value when type matches' do
      expect(Contracts.check_type(42, Integer)).to eq(42)
      expect(Contracts.check_type('hello', String)).to eq('hello')
      expect(Contracts.check_type([1, 2], Array)).to eq([1, 2])
    end

    it 'raises ValidationError when type does not match' do
      expect { Contracts.check_type('42', Integer) }
        .to raise_error(Contracts::ValidationError, /expected Integer, got String/)
    end
  end

  describe '.positive' do
    it 'returns value when positive' do
      expect(Contracts.positive(5)).to eq(5)
      expect(Contracts.positive(0.1)).to eq(0.1)
    end

    it 'raises ValidationError for zero' do
      expect { Contracts.positive(0) }
        .to raise_error(Contracts::ValidationError, /must be positive/)
    end

    it 'raises ValidationError for negative' do
      expect { Contracts.positive(-5) }
        .to raise_error(Contracts::ValidationError, /must be positive/)
    end
  end

  describe '.non_negative' do
    it 'returns value when non-negative' do
      expect(Contracts.non_negative(0)).to eq(0)
      expect(Contracts.non_negative(5)).to eq(5)
    end

    it 'raises ValidationError for negative' do
      expect { Contracts.non_negative(-1) }
        .to raise_error(Contracts::ValidationError, /must be non-negative/)
    end
  end

  describe '.in_range' do
    it 'returns value when in range' do
      expect(Contracts.in_range(50, 0..100)).to eq(50)
      expect(Contracts.in_range(0, 0..100)).to eq(0)
      expect(Contracts.in_range(100, 0..100)).to eq(100)
    end

    it 'raises ValidationError when out of range' do
      expect { Contracts.in_range(150, 0..100) }
        .to raise_error(Contracts::ValidationError, /must be in/)
    end
  end

  describe '.not_empty' do
    it 'returns value when not empty' do
      expect(Contracts.not_empty([1, 2, 3])).to eq([1, 2, 3])
      expect(Contracts.not_empty('hello')).to eq('hello')
    end

    it 'raises ValidationError for empty array' do
      expect { Contracts.not_empty([]) }
        .to raise_error(Contracts::ValidationError, /must not be empty/)
    end

    it 'raises ValidationError for nil' do
      expect { Contracts.not_empty(nil) }
        .to raise_error(Contracts::ValidationError, /must not be empty/)
    end
  end

  describe '.matches' do
    it 'returns value when pattern matches' do
      expect(Contracts.matches('hello@example.com', /@/)).to eq('hello@example.com')
    end

    it 'raises ValidationError when pattern does not match' do
      expect { Contracts.matches('hello', /@/) }
        .to raise_error(Contracts::ValidationError, /must match/)
    end
  end
end

RSpec.describe Calculator do
  let(:calc) { Calculator.new }

  describe '#divide' do
    it 'divides two positive numbers' do
      expect(calc.divide(10, 2)).to eq(5.0)
    end

    it 'raises ValidationError for division by zero or negative' do
      expect { calc.divide(10, 0) }
        .to raise_error(Contracts::ValidationError, /must be positive/)
    end

    it 'raises ValidationError for non-numeric argument' do
      expect { calc.divide('ten', 2) }
        .to raise_error(Contracts::ValidationError, /expected Numeric/)
    end
  end

  describe '#sqrt' do
    it 'calculates square root of positive number' do
      expect(calc.sqrt(16)).to eq(4.0)
      expect(calc.sqrt(2)).to be_within(0.001).of(1.414)
    end

    it 'calculates square root of zero' do
      expect(calc.sqrt(0)).to eq(0.0)
    end

    it 'raises ValidationError for negative number' do
      expect { calc.sqrt(-4) }
        .to raise_error(Contracts::ValidationError, /must be non-negative/)
    end
  end
end
