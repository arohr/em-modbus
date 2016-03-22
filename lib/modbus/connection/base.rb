# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

module Modbus
  module Connection

    class Base < EM::Connection


      def initialize(adapter)
        @adapter = adapter
        @buffer  = String.new
      end


      def receive_data(data)
        @buffer << data
        analyze_buffer
      end


      def analyze_buffer
        success = transaction_class.recv_adu @buffer, self
        analyze_buffer if success && !@buffer.empty?
      end


    end # Base

  end # Connection
end # Modbus
