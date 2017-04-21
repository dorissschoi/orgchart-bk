 # UserController
 #
 # @description :: Server-side logic for managing users
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
querystring = require 'querystring'
_ = require 'lodash'

module.exports =		
	findOauth2User: (req, res) ->
		cond = actionUtil.parseCriteria req
		url = sails.config.oauth2.userURL
		imurl = sails.config.im.url
		values = actionUtil.parseValues(req)
		
		strCond = querystring.stringify(cond)
		
		if values.skip != null & parseInt(values.skip) > 0 && strCond.length==0
			strCond = "page=#{(parseInt(values.skip) + 10)/10}"

		Promise
			.all [
			
				sails.services.rest().get req.user.token, "#{url}?#{strCond}"
				sails.services.rest().get req.user.token, "#{imurl}"
			]	
			.then (result) ->
				_.each result[0].body.results, (r) ->
					info = _.find result[1].body.results, {username: r.username}
					if !_.isUndefined info
						_.extend r, _.pick(info, 'photo
    Url','title')
				res.ok result[0].body
			.catch res.serverError

	findPageableUser: (req, res) ->
		sails.services.crud
			.find(req)
			.then res.ok
			.catch res.serverError
	update: (req, res) ->
		pk = actionUtil.requirePk(req)
		user = actionUtil.parseValues(req)

		#check whether user is admin
		sails.models.user.admin()
			.then (admin) ->
				if pk == admin.id
					pk = user.selUser.id

		if (user.supervisor == null || _.isUndefined user.supervisor)
			sails.models.user.update(pk, user)
				.then (updatedRecord) ->
					res.ok updatedRecord
				.catch res.serverError
		else		
			sails.models.user.findOne()
				.where({id: user.supervisor.id})
				.populateAll()
				.then (supervisor) ->
					supervisor.subordinates.add pk
					supervisor.save()
					res.ok user
				.catch res.serverError
	findForSelect: (req, res) ->
		@findPageableUser(req, res)
	
			
	
