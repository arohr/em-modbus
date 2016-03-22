# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus
  module Transaction

    class Base

      # Valid transactions (messages) and value handler config
      TRANSACTIONS = [
        {
          :request  => PDU::ReadInputRegistersRequest,
          :response => PDU::ReadInputRegistersResponse,
          :handler  => :handle_read_input_registers
        },
        {
          :request  => PDU::ReadHoldingRegistersRequest,
          :response => PDU::ReadHoldingRegistersResponse,
          :handler  => :handle_read_holding_registers
        },
        {
          :request  => PDU::WriteMultipleRegistersRequest,
          :response => PDU::WriteMultipleRegistersResponse,
          :handler  => :handle_write_multiple_registers
        }
      ]


      # Initializes a new Transaction instance.
      #
      # @param conn [Roadster::Adapters::Connections::ModbusTCPClientConnection] A EM connection object to work on.
      #
      def initialize(conn)
        @conn = conn
      end

    end # Base

  end # Transaction

end # Modbus


