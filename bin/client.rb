# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

$LOAD_PATH << 'lib'
require 'modbus'

class Client < Modbus::Client

  def poll
    transaction do |t|
      request = t.read_holding_registers 0, 10
      request.timeout 2

      request.callback do |start_addr, reg_values|
        puts "reg values @ #{start_addr}: #{reg_values.inspect}"
        schedule_next_poll
      end

      request.errback do |error|
        puts "error: #{error.inspect}"
        schedule_next_poll
      end
    end
  end

end

trap 'INT' do
  EM.stop
end

EM.run do
  client = Client.new 'tcp://192.168.56.101:502'
  client.connect
end
