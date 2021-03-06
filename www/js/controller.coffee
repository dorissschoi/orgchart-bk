env = require './env.coffee'
Promise = require 'promise'

angular
	.module 'starter.controller', ['ionic', 'ngCordova', 'http-auth-interceptor', 'starter.model', 'platform']

	.controller 'MenuCtrl', ($scope, $ionicModal, $ionicSideMenuDelegate, $ionicPopup, $state, resources, me, collection, allUsers) ->
			
		$ionicModal
			.fromTemplateUrl 'templates/user/userSelect.html',
			  scope: $scope
			.then (modal) ->
				$scope.userModal = modal
		$ionicModal
			.fromTemplateUrl 'templates/user/adminSelect.html',
			  scope: $scope
			.then (modal) ->
				$scope.adminModal = modal

		collection.models.unshift(new resources.User {username: 'No Supervisor', selected: false})

		_.extend $scope,
			model: me
			collection: collection
			allUsers: allUsers
			highlightSupervisor: (user) ->
				$scope.selSupervisor = user
			highlightUser: (user) ->
				$scope.selUser = user
				newUser = new resources.User {username: user.username, email: user.email}
				newUser.$save()
					.then (u) ->
						$scope.selectUser = u
			loadMore: ->
				collection.$fetch()
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert

			loadMoreUsers: ->
				allUsers.$fetch()
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert
			userSave: (user) ->
				if (_.isUndefined $scope.selSupervisor) or ($scope.selSupervisor.username == "No Supervisor")
					user.supervisor = null
				else
					user.supervisor = $scope.selSupervisor
				$scope.selSupervisor = null
				user.$save().then ->
					$ionicSideMenuDelegate.toggleLeft()
					$state.reload()

			adminSave: ->
				if (_.isUndefined $scope.selSupervisor) or ($scope.selSupervisor.username == "No Supervisor")
					$scope.selectUser.supervisor = null
				else
					$scope.selectUser.supervisor = $scope.selSupervisor
				$scope.selSupervisor = null
				$scope.selUser = null
				$scope.selectUser.$save().then ->
					$ionicSideMenuDelegate.toggleLeft()
					$state.reload()


	.controller 'OrgChartCtrl', ($scope, collection, resources, userList, me) ->
		_.extend $scope,
			expandedNodes: []
			listView: false
			userList: userList
			collection: collection
			showInfo: (node) ->			
				$scope.$emit 'userInfo', node 
			showToggle: (node, expanded) ->
				if expanded
					$scope.expandedNodes.push node
					Promise
						.all _.map node.subordinates, (child) ->
							if child.subordinates.length == 0
								subordinate = new resources.User id: child.id
								subordinate.$fetch()
							else
								return child
						.then (data)->
							node.subordinates = data
							$scope.$apply()
							return node.subordinates
				else
					i = _.indexOf($scope.expandedNodes, node)
					$scope.expandedNodes.splice i, 1
			select: (nodes, user) ->
				if nodes == null
					new resources.User.root(user)
						.then (rootSupervisor) ->
							match = _.findWhere $scope.collection, {id: rootSupervisor.id}
							if match
								i = _.indexOf($scope.collection, match)
								if user.id == rootSupervisor.id
									$scope.selected = $scope.collection[i]
									$scope.$apply()
								else
									$scope.expandedNodes.push $scope.collection[i]
									$scope.showToggle($scope.collection[i], true)
										.then (data) ->
											$scope.select(data, user)
				else
					_.every nodes, (node) ->
						if node.id != user.id
							$scope.expandedNodes.push node
							$scope.showToggle(node, true)
								.then (data) ->
									$scope.select(data, user)
						else
							$scope.selected = node
							$scope.$apply()
			hide: ->
				$scope.listView = false
			show: ->
				$scope.listView = true				
			
	.filter 'UserFilter', ->
		(user, search) ->
			r = new RegExp(search, 'i')
			if search
				return _.filter user, (item) ->
					r.test(item?.username) or r.test(item?.email)	
			else
				return user

