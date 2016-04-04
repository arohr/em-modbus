# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

require 'uri'

module Modbus

  class Server
    attr_reader :registers


    def initialize(uri, handler)
      @uri       = URI uri
      @handler   = handler
      @registers = {}
    end


    def add_register(addr, handler = nil)
      reg_addr, bit = addr.split('.')
      reg_addr = reg_addr.to_i
      register_class = bit ? BitRegister : WordRegister
      reg = get_register reg_addr, register_class
      reg.handler = handler
      value = bit ? false : 0
      update_register addr, value
      reg
    end


    def update_register(addr, value)
      reg_addr, bit = addr.split('.')
      reg = @registers.fetch reg_addr.to_i

      case reg
      when WordRegister
        reg.update value
      when BitRegister
        reg.update bit.to_i, value
      end
    end


    def start
      EM.start_server @uri.host, @uri.port, Modbus::Connection::TCPServer, self
    end


    def client_connected(signature)
      log.info "client connected (signature #{signature})"
    end


    def client_disconnected(signature)
      log.info "client disconnected (signature #{signature})"
    end


    def read_registers(start_addr, reg_count)
      (0..reg_count-1).map do |idx|
        addr = 40001 + start_addr + idx
        read_register addr
      end
    end


    def write_registers(start_addr, reg_values)
      reg_values.each_with_index do |value, idx|
        addr = 40001 + start_addr + idx
        write_register addr, value
      end

      reg_values.size
    end


    private


    def log
      @handler.log
    end


    def get_register(addr, klass)
      @registers[addr] ||= klass.new(addr)
    end


    def read_register(addr)
      reg = @registers.fetch addr
      reg.value

    rescue => e
      log.warn "read_register @ #{addr} failed. Error: #{e.message}, Line: #{e.backtrace.first}"
    end


    def write_register(addr, value)
      reg = @registers.fetch addr
      reg.write value

    rescue => e
      log.warn "write_register @ #{addr} failed. Error: #{e.message}, Line: #{e.backtrace.first}"
    end

  end

end
