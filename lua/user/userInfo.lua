local uri_args = ngx.req.get_uri_args()  
local id = uri_args.id
local userInfo 
require "lua/user/userRedis"
userRedis.init()
userInfo = userRedis.getUserInfo(id)
if userInfo == ngx.null  then
	require "lua/user/user_db"
	user_db.init()
	userObj  = user_db.getUser(id)
 	userInfo = userRedis.setUserInfo(userObj.id, userObj.username,userObj.info,userObj.activity)
end
ngx.say("userInfo : ", userInfo) 