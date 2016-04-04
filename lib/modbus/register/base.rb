# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.



module Modbus

  class Register
    attr_reader :addr
    attr_accessor :handler


    def initialize(addr)
      @addr = addr
    end

  end

end
