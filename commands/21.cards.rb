class Card
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def val
    if rank <= 10
      rank
    else
      10
    end
  end

  def char
    if rank == 1
      "A"
    elsif rank <= 9
      rank.to_s
    elsif rank == 10
      "T"
    elsif rank == 11
      "J"
    elsif rank == 12
      "Q"
    elsif rank == 13
      "K"
    else
      "?"
    end
  end

  def to_s
    "**#{char}**#{suit}"
  end

  attr_accessor :rank, :suit
end

CARDS = [
  Card.new(1, ":spades:"), Card.new(2, ":spades:"), Card.new(3, ":spades:"),
  Card.new(4, ":spades:"), Card.new(5, ":spades:"), Card.new(6, ":spades:"),
  Card.new(7, ":spades:"), Card.new(8, ":spades:"), Card.new(9, ":spades:"),
  Card.new(10, ":spades:"), Card.new(11, ":spades:"), Card.new(12, ":spades:"),
  Card.new(13, ":spades:"),
  Card.new(1, ":hearts:"), Card.new(2, ":hearts:"), Card.new(3, ":hearts:"),
  Card.new(4, ":hearts:"), Card.new(5, ":hearts:"), Card.new(6, ":hearts:"),
  Card.new(7, ":hearts:"), Card.new(8, ":hearts:"), Card.new(9, ":hearts:"),
  Card.new(10, ":hearts:"), Card.new(11, ":hearts:"), Card.new(12, ":hearts:"),
  Card.new(13, ":hearts:"),
  Card.new(1, ":diamonds:"), Card.new(2, ":diamonds:"), Card.new(3, ":diamonds:"),
  Card.new(4, ":diamonds:"), Card.new(5, ":diamonds:"), Card.new(6, ":diamonds:"),
  Card.new(7, ":diamonds:"), Card.new(8, ":diamonds:"), Card.new(9, ":diamonds:"),
  Card.new(10, ":diamonds:"), Card.new(11, ":diamonds:"), Card.new(12, ":diamonds:"),
  Card.new(13, ":diamonds:"),
  Card.new(1, ":clubs:"), Card.new(2, ":clubs:"), Card.new(3, ":clubs:"),
  Card.new(4, ":clubs:"), Card.new(5, ":clubs:"), Card.new(6, ":clubs:"),
  Card.new(7, ":clubs:"), Card.new(8, ":clubs:"), Card.new(9, ":clubs:"),
  Card.new(10, ":clubs:"), Card.new(11, ":clubs:"), Card.new(12, ":clubs:"),
  Card.new(13, ":clubs:")
] 
