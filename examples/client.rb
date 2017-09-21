#!/usr/bin/env ruby

$LOAD_PATH << 'lib'
require 'modbus'

class Client < Modbus::Client

  def poll
    # transaction do |t|
    #   request = t.read_holding_registers 0, 1
    #
    #   request.callback do |start_addr, reg_values|
    #     puts "reg values @ #{start_addr}: #{reg_values.inspect}"
    #     schedule_next_poll
    #   end
    #
    #   request.errback do |error|
    #     puts "error: #{error.inspect}"
    #     schedule_next_poll
    #   end
    # end

    transaction do |t|
      request = t.read_input_status 0, 32

      request.callback do |start_addr, bit_values|
        puts "bit values @ #{start_addr}: #{bit_values.inspect}"
        schedule_next_poll
      end

      request.errback do |error|
        puts "error: #{error.inspect}"
        schedule_next_poll
      end
    end


    # transaction do |t|
    #   request = t.read_coils 0, 32
    #
    #   request.callback do |start_addr, bit_values|
    #     puts "bit values @ #{start_addr}: #{bit_values.inspect}"
    #     schedule_next_poll
    #   end
    #
    #   request.errback do |error|
    #     puts "error: #{error.inspect}"
    #     schedule_next_poll
    #   end
    # end

    # @addr ||= 0
    # @addr = @addr.next
    #
    # transaction do |t|
    #   request = t.write_single_coil @addr, 0xFF00
    #
    #   request.callback do |start_addr, value|
    #     puts "Write successful: #{start_addr} 0x#{value.to_s(16)}"
    #     schedule_next_poll
    #   end
    #
    #   request.errback do |error|
    #     puts "error: #{error.inspect}"
    #     schedule_next_poll
    #   end
    # end
  end

end

trap 'INT' do
  EM.stop
end

EM.run do
  # client = Client.new 'tcp://localhost:1502'
  client = Client.new 'tcp://192.168.56.101:502'
  client.connect
end
