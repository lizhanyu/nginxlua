# 目标
 熟悉nginx+lua开发模式，熟悉openresty
  api使用。
# 需求
1. 满足用户登录，注册，信息存储进mysql
2. 满足用户个人信息的拉取，有缓存
3. 满足个人信息的修改
3. 记录用户的活跃值，活跃值登录则会增加
 
# mysql设计

user表

字段名  | 类型 | 描述
---    |---  |---
id     | int | 主键
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




