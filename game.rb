class Game
  
  def initialize(decks_count = 2, jokers_count = 2)
    @players = []
    @last_winner = nil
    @deck = CardDeck.new
    @used_cards = []

    (decks_count - 1).times {
      @deck.merge(CardDeck.new)
    }

    jokers_in_deck = decks_count * 2
    jokers = @deck.cards.select {|card| card.rank == "Joker"}
    while jokers_in_deck > jokers_count
      joker_to_remove = jokers.shuffle.pop
      @deck.remove_card(joker_to_remove)
      jokers_in_deck -= 1
    end

    @deck.shuffle!
  end

  def add_to_used_cards(card)
    @used_cards << card
  end

  def available_card
    @used_cards.last
  end

  def pull_available_card
    @used_cards.pop
  end

  def add_player(name)
    max_score = @players.collect(&:score).max || 0
    @players << Player.new(name)
  end

  def start
    if players.count < 2
      return false
    else
      14.times do
        players.each do |player|
          player.add_cards(deck, 1)
        end
      end

      if @last_winner.nil?
        @last_winner = players.first
      end

      @last_winner.add_cards(deck, 1)

      return true
    end

  end

  def last_winner
    @last_winner
  end

  def visible_card
    unless @last_winner.nil?
      @last_winner.cards.last.to_s(:human)
    end
  end

  def players
    @players
  end

  def score_board
    @players.sort_by {|p| p.score }
  end

  def deck
    @deck
  end
end

