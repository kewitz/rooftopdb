db = require './db.coffee'

class Roof
	find: (req,res) ->
		db.find(id: id)

module.exports = Roof