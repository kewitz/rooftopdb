###
	User Model and Control.
###

crypto = require 'crypto'
db = require './db.coffee'
col = db.collection 'users'

class Model
	constructor: (params) ->
		if params?
			{@name, @pass, @salt} = params

	validate: (pass) ->
		@pass == crypto.createHmac('sha1', @salt).update(pass+'').digest('hex')

	hash: (pass) ->
		@saltit() unless @salt
		@pass = crypto.createHmac('sha1', @salt).update(pass+'').digest('hex')

	saltit: ->
		@salt = crypto.createHmac('sha1', '').update(Math.round((new Date().valueOf() * Math.random())) + '').digest('hex')

	save: (cb) ->
		user = this
		@exists (e) ->
			if e then cb "User already exists." else col.insert user, cb

	update: (cb) ->
		user = this
		console.log "Update", user
		col.update {_id: user._id}, {$set:user}, cb

	exists: (cb) ->
		if @name?
			col.findOne {name:@name}, (err,doc) ->
				cb doc?

	serialize: ->
		_id: @_id, name: @name

	@deserialize: (id, cb) ->
		col.findOne {_id: id}, (err, doc) ->
			err ?= "User does not exist." unless doc?
			if err? 
				cb err, null
			else if doc?
				r = new Model doc
				r._id = doc._id
				cb null, r

	@find: (filter, cb) ->
		col.find filter, cb


class Control
	create: (req, res, next) ->
		u = new User(req.body)
		u.save (err, doc) ->
			if err? then console.log err else console.log "New user #{doc.name} added."
			res.err = err
			res.user = doc
			next();

	auth: (req,res) ->
		@_parse req.body, (user) ->
			@col.findOne(user).count (err, count) ->
				authed = count == 1
		return

module.exports = Model: Model, Control: Control