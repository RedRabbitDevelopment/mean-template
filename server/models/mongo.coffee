
{host, db, username, password, port} = require('./config.json').mongo

mongoose = require 'mongoose'

auth = if username and password
  "#{username}:#{password}@"
else
  ''

module.exports = mongoose.connect "mongodb://#{auth}#{host}:#{port}/#{db}"
