ngx.say("Hi Gary");   

local cjson = require("cjson")  
local value = cjson.encode(ngx.shared.url_limit)
ngx.say(value)


--[[

总会有不期而遇的温暖，也会存在生生不息的希望。虽任重而道远，只要方向正确，不管多么崎岖不平，都比站在原地更接近终点。

--]]