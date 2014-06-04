
Auth = require '../models/auth'
BaseController = require('ez-ctrl').BaseController

BaseController.prototype.logError = (error)->
  console.log "SERVER ERROR", error, error?.stack

module.exports = BaseController.extend
  isAbstract: true
  beforeEach: Auth.setUser
