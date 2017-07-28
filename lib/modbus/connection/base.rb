# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

module Modbus
  module Connection

    class Base < EM::Connection


      def initialize(handler)
        @handler = handler
        reset_buffer
      end


      def receive_data(data)
        @buffer << data
        analyze_buffer

      rescue => e
        # TODO log exception
        # puts e.message
        reset_buffer
      end


      def reset_buffer
        @buffer = String.new
      end


      def analyze_buffer
        success = transaction_class.recv_adu @buffer, self
        analyze_buffer if success && !@buffer.empty?
      end


    end # Base

  end # Connection
end # Modbus
