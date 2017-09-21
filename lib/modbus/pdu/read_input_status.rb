# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus

  class PDU

    # PDU for modbus function "read input status" (request message)
    #
    class ReadInputStatusRequest < ReadCoilsRequest
      FUNC_CODE = 0x02
    end


    # PDU for modbus function "read input status" (response message)
    #
    class ReadInputStatusResponse < ReadBitsResponse
      FUNC_CODE = 0x02
    end

  end

end # Modbus


