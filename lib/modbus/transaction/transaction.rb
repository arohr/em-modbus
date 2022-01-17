# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

require 'modbus/transaction/base'
require 'modbus/transaction/client'
require 'modbus/transaction/server'

module Modbus
  module Transaction

    # Valid transactions (messages) and value handler config
    TRANSACTIONS = [
      {
        :request  => PDU::ReadCoilsRequest,
        :response => PDU::ReadCoilsResponse,
        :handler  => :handle_read_coils
      },
      {
        :request  => PDU::ReadInputStatusRequest,
        :response => PDU::ReadInputStatusResponse,
        :handler  => :handle_read_input_status
      },
      {
        :request  => PDU::ReadInputRegistersRequest,
        :response => PDU::ReadInputRegistersResponse,
        :handler  => :handle_read_input_registers
      },
      {
        :request  => PDU::ReadHoldingRegistersRequest,
        :response => PDU::ReadHoldingRegistersResponse,
        :handler  => :handle_read_holding_registers
      },
      {
        :request  => PDU::WriteMultipleRegistersRequest,
        :response => PDU::WriteMultipleRegistersResponse,
        :handler  => :handle_write_multiple_registers
      },
      {
        :request  => PDU::WriteSingleCoilRequest,
        :response => PDU::WriteSingleCoilResponse,
        :handler  => :handle_write_single_coil
      }
    ]

  end # Transaction

end # Modbus


