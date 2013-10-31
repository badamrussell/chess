require_relative 'sliding_piece'

class Rook < SlidingPiece
  attr_reader :first_move

  def initialize(pos, board, color)
    super(pos, board, color)
    @first_move = true
  end

  def valid_moves
    orthogonal_moves
  end

  def move(position)
    super(position)
    self.first_move = false
  end

  def dup(new_board)
    new_piece = super
    new_piece.first_move = self.first_move
  end

  def to_s
    self.color == :white ? '♖' : '♜'
  end

  protected
  attr_writer :first_move
end
