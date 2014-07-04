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
      begin
        send
        receve
      rescue Interrupt, Errno::EPIPE, NoMethodError
        @socket.close
        exit
      end
    }
  end

  def send
    print "\e[31mCLIENT > \e[0m"
    context = $stdin.gets.chomp
    @socket.puts context
  end

  def receve
    result = @socket.gets.chomp
    puts "\e[32mSERVER > \e[0m#{result}"
  end
end

IrbClient.new ARGV[0], ARGV[1].to_i
