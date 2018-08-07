# 目标
 熟悉nginx+lua开发模式，熟悉openresty
  api使用。
# 需求
1. 满足用户登录，注册，信息存储进mysql
2. 满足用户个人信息的拉取，有缓存
3. 满足个人信息的修改
4. 记录用户的活跃值，活跃值登录则会增加

# mysql设计

user表


字段名 | 类型 | 描述
---|---|---
id | int | 主键
username | varchar | 用户名
psd | varchar | 密码
activity | int | 活跃值
info     | varchar | 个人信息

# redis设计

1. 注册后将个人信息写入redis
    
key | value
---|---
用户唯一标识 | 用户名和个人信息的json

2. 登录不走redis,更新活跃值


# 实现

## 开发环境搭建
    
    不做说明
## 实现

    lua.conf 中配置注册文件的入口
    
```
        default_type 'text/html';    
        lua_code_cache off;        
        content_by_lua_file /usr/example/nginxlua/lua/user/register.lua;  
```

    将注册逻辑写进register.lua 中，req.get_uri_args()可以得到请求过来数据的参数
    
```
        local uri_args = ngx.req.get_uri_args()  
        local username = uri_args.username
        local password = uri_args.password
        require "lua/user/user_db"
        require "lua/user/userRedis"
```
 
user_db 为写入mysql的逻辑，userRedis 为写入redis逻辑文件，调用方法为

```
        user_db.init()
        insertRes = user_db.insertUser(username,password,info)
        userRedis.init()
        userRedis.setUserInfo(insertRes.insert_id,username,info,1)
```
先调用init（）方法，这个地方可以复用db的连接，我这里没有加这个逻辑
在处理连接关闭的地方，加入set_keepalive 可以保持这个连接。
从redis中读出的数据，如果不存在，那么返回的是null，lua中的nil和null不相等，
所以如果需要作比较，需要做ngx.null 和redis读出的null作比较

## 登录和获取个人信息的地方逻辑基本一致，









    




