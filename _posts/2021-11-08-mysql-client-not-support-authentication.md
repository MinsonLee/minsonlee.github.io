---
layout: post
title: 错误：1251- Client does not support authentication protocol requested by server;consider upgrading Mysql client。
date: 2021-11-08
tags: [MySQL]
---

在腾讯云上购买了服务器，搭建了一些服务平时自己玩玩。开了一个 MySQL 用户给同学，自己测试过登录、建表等都没有问题，结果她使用 Navicat 登录的时候报错：`1251- Client does not support authentication protocol requested by server;consider upgrading Mysql client`。

这里稍微记录一下问题原因、解决方法

**创建用户并授权**

```sql
-- 创建数据库
CREATE DATABASE <database>;

-- 创建用户
CREATE USER '<user>'@'%' IDENTIFIED BY '<password>';

-- 授权用户
GRANT ALL ON <database>.<table> TO '<user>'@'%';
```



登录报错：`1251- Client does not support authentication protocol requested by server;consider upgrading Mysql client。`

- 原因：`MySQL8` 之前的版本中加密规则是`mysql_native_password`,而在 `MySQL8` 之后,加密规则是`caching_sha2_password`。
- 解决办法：
    1. 可以升级客户端的驱动
    2. 将 MySQL 登录用户的登录密码加密规则改为 `mysql_native_password`（推荐）



```sql
-- 查询用户加密方式
select host,user,plugin,authentication_string from mysql.user;

-- 重新修改用户密码
ALTER USER '<user>'@'<host>' IDENTIFIED WITH mysql_native_password BY '<pwd>';

-- 刷新当前进程权限
FLUSH PRIVILEGES; #刷新权限
```

![error-mysql-client-not-support-authentication](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/error-mysql-client-not-support-authentication.png)

