#!/usr/local/bin/ruby

require 'socket'

class DnsClient
  UDP_SOCK_SIZE = 65536

  def initialize( ip, port )
    @socket = UDPSocket.new
    @socket.connect ip, port
    run
  end

  private

  def run
    begin
      send
      receve
    rescue Interrupt
      @socket.close
      exit
    end
  end

  def send
    print "\e[33mCLIENT > \e[0m"
    domain = $stdin.gets.chomp
    @socket.send domain, 0
  end

  def receve
    result = @socket.recvfrom(UDP_SOCK_SIZE).first.chomp
    puts "\e[34mSERVER > \e[0m#{result}"
  end
end

DnsClient.new ARGV[0], ARGV[1].to_i
