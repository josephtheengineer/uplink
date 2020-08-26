const redis = require('redis')
let client = redis.createClient()

// Find the user to check password
exports.findByEmail = function(email, cb) {
	process.nextTick(function() {
		client.get('user:' + email, function(err, id) {
			console.log('dbId: ' + id)

			// find user in database here
			client.hgetall('user:' + id, function(err, obj) {
				console.log('Full obj: ' + obj)

				if (obj.email === email) {
					return cb(null, obj);
				}
				return cb(null, null);
			})
		})
	});
}

exports.findById = function(id, cb) {
	process.nextTick(function() {
		// find user in database here
		client.hgetall('user:'+id, function(err, obj){
			if (obj) {
				cb(null, obj);
			} else {
				cb(new Error('User ' + id + ' does not exist'));
			}
		})
	});
}
