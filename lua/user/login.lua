local uri_args = ngx.req.get_uri_args()  
local username = uri_args.username
local password = uri_args.password
require "lua/user/user_db"
user_db.init()
psd,id  = user_db.getUserByname(username)
if psd ~= nil then 
	if psd ~= password then
		ngx.say("Mismatch of username and password")
	else
		user_db.updateActivity(id)
		ngx.say("lgoin success")
	end
else
	ngx.say("unknow user")
end