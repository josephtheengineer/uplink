const app = express.Router()

app.get('/', checkAuthenticated, (req, res) => {
	res.render('index', {
		title: 'Notes!',
		name: req.user.first_name
	})
})

module.exports = app
