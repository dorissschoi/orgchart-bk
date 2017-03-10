module.exports = 
	bootstrap:	(cb) ->	
		sails.models.user
			.findOrCreate username: sails.config.adminUser.username,
				url:		"#{process.env.AUTHURL}/api/users/#{sails.config.adminUser.username}/"
				username:	sails.config.adminUser.username
				email:		sails.config.adminUser.email
			.then (admUser) ->
				cb()
			.catch cb