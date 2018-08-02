ngx.say("hello lizy");   

local cjson = require("cjson")  
local value = cjson.encode(ngx.shared.url_limit)
ngx.say(value)