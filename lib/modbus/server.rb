# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

require 'uri'

module Modbus

  class Server


    def initialize(uri)
      @uri = URI uri
    end


    def start
      EM.start_server @uri.host, @uri.port, Modbus::Connection::TCPServer, self
    end


    def client_connected(signature)
      puts "client connected (signature #{signature})"
    end


    def client_disconnected(signature)
      puts "client disconnected (signature #{signature})"
    end


    def read_registers(start_addr, reg_count)
      puts "read #{reg_count} registers from #{start_addr}"
      (1..reg_count).map { rand(2**16-1) }
    end


    def write_registers(start_addr, reg_values)
      puts "write #{reg_values.size} registers from #{start_addr}: #{reg_values.inspect}"
      reg_values.size
    end

  end

end
