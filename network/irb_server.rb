#!/usr/local/bin/ruby

require 'socket'

class IrbServer
  def initialize( ip, port )
    @server = TCPServer.open ip, port
    run
  end

  private

  def run
    loop {
      begin
        Thread.start( @server.accept ) do | client |
          puts "[NEW CLIENT] #{client.addr.last}"
          listen_context client
        end
      rescue Interrupt
        exit
      end
    }.join
  end

  def listen_context( client )
    loop {
      context = client.gets.chomp
      puts "[#{client.addr.last}] #{context}"
      result = eval context
      client.puts result
    }
  end
end

IrbServer.new ARGV[0], ARGV[1].to_i
