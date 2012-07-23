require 'game'
require 'card_deck'
require 'player'
require 'hand'
require 'socket'
require 'series'
require 'flush_series'
require 'straight_series'
require 'multi_client_server'

puts "*************************************************"
puts "* Welcome to Remi Server by Fiverr Tsunami Team *"
puts "*************************************************"

port = ARGV[0].nil? ? 5555 : ARGV[0].to_i
puts "-- Setting up server on port #{port}"
server = MultiClientTCPServer.new(port, 30, true )
puts "-- Server Ready"
@connections = {}
@game = Game.new
puts "-- Game created with #{@game.deck.cards.size} cards."
loop do
    puts "-- Listening..."
    if sock = server.get_socket
        # a message has arrived, it must be read from sock
        message = sock.gets( "\r\n" ).chomp( "\r\n" )
        puts "Message: '#{message.split(":").first.to_s.downcase}'"
        # arbitrary examples how to handle incoming messages:
        case message.split(":").first.to_s.downcase
        when "name"
          name = message.split(":").last
          @game.add_player(name)
          @connections[sock.peeraddr.join(':')] = {:name => name, :socket => sock}
          sock.write( "SERVER:OK\r\n" )
        when "players"
          sock.write( "#{@game.players.collect(&:name).join(', ')}\r\n" )
        when "start"
          if !(@game.start)
            @connections.values.collect {|p| p[:socket]}.each do |conn|
              conn.write( "#{@game.players.count} player(s) is not enough to start a game\r\n" )
            end
          else
            @connections.values.collect {|p| p[:socket]}.each do |conn|
              conn.write( "Starting game: turn @ #{@game.last_winner.name} - card on top => #{@game.visible_card.to_s}\r\n" )
            end
          end
        when "hand"
          me = @game.players.select {|p| p.name == @connections[sock.peeraddr.join(":")][:name]}.first
          sock.write(me.hand.cards_in_hand + "\r\n")
        when "hint"
          me = @game.players.select {|p| p.name == @connections[sock.peeraddr.join(":")][:name]}.first
          me.hand.build
          sock.write(me.hand.cards_in_hand + "\r\n")
        when "move"
          command, from, to = message.split(":")
          me = @game.players.select {|p| p.name == @connections[sock.peeraddr.join(":")][:name]}.first
          me.hand.move_card(from.to_i, to.to_i)
          sock.write(me.hand.cards_in_hand + "\r\n")
        when "drop"
          command, index = message.split(":")
          me = @game.players.select {|p| p.name == @connections[sock.peeraddr.join(":")][:name]}.first
          card_to_drop = me.hand.drop_card_at(index.to_i)
          @game.add_to_used_cards(card_to_drop)
          @connections.values.collect {|p| p[:socket]}.each do |conn|
            conn.write("#{me.name} dropped #{card_to_drop.to_s(:human)} (#{card_to_drop.to_s})\r\n")
          end
        when "down"
          command, series_type, selector = message.split(":")
          me = @game.players.select {|p| p.name == @connections[sock.peeraddr.join(":")][:name]}.first
          case series_type.downcase
          when "flush"
            begin
              series = FlushSeries.new(me, selector)
              sock.write("Flush series: #{series.cards}" + "\r\n")  
            rescue Exception => e
              sock.write("Flush series INVALID - #{e.to_s}" + "\r\n")  
            end
          when "straight"
          else
            sock.write("#{series_type} is an invalid series type, try again using 'flush' or 'straight'." + "\r\n")
          end
        when "top"
          if @game.available_card
            sock.write("Card on top is the #{@game.available_card.to_s(:human)} (#{@game.available_card.to_s})" + "\r\n")
          else
            sock.write("No cards on the table yet." + "\r\n")
          end
        when "who?"
          if @game.last_winner && @game.last_winner.name == @connections[sock.peeraddr.join(":")][:name]
            sock.write("It's your turn" + "\r\n")
          elsif @game.last_winner
            sock.write("It's #{@game.last_winner.name}'s turn" + "\r\n")
          else
            sock.write("Didn't start yet, nobody's turn." + "\r\n")
          end
        when "quit"
          exit
        else
          sock.write( "Command not found\r\n" )
        end
    else
        sleep 0.01 # free CPU for other jobs, humans won't notice this latency
    end
end
