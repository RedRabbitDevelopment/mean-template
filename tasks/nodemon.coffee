nodemon = require 'gulp-nodemon'

module.exports = ->
  unless nodemon_instance
    nodemon_instance = nodemon
      script: 'index.js'
      ext: 'js'
      watch: ['doesntexist']
    .on 'restart', ->
      console.log 'restarting server'
  else
    nodemon_instance.emit 'restart'
