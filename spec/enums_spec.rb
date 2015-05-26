describe 'enums' do
  it { expect(Color.all).to eq [Color.red, Color.green, Color.black, Color.blue] }
  it { expect(Direction.all).to eq [Direction.east, Direction.west, Direction.south, Direction.north] }
end
