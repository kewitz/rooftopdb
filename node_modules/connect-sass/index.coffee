{spawn} = require 'child_process'
path = require 'path'
fs = require 'fs'
Q = require 'kew'

cmd = (cmd, args...) ->
  promise = Q.defer()
  ps = spawn(cmd, args)
  stdout = []
  stderr = []
  ps.stdout.on 'data', (chunk) -> stdout.push(chunk)
  ps.stderr.on 'data', (chunk) -> stderr.push(chunk)
  ps.on 'exit', (code) ->
    if code == 0
      promise.resolve stdout.join('')
    else
      promise.reject new Error stderr.join('')
  promise

isSass = /\.(sass|scss)$/

exports.serve = (options) ->
  if options.toString() == '[object Object]'
    filename = options.filename
    contentType = options.contentType or 'text/css'
  else
    filename = options
    contentType = 'text/css'

  dirname = path.dirname(filename)
  render = -> cmd 'sass', '--compass', filename

  rendered = render()

  fs.watch dirname, {persistent: false}, (ev, filename) ->
    rendered = render() if isSass.test filename

  (req, res, next) ->
    rendered
      .then (result) ->
        res.setHeader('Content-type', contentType)
        res.end(result)
      .fail next
