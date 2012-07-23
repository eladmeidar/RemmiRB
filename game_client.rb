require 'player'
require 'card_deck'
require 'hand'
require 'socket'
require 'timeout'

server = ARGV[0].nil? ? "127.0.0.1" : ARGV[0]
port = ARGV[1].nil? ? 5555 : ARGV[1].to_i
name = ARGV[2].nil? ? "Player#{rand(999)}" : ARGV[2]

puts "*************************************************"
puts "* Welcome to Remi Server by Fiverr Tsunami Team *"
puts "*************************************************"

puts "-- Connecting to #{server}:#{port}"
sock = begin
           Timeout::timeout( 15 ) { TCPSocket.open( server, port ) }
       rescue StandardError, RuntimeError => ex
           raise "cannot connect to server: #{ex}"
       end
puts "-- Connected"
# send sample messages:
puts "-- Using name: '#{name}'"
# sock.write( "NAME: #{name}\r\n" )
# sleep( 2 )

# puts "sending a request that should be answered"
sock.write( "NAME:#{name}\r\n" )
response = begin
               Timeout::timeout( 15 ) { sock.gets( "\r\n" ).chomp( "\r\n" ) }
           rescue StandardError, RuntimeError, Timeout::Error => ex
               puts "-- no response from server: #{ex}"
               exit
           end
if response == "SERVER:OK"
  puts "-- Player registered"
else
  puts "Server replied with #{response}, exiting"
  exit
end
sleep( 2 )

while !(sock.closed?)
  print "$> "
  input = $stdin.gets.chomp
  begin
    response = Timeout::timeout( 1 ) { sock.gets( "\r\n" ).chomp( "\r\n" ) }
    puts response
  rescue StandardError, RuntimeError, Timeout::Error => ex
    # Do nothing - just read pending messages if there are any
  end
  puts "-- Executing: #{input}"
  sock.write( input + "\r\n" )
  response =   begin
                  Timeout::timeout( 1 ) { sock.gets( "\r\n" ).chomp( "\r\n" ) }
                  
               rescue StandardError, RuntimeError, Timeout::Error => ex
                   puts "no response from server: #{ex}"
                   exit
               end
  puts response
end
