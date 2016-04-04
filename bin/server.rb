#!/usr/bin/env ruby

require 'logger'
$LOAD_PATH << 'lib'
require 'modbus'

trap 'INT' do
  EM.stop
end

class ServerHandler
  def log
    @log ||= Logger.new STDOUT
  end
end

class ValueHandler
  def write_values(list)
    puts "ValueHandler#write_values #{list.inspect}"
  end
end

EM.run do
  server = Modbus::Server.new 'tcp://0.0.0.0:1502', ServerHandler.new
  value_handler = ValueHandler.new
  server.add_register '40101', value_handler
  server.add_register '40102.0', value_handler
  server.add_register '40102.2', value_handler
  server.add_register '40102.4', value_handler
  server.add_register '40102.15', value_handler
  server.start

  counter = 0
  EM.add_periodic_timer(1) do
    counter += 1
    server.update_register '40101', counter
    bit_value = counter.modulo(2) == 0
    server.update_register '40102.0', bit_value
    server.update_register '40102.2', bit_value
    server.update_register '40102.4', bit_value
    server.update_register '40102.15', bit_value
  end
end
