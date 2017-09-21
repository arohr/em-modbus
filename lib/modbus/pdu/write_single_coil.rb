# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus

  class PDU

    # PDU for modbus function "read single coil" (request message)
    #
    class WriteSingleCoilRequest < PDU
      FUNC_CODE = 0x05

      attr_accessor :start_addr, :value


      # Initializes a new PDU instance. Decodes from protocol data if given.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def initialize(data = nil, func_code = nil)
        @start_addr = 0
        @value      = 0
        super
      end


      # Decodes a PDU from protocol data.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def decode(data)
        @start_addr = data.shift_word
        @value      = data.shift_word
      end


      # Encodes a PDU into protocol data.
      #
      # @return [Modbus::ProtocolData] The protocol data representation of this object.
      #
      def encode
        data = super
        data.push_word @start_addr
        data.push_word @value
        data
      end


      # Returns the length of the PDU in bytes.
      #
      # @return [Integer] The length.
      #
      def length
        5
      end


      # Validates the PDU. Raises exceptions if validation fails.
      #
      def validate
        fail ClientError, "Value must be 0x0000 or 0xFF00, got '#{@value}'" unless [0x0000, 0xFF00].include?(@value)
      end

    end


    # PDU for modbus function "read single coil" (response message)
    #
    class WriteSingleCoilResponse < WriteSingleCoilRequest
    end

  end

end # Modbus


