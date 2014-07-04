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
        Thread.start( @server.recvfrom UDP_SOCK_SIZE ) do | client |
          domain = client[0].chomp
          send_ip = client[1][2]
          send_port = client[1][1]
          puts "[#{send_ip}:#{send_port}] #{domain}"
          result = resolv_domain domain
          @server.send result, 0, send_ip, send_port
        end
      rescue Interrupt
        @server.close
        exit
      end
    }
  end

  def resolv_domain( domain )
    begin
      Resolv.getaddress domain
    rescue Resolv::ResolvError
      "no address for #{domain}"
    end
  end
end

DnsServer.new ARGV[0], ARGV[1].to_i
