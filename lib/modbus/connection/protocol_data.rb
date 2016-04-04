# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus


  # Helper class for dealing with the modbus wire format.
  #
  class ProtocolData < ::Array


    # Initializes a new ProtocolData instance. Unpacks a buffer string if given.
    #
    # @param buffer [String, Array] The buffer data. If it's a String, it's automatically unpacked.
    #
    def initialize(buffer = nil)
      case buffer
      when String
        super buffer.unpack('C*')
      when Array
        super buffer
      end
    end


    # Shifts two bytes off the from front of the array and interprets them as a word (network byte order).
    #
    # @return [Integer, NilClass] The shifted word or nil if there are not enough bytes.
    #
    def shift_word
      return nil if size < 2
      # self.shift(2).pack('C2').unpack('n').first
      self.slice!(0,2).pack('C2').unpack('n').first
    end


    # Interprets a value as a word (network byte order) and pushes two bytes to the end of the array.
    #
    # @param word [Integer] The value to push.
    #
    def push_word(word)
      self.concat [word].pack('n').unpack('C2')
    end


    # Shifts one bytes off the from front of the array.
    #
    # @return [Integer] The shifted byte.
    #
    def shift_byte
      # self.shift
      self.slice!(0,1).first
    end


    # Interprets a value as a byte (network byte order) and pushes the byte to the end of the array.
    #
    # @param byte [Integer] The value to push.
    #
    def push_byte(byte)
      self.concat [byte].pack('C').unpack('C')
    end


    # Converts the array data into a string.
    #
    # @return [String] The data string (frozen).
    #
    def to_buffer
      self.pack('C*').freeze
    end

  end

end # Modbus


