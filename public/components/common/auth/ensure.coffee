
angular.module 'auth'
.run(['$rootScope', 'Ensure', ($rootScope, Ensure)->
  $rootScope.$on '$stateChangeStart', (event, toState, toParams)->
    overridden = if toState.data?.ensure
      switch toState.data.ensure
        when 'loggedIn'
          Ensure.ensureLoggedIn()
        when 'loggedOut'
          Ensure.ensureLoggedOut()
        else
          Ensure.ensureState(toState.data.ensure)
    else
      Ensure.ensureNothing()
    event.preventDefault() if overridden
  $rootScope.$on '$loginChangeEvent', (event, user, config)->
    Ensure.ensureCallback? user, config
])
.provider('Ensure', [ ->
  desiredStates =
    loggedIn:
      check: ['user', (user)->
        user?
      ]
      goTo: ['config', (config)->
        config['unauthorizedView']
      ]
      info: error: 'Unauthenticated'
    loggedOut:
      check: ['user', (user)->
        not user?
      ]
      goTo: ['config', (config)->
        config['authorizedView']
      ]
  this.addState = (state, fn)->
    desiredStates[state] = fn
  this.$get = [
    '$state'
    'AuthConfig'
    'Auth'
    '$injector'
  ($state, AuthConfig, Auth, $injector)->
    ensureLoggedIn: (config)->
      @ensureState 'loggedIn', config
    ensureLoggedOut: (config)->
      @ensureState 'loggedOut', config
    ensureNothing: ->
      @ensureCallback = null
    ensureState: (desiredState, config)->
      @ensureCallback = (user, config)=>
        config = AuthConfig.getConfig config
        if state = desiredStates[desiredState]
          if state.inherits
            unless _.isArray state.inherits
              state.inherits = [state.inherits]
            for inherit in state.inherits
              if @ensureState inherit, config
                return true
          locals =
            user: Auth.user
            config: config
          unless $injector.invoke state.check, null, locals
            goTo = if _.isString state.goTo
              state.goTo
            else
              $injector.invoke state.goTo, null, locals
            info = if _.isArray state.info or _.isFunction state.info
              # is injectable function?
              $injector.invoke state.info, null, locals
            else if state.info?
              state.info
            else
              {}
            $state.go goTo, info
            true
          else
            false
        else
          throw new Error "Unrecognized desired state: #{desiredState}"
      unless Auth.loading
        @ensureCallback(Auth.user, config)
      else
        false
  ]
  this
])
