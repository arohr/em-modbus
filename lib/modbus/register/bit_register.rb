# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.



module Modbus

  class BitRegister < Register

    def initialize(addr)
      super
      @bits = {}
    end


    def update(bit, value)
      fail ArgumentError unless (0..15).include? bit
      fail ArgumentError unless [true, false].include? value
      @bits[bit] = value
    end


    def value
      result = 0

      @bits.each do |bit, bit_value|
        value = bit_value ? 1 : 0
        result |= (value << bit)
      end

      result
    end


    def write(value)
      return unless @handler

      values = @bits.keys.map do |bit|
        bit_value = value[bit] == 1
        {:addr => [@addr, bit].join('.'), :value => bit_value}
      end

      @handler.write_values values
    end

  end


end
