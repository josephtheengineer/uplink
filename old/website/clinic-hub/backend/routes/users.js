const app = express.Router()

app.get('/login', checkNotAuthenticated, (req, res) => {
	res.render('users/login', {
		title: 'Login - Notes!',
		layout: 'no-nav'
	})
})

app.post('/login', checkNotAuthenticated, passport.authenticate('local', {
	successRedirect: '/',
	failureRedirect: '/users/login',
	failureFlash: true
}))

app.get('/client-register', (req, res) => {
	res.render('users/client-register', {
		title: 'Client Register - Notes!'
	})
})

app.post('/client-register', async (req, res) => {
	try {
		const userId = Date.now().toString()
		const userString = 'user:' + userId
		const name = req.body.name
		const email = req.body.email
		const hashedPassword = await bcrypt.hash(req.body.password, 10)

		const fullName = req.body.full_name.split(' ')
		var firstName = ""
		var middleName = ""
		var lastName = ""

		if (fullName.length == 1) {
			firstName = fullName[0]

			client.hset(userString, [
				'id', userId,
				'name', name,
				'first_name', firstName,
				'email', email,
				'password', hashedPassword
			], function(err, reply) {
				if(error) {
					console.log(err)
				}
				console.log(reply)
			})

		} else if (fullName.length == 2) {
			firstName = fullName[0]
			lastName = fullName[1]

			client.hset(userString, [
				'id', userId,
				'name', name,
				'first_name', firstName,
				'last_name', lastName,
				'email', email,
				'password', hashedPassword
			], function(err, reply) {
				if(err) {
					console.log(err)
				}
				console.log(reply)
			})

		} else if (fullName.length >= 3) {
			firstName = fullName[0]
			middleName = fullName[1]
			lastName = fullName[2]

			client.hset(userString, [
				'id', userId,
				'name', name,
				'first_name', firstName,
				'middle_name', middleName,
				'last_name', lastName,
				'email', email,
				'password', hashedPassword
			], function(err, reply) {
				if(err) {
					console.log(err)
				}
				console.log(reply)
			})
		} else {
			console.log('Error fullName.length invalid')
		}

		client.set('user:' + email, userId,
			function (err, reply) {
				if(err) {
					console.log(err)
				}
				console.log(reply)
		})


		res.redirect('/')

	} catch (e) {
		console.log(e)
		res.redirect('/register')
	}
})

app.get('/register', checkNotAuthenticated, (req, res) => {
	res.render('users/register', {
		title: 'Register - Notes!'
	})
})

app.post('/register', checkNotAuthenticated, async (req, res) => {
	try {
		const userId = Date.now().toString()
		const userString = 'user:' + userId
		const name = req.body.name
		const email = req.body.email
		const hashedPassword = await bcrypt.hash(req.body.password, 10)

		const fullName = req.body.full_name.split(' ')
		var firstName = ""
		var middleName = ""
		var lastName = ""

		if (fullName.length == 1) {
			firstName = fullName[0]

			client.hset(userString, [
				'id', userId,
				'name', name,
				'first_name', firstName,
				'email', email,
				'password', hashedPassword
			], function(err, reply) {
				if(error) {
					console.log(err)
				}
				console.log(reply)
			})

		} else if (fullName.length == 2) {
			firstName = fullName[0]
			lastName = fullName[1]

			client.hset(userString, [
				'id', userId,
				'name', name,
				'first_name', firstName,
				'last_name', lastName,
				'email', email,
				'password', hashedPassword
			], function(err, reply) {
				if(err) {
					console.log(err)
				}
				console.log(reply)
			})

		} else if (fullName.length >= 3) {
			firstName = fullName[0]
			middleName = fullName[1]
			lastName = fullName[2]

			client.hset(userString, [
				'id', userId,
				'name', name,
				'first_name', firstName,
				'middle_name', middleName,
				'last_name', lastName,
				'email', email,
				'password', hashedPassword
			], function(err, reply) {
				if(err) {
					console.log(err)
				}
				console.log(reply)
			})
		} else {
			console.log('Error fullName.length invalid')
		}

		client.set('user:' + email, userId,
			function (err, reply) {
				if(err) {
					console.log(err)
				}
				console.log(reply)
		})


		res.redirect('/')

	} catch (e) {
		console.log(e)
		res.redirect('/register')
	}
})

app.delete('/logout', (req, res) => {
	req.logOut()
	res.redirect('/login')
})

app.get('/search', checkAuthenticated, function(req, res, next){
	res.render('users/search', {
		title: 'Search Users - Notes!'
	})
})

app.post('/search', checkAuthenticated, function(req, res, next){
	let id = req.body.id

	client.hgetall(id, function(err, obj){
		if(!obj){
			res.render('searchusers', {
				error: 'user does not exist'
			})
		} else {
			obj.id = id
			res.render('searchusers', {
				user: obj
			})
		}
	})
})

app.delete('/delete/:id', checkAuthenticated, function(req, res, next){
	client.hgetall(req.params.id, function(err, obj){
		if(!obj){
			res.render('searchusers', {
				error: 'user does not exist'
			})
		} else {
			client.del('user:' + obj.email)
			res.render('searchusers', {
				error: req.params.id + ' deleted'
			})
		}
	})
	client.del(req.params.id)
})

app.get('/profile', checkAuthenticated, function(req, res, next){
	res.render('users/profile', {
		title: 'Your Settings - Notes!',
		name: req.user.name
	})
})

module.exports = app
