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

--[[function doRequest( ... )
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
end

local method=ngx.req.get_method()
local curl=ngx.md5(ngx.var.request_uri);
local request_uri_without_args = ngx.re.sub(ngx.var.request_uri, "\\?.*", "");
local match = string.match
local ngxmatch=ngx.re.match
--限流计数
function limit_url_check(key,s,m)
    　　 local localkey=key;
    　　 local yyy_limit=ngx.shared.url_limit
　　　　　　　 --每分钟限制
        local key_m_limit  =  localkey..os.date("%Y-%m-%d %H:%M", ngx.time()) 
            --每秒限制
        local key_s_limit  =  localkey..os.date("%Y-%m-%d %H:%M:%S", ngx.time())
        local req_key,_=yyy_limit:get(localkey);
        local req_key_s,_=yyy_limit:get(key_s_limit)
        local req_key_m,_=yyy_limit:get(key_m_limit)
        --每秒处理
        if req_key_s then
                yyy_limit:incr(key_s_limit,1)
                if req_key_s>s then 
                    --return true 
　　　　　　　　　　return false
                end
    　　 else
         		yyy_limit:set(key_s_limit,1,60)
    　　 end
　　　　　　　 --每分钟处理
        if req_key_m then
                 yyy_limit:incr(key_m_limit,1)
                 if req_key_m>m then 
                    --return true
                    return false
                 end
　　　　　　　 else
         yyy_limit:set(key_m_limit,1,85)
　　　　　　　 end
　　　　　　　 return false
end


if limit_url_check("userInfo",1,3200) then
　　　　ngx.say('访问太快了')
　　　　ngx.exit(200);
 　　　 return
else
		doRequest()
end
--]]