# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus
  module Transaction

    class Base


      # Offsets for Modbus object numbering model
      NUMBER_OFFSETS = {
        coils:             00001,
        input_status:      10001,
        input_registers:   30001,
        holding_registers: 40001
      }.freeze


      # Initializes a new Transaction instance.
      #
      # @param conn [Modbus::Connection::TCPServer] An EM connection object to work on.
      #
      def initialize(conn)
        @conn = conn
      end


      def address_to_number(table, address)
        NUMBER_OFFSETS.fetch(table) + address
      end


    end # Base

  end # Transaction

end # Modbus


