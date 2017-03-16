env = require '../../env.coffee'
req = require 'supertest-as-promised'    

describe 'UserController', ->
   token = null
  user = null
  supervisor = null  
  
  before ->
    env.getToken()
      .then (res) ->
        token = res         

  it 'get login user', ->
    req sails.hooks.http.app
      .get('/api/user/me')
      .set 'Authorization', "Bearer #{token}"
      .expect 200    
      .then (res) ->
        user = res
  
  it 'update supervisor', ->
    # get supervisor
    sails.models.user
      .findOne
         username: process.env.ADMIN_ID
      .then (u) ->
        supervisor = u
      
    req sails.hooks.http.app
      .put "/api/user/#{user.id}"
      .send
         supervisor: supervisor 
      .set 'Authorization', "Bearer #{token}"
      .expect 200
    
     