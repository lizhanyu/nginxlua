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
--累计活跃值
function updateActivity( id )
    local update_sql = "update  user set activity =  activity + 1 where id = "..id  
    res, err, errno, sqlstate = db:query(update_sql) 
    if not res then  
       ngx.say("update error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
       return close_db(db)  
    end    
end

function insertUser( username,password,info)
    local password = getUser(username)
    if password ~= nil then
        ngx.say("username 已经注册过了")  
       return close_db(db)  
    end
    local insert_sql = "insert into user (id,username,psd,activity,info) values(0,'" .. username .."','"..password.."',1,'"..info.."' )";  
    res, err, errno, sqlstate = db:query(insert_sql)  
    if not res then  
       ngx.say("insert error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
       return close_db(db)  
    end   
    return res
end

function getUser( id ) 
    local userObj   = {} 
    local select_sql = "select id,username, activity,info from user where id="..id  
    res, err, errno, sqlstate = db:query(select_sql) 
    if not res then  
        ngx.say("select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
        return close_db(db) 
    end 
    for i, row in ipairs(res) do  
       for name, value in pairs(row) do  
            if name=="id" then
                userObj.id = value 
            elseif name =="username" then
                userObj.name = value
            elseif name == "info" then
                userObj.info = value
            elseif name=="activity" then
                userObj.activity = value
            else

            end
       end  
    end 
    return userObj 
end 
function getUserByname( username ) 
    local password = nil 
    local id = nil
    local select_sql = "select id, psd from user where username= '"..username.."'"  
    res, err, errno, sqlstate = db:query(select_sql) 
    if not res then  
        ngx.say("select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
        return close_db(db) 
    end 
    for i, row in ipairs(res) do  
       for name, value in pairs(row) do  
            if name=="psd" then
                password = value 
            elseif name =="id" then
                id = value
            end
       end  
    end 
    return password ,id
end  