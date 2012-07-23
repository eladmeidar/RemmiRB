class Hand
  
  def initialize(deck, amount_to_get = 3)
    @cards = []
    @sticked = false
    draw_cards(deck, amount_to_get)
  end

  def draw_cards(deck, amount_to_get)
    amount_to_get.times {
      @cards << deck.draw!
    }
  end

  def sticked!
    @sticked = true
  end

  def sticked?
    @sticked == true
  end

  def cards_in_hand
    @string = "[ "
    @string += @cards.collect { |c| "(#{@cards.index(c)}) #{c.to_s}" }.join(" - ")
    @string += "]"
  end

  def cards
    @cards
  end

  def build
    @cards = @cards.sort_by {|card| card.sort_value }
  end

  def drop_card_at(index)
    @cards.delete_at(index)
  end

  def move_card(from, to)
    if from < @cards.size && to < @cards.size
      @cards.insert(to, @cards.delete_at(from))
    end
  end
end