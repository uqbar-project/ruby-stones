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

  East = Expression.new('Este')
  North = Expression.new('Norte')
  South = Expression.new('Sur')
  West = Expression.new('Oeste')

  Red = Expression.new('Rojo')
  Blue = Expression.new('Azul')
  Green = Expression.new('Verde')
  Black = Expression.new('Negro')

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
  describe "direcciones" do
    it { expect(East.compile).to eq 'Este' }
    it { expect(North.compile).to eq 'Norte' }
    it { expect(South.compile).to eq 'Sur' }
    it { expect(West.compile).to eq 'Oeste' }
  end
  describe "colores" do
    it { expect(Blue.compile).to eq 'Azul' }
    it { expect(Red.compile).to eq 'Rojo' }
    it { expect(Black.compile).to eq 'Negro' }
    it { expect(Green.compile).to eq 'Verde' }
  end

  describe "acciones" do
    it { expect((push Red).compile).to eq 'Poner(Rojo)' }
    it { expect((push Green).compile).to eq 'Poner(Verde)' }

    it { expect((move West).compile).to eq 'Mover(Oeste)' }
    it { expect((move East).compile).to eq 'Mover(Este)' }

    it { expect((pop Red).compile).to eq 'Sacar(Rojo)' }
    it { expect((pop Green).compile).to eq 'Sacar(Verde)' }
  end
end