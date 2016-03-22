# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

module Modbus
  module Connection

    class TCPServer < Base


      def post_init
        @adapter.client_connected signature
      end


      def unbind
        @adapter.client_disconnected signature
      end


      def read_registers(start_addr, reg_count)
        @adapter.read_registers start_addr, reg_count
      end


      def write_registers(start_addr, reg_values)
        @adapter.write_registers start_addr, reg_values
      end


      private


      def transaction_class
        Modbus::Transaction::Server
      end

    end # TCPServer

  end # Connection
end # Modbus
