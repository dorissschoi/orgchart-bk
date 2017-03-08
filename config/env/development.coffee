agent = require 'https-proxy-agent'

module.exports =
	hookTimeout:	400000
	
	port:			1337

	#http:
	#	opts:
	#		agent:	new agent("http://proxy1.scig.gov.hk:8080")				
	
	oauth2:
		verifyURL:			process.env.VERIFYURL
		tokenURL:			"https://abc.com/org/oauth2/token/"
		scope:				process.env.OAUTH2_SCOPE?.split(' ')	
		userURL:			"https://abc.com/org/api/users/"

	adminUser:
		username: 'jokyip'

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
			
	log:
		level: 'info'
		
			
