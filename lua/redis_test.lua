local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000)

local ok, err = red:connect("192.168.199.104", 6379)
if not ok then
        ngx.say("failed to connect: ", err)
        return
end
ngx.say("set result: ", "connect success")
local res, err = red:get("book")

if not res then
        ngx.say("failed to get book: ", err)
        return
end
ngx.say("get book is: ", res)
if res == ngx.null then
        ngx.say("book not found.")
        return
end

ngx.say("book: ", res)

red:init_pipeline()
red:set("1","2")
red:set("2","3q")
local result,err = red:commit_pipeline()

local reslrange,err = red:lrange("",0,8)