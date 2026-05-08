# MySQL 8 从入门到“感冒”

- [儒猿：从零开始带你成为MySQL实战优化高手学员笔记]( https://docs.qq.com/doc/DV3VHU1pBWmJKSGRR)
- [为什么要旗帜鲜明地反对 orm 和 sql builder](https://mp.weixin.qq.com/s/5DIRKlWpr3pwx2h5YJhnAQ)
- [MySQL 唯一索引 UNIQUE KEY 会导致死锁？](https://blog.csdn.net/agonie201218/article/details/123852659)


----


[TOC]

- MySQL 发展历史：https://www.cnblogs.com/YangJiaXin/p/13800134.html 、 https://blog.51cto.com/wangwei007/2495496 、 https://en.wikipedia.org/wiki/MySQL

- SQL 优化：https://dev.mysql.com/doc/refman/8.0/en/optimization.html

## `CentOS` 安装 `MySQL 8.0.23`

- 系统： `CentOS7` 或 `Ubuntu 20` （Ubuntu 只需将 `yum` 替换成`apt-get`即可）
- 数据库版本：[ `MySQL 8.0.23` ](https://dev.mysql.com/doc/refman/8.0/en/)

### 1. 安装必要依赖

```
yum install gcc gcc-c++ gcc-g77 make autoconf automake ncurses ncurses-devel openssl openssl-devel bison cmake cmake3 -y
```

**！！！注意： `MySQL 8.0.x` 对 `GCC` 依赖的版本需要 `5.3+`，因此安装好依赖后请使用`gcc --version`检查一下！**

![image](077E3EADAEEC4D67B6EE020BFE53A97D)

若 `gcc` 版本低于 `5.3+`，可通过下述将 `gcc` 升级到 `8.0.x` 版本（升级方法来源：[CentOS7.7快速升级gcc到8.x版本](https://mhl.xyz/Linux/update-gcc.html)）

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

### 2. 创建对应 `mysql` 用户&&用户组及目录

```sh
# 1. 创建 `mysql` 用户组
groupadd mysql

# 2. 创建 `mysql` 用户：隶属mysql组，禁止 `shell` 登录
useradd -r -g mysql -s /bin/false mysql
```

### 3. 下载源码并初始化数据库

**注意：**
1. `MySql 8.0.23` 版本的源码包格式变为了 `tar.xz`，不再是 `tar.gz`！
2. 下载源码前，[确认自己的 `glibc` 版本](https://dev.to/0xbf/how-to-get-glibc-version-c-lang-26he)
3. 如果你下载的版本跟本文不一致，需自行修改下述命令中含有的版本信息

![image](253B669AA3484170AE66F5E558C6805D)

![如何获取MySQL最新下载链接](96B3898C4D134F1B84719A3282183ED2)

1. 下载并解压源码包

```sh
# 下载
cd /tmp && wget -c https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar.xz
# 解压
tar xvf mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar.xz
```

2. 创建 `mysql` 的 `basedir`、 `data`、 `logs` 目录

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

![image](40C8A6E1EE85407C82CBD34CDFAF28D9)

```sh
mv /tmp/mysql-8.0.23-linux-glibc2.17-x86_64-minimal/* /apps/mysql/

# 初始化数据库（如下图，初始密码：DtNquE8Yn-kX）
/apps/mysql/bin/mysqld --initialize --user=mysql --basedir=/apps/mysql --datadir=/data/mysql

# 为 mysql 生成 `SSL/RSA` 证书信息
/apps/mysql/bin/mysql_ssl_rsa_setup --datadir=/data/mysql/
```

![image](F3369071456448808F5C1EB8B31868EB)

### 4. 启动服务并设置开启自动启动服务

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

注意：`[client]`下的 `socket` 配置和`[mysqld]`下的 `socket` 配置，两者一定要一样！否则，可能在 `mysqld` 服务启动后，`mysql` 一直连接不上并报错：`ERROR 2020 (HY000) : Can't connect to local MySQL Server through socket '/tmp/mysql.socket' (111)`

![image](DF0AA9C3543D42FFB4848FC84A15CEAF)

2. 创建对应的 `log` 文件

> `MySQL` 竟然不会自动创建配置文件中的 `log` 文件，这个操作真是非常奇怪

![image](86275A276DF049699478BD57F7701658)

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

![image](1DE64936E382438397ABB68BE55E0C86)

**问题：[ `mysqld` 与 `mysqld_safe` 的区别？](https://developer.aliyun.com/article/576694)**

在看[ `MySQL 8.0` 官方安装介绍文档](https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html)的时候，看到文档中启动 `mysqld` 的服务是通过 `mysqld_safe` 来启动的，当时觉得很奇怪： `mysqld` 与 `mysqld_safe` 的有什么区别呢？查了一下资料后，总结就是： `mysqld_safe` 脚本会在启动 `MySQL` 服务器后继续监控其运行情况，并在 `mysqld` 死机时重新启动它，而 `mysqld` 则不会监控自动重启，因此：直接运行 `mysqld` 启动 `MySQL` 服务的方法很少见，更加推荐 `mysqld_safe` 的方式来启动服务！

`mysqld_safe` 通常做如下事情：
- 检查系统和选项。
- 检查 `MyISAM` 表。
- 保持 `MySQL` 服务器窗口。
- 启动并监视 `mysqld`，如果因错误终止则重启。
- 将 `mysqld` 的错误消息发送到 `error.log` 文件。
- 将 `mysqld_safe` 的屏幕输出发送到数据目录中的 `host_name.safe` 文件

### 5. 登录服务并设置允许远程连接

1. 通过 `mysql` 客户端连接登录，输入初始密码后，若成功及表示安装已经初步成功！

```sh
/apps/mysql/bin/mysql -u root -p
```

![image](616C60B8B69C4A38997BC5B99857438D)

2. 修改 `root@localhost` 的初始化密码且 `root` 密码永不过期

> mysql-5.7 密码过期详解：https://www.cnblogs.com/JiangLe/p/7655165.html

```sh
ALTER USER 'root'@'localhost' IDENTIFIED BY 'testmysql8' PASSWORD EXPIRE NEVER;
```

必须先修改初始密码，后续才能执行指令，否则会报错：`ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.`

![image](E20A0AD3FC9B4D67B3BD21E98B01C1FD)

3. 设置允许用户远程登录

初步安装成功后，默认所有的用户都是只允许从 `localhost` 连到本机 `MySQL` 服务上的，非本机连接服务会报错：`Host is not allowed to connect to this MySQL server"`

![image](590EF7FADF1E4F3AB7D22E8383296120)

- 方式一：直接修改 `root` 用户的 `host` 信息

```sh
# 更改 `root` 用户 `host` 为不限制
update mysql.user set host = '%' where user = 'root';

# 刷新当前mysql链接服务权限
flush privileges;
```

![image](D5FCBBACA6D940609DE4ABC6637C9DC2)

- 方式二：（推荐）新增一个不限制 `host` 连接的 `root` 用户（[MySQL用户管理](https://dev.mysql.com/doc/refman/8.0/en/account-management-statements.html)）

```sh
# 创建不受限制的用户-`root` @'%'
CREATE USER 'root'@'%' IDENTIFIED BY 'root';

# 授予用户所有权限
GRANT ALL ON *.* TO 'root'@'%';

# 刷新当前mysql链接服务权限
flush privileges;
```

![image](0B6C3637DB4C4BEC8EAD75CD3D7D5D7E)

### 6. 设置 `mysql` 系统变量及设置服务开机启动

```sh
# 设置 `mysql` 系统变量
echo 'export PATH=$PATH:/usr/local/mysql/bin' >> /etc/profile
# 重新加载当前进程 peofile
source /etc/profile
```

```sh
# 将 `mysql.server` 复制到系统初始化服务目录
# 即将其设置为系统服务，后续就可以通过系统服务方式管理服务：
# `service mysql {start|stop|restart|status}` 或
# `systemctl {start|stop|restart|status} mysql` 
cp /apps/mysql/support-files/mysql.server /etc/rc.d/init.d/mysql
# 赋予其可执行权限
chmod +x /etc/rc.d/init.d/mysql

# vim /etc/rc.d/init.d/mysql，设置 mysql basedir 和 mysql datadir
basedir=/usr/local/mysql
datadir=/data/mysql

# 设置开机启动
chkconfig mysql on
```

### 7. 停止/重启 mysqld 服务

如果你是通过系统服务（service 或 systemctl）的方式启动服务，那么可以通过

```shell
# start-启动服务|stop-停止服务|restart-重启服务|status-查看服务状态

service mysql {start|stop|restart|status}
systemctl {start|stop|restart|status} mysql 
```

如果是通过 `mysqld_safe` 方式启动的一个后台常驻进程，那么需要通过下述方式来关闭服务进程

> MySQL 启动脚本：https://gohalo.me/post/mysql-mysqld-safe.html

```shell
/apps/mysql/bin/mysqladmin -uroot -p shutdown
```

![mysqladmin shutdown](7176BC63C23349A1B57827AFF9DE1CA7)

## MySQL 8 重置密码

在安装 `MySQL` 的过程中有一个初始化数据库的操作：`mysqld --initialize`或`mysqld --initialize --console`，这个操作中会生成一个 `MySQL` 用户： `root@localhost`，同时还有其初始化密码，要记下！要记下！要记下！

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

![select users](64089DB9E79348C78D37328063580BFA)

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

### 注意事项

1. **`MySQL 8` 已经废弃了 `PASSWORD()` 函数改用了 `IDENTIFIED BY 'newPassWord'` 的方式生成加密密码，因此旧版本的设置密码方式不可行了！**

[官方重置密码文档]([https://dev.mysql.com/doc/refman/8.0/en/set-password.html)提供了两种方式：

- `ALTER` 方式（可以同步设置密码过期策略、自定义密码）：`ALTER USER 'username'@'host' IDENTIFIED BY 'NewPassword' [PASSWORD EXPIRE NEVER];`
- `SET PASSWORD` 方式（可以生成随机强密码，适合生产但需要额外设置密码的过期策略）：`SET PASSWORD [FOR 'user'@'host' ] {= '自定义密码' | TO RANDOM - 随机密码}`

![image](2A741A8DBC814390A3E9C9303D6A64A9)

**不管使用哪种方式重置密码，最后都要记得执行 `flush privileges;` 刷新当前服务的权限列表！**

2. **[ `MySQL` 的密码管理机制](https://dev.mysql.com/doc/refman/8.0/en/password-management.html)中用户的密码默认是有期限的**，若用户密码过期了，即使用户登录完成后是无法执行任何 `DDL` 语句的，否则会报错：`ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executin`。

要[关闭 `Password Expiration Policy` 机制](https://dev.mysql.com/doc/refman/8.0/en/password-management.html#password-expiration-policy)，也提供了两个方式：

- 方式1-修改单用户密码永不过期 `ALTER USER 'user'@'host' PASSWORD EXPIRE NEVER`
- 方式2-修改 `my.cnf` 配置文件，全局设置用户密码不过期

```conf
[mysqld]
default_password_lifetime=0
```

## `MySQL` 命令行客户端神器 - `mycli`

`MySQL` 的客户端很多首推 `Navicat`，但工作中总是避免不了要在漆黑的命令行下操作 `MySQL`，使用其自带的 `mysql-client` 工具体验并不算太好。

`MyCLI` 是一款使用 `python` 语言开发的支持 `MySQL`、 `MariaDB` 和 `Percona` 数据库的终端工具，具有提示、自动补全、使用高危命令时二次确认等等人性化的功能。同时 `mycli` 命令完全继承了 `mysql` 命令中的参数，因此熟悉 `mysql` 的人都能快速上手使用，学习成本低！

`MyCLI` 基于 `Python` 开发，因此安装 `MyCLI` 需要先安装 `Python` 和 `Python` 包管理器-`Pip`。

1. [查看是否安装 python](https://www.runoob.com/python3/python3-install.html)

```sh
python --version
```

2. [查看是否安装 pip](https://www.runoob.com/w3cnote/python-pip-install-usage.html)

```sh
pip --version
```


3. [安装 `mycli` ](https://www.mycli.net/install)

```sh
pip install mycli
```

![mycli-install-verify.png](1C3E61B9C77C492C93BF36FC1E7819EF)

`MyCLI` 对应文档，个人觉得是非常好：简单、明了！没有像其他手册一样，长篇大论，一股脑子输出，详细使用可查看下述文档或输入 `mycli --help` 查看帮助说明，不再赘述！

- `MyCLI` 的官网：[https://www.mycli.net/](https://www.mycli.net/)
- `MyCLI` 的手册：[https://www.mycli.net/docs](https://www.mycli.net/docs)
- `MyCLI` 的配置文件说明：[https://www.mycli.net/config](https://www.mycli.net/config)【首次使用 `mycli` 时会自动创建`~/.myclirc`】
- 网易游戏基础架构平台-知乎介绍（中文简介）：https://zhuanlan.zhihu.com/p/101697361


## 数据库知识小记

### 1. 什么是数据库？

数据库，又叫做“数据管理系统”-就是一个**存储**和**管理**数据的仓库系统！大致可以划分为：关系型数据库（RDS）和非关系型数据库-NoSQL（Not Only SQL）。数据库 = 数据库引擎服务 + 数据库查询程序 + 数据库客户端。

非关系数据库没有统一固定的数据结构类型，但是关系型数据库一般都是通过二维表结构的方式组织存放数据的：由 “表” 组建成一个 “库”，由多个 “库” 组建为一个数据库服务。

关于 `NoSQL` 的小记可以看看左耳朵耗子译过来的一篇文章：[ `NoSQL` 数据建模技术](https://coolshell.cn/articles/7270.html)。

#### 数据库引擎服务

数据库引擎服务是指提供给客户端连接，便于客户端和数据仓库相互操作的一个程序。一般来说这个服务程序都需要设置为随系统自动启动并运行在后台。数据库引擎服务可以说就是“数据与客户端之间的门户”！

例如： `MySQL` 的 `mysqld` 程序；`MS SQLServer` 的 `sqlserver.exe` 或 `sqlserver` 程序。

![mysql-ps-grep-mysqld.png](D34AC2DACD7F4AE3B54C53E9ADCCB91C)

![sqlserver-services.png](164E1A7C5B4741E695176A2D84C9AED3)

#### 数据库查询程序

每种数据库都有其自己的查询语言（获取数据的手段），非关系型数据库的语句各不相同，但绝大部分的关系型数据库服务都是支持通过结构化查询语句-`SQL` 来查询获得数据的（语法上可能有差异，但总的来说都是大同小异，言简意赅）。

数据库查询程序一般来说都包含：数据库查询解析器、查询优化器、查询执行程序，它们的职责就是：将用户传入的查询语句解析、优化、执行、统计等操作，最后将得到的结构返回给数据库引擎服务。

#### 数据库客户端

数据库客户端是**提供给用户操作**的前台程序，可以说是“用户与数据库服务引擎沟通的门户”！这类工具可就多了，例如： `MySQL` 自己提供的 `mysql` 命令行客户端程序、 `Navicat`-支持连接多种数据库的 `GUI`、PHP 编写的 `phpmyadmin`、Python 编写的 `mycli` 等等。


### 2. 什么是 SQL ？

`SQL` 的全程是： `Structured Query Language`-结构化查询语言。它 是一种编程术语，基于**集合论和关系代数**进行**集合运算**（如并集，交集和差级等）以达到**描述（组织和检索）**关系数据库中的信息。

`SQL` 是一种 `What` 类型语言，即：你告诉我你想要什么东西，我直接给你，你不需要关心我到底是怎么组织、怎么描述、从什么地方拿、做了什么操作...你只需要关心我给你的结果是不是你想要拿的即可！

这与其他的编程式的 `How` 类型语言不一样，即：你想要得到什么结果需要你自己亲力亲为从头到尾设计、生产、获取、组织、执行才能得到结果，你需要参与整个过程中大部分的环节和所有决定性的细节点。如：使用 `PHP`、 `Go`、 `Java`、 `Python` 获取一段数据，你需要自己编程设计实现所有的细节，才能得到结果。

`SQL` 语句按照功能进行划分，可简略分为： `DML`、 `DDL`、 `DCL` 三类语句。

- [`DML-Data Manipulation Languages`](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_dml)-数据库操作语言：绝大部分都是在使用 `DML` 语句。如：增删改查操作，相当于工地里“工人”的角色，充当“使用者”的角色（详情点击：[Data Manipulation Statements](https://dev.mysql.com/doc/refman/8.0/en/sql-data-manipulation-statements.html)）
- [`DDL-Data Definition Language`](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_ddl)-数据定义语言：小部分人使用 `DDL` 语句，用来定义数据库中所有的对象。如：建库、建表、建视图、建索引...，相当于工地里“工头、设计师”的角色，充当“建设者”的角色（详情点击：[Data Definition Statements](https://dev.mysql.com/doc/refman/8.0/en/sql-data-definition-statements.html)）
- [`DCL-Data Control Language`](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_dcl)-数据控制语言：用于授予或回收访问数据库的权限、控制数据库操作事务发生的时间及效果、对数据库实行监视...等操作，相当于工地里“项目经理、监工”的角色，充当“管理者”的角色（详情点击：[Database Administration Statements](https://dev.mysql.com/doc/refman/8.0/en/sql-server-administration-statements.html)）

## `MySQL` 操作语句记录

- `system clear`：实现 `MySQL` 终端清屏
- `mysql -h host_or_ip -P port -u user -p[password] [ database]`：连接数据库并切换
- `show databases;`：查看 `MySQL` 服务中所有的数据库
- `use database;`：更改操作的数据库对象
- `show tables;`：查看该操作数据库对象中所有的数据表名称和视图名称
- `desc table_name/view_name;`：查看表/视图结构信息-列名、列类型、是否为 `NULL`、索引类型、默认值、扩展属性
- `show create database <database>;`：查看当前建库 `SQL` 语言
- `show create table <table>;`：查看建表 `SQL` 语句
- `\c`：取消执行当前输入 `mysql` 语句
- `G`：垂直分模块展示结果（非常喜欢）
- `show table status [where name = table_name [\G]];`：查看数据库中表的信息
- `truncate table_name;`：清空表数据（表结构不变，主键起始值会被重置为0，和 `delete from table_name` 是不同的）
- `RENAME TABLE tableA To tableB;`：修改表名
- `drop table table_name;`：删除表
- `drop view view_name;`：删除视图
- `ALTER TABLE <table> ADD INDEX <idex_name> (cols) USING BTREE COMMENT '<idex_comment>';`：添加索引
- `ALTER TABLE <table> DROP INDEX <idex_name>;`：删除索引


## 数据库的导入/导出

见文章：MySQL大量数据导入导出


## SQL-DML部门

1. 测试 `SQL` 语句准备：[点击下载](https://minsonlee.github.io/attaching/test-mysql.sql)

```sh
wget -O /tmp/test-mysql.sql https://minsonlee.github.io/attaching/test-mysql.sql
```

2. 导入 `MySQL`
```sh
# 登录mysql，切换到 `test` 库（没有创建提前创建）：CREATE DATABASE `test` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
mysql -u root -p test

# 执行 sql 文件，导入数据
source /tmp/test-mysql.sql 
```

![source file.sql](715B0E748FFC446A9E97F6F25142BF3B)

详细的 SQL 语法文档，见：[https://dev.mysql.com/doc/refman/8.0/en/sql-statements.html](https://dev.mysql.com/doc/refman/8.0/en/sql-statements.html)

### `DML` 基础语句

- 新增-`INSERT` :`INSERT INTO <table> (col1, col2,....) values (value1, value2,....)`-"插入值"与"列"要一一对应
- 删除-`DELETE`：`DELETE from <table> [where <expression>];`-**一般来说工作中删除操作是必须携带 `where` 条件限制的**
- 更新-`UPDATE`：`UPDATE <table> set <key=value>[, <key2=value2>..] [where <expression>];`-更新指定列，**一般来说工作中更新操作是必须携带 `where` 条件限制的**
- 查询-`SELECT`：`SELECT (col1, col2,...,or function) FROM <table> [WHERE <expression>] [GROUP BY <cols>] [HAVING <expression>] [ORDER BY <col> ASC|DESC] [LIMIT 0,100]`-**查询遇到最多的就是查询优化问题-也是重点！！！**

**注意：更新和删除操作一定要记得检查 `WHERE` 条件，除非对生活心灰意冷了否则还是加上比较好！即使真的是需要影响整个表的数据也加上，养成写上 `WHERE` 条件，检查 `WHERE` 条件再执行的好习惯！**

#### SELECT 查询语句

`SELECT` 查询有 5 种子句:
- `WHERE` 子句：条件查询-`WHERE <expression>`
- `GROUP BY` 子句：分组查询-`GROUP BY <cols>`
- `HAVING` 子句：筛选查询-`HAVING <expression>`
- `ORDER BY` 子句：排序查询-`ORDER BY <cols> ASC|DESC`
- `LIMIT` 子句：范围查询-`LIMIT <start>,<end>`


1. **注意：5 种子句在书写 `SQL` 的时候是有严格顺序的： `where` > `group by` > `having` > `order by` > `limit`**
2. **列相当于“变量”，可以进行计算！**

关系型数据库是通过二维表的方式进行组织数据：一**行**代表**一条完整的记录**，一**列**代表**同一类数据**！

所有的数据都是按照“列”的关系进行组织，然后按照“行”的形式进行存储，从编程语言的角度来说：列相当于变量，而行相当于变量的值！

变量是统计学中引入的概念，它的定义如下：它表示数字的字母字符，具有任意性和未知性。 把变量当作是显式数字一样，对其进行代数计算，可以在单个计算中解决很多问题！

因此：列也具备同样的作用：可以进行代数计算！

如：从 `user` 表中查找所有 `uid`、 `name`、 `age` 三列，并给 `age` 列所在值进行加一操作！
```sql
select uid, name, age+1 from user;
```

![mysql-select-colum-as-param.png](08FCC01843D64B2FAD182718A63D5A86)

如图对列进行代数计算，语句是可以正常执行的！

`SELECT` 语句还可以配合算数运算符、逻辑运算符和位运算符以及相关函数写出更高效率的查询语句（注意运算符的优先级）！

##### WHERE 条件查询子句

条件运算在很多程序设计语言中都是存在的，其结果是布尔型，只有两种情况：真-true，假-false！

> 关于条件语句，PHP核心开发者鸟哥的博客有一篇文章-[一个关于if else容易迷惑的问题](https://www.laruence.com/2020/07/09/6015.html) 提到一句话：**这个世界上本无 `elseif`，有的只不过是 `else (if statement)`**，对条件运算的结果阐释的非常到位！

![mysql-select-where-true-or-false.png](B601208073C0496FBAC1022490FA2944)

- 查询出第4号、第11号商品的名称、价格

```sql
select goods_id,goods_name,shop_price from goods where goods_id in(4, 11);
```

![mysql-select-where-in.png](215149E1A1754750A153ED86964B28F0)

- 查询出第4号到第11号之间商品的名称、价格

```sql
select goods_id,goods_name,shop_price from goods where goods_id between 4 and 11;
```

![mysql-select-where-between-and.png](B89BB941DFB14480A12241955F526968)

`SELECT` 可以使用 `LIKE` 运算符进行模糊查询：`%`-通配任意长度任意字符；`_`-通配单一任意字符

- 取出名字以"诺基亚"开头的商品

```sql
select goods_id,goods_name,shop_price from goods where goods_name like '诺基亚%';
```

![mysql-select-where-like-%](962B17474B9141019C4F37F91141B4A1)

- 取出名字为"诺基亚Nxx"的手机

```sql
select goods_id,goods_name,shop_price from goods where goods_name like '诺基亚N__';
```

![mysql-select-where-like-_](04CF011082454956984D574923E1F95A)

- 取出名字不以"诺基亚"开头的商品

```sql
select goods_id,goods_name,shop_price from goods where goods_name not like '诺基亚%';
```

![mysql-select-where-not-like](BE5160267E8B42B0A0C24AB07551F168)

当涉及到多重条件查询可以使用逻辑运算符： `AND`、 `OR`、 `NOT`...之类的来修饰条件时候，不管是 `SQL` 还是其他编程语言，多重条件一定要注意运算符的优先级问题，建议使用括号`()`将条件进行分类，避免优先级问题！

###### 算数运算符

| 运算符 | 描述 | 
| ------ | ---- |
| + | 加法 |
| - | 减法 |
| * | 乘法 |
| / | 除法 |
| % | 取模（取余数） |


###### 比较运算符

| 运算符 | 描述 |
| ------ | ---- |
| = | 检查两个操作数的值是否相等，如果是，则条件为真(true) |
| != | 检查两个操作数的值是否相等，如果值不相等则条件为真(true) |
| <> | 检查两个操作数的值是否相等，如果值不相等则条件为真(true) |
| > | 检查左操作数的值是否大于右操作数的值，如果是，则条件为真(true) |
| < | 检查左操作数的值是否小于右操作数的值，如果是，则条件为真(true) |
| >= | 检查左操作数的值是否大于或等于右操作数的值，如果是，则条件为真(true) |
| <= | 检查左操作数的值是否小于或等于右操作数的值，如果是，则条件为真(true) |
| !< | 检查左操作数的值是否不小于右操作数的值，如果是，则条件变为真(true) |
| !> | 检查左操作数的值是否不大于右操作数的值，如果是，则条件变为真(true) |

###### 逻辑运算符

| 运算符 | 描述 | 
| ------ | ---- |
| AND | AND 运算符允许在SQL语句的WHERE子句中指定多个条件 |
| OR | OR 运算符用于组合SQL语句的WHERE子句中的多个条件 |
| BETWEEN | BETWEEN 运算符用于搜索在给定范围内的值 |
| LIKE | LIKE 运算符用于使用通配符运算符将值与类似值进行比较 |
| IS NULL | IS NULL 运算符用于将值与NULL值进行比较 |
| IN | IN 运算符用于将值与已指定序列的值列表进行比较 |
| EXISTS | EXISTS 运算符用于搜索指定表中是否存在满足特定条件的行 |
| NOT | NOT 运算符反转使用它的逻辑运算符的含义。 例如：NOT EXISTS, NOT BETWEEN, NOT IN, IS NOT NULL 等等，这是一个否定运算符 |
| ANY | ANY 运算符用于根据条件将值与列表中的任何适用值进行比较 |
| ALL | ALL 运算符用于将值与另一个值集中的所有值进行比较 |
| UNIQUE | UNIQUE 运算符搜索指定表的每一行的唯一性(无重复项) |

对于以上提到的绝大部分运算符都很好理解，有几个点需要特别注意： `NULL` 值的判断、 `EXISTS` 与 `IN` 的使用区别、 `ALL` 和 `ANY` 的用法、 `BETWEEN` 和 使用 `>` `<` 符号进行判断范围的区别。

**1. `NULL` 值的判断**

`NULL` 表示的是什么都没有，它与空字符串、0 这些是不等价的，是不能用于比较的！
如： `<expr> = NULL` 、 `NULL = ''` 得到的结果为 `false`，判断 `NULL` 必须使用 `IS NULL` 或 `IS NOT NULL` 进行判断。

如下图，在 `result` 表中插入一条含有 `NULL` 值的数据，并针对存在 `NULL` 值的 `subject` 列添加一个索引，进行演示！

```SQL
insert into result values ('王五',NULL,NULL);
ALTER TABLE `test`.`result` ADD INDEX `idx_name`(`name`) USING BTREE COMMENT '索引-用户的所有学科成绩', ADD INDEX `idx_subject`(`subject`) USING BTREE COMMENT '索引-学科所有同学成绩';
```

![mysql-null-demo-table-result](EF7CFE78DC71424F9E5A174921478690)
![mysql-null-where-expr-comper](F6E574F0762841D9962E9B1A10DA14E5)

**数据库建表的时候默认是 `NULL`，但在工作中一般建表的时候都会禁止使用 `NULL` 的！**

1. 不利于代码的可读性和可维护性，特别是强类型语言，查询 `INT` 值，结果得到一个 `NULL`，程序可能会奔溃...如果要兼容这些情况程序往往需要多做很多操作来兜底
2. 若所在列存在 `NULL` 值，会影响 `count()`、 `<col> != <value>`、 `NULL + 1` 等查询、统计、运算情景的结果

**因此：`NULL` 的操作判断不管在数据库、程序中都很麻烦，一般会通过一个有意义的同类型值表示 `NULL` 值**

- [MySQL文档：Problems with NULL Values](https://dev.mysql.com/doc/refman/8.0/en/problems-with-null.html)
- [MySQL文档：Working with NULL Values](https://dev.mysql.com/doc/refman/8.0/en/working-with-null.html)
- [MySQL文档：How MySQL Partitioning Handles NULL](https://dev.mysql.com/doc/refman/8.0/en/partitioning-handling-nulls.html)

**2. `EXISTS` 与 `IN` 的使用区别**

- [SQL EXISTS 运算符](https://www.runoob.com/sql/sql-exists.html)
- [Mysql 之 IN 和 Exists 用法](https://www.cnblogs.com/zhangminghui/p/4403672.html)
- https://www.cnblogs.com/wxw16/p/6105624.html
- https://zhuanlan.zhihu.com/p/37920214
- https://cloud.tencent.com/developer/article/1144244

**3. `ALL` 和 `ANY` 的用法**

- [MySQL中ALL 和 ANY 的用法](https://blog.csdn.net/A_Runner/article/details/103177832)

**4. `BETWEEN` 和 使用 `>` `<` 符号进行判断范围的区别**



###### 面试题：列是变量

一、有如下表和数组，使用一条 `SQL` 语句实现下述要求！
1. 把 `num` 值处于 [20,29] 之间,改为20：`update main set num=20 where num between 20 and 29;`
2. 把 `num` 值处于 [30,39] 之间的,改为30：`update main set num=30 where num between 30 and 39;`

![mysql-where-demo-interview-1.png](5C25C2B6F1AD42C48E738C5DEF2D0B25)

```sql
-- 建表准备数据
create table interview1 ( num int(10) not null default 0) engine=InnoDB CHARSET=utf8mb4;
insert into interview1 (num) values (3), (12), (15), (25), (23), (29), (34), (37), (32), (45), (48), (52);

-- 考察点：对 SQL 的列是变量，可以进行计算的理解，结合基本函数运用！
update interview1 set num = (floor(num/10)*10) where num between 20 and 39;
```

二、将 `goods` 表中商品名为'诺基亚xxxx'的商品,改为'HTCxxxx'！

![mysql-where-demo-interview-2.png](83022057FB684AD6AC537AB99E85234A)

```sql
update goods set goods_name = concat('HTC',substring(goods_name, 4)) where goods_name like '诺基亚%';
```


##### 数据库模式：sql_mode
- [MySQL的sql_mode模式说明及设置](https://www.cnblogs.com/clschao/articles/9962347.html)
- [5.1.11 Server SQL Modes](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html)
- http://www.gramess.com/article/detail/153.html
- https://www.twle.cn/c/yufei/mysqlfav/mysqlfav-basic-sql_mode3.html

###### 什么是数据库模式： sql_mode ？

数据库的 SQL 模式定义了当前数据库（如： MySQL、MSSQLServer）应该支持的 SQL 语法以及应该执行的数据验证检查类型。
这使得在不同环境中使用 MySQL 以及将 MySQL 与其他同样支持 SQL 语法的数据库服务器一起使用更加容易。MySQL 服务器将这些模式分别应用于不同的客户端。

简单来说，即： 

1. SQL 是一个独立的查询语法，没有强制跟任何数据库绑定
2. 绝大多数关系型数据库都支持 SQL 语法的查询语句，但不同类型关系型数据库中解析同一条 SQL 语句所做的校验规则可能稍有不同

基于上述原因：设置不同的数据库模式，可以让数据库使用不同的验证模式对 SQL 语句进行合法校验！

一般来说，在生产环境中是必须将 `sql_mode` 设置为严格模式（`STRICT_TRANS_TABLES`），开发、测试环境的数据库也应当要设置，这样在开发测试阶段就可以发现问题。

###### MySQL 查看 sql_mode ？

`sql_mode` 的设置分为：全局设置-影响设置后所有新连接的客户端、会话设置-只影响当前连接的客户端。

- 查看当前客户端连接的数据库模式

```SQL
-- 查看当前连接的数据库模式
SELECT @@SESSION.sql_mode;

-- 查看当前连接的数据库模式
SELECT @@sql_mode;
```

![mysql-select-session-sql-mode](9E37612AB9354680AEF6C4C16AD255C5)


- 查看全局连接数据库模式

```SQL
-- 查看全局连接的数据库模式
SELECT @@GLOBAL.sql_mode;
```

或查看 `my.cnf` 配置文件，搜索关键词 `sql-mode`，一般数据库安装完毕后配置文件中默认是不显示设置 `sql-mode` 这个配置项的，因此可能找不到！

###### MySQL 修改 sql_mode ?

通过 SQL 语句修改数据库模式
```SQL
SET GLOBAL sql_mode = 'modes';
SET SESSION sql_mode = 'modes';
```

- `SET SESSION sql_mode = 'modes'` 生命周期：只能修改当前数据库客户端所连接的数据库模式，只要当前客户端断开连接那么该设置的生命周期就完结了
- `SET GLOBAL sql_mode = 'modes';` 生命周期：影响当前数据库服务进程所有的客户端连接，但只要当前服务进程被中断或重启后该设置的生命周期就完结了

通过修改 `my.cnf` 配置中的 `sql-mode` 选项

```conf
[mysqld]
#set the SQL mode to strict
sql-mode="modes..."
```

**注意：**

1. 配置是 `sql-mode`，中间使用英文状态的中横线 `-` 连接的，而不是下划线
2. 配置项 `sql-mode` 要放在 `[mysqld]` 下

![image](27CDBB82A93049E5BB45083715C35CEA)

###### 有什么坑？

**1. 不同的数据模式对数据的校验规则不同，因此：强烈建议一旦使用了定义的 `sql_mode` 建表并写入数据后，就不要更改 `sql_mode`**

- 在数据写入表里面以后更改 `sql_mode` 可能会导致表中的数据发生损坏、丢失、默认值被改变等情况！
- 在做数据复制、数据迁移时，最好保持主库和从库的 `sql_mode` 一致，否则可能在复制、迁移过程中会失败或操作完成后两端数据不一致

###### sql_mode 重要模式说明

- `ONLY_FULL_GROUP_BY`：当使用 `GROUP BY` 进行分组查询时，`SELECT` 列、`HAVING` 条件、`ORDER BY` 列必须是聚合列，否则拒绝执行！错误示范，如： `SELECT name, avg(score) as average FROM result GROUP BY name ORDER BY score;`
- `STRICT_TRANS_TABLES`： 对支持事务的存储引擎开启 `SQL` 严格模式。例如：严格模式下对一个非 `NULL` 列插入一个 `NULL` 值是会被拒绝执行的。更多参考：[Strict SQL Mode](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sql-mode-strict)
- `NO_ZERO_IN_DATE`：对于日期数据格式的值，月、日不能为 `0`（该模式基于 `STRICT_TRANS_TABLES` 开启了才有效）。 
    - 注意：该模式对 `0000-00-00` 无效
    - 错误示范：`xxxx-00-00`、`xxxx-00-xx`、`xxxx-xx-00`
- `NO_ZERO_DATE`：对于日期数据格式的值，年不能全为 `0`（该模式基于 `STRICT_TRANS_TABLES` 开启了才有效）。
    - 注意：该模式对 `0000-00-00` 有效
    - 错误示范：`0000-xx-xx`
- `ERROR_FOR_DIVISION_BY_ZERO`： `0` 不能作为被除数用于涉及除法的运算中（包括取模）。
    - MySQL 的文档中明确表示：不推荐使用，且该模式可能后期会直接包含在严格模式中从而被废弃
    - 无论模式是否设置，结果都会返回 NULL，区别在于：设置了该模式会产生一个警告错误
    ![image](39BBA2643C374234AE334B01AD9BFE57)
- `NO_ENGINE_SUBSTITUTION`：若需要的存储引擎被禁用或未编译安装，则抛出错误。没有设置该模式，会使用默认的存储引擎进行替代，并抛出一个异常
- `NO_UNSIGNED_SUBTRACTION`：没有设置该模式的时候，要求：计算两个无符号整数的差值时，其结果一定要为无符号整数（即：结果不能为负数），否则会报错！设置了该模式则不会报错！
    ![mysql-sql-mode-NO_UNSIGNED_SUBTRACTION](D269AED5F159477CB7DB7D890A07F465)

![mysql-select-global-sql-mode](60DB808E69A5423F963D028FA07EA2D7)

![image](F436A38095C9492F9E44DA67C5551FA4)


##### GROUP BY 分组查询子句

`GROUP BY` 查询子句可以根据给定列（该列称为：聚合列）的值对数据集进行分组，一般会结合聚合函数或聚合分析函数最终得到一个分组汇总表。

聚合函数是将组中的行汇总计算为单个值的函数，如：`COUNT()`-计算行数、`SUM()`-求和、`AVG()`-求平均值、`MAX()`-取集合中的最大值、`MIN()`-取集合中的最小值...等

需要注意的是：

1. 严格模式下：当 `SELECT` 语句配合 `GROUP BY` 子句一起使用时，`SELECT` 的列、`HAVING` 子句的列、`ORDER BY` 的非聚合函数列都必须要出现在 `GROUP BY` 列中（即：在使用 `GROUP BY` 语句时，非聚合列只有使用了聚合函数才能在 `SELECT` 列中）
2. 宽松模式下：如果非聚合列和聚合列是一一对应，那么得到的汇总结果是正确的，但是：若非聚合列和聚合列不是一一匹配时，非聚合列出现的值是随机不准确的

因此：工作中，`sql_mode` 一般我们都会设置为严格模式 `ONLY_FULL_GROUP_BY`！对问题的详细描述可以看官方文档-[《MySQL Handling of GROUP BY》](https://dev.mysql.com/doc/refman/8.0/en/group-by-handling.html)，或参考博文：[《神奇的 SQL 之层级 → 为什么 GROUP BY 之后不能直接引用原表中的列》](https://www.cnblogs.com/youzhibing/p/11516154.html)，深究可以学习一下集合论再去查看：《SQL基础教程》、《SQL进阶教程》书籍。

总的来说：`GROUP BY` 是按照某一列或几列进行“分组”查询，查询的信息必须是分组的依据或“组”属性信息。如：根据学生身高和性别进行分组，你只能得到这个组里身高、性别的分组信息，或者得到最高的身高、各自组有多少人等这类分组依据及组属性信息，但是**不能一步到位的得到**这个组里最高身高的男生是谁这类明确到具体组员的非分组依据信息！

`ERROR 1055 (42000): Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'test.result.subject' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by`

![mysql-select-group-by-error-on-only_full_group_by](0FF461A938F64DFF9F809A29543E6FBA)

##### HAVING 查询筛选子句

`HAVING` 是针对查询得到的结果集进行进一步的过滤筛选。因此：`HAVING` 条件涉及的列一定是在 `SELECT` 临时结果集中出现的列。

注意：如果 `SELECT` 的列使用了 `AS` 命名了别名，那么 `HAVING` 做筛选时候也需要使用别名！

以商品表-`goods` 表为例，要求：查询 `goods` 表中商品比市场价低出至少 200 的商品。如下：

1. 结合**列是变量，可以进行计算**，查询 `goods` 表中商品比市场价低出多少？

```SQL
SELECT goods_id, goods_name, (market_price - shop_price) as diff_price FROM `goods` WHERE market_price > shop_price;
```

注意：`MySQL 8` 的数据库模式默认是严格模式，若计算列及其结果超出了列类型所定义的数据类型范围，会报错：`(1690, "XXX value is out of range in 'xxxx'`，详细可阅读官方文档：[《11.1.7 Out-of-Range and Overflow Handling》](https://dev.mysql.com/doc/refman/8.0/en/out-of-range-and-overflow.html)。

测试表 `goods` 中，`market_price` 和 `shop_price` 都是非负小数：`DECIMAL UNSIGNED`，而 `(market_price - shop_price)` 可能会出现负数，因此在数据库严格模式下这个运算可能会出现报错，如下图：

![mysql-error-DECIMAL-UNSIGNED-value-is-out-of-range-in-goods](ED1B4FF3C8624AD6B175CC074A77D26C)

解决方法有如下几种：

- 在查询时候需要加上 ` WHERE market_price > shop_price` 确保计算结果范围正确！（推荐：养成书写严格模式的 SQL 是一个好习惯，兼容性也比较高）


- 给 `sql_mode` 增加设置 `NO_UNSIGNED_SUBTRACTION`，允许计算结果与计算列数据类型不同

![mysql-set-sql-mode-no-unsigned-subtraction](49D5D48A07B44037A5CE13B87D985992)

- 通过 `CAST()` 函数改变计算列的取值范围

```SQL
 SELECT goods_id, goods_name, (CAST(market_price as SIGNED) - CAST(shop_price AS SIGNED)) AS diff_price FROM `goods`;
 ```
 
 ![mysql-select-cast-change-colum's-data-struct.png](EDDE86C2F32F4025B976390FEBE25E9C)


2. 查询 `goods` 表中商品比市场价低出至少 200 的商品？

- 利用 `WHERE` 子句实现：

```SQL
SELECT goods_id, goods_name, (market_price - shop_price) as diff_price FROM `goods` WHERE market_price > shop_price and  (market_price - shop_price) >= 200;
```

- 利用 `HAVING` 子句实现：
```SQL
SELECT goods_id, goods_name, (market_price - shop_price) as diff_price FROM `goods` WHERE market_price > shop_price HAVING  diff_price >= 200;
```

！！！注意：如果同时写了 `WHERE` 和 `HAVING` 子句， `WHERE` 子句一定要写在 `HAVING` 子句前面，因为：`WHERE` 子句针对的是磁盘中的数据集进行过滤筛选，而 `HAVING` 子句是针对 `WHERE` 子句查询放到内存中的临时结果集来操作的！


##### 练习题：WHERE-HAVING-GROUP 综合练习

有如下 `result` 表及数据，要求查询出 2 门及 2 门以上不及格者的平均成绩！

![mysql-demo-table-result](7F8F291DE54A487595F6F80F64EA3FA8)

思路应该都知道：①.先找出有 2 门及 2 门以上不及格的人；②. 利用 `avg()` 函数求平均值！

取平均值没什么难度，仅仅是函数的简单运用而已，那么怎么找出 2 门及 2 门以上不及格的人，就成了关键！

**错误示范：**

说到统计不及格的人数，可能一下子就想到了 `count( score < 60 )`，这是最显著的一种错误：`count()` 函数的理解错误！如下：

```SQL 
select name,count(score < 60) as num ,avg(score) as average from result group by name having num > 1;
```

![mysql-demo-error-count](0D09786FB07E4B739055203CBCEC5AB7)

乍一看结果是正确的！

但是若此时再增加几条合格的记录，然后再执行上述查询，上述的错误就昭然若揭了。如下：

```SQL
-- 添加一条王五合格的数据，三条赵六合格数据
INSERT INTO result (`name`, `subject`, `score`) VALUE ('王五', '语文', 99), ('赵六','A',100),  ('赵六','B',99), ('赵六','C',98)

-- 查询有 2 门及 2 门以上不及格者的平均成绩
select name,count(score < 60) as num ,avg(score) as average from result group by name having num > 1;
```

![mysql-demo-error-select-count.png](5E372A7F8718458BB3A5158260355F15)

王五只有 1 科不合格，但是结果给统计出来了；赵六 3 科都合格，还是给统计出来了！

也就是说 `count(score < 60)` 理解错误了。理解如下：

- `COUNT(*)` 返回结果集中所有的行数，包括：`NULL` 和所有非 `NULL` 的记录数
- `COUNT(expression)` 返回所有非 `NULL` 记录
- `COUNT( DISTINCT expression)` 返回所有排重之后的非 `NULL` 记录

在刚才的 `result` 表中插入一条 `NULL` 的数据，如下：

![mysql-demo-count-table-result](1AF328802C18486DB722D24129054977)

分别看看 `COUNT(*)`、`COUNT(expression)`、`COUNT( DISTINCT expression)`、`COUNT(1)`、`COUNT(0)` 几种情况的结果

![mysql-demo-count-*-table-result](8DF0A3CCBF9746DF99452A552A921628)
![mysql-demo-count-column-table-result](935209C5B182446BA8630E62EFCFFC3B)
![mysql-demo-count-distinct-column-table-result](90A42DB95D754C408351213CDCDA43C4)
![mysql-demo-count-1-table-result](34DDEB24B57441468C324CCBE49B0648)
![mysql-demo-count-0-table-result](9055A24903C144038219F3877A6D18D8)

从上述图可以看出：`COUNT()` 函数只要不涉及列，那么返回的都是所有行记录，如果表达式涉及了列那么会过滤掉 `NULL` 记录（因为 `NULL` 表示什么都没有，不能做比较）！

**正确解答：**通过 `SUM(expression)` 解决，如下图！

![mysql-demo-select-table-result](73BAD2EFD78A4388858A6CC083732819)
![mysql-demo-select-sum-table-result](A59B9766078D470B999205741824B012)

```SQL
select name, sum(score < 60) as num, avg(score) as average from result group by name having num > 1;
```

![mysql-select-sum-group-by-having](1A937593058742869B569E6BE18C26FE)

##### ORDER BY 查询筛选子句
- https://www.runoob.com/mysql/mysql-order-by.html
- https://www.cnblogs.com/cjsblog/p/10874938.html

##### LIMIT 查询筛选子句
- https://segmentfault.com/a/1190000008859706
- https://juejin.cn/post/6844903840332906509

#### 子查询陷阱


## DDL 语句

DDL（data definition language）数据库定义语句，主要的命令有CREATE、ALTER、DROP等，DDL主要是用在定义或改变表（TABLE）的结构，数据类型，表之间的链接  和约束等初始化工作上，他们大多在建立表时使用。

### 用户管理

#### 创建用户并授权

```sql
CREATE USER '<user>'@'%' IDENTIFIED BY '<password>';
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


## DCL 语句

DCL（Data Control Language）：  是数据库控制功能。是用来设置或更改数据库用户或角色权限的语句，包括（grant,deny,revoke等）语句。在默认状态下，只有
sysadmin,dbcreator,db_owner或db_securityadmin等人员才有权力执行DCL。



## TCL 语句

TCL（Transaction Control Language）事务控制语言 SAVEPOINT 设置保存点  ROLLBACK  回滚 SET TRANSACTION。

## 文章阅读&&疑问
- [RENAME TABLE语句](https://dev.mysql.com/doc/refman/8.0/en/rename-table.html)
- [如何平滑的变更单表超 100000000 条记录的数据库结构](https://www.hi-linux.com/posts/33485.html)
- [不停机不停服务，MYSQL可以这样修改亿级数据表结构](https://www.cnblogs.com/zishengY/p/6852333.html)
- 磁盘加载数据到内存是按照什么规则进行加载的？
- 磁盘加载数据是如何进行加载的？-如果有索引、没有命中索引？按列加载、按页加载？
- [MySQL 整体架构与 SQL 执行原理，数据库事务原理](https://cloud.tencent.com/developer/article/1491329)
- [存储过程在实际项目中用的多吗？](https://www.zhihu.com/question/54408187)
- [为什么阿里巴巴Java开发手册里要求禁止使用存储过程？](https://www.zhihu.com/question/57545650)
- [在MySQL语句中使用MySQL自带函数效率问题](https://segmentfault.com/q/1010000000345755)
- [避免写出不走索引的SQL, MySQL](https://jaskey.github.io/blog/2016/01/19/mysql-bad-sql-with-no-index/)
- [MySQL SHOW COLUMNS and DESCRIBE: List All Columns in a Table](https://www.mysqltutorial.org/mysql-show-columns/)
- [MYSQL（8.0版本及以上）- utf8mb3，utf8mb4 和utf8的含义和由来](https://blog.csdn.net/htuhxf/article/details/90676341)
- [MySQL Performance Benchmarking: MySQL 5.7 vs MySQL 8.0](https://severalnines.com/blog/mysql-performance-benchmarking-mysql-57-vs-mysql-80/)



### MySQL 中 `length()`、`char_length()` 有什么区别？

- `char_length(str)` 计算字符长度（即：多少个字符，不管是 1 个字母/数字/汉字 长度都是 1）
- `length(str)` 计算字符串的字节长度，根据不同编码规则 1 个字符其字节数不一定相同的。如：UTF-8 编码中汉字是 3 个字节，而 GBK 编码汉字是 2 个字节
- https://cloud.tencent.com/developer/article/1655577
- https://www.mysqltutorial.org/mysql-string-length/



### `varchar(10)` 和 `varchar(200)` 有什么区别？

- https://juejin.cn/post/6844904127571427342
- https://www.iamshuaidi.com/1413.html
- 