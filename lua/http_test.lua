local http = require "resty.http"   -- ①
local httpc = http.new()
local res, err = httpc:request_uri( -- ②
      "http://140.143.170.39:8083/study/coin/info",
       {
            method = "GET",
        }
    )
if 	200 ~= res.status then
        ngx.exit(res.status)
end
if args.key == res.body then
        ngx.say(res.body )
else
        ngx.say("invalid request")
end

