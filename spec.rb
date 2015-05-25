module Gobgems
  class ::Fixnum
    def compile
      to_s
    end
  end
  class ::TrueClass
    def compile
      'true'
    end
  end
  class ::FalseClass
    def compile
      'false'
    end
  end
  class Expression
    def initialize(compiled)
      @compiled = compiled
    end
    def compile
      @compiled
    end
  end

  def east; Expression.new('Este'); end
  def north; Expression.new('Norte'); end
  def south; Expression.new('Sur'); end
  def west; Expression.new('Oeste'); end

  def red; Expression.new('Rojo'); end
  def blue; Expression.new('Azul'); end
  def green; Expression.new('Verde'); end
  def black; Expression.new('Negro'); end

  def pop(color)
    Expression.new("Sacar(#{color.compile})")
  end

  def push(color)
    Expression.new("Poner(#{color.compile})")
  end

  def move(direction)
    Expression.new("Mover(#{direction.compile})")
  end
end

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
end