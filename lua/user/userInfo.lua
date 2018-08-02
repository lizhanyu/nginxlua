local uri_args = ngx.req.get_uri_args()  
local id = uri_args.id
local userInfo 
ngx.say("id : ", id) 
require "lua/user/userRedis"
userRedis.init()
userInfo = userRedis.getUserInfo(id)
if userInfo == nil  then
	require "lua/user/user_db"
	userObj  = user_db.getUser(id)
	ngx.say("read db ") 
	userInfo = userRedis.setUserInfo(userObj.id, userObj.username,userObj.info,userObj.activity)
end
ngx.say("userInfo : ", userInfo) 