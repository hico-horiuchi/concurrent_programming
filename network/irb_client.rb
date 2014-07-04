#!/usr/local/bin/ruby

require 'socket'

class IrbClient
  def initialize( ip, port )
    @socket = TCPSocket.open ip, port
    run
  end

  private

  def run
    loop {
      print "\e[31mCLIENT > \e[0m"
      begin
        context = $stdin.gets.chomp
        @socket.puts context
        result = @socket.gets.chomp
        puts "\e[32mSERVER > \e[0m#{result}"
      rescue Interrupt, Errno::EPIPE, NoMethodError
        @socket.close
        exit
      end
    }
  end
end

IrbClient.new ARGV[0], ARGV[1].to_i
