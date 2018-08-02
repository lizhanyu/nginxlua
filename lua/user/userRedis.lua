
module("userRedis", package.seeall)
local cjson = require("cjson")  
local redis = require("resty.redis")  
function destroy(...)
    package.loaded["userRedis"] = nil
end

function moduleName()
    return "userRedis"
end
local function close_redis(red)  
    if not red then  
        return  
    end  
    --释放连接(连接池实现)  
    local pool_max_idle_time = 10000 --毫秒  
    local pool_size = 100 --连接池大小  
    local ok, err = red:set_keepalive(pool_max_idle_time, pool_size)  
    if not ok then  
        ngx.say("set keepalive error : ", err)  
    end  
end
--创建实例  
local red 
function init( ... )
    red = redis:new() 
    --建立连接  
    local ip = "192.168.40.8"  
    local port = 6379 
    local ok, err = red:connect(ip, port)  
    if not ok then  
        ngx.say("connect to redis error : ", err)  
        return close_redis(red)  
    end
    return red
end
local function keyBuild(userId )
    return "user_"..userId
end 
function getUserInfo( userId )
    local key = keyBuild(userId)
    local value = red:get(key)
    return value
end
function setUserInfo(userId, username,info,activity )
    local obj   = {}
    obj.name    = username
    obj.id      = userId 
    obj.info    = info
    obj.activity= activity
    local value = cjson.encode(obj) 
    local key   = keyBuild(userId)
    red:set(key,value)
    return value
end