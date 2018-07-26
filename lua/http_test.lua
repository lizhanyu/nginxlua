--https://github.com/pintsized/lua-resty-http/archive/master.zip
local http = require "resty.http"   
local httpc = http.new()
local res, err = httpc:request_uri( 
      "http://140.143.170.39:8083",
       {
            method = "GET",
            path="/study/coin/info",
            headers={}
        }
    )
if 	200 ~= res.status then
        ngx.say(res.status)
end

    ngx.say(res.body )


