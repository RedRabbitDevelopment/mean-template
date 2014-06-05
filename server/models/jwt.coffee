
jwt = require 'jwt-simple'

secret = require('./config.json').server.jwt_secret

module.exports =
  encode: (data)->
    jwt.encode data, secret
  decode: (token)->
    jwt.decode token, secret
