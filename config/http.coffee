express = require 'express'
csp = require 'helmet-csp'			
module.exports = 
	http:
		middleware:
			static: express.static('www')
			csp: (req, res, next)->
				host = req.headers['x-forwarded-host'] || req.headers['host']
				src = [
					"'self'"
					"data:"
					"http://#{host}"
					"https://#{host}"
				]
				ret = csp
					directives:
						defaultSrc: src
						connectSrc: [ "ws://#{host}", "wss://#{host}" ].concat src
						styleSrc: [ "'unsafe-inline'" ].concat src
						scriptSrc: [ "'unsafe-inline'", "'unsafe-eval'" ].concat src
				ret req, res, next
			order: [
				'startRequestTimer'
				'cookieParser'
				'session'
				'prefix'
				'resHeader'
				'bodyParser'
				'compress'
				'methodOverride'
				'$custom'
				'router'
				'static'
				'www'
				'favicon'
				'404'
				'500'
			]