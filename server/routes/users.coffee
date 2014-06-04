
BaseController = require('./base')
Q = require 'q'
User = require '../models/user'
UserError = require('ez-ctrl').UserError
Auth = require '../models/auth'

module.exports = BaseController.extend
  name: 'User'
  routes:
    query: ->
      User.find().exec()
    getMe: ->
      @request.user
    logout: ->
      Auth.logout @request
      true
    login:
      method: 'post'
      validation:
        email:
          required: true
          type: 'text'
        password:
          type: 'text'
          required: true
      logic: (email, password)->
        User.findOne email: email
        .exec().then (user)=>
          Q.fcall ->
            if user
              Auth.compare password, user.password
            else
              false
          .then (isValid)=>
            if isValid
              Auth.login @request, user
            else
              throw new UserError 'InvalidPassword'
