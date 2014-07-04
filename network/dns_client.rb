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
    print "\e[33mCLIENT > \e[0m"
    begin
      domain = $stdin.gets.chomp
      @socket.send domain, 0
      result = @socket.recvfrom(UDP_SOCK_SIZE).first.chomp
      puts "\e[34mSERVER > \e[0m#{result}"
    rescue Interrupt, Errno::EPIPE, NoMethodError
      @socket.close
      exit
    end
  end
end

DnsClient.new ARGV[0], ARGV[1].to_i
