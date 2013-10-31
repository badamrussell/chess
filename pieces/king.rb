require_relative 'stepping_piece'

class King < SteppingPiece
  DELTAS = [  [0, -1],
              [0,  1],
              [-1, -1],
              [-1,  1],
              [-1,  0],
              [1, -1],
              [1,  0],
              [1, 1] ]

  def initialize(pos, board, color)
    super(pos, board, color)
    @first_move = true
  end

  def rook(side) # returns the rook on the specified side of the king
    row = (color == :white ? 0: 7)

    if side == :queen
      self.board[[row,0]]
    else
      self.board[[row,7]]
    end
  end

  def castling_position(side)
    row = (color == :white ? 0: 7)
    col = (side == :king ? 6 : 2)

    [row, col]
  end

  # if we castle this method modifies the board class to move the rook
  def move(pos)
    super(pos)

    if self.first_move
      if castling_position(:king) == pos
        row, col = self.pos[0], 5
        rook_pos = rook(:king).pos
        self.board.move!(rook_pos, [row, col])

      elsif castling_position(:queen) == pos
        row, col = self.pos[0], 3
        rook_pos = rook(:queen).pos
        self.board.move!(rook_pos, [row, col])
      end
    end

    @first_move = false
  end

  def clear_to_rook?(side)
    row = self.pos[0]
    if side == :king
      (5..6).to_a.all? { |col| self.board[[row, col]].nil? }
    else
      (1..3).to_a.all? { |col| self.board[[row, col]].nil? }
    end
  end

  def okay_to_castle?(side)
    return false unless clear_to_rook?(side)

    rook = rook(side)
    return false unless rook.is_a?(Rook)
    return false unless rook.first_move
    return false unless self.first_move

    !self.board.checked?(self.color) # you can't move while in check
  end

  def valid_moves
    results = []
    results << castling_position(:king) if okay_to_castle?(:king)
    results << castling_position(:queen) if okay_to_castle?(:queen)

    super + results
  end

  def dup(new_board)
    new_piece = super
    new_piece.first_move = self.first_move
    new_piece
  end

  def to_s
    self.color == :white ? '♔' : '♚'
  end

  protected
  attr_accessor :first_move
end
