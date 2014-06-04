
angular.module('auth')
.provider('AuthConfig', [ ->
  defaults =
    authorizedView: 'index'
    unauthorizedView: 'login'
    loginUrl: '/login'
    meUrl: '/users'
    translateResponse: (response)->
      response.data
  this.config = (config)->
    angular.extend defaults, config

  this.$get = ->
    getConfig: (config = {})->
      angular.extend {}, defaults, config
  this
])
