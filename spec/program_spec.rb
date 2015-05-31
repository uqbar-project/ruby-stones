require_relative './spec_helper'

describe Stones::Program do
  context 'empty program' do
    class SampleProgram1
      include Stones::Program

      def main
      end
    end
    before do
      @context = Stones::ExecutionContext.new
      @context.board = Board.empty(2, 2)
      @context.run SampleProgram1
    end

    it { expect(@context.board).to eq Board.empty(2, 2) }
  end

  context 'idempotent program' do
    class SampleProgram2
      include Stones::Program

      def main
        push! red
        pop! red
      end

    end

    before do
      @context = ExecutionContext.new
      @context.board = Board.empty(2, 2)
      @context.run SampleProgram2
    end

    it { expect(@context.board).to eq Board.from([[{}, {}], [{}, {}]]) }
  end

  context 'movement program' do
    class SampleProgram3
      include Stones::Program

      def main
        move! east
      end
    end
    before do
      @context = Stones::ExecutionContext.new
      @context.board = Board.empty(2, 2)
      @context.run SampleProgram3
    end

    it { expect(@context.board).to eq Board.empty(2, 2, [1, 0]) }
  end

  context 'simple program' do
    class SampleProgram4
      include Stones::Program

      def main
        push! red
        move! east
        push! black
        move! west
      end
    end
    before do
      @context = Stones::ExecutionContext.new
      @context.board = Board.empty(2, 2)
      @context.run SampleProgram4
    end

    it { expect(@context.board).to eq Board.from([[{}, {}], [{red: 1}, {black: 1}]], [0, 0]) }
  end


  context 'program with if' do
    class SampleProgram5
      include Stones::Program

      def main
        if can_move? south
          move! south
          push! red
        end
        push! black
        if count(black) >= 1
          push! red
        end
      end
    end

    before do
      @context = Stones::ExecutionContext.new
      @context.board = Board.empty(2, 2)
      @context.run SampleProgram5
    end

    it { expect(@context.board).to eq Board.from([[{}, {}], [{red: 1, black: 1}, {}]], [0, 0]) }
  end
end
