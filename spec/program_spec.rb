require_relative './spec_helper'

describe Gobgems::Program do
  context 'empty program' do
    class SampleProgram1
      include Gobgems::Program

      def main
      end
    end
    before do
      @context = Gobgems::ExecutionContext.new
      @context.board = Board.empty(2, 2)
      @context.run SampleProgram1
    end

    it { expect(@context.board).to eq Board.empty(2, 2) }
  end

  context 'idempotent program' do
    class SampleProgram2
      include Gobgems::Program

      def main
        push red
        pop red
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
      include Gobgems::Program

      def main
        move east
      end
    end
    before do
      @context = Gobgems::ExecutionContext.new
      @context.board = Board.empty(2, 2)
      @context.run SampleProgram3
    end

    it { expect(@context.board).to eq Board.empty(2, 2, [1, 0]) }
  end

  context 'simple program' do
    class SampleProgram4
      include Gobgems::Program

      def main
        push red
        move east
        push black
        move west
      end
    end
    before do
      @context = Gobgems::ExecutionContext.new
      @context.board = Board.empty(2, 2)
      @context.run SampleProgram4
    end

    it { expect(@context.board).to eq Board.from([[{}, {}], [{red: 1}, {black: 1}]], [0, 0]) }
  end


  context 'program with if' do
    class SampleProgram5
      include Gobgems::Program

      def main
        if can_move? south
          move south
          push red
        end
        push black
        if count(black) >= 1
          push red
        end
      end
    end

    before do
      @context = Gobgems::ExecutionContext.new
      @context.board = Board.empty(2, 2)
      @context.run SampleProgram5
    end

    it { expect(@context.board).to eq Board.from([[{}, {}], [{red: 1, black: 1}, {}]], [0, 0]) }
  end
end
