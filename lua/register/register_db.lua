module("register_db", package.seeall)
function destroy(...)
    package.loaded["register_db"] = nil
end

function moduleName()
    return "register_db"
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
local db, err = mysql:new()  
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
function insertUser( username,password,info, )
    local insert_sql = "insert into user (id,username,password,activity,info) 
    values('null'," .. username ..","..password..",1,"..info..")";  
    res, err, errno, sqlstate = db:query(insert_sql)  
    if not res then  
       ngx.say("insert error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
       return close_db(db)  
    end  
end  