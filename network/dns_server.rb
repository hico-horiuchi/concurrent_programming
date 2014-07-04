#!/usr/local/bin/ruby

require 'socket'
require 'resolv'

class DnsServer
  UDP_SOCK_SIZE = 65536

  def initialize( ip, port )
    @server = UDPSocket.new
    @server.bind ip, port
    run
  end

  private

  def run
    loop {
      begin
        recv = @server.recvfrom UDP_SOCK_SIZE
        domain = recv[0].chomp
        send_ip = recv[1][2]
        send_port = recv[1][1]
        puts "[#{send_ip}:#{send_port}] #{domain}"
        begin
          result = Resolv.getaddress domain
        rescue Resolv::ResolvError
          result = "no address for #{domain}"
        end
        @server.send result, 0, send_ip, send_port
      rescue Interrupt
        @server.close
        exit
      end
    }
  end
end

DnsServer.new ARGV[0], ARGV[1].to_i
