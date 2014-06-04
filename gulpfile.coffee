gulp = require 'gulp'
runSequence = require 'run-sequence'

require('node-require-directory')('./tasks')

###
# Commands:
#   help: list commands
#   serve: watch and serve files
#   tdd: watch and run tests
#   build: build complete file path
###

gulp.on 'error', (err)->
  this.emit 'end'

gulp.task 'help', ->
  console.log ''
  console.log 'cult <command>'
  console.log '  cult help - this message'
  console.log '  cult serve - watch and serve files'
  console.log '  cult tdd - watch and test files'
  console.log '  cult test - build files and run tests'
  console.log '  cult build - build files but don\'t run tests'
  console.log ''

gulp.task 'build', ['test'], ->
  runSequence 'backend-tests', 'frontend-tests', 'e2e'

gulp.task 'build', [
  'bower'
  'ez-copy'
  'ez-gen'
  'backend-copy'
  'frontend-copy'
  'frontendjs'
  'backendjs'
  'sass'
  'index'
]

gulp.on 'stop', ->
  process.nextTick ->
    process.exit 0

