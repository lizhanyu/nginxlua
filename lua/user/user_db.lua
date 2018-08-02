module("user_db", package.seeall)

function destroy(...)
    package.loaded["user_db"] = nil
end

function moduleName()
    return "user_db"
end
local function close_db(db)  
    if not db then  
        return  
    end  
    --释放连接(连接池实现)  
    local pool_max_idle_time = 10000 --毫秒  
    local pool_size = 100 --连接池大小  
    local ok, err = db:set_keepalive(pool_max_idle_time, pool_size)  
    if not ok then  
        ngx.say("set keepalive error : ", err)  
    end
   -- db:close()  
end  

local mysql = require("resty.mysql")  
--创建实例  
local db
function init( ... )
    db, err = mysql:new()  
    if not db then  
        ngx.say("new mysql error : ", err)  
        return  
    end  
    --设置超时时间(毫秒)  
    db:set_timeout(1000)  
    local props = {  
        host = "192.168.40.8",  
        port = 3306,  
        database = "study",  
        user = "root",  
        password = "123456"  
    }  
  
    local res, err, errno, sqlstate = db:connect(props)  
  
    if not res then  
       ngx.say("connect to mysql error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
       return close_db(db)  
    end
end


function insertUser( username,password,info)
    local insert_sql = "insert into user (id,username,psd,activity,info) values(0,'" .. username .."','"..password.."',1,'"..info.."' )";  
    res, err, errno, sqlstate = db:query(insert_sql)  
    if not res then  
       ngx.say("insert error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
       return close_db(db)  
    end   
    return res
end

function getUser( ... ) 
    local userObj   = {} 
    local select_sql = "select id,username, activity,info from user"  
    res, err, errno, sqlstate = db:query(select_sql) 
    if not res then  
        ngx.say("select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
        return close_db(db) 
    end 
    for i, row in ipairs(res) do  
       for name, value in pairs(row) do  
         ngx.say("select row ", i, " : ", name, " = ", value, "<br/>")  
            if name=="id" then
                userObj.id = userId 
            elseif name =="username" then
                userObj.name = username
            elseif name == "info" then
                userObj.info = info
            elseif name=="activity" then
                userObj.activity = activity
            else

            end
       end  
    end 
    return userObj 
end  