require_relative './gobgems'
require 'rspec'

include Gobgems

describe "valores" do
  describe "numeros" do
    it { expect(1.compile).to eq '1' }
    it { expect(10.compile).to eq '10' }
  end
  describe "booleanos" do
    it { expect(true.compile).to eq 'true' }
    it { expect(false.compile).to eq 'false' }
  end
  describe "direccion
    def es east" do
    it { expect(east.compile).to eq 'Este' }
    it { expect(north.compile).to eq 'Norte' }
    it { expect(south.compile).to eq 'Sur' }
    it { expect(west.compile).to eq 'Oeste' }
  end
  describe "colores" do
    it { expect(blue.compile).to eq 'Azul' }
    it { expect(red.compile).to eq 'Rojo' }
    it { expect(black.compile).to eq 'Negro' }
    it { expect(green.compile).to eq 'Verde' }
  end

  describe "acciones" do
    it { expect((push red).compile).to eq 'Poner(Rojo)' }
    it { expect((push green).compile).to eq 'Poner(Verde)' }

    it { expect((move west).compile).to eq 'Mover(Oeste)' }
    it { expect((move east).compile).to eq 'Mover(Este)' }

    it { expect((pop red).compile).to eq 'Sacar(Rojo)' }
    it { expect((pop green).compile).to eq 'Sacar(Verde)' }
  end

  describe "program" do
    it { expect((program do
    end).compile).to eq "program {\n}" }
    it { expect((program do
      true
    end).compile).to eq "program {\n}" }
    it { expect((program do
      2
    end).compile).to eq "program {\n}" }
    it { expect((program do
      red
    end).compile).to eq "program {\n}" }
    it { expect((program do
      green
    end).compile).to eq "program {\n}" }
    it { expect((program do
      push red
    end).compile).to eq "program {\n  Poner(Rojo)\n}" }
    it { expect((program do
      push red; push green
    end).compile).to eq "program {\n  Poner(Rojo)\n  Poner(Verde)\n}" }
  end


end
