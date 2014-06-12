
angular.module 'meanTemplate'
.config ($stateProvider)->
  $stateProvider.state 'forgot-password',
    url: '/forgot-password'
    templateUrl: '/components/login/forgot-password.html'
    controller: 'ForgotPassword'
    data:
      pageTitle: 'Forgot Password'
      ensure: 'loggedOut'
.controller 'ForgotPassword', ($scope, EZAccess)->
  $scope.forgotPassword = (email)->
    $scope.success = false
    $scope.sending = true
    EZAccess.User.forgotPassword(email)
    .then (success)->
      $scope.success = true
    , (error)->
      $scope.error = error
      $scope.errors = error.errors
    .then ->
      $scope.sending = false

