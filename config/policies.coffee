module.exports = 
	policies:
		UserController:
			'*':		false
			find:		true
			findOne:	['isAuthMe', 'user/me']
			update:		['isAuth', 'user/addSuper']
			findOauth2User:		['isAuth']
			findPageableUser:	true
			findForSelect: ['isAuth', 'user/isAdmin']
			create: ['isAuth', 'user/isAdmin']
