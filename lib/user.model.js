var crypto = require('crypto');
var db = require('./db.coffee');

function User (nick, pass) {
	this.nick = nick;
	this.pass = pass;
	this.col = db.collection('users');
}

User.prototype = {
	constructor: User,

	exists: function () {
		this.col.find({nick: this.nick}).count(function(err,c){
			return c > 0;
		});
	},

	makePass: function(pass) {
		if (pass != null)
			return crypto.createHmac('sha1', '1156880414195').update(pass+'').digest('hex');
	},

	find: function(doc) {
		this.col.find(doc).toArray(function(err, docs) {
			return docs;
		});
	},

	save: function() {
		if (!this.exists) {
			this.col.insert({nick: this.nick, pass: this.pass})
		}
	}


}

module.exports = User;