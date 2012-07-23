class CardDeck

  def initialize
    create_deck
  end

  def add_card(card)
    @cards << card
  end

  def shuffle!
    @cards = @cards.shuffle
  end

  def cards
    @cards
  end

  def merge(other_deck)
    @cards += other_deck.cards
  end

  def empty?
    @cards.empty?
  end

  def draw!
    @cards.pop
  end

  def remove_card(card)
    @cards.delete(@cards.index(card))
  end

  def inspect
    "<CardDeck: #{@cards.count} cards>"
  end

  protected

  def create_deck
    @cards = []
    ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"].each do |identifier|
      Card::SUITS.each do |suit|
        value = (identifier.to_i.to_s == identifier ? identifier.to_i : 10)
        if identifier == "A"
          value = 11
        end

        add_card(Card.new(suit, identifier, value))
      end
    end

    2.times do
      add_card(Card.new(Card::JOKER, Card::JOKER, 11))
    end
  end
end


class Card

  SPADE_SUIT = "♠"
  CLUB_SUIT = "♣"
  DIAMOND_SUIT = "♦"
  HEARTS_SUIT = "♥"
  
  JOKER = "☺"

  SORT_VALUES = {"J" => "11", "Q" => "12", "K" => "13", "A" => "14", Card::JOKER => "15"}

  SUITS = [SPADE_SUIT, CLUB_SUIT, DIAMOND_SUIT, HEARTS_SUIT]

  def initialize(suit = nil, identifier = nil, value = nil)
    @suit = suit
    @identifier = identifier
    @value = value
    @sort_value = get_sort_value
  end

  def sort_value
    @sort_value
  end

  def get_sort_value
    prefix = case @identifier
    when "2".."9"
      "0#{@identifier}"
    when "10"
      @identifier
    when "J", "Q", "K", "A", Card::JOKER
      SORT_VALUES[@identifier]
    end

    suffix = suit_name[0].chr
    "#{prefix}#{suffix}"
  end

  def suit_name
    case @suit
    when Card::SPADE_SUIT
      "Spades"
    when Card::CLUB_SUIT
      "Clubs"
    when Card::DIAMOND_SUIT
      "Diamonds"
    when Card::HEARTS_SUIT
      "Hearts"
    when Card::JOKER
      "Jokers"
    end
  end

  def inspect
    "<Card: #{to_s}>"
  end
  def rank
    case @identifier
    when "J"
      "Jack"
    when "Q"
      "Queen"
    when "K"
      "King"
    when "A"
      "Ace"
    when Card::JOKER
      "Joker"
    else
      @identifier
    end
  end

  def to_s(type = :plain)
    if type == :human
      "#{rank} of #{suit_name}"
    else
      "#{@identifier}#{@suit}"
    end
  end

  def to_i
    value
  end

  def value
    @value
  end
end
