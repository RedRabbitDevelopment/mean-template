
mongoose = require './mongo'
crypto = require 'crypto'
Schema = mongoose.Schema

UserSchema = new Schema
  name: String
  email: String
  password: String

UserSchema.methods =
  toJSON: ->
    console.log @_doc
    doc = @_doc
    delete doc.password
    doc

module.exports = User = mongoose.model 'User', UserSchema

