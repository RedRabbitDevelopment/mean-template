fs = require 'fs'
ejs = require 'ejs'
Q = require 'q'
nodemailer = require 'nodemailer'
config = require './config.json'

mail_config =
  protocol: 'SMTP'
  host: 'Gmail'
  username: config.smtp.email
  password: config.smtp.password
exports.mail_config = mail_config

exports.transport = transport = nodemailer.createTransport mail_config.protocol,
  service: mail_config.service
  auth:
    user: mail_config.username
    pass: mail_config.password

exports.sendEmail = (options)->
  renderTemplate(options.template, options.data).then (body)->
    exports.sendEmailBase
      to: options.email
      subject: options.subject
      html: body.html
      text: body.text

exports.sendEmailBase = (options)->
  options.from or= mail_config.username
  unless config.server.environment is 'production'
    options.to = 'sumwierdkid@gmail.com'
  Q.ninvoke transport, 'sendMail', options

renderTemplate = (template, object)->
  promises = for format in ['html', 'text']
    Q.nfcall(fs.readFile, "./email_templates/#{template}/#{format}.ejs", "utf8")
  Q.all(promises).spread (html, text)->
    html: ejs.render html, object
    text: ejs.render text, object

exports.makeHost = (request)->
  "#{request.protocol}://#{request.headers.host}"
