module Stones
  module Color
    def red
      :red
    end

    def blue
      :blue
    end

    def green
      :green
    end

    def black
      :black
    end

    def self.all
      [red, green, black, blue]
    end

    module_function :red, :blue, :green, :black
  end
end
