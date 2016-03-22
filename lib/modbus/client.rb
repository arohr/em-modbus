# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

require 'uri'

module Modbus

  class Client


    def initialize(uri)
      @base_polling_interval = 1
      @last_poll_time        = Time.now
      @uri                   = URI uri
    end


    def connected(conn)
      puts 'connected'
      @conn = conn
      schedule_next_poll
    end


    def disconnected
      puts 'disconnected'
      reconnect
    end


    def connect
      EM.connect @uri.host, @uri.port, Modbus::Connection::TCPClient, self
    end


    private


    def reconnect
      EM.add_timer(5) { connect }
    end


    def schedule_next_poll
      poll_time      = Time.now - @last_poll_time
      next_poll_time = [@base_polling_interval - poll_time, @base_polling_interval*0.25].max

      EM.add_timer(next_poll_time) do
        @last_poll_time = Time.now
        poll
      end
    end


    def poll
      # no-op
    end


    def transaction
      yield Modbus::Transaction::Client.new @conn
    end

  end

end
