# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.


require 'modbus/pdu/pdu'
require 'modbus/adu/adu'
require 'modbus/transaction/transaction'
require 'modbus/connection/connection'
require 'modbus/client'
require 'modbus/server'


module Modbus
  ClientError = Class.new StandardError
end

