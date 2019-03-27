---
layout: post
title: "Windows 下 MySQL8.* 免密登陆并设置密码"
date: 2019-03-28
tag: MySQL
---

## 下载
1. 官网：https://dev.mysql.com/downloads/mysql/
    - MySQL 有企业和社区版本，非企业下载社区版：MySQL Community Server
    - 下载 zip 文档，如果对 MySQL 还不了解，直接下载 MSI，然后傻瓜式安装，先用起来



## 安装

> 菜鸟教程-MySQL安装：http://www.runoob.com/mysql/mysql-install.html

**注意点：**
1. 初始化数据库 `mysqld --initialize --console`，这个操作中会生成 MySQL `root@localhost` 用户的初始化密码，要记下！要记下！要记下！




## 问题
1. 我日...忘记把上面的初始密码给记录下来了，直接复制...复制内容被覆盖了，导致初始密码丢失
2. 旧版本可以通过 `MySQL安装目录`》`data目录`》`xxx.err文件`，使用编辑器打开，查询一下初始密码。关键字：`temporary password` 【初始密码...新版本 log 没有记录啦】
3. 在 Windows 下 MySQL 8 `mysqld --skip-grant-tables` 无法实现免密登陆



## MySQL 免密码登陆设置密码

**思路解析**
1. 停止当前服务
2. 设置登陆时免权限验证，并重启服务【该点是该文章要讲述的问题】
3. 修改密码
4. 去除免权限验证设置，重启服务


### 利用 init-file 参数解决
1. 将下述命令保存在一文本中，例如：pwd.txt
```
ALTER USER 'root'@'localhost' IDENTIFIED BY ”;
```
2. 通过命令行方式，使用 `--init-file` 初始化 MySQL 服务器
```
mysqld –init-file=d:mysqlc.txt –console
```


### 让 skip-grant-tables 参数用起来
- Windows 下 执行：`mysqld --console --skip-grant-tables --shared-memory`，然后重开一个窗口即可免密登陆，进行设置密码
- 设置密码方法：https://dev.mysql.com/doc/refman/8.0/en/set-password.html

> 1. 官网对 skip-grant-tables 参数的解释：https://dev.mysql.com/doc/refman/8.0/en/server-options.html#option_mysqld_skip-grant-tables
> 2. 官网对 shared-memory 参数的解释： https://dev.mysql.com/doc/refman/8.0/en/server-options.html#option_mysqld_shared-memory






## 可能会遇到问题

1. 使用非 `ALTER` 方式置空密码，可能会遇到下述方式报错
> ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executin

- MySQL 8 废弃了 `PASSWORD()` 函数，因此旧版本的设置密码方式不可行了！

问题原因：
- MySQL 5.7.4 版本之后，加了 `Password Expiration Policy` 机制，当密码过期时候强制要求重新设置密码后才能进行后续SQL操作


解决方案：
1.  直接设置密码或使用 `ALTER` 方式再次置空密码即可！

> 查官网文档：[https://dev.mysql.com/doc/refman/8.0/en/set-password.html](https://dev.mysql.com/doc/refman/8.0/en/set-password.html)，不要轻信网上博客的设置密码方式，很多都是旧版本的了，建议直接查看官网手册

2. 关闭 `Password Expiration Policy` 机制
    - 方式1-修改单用户密码永不过期 `ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER`
    - 方式2-全局设置用户密码不过期 
        ```conf
        [mysqld]
        default_password_lifetime=0
        ```
> 关于 MySQL 密码管理机制：[https://dev.mysql.com/doc/refman/8.0/en/password-management.html#password-expiration-policy](https://dev.mysql.com/doc/refman/8.0/en/password-management.html#password-expiration-policy)

