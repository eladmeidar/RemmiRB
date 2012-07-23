class FlushSeries < Series

  def initialize(player, selector)
    super(player, selector)
  end

  def validate!
    align!
    if @cards.collect { |card| card.rank }.uniq.size > 1
      if @cards.select {|card| card.rank == "Joker"}.size > 1
        raise Series::Exceptions::TooManyJokers, "Too many jokers in a flush series. you can use only 1"
      elsif @cards.select {|card| card.rank == "Joker"}.size == 0
        raise Series::Exceptions::NotAFlush, "Not a flush series"
      end
    elsif suit_occurances.any? {|suit, count| count > 1}
      raise Series::Exceptions::NotAFlush, "some suits appear more than once."
    end
  end

  def suit_occurances
    @cards.inject(Hash.new(0)) { |h,v| h[v.suit_name] += 1; h }
  end
end