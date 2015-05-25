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
    clean_context { pop(color )}
  end

  def push(color)
    clean_context { push(color) }
  end

  def move(direction)
    clean_context { move(direction) }
  end


  def program(&block)
    context = Context.new('  ')
    context.instance_eval &block
    Expression.new("program {\n#{context.compile}}")
  end

  private

  def clean_context(&block)
    c = Context.new
    c.instance_eval(&block)
  end

  class Context
    def initialize(tab='')
      @actions = []
      @tab = tab
    end

    def pop(color)
      add_action Expression.new("Sacar(#{color.compile})")
    end

    def push(color)
      add_action Expression.new("Poner(#{color.compile})")
    end

    def move(direction)
      add_action Expression.new("Mover(#{direction.compile})")
    end

    def compile
      @actions.map { |a| "#{@tab}#{a.compile}\n" }.join('')
    end

    private

    def add_action(action)
      @actions << action
      action
    end
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

  describe "program" do
    it { expect((program do end).compile).to eq "program {\n}" }
    it { expect((program do true end).compile).to eq "program {\n}" }
    it { expect((program do 2 end).compile).to eq "program {\n}" }
    it { expect((program do red end).compile).to eq "program {\n}" }
    it { expect((program do green end).compile).to eq "program {\n}" }
    it { expect((program do push red end).compile).to eq "program {\n  Poner(Rojo)\n}" }
    it { expect((program do push red; push green end).compile).to eq "program {\n  Poner(Rojo)\n  Poner(Verde)\n}" }
  end
end