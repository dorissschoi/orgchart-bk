env = require '../../env.coffee'
req = require 'supertest-as-promised'    
oauth2 = require 'oauth2_client' 

describe 'UserController', ->
  token = null
  user = null
  supervisor = null  
  
  before ->
    oauth2
      .token env.tokenUrl, env.client, env.user, env.scope
      .then (t) ->
        token = t
  
  it 'update supervisor who never login',  ->
    sails.models.user
      .findOne
         username: process.env.USER_ID
      .then (user) ->
        req sails.hooks.http.app
          .put "/api/user/#{user.id}"
          .set 'Authorization', "Bearer #{token}"
          .send 
            supervisor: {email: 'user4@abc.com', username: 'user4', url: 'user4@abc.com'}
          .expect 200
          .toPromise()
          .delay(100)
