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
  class Value
    def initialize(compiled)
      @compiled = compiled
    end
    def compile
      @compiled
    end
  end
  East = Value.new('Este')
  North = Value.new('Norte')
  South = Value.new('Sur')
  West = Value.new('Oeste')
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
end