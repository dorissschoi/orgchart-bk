_ = require 'lodash'

module.exports =
	timeout: 4000000
	client: 
		id:		process.env.CLIENT_ID
		secret: process.env.CLIENT_SECRET
	user: 
		id:		process.env.USER_ID
		secret: process.env.USER_SECRET
	getToken: ->
		new Promise (fulfill, reject) ->
			url = process.env.TOKENURL
			scope = process.env.OAUTH2_SCOPE?.split(' ') || [ 'User', 'Mobile' ]
			Promise
				.resolve sails.services.rest().token url, module.exports.client, module.exports.user, scope
				.then (res) ->
						fulfill res.body.access_token
				.catch reject
