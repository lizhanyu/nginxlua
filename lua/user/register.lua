local var = ngx.var  
local uri_args = ngx.req.get_uri_args()  
local username = uri_args.username
local password = uri_args.password
local info 	   = uri_args.info 
local insertRes
 ngx.say("username : ", username, " , password : ", password, " , info : ", info) 
 require "lua/user/user_db"
 require "lua/user/userRedis"
 register_db.init()
 insertRes = register_db.insertUser(username,password,info)
 userRedis.init()
 userRedis.setUserInfo(insertRes.insert_id,username,info,1)
 ngx.say("register success", "<br/>")  


 