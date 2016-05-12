# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus
  module Transaction

    class Base


      # Initializes a new Transaction instance.
      #
      # @param conn [Modbus::Connection::TCPServer] An EM connection object to work on.
      #
      def initialize(conn)
        @conn = conn
      end

    end # Base

  end # Transaction

end # Modbus


