agent = require 'https-proxy-agent'

module.exports =
	hookTimeout:	400000
	
	port:			1337
	
	oauth2:
		verifyURL:			process.env.VERIFYURL
		tokenURL:			process.env.TOKENURL
		scope:				process.env.OAUTH2_SCOPE?.split(' ')	
		userURL:			process.env.USERURL

	adminUser:
		username:	process.env.ADMIN_ID
		email:		process.env.ADMIN_EMAIL

	promise:
		timeout:	10000 # ms

	models:
		connection: 'mongo'
		migrate:	'alter'
	
	connections:
		mongo:
			adapter:	'sails-mongo'
			driver:		'mongodb'
			host:		'orgchart_mongo'
			port:		27017
			user:		''
			password:	''
			database:	'orgchart'	
			
		
			
