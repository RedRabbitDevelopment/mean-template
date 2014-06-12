
angular.module 'meanTemplate'
.config ($stateProvider)->
  $stateProvider.state 'login',
    url: '/login'
    templateUrl: '/components/login/login.html'
    controller: 'Login'
    data:
      pageTitle: 'Login'
      ensure: 'loggedOut'
.controller 'Login', ($scope, Auth)->
  $scope.login = (user)->
    Auth.login user
  $scope.autologin = ->
    $scope.login
      email: 'activeuser@gmail.com'
      password: 'password'
