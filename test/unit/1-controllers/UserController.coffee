env = require '../../env.coffee'
req = require 'supertest-as-promised'    
path = require 'path'
util = require 'util'
_ = require 'lodash'
fs = require 'fs'
Promise = require 'bluebird'

describe 'UserController', ->
  @timeout env.timeout
  
  token = null
  
  before ->
    env.getToken()
      .then (res) ->
        token = res

  it 'update supervisor', (done) ->
    req sails.hooks.http.app
      .put "/api/user/#{env.user.id}"
      .set 'Authorization', "Bearer #{token}"
      .send 
         supervisor: {email: 'user4@abc.com', username: 'user4', url: 'user4@abc.com'}
      .toPromise()
      .delay(100)
      .then (res) ->
         done()
