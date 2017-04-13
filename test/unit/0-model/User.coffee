env = require '../../env.coffee'
Promise = require 'bluebird'

describe 'model', ->
  createdBy = null

  users = [
    { username: 'user1', url: 'user1@abc.com', email: "user1@abc.com" }
    { username: 'user2', url: 'user2@abc.com', email: "user2@abc.com" }
  ]

  it 'create user', ->
    sails.models.user
      .create
        username: users[0].username, url: users[0].url, email: users[0].email
      .then (user) ->
        createdBy = user

  it 'update supervisor', ->
    sails.models.user
      .update {username: createdBy.username}, {supervisor: {username: users[1].username, url: users[1].url, email: users[1].email}}
      .then (user) ->
         createdBy = user
         return

  it 'get user', ->
    sails.models.user
      .find
         email: createdBy.email
      .then (user) ->
         console.log user

  it 'delete user', ->
    Promise.mapSeries users, (u) ->
      sails.models.user
        .destroy
          username: u.username         
