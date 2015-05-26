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

  def east;
    Expression.new('Este');
  end

  def north;
    Expression.new('Norte');
  end

  def south;
    Expression.new('Sur');
  end

  def west;
    Expression.new('Oeste');
  end

  def red;
    Expression.new('Rojo');
  end

  def blue;
    Expression.new('Azul');
  end

  def green;
    Expression.new('Verde');
  end

  def black;
    Expression.new('Negro');
  end

  def directions;
    [north, east, south, west];
  end

  def colors;
    [blue, black, red, green];
  end

  def pop(color)
    clean_context { pop(color) }
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

  module Program

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
