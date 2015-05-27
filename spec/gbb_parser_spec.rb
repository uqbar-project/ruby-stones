require_relative './spec_helper'

describe GbbParser do
  let (:parser) { GbbParser.new }

  let (:gbb) {
'GBB/1.0
size 4 4
cell 0 0 Rojo 1 Verde 2 Azul 5
cell 0 1 Negro 3
cell 1 0 Negro 3 Rojo 0 Verde 0 Azul 0
head 3 3
%%'
  }

  let (:board) { parser.from_string gbb }

  context 'should create a board with the proper size' do
    it { expect(board.size).to eq [4, 4] }
  end

  context 'should set the position of the head' do
    it { expect(board.head_position).to eq [3, 3] }
  end

  context 'should set the cells' do
    it { expect(board.__cell_at__([0, 0])).to eq(red: 1, black: 0, green: 2, blue: 5) }
    it { expect(board.__cell_at__([0, 1])).to eq(black: 3, red: 0, green: 0, blue: 0) }
  end
end
