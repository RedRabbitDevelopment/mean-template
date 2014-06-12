
describe 'Login', ->
  LoginCtrl = null
  $scope = {}
  $hb = null
  $rootScope = null
  auth = null
  beforeEach module 'meanTemplate.auth'
  beforeEach inject (Auth, $controller, $httpBackend, _$rootScope_)->
    $rootScope = _$rootScope_
    $hb = $httpBackend
    LoginCtrl = $controller 'Login',
      $scope: $scope
      Auth: auth = Auth
  it 'should login', ->
    $hb.expectPOST '/users/login'
    .respond
      success: true
      response:
        id: 5
    $scope.login
      username: 'user'
      password: 'pass'
    $rootScope.$digest()
    $hb.flush()
    $rootScope.$digest()
    auth.user.should.have.property('id', 5)
    $hb.verifyNoOutstandingExpectation()
