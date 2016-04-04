# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

require 'forwardable'

module Modbus
  module Connection

    class TCPServer < Base
      extend Forwardable

      def_delegator :@handler, :read_registers,   :read_registers
      def_delegator :@handler, :write_registers,  :write_registers


      def post_init
        @handler.client_connected signature
      end


      def unbind
        @handler.client_disconnected signature
      end


      private


      def transaction_class
        Modbus::Transaction::Server
      end

    end # TCPServer

  end # Connection
end # Modbus
