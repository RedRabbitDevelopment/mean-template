
## Builds
gulp = require 'gulp'
es = require 'event-stream'
coffeelint = require 'gulp-coffeelint'
changed = require 'gulp-changed'
inject = require 'gulp-inject'
sass = require 'gulp-sass'
bower = require 'gulp-bower'
ejs = require 'gulp-ejs'
print = require 'gulp-print'
coffee = require 'gulp-coffee'
rename = require 'gulp-rename'
config = require '../server/models/config.json'
require './ez-files'

files = require './files'

gulp.task 'bower', ['bowerInstall', 'ez-copy', 'ez-gen'], ->
  bowers = files.bower_components.map (file)->
    "bower_components/#{file}"
  gulp.src bowers, base: 'bower_components'
  .pipe gulp.dest 'public/lib'

gulp.task 'bowerInstall', ->
  # Dependencies
  bower()
  .pipe gulp.dest 'bower_components'


gulp.task 'backend-copy', ->
  # Backend static
  gulp.src files.staticBack
  .pipe changed('build')
  .pipe gulp.dest 'build'

gulp.task 'frontend-copy', ['bower'], ->
  # Frontend static
  gulp.src [files.static, '!public/**/*.spec.js']
  .pipe changed('build/public')
  .pipe gulp.dest 'build/public'

gulp.task 'frontendjs', ->
  # Frontend js
  gulp.src files.frontendjs
  .pipe changed 'build/public', extension: '.js'
  .pipe coffeelint()
  .pipe coffeelint.reporter()
  .pipe coffee bare: true
  .pipe gulp.dest 'build/public'

gulp.task 'sass', ['bower'], ->
  # Sass
  gulp.src files.sass
  .pipe sass errLogToConsole: true
  .pipe gulp.dest 'build/public/css'

gulp.task 'backendjs', ->
  # Backend javascript
  backendStream = gulp.src files.backendjs
  .pipe changed 'build', extension: '.js'
  .pipe coffeelint()
  .pipe coffeelint.reporter()
  .pipe coffee bare: true
  .pipe gulp.dest 'build'
  indexStream = gulp.src 'index.coffee'
  .pipe changed './', extension: '.js'
  .pipe coffeelint()
  .pipe coffeelint.reporter()
  .pipe coffee bare: true
  .pipe gulp.dest './'
  es.merge backendStream, indexStream

module.exports = exports =
  buildIndex: ()->
    # index
    base = files.frontendBuildDir
    bowerFiles = files.bower_components.map (component)->
      "/lib/#{component}"
    javascripts = gulp.src ["#{base}/**/*.js", "!#{base}/lib/**/*.js"],
      read: false

    moduleFile = 'module.js'
    getScore = (filename)->
      parts = filename.substring(1).split '/'
      score = 0
      if 0 is parts.indexOf 'lib'
        score += 100
      if 1 is parts.indexOf 'common'
        score += 10
      if parts.length - 1 is parts.indexOf moduleFile
        score += 2
      score
    gulp.src ['public/index.tpl']
    .pipe rename 'index.html'
    .pipe ejs
      environment: config.server.environment
      libs: bowerFiles
    .pipe inject javascripts,
      ignorePath: base
      sort: (a, b)->
        getScore(b.filepath) - getScore(a.filepath)
    .pipe gulp.dest base

gulp.task 'index', ['frontendjs', 'frontend-copy'], exports.buildIndex


