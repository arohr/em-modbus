# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus

  class PDU

    # PDU for modbus function "read input status" (request message)
    #
    class ReadInputStatusRequest < PDU
      FUNC_CODE = 0x02
      
      attr_accessor :start_addr, :bit_count


      # Initializes a new PDU instance. Decodes from protocol data if given.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def initialize(data = nil, func_code = nil)
        @start_addr = 0
        @bit_count  = 0
        super
      end


      # Decodes a PDU from protocol data.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def decode(data)
        @start_addr = data.shift_word
        @bit_count  = data.shift_word
      end


      # Encodes a PDU into protocol data.
      #
      # @return [Modbus::ProtocolData] The protocol data representation of this object.
      #
      def encode
        data = super
        data.push_word @start_addr
        data.push_word @bit_count
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
        fail ClientError, "Register count must be in (1..127), got '#{@bit_count.inspect}'" unless (1..127).include?(@bit_count)
      end

    end


    # PDU for modbus function "read input status" (response message)
    #
    class ReadInputStatusResponse < PDU
      FUNC_CODE = 0x02

      attr_accessor :bit_values


      # Initializes a new PDU instance. Decodes from protocol data if given.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def initialize(data = nil, func_code = nil)
        @bit_values = []
        super
      end


      # Decodes a PDU from protocol data.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def decode(data)
        byte_count = data.shift_byte
        byte_count.times do
          byte = data.shift_byte

          8.times do |bit|
            @bit_values.push byte[bit] == 1
          end
        end
      end


      # Encodes a PDU into protocol data.
      #
      # @return [Modbus::ProtocolData] The protocol data representation of this object.
      #
      def encode
        data = super
        data.push_byte byte_count
        @bit_values.each do |value|
          data.push_byte value
        end
        data
      end


      # Returns the length of the register values in bytes.
      #
      # @return [Integer] The length.
      #
      def byte_count
        @bit_values.size
      end


      # Returns the length of the PDU in bytes.
      #
      # @return [Integer] The length.
      #
      def length
        # +1 for func_code, +1 for byte_count
        byte_count + 2
      end


      # Validates the PDU. Raises exceptions if validation fails.
      #
      def validate

      end

    end

  end

end # Modbus


