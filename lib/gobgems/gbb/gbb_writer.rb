module Gobgems
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

      board.__each_cell__ do |cell, x, y|
        cell.select { |color, count| count > 0 }.each do |color, count|
          cells_gbb << "cell #{x} #{y} #{to_gbb_color color} #{count}\n"
        end
      end

      cells_gbb
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
