env = require './env.coffee'

angular.module 'starter', ['ionic', 'starter.controller', 'starter.model', 'ActiveRecord', 'angular.filter', 'util.auth', 'treeControl', 'xeditable', 'ui.select', 'angular-scroll-complete', 'ngFancySelect']

	.run (authService) ->
		authService.login env.oauth2().opts
		
	.run ($rootScope, platform, $ionicPlatform, $location, $http) ->
		$ionicPlatform.ready ->
			if (window.cordova && window.cordova.plugins.Keyboard)
				cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
			if (window.StatusBar)
				StatusBar.styleDefault()					
	.run ($rootScope, $ionicModal) ->
		$rootScope.$on 'userInfo', (event, data) ->
			_.extend $rootScope,
				username: data.username
				email: data.email
				url: data.url
			$ionicModal.fromTemplateUrl 'templates/orgchart/modal.html', scope: $rootScope
				.then (modal) ->
					modal.show()
					$rootScope.modal = modal			
	.run (editableOptions) ->
		editableOptions.theme = 'bs3'
	.config ($stateProvider, $urlRouterProvider) ->
		$stateProvider.state 'app',
			url: ""
			abstract: true
			controller: 'MenuCtrl'
			templateUrl: "templates/menu.html"
			resolve:
				resources: 'resources'
				me: (resources) ->
					resources.User.me().$fetch()
				allUsers: (resources) ->
					ret = new resources.Oauth2Users()
					ret.$fetch({params: {sort: 'name ASC'}})						
						.then (data) ->
							return data

				collection: (resources, me) ->
					resources.User.subord(me, [])
						.then (result) ->
							result.push me.email
							ret = new resources.Oauth2Users()
							ret.$fetch({params: {sort: 'name ASC'}})
								.then (data) ->
									ret.models = _.filter data.models, (user) ->
										_.indexOf(result, user.email) == -1
									return ret

		$stateProvider.state 'app.update',
			url: '/update'
			cache: false
			views:
				menuContent:
					templateUrl: 'templates/user/update.html'
					controller: 'UserUpdateCtrl'
			resolve:
				resources: 'resources'
				me: (resources) ->
					resources.User.me().$fetch()
				adminSelectUsers: (resources) ->
					ret = new resources.AdminSelectUsers
					ret.$fetch({params: {sort: 'name ASC'}})
				collection: (resources, me) ->
					resources.User.subord(me, [])
						.then (result) ->
							result.push me.email
							ret = new resources.Oauth2Users()
							ret.$fetch({params: {sort: 'name ASC'}})
								.then (data) ->
									ret.models = _.filter data.models, (user) ->
										_.indexOf(result, user.email) == -1
									return ret

		$stateProvider.state 'app.orgchart',
			url: "/orgchart"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/orgchart/list.html"
					controller: 'OrgChartCtrl'
			resolve:
				resources: 'resources'
				collection: (resources) ->
					resources.User.noSupervisor()
				userList: (resources) ->
					ret = new resources.Users()
					ret.$fetch({params: {sort: 'name ASC'}})
				me: (resources) ->
                                        resources.User.me().$fetch()

		$urlRouterProvider.otherwise('/orgchart')
