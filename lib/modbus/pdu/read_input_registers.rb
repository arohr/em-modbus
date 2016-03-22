# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus

  class PDU

    # PDU for modbus function "read input register" (request message)
    #
    class ReadInputRegistersRequest < ReadRegistersRequest
      FUNC_CODE = 0x04
    end


    # PDU for modbus function "read input register" (response message)
    #
    class ReadInputRegistersResponse < ReadRegistersResponse
      FUNC_CODE = 0x04
    end

  end

end # Modbus


