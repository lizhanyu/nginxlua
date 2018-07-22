local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000)

local ok, err = red:connect("192.168.199.104", 6379)
if not ok then
        ngx.say("failed to connect: ", err)
        return
end
ngx.say("set result: ", ok)