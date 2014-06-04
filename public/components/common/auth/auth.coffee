
angular.module('auth')
.factory('Auth', [
    '$rootScope'
    'EZAccess'
    'AuthConfig'
  ($rootScope, EZAccess, AuthConfig)->
    changeEventName: '$loginChangeEvent'
    initialize: (config)->
      @loading = @onload = EZAccess.User.getMe().then (user)=>
        delete @loading
        @setUser user, config
    register: (data, config)->
      EZAccess.User.add(data)
      .then (user)=>
        @setUser user, config
    login: (data, config)->
      config = AuthConfig.getConfig config
      EZAccess.User.login(data[config.authBy], data.password)
      .then (user)=>
        @setUser user, config
    loginWithFacebook: (accessToken, config)->
      EZAccess.User.loginWithFacebook(accessToken)
      .then (user)=>
        @setUser user, config
    setUser: (user, config)->
      @user = user
      config = AuthConfig.getConfig config
      $rootScope.$broadcast @changeEventName, user, config
      @user
    logout: (config)->
      setUser = =>
        @setUser null, config
      EZAccess.User.logout().then setUser, setUser
])

