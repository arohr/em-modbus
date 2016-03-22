# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus

  class PDU

    # Base class PDU for modbus function "read holding register" (request message)
    #
    class ReadRegistersRequest < PDU
      attr_accessor :start_addr, :reg_count


      # Initializes a new PDU instance. Decodes from protocol data if given.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def initialize(data = nil, is_exception = false)
        @start_addr = 0
        @reg_count  = 0
        super
      end


      # Decodes a PDU from protocol data.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def decode(data)
        @start_addr = data.shift_word
        @reg_count  = data.shift_word
      end


      # Encodes a PDU into protocol data.
      #
      # @return [Modbus::ProtocolData] The protocol data representation of this object.
      #
      def encode
        data = ProtocolData.new
        data.push_byte func_code
        data.push_word @start_addr
        data.push_word @reg_count
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
        fail ClientError, "Register count must be in (1..127), got '#{@reg_count.inspect}'" unless (1..127).include?(@reg_count)
      end

    end


    # PDU for modbus function "read holding register" (response message)
    #
    class ReadRegistersResponse < PDU
      attr_accessor :reg_values


      # Initializes a new PDU instance. Decodes from protocol data if given.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def initialize(data = nil, is_exception = false)
        @reg_values = []
        super
      end


      # Decodes a PDU from protocol data.
      #
      # @param data [Modbus::ProtocolData] The protocol data to decode.
      #
      def decode(data)
        byte_count = data.shift_byte
        byte_count.div(2).times { @reg_values.push data.shift_word }
      end


      # Encodes a PDU into protocol data.
      #
      # @return [Modbus::ProtocolData] The protocol data representation of this object.
      #
      def encode
        data = ProtocolData.new
        data.push_byte func_code
        data.push_byte byte_count
        @reg_values.each { |value| data.push_word value }
        data
      end


      # Returns the length of the register values in bytes.
      #
      # @return [Integer] The length.
      #
      def byte_count
        @reg_values.size * 2
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


