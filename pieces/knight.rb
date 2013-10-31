require_relative 'stepping_piece'

class Knight < SteppingPiece
  DELTAS = [  [-2, -1],
              [-2,  1],
              [-1, -2],
              [-1,  2],
              [ 1, -2],
              [ 1,  2],
              [ 2, -1],
              [ 2,  1] ]

  def initialize(pos, board, color)
    super(pos, board, color)
  end

  def to_s
    self.color == :white ? '♘' : '♞'
  end
end
