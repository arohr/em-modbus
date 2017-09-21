# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

require 'modbus/pdu/exception'
require 'modbus/pdu/read_bits'
require 'modbus/pdu/read_coils'
require 'modbus/pdu/read_input_status'
require 'modbus/pdu/read_registers'
require 'modbus/pdu/read_input_registers'
require 'modbus/pdu/read_holding_registers'
require 'modbus/pdu/write_multiple_registers'
require 'modbus/pdu/write_single_coil'

module Modbus


  # Base class modelling a Modbus PDU (Protocol Data Unit)
  #
  class PDU

    # Maps the Modbus function code to the corresponding class (for request messages)
    REQ_PDU_MAP = {}
    [
      ReadCoilsRequest,
      ReadInputStatusRequest,
      ReadInputRegistersRequest,
      ReadHoldingRegistersRequest,
      WriteMultipleRegistersRequest,
      WriteSingleCoilRequest
    ].each { |klass| REQ_PDU_MAP[klass::FUNC_CODE] = klass }


    # Maps the Modbus function code to the corresponding class (for response messages)
    RSP_PDU_MAP = {}
    [
      ReadCoilsResponse,
      ReadInputStatusResponse,
      ReadInputRegistersResponse,
      ReadHoldingRegistersResponse,
      WriteMultipleRegistersResponse,
      WriteSingleCoilResponse
    ].each { |klass| RSP_PDU_MAP[klass::FUNC_CODE] = klass }


    attr_reader :creation_time, :func_code


    # Factory method for creating PDUs. Decodes a PDU from protocol data and returns a new PDU instance.
    #
    # @param type [Symbol] The type of PDU which should be created. Must be :request or :response.
    # @param func_code [Integer] The modbus function code of the PDU
    # @param data [Modbus::ProtocolData] The protocol data to decode.
    # @return [Modbus::PDU] The created PDU instance.
    #
    def self.create(type, func_code, data)
      map = { :request => REQ_PDU_MAP, :response => RSP_PDU_MAP }[type]
      fail ArgumentError, "Type is expected to be :request or :response, got #{type}" unless map

      # 0x80 is the offset in case of a modbus exception
      klass = func_code > 0x80 ? PDU::Exception : map[func_code]
      fail IllegalFunction, "Unknown function code 0x#{func_code.to_s(16)}" if klass.nil?

      klass.new data, func_code
    end


    # Initializes a new PDU instance. Decodes from protocol data if given.
    #
    # @param data [Modbus::ProtocolData] The protocol data to decode.
    # @param func_code [Fixnum] Modbus function code.
    #
    def initialize(data = nil, func_code = nil)
      @creation_time = Time.now.utc
      @func_code     = func_code || self.class::FUNC_CODE

      self.decode data if data
    end


    # Encodes a PDU into protocol data.
    #
    # @return [Modbus::ProtocolData] The protocol data representation of this object.
    #
    def encode
      data = ProtocolData.new
      data.push_byte @func_code
      data
    end

  end

end # Modbus


