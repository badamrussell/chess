require_relative 'piece'

class Pawn < Piece
  def initialize(pos, board, color)
    super(pos, board, color)
    @first_move = true
    @direction = (self.color == :white ? 1 : -1)
  end

  def first_move?
    @first_move
  end

  def move(final)
    super(final)

    @first_move = false
    row = self.pos[0]

    if row == 0 || row == 7
      self.board.promote_pawn(self.color, self.pos)
    end
  end

  def forward_positions
    deltas_to_check = [[self.direction, 0]]

    deltas_to_check << [2 * self.direction, 0] if self.first_move?

    deltas_to_check.map do |d_row, d_col|
      [d_row + self.pos[0], d_col + self.pos[1]]
    end
  end

  def attack_positions
    positions = [[self.direction, 1], [self.direction, -1]].map do |d_row, d_col|
      [d_row+self.pos[0], d_col+self.pos[1]]
    end

    positions + en_passant_attack
  end

  def en_passant_attack
    # will add
    positions = []

    #check if there is another opponent pawn horizontally adjacent
    left_side = [pos[0],pos[1]-1]
    if self.board[left_side].is_a?(Pawn) && self.board[left_side].first_move?

    end
    right_side = [pos[0],pos[1]+1]
    if self.board[right_side].is_a?(Pawn) && self.board[right_side].first_move?

    end
    positions
  end

  def moves_ahead
    ahead = []
    forward_positions.each do |pos|

      self.board[pos].nil? ? ahead << pos : break
      # if self.board[pos].nil?
      #   ahead << pos
      # else
      #   break
      # end
    end

    ahead
  end

  def moves_diag
    diag = []
    attack_positions.each do |pos|
      piece = self.board[pos]
      next if piece.nil?
      diag << pos if piece.color != self.color
    end

    diag
  end

  def valid_moves
    moves_ahead + moves_diag
  end

  def to_s
    self.color == :white ? '♙' : '♟'
  end

  protected

  attr_reader :direction
end