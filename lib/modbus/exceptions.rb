# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus
  ClientError = Class.new StandardError
  ModbusError = Class.new StandardError

  class ModbusError < StandardError
    attr_reader :code

    def initialize(msg)
      super
      @code = self.class::CODE
    end
  end

  class IllegalFunction < ModbusError
    CODE = 0x01

    def initialize(msg = 'ILLEGAL FUNCTION')
      super
    end
  end

  class IllegalDataAddress < ModbusError
    CODE = 0x02

    def initialize(msg = 'ILLEGAL DATA ADDRESS')
      super
    end
  end

  class IllegalDataValue < ModbusError
    CODE = 0x03

    def initialize(msg = 'ILLEGAL DATA VALUE')
      super
    end
  end

  class ServerDeviceFailure < ModbusError
    CODE = 0x04

    def initialize(msg = 'SERVER DEVICE FAILURE')
      super
    end
  end

  class Acknowledge < ModbusError
    CODE = 0x05

    def initialize(msg = 'ACKNOWLEDGE')
      super
    end
  end

  class ServerDeviceBusy < ModbusError
    CODE = 0x06

    def initialize(msg = 'SERVER DEVICE BUSY')
      super
    end
  end

  class MemoryParityError < ModbusError
    CODE = 0x08

    def initialize(msg = 'MEMORY PARITY ERROR')
      super
    end
  end

  class GatewayPathUnavailable < ModbusError
    CODE = 0x0A

    def initialize(msg = 'GATEWAY PATH UNAVAILABLE')
      super
    end
  end

  class GatewayTargetDeviceFailedToRespond < ModbusError
    CODE = 0x0B

    def initialize(msg = 'GATEWAY TARGET DEVICE FAILED TO RESPOND')
      super
    end
  end

  def self.find_exception(code)
    exceptions = [
      IllegalFunction,
      IllegalDataAddress,
      IllegalDataValue,
      ServerDeviceFailure,
      Acknowledge,
      ServerDeviceBusy,
      MemoryParityError,
      GatewayPathUnavailable,
      GatewayTargetDeviceFailedToRespond
    ]

    exceptions.find { |e| e::CODE == code } || RuntimeError
  end

end
