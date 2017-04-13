env = require './env.coffee'
require 'PageableAR'

angular.module 'starter.model', ['PageableAR']
	
	.factory 'resources', (pageableAR, $filter, $http) ->

		class User extends pageableAR.Model
			$idAttribute: 'id'
			
			$urlRoot: "api/user"
			
			_me = null
			
			@me: ->
				_me ?= new User id: 'me'
			
			@root: (user) ->
				if user.supervisor
					user.supervisor.$fetch()
						.then ->
							User.root(user.supervisor)
				else
					Promise.resolve user
			@subord: (user, subordArry)->	
				Promise.all (_.map user.subordinates, (subordinate) ->
								subordArry.push subordinate.email
								subordinate.$fetch()
									.then ->
										User.subord(subordinate, subordArry))			
					.then ->
						Promise.resolve subordArry
			
			@noSupervisor: ->
				User.fetchAll
					params:
						supervisor: "null"
						
			$parse: (data, opts) ->				
				if _.isObject(data.supervisor)
					data.supervisor = new User(data.supervisor)
				else if _.isString(data.supervisor)
					data.supervisor = new User(id: data.supervisor)

				data.subordinates = _.map data.subordinates, (subordinate)->
					new User(subordinate)
				
				return data
		
		class Users extends pageableAR.PageableCollection
			model: User
			$urlRoot: "api/pageable/user"		

		class Oauth2User extends pageableAR.Model
			$idAttribute: 'username'		
			$urlRoot: "api/oauth2/user"
		
		class Oauth2Users extends pageableAR.PageableCollection
			model: Oauth2User
			$urlRoot: "api/oauth2/user"

			$fetch: (opts = {}) ->
				opts.params = opts.params || {}
				opts.params.offset = @state.skip
				super opts
						
		class AdminSelectUsers extends pageableAR.PageableCollection
			model: User
			$urlRoot: "api/admForSelect/user"		


		User:		User
		Users:	Users
		Oauth2User:	Oauth2User
		Oauth2Users:	Oauth2Users
		AdminSelectUsers:	AdminSelectUsers
