[ 'VERIFYURL', 'OAUTH2_SCOPE', 'USERURL', 'TOKENURL' ].map (name) ->
  if not (name of process.env)
    throw new Error "process.env.#{name} not yet defined"

module.exports =
	oauth2:
		verifyURL:			process.env.VERIFYURL
		tokenURL:			process.env.TOKENURL
		scope:				process.env.OAUTH2_SCOPE?.split(' ')	
		userURL:			process.env.USERURL			