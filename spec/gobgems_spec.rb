require_relative '../lib/gobgems'
require 'rspec'

include Gobgems

describe 'enums' do
  it { expect(Color.all).to eq [Color.red, Color.green, Color.black, Color.blue] }
  it { expect(Direction.all).to eq [Direction.east, Direction.west, Direction.south, Direction.north] }
end

describe "board" do

  it { expect(Board.empty(1, 1)).to eq Board.empty(1, 1) }
  it { expect(Board.empty(1, 1)).to eq Board.from([[{}]]) }
  it { expect(Board.empty(2, 2)).to eq Board.from([[{}, {}], [{}, {}]]) }

  describe 'ops' do
    let(:board) { Board.empty(2, 2) }

    context 'idempotent put ops' do
      before do
        board.push Color.red
        board.pop Color.red
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]]) }
    end

    context 'single push op' do
      before do
        board.push Color.red
      end
      it { expect(board).to eq Board.from([[{red: 1}, {}], [{}, {}]]) }
    end

    context 'invalid pop op' do
      it { expect { board.pop Color.red }.to raise_exception }
    end

    context 'multiple push ops' do
      before do
        board.push Color.red
        board.push Color.red
        board.push Color.blue
      end
      it { expect(board).to eq Board.from([[{red: 2, blue: 1}, {}], [{}, {}]]) }
    end

    context 'multiple push ops with movement' do
      before do
        board.move Direction.south
        board.push Color.green
        board.push Color.black
        board.move Direction.north
      end
      it { expect(board).to eq Board.from([[{}, {}], [{green: 1, black: 1}, {}]]) }
    end

    context 'push with color query' do
      before do
        board.push Color.green
        board.push Color.green
        board.push Color.red
      end
      it { expect(board.count(Color.green)).to eq 2 }
      it { expect(board.count(Color.red)).to eq 1 }
      it { expect(board.count(Color.black)).to eq 0 }

      it { expect(board.exist?(Color.green)).to be true }
      it { expect(board.exist?(Color.red)).to be true }
      it { expect(board.exist?(Color.blue)).to be false }
    end


    context 'can move query' do
      it { expect(board.can_move?(Direction.east)).to be true }
      it { expect(board.can_move?(Direction.south)).to be true }
      it { expect(board.can_move?(Direction.west)).to be false }
      it { expect(board.can_move?(Direction.north)).to be false }
    end


    context 'idempotent move horizontal ops' do
      before do
        board.move Direction.east
        board.move Direction.west
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]]) }
    end


    context 'idempotent move vertical ops' do
      before do
        board.move Direction.south
        board.move Direction.north
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]]) }
    end

    context 'move within board' do
      before do
        board.move Direction.east
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]], [0, 1]) }
    end

    context 'move within board multiple times' do
      before do
        board.move Direction.south
        board.move Direction.east
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]], [1, 1]) }
    end

    context 'move without external bounds' do
      before do
        board.move Direction.south
        board.move Direction.south
      end
      it { expect { board.move Direction.south }.to raise_exception  }
    end

    context 'move out of board' do
      it { expect { board.move Direction.west }.to raise_exception }
      it { expect { board.move Direction.north }.to raise_exception }
    end
  end

end


describe "valores" do
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

    it { expect(@context.board).to eq Board.empty(2, 2, [0, 1]) }
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
      @context.run SampleProgram3
    end

    it { expect(@context.board).to eq Board.empty(2, 2, [0, 1]) }
  end


  context 'program with if' do
    class SampleProgram5
      include Gobgems::Program

      def main
        if can_move? north
          move north
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

    it { expect(@context.board).to eq Board.from([[{red: 1, black: 1}, {}], [{}, {}]], [0, 0]) }
  end
end
