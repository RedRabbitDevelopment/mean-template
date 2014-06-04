
mongoose = require './mongo'
crypto = require 'crypto'
Schema = mongoose.Schema

UserSchema = new Schema
  name: String
  email: String
  password: String

module.exports = User = mongoose.model 'User', UserSchema

