require_relative "chessboard"

class Game
  class BadMoveError < ArgumentError
  end

  COLUMNS = { "a" => 0,
              "b" => 1,
              "c" => 2,
              "d" => 3,
              "e" => 4,
              "f" => 5,
              "g" => 6,
              "h" => 7 }

  attr_reader :chess_board

  def initialize
    @chess_board = ChessBoard.new
    @current_player = :white
    chess_board.start_game
  end

  def format_position(position)
    col_letter = position[0]
    row = position[1]

    #either of the digits could be a letter
    if ("a".."h") === position[1]
      #second digit is the letter
      col_letter = position[1]
      row = position[0]
    end

    raise ChessBoard::BadMoveError unless ("a".."g") === col_letter

    col = COLUMNS[col_letter]
    row = row.to_i-1 # Integer(row) can throw an error that we can rescue
    raise ChessBoard::BadMoveError unless (0...8) === row

    [row, col]
  end

  def prompt_user
    begin
      puts "Type in your move, #{self.current_player}"
      str_input = gets.downcase.chomp.split(",")
      row1, col1 = str_input[0].split('')
      row2, col2 = str_input[1].split('')

      #raise error if str_input is not 2 digits
      start = format_position([row1, col1])
      final = format_position([row2, col2])
      [start, final]
    rescue ChessBoard::BadMoveError
      puts "One of those positions is invalid."
      retry
    end
  end

  def game_turn
    puts self.chess_board
    start, final = prompt_user

    self.chess_board.move(start, final)
  end

  def play_game

    loop do
      begin
        game_turn
      rescue ChessBoard::MoveIntoCheckError
        puts "That puts you in check! Try again!"
        retry
      rescue ChessBoard::BadMoveError
        puts "There's no piece there. Try again!"
        retry
      rescue ChessBoard::StartPositionError
        puts "There's no piece in the first position!"
        puts "Try again!"
        retry
      end

      self.current_player = (current_player == :white ? :black : :white)
      break if chess_board.checkmate?(current_player)
      break if chess_board.draw?(current_player)
    end

  end

  def to_s
    self.chess_board.to_s
  end

  protected

  attr_accessor :current_player

end

if $PROGRAM_NAME == __FILE__
  #debugger
  game = Game.new
  game.play_game
  #game.game_turn
  p game
end