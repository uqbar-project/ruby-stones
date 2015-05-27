require_relative './gbb/gbb_reader'
require_relative './gbb/gbb_writer'

module Gobgems
  module Gbb
    def self.read(gbb)
      GbbReader.new.from_string(gbb)
    end

    def self.write(board)
      GbbWriter.write(board)
    end
  end
end
