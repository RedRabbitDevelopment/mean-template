
angular.module('meanTemplate')
.config ($stateProvider)->
  $stateProvider.state 'reset-password',
    url: '/reset-password/:token'
    templateUrl: '/components/login/reset-password.html'
    controller: 'ResetPassword'
    data:
      pageTitle: 'Reset Password'
      ensure: 'loggedOut'
.controller 'ResetPassword', ($scope, $stateParams, EZAccess, Auth)->
  $scope.resetPassword = (password, password_confirm)->
    $scope.errors = {}
    if password isnt password_confirm
      return $scope.errors = password_confirm: ['NotMatching']
    EZAccess.User.resetPassword $stateParams.token, password
    .then (user)->
      Auth.setUser user
    , (error)->
      console.log error
      $scope.errors = error.errors
