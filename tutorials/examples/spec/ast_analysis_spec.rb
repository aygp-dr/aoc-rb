# frozen_string_literal: true

require_relative '../ast_analysis'

RSpec.describe 'AST Analysis' do
  describe '#sexp' do
    it 'parses simple code to S-expression' do
      result = sexp('1 + 2')

      expect(result).to be_an(Array)
      expect(result.first).to eq(:program)
    end

    it 'parses method definition' do
      result = sexp('def foo; end')

      expect(result).to be_an(Array)
      # Should contain :def somewhere in the tree
      expect(result.flatten).to include(:def)
    end
  end

  describe '#tokenize' do
    it 'returns array of tokens' do
      result = tokenize('x = 1 + 2')

      expect(result).to be_an(Array)
      expect(result).to include('x')
      expect(result).to include('=')
      expect(result).to include('1')
      expect(result).to include('+')
      expect(result).to include('2')
    end
  end

  describe '#lex' do
    it 'returns tokens with position info' do
      result = lex('x = 1')

      expect(result).to be_an(Array)
      expect(result.first).to be_an(Array)

      # Each token should have position, type, value, state
      pos, type, value, _state = result.first
      expect(pos).to be_an(Array)
      expect(pos.size).to eq(2) # [line, col]
      expect(type).to be_a(Symbol)
      expect(value).to be_a(String)
    end
  end

  describe '#find_methods' do
    it 'finds method definitions in code' do
      code = <<~RUBY
        def foo; end
        def bar(x); x * 2; end
        def baz(a, b); a + b; end
      RUBY

      methods = find_methods(code)

      expect(methods).to include('foo')
      expect(methods).to include('bar')
      expect(methods).to include('baz')
    end

    it 'returns empty array when no methods' do
      methods = find_methods('x = 1 + 2')

      expect(methods).to eq([])
    end
  end
end
