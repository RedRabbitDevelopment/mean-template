
angular.module 'meanTemplate'
.config ($stateProvider)->
  $stateProvider.state 'home',
    url: '/'
    templateUrl: '/components/home/home.html'
    controller: 'Home'
    data:
      pageTitle: 'Home'
      ensure: 'loggedIn'
    resolve:
      users: (EZAccess)->
        EZAccess.User.query()
.controller 'Home', ($scope, users)->
  $scope.users = users
