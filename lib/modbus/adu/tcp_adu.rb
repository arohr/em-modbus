# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus

  # ADU (Application Data Unit) for transport over TCP
  #
  class TCPADU
    attr_accessor :transaction_ident, :protocol_ident, :unit_ident, :pdu


    # Initializes a new TCPADU instance.
    #
    # @param pdu [Modbus::PDU] A PDU to preset in the ADU.
    #
    def initialize(pdu = nil, transaction_ident = 0)
      @transaction_ident = transaction_ident
      @protocol_ident    = 0
      @unit_ident        = 1
      @pdu               = pdu
    end


    # Encodes the ADU into the wire format.
    #
    # @return [String] The encoded ADU.
    #
    def encode
      data = ProtocolData.new
      data.push_word @transaction_ident
      data.push_word @protocol_ident
      data.push_word @pdu.length + 1
      data.push_byte @unit_ident
      data.concat @pdu.encode
      data.to_buffer
    end


    # Decodes an ADU from wire format and sets the attributes of this object.
    #
    # @param type [Symbol] The type of PDU which should be created.
    # @param buffer [String] The bytes to decode.
    # @return [true, false] True, if there where enough bytes in the buffer and decoding was successful.
    #
    def decode(type, buffer)
      data = ProtocolData.new buffer

      # not enough data in buffer to know the length
      return false if data.size < 6

      @transaction_ident = data.shift_word
      @protocol_ident    = data.shift_word
      length             = data.shift_word

      # not enough data in buffer according to length
      return false if data.size < length

      @unit_ident = data.shift_byte
      func_code   = data.shift_byte
      @pdu        = PDU.create type, func_code, data

      # Strip the consumed bytes off the buffer, thus NOT consumed bytes remain in the buffer!
      buffer.slice!(0..self.length - 1)

      return true
    end


    # Returns the length of the remaining length of the ADU in bytes (= length of the ADU - 6 bytes)
    # Used for the length field in the modbus protocol.
    #
    # @return [Integer] The length in bytes.
    #
    def length
      @pdu.length + 7
    end


  end

end # Modbus


