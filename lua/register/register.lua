local var = ngx.var  
ngx.say("uri args begin", "<br/>")  
local uri_args = ngx.req.get_uri_args()  
local username = uri_args.username
local password = uri_args.password
local info 	   = uri_args.info 
 ngx.say("username : ", username, " , password : ", password, " , info : ", info) 
 require "lua/register/register_db"
 register_db.init()
 register_db.insertUser(username,password,info)



 