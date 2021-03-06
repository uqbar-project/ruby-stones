module Stones
  module GbbWriter
    def self.write(board)
      "GBB/1.0\n" +
      "size #{board.size[0]} #{board.size[1]}\n" +
      "#{write_cells board}" +
      "head #{board.head_position[0]} #{board.head_position[1]}"
    end

    private

    def self.write_cells(board)
      cells_gbb = ''

      board.send :each_cell do |cell, x, y|
        cell = cell.select { |color, count| count > 0 }
        next if cell.empty?
        cells_gbb << "cell #{x} #{y} #{write_colors cell}\n"
      end

      cells_gbb
    end

    def self.write_colors(cell)
      cell.map { |color, count| "#{to_gbb_color color} #{count}" }.join(' ')
    end

    def self.to_gbb_color(color)
      case color
        when :red then 'Rojo'
        when :green then 'Verde'
        when :black then 'Negro'
        when :blue then 'Azul'
      end
    end
  end
end
