if (process.env.NODE_ENV !== 'production') {
	require('dotenv').config()
}

global.express = require('express')
const expressHbs = require('express-handlebars')
const bcrypt = require('bcrypt')
global.passport = require('passport')
const flash = require('express-flash')
const session = require('express-session')
const methodOverride = require('method-override')

const path = require('path')
const bodyParser = require('body-parser')
const redis = require('redis')

const Strategy = require('passport-local').Strategy

const port = 3000
app = express()

// setup Redis
let client = redis.createClient()

client.on('connect', function(){
	console.log('Connected to Redis')
})

// view engine
app.engine('.hbs', expressHbs({defaultLayout:'main', extname:'.hbs'}))
app.set('view engine', '.hbs')

// body parser
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended:false}))

//app.set('view-engine', 'ejs')
app.use(express.urlencoded({ extended: false }))
app.use(flash())
app.use(session({
	secret: process.env.SESSION_SECRET,
	resave: false,
	saveUninitialized: false
}))
app.use(passport.initialize())
app.use(passport.session())

// passport setup what is happening?????
global.initializePassport = require('./passport-config')

// Configure the local strategy for use by Passport.
//
// The local strategy require a `verify` function which receives the credentials
// (`username` and `password`) submitted by the user.  The function must verify
// that the password is correct and then invoke `cb` with a user object, which
// will be set at `req.user` in route handlers after authentication.
passport.use(new Strategy({ usernameField: 'email' },
function(email, password, cb) {
	initializePassport.findByEmail(email, function(err, user) {
		if (err) { return cb(err); }
		if (!user) { return cb(null, false); }
		if (!bcrypt.compare(user.password, password)) { return cb(null, false); }
		return cb(null, user);
	});
}));


// Configure Passport authenticated session persistence.
//
// In order to restore authentication state across HTTP requests, Passport needs
// to serialize users into and deserialize users out of the session.  The
// typical implementation of this is as simple as supplying the user ID when
// serializing, and querying the user record by ID from the database when
// deserializing.
passport.serializeUser(function(user, cb) {
	cb(null, user.id);
});

passport.deserializeUser(function(id, cb) {
	initializePassport.findById(id, function (err, user) {
		if (err) { return cb(err); }
		cb(null, user);
	});
});

// allows the use of DELETE method in forms
app.use(methodOverride('_method'))


global.checkAuthenticated = function(req, res, next) {
	if (req.isAuthenticated()) {
		return next()
	}

	res.redirect('/users/login')
}

global.checkNotAuthenticated = function(req, res, next) {
	if (req.isAuthenticated()) {
		return res.redirect('/')
	}
	next()
}


const indexRoutes = require('./routes/index')
const usersRoutes = require('./routes/users')
const notesRoutes = require('./routes/notes')

app.use('/', indexRoutes)
app.use('/users', usersRoutes)
app.use('/notes', notesRoutes)

app.listen(port, function(){
	console.log('Server started on port '+port)
})
