class Series
  
  module Exceptions
    class NotEnoughCards < RuntimeError; end;
    class JokersInARow < RuntimeError; end;
    class TooManyJokers < RuntimeError; end;
    class NotAFlush < RuntimeError; end;
    class NotAStraight < RuntimeError; end;
  end

  include Exceptions

  def initialize(player = nil, selector = "")
    @player = player
    @cards = select_cards(player.hand, selector)
    @valid = true
    if @cards.size < 3
      raise Series::Exceptions:NotEnoughCards, "Not enought Cards supplied."
    end
    begin
      validate!
      @valid == true
    rescue Exception => e
      @valid == false
      raise e
    end
  end

  def valid?
    @valid == true
  end

  def align!
    @cards = @cards.sort_by {|card| card.sort_value }
  end

  def player
    @player
  end

  def cards
    @string = "[ "
    @string += @cards.collect { |c| "(#{@cards.index(c)}) #{c.to_s}" }.join(" - ")
    @string += "]"
  end

  def add_card(card)
    @cards << card
    align!
  end

  def stick!(card)
    # TODO: adding to series
    # TODO: Joker replacing 
  end

  def score
    @cards.collect(&:value).sum
  end

  def validate
  end

  protected

  def select_cards(hand, selector)
    indexes_to_fetch = parse_selector(selector)
    puts "Indexes: #{indexes_to_fetch.inspect}"
    hand.cards.values_at(*indexes_to_fetch)
  end

  def parse_selector(selector = "")
    indexes = []
    clean_selectors = selector.gsub(" ", '').split(",")
    clean_selectors.each do |clean_selector|
      if clean_selector.include?("-")
        start_in, end_in = clean_selector.split("-").collect(&:to_i)
        indexes += (start_in..end_in).to_a
      else
        indexes << clean_selector.to_i
      end
    end
    indexes
  end
end