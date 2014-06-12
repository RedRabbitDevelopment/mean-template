Q = require 'q'
bcrypt = require 'bcrypt-nodejs'
User = require('./user')
UserError = require('ez-ctrl').UserError
_ = require 'lodash'
SALT_WORK_FACTOR = 10

module.exports = Auth =
  login: (request, user)->
    request.session.userid = user.id
    user

  logout: (request)->
    delete request.session.userid

  setUser: ->
    if @request.session.userid
      User.findById(@request.session.userid)
      .exec().then (user)=>
        unless user
          delete @request.session.userid
        else
          @request.user = user
  
  ensureAdmin: ->
    unless @request.user and @request.user.is_admin
      throw new UserError('Unauthorized')
  
  ensureLoggedIn: ->
    unless @request.user
      throw new UserError('Unauthenticated')

  password: (password)->
    Q.ninvoke(bcrypt, 'genSalt', SALT_WORK_FACTOR).then (salt)->
      Q.ninvoke(bcrypt, 'hash', password, salt, null)

  compare: (password, hash)->
    Q.fcall ->
      return false if not password
      Q.ninvoke bcrypt, 'compare', password, hash

for method in ['ensureLoggedIn', 'ensureAdmin']
  ((method)->
    Auth[method].allow = (allowedRoutes)->
      ->
        if -1 is allowedRoutes.indexOf @route
          Auth[method].call(@)
  )(method)
  
# Example user
makeIfNotExists = (name, email, admin)->
  User.findOne email: email
  .exec().then (user)->
    unless user
      user = new User
        name: name
        email: email
        admin: admin
      Auth.password 'password'
      .then (password)->
        user.password = password
        user.save()
  .end()
makeIfNotExists('Active User', 'activeuser@gmail.com', false)
makeIfNotExists('Admin User', 'adminuser@gmail.com', true)
