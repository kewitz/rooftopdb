#!/usr/bin/env coffee
path = require 'path'
connect = require 'connect'
sass = require '../index'

app = connect()
app.use sass.serve path.join(__dirname, 'style.sass')
app.use connect.errorHandler()

connect.createServer(app).listen(3000)
