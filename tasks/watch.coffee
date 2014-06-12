
gulp = require 'gulp'
watch = require 'gulp-watch'
coffee = require 'gulp-coffee'
karma = require 'gulp-karma'
newer = require 'gulp-newer'
print = require 'gulp-print'
mocha = require 'gulp-mocha'
nodemon = require 'gulp-nodemon'
plumber = require 'gulp-plumber'
rename = require 'gulp-rename'
coffeelint = require 'gulp-coffeelint'
sass = require 'gulp-sass'
Combine = require 'stream-combiner'
filter = require 'gulp-filter'
es = require 'event-stream'
getTestFiles = require './get-testfile'
{buildIndex} = require './build'
Generator = require './ez-files'
karmaConfigMethod = require '../karma.conf'

files = require './files'

gulp.task 'serve', ['build'], ->
  filterDeleted = -> filter (file)-> file.event isnt 'deleted'
  # EZ files
  gulp.src 'node_modules/ez-ctrl/lib/ez-access/*.js',
    base: 'node_modules/ez-ctrl/lib'
  .pipe watch()
  .pipe gulp.dest 'bower_components'
  
  gen = new Generator()
  output = files.ezRoutes
  watch
    glob: ['server/routes/*.coffee', '!server/routes/*.spec.coffee']
  .pipe newer output
  .pipe gen.stream()
  .pipe gulp.dest 'bower_components/ez-access'

  # bower components
  bowerFiles = files.bower_components.map (file)->
    "bower_components/#{file}"
  gulp.src bowerFiles,
    base: 'bower_components'
  .pipe watch()
  .pipe gulp.dest 'public/lib'
  
  # backend static files
  gulp.src files.staticBack, base: 'server'
  .pipe watch()
  .pipe gulp.dest 'build'
  
  # frontend static files
  watch
    glob: files.static
  .pipe filtered = filterDeleted()
  .pipe gulp.dest 'build/public'

  # Frontend javascript
  watch
    glob: files.frontendjs
  .pipe filtered = filterDeleted()
  .pipe plumber()
  .pipe coffeelint()
  .pipe coffeelint.reporter()
  .pipe coffee bare: true
  .pipe gulp.dest 'build/public'

  # Sass
  watch
    glob: files.sass
  .pipe plumber()
  .pipe sass errLogToConsole: true
  .pipe gulp.dest 'build/public/css'

  # backend javascript
  watch glob: files.backendjs
  .pipe plumber()
  .pipe coffeelint()
  .pipe coffeelint.reporter()
  .pipe coffee bare: true
  .pipe gulp.dest 'build'

  gulp.src 'index.coffee'
  .pipe watch()
  .pipe plumber()
  .pipe coffee base: true
  .pipe gulp.dest './'

  # index
  watch
    glob: ['build/public/**/*.js', 'public/index.tpl']
  , buildIndex

  # nodemon
  nodemon_instance = false
  restartServer = ->
    unless nodemon_instance
      nodemon_instance = nodemon
        script: 'index.js'
        ext: 'js'
        watch: ['doesntexist']
    else
      nodemon_instance.emit 'restart'
  restartServer()
  watch
    glob: ['build/**/*', '!build/public/**/*']
  , restartServer

gulp.task 'tdd', ['build'], (cb)->
  # backend tests
  gulp.src ['server/**/*']
  .pipe watch (files)->
    combined = Combine(
      files,
      getTestFiles(),
      mocha reporter: 'spec'
    )
    combined.on 'error', (err)->
      unless /tests? failed/.test err.stack
        console.log err.stack
      this.emit 'end'

  server = require('karma').server
  server.start
    configFile: __dirname + '/../karma.conf.coffee'
    singleRun: false
    autoWatch: true

  ### doesnt seem to work
  gulp.src files.karmafiles
  .pipe karma
    configFile: 'karma.conf.coffee'
    action: 'watch'
  ###
      
