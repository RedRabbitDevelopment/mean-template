
gulp = require 'gulp'
changed = require 'gulp-changed'
watch = require 'gulp-watch'
print = require 'gulp-print'
Stream = require 'stream'
newer = require 'gulp-newer'
files = require './files'
{File} = require 'gulp-util'
through = require 'through2'
FrontEnd = require('ez-ctrl').FrontEnd

gulp.task 'ez-copy', ->
  gulp.src 'node_modules/ez-ctrl/lib/ez-access/*.js',
    base: 'node_modules/ez-ctrl/lib'
  .pipe changed 'bower_components'
  .pipe gulp.dest 'bower_components'

module.exports = class Generator
  constructor: ->
    @cache = {}
    @frontend = new FrontEnd
  stream: ->
    _this = this
    through.obj (file, enc, cb)->
      delete require.cache[file.path]
      ctrl = require file.path
      _this.frontend.controllerManager.addController ctrl
      contents = _this.frontend.getFrontEndMethods()
      newfile = new File
        cwd: file.cwd
        base: file.base
        path: file.base + 'ez-routes.js'
        contents: new Buffer contents
      @push newfile
      cb()

gulp.task 'ez-gen', ->
  gen = new Generator()
  gulp.src ['server/routes/*.coffee', '!server/routes/*.spec.coffee']
  .pipe gen.stream()
  .pipe gulp.dest 'bower_components/ez-access'

