
BaseController = require('./base')
Q = require 'q'
User = require '../models/user'
jwt = require '../models/jwt'
smtp = require '../models/smtp'
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
    save:
      validation:
        name:
          type: 'text'
          required: false
        email:
          type: 'email'
          required: false
        password:
          type: 'text'
          len: [[8]]
          required: false
        old_password:
          type: 'text'
          required: false
      logic: (_data)->
        promise = if _data.password
          Q.all [
            Auth.compare(_data.old_password, @request.user.password)
            .then (compare_result)->
              throw new UserError 'InvalidPassword' unless match
          ,
            Auth.password(_data.password).then (hash)->
              _data.password = hash
          ]
        else
          Q.when true
        promise.then (match)->
          @request.user.update(_data)
          .then ->
            @request.user
    forgotPassword:
      method: 'post'
      validation:
        email:
          type: 'email'
          required: true
      logic: (email)->
        User.findOne email: email
        .exec().then (user)=>
          if user
            oneHourLater = new Date()
            oneHourLater.setHours oneHourLater.getHours() + 1
            token = jwt.encode
              id: user.id
              expiration: oneHourLater.getTime()
            smtp.sendEmail
              to: user.email
              template: 'forgotPassword'
              subject: 'Forgot your Password?'
              data:
                name: user.name
                token: token
                host: smtp.makeHost @request
            .done()
          true
    resetPassword:
      method: 'post'
      validation:
        token:
          type: 'text'
          required: true
        password:
          type: 'text'
          len: [[8]]
          required: true
      logic: (token, password)->
        Q.fcall ->
          data = jwt.decode token
          if data.expiration < Date.now()
            throw new UserError 'ExpiredToken'
          unless data.id
            throw new UserError 'InvalidToken'
          User.findById(data.id)
          .exec().then (user)->
            unless user
              throw new UserError 'InvalidToken'
            Auth.password password
            .then (hash)->
              user.update(password: hash).exec()
            .then (user)->
              user
        .catch (e)->
          if e.message is 'Not enough or too many segments'
            throw new UserError 'InvalidToken'
          throw e

