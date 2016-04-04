# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.



module Modbus

  class WordRegister < Register
    attr_reader :value


    def initialize(addr)
      super
      @value = 0
    end


    def update(value)
      fail ArgumentError unless (0..65535).include? value
      @value = value
    end


    def write(value)
      @handler.write_values [{:addr => @addr.to_s, :value => value}] if @handler
    end

  end

end
