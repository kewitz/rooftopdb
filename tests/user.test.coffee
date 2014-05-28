assert = require 'assert'
User = require('../lib/user.coffee').Model

teste = new User name:"test"
console.log "User created:", teste

teste.hash(123)
console.log "Salted:", teste

console.log "Validated:", teste.validate(123)

teste.save (err,result) ->
	if err?
		console.log "Error:", err 
	else
		console.log "Saved on DB:", result

User.deserialize 2, (err, u) ->
	if err?
		console.log "Error:", err
	else
		console.log "Loaded from DB:", u
		console.log "Serialized:", u.serialize()
		u.exists (e) ->
			console.log "Exists:", e
		u.name = "o Teste mudou"
		u.update (err, result) ->
			if err?
				console.log "Update Error:", err
			else
				console.log "Updated:", result