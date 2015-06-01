require_relative './spec_helper'

describe Board do

  it { expect(Board.empty(1, 1)).to eq Board.empty(1, 1) }
  it { expect(Board.empty(1, 1)).to_not eq Board.empty(2, 2) }

  it { expect(Board.empty(1, 1)).to eq Board.from([[{}]]) }
  it { expect(Board.from([[{red: 1}]])).to eq Board.from([[{red: 1}]]) }
  it { expect(Board.from([[{red: 2}]])).to eq Board.from([[{red: 2}]]) }
  it { expect(Board.from([[{green: 2}]])).to eq Board.from([[{green: 2}]]) }

  it { expect(Board.empty(2, 2)).to eq Board.from([[{}, {}], [{}, {}]]) }

  describe 'ops' do
    let(:board) { Board.empty(2, 2) }

    context 'idempotent put ops' do
      before do
        board.push! Color.red
        board.pop! Color.red
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]]) }
    end

    context 'single push op' do
      before do
        board.push! Color.red
      end
      it { expect(board).to eq Board.from([[{}, {}], [{red: 1}, {}]]) }
    end

    context 'invalid pop op' do
      it { expect { board.pop! Color.red }.to raise_exception }
    end

    context 'multiple push ops' do
      before do
        board.push! Color.red
        board.push! Color.red
        board.push! Color.blue
      end
      it { expect(board).to eq Board.from([[{}, {}], [{red: 2, blue: 1}, {}]]) }
    end

    context 'multiple push ops with movement' do
      before do
        board.move! Direction.north
        board.push! Color.green
        board.push! Color.black
        board.move! Direction.south
      end
      it { expect(board).to eq Board.from([[{green: 1, black: 1}, {}], [{}, {}]]) }
    end

    context 'push with color query' do
      before do
        board.push! Color.green
        board.push! Color.green
        board.push! Color.red
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
      it { expect(board.can_move?(Direction.north)).to be true }
      it { expect(board.can_move?(Direction.west)).to be false }
      it { expect(board.can_move?(Direction.south)).to be false }
    end

    context 'idempotent move_to_edge horizontal idempotent ops' do
      before do
        board.move_to_edge! Direction.east
        board.move_to_edge! Direction.west
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]], [0, 0]) }
    end

    context 'idempotent move_to_edge vertical idempotent ops' do
      before do
        board.move_to_edge! Direction.north
        board.move_to_edge! Direction.south
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]], [0, 0]) }
    end

    context 'idempotent move_to_edge mixed ops' do
      before do
        board.move_to_edge! Direction.east
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]], [1, 0]) }
    end

    context 'idempotent move_to_edge vertical ops' do
      before do
        board.move_to_edge! Direction.north
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]], [0, 1]) }
    end

    context 'idempotent move horizontal ops' do
      before do
        board.move! Direction.east
        board.move! Direction.west
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]]) }
    end


    context 'idempotent move vertical ops' do
      before do
        board.move! Direction.north
        board.move! Direction.south
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]]) }
    end

    context 'move within board' do
      before do
        board.move! Direction.east
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]], [1, 0]) }
    end

    context 'when clear empty board' do
      before do
        board.clear!
      end
      it { expect(board).to eq Board.empty(2, 2) }
    end

    context 'when clear non empty board' do
      before do
        board.push! Color.red
        board.move! Direction.east
        board.clear!
      end
      it { expect(board).to eq Board.empty(2, 2, [1, 0]) }
    end


    context 'move within board multiple times' do
      before do
        board.move! Direction.north
        board.move! Direction.east
      end
      it { expect(board).to eq Board.from([[{}, {}], [{}, {}]], [1, 1]) }
    end

    context 'move without external bounds' do
      before do
        board.move! Direction.north
      end
      it { expect { board.move! Direction.north }.to raise_exception }
    end

    context 'move out of board' do
      it { expect { board.move! Direction.west }.to raise_exception }
      it { expect { board.move! Direction.south }.to raise_exception }
    end
  end

end

