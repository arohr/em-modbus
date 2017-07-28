# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

require 'rubygems'
require 'eventmachine'

module Modbus
  module Transaction

    class Client < Base
      include EM::Deferrable


      def initialize(conn, timeout)
        super conn
        @timeout = timeout
      end


      # Try to decode a response ADU from some recevied bytes and handle the ADU if decoding was successful.
      #
      # @param buffer [String] The bytes received from the network.
      # @param conn [Modbus::Connection::TCPClient] An EM connection object to work on.
      # @return [true, false] True, if there where enough bytes in the buffer and decoding was successful.
      #
      def self.recv_adu(buffer, conn)
        adu = Modbus::TCPADU.new

        if adu.decode :response, buffer, conn
          transaction = conn.pick_pending_transaction adu.transaction_ident
          fail ClientError, "Transaction ident #{adu.transaction_ident} not found!" unless transaction
          transaction.handle_response adu
          return true
        else
          return false
        end
      end


      # Sends a request for the modbus function "read input status" asynchronusly. This method is non-blocking.
      #
      # @param start_addr [Integer] The starting modbus register address to read registers from.
      # @param bit_count [Integer] The number of input bits to read.
      #
      def read_input_status(start_addr, bit_count)
        pdu            = PDU::ReadInputStatusRequest.new
        pdu.start_addr = start_addr
        pdu.bit_count  = bit_count

        send_pdu pdu
      end


      # Sends a request for the modbus function "read holding registers" asynchronusly. This method is non-blocking.
      #
      # @param start_addr [Integer] The starting modbus register address to read registers from.
      # @param reg_count [Integer] The number of registers to read.
      #
      def read_holding_registers(start_addr, reg_count)
        pdu            = PDU::ReadHoldingRegistersRequest.new
        pdu.start_addr = start_addr
        pdu.reg_count  = reg_count

        send_pdu pdu
      end


      # Sends a request for the modbus function "write mutliple registers" asynchronusly. This method is non-blocking.
      #
      # @param start_addr [Integer] The starting modbus register address to read registers from.
      # @param reg_values [Integer] The register values to write.
      #
      def write_multiple_registers(start_addr, reg_values)
        pdu            = PDU::WriteMultipleRegistersRequest.new
        pdu.start_addr = start_addr
        pdu.reg_values = reg_values

        send_pdu pdu
      end


      # Constructs a ADU using a PDU and send it asynchronusly to the server.
      # The created ADU is stored internally and is matched to the response when the response is available.
      #
      # @param pdu [Modbus::PDU] The PDU to send.
      # @return [Modbus::TCPADU] The sent ADU.
      #
      def send_pdu(pdu)
        @request_adu = TCPADU.new pdu, @conn.next_transaction_ident
        @conn.track_transaction self
        @conn.send_data @request_adu.encode

        @timeout_timer = EM.add_timer @timeout do
          @conn.pick_pending_transaction @request_adu.transaction_ident
          set_deferred_failure "Timeout #{@timeout}s expired"
        end

        self
      end


      # Handles a recevied ADU and calls the relevant callback.
      # The corresponding request ADU is matched and cleaned up.
      #
      # @param adu [Modbus::ADU] The ADU to handle.
      #
      def handle_response(adu)
        @response_adu = adu
        fail Modbus.find_exception(@response_adu.pdu.exception_code), "Request PDU: #{@request_adu.pdu.inspect}" if @response_adu.pdu.is_a? PDU::Exception

        transaction = TRANSACTIONS.find { |t| @response_adu.pdu.is_a? t[:response] }
        fail "Unknown PDU #{@response_adu.pdu.inspect}" unless transaction
        fail "Unexpected last sent PDU: #{@request_adu.pdu.inspect}" unless @request_adu.pdu.is_a? transaction[:request]

        value = send transaction[:handler]
        EM.cancel_timer @timeout_timer
        set_deferred_success @request_adu.pdu.start_addr, value

      rescue => e
        set_deferred_failure "#{e.class} - #{e.message}"
      end


      def handle_read_input_status
        @response_adu.pdu.bit_values
      end


      def handle_read_holding_registers
        @response_adu.pdu.reg_values
      end


      def handle_write_multiple_registers
        @response_adu.pdu.reg_count
      end


      # Returns the transaction ident of this transaction which is consistent to the ident of the request PDU.
      #
      # @return [Integer] The transaction ident.
      #
      def transaction_ident
        @request_adu.transaction_ident
      end


      # Returns the duration of a transaction.
      #
      # @return [Float] Time time in seconds.
      #
      def transaction_time
        fail ClientError, 'Response ADU unknown. Can not calcluate transaction time.' unless @response_adu
        ((@response_adu.pdu.creation_time - @request_adu.pdu.creation_time) * 1000).round
      end

    end # Base

  end # Request

end # Modbus

