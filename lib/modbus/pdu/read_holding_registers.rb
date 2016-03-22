# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus

  class PDU

    # PDU for modbus function "read holding register" (request message)
    #
    class ReadHoldingRegistersRequest < ReadRegistersRequest
      FUNC_CODE = 0x03
    end


    # PDU for modbus function "read holding register" (response message)
    #
    class ReadHoldingRegistersResponse < ReadRegistersResponse
      FUNC_CODE = 0x03
    end

  end

end # Modbus


