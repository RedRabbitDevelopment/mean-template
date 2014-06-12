
module.exports = exports = files =
  frontendDir: 'public'
  backendDir: 'server'
  buildDir: 'build'
  frontendBuildDir: 'build/public'
  static: 'public/**/*.{html,css,js,gif,png,jpg,jpeg,svg,eot,woff,ttf}'
  staticBack: ['server/**/*', '!server/**/*.coffee']
  backendjs: ['server/**/*.coffee', '!server/**/*.spec.coffee']
  frontendjs: ['public/**/*.coffee', '!public/**/*.spec.coffee']
  sass: 'public/**/*.sass'
  ezFiles: ['ez-access.js', 'ez-access-angular.js']
  ezRoutes: 'ez-routes.js'
  bower_components: [
    'jquery/dist/jquery.js'
    'lodash/dist/lodash.js'
    'q/q.js'
    'angular/angular.js'
    'angular-ui-router/release/angular-ui-router.js'
    'ez-access/ez-access.js'
    'ez-access/ez-routes.js'
    'ez-access/ez-access-angular.js'
  ]
  test_bower_components: [
    'angular-mocks/angular-mocks.js'
    'should.js/should.js'
  ]

exports.karmafiles = karmafiles = files.bower_components
.map (file)->
  "public/lib/#{file}"
.concat files.test_bower_components.map (file)->
  "bower_components/#{file}"
.concat ['public/**/module.coffee', 'public/**/*.coffee']

