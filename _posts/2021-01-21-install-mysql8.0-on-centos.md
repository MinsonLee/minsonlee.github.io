---
layout: post
title: MySQL 8.0.23 源码安装
date: 2021-01-21
tags: [MySQL]
---

`MySQL 8.0` 也出了有一段时间了，最新版 `MySQL 8.0.23` 在 `2021-01-18` 发布，来尝尝鲜！

- 系统： `CentOS7` 或 `Ubuntu 20` （Ubuntu 只需将 `yum` 替换成 `apt-get` 即可）
- 数据库版本： `MySQL 8.0.23`

## 1. 安装必要依赖

```
yum install gcc gcc-c++ gcc-g77 make autoconf automake ncurses ncurses-devel openssl openssl-devel bison cmake cmake3 -y
```

**！！！注意： `MySQL 8.0.x` 对 `GCC` 依赖的版本需要 `5.3+`，因此安装好依赖后请使用`gcc --version`检查一下！**

![gcc -version](/images/article/gcc-version.png)

若 `gcc` 版本低于 `5.3+`，可通过下述将 `gcc`升级到 `8.0.x` 版本（升级方法来源：[CentOS7.7快速升级gcc到8.x版本](https://mhl.xyz/Linux/update-gcc.html)）

```sh
# 1. 安装scl源
yum install centos-release-scl scl-utils-build -y

# 2. 确认scl可用源（有对应信息即可）
yum list all --enablerepo='centos-sclo-rh' | grep "devtoolset-"

# 3. 升级 gcc
yum install devtoolset-8-toolchain -y

# 4. 将 `gcc 8.0.x` 设为默认开启版本
echo "source /opt/rh/devtoolset-8/enable" >>/etc/profile
```

## 2. 创建对应 `mysql` 用户&&用户组

```sh
# 1. 创建 `mysql` 用户组
groupadd mysql

# 2. 创建 `mysql` 用户：隶属mysql组，禁止 `shell` 登录
useradd -r -g mysql -s /bin/false mysql
```

## 3. 下载源码并初始化数据库

**注意：**
1. `MySql 8.0.23` 版本的源码包格式变为了 `tar.xz`，不再是 `tar.gz`！
2. 下载源码前，[确认自己的 `glibc` 版本](https://dev.to/0xbf/how-to-get-glibc-version-c-lang-26he)
3. 如果你下载的版本跟本文不一致，需自行修改下述命令中含有的版本信息

![how to show glibc version](/images/article/glibc-version.png)

![how to get the latest mysql server source code](/images/article/how-to-get-mysql-server-source.gif)

1. 下载并解压源码包

```sh
# 下载
cd /tmp && wget -c https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar.xz
# 解压
tar xvf mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar.xz
```

2. 创建 `mysql` 的 `basedir` 、 `data` 、 `logs` 目录

```sh
mkdir -p /apps/mysql # basedir 目录：放置 mysql 安装信息
mkdir -p /apps/mysql/conf/my.cnf.d # basedir 目录：放置 mysql 配置信息
mkdir -p /data/mysql # data 目录：放置 mysql 磁盘存储信息
mkdir -p /data/logs/mysql # logs 目录：放置 mysql_error.log、mysql_slow.log、mysql_binlog 等日志信息
```

3. 为上述目录赋权

```sh
chown -R mysql:mysql /apps/mysql /data/mysql /data/logs/mysql
chmod 0750 -R /apps/mysql /data/mysql /data/logs/mysql
```

4. 初始化数据信息：会生成 `root@localhost` 的密码，注意记录！

注意： `MySQL 8.0.X` 版本的初始化已经弃用了 `mysql_install_db` 脚本，而是通过 `mysqld --initialize` 或 `mysqld --initialize-insecure` 的方式进行初始化安装！

![mysql-remove-mysql_install_db](/images/article/mysql-remove-mysql_install_db.png)

```sh
mv /tmp/mysql-8.0.23-linux-glibc2.17-x86_64-minimal/* /apps/mysql/

# 初始化数据库（如下图，初始密码：DtNquE8Yn-kX）
/apps/mysql/bin/mysqld --initialize --user=mysql --basedir=/apps/mysql --datadir=/data/mysql

# 为 mysql 生成 `SSL/RSA` 证书信息
/apps/mysql/bin/mysql_ssl_rsa_setup --datadir=/data/mysql/
```

![mysqld-initialize](/images/article/mysqld-initialize.png)

## 4. 启动服务并设置开启自动启动服务

1. 编辑 `/etc/my.cnf` 配置文件

```conf
[client]
port=3306 # 指定端口
socket=/data/mysql/mysql.sock # 指定 mysql 客户端的 sock 文件路径

[mysqld]
basedir=/apps/mysql # 指定 mysql 的安装路径
datadir=/data/mysql # 指定mysql 的 data 路径
socket=/data/mysql/mysql.sock # 指定 mysqld 生成的 sock 文件路径

[mysqld_safe]
log-error=/data/logs/mysql/error.log # 指定 mysql 的错误日志
pid-file=/data/mysql/mysqld.pid # 指定 mysql.pid 文件路径

#
# 自定义包含用户 mysql 配置文件夹
#
!includedir /apps/mysql/conf/my.cnf.d
```

注意： `[client]` 下的 `socket` 配置和 `[mysqld]` 下的 `socket` 配置，两者一定要一样！否则，可能在 `mysqld` 服务启动后， `mysql` 一直连接不上并报错： `ERROR 2020 (HY000) : Can't connect to local MySQL Server through socket '/tmp/mysql.socket' (111)`

![Can't connect to local MySQL Server through socket](/images/article/mysql-error-can-not-connect-to-local-MySQL-Server-through-socket.png)

2. 创建对应的 `log` 文件

> `MySQL` 竟然不会自动创建配置文件中的 `log` 文件，这个操作真是非常奇怪

![error.log Can't creatable](/images/article/mysql-error-error.log-can-not-creatable.png)

```
# 创建文件
touch /data/logs/mysql/error.log /data/mysql/mysqld.pid
# 赋权
chown mysql:mysql /data/logs/mysql/error.log
```

3. 使用 `mysqld_safe` 启动服务

```sh
/apps/mysql/bin/mysqld_safe --user=mysql &
```

![bin/mysqld_safe --user=mysql &](/images/article/mysqld_safe_start.png)

**问题：[`mysqld` 与 `mysqld_safe` 的区别？](https://developer.aliyun.com/article/576694)**

在看[`MySQL 8.0`官方安装介绍文档](https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html)的时候，看到文档中启动 `mysqld` 的服务是通过 `mysqld_safe` 来启动的，当时觉得很奇怪： `mysqld` 与 `mysqld_safe` 的有什么区别呢？查了一下资料后，总结就是： `mysqld_safe` 脚本会在启动 `MySQL` 服务器后继续监控其运行情况，并在 `mysqld` 死机时重新启动它，而 `mysqld` 则不会监控自动重启，因此：直接运行 `mysqld` 启动 `MySQL` 服务的方法很少见，更加推荐 `mysqld_safe` 的方式来启动服务！

`mysqld_safe`通常做如下事情：
- 检查系统和选项。
- 检查 `MyISAM` 表。
- 保持 `MySQL` 服务器窗口。
- 启动并监视 `mysqld`，如果因错误终止则重启。
- 将 `mysqld` 的错误消息发送到 `error.log` 文件。
- 将 `mysqld_safe` 的屏幕输出发送到数据目录中的 `host_name.safe` 文件

## 5. 登录服务并设置允许远程连接

1. 通过 `mysql` 客户端连接登录，输入初始密码后，若成功及表示安装已经初步成功！

```sh
/apps/mysql/bin/mysql -u root -p
```

![bin/mysql -u root -p](/images/article/mysql-login-by-root%40localhost.png)

2. 修改 `root@localhost` 的初始化密码且 `root` 密码永不过期

```sh
ALTER USER 'root'@'localhost' IDENTIFIED BY 'testmysql8' PASSWORD EXPIRE NEVER;
```

必须先修改初始密码，后续才能执行指令，否则会报错：`ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.`

![You must reset your password using ALTER USER statement before executing this statement](/images/article/mysql-error-without-change-initialize-pwd.png)

3. 设置允许用户远程登录

初步安装成功后，默认所有的用户都是只允许从 `localhost` 连到本机 `MySQL` 服务上的，非本机连接服务会报错：`Host is not allowed to connect to this MySQL server"`

![xxx is not allowed to connect to this MySQL server](/images/article/mysql-error-not-allowed-to-connect-to-mysql-server.png)

- 方式一：直接修改 `root` 用户的 `host` 信息

```sh
# 更改 `root` 用户 `host` 为不限制
update mysql.user set host = '%' where user = 'root';

# 刷新当前mysql链接服务权限
flush privileges;
```

![update mysql.user host](/images/article/mysql-update-user-host.png)

- 方式二：（推荐）新增一个不限制 `host` 连接的 `root` 用户（[MySQL用户管理](https://dev.mysql.com/doc/refman/8.0/en/account-management-statements.html)）

```sh
# 创建不受限制的用户 `root`@'%'
CREATE USER 'root'@'%' IDENTIFIED BY 'root';

# 授予用户所有权限
GRANT ALL ON *.* TO 'root'@'%';

# 刷新当前mysql链接服务权限
flush privileges;
```

![create new user and grant privileges](/images/article/mysql-create-user-and-grant-privileges.png)

## 6. 设置 `mysql` 系统变量及设置服务开机启动

```sh
# 设置 `mysql` 系统变量
echo 'export PATH=$PATH:/usr/local/mysql/bin' >> /etc/profile
# 重新加载当前进程 peofile
source /etc/profile
```

```sh
# 将 `mysql.server` 复制到系统初始化服务目录：即将其设置为系统服务，后续就可以通过 `service mysql start/stop/restart` 管理服务
cp /apps/mysql/support-files/mysql.server /etc/rc.d/init.d/mysql
# 赋予其可执行权限
chmod +x /etc/rc.d/init.d/mysql

# vim /etc/rc.d/init.d/mysql，设置 mysql basedir 和 mysql datadir
basedir=/usr/local/mysql
datadir=/data/mysql

# 设置开机启动
chkconfig mysql on
```