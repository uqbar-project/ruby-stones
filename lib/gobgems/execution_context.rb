module Gobgems
  class ExecutionContext
    attr_accessor :board

    def run(program_class)
      program = program_class.new
      program.board = board
      program.main
    end
  end
end
