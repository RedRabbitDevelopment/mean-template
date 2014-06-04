
angular.module('meanTemplate', ['ui.router', 'ez.access', 'auth'])
.config ($urlRouterProvider, AuthConfigProvider)->
  $urlRouterProvider.otherwise '/'
  AuthConfigProvider.config
    loginUrl: '/users/login'
    authorizedView: 'home'
    translateResponse: (res)->
      res.data.user = res.data.response
      res.data
.run (Auth)->
  Auth.initialize()
.controller 'Base', ($scope)->
  $scope.$on '$stateChangeSuccess', (event, toState)->
    window.ga? 'send', 'pageview', toState.url
    if toState.data?.pageTitle
      $scope.pageTitle = "#{toState.data.pageTitle} | Mean Template"

