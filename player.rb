class Player
  def initialize(name, score = 0)
    @name = name
    @score = score
    @hand = nil
  end

  def inspect
    if @hand.nil?
      "<Player: #{name}>"
    else
      "<Player: #{name} #{@hand.cards_in_hand}>"
    end
  end

  def name
    @name
  end

  def score
    @score
  end

  def hand
    @hand
  end

  def cards
    if @hand.nil?
      []
    else
      @hand.cards
    end
  end

  def add_cards(deck, amount_to_add = 3)
    if @hand.nil?
      @hand = Hand.new(deck, amount_to_add)
    else
      @hand.draw_cards(deck, amount_to_add)
    end
  end
end