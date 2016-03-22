# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

$LOAD_PATH << 'lib'
require 'modbus'

trap 'INT' do
  EM.stop
end

EM.run do
  server = Modbus::Server.new 'tcp://0.0.0.0:1502'
  server.start
end
