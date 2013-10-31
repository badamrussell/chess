require_relative 'sliding_piece'

class Queen < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
  end

  def valid_moves
    orthogonal_moves + diagonal_moves
  end

  def to_s
    self.color == :white ? '♕' : '♛'
  end
end
