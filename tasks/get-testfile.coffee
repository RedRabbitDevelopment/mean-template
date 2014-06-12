
through = require 'through2'
gutil = require 'gulp-util'
fs = require 'fs'

module.exports = (getBoth)->
  through.obj (file, enc, cb)->
    path = file.path
    parts = path.split('.')
    # if is script
    if /(coffee|js)/.test parts[parts.length - 1]
      # is test file
      isTestFile = 'spec' is parts[parts.length - 2]
      if isTestFile and not getBoth
        @push file
        cb()
      else
        # look for other file
        if isTestFile
          parts.splice parts.length - 2
        else
          parts.splice parts.length - 1, 0, 'spec'
        otherPath = parts.join '.'
        fs.readFile otherPath, (err, data)=>
          if data
            newFile = new gutil.File
              base: file.base
              cwd: file.cwd
              path: otherPath
              contents: data
            @push newFile
          cb()
    else
      cb()
