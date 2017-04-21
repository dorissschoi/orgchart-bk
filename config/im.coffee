if not ('IMURL' of process.env)
	throw new Error "process.env.IMURL not yet defined"

module.exports =
	im:
		url: process.env.IMURL
