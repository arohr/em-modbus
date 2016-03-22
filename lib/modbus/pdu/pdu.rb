# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

require 'modbus/pdu/read_registers'
require 'modbus/pdu/read_input_registers'
require 'modbus/pdu/read_holding_registers'
require 'modbus/pdu/write_multiple_registers'

module Modbus


  # Base class modelling a Modbus PDU (Protocol Data Unit)
  #
  class PDU

    # Maps the Modbus function code to the corresponding class (for request messages)
    req_PDUs = [
      ReadInputRegistersRequest,
      ReadHoldingRegistersRequest,
      WriteMultipleRegistersRequest
    ]
    REQ_PDU_MAP = Hash[req_PDUs.map { |klass| [klass::FUNC_CODE, klass] }]


    # Maps the Modbus function code to the corresponding class (for response messages)
    rsp_PDUs = [
      ReadInputRegistersResponse,
      ReadHoldingRegistersResponse,
      WriteMultipleRegistersResponse
    ]
    RSP_PDU_MAP = Hash[rsp_PDUs.map { |klass| [klass::FUNC_CODE, klass] }]


    # Modbus exception codes
    EXCEPTION_CODES = {
      0x01 => 'ILLEGAL FUNCTION',
      0x02 => 'ILLEGAL DATA ADDRESS',
      0x03 => 'ILLEGAL DATA VALUE',
      0x04 => 'SERVER DEVICE FAILURE',
      0x05 => 'ACKNOWLEDGE',
      0x06 => 'SERVER DEVICE BUSY',
      0x08 => 'MEMORY PARITY ERROR',
      0x0A => 'GATEWAY PATH UNAVAILABLE',
      0x0B => 'GATEWAY TARGET DEVICE FAILED TO RESPOND'
    }


    attr_reader :exception_code, :creation_time


    # Factory method for creating PDUs. Decodes a PDU from protocol data and returns a new PDU instance.
    #
    # @param type [Symbol] The type of PDU which should be created. Must be :request or :response.
    # @param func_code [Integer] The modbus function code of the PDU
    # @param data [Modbus::ProtocolData] The protocol data to decode.
    # @return [Modbus::PDU] The created PDU instance.
    #
    def self.create(type, func_code, data)
      map = { :request => REQ_PDU_MAP, :response => RSP_PDU_MAP }[type]
      fail ClientError, "Type is expected to be :request or :response, got #{type}" unless map

      klass = map[func_code] || map[func_code - 0x80] # 0x80 is the offset in case of a modbus exception
      fail ClientError, "Unknown function code 0x#{func_code.to_s(16)}" if klass.nil?

      klass.new(data, func_code > 0x80)
    end


    # Initializes a new PDU instance. Decodes from protocol data if given.
    #
    # @param data [Modbus::ProtocolData] The protocol data to decode.
    #
    def initialize(data = nil, is_exception = false)
      @creation_time = Time.now.utc

      return if data.nil?

      if is_exception
        @exception_code = data.shift_byte
      else
        self.decode data
      end
    end


    # Returns the modbus function code which corresponds to this object type.
    #
    # @return [Integer] The function code
    #
    def func_code
      self.class::FUNC_CODE
    end


    # Returns true if the PDU contains a modbus exception.
    #
    # @return [Integer] The modbus exception code
    #
    def has_exception?
      !@exception_code.nil?
    end


    # Returns the corresponding error message to an exception code.
    #
    # @return [String, NilClass] The error message.
    #
    def exception_info
      EXCEPTION_CODES[@exception_code]
    end

  end

end # Modbus


