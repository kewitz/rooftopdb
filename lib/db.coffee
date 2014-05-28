###
	Singleton database connection.
###

engine = require('tingodb')()

class Singleton
	@get: ->
		@_instance ?= new engine.Db './db', safe: true

module.exports = Singleton.get()