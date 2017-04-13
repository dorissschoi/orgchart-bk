if not ('DB' of process.env)
	throw new Error 'process.env.DB not yet defined'

module.exports =
	connections:
		mongo:
			adapter: 'sails-mongo'
			driver: 'mongodb'
			url: process.env.DB
