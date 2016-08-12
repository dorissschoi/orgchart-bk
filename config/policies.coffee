module.exports = 
	policies:
		UserController:
			'*':		false
			find:		['isAuth']
			findOne:	['isAuth']
			create:		['isAuth']
			update:		['isAuth']
			destroy:	['isAuth']
			add:		['isAuth']
			remove:		['isAuth']			
			findSuper:	['isAuth', 'user/me']
