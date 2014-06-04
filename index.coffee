
server = require './build/server'

server.start().then (port)->
  console.log 'listening on port ' + port
.done()
