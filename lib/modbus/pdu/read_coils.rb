# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


module Modbus

  class PDU

    # PDU for modbus function "read coils" (request message)
    #
    class ReadCoilsRequest < ReadBitsRequest
      FUNC_CODE = 0x01
    end


    # PDU for modbus function "read coils" (response message)
    #
    class ReadCoilsResponse < ReadBitsResponse
      FUNC_CODE = 0x01
    end

  end

end # Modbus


