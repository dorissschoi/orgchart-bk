[
  'OAUTH2_SCOPE', 
  'TOKENURL', 
  'CLIENT_ID', 
  'CLIENT_SECRET', 
  'USER_ID', 
  'USER_SECRET'
].map (name) ->
  if not (name of process.env)
    throw new Error "process.env.#{name} not yet defined"
    
module.exports =
	timeout: 4000000
	tokenUrl: process.env.TOKENURL
	scope: process.env.OAUTH2_SCOPE.split ' '
	client: 
		id:		process.env.CLIENT_ID
		secret: process.env.CLIENT_SECRET
	user: 
		id:		process.env.USER_ID
		secret: process.env.USER_SECRET
