require_relative 'piece'

class SteppingPiece < Piece
  def initialize(pos, board, color)
    super(pos, board, color)
  end

  def valid_moves
    possible_moves = []
    self.class::DELTAS.each do |d_row, d_col|
      row, col = d_row + pos[0], d_col + pos[1]
      possible_moves << [row, col] if legal_move?([row, col])
    end

    possible_moves
  end
end