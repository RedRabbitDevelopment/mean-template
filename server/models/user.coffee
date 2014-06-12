
mongoose = require './mongo'
crypto = require 'crypto'
Schema = mongoose.Schema

UserSchema = new Schema
  name: String
  email: String
  password: String
  is_admin: Boolean

UserSchema.methods =
  toJSON: ->
    doc = @_doc
    delete doc.password
    doc

module.exports = User = mongoose.model 'User', UserSchema

