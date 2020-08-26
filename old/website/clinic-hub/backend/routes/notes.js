const app = express.Router()

app.get('/', checkAuthenticated, function(req, res, next){
	res.render('notes', {
		title: 'New - Notes!',
		date: getHumanDate(),
		notes_template: req.query.template
	})
})

app.post('/', checkAuthenticated, async (req, res) => {
	try {
		const date = encodeURIComponent(req.body.date)
		const template = encodeURIComponent(req.body.template)
		const title = encodeURIComponent(req.body.title)

		res.redirect('/notes/' + template + '?date='+date + '&template='+template + '&title='+title);

	} catch (e) {
		console.log(e)
		res.redirect('/')
	}
})


app.get('/intake', checkAuthenticated, function(req, res, next){
	res.render('notes/intake', {
		title: 'Intake Form - Notes!',
		date: getHumanDate(),
		notes_template: req.query.template
	})
})

app.post('/intake', checkAuthenticated, function(req, res, next){
	try {
		var data = []

		const id = Date.now().toString()
		data.push('id', id)
		const user = 'user:' + userId

		//const name = req.body.name
		//const hashedPassword = await bcrypt.hash(req.body.password, 10)

		const fullName = req.body.full_name.split(' ')
		var firstName = ""
		var middleName = ""
		var lastName = ""

		if (fullName.length == 1) {
			firstName = fullName[0]

			data.push('first_name', firstName)
		} else if (fullName.length == 2) {
			firstName = fullName[0]
			lastName = fullName[1]

			data.push('first_name', firstName)
			data.push('last_name', lastName)
		} else if (fullName.length >= 3) {
			firstName = fullName[0]
			middleName = fullName[1]
			lastName = fullName[2]

			data.push('first_name', firstName)
			data.push('middle_name', middleName)
			data.push('last_name', lastName)
		} else {
			console.log('Error fullName.length invalid')
		}

		// personal details
		data.push('address', req.body.address)

		// contact details
		data.push('home_phone', req.body.home-phone)
		data.push('mobile_phone', req.body.mobile-phone)
		data.push('work_phone', req.body.work-phone)

		const email = req.body.email
		data.push('email', email)

		data.push('birth', req.body.birth)
		data.push('children', req.body.children)
		data.push('partner', req.body.partner)
		data.push('occupation', req.body.occupation)
		data.push('accounts_name', req.body.accounts-name)
		data.push('health_fund', req.body.health-fund)

		// referral details
		data.push('referrer', req.body.referrer)
		data.push('referrer_yellow_pages', req.body.referrer-yellow-pages)
		data.push('referrer_sign', req.body.referrer-sign)
		data.push('referrer_health_fund', req.body.referrer-health-fund)
		data.push('referrer_acupuncture_association', req.body.referrer-acupuncture-association)
		data.push('referrer_health_care', req.body.referrer-health-care)
		data.push('referrer_voucher', req.body.referrer-voucher)
		data.push('referrer_paper', req.body.referrer-paper)
		data.push('first_visit', req.body.first-visit)

		// accidents or injuries
		data.push('injuries', req.body.injuries)
		data.push('doctor', req.body.doctor)
		data.push('doctor_phone', req.body.doctor-phone)

		// health details
		data.push('med_pain', req.body.med-pain)
		data.push('med_muscle_relaxants', req.body.med-muscle-relaxants)
		data.push('med_anti_infamantory', req.body.med-anti-infamantory)
		data.push('med_birth_control', req.body.med-birth-control)
		data.push('med_pressure', req.body.med-pressure)
		data.push('med_vitamins', req.body.med-vitamins)
		data.push('med_other', req.body.med-other)
		data.push('operations', req.body.operations)
		data.push('pregnant', req.body.pregnant)

		// Part 1 Create Client



		client.hset(user, [
			'id', id,
			'first_name', firstName,
			'email', email
		]
		function(err, reply) {
			if(err) {
				console.log(err)
			}
			console.log(reply)
		})

		client.set('user:' + email, id,
			function (err, reply) {
				if(err) {
					console.log(err)
				}
				console.log(reply)
		})

		res.redirect('/')
	} catch (e) {
		console.log(e)
		res.redirect('/notes/intake')
	}
})

app.get('/soap', function(req, res, next){
	res.render('notes/soap', {
		title: 'SOAP - Notes!',
		date: getHumanDate(),
		notes_template: req.query.template
	})
})


function getHumanDate(){
	var dateObj = new Date();
	var month = dateObj.getUTCMonth() + 1; //months from 1-12
	var day = dateObj.getUTCDate();
	var year = dateObj.getUTCFullYear();

	console.log(year + "-" + month + "-" + day)
	return year + "-" + month + "-" + day;
}

module.exports = app
