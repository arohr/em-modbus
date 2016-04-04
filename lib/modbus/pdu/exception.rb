# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus

  class PDU

    # PDU for modbus exception (response message)
    #
    class Exception < PDU
      attr_accessor :exception_code


      def self.create(func_code, error)
        obj = self.new nil, func_code + 0x80
        obj.exception_code = error.code
        obj
      end


      # Decodes a PDU from protocol data.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def decode(data)
        @exception_code = data.shift_byte
      end


      # Encodes a PDU into protocol data.
      #
      # @return [Modbus::ProtocolData] The protocol data representation of this object.
      #
      def encode
        data = super
        data.push_byte @exception_code
        data
      end


      # Returns the length of the PDU in bytes.
      #
      # @return [Integer] The length.
      #
      def length
        2
      end

    end

  end

end # Modbus


