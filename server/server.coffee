
express = require 'express'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
serveStatic = require 'serve-static'
session = require 'express-session'
MongoSession = require('connect-mongo')(session)
mongo = require './models/mongo'
Q = require 'q'
services = require './models/services'
app = express()

# middleware
app.use serveStatic('build/public')
app.use cookieParser()
app.use bodyParser()
app.use session
  secret: 'replace'
  store: new MongoSession
    mongoose_connection: mongo.connections[0]


# routes
frontEnd = new (require('ez-ctrl').FrontEnd)()
services.push frontEnd.registerRoutes(app, "#{__dirname}/routes")

module.exports =
  start: ->
    Q.all(services).then ->
      def = Q.defer()
      port = 3000
      app.listen port, ->
        def.resolve port
      def.promise
