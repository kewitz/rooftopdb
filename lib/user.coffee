crypto = require 'crypto'
db = require './db.coffee'

class User
	constructor: (@nick, @pass) ->
		@col = db.collection 'users'

	create: (req, res) ->
		@_parse req.body, (user) ->
			user._exists (exist) ->
				if exist
					console.log 'Usuário %s já cadastrado.', user.nick
				else
					user._save()

	auth: (req,res) ->
		@_parse req.body, (user) ->
			@col.findOne(user).count (err, count) ->
				authed = count == 1
		return

	_makePass: (pass) ->
		if pass?
			@pass = crypto.createHmac('sha1', '1156880414195').update(pass+'').digest('hex')

	_parse: (doc, next) ->
		@nick = doc.nick
		@pass = @_makePass doc.pass
		next this

	_exists: ->
		(@col.find(nick: @nick).count((err, count) ->
			count > 0
		))()

	_save: (next) ->
		this._exists (exist) ->
			if !exist
				@col.insert this, next(err,doc)

	_find: (doc) ->
		@col.find(doc).toArray (err,docs) ->
			return docs
		return

module.exports = User