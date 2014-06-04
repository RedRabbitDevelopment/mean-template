
runSequence = require 'run-sequence'
gulp = require 'gulp'
mocha = require 'gulp-mocha'
karma = require 'gulp-karma'
protractor = require 'gulp-protractor'
## Tests

gulp.task 'frontend-tests', ->
  gulp.src ['build/public/lib/jquery/jquery.js', 'build/public/lib/angular/angular.js', 'public/**/*.coffee'], read: false
  .pipe karma
    configFile: 'karma.conf.coffee'
    action: 'run'
  
gulp.task 'backend-tests', ->
  gulp.src 'server/**/*.spec.coffee', read: false
  .pipe mocha reporter: 'spec'

gulp.task 'e2e', ->
  gulp.src 'e2e/**/*.coffee'
  .pipe protractor
    configFile: 'protractor.conf.coffee'
    args: ['--baseUrl', 'http://localhost:8000']
  .on 'error', (e) -> throw e
