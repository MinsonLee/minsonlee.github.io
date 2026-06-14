---
layout: post
title: MySQL 8 重置 `root` 用户密码
date: 2021-01-22
tags: [MySQL]
---

在安装 `MySQL` 的过程中有一个初始化数据库的操作：`mysqld --initialize`或`mysqld --initialize --console`，这个操作中会生成一个 `MySQL` 用户： `root@localhost`，同时还有其初始化密码，要记下！要记下！要记下！

## MySQL 8 忘记密码

在 `MySQL 8` 之前的旧版本是可以通过 `MySQL安装目录`》`data目录`》`xxx.err文件`，使用编辑器打开，搜索关键字 `temporary password` 查询初始密码，但是在 `MySQL 8` 及其以后的版本中这个 `log` 没有再记录该初始密码了！

同时，直接使用 `mysqld --skip-grant-tables` 操作也不能直接实现免密登录操作了，需要利用 `init-file` 参数解决，如下！

详细信息请查看官网：[How to Reset the Root Password](https://dev.mysql.com/doc/refman/8.0/en/resetting-permissions.html)。

1. 将下述命令保存在一文本中，例如：`/tmp/pwd-reset`

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'test';
```

2. 通过命令行方式，使用 `--init-file` 初始化 `mysqld` 服务（`&`-在后台运行）

```sh
mysqld –init-file=/tmp/pwd-reset &
```

3. 通过 `mysql` 客户端连接到本机服务

```sh
mysql -uroot -ptest
```

**注意： `mysql -ppassword` 表示 `password` 是密码部分；`mysql -p xxx`表示需要用户手动输入密码，然后默认进入到 `xxx` 数据库-相当于登录之后默认执行一句：`use xxx;`进行切换数据库**

4. 查看 `root` 用户有哪些 `host`

![select users](/images/article/mysql-select-root-in-mysql.user.png)

```sql
select user,host from mysql.user where user='root';
```

5. 修改 `root` 用户密码

```sql
-- 修改 root 用户密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'NewPassword' PASSWORD EXPIRE NEVER;
ALTER USER 'root'@'%' IDENTIFIED BY 'NewPassword' PASSWORD EXPIRE NEVER;

-- 刷新当前服务权限
flush privileges;
```

## 注意事项

1. ** `MySQL 8` 已经废弃了 `PASSWORD()` 函数改用了 `IDENTIFIED BY 'newPassWord'` 的方式生成加密密码，因此旧版本的设置密码方式不可行了！**

[官方重置密码文档]([https://dev.mysql.com/doc/refman/8.0/en/set-password.html)提供了两种方式：

- `ALTER` 方式（可以同步设置密码过期策略、自定义密码）：`ALTER USER 'username'@'host' IDENTIFIED BY 'NewPassword' [PASSWORD EXPIRE NEVER];`
- `SET PASSWORD` 方式（可以生成随机强密码，适合生产但需要额外设置密码的过期策略）：`SET PASSWORD [FOR 'user'@'host' ] {= '自定义密码' | TO RANDOM - 随机密码}`

![set password for user to random](/images/article/mysql-set-pwd-to-random.png)

**不管使用哪种方式重置密码，最后都要记得执行 `flush privileges;` 刷新当前服务的权限列表！**

2. **[`MySQL` 的密码管理机制](https://dev.mysql.com/doc/refman/8.0/en/password-management.html)中用户的密码默认是有期限的**，若用户密码过期了，即使用户登录完成后是无法执行任何 `DDL` 语句的，否则会报错：`ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executin`。

要[关闭 `Password Expiration Policy` 机制](https://dev.mysql.com/doc/refman/8.0/en/password-management.html#password-expiration-policy)，也提供了两个方式：

- 方式1-修改单用户密码永不过期 `ALTER USER 'user'@'host' PASSWORD EXPIRE NEVER`
- 方式2-修改 `my.cnf` 配置文件，全局设置用户密码不过期

```conf
[mysqld]
default_password_lifetime=0
```