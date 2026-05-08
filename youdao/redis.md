# Redis

[TOC]


## Redis 基本学习

- https://www.runoob.com/redis/redis-tutorial.html
- https://www.redis.net.cn/tutorial/3501.html
- [黑马程序员 ： Redis入门到实战教程，深度透析redis底层原理](https://www.bilibili.com/video/BV1cr4y1671t/)
- [【动力节点】Redis缓存教程，全网最新最全 Redis7 入门到高级，redis百科大全](https://www.bilibili.com/video/BV1U24y1y7jF/)
- https://tobebetterjavaer.com/xuexiluxian/redis.html
- [阿里云：Redis入门及实战](https://edu.aliyun.com/course/315259)
- [GitChat：Redis 核心原理与实战](https://learn.lianglianglee.com/%e4%b8%93%e6%a0%8f/Redis%20%e6%a0%b8%e5%bf%83%e5%8e%9f%e7%90%86%e4%b8%8e%e5%ae%9e%e6%88%98)
- [极客时间：Redis 核心技术与实战](https://learn.lianglianglee.com/%e4%b8%93%e6%a0%8f/Redis%20%e6%a0%b8%e5%bf%83%e6%8a%80%e6%9c%af%e4%b8%8e%e5%ae%9e%e6%88%98)
- [极客时间：Redis 源码剖析与实战](https://learn.lianglianglee.com/%e4%b8%93%e6%a0%8f/Redis%20%e6%ba%90%e7%a0%81%e5%89%96%e6%9e%90%e4%b8%8e%e5%ae%9e%e6%88%98)
- [掘金：Book/Redis深度历险：核心原理和应用实践](https://github.com/Zhengfangxing/Book/blob/master/Redis%E6%B7%B1%E5%BA%A6%E5%8E%86%E9%99%A9%EF%BC%9A%E6%A0%B8%E5%BF%83%E5%8E%9F%E7%90%86%E5%92%8C%E5%BA%94%E7%94%A8%E5%AE%9E%E8%B7%B5.pdf)
- [CentOS下正确编译安装和使用RediSearch](https://blog.csdn.net/lifetragedy/article/details/128991181)
- https://www.ziruchu.com/art/130
- https://github.com/redis/redis
- https://redis.com/blog/salvatore-sanfilippo-welcome-to-redis-labs/
- https://hub.docker.com/u/redislabs
- https://hub.docker.com/_/redis
- https://github.com/docker-library/redis/blob/9b538c33746872dcd1e8c809cbde9f21ac2ec3ac/7.2/alpine/Dockerfile
- https://github.com/docker-library/redis/tree/master
- https://www.ibm.com/cn-zh/topics/redis
- https://cloud.tencent.com/developer/news/843145
- https://blog.csdn.net/m0_59537084/article/details/119674247
- https://redis.com/
- https://developer.aliyun.com/article/835598
- http://blog.itpub.net/31545816/viewspace-2220934/
- https://redis.com/comparisons/redis-vs-memcached/
- https://aws.amazon.com/cn/elasticache/redis-vs-memcached/
- https://www.quora.com/Why-would-a-new-startup-choose-Memcached-over-Redis
- [图解Redis](https://xiaolincoding.com/redis/)
- https://i6448038.github.io/2021/09/05/float-binary/
- https://blog.csdn.net/fangkang7/category_8399760.html
- https://zhuanlan.zhihu.com/p/97527245
- https://blog.51cto.com/u_15766933/5624605
- https://developer.aliyun.com/article/680043
- https://cloud.tencent.com/developer/article/1805388
- https://www.cnblogs.com/will-xz/p/14317697.html
- https://xie.infoq.cn/article/6c3500c66c3cdee3d72b88780
- https://blog.51cto.com/u_11812862/3047706
- https://blog.51cto.com/u_11812862/4972093
- https://blog.51cto.com/u_11812862/4972161
- https://blog.51cto.com/u_11812862/4972090
- https://blog.51cto.com/lovebetterworld/2858173
- [面试时你可能需要的 Redis 知识技巧](https://learnku.com/articles/24466)
- Redis 21问：https://zhuanlan.zhihu.com/p/130923806
- [Redis 缓存满了之后怎么办？](https://mp.weixin.qq.com/s/limIGzVCvh28ad1EsTmWEw)



## 什么是 Redis ？它的优缺点是什么？

`Redis` （全称：`Remote Dictionary Server`，远程字典服务）于 `2009` 年由意大利程序员 `Salvatore Sanfilippo`（ `Redis` 之父，网名 `Antirez`）使用 `C` 语言编写的一个 **高性能、完全开源免费（[遵守 BSD 协议](https://www.kancloud.cn/crq0625/redis/640257)）、基于 `Key-Value` 的 NoSQL 内存数据存储系统**。

**`Redis` 将所有数据统统存储在内存中** — 提供最快的数据读写性能，并提供内置的复制能力，允许您将数据保存在距离用户更近的地方，以实现最低延迟，也因为其优秀的读写速度，主要用作于：**缓存 或 充当快速响应数据库**

- Redis 官网：https://redis.io/
- Redis 中文网：https://www.redis.net.cn/
- Redis 中文学习网：https://redis.com.cn/
- Redis 命令中文参考：http://doc.redisfans.com/
- Redis 命令参考：https://redis.io/commands/
- Redis 官方博客 ： https://redis.com/glossary/
- 源码地址：https://github.com/redis/redis
- Redis 在线测试：http://try.redis.io/

它最初只是内部用来解决 `web` 应用程序扩容场景下产生的一些问题（缓存用户会话，避免扩容丢失会话），但随着发展，其功能也越来越丰富，能覆盖很多问题场景。

**`Redis` 的优点如下：**

- 基于内存，读写速度快，官方给出的数据显示：读的速度是 110,000 次/s，写的速度是 81,000 次/s
- `Redis` 基于键值对，且 `Value` 有 5 种数据基础类型：动态字符串（`String`）、散列（`Hash`）、列表（`List`）、集合（`Set`）、有序集合（`SortedSet-Zset`）
- 支持数据持久化，`AOF` 和 `RDB` 两种方式
- 支持事务，`Redis` 所有的单个操作都是原子性的，多个操作则通过 `MULTI`（开启事务） 和 `EXEC`（触发事务执行） 指令包起来从而实现事务操作。**注意：单个 Redis 命令的执行是原子性的，但 Redis 事务的执行并不是原子性的。即：中间某条指令的失败不会导致前面已做指令的回滚，也不会造成后续的指令不做**。[Transactions | Redis](https://redis.io/docs/interact/transactions/)
- 内置丰富的功能特性（如：队列、订阅、流水线、事务、过期 key 等），同时支持 `Lua` 脚本用于自定义开发功能
- 社区活跃，官方提供绝大数主流语言的 `SDK`
- 成熟的高可用方案（主从、哨兵、Cluster）、分布式、高并发
- 支持主从复制，`master` 机器会自动将数据同步到 `slave` 机器

**`Redis` 的快是基于“RAM”，因此读写速度快，但正因此所以缺点也比较明显：**

- `Redis` 有数据持久化功能，但不能将 `Redis` 作为纯数据库来使用，容易受到物理内存的限制
- 由于受内存限制，`Redis` 不能用作海量数据的高性能读写（数据量不能大于硬件内存）


但不管如何，`Redis` 目前基本上是首选的缓存系统。

- [为什么要选择 Redis](https://redis.com.cn/topics/why-use-redis.html)
- [redis读写性能测试](https://blog.csdn.net/nightelve/article/details/16854223)
- [Redis读写的速度之争（redis读和写的速度）](https://www.dbs724.com/316921.html)
- [如何正确地使用Redis（附性能测试实验结果）](https://developer.aliyun.com/article/783643)
- [redis mysql 读写速度 redis读写速度 每秒](https://blog.51cto.com/u_16099274/6347315)

> 注意：学习和操作 `Redis` 的时候善于使用 `help` 命令，同时可以通过 `:set hints` 开启语法提示，这样在 CLI 中键入命令时可以看到对应的提示信息

![Redis 开启语法提示](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/redis-set-hints.png)

## Redis 和 RedisLabs 是什么关系？

通过 `Docker` 搭建本地 `Redis` 环境的时候，发现除了 `Docker Official Imange`（`Docker` 自身提供的镜像） 以外，还有一个 `Verified Publisher` （经过 `Docker` 组织审查由第三方提供商提供和维护的镜像，一般都是其服务的官方公司）叫做 `redislabs`，也发布了非常多的 `Redis` 相关的镜像...

查询了一下，简单记录两者渊源：

- `Redis Labs` 是一家于 `2011` 年成立的美国 **云数据库服务提供商**，致力于为 `Redis/Memcached` 等流行的开源数据库提供云托管服务
- `2015` 年 `Redis` 之父 — `Salvatore Sanfilippo（ antirez）`加入了 `Redis Labs`公司，并将 `Redis` 项目的知识产权、商标转让给了该公司
- `2021/08/11` 该公司决定将公司名字由 `Redis Labs` 改为 `Redis`
- 该公司基于 `Redis` 服务自研了很多 `Redis` 模块，如：`RedisSearch`、`Redis Graph`、`ReJSON`、`ReBloom` 和 `Redis-ML` 为 `Redis` 的丰富生态做出了很大贡献（如果你想使用这些模块用于做和数据相关的商业活动，需要获得 `RSAL` 授权许可）

## Docker 安装、运行 Redis

Redis 版本号采用标准惯例：**主版本号.副版本号.补丁级别**，一个副版本号就标记为一个标准发行版本，例如 `1.2`，`2.0`，`2.2`，`2.4`，`2.6`，`2.8`，奇数的副版本号用来表示非标准版本,例如`2.9.x`发行版本是`Redis 3.0`标准版本的非标准发行版本，[当前（2023/08/20）最新的版本是：`7.2.0`](https://github.com/redis/redis/releases)。


去 [`Download for Redis Leleases`](https://download.redis.io/releases/)（[ 下载最新稳定版 redis-stable](http://download.redis.io/redis-stable/)） 可以查看所有版本的源码包，安装过程自行查询。安装 `Redis` 之后，其主要包含两个程序：服务-`redis-server`、客户端工具-`redis-cli：redis-cli [-h host] [-p port] [-a password]`

- 查看 Redis 服务信息：`redis-cli INFO [section,ps:keyspace]`

就学习来说目前通过 `Docker` 搭建 `Redis` 服务是最方便、最推荐的，可以选择以下两个镜像：

- `Redis` 公司提供的 `Redis` 企业版镜像：https://hub.docker.com/r/redislabs/redis
- `Docker` 公司提供的 `Redis` 镜像：https://hub.docker.com/_/redis

```sh
# 拉取镜像（或：docker pull redislabs/redis）
docker pull redis

# 运行镜，设置密码 pwd123
docker run -itd -p 6379:6379 --restart=always --name redis-demo redis redis-server --requirepass pwd123
# 或：docker run -d --cap-add sys_resource --name redis-demo -p 8443:8443 -p 12000:12000 redislabs/redis

# Redis Ping 命令使用客户端向 Redis 服务器发送一个 PING ，如果服务器运作正常的话，会返回一个 PONG 
# 通常用于测试与服务器的连接是否仍然生效，或者用于测量延迟值
docker exec -it redis-demo redis-cli -p 6379 -a pwd123
```

> - 当然可以通过 `docker search redis` 搜索可用的 redis 镜像列表
> - docker 参数解释：https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities

## `Redis` 设置密码链接

> `Redis 6.0` 以前是没有区分用户且密码是通过明文存储的，即：所有人通过同一个账号和密码进行登录操作；`Redis 6.0` 开始引入了 [`ACL（Redis Access Control List）`](https://redis.io/docs/management/security/acl/) 这个概念，可以通过 **"用户-密码"** 对 `Redis` 服务进行访问权限控制。

默认情况下 `Redis` 服务是关闭了密码链接的，可以通过 `redis-server --requirepass <password>` 在启动的时候设置密码

```sh
# 进入容器
docker exec -it redis-demo bash

# 安装 ps 命令
root@239300081f12:/data# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
NAME="Debian GNU/Linux"
...
root@239300081f12:/data# apt update -y && apt install -y procps

# 查看 redis-server 进程
root@239300081f12:/data# ps -aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
redis          1  0.1  0.3  52828 13032 pts/0    Ssl+ 17:25   0:02 redis-server *:6379
root          27  0.0  0.0   4088  3464 pts/1    Ss   17:47   0:00 bash
root         371  0.0  0.0   6700  2896 pts/1    R+   17:47   0:00 ps -aux

# 查看版本
root@239300081f12:/data# redis-server -v
Redis server v=6.2.6 sha=00000000:0 malloc=jemalloc-5.1.0 bits=64 build=b61f37314a089f19

# 通过 redis-cli 登录服务
# 登录时就输入密码，可以 redis-cli -p 6379 -a pwd123
root@239300081f12:/data# redis-cli

# 查看密码（会提示验证错误，因为还没有设置当前服务链接的密码）
127.0.0.1:6379> config get requirepass
(error) NOAUTH Authentication required.

# 输入授权密码
127.0.0.1:6379> auth pwd123
OK
127.0.0.1:6379> config get requirepass
1) "requirepass"
2) "pwd123"
```

如果我们已经通过 `redis-server &` 在后台启动了服务，想设置当前服务连接的密码也是可以的：

```sh
root@239300081f12:/data# redis-cli

127.0.0.1:6379> config set requirepass pwd123
```

不过这种方式，重启容器（即：重启`Redis`服务）后密码就会丢失，而程序中如果使用了密码登录...反而会报错提示授权错误。

`Redis` 的命令（包括 `AUTH` 命令）都是没有加密的，阻止不了攻击者在网络上窃取你的密码。

认证层的目的只是提供多一层的保护：当防火墙系统防御外部攻击失败 或 `redis` 服务意外对外进行了暴露的情况下，外部用户如果没有通过密码认证还是无法访问`redis`服务。

如果想要解决，两种思路：

1. 启动（重启）时，想办法让服务启动程序 `redis-server` 带上 `--requirepass` 参数
2. 通过 `redis.conf` 配置文件进行配置（但要注意：Docker 拉下来的镜像默认是不带这个配置文件的）


方法1：如果我们使用 `Docker Compose` 来启动多容器服务时， 除了 `docker-compose.yml` 外，还可以自动的通过 `.env` 隐藏文件设置环境变量，然后在 `docker-compse.yml` 中直接设定启动服务。如：

`.env` 文件设置环境变量：

```
REQUIRED_PASSWD=pwd123
```

`docker-compose.yml` 文件如下即可：

```yaml
version: "2"
services:
  redis:
    image: redis:5-alpine
    container_name: redis-demo
    restart: always
    networks:
      - app_net
    ports:
      - "6379:6379"
    volumes:
      - /data/redis:/data
    command: redis-server --requirepass $REQUIRED_PASSWD

networks:
  app_net:
    external: true
```

如果想通过 `redis.conf` 来配置启动服务信息的，可以参考：[Docker安装Redis以及以配置文件方式启动Redis（docker安装的请别乱下载redis.conf文件）](https://blog.csdn.net/dl962454/article/details/109776892)，可参考：[redis.conf 详解](https://github.com/hhxsv5/docker/blob/master/redis/redis.conf)。

**补充：`Docker Compose` 自动将 `.env` 文件引入，其实就是：`docker run --env-file /path/to/.env`，然后更改 `Dockerfile` 中的 CMD 命令为 `CMD ["redis-server", "--requirepass", $REQUIRED_PASSWD]`**


方法2：去官方下载对应版本的源码，源码包里含有 `redis.conf` 文件（如：[`redis-stable`](http://download.redis.io/redis-stable/)），配置好对应的 `redis.conf` 然后挂载到容器中

```sh
docker run \
    -d -p 6379:6379 \
    -v /apps/redis/conf/redis.conf:/etc/redis/redis.conf \
    -v /apps/redis/data:/data \
    --restart=always \
    --name redis-demo redis \
    redis-server /etc/redis/redis.conf --appendonly yes
```

## 解决 `redis-cli` 中文乱码

当通过 `redis-cli` 程序终端（tty）连接服务然后有中文的时候，输出的结果会是被编码的，如下：

```sh
root@ebf38f1a3501:/data# redis-cli -a pwd123
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
127.0.0.1:6379> set test "中国"
OK
127.0.0.1:6379> get test
"\xe4\xb8\xad\xe5\x9b\xbd"
```

可以通过指定 `redis-cli` 的 `--raw` 选项来解决：

```
root@ebf38f1a3501:/data# redis-cli -a pwd123 --raw
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
127.0.0.1:6379> get test
中国
```

- `--raw` Use raw formatting for replies (default when STDOUT is not a tty). 使用原始格式进行回复（当标准输出不是 tty 时，默认该值是开启的）

## Redis 配置

- `CONFIG GET *` 可以获取所有的配置信息
- `CONFIG GET <CONFIG_NAME>` 获取指定配置信息
- `CONFIG SET <CONFIG_NAME> <CONFIG_VALUE>` 设置当前链接的配置信息（仅当前服务进程有效，重启服务后无效）

如果需要配置 `redis.conf` 建议先通过下方两个链接阅读了解 `redis.conf` 配置：

- 方法1：通常会通过修改 `redis.conf` 配置文件，然后重启 `redis-server`。如果觉得太长了，可以借助 [`ChatPDF`](https://www.chatpdf.com/) 来解读 [`redis.conf`](http://download.redis.io/redis-stable/redis.conf)
- 方法2：[redis.conf 简介](https://github.com/hhxsv5/docker/blob/master/redis/redis.conf) 或 [03 redis.conf配置文件详解](https://blog.51cto.com/u_11812862/4972161)


并**推荐使用 `redis-server </path/to/redis.conf>` 显示声明配置路径来启动 `Redis`**。

需要额外注意一下配置文件的数据单位，大小写不敏感，即：`1GB = 1gb = 1Gb`

```plain
# 1k => 1000 bytes
# 1kb => 1024 bytes
# 1m => 1000000 bytes
# 1mb => 1024*1024 bytes
# 1g => 1000000000 bytes
# 1gb => 1024*1024*1024 bytes
```

电脑常用的存储单位是：

```plain
# 1Byte（Byte 字节） = 8 Bit（Bit 二进位）
# 1KB (Kilobyte 千字节) = 1024 Byte，
# 1MB (Megabyte，兆字节，简称“兆”) = 1024 KB
# 1GB (Gigabyte，吉字节，又称“千兆”) = 1024 MB
# 1TB (Terabyte，太字节，或百万兆字节) = 1024 GB
```

### 启动类配置

- `daemonize no` : `Redis` 默认不是以[守护进程](https://www.kancloud.cn/crq0625/redis/640256)的方式运行，可以通过该配置项修改，使用 `yes` 启用守护进程进行启动，启动脚步-[redis_init_script](https://github.com/redis/redis/tree/unstable/utils)
- `pidfile /var/run/redis.pid`：设置 `Redis` 守护进程启动方式的 `pid` 文件
- `port 6379` 启动端口，默认 `6379`
- `bind` 绑定 `Redis` 服务器主机的网络接口地址，详细看[《Redis配置文件中bind参数 | Bingo's Blog》](https://bingozb.github.io/views/default/62.html#%E5%85%B3%E4%BA%8Ebind)

### 连接类配置

- `timeout 300` 当客户端闲置 x 秒后关闭连接，`0` 表示关闭该功能

### 日志类配置

- `loglevel notice` 日志记录级别：debug、verbose、notice（默认）、warning
- `logfile stdout` 日志记录方式，默认为标准输出（控制台），若 `Redis` 为守护进程方式运行，日志将会发送给 `/dev/null`


## Redis 数据类型

通过对 `Redis` 官方命令分类进行划分，可以将 `Redis` 的操作归纳为：

- 8 种数据类型：
    - 5 种基础类型：string、list、hash、set、sorted-set
    - 3 种新增类型：Bitmap、GEO、HyperLogLog
- 2 种消息队列：
    - 发布订阅：pub/sub
    - Redis 流： Stream
- 4 类运维管理操作：
    - 集群管理
    - 连接管理
    - 服务管理
    - 高可用管理（非集群）：哨兵、主从
- 2 类其他：
    - Lua 脚本执行 - [Lua 教程 | 菜鸟教程](https://www.runoob.com/lua/lua-tutorial.html)、[使用 lua 脚本的好处 | 木易](https://muyids.github.io/blogs/2020/redis%E4%BD%BF%E7%94%A8lua%E8%84%9A%E6%9C%AC%E5%AE%9E%E7%8E%B0%E5%88%86%E5%B8%83%E5%BC%8F%E9%94%81.html)
    - Transactions：监控



### 5 种基础数据类型

1. 数据类型：
    - 描述单个数据项的性质和特征
    - 基本数据类型如整型、浮点型、布尔型、字符型等
    - 强调的是「如何在内存中存储数据」以及「可以对其执行的操作」
2. 数据结构：
    - 用来组织和存储多个数据项的方式
    - 常见数据结构如数组、链表、堆、栈、哈希表、树等
    - 强调的是「数据项之间的关系」及「如何高效地存储和访问这些数据」

**数据类型涉及单个数据项的性质，而数据结构关注多个数据项如何组织和相互关联。你可以将数据结构视为使用特定数据类型构建的容器，例如使用整型构建的数组或使用对象构建的链表等等...**。

> - [阿里云Redis开发规范](https://developer.aliyun.com/article/531067)
> - [阿里云数据库Redis开发运维规范](https://help.aliyun.com/zh/redis/use-cases/development-and-o-and-m-standards-for-apsaradb-for-redis)
> - [Redis data types | Redis](https://redis.io/docs/data-types/)

`Redis` 本身是一个 `Key => Value` 的内存数据库，其访问快除了因为是基于内存还有就是其底层是用 `Hash` 的方式存储数据的，算法复杂度是 O(1)。我们讨论的 `Redis` 数据类型都是在说 `Value` 的数据类型。

`Redis` 提供了 5 种简单的数据类型，每种结构所分别对应的底层数据结构关系如下图：

![Redis 数据类型与底层数据结构对应关系](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/redis-datastructs.png)

需要切记的是：**`Redis` 虽然是一个 NoSQL 数据存储系统，但它是“基于内存”的，不适合用作大量数据的存储操作！！！**

1. 一个 `String` 类型的 `value` 最大可以存储 `512M`（即：`2^29 - 1 = 536,870,911` 字节）
2. 一个 `Hash` 类型的 `KEY` 最多可以存放 `2^32 - 1 = 4294967295` 个键值对（40 多亿个 `Field => Value`）
3. 一个 `List/Set/Zset` 类型的 `KEY` 对最多可以存放 `2^32 - 1 = 4294967295` 个元素

#### String 字符串

1. `Redis` 中 `String` 类型单个 `Key` 最大限制在 `512M` 大小（即：`2^29 - 1 = 536,870,911` 字节），可以通过 `strlen KEY` 命令获取字符串长度
2. `GET/SET/DEL` 命令

- 采用锁机制实现最简单的分布式锁：`SET resource-name anystring NX EX max-lock-time`
- 更好效果的分布式锁参考实现：[Distributed Locks with Redis](https://redis.io/docs/manual/patterns/distributed-locks/)
- [redis string底层数据结构-阿里云开发者社区](https://developer.aliyun.com/article/666402)

#### Hash 哈希

1. `Redis Hash` 是一个 `Key => Map` 的集合，`Map` 中定义映射关系表（类似于 `PHP` 中的索引数组，`Java` 中的 `HashMap`）
2. 每个 `KEY` 可以存储 `2^32 -1` 个键值对（`Map`）
3. `Redis Hash` 中的 `Map` 里的 `Field/Value` 只能是 `String` 类型
3. `HGET/HSET KEY FIELD VALUE` 命令、`HMGET/HMSET KEY [FIELD VALUE]...` 命令、
5. `Redis Hash` 类型特别适合用于存储“对象类型的数据结构”，可以非常灵活的添加和删除对象属性
6. `Redis Hash` 底层使用 `HashTable` 或 `ziplist` 来存储组织数据（字段和值都较小 或 元素个数较少时会自动选择 `ziplist`， 通过 `hash-max-ziplist-entries/hash-max-ziplist-value` 可以设置这个阈值）

**但是 `Hash` 设计初衷不是为了存储大量对象而设计的，切记不要滥用，更不可以将 `Hash` 作为对象列表使用。** `HGETALL KEY` 命令可以获取全部的键值对，但如果内部的 `Field` 过多的时候，遍历整体数据效率会非常低，从而造成数据访问瓶颈。

- [redis hash底层数据结构-阿里云开发者社区](https://developer.aliyun.com/article/666400)

#### List 列表

`Redis List` 类型其实就是一个简单的“字符串列表”，即：**元素只能是字符串**，最大元素个数限制为 `2^32 - 1 (4,294,967,295)` 个。

底层使用「双向链表-`Linked-List`」或「压缩列表-`ziplist`」两类数据结构进行组织数据，这种底层数据结构的选择由 `Redis` 自身决定使用哪一种（一般小的列表用压缩列表，大的列表用双向链表，可以通过 `list-max-ziplist-size` 来配置，该配置值默认是 64 byte）

特点 | 双向链表（`linked-list`） | 压缩列表（`ziplist`）
-------------|----------|---------
存储方式 | 前后指针+数据`[head] <-> [node1] <-> [tail]` | 长度+数据 `len|entry1|len|entry2|···`
存储空间 | 较大，数据可能比较散乱，需要两个额外位置存储前后指针 | 较小，数据紧凑，只需要一个额外位置存储数据长度
访问速度 | 较快，根据指针能快速寻址 | 可能较慢，因为需要解码
适宜场景 | 存储大型、变长的数据 | 存储小型、相似长度的数据

`Redis v3.2` 引入了 [`Quicklist - A doubly linked list of ziplists`](https://juejin.cn/post/7093145133368999943) 数据结构，它是 `linkedlist` 和 `ziplist` 的混合体。[Redis数据结构：快速列表(quicklist) ](https://www.cnblogs.com/hunternet/p/12624691.html)

- [redis list底层数据结构-阿里云开发者社区](https://developer.aliyun.com/article/666401)

#### Set 集合

1. `Redis Set` 是一堆 **“字符串”** 元素的 **“无序”** 集合，底层可以通过 `HashTable` 或 `Array` 来实现。
    - 使用 `intset（即：Array）` 存储必须满足下面两个条件，否则使用 `HashTable`，条件如下：
        - 保存的所有元素都是整数值
        - 集合对象保存的元素数量不超过 `512` 个
2. **集合内的元素具有「唯一性」，即：重复插入相同元素，只有第一次插入的数据是有效的其余操作会被忽略**
3. 最大元素个数：`2^32 - 1` 个 (`4,294,967,295`) 

- [redis set底层数据结构-阿里云开发者社区](https://developer.aliyun.com/article/666399)

#### Zset 有序集合-SortedSet

1. `Redis ZSet` 和 `Redis Set` 的相同点在于：都是一堆具有 **“唯一性的字符串”** 元素集合
2. 不同点在于：`Redis Zset` 的元素会额外关联一个 `double` 类型的分数来表示元素的排序权重，`Redis` 正是通过该分数来为集合中的成员进行从小到大的排序
3. **`zset` 通过 `zadd KEY score value` 命令添加元素，`value`具有唯一性，但是 `score` 却可以重复**
4. **[如果 `score` 相同，元素按照词典顺序进行排序](https://redis.io/commands/zadd/#elements-with-the-same-score)**
5. 最大元素个数：`2^32 - 1` 个 (`4,294,967,295`)

- [redis zset底层数据结构-阿里云开发者社区](https://developer.aliyun.com/article/666398)


## Redis 为什么是 16 个数据库？如何查看和切换数据库？

通过 `CONFIG GET databases` 命令可以查看 `Redis` 划分了多少个数据库（类似：`show databases`），一般默认都是 `16` 个。 

`Redis` 的数据库是用于「**在同一个服务实例中用来隔离不同的数据集（不完全隔离- `FLUSHALL` 命令可以清空整个 `Redis` 实例中的所有数据库）**」，这样可以：**在不同的数据库中存储不同应用或服务的数据（但不推荐）**，这样做的意义在于：

- 能更好的组织数据进行**分类**，增加数据的**灵活性**，**简化数据管理**
- 同一实例中的不同数据库数据是**相互隔离**的，可以**降低不同业务间 `Key` 冲突**的可能性

**`16` 个数据库是 `Redis` 服务的一个默认配置，这个数量是一个官方认为的一个平衡值，既足够多支持大部分应用场景，又不会占用太多的资源，如果数据的分类超出了 `2^4 = 16` 个类别，也可以通过 `redis.conf` 中的 `databases` 配置来设置其他值。**

如果没有明确的使用 `SELECT <index>` 命令来选择数据库，所有的数据默认都会存放在 `0` 号数据库中

**如何确保 “特定类别的数据存储在同一个数据库中” 呢？**

1. **选择数据库**: 在与 `Redis` 交互之前，使用 `SELECT` 命令来选择正确的数据库
2. **约定**: 设定团队或项目的规则，确保某一类数据始终写入特定的数据库
3. **封装逻辑**: 通过代码封装逻辑，确保与特定类型的数据交互时总是先选择正确的数据库
4. **监控和审计**: 通过日志和监控来跟踪数据存储操作，并定期检查是否符合预期

这种策略要求开发和运维团队之间有明确的沟通和约定，以确保每个人都遵循相同的实践。



修改 Redis 数据库数量的情况可能包括：

1. **需求分隔**: 如果你的应用或系统需要更精细的数据隔离，超过16个不同的类别或项目，你可能需要增加数据库数量
2. **资源优化**: 如果你只使用其中几个数据库，减少数据库数量可能有助于优化资源使用
3. **组织策略**: 你的组织或项目的特定需求可能需要特定数量的数据库，以符合数据管理和安全性规则
4. **兼容性**: 旧的系统或第三方工具可能有特定的数据库数量需求，以确保与现有架构的兼容性

！！！请注意：

- **更改数据库数量是一项全局设置，可能会影响现有的应用和服务，因此需要谨慎考虑并充分测试**，因此如果非必要不要在中途才改数据库数量
- **Redis不支持自定义数据库的名字、不支持为各个数据库单独定义密码，所以每个数据库都以编号命名**

![Redis select db](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/redis-how-to-swith-db.png)

- 官方说：`Redis` 集群就没有数据库的概念。但是...我自己试验发现，我通过 `select` 也一样还是可以切换数据库，并且存储了值后在集群中也是可以被同步

> When using Redis Cluster, the SELECT command cannot be used, since Redis Cluster only supports database zero. In the case of a Redis Cluster, having multiple databases would be useless and an unnecessary source of complexity. Commands operating atomically on a single database would not be possible with the Redis Cluster design and goals. 引用：[《SELECT | Redis Commands》](https://redis.io/commands/select/)

- 如果使用 `Redis` 的数据库，那么用户必须自己记录哪些数据库存储了哪些数据


- [为什么 Redis 默认 16 个库？](https://cloud.tencent.com/developer/article/1588184)


## Redis 能干什么？Redis 的应用场景

`Redis` 常用的应用场景有很多：

1、缓存-`Cache`

`Redis` 使用最多的场景就是充当“缓存服务器”，凭借其优秀的读写性能（官方数据：读的速度是 11w 次/s，写的速度是 8.1w 次/s）和相较于 `Memcache` 更加丰富的数据结构（`String/List/Set/Zset/Hash`）支持，基本上在缓存服务器技术选项时首要考虑的对象。

常见的缓存场景，如：

- 缓存热点数据
- 对象缓存
- 全页缓存（Full-Page Cache，即：对生成的静态页面进行缓存，不过更多可以考虑用 `CDN` 进行静态资源和页面缓存，更多阅读：[全站缓存时代](https://segmentfault.com/a/1190000005808789)）
- 一些电商秒杀时，也会用于缓存库存的预减（[秒杀场景：如何通过 Redis 减库存？](https://www.cnblogs.com/javastack/p/16334831.html)）

总得来说，缓存的原理就是：减少机器的 `CPU` 消耗（避免重复计算）或 减轻数据库的读写瓶颈（减少 IO 资源的查询消耗，或错峰延迟写入数据到数据库），从而提高系统的读写能力。

---

2、数据共享-`Datashare`

最常用的就是实现站点应用的「分布式 `Session` 共享」，避免用户状态丢失。

早期 `Session` 会话存储在本地，但这样的方式随着分布式应用部署的兴起这会导致用户会话丢失；于是使用数据库来存储会话，但是随着访问量的增加，使用数据库存储用户会话需要耗费大量的磁盘IO查询、网络IO传输...于是也不适用。

后来 `Memcached` 的出现倒是暂时解决了这一困境（也是最早的缓存解决方案之一），但是 `Memcached` 不支持数据持久化、数据结构单一、本身不支持集群、早期的版本更是没有任何安全机制，这些缺点问题逐渐暴露...

于是 `Redis` 被推了出来，其自身是支持多种数据结构、支持数据持久化、事务、分布式的（即：配置好集群方式后，由 `Redis` 自动完成集群机器间数据的同步，而不需要借助额外的手段）

需要注意一点：

- `Memcached` 的 `Key-Value String` 是一种序列化字符串，这意味着你读取和修改信息时传递都是一个“完整”的数据
- `Redis` 的 `Key-Value String` 是基于二进制的（且 `Value` 支持多种数据类型），意味着 `Redis` 的修改可以无需传递一个“完整”的数据，从而可以减少网络 I/O 消耗；同时 `Redis` 可以用于存储二进制数据（如：图片）


`MC VS Redis` 参考：

- [Memcached vs Redis: Choose Your In-Memory Cache - Kinsta® ](https://kinsta.com/blog/memcached-vs-redis/)


Features | Redis | Memcached
---------|-------|----------
数据结构 | 基于二进制的 `Key-Value`，支持 `String/List/Set/Zset/Hash` | 序列化字符串
数据大小 | 512M 上限 | 1M 上限
线程模型 | 默认单线程（[追求性能极致：Redis6.0的多线程模型](https://www.cnblogs.com/wzh2010/p/15886804.html)） | 单进程多线程
数据持久化| 支持，`RDB/AOF` 两种文件格式 | 不支持
主从复制 | 允许复制 | 不支持
淘汰策略 | 多种策略 | “最近最少使用”淘汰缓存

---

3、分布式锁 - `Distributed Lock`


**「分布式锁」即：控制分布式系统“不同进程共同访问同一共享资源”的一种锁的实现，以达到“共享资源读写互斥、防止进程读写彼此干扰”的目的，从而保障“资源一致性”**

> - [分布式系统 - 分布式锁及实现方案 | Java 全栈知识体系](https://pdai.tech/md/arch/arch-z-lock.html)
> - [分布式锁](https://dreamgoing.github.io/%E5%88%86%E5%B8%83%E5%BC%8F%E9%94%81.html)
> - [深度剖析：Redis 分布式锁到底安全吗？看完这篇文章彻底懂了！ | Kaito's Blog](http://kaito-kidd.com/2021/06/08/is-redis-distributed-lock-really-safe/)
> - [拉勾技术专栏：分布式技术原理与实战 45 讲-分布式锁有哪些应用场景和实现？](https://learn.lianglianglee.com/%E4%B8%93%E6%A0%8F/%E5%88%86%E5%B8%83%E5%BC%8F%E6%8A%80%E6%9C%AF%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E6%88%9845%E8%AE%B2-%E5%AE%8C/11%20%E5%88%86%E5%B8%83%E5%BC%8F%E9%94%81%E6%9C%89%E5%93%AA%E4%BA%9B%E5%BA%94%E7%94%A8%E5%9C%BA%E6%99%AF%E5%92%8C%E5%AE%9E%E7%8E%B0%EF%BC%9F.md)
> - [Redis分布式锁](https://redis.com.cn/topics/distlock.html)


由于  `Redis` 自带分布式属性且 `Redis` 是单线程执行命令的特性，因此使用 `Redis` 也常常用于实现「分布式锁」，如：

- 最简单的 `setnx（SET if Not eXists）` 来实现分布式锁（存在死锁风险）
- 利用原子性判断 `incr KEY`，判断返回值是否等于 `1`（存在死锁风险）
- 分布式集群情况下通过红锁（`Redlock`）算法实现分布式锁

-----

4、计数器和统计数据 - `Counters and statistics`

> - [Redis in Action：5.2 Counters and statistics | Redis](https://redis.com/ebook/part-2-core-concepts/chapter-5-using-redis-for-application-support/5-2-counters-and-statistics/)
> - [Redis in Action](https://awesome-programming-books.github.io/redis/Redis%E5%AE%9E%E6%88%98.pdf)

利用 `incr/incrby/incrbyfloat` 命令实现对：文章的阅读量、微博点赞数、允许一定的延迟，先写入 `Redis` 再定时同步到数据库（高并发削峰的一种情况）

-----

5、限流器 - `RateLimiter`

> [分布式限流：基于 Redis 实现 - 熊喵君的博客 | PANDAYCHEN](https://pandaychen.github.io/2020/09/21/A-DISTRIBUTE-GOREDIS-RATELIMITER-ANALYSIS/)

同样利用 `incr KEY` 命令自动 `+1` 操作，如果 `KEY` 不存在会先设置 `KEY` 再 `+1`，可以以访问者的唯一信息作为 `key`，访问一次增加一次计数超过次数则返回 `false`，再结合过期时间，从而达到限制访问频率保障系统的稳定性

-----

6、抽奖

> [【开发经验】redis实现抽奖功能_51CTO博客_redis 抽奖功能](https://blog.51cto.com/u_12633149/3699681)

利用集合特性-「元素具有唯一性」来做一个抽奖池（`SADD SET MEMBERS...` 向集合添加元素，`SMEMBERS SET` 查看集合元素），然后 `spop <SET> [<count>]` 随机移除集合中的指定个数元素 或 `SRANDMEMBER <SET> <count>` 随机获取指定个数元素（可重复参与抽奖）

`SPOP` 命令会移除被随机选中的元素， 而 `SRANDMEMBER` 命令则不会移除被随机选中的元素。

-----

7、位图统计-`BitMap`

> - [Redis 位图基础到统计活跃用户 - 掘金](https://juejin.cn/post/6844904084185546760)
> - [利用 Redis 位运算快速实现签到统计功能](https://gist.github.com/lifeblood/75287f739ddf9a0b9b5e345bd87518eb)
> - [Redis 实战篇：巧用 Bitmap 实现亿级数据统计 - Redis - SegmentFault 思否](https://segmentfault.com/a/1190000040177140)

利用 `string` 的 `bitcount` 可以实现在线用户数、留存用户统计（一些直播场景）或签到统计（论坛...教为常见）。

-------

8、基数统计-HyperLogLog

> - [Redis 中 HyperLogLog 的使用场景 - 程序员自由之路 - 博客园](https://www.cnblogs.com/54chensongxia/p/13803465.html)
> - [Redis HyperLogLog 是什么？](https://developer.aliyun.com/article/905171)
> - [学透 Redis HyperLogLog，看这篇就够了](https://cloud.tencent.com/developer/article/2333100)

对于大量需要“去重数据统计”，譬如：多少个用户访问了本站点？“去重”是`Set/Hash` 数据类型的特性，但是这些都比较耗费内存，通过 `HyperLogLog` 可以在耗费极小内存（12KB）下大概估算出去重基数。

-----

9、购物车

- [SpringBoot2 | 第二十九篇：Redis 实现购物车 | Fatal's Blog](https://ynfatal.github.io/2019/08/17/SpringBoot2/SpringBoot2%E7%AC%AC%E4%BA%8C%E5%8D%81%E4%B9%9D%E7%AF%87Redis%E5%AE%9E%E7%8E%B0%E8%B4%AD%E7%89%A9%E8%BD%A6/)
- [天猫Java研发三面：讲讲Redis实现购物车的设计思路！-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1542943)
- [Redis实现购物车设计思路 - CodeAntenna](https://codeantenna.com/a/o9Q9sdSts2)
- [【Java 实战】通过Redis实现购物车功能 - 猫的树kireCat - 博客园](https://www.cnblogs.com/kire-cat/p/16886912.html)
- [大厂技术，基于的Redis 购物车设计 - 掘金](https://juejin.cn/post/6915284243866206221#comment)

类对象数据，使用 `Redis Hash` 进行存储（电商场景）

-------

10、标签功能

- [17 如何理解、选择并使用Redis的核心数据类型？](https://learn.lianglianglee.com/%E4%B8%93%E6%A0%8F/300%E5%88%86%E9%92%9F%E5%90%83%E9%80%8F%E5%88%86%E5%B8%83%E5%BC%8F%E7%BC%93%E5%AD%98-%E5%AE%8C/17%20%E5%A6%82%E4%BD%95%E7%90%86%E8%A7%A3%E3%80%81%E9%80%89%E6%8B%A9%E5%B9%B6%E4%BD%BF%E7%94%A8Redis%E7%9A%84%E6%A0%B8%E5%BF%83%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B%EF%BC%9F.md)
- [电商用户标签服务系统建设及演进](https://neway6655.github.io/user-profile/2018/11/07/user-profile-tagging-system.html)

利用集合的特性，如：记录维护商品的标签属性（电商场景）、仿微信对收藏文件打标签/朋友圈对某个标签组可见或不可见（社交场景）

------

11、筛选功能

依然是利用集合的特性，处理「交/并/补(差)集」实现：商品筛选（电商场景）

-----

11、用户关注、推荐模型

- [【开发经验】redis实现共同好友功能_51CTO博客_redis 共同好友](https://blog.51cto.com/u_12633149/3698039)
- [Redis使用Set集合实现好友功能（关注/互粉/共同好友等） - 爱学习的eamon - 勿忘初心方得始终](https://blog.97it.net/archives/140.html)
- [10｜存储模块：如何用Redis解决推荐系统特征的存储问题？](http://8.129.87.238/157-%E6%B7%B1%E5%BA%A6%E5%AD%A6%E4%B9%A0%E6%8E%A8%E8%8D%90%E7%B3%BB%E7%BB%9F%E5%AE%9E%E6%88%98/05-%E7%BA%BF%E4%B8%8A%E6%9C%8D%E5%8A%A1%E7%AF%87%20%287%E8%AE%B2%29/10%EF%BD%9C%E5%AD%98%E5%82%A8%E6%A8%A1%E5%9D%97%EF%BC%9A%E5%A6%82%E4%BD%95%E7%94%A8Redis%E8%A7%A3%E5%86%B3%E6%8E%A8%E8%8D%90%E7%B3%BB%E7%BB%9F%E7%89%B9%E5%BE%81%E7%9A%84%E5%AD%98%E5%82%A8%E9%97%AE%E9%A2%98%EF%BC%9F.html)


依然是利用集合的特性，处理「交/并/补(差)集」实现：共同好友、可能认识的人...（社交场景）

-----

13、榜单功能

- [兄弟，王者荣耀的段位排行榜是通过Redis实现的？_ITPUB博客](http://blog.itpub.net/70027826/viewspace-2978582/)
- [【开发经验】redis排行榜功能（日榜、周榜、月榜）_51CTO博客_redis排行榜实现](https://blog.51cto.com/u_12633149/3699775)
- [【DB系列】借助Redis实现排行榜功能（应用篇） | 一灰灰Blog](https://spring.hhui.top/spring-blog/2018/12/25/181225-SpringBoot%E5%BA%94%E7%94%A8%E7%AF%87%E4%B9%8B%E5%80%9F%E5%8A%A9Redis%E5%AE%9E%E7%8E%B0%E6%8E%92%E8%A1%8C%E6%A6%9C%E5%8A%9F%E8%83%BD/)
- [基于Redis 千万级用户排行榜最佳实践-阿里云开发者社区](https://developer.aliyun.com/article/312562)
- [Redis 实用小技巧——如何实现一个排行榜功能 | Laravel China 社区](https://learnku.com/articles/77329)
- [想知道谁是你的最佳用户？基于Redis实现排行榜周期榜与最近N期榜 - 腾讯云开发者 - 博客园](https://www.cnblogs.com/qcloud1001/archive/2018/12/13/10115588.html)
- [排行榜系统设计](https://leriou.github.io/2019-06-01-recommended-system-ranking-system-md/)
- [凉了呀，面试官叫我设计一个排行榜。 - why技术 - 博客园](https://www.cnblogs.com/thisiswhy/p/14470861.html)

用 `zset` 来实现绑定排序并记录点击数/榜单值之类的（直播场景、BBS论坛场景、热点信息排序场景）

-----

14、用户消息时间线timeline

- [系统设计之——Twitter时间线、搜索功能](https://www.oo2ee.com/?p=367)
- [Redis实现朋友圈，微博等Feed流功能,实现Feed流微服务(业务场景、实现思路和环境搭建)_微博feed流设计-CSDN博客](https://blog.csdn.net/qq_35427589/article/details/128325747)
- [朋友圈式的Timeline设计方案 - 一只安静的猫](https://www.myway5.com/index.php/2017/06/29/timeline-design/)
- [Redis实现朋友圈，微博等Feed流功能,实现Feed流微服务(业务场景、实现思路和环境搭建)-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/2193811)

-----

15、消息队列

- [redis实现消息队列的几种方式及其优劣_redis 队列_衡与墨的博客-CSDN博客](https://blog.csdn.net/le_17_4_6/article/details/124457648)
- [Redis实现消息队列的4种方案 - 简书](https://www.jianshu.com/p/d32b16f12f09)
- [“程”风破浪的开发者｜你真的会用Redis做消息队列吗_学习方法_芥末拌个饭吧_InfoQ写作社区](https://xie.infoq.cn/article/7107605ea187f889b4867ee60)

-----

16、全局唯一 `ID`：利用 `incr/incrby` 

- [Redis实战9-全局唯一ID-龙果博客-IT技术文章-龙果学院博客](https://blog.roncoo.com/article/1619515023644368898)
- [简单实用！利用Redis轻松实现高并发全局ID生成器-redis分布式id生成器](https://www.51cto.com/article/743438.html)
- [全局唯一自增 ID 生成方案](https://xli1224.github.io/2018/03/10/global-id-generation/)
- [使用redis生成唯一编号_11月日更_喵叔_InfoQ写作社区](https://xie.infoq.cn/article/e762ff1833c0ed41816981500)

----

17、附件的人/车/xxx：利用  `Redis GEO` 即可实现

> [使用 Redis GEO 储存地理位置](https://mp.weixin.qq.com/s/8AbQMGuK4TVyK_YVRdcHsg)

-----------

`Redis` 大部分情况用来做缓存、队列来应对高并发场景，应对流量的削峰填谷，而面试最多的可能就是扯「秒杀系统」

> - [秒杀系统流量削峰这事应该怎么做？为什么要削峰呢？](https://cloud.tencent.com/developer/article/1552608)
> - [秒杀系统的设计思考](https://note.dolyw.com/distributed/01-Design-Thinking.html)

但是 `Redis` 的应用场景远远不止「秒杀场景」，还有很多。要对 `Redis` 的应用场景熟悉，主要是对 `Redis` 自身的特性以及其 5 种逻辑数据类型的特性以及对应数据类型的操作命令要熟悉，如：

1. `Redis` 自身的特性：**基于内存、自身支持分布式**、本身是 `Key/Value` 的 `NoSQL` 数据存储系统
    - `Key/Value` 意味着：不管哪一种数据类型，其最终存的都是字符串类型
    - 自身支持分布式：**解决集群信息共享，配合原子性理论可实现全局唯一**
    - **执行命令时是单一线程，操作具有原子性，可用作实现一些“锁”场景：分布式锁、线程锁**
2. `String` 类型用于存单个值的快速存取操作
    - **一般来说 `string+json` 可以应对所有情况，但是 `json` 的编码和解码太慢**
    - 最主要的就是：**数字字符串可以做运算、`incr/incrby/incrbyfloat` 原子操作可用于计数、限流场景**
3. `Hash` 类型其实就是：`Key => [ [Field => String] ]` 的嵌套
    - **虽说网上称该类型初衷不是为了对象设计，但都没说初衷是用来干嘛的...不可否认这是最接近对象数据存储的一种数据类型**
    - 数据特性在于 `String` 类型，应用特性在该数据类型“**对象存储**”的设计
    - **当你觉得需要使用 `String + JSON` 的方式就该考虑 `Hash` 数据类型**
4. `List`（队列） 类型：队列本身 **「先进先出」**，而 `List` 类型大部分情况下应该都是使用双向链表存储，操作头尾指针都非常的快，因此一些 **「后进先出」** 的场景也使用
    - **涉及排队、顺序的场景，需要优先考虑该数据类型**
    - **可作简单的消息队列：削峰填谷、异步、解耦**，因此有此类需要的场景也应优先考虑该数据类型
5. `Set`（集合）类型，是一个无序集合。从数学概念上看集合的特性-一堆确定的元素组成的整体，元素具有无序性、**互异性（元素只能出现一次）、确定性（事物本身只有2种相反的情况）**
    - 因此：如果应用的场景中的对象具有唯一性就应该就要考虑该数据类型，然后思考是否最终需求就是做一些集合 「交、并、补」运算呢？
    - 对需要“池化”的数据进行初始化，然后对池内数据进行增删查改操作，如：初始化抽奖人员，随机选元素即为“抽奖”
    - 并集：一些合并操作，如：做一个收藏夹功能，实现本地和远端的数据合并、选择列表的全选功能
    - 交集：子集/父集的表示，其实是交集的一种特殊反馈，可以做：共同好友、商品筛选
    - 补集（差集）：选择列表的反选功能 或 一些推荐模型-可能认识的人/可能喜欢的商品...
6. `zset` 就是一个有序集合，在 `Set` 的场景下做了一个 **有序** 的操作，属于是对 `Set` 的一个扩展
    - **如果涉及唯一、有序 两个特性，那么就该优先考虑是否要用该数据类型**。如：好友亲密度排序、xx榜单场景

## Redis 命令注意事项

没有任何一篇文章可以比得过官方的 [「`Redis` 命令手册」](https://redis.com.cn/commands.html)（英文版：[Redis 命令参考](https://redis.io/commands/)），简单浏览操作一次即可。

这部分内容只是整理了手册 「`Redis` 命令手册」中提到的 `Warning` 信息或被我忽视的点

1. **生产环境使用 KEYS 命令需要非常小心，在大的数据库上执行命令会影响性能。如果需要查询某些 KEY ，考虑使用 `SCAN/SETS`命令**。
2. `exists KEY1 KEY2 KEY3...` 返回的存在值的 KEY 的个数，**如果传递了两个重复的 `KEY` 返回的值也会加 1**
3. [`Redis` 使用 `DUMP/RESTORE` 命令对值进行序列化/反序列化](https://blog.csdn.net/pengpengzhou/article/details/109200879)，用于 `Redis Key` 迁移的情况使用



## 为什么 `KEYS <pattern>` 命令会慢？

> - [redis keys命令，生产环境慎用，最好屏蔽掉](https://juejin.cn/post/7112071686911950884)
> - [redis-避免生产环境使用keys命令 ](https://www.cnblogs.com/laggage/p/13696895.html)
> - [redis debug命令详解](https://developer.aliyun.com/article/33)

模拟：

1. `debug populate 100000` 迅速产生 `10w` 个 `Key`
2. 设置 `redis` 慢日志信息
    - `config get slowlog-log-slower-than` 慢日志的预设阈值（单位微秒，默认是 `10000` 微秒 = `10` 毫秒，**一般设置为 `1ms=1000μs`**）
    - `config get slowlog-max-len` 查看慢日志存储数量（默认是 `128`，当慢日志大于该值时候旧日志会被丢弃，**一般设置为 1000**）
    - `slowlog len` 查看当前慢日志条数
    - `slowlog get [len]` 查看 所有/最近 `N` 条 慢日志记录
    - `slowlog reset` 清空慢日志
3. `slowlog` 格式
    ```log
    127.0.0.1:6379> SLOWLOG get 1
    1) 1) (integer) 1 # 慢日志标识 ID
       2) (integer) 1693045477 # 慢日志产生时间戳
       3) (integer) 27855 # 执行时长（单位是微秒），1ms=1000μs
       4) 1) "keys" # 慢日志命令及其参数
          2) "*"
       5) "127.0.0.1:37978" # 客户端 IP+端口
       6) ""
    ```

原因：

1. `Redis` 是 `Key=>Value` 的内存数据库，底层是通过 `Hash` 数据结构存储的，如果 `KEYS <KEY>` 那么复杂度为 0(1)，但是对于模糊匹配则需要遍历所有 `KEY` 才可以知道结果
2. `Redis` 执行是单线程的（即：同一时间只能执行单个命令），单一操作时间太长会阻碍后续操作执行（可以通过 `debug sleep 1s` 模拟）

解决：

1. 建议使用 `scan index [MATCH pattern] [COUNT count]` 命令以迭代的方式进行遍历查询
    - `SCAN` 命令是非阻塞的，它会分段向 `Redis` 服务发起请求获取 `key`，因此允许在长时间的遍历操作中同时运行其他命令，保证了 `Redis` 的响应能力
    - `count` 限制的是单次查询的 `key` 数量，即约等于限定服务器单次遍历的字典槽位数量，而不是限定返回结果的数量
    - 在查找过程中新增或删除一个元素，这个元素可能会出现也可能不会（即：对结果不能提供稳定的保证）
    - 同一个元素可能会被返回多次，排重需要业务自己处理
    - 命令返回下一次卡槽扫描的位置，然后替换 `index` 直到返回结果为 `0` 可以大致认为全部扫描完毕
2. 避免误用，建议通过 `redis.conf` 配置文件屏蔽
    ```conf
    rename-command FLUSHALL ""
    rename-command FLUSHDB ""
    rename-command KEYS ""
    ```

## `Redis` 淘汰策略有哪些？如何选择？

**「淘汰策略 - `Key Eviction`」指的是：在 `Redis` 实例占用内存存储空间达到了其设定的阈值情况下，针对「未过期的 `Key`」 所采用的驱逐方式。**

### 最大内存

通过 `config get maxmemory` 可以查看当前实例的最大存储内存空间。该数值如果为 `0` 表示无限制，即淘汰策略设置无效。`64` 位系统默认值为 `0`，而 `32` 位系统默认值为 `3GB`，可以通过 `config set maxmemory 5gb` 命令修改最大内存值。

```plain
# 1k => 1000 bytes
# 1kb => 1024 bytes
# 1m => 1000000 bytes
# 1mb => 1024*1024 bytes
# 1g => 1000000000 bytes
# 1gb => 1024*1024*1024 bytes
```

### 淘汰策略

可以粗略的分为四种淘汰算法：

- `LRU - Least Recently Used` 算法 ：最近最少使用（访问时间维度）
- `LFU - Least Frequently Used` 算法 ：最近最小使用算法（使用频率纬度），该算法是 `Redis 4.0` 引入的
- `Random` 算法 ： 随机的进行删除 `Key`
- `TTL` 算法 ： 按照过期时间维度来进行删除 `Key`

共衍生出 8 种淘汰策略：

**不淘汰策略**

- `noeviction` : **不驱逐** - 不对现有的未过期 `Key` 进行驱逐，新 `Key` 写入时报错 `OOM command not allowed when used memory > 'maxmemory'.`

**针对所有 `KEY` 进行淘汰**

- `allkeys-lru` : **优先淘汰最久未访问的 `KEY`**
- `allkeys-lfu` : **优先淘汰访问频次最低的 `KEY`**
- `allkeys-random` : **随机的进行淘汰**

**针对设置了过期时间的 `KEY` 进行淘汰**

- `volatile-lru` : **优先淘汰最久未访问的 `KEY`**
- `volatile-lfu` : **优先淘汰访问频次最低的 `KEY`**
- `volatile-random` : **随机的进行淘汰**
- `volatile-ttl` : **优先删除即将过期的 `KEY`**

### 如何选择

https://www.jf3q.com/article/detail/5835

1. noeviction: 内存充足或数据不可丢失。适用于关键数据。
2. allkeys-lru: 数据访问不均，但经常用的应保留。适用于web缓存。
3. allkeys-lfu: 访问频率稳定，长时间不变。适用于稳定工作负载。
4. allkeys-random: 数据访问无规律，或内存非常紧张。适用于暂态数据。
5. volatile-lru: 只有部分键设置了TTL。适用于缓存+持久化混用。
6. volatile-lfu: 部分键设置了TTL且访问频率稳定。适用于混合模式下稳定访问。
7. volatile-ttl: 大部分键依赖TTL过期。适用于短生命周期数据。
8. volatile-random: 部分键设置了TTL且访问无规律。适用于混合模式下暂态数据。

选择：首先，明确是否所有键都重要或只有带 `TTL` 的键重要。其次，了解访问模式—是否稳定或变化快。最后，实验验证。


## Redis 使用规范

旧版本的Redis中，使用":"（冒号）作为键名的一部分来创建一种类似目录结构的命名模式，并没有直接提升Redis的索引效率，因为Redis本身并不使用这种结构来优化存储或检索。这种做法主要是为了用户便利：

1. **逻辑分组**：使用冒号可以将相关的键分组在一起，便于逻辑上的组织和理解。例如，`user:123:name` 和 `user:123:email` 明确表示这些键属于ID为123的用户。

2. **模式匹配**：Redis的某些操作支持模式匹配，如 `KEYS user:*` 可以找到所有以 `user:` 开头的键。这种命名约定使得模式匹配更加有效。

3. **易于管理**：便于维护和管理数据，尤其是在处理大量键时。

总结，":"的使用更多是一种命名约定，便于用户管理和操作数据，而非Redis内部的索引或存储优化机制。


> 事实上这种目录树结构的是一种相当好的索引，利于查询和检索，它在一段时间内都是redis的主要存储策略，但它也有着局限性，使用者必须设计好目录层树才能使得效率更好。现在已经不这样的了，现在都是散列hash,所以这样写key目前也是没有了具体的意义了。

这句话中的“现在已经不这样的了，现在都是散列hash”，可能是指Redis的使用模式和数据结构的演变。具体来说：

1. **早期的使用模式**：早期，用户可能倾向于使用冒号分隔的键名来模拟目录结构，以逻辑方式组织数据。这种做法便于理解和维护，但对Redis的性能或索引效率没有直接影响。

2. **散列（Hash）的使用**：随着时间的发展，Redis用户可能更多地采用散列数据类型（hashes）来存储和组织复杂的数据结构。在Redis中，散列是一种将多个键值对存储在一个Redis键下的方法。例如，可以使用一个散列来存储用户的所有属性，而不是为每个属性创建一个独立的键。

3. **效率考量**：使用散列可以更高效地存储和访问相关联的数据，尤其是当涉及到频繁的读写操作时。在一些场景下，使用散列而非多个独立键可以减少内存使用，提高数据处理效率。

总结，这句话可能是在描述Redis用户从早期使用类似目录结构的键命名约定（冒号分隔）转向更加高效地使用散列数据类型的趋势。

- [Redis 很屌，不懂使用规范就糟蹋了 -阿里云开发者社区](https://developer.aliyun.com/article/905158)

## `Redis` 优化建议

1. 尽量使用短的 `key`，对于 `value` 可以精简的就精简，能用 `int` 就用 `int`
2. 避免使用 `keys *` 命令，使用 `scan` 命令替代
3. 应该尽可能的为 `key` 设置 `ttl` 有效期（[redis中获取没有设置ttl过期时间的key - knowledge-is-power - 博客园](https://www.cnblogs.com/imdba/p/10161343.html)、[Python 实现：获取没有设置ttl的key脚本](http://blog.itpub.net/22664653/viewspace-2153419/)）
4. 选择回收策略（`config get maxmemory-policy`），即：当 `Redis` 实例空间内存不足时会回收一部分 `Key`
    - `volatile-lru` ： 只对设置了过期时间的 `key` 按照

## Redis 相比 memcached 有哪些优势?

- [Redis 键(key) | 菜鸟教程](https://www.runoob.com/redis/redis-keys.html)

## redis 并发锁的实现

使用 Redis 的 SET 命令和 NX 选项来实现锁：

```php
<?php
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);

$lock_key = 'my_lock';

// 尝试获取锁
$lock_acquired = $redis->set($lock_key, 1, array('NX', 'EX' => 60));

if (!$lock_acquired) {
    echo 'Failed to acquire lock';
    exit;
}

// 成功获取锁，进行处理
// ...

// 释放锁
$redis->del($lock_key);
?>
```
首先通过 $redis->set() 方法尝试获取锁，如果成功则返回 true，否则返回 false。

SET 命令中的 NX 选项表示仅在键不存在时才进行设置。EX 选项指定锁的过期时间为 60 秒。

由于 Redis 是单线程的，因此在使用 Redis 实现锁时，需要保证对锁的操作是原子的，即不能被其他进程或线程打断。上述代码中，SET 命令的 NX 选项能够保证原子性，因为仅当键不存在时才进行设置。

- [七种方案！探讨Redis分布式锁的正确使用姿势](https://ost.51cto.com/posts/18881)



## 阅读的一些文章

- [秒杀系统流量削峰这事应该怎么做？为什么要削峰呢？](https://cloud.tencent.com/developer/article/1552608)
- [秒杀系统的设计思考](https://note.dolyw.com/distributed/01-Design-Thinking.html)
- [全站缓存时代](https://segmentfault.com/a/1190000005808789)
- [redis数据类型、应用场景、常用命令](https://www.cnblogs.com/yinchh/p/10484948.html)
- [互联网公司使用 Redis 的16个应用场景](https://ibit.tech/archives/redis-16-usage-situation)
- [Redis分布式原理](https://www.cnblogs.com/jing-yi/p/12932025.html)
- [`Redis` 使用 `DUMP/RESTORE` 命令对值进行序列化/反序列化](https://blog.csdn.net/pengpengzhou/article/details/109200879)
- [redis keys命令，生产环境慎用，最好屏蔽掉](https://juejin.cn/post/7112071686911950884)
- [redis-避免生产环境使用keys命令 ](https://www.cnblogs.com/laggage/p/13696895.html)
- [redis debug命令详解](https://developer.aliyun.com/article/33)
- [Redis RESTORE](http://doc.redisfans.com/key/restore.html)
- [Distributed Locks with Redis](https://redis.io/docs/manual/patterns/distributed-locks/)、[中文版：Distributed Locks with Redis](http://redis.cn/topics/distlock.html)
- [浅析 Redlock 分布式锁实现原理](https://her-cat.com/posts/2022/05/08/redlock-distributed-lock/)
- [高并发系统设计（十三）：消息队列的三大作用：削峰填谷、异步处理、模块解耦](https://www.cnblogs.com/wt645631686/p/13199532.html)
- [【系统设计】如何设计 Twitter 时间线和搜索？](https://www.cnblogs.com/yinbiao/p/16164975.html)
- [一个秒杀系统的设计思考](https://www.cser.club/GitBook-Notes/#/java/yi-ge-miao-sha-xi-tong-de-she-ji-si-kao)
- [系统设计之——Twitter时间线、搜索功能](https://www.oo2ee.com/?p=367)
- [如何用Redis解决削峰填谷问题（如何用redis削峰）](https://www.dbs724.com/232560.html)
- [为什么Redis集群有16384个槽](https://zhuanlan.zhihu.com/p/80335611)
- [redis 怎么将两个关联对象存到一个卡槽](https://blog.51cto.com/u_16213416/7097794)
- [把Redis当作队列来用，真的合适吗？](https://www.51cto.com/article/659208.html)
- [Redis Pub/Sub 发布订阅模式的深度解析与实现消息队列](https://juejin.cn/post/7112434646851584013)
- [redis 发布订阅方法与缺陷](https://www.cnblogs.com/shangwei/p/14888728.html)
- https://mp.weixin.qq.com/s/LKoZEI93zZYeIyT7hpBDTQ
- https://www.cnblogs.com/yinchh/p/10484948.html
- https://www.runoob.com/redis/redis-data-types.html
- https://blog.51cto.com/BugMaker/5588444
- https://www.cnblogs.com/sheseido/p/11243341.html
- https://www.51cto.com/article/743438.html
- https://zhuanlan.zhihu.com/p/95814245
- https://blog.csdn.net/m0_60915009/article/details/130466581
- https://www.iteye.com/blog/justcoding-2248949
- [2023-05-24：为什么要使用Redis做缓存？](https://juejin.cn/post/7236670284559532090)
- [2023-05-28：为什么Redis单线程模型效率也能那么高？](https://juejin.cn/post/7238132993532461116)
- [2023-05-30：Redis6.0为什么要引入多线程呢？](https://juejin.cn/post/7238917620849950775)
- [2023-06-01：讲一讲Redis常见数据结构以及使用场景。](https://juejin.cn/post/7239645564256878647)
- [2023-06-05：Redis官方为什么不提供 Windows版本？](https://juejin.cn/post/7241129272378572858)
- [2023-06-07：Redis 持久化方式有哪些？以及有什么区别？](https://juejin.cn/post/7241859817563947045)
- [2023-06-09：什么是Redis事务？原理是什么？](https://juejin.cn/post/7242677017035096123)
- [2023-06-13：统计高并发网站每个网页每天的 UV 数据，结合Redis你会如何实现？](https://juejin.cn/post/7244104719135359032)
- [2023-06-15：说一说Redis的Key和Value的数据结构组织?](https://juejin.cn/post/7244819106343764028)
- [2023-06-19：讲一讲Redis分布式锁的实现？](https://juejin.cn/post/7246293244636381241)
- [2023-07-03：讲一讲Redis缓存的数据一致性问题和处理方案。](https://juejin.cn/post/7251512482152497209)
- [一条 Redis 命令是如何执行的？ - 掘金](https://juejin.cn/post/7070925667776331813)
- [全网最详细Redis教程之Redis持久化机制 - 掘金](https://juejin.cn/post/7044699344091480077?searchId=20230826233950DEB23674A0CD358826DF#comment)
- [官方文档：Key eviction | Redis](https://redis.io/docs/reference/eviction/)
- [redis系列介绍八-淘汰策略 | Nicksxs's Blog](https://nicksxs.me/2020/04/18/redis%E7%B3%BB%E5%88%97%E4%BB%8B%E7%BB%8D%E5%85%AB/)
- [深入学习 Redis 原理 - 淘汰策略 | A Big Boy Blog - Tech Articls & Notes](https://sulangsss.github.io/2019/10/13/Redis/%E6%B7%B1%E5%85%A5%E5%AD%A6%E4%B9%A0%20Redis%20%E5%8E%9F%E7%90%86%20-%20%E6%B7%98%E6%B1%B0%E7%AD%96%E7%95%A5/)
- [Redis技术 - ITPUB技术栈](https://z.itpub.net/stack/detail/10149)
- [Redis 过期删除策略和内存淘汰策略有什么区别？ | 小林coding](https://xiaolincoding.com/redis/module/strategy.html#%E5%86%85%E5%AD%98%E6%B7%98%E6%B1%B0%E7%AD%96%E7%95%A5)
- [redis中主从、哨兵和集群这三个有什么区别 ？-CSDN博客](https://codegoogler.blog.csdn.net/article/details/129807237)
- [深入理解Redis的单机、主从、哨兵、集群四种模式_节点_数据_存储](https://www.sohu.com/a/669912638_121687414)
- [使用HAProxy、PHP、Redis和MySQL支撑10亿请求每周架构细节 · 学习日记 · 看云](https://www.kancloud.cn/qinfengyan/study/121858)
- [面试官：项目中怎样保证redis的缓存和数据库数据一致性？java高频面试八股文，建议收藏！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1FG411Z7Wk/?vd_source=53b4bc277159163c329436ad5004e713)
- [缓存更新的套路 | 酷 壳 - CoolShell](https://coolshell.cn/articles/17416.html)
- [由12306.cn谈谈网站性能技术 | 酷 壳 - CoolShell](https://coolshell.cn/articles/6470.html)
- [Redis 究竟是单线程还是多线程呢？ - 掘金](https://juejin.cn/post/7065960336335044645)
- [深度剖析：Redis分布式锁到底安全吗？看完这篇文章彻底懂了！ | Kaito's Blog](http://kaito-kidd.com/2021/06/08/is-redis-distributed-lock-really-safe/)
- [Redis面试八股文-bitmap类型和实战应用（大数据量精确统计、状态/标签记录、布隆过滤器等） | 程序猿老龚](https://gjh.me/?p=1158)
- [Redis进阶：深入解读阿里云Redis开发规范（修订版） | HeapDump性能社区](https://heapdump.cn/article/210671)
- [Redis键中冒号的用途是什么？-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/ask/sof/119320)
- [redis key命名规范 - 墨天轮](https://www.modb.pro/db/394308)
- [加餐（六）| Redis的使用规范小建议](https://time.geekbang.org/column/article/309089)
- [Redis进阶-如何发现和优雅的处理BigKey一二事_51CTO博客_Redis bigkey](https://blog.51cto.com/u_15239532/2835941)
- [深入理解大数据架构之——事务及其ACID特性 - Heriam - 博客园](https://www.cnblogs.com/cciejh/p/acid.html)



-----

Redis 的部署模式：单机、主从、哨兵、分片集群

Redis 的 HAProxy 应用场景：

1. 读写分离：将读请求路由到从服务器，写请求到主服务器。
2. 多数据中心：分发请求到地理位置不同的Redis实例。
3. 故障转移：自动将流量从失效节点重定向到健康节点。
4. 水平扩展：当一个Redis实例达到性能上限时，使用HAProxy进行负载均衡。
5. 高可用：与Redis哨兵或集群结合，提供额外的可用性保障。
6. 连接池复用：减少Redis新连接的开销。
7. 限流：控制每秒请求到Redis的数量。
8. 监控与日志：收集性能数据和故障信息。
9. 灰度发布：逐步引入新版本或配置，减小风险。

通过这些方式，HAProxy可以增强Redis的性能，可用性和可管理性。


------------

## Redis 深度历险：核心原理与应用实践




--------


## 面试题

### Redis 基础

- [什么是Redis? 简述它的优缺点?](https://bbs.huaweicloud.com/blogs/366040)
- [redis基础，优缺点、适合场景、数据淘汰/删除策略、持久化三种方案、并发处理](https://blog.csdn.net/h2604396739/article/details/89157844)
- Redis 能干什么？
- Redis支持哪几种数据类型?
- Redis主要消耗什么物理资源?
- Redis的全称是什么?
- Redis有哪几种数据淘汰策略?
- Redis官方为什么不提供Windows版本?
- 一个字符串类型的值能存储最大容量是多少?
- 为什么Redis需要把所有数据放到内存中?
- Redis集群方案应该怎么做? 都有哪些方案?
- Redis集群方案什么情况下会导致整个集群不可用?
- MySQL里有2000w数据，redis中只存20w的数据，如何保证redis中的数据都是热点数据?
- Redis有哪些适合的场景?
- Redis和Redisson有什么关系?（phpredis 和 redis 有什么关系？）
- Jedis与Redisson对比有什么优缺点?（phpredis 有哪些容易踩坑的地方？和 php redis 原生扩展对比有什么优缺点？laravel 是如何操作 redis 的？）
- Redis如何设置密码及验证密码?
- 说说Redis哈希槽的概念?
- Redis集群的主从复制模型是怎样的?
- Redis集群会有写操作丢失吗? 为什么?
- Redis集群之间是如何复制的?
- Redis集群最大节点个数是多少?
- Redis集群如何选择数据库?
- 怎么测试Redis的连通性?
- Redis中的管道有什么用?
- 怎么理解Redis事务?
- Redis事务相关的命令有哪几个?
- Redis key的过期时间和永久有效分别怎么设置?
- Redis如何做内存优化?
- Redis回收进程如何工作的?
- 为什么redis需要把所有数据放到内存中?
- Redis常见的性能问题都有哪些? 如何解决?
- Redis最适合的场景有哪些?
- Memcache与Redis的区别都有哪些?
- Redis有哪几种数据结构?
- Redis的持久化是什么?
- RDB的优缺点?
- AOF的优缺点?
- 简单说说缓存雪崩及解决方法？
- 缓存穿透怎么导致的?
- 项目中有出现过缓存击穿，简单说说怎么回事?
- 遇到缓存一致性问题，你怎么解决的?
- 为什么要用 Redis 而不用 map/guava 做缓存?
- 如何选择合适的持久化方式?
- Redis持久化数据和缓存怎么做扩容?
- Redis的内存淘汰策略有哪些?
- 简单描述下Redis线程模型
- Redis事务其他实现方式?
- 生产环境中的 redis 是怎么部署的?
- 如何解决 Redis 的并发竞争 Key 问题?
- 什么是 RedLock?
- 什么时候需要缓存降级？
- 如何保证缓存与数据库双写的数据一致性？
- [如何保证Redis缓存和数据库数据一致性？](https://www.zhihu.com/question/319817091/answer/1699095849)
- 如何保证Redis缓存和数据库数据一致性？
- 如何用 Redis 高效实现12306的复杂售票业务
- 新浪微博突发事件如何做好Redis缓存的高可用
- 高并发场景缓存穿透&失效&雪崩如何解决
- Redis高并发场景热点缓存如何重建
- Redis集群架构如何抗住12306与双11的洪峰流量
- Redis缓存与数据库双写不一致如何解决
- 双十一亿级用户日活统计如何用Redis快速计算
- 双十一电商推荐系统如何用Redis实现
- 类似微信的社交App朋友圈关注模型如何设计实现
- 美团单车如何基于Redis快速找到附近的车
- Redis分布式锁主从架构锁失效问题如何解决
- 从CAP角度解释下Redis&Zookeeper锁架构异同
- 超大并发的分布式锁架构该如何设计
- Redis底层ZSet跳表是如何设计与实现的
- Redis底层ZSet实现压缩列表和跳表如何选择
- Redis 6.0 多线程模型比单线程优化在哪里了
- [Redis与Memcached的incr/decr差异对比](https://www.cnblogs.com/exceptioneye/p/4783310.html)
- redis能存放多少key？


### Redis 的基础知识

- Redis 是什么？
- Redis 的特点是什么？
- Redis 的优缺点是什么？
- Redis 相比 Memcached 有哪些优势?

### Redis 的数据结构

- Redis 支持哪些数据结构？
- Redis 的数据结构底层实现是什么？
- Redis 的字符串类型有哪些操作？
- Redis 的哈希类型有哪些操作？
- Redis 的列表类型有哪些操作？
- Redis 的集合类型有哪些操作？
- Redis 的有序集合类型有哪些操作？
- Redis 支持的数据结构有哪些限制？

### Redis 的持久化

- Redis 的持久化有哪些方式？
- Redis 的 RDB 持久化和 AOF 持久化的区别是什么？[Redis进阶 - 持久化：RDB和AOF机制详解 | Java 全栈知识体系](https://pdai.tech/md/db/nosql-redis/db-redis-x-rdb-aof.html)、[AOF 持久化是怎么实现的？ | 小林coding](https://www.xiaolincoding.com/redis/storage/aof.html)
- Redis 的持久化策略是如何工作的？
- Redis 的持久化有哪些优缺点？

### Redis 的高可用性

- Redis 的主从复制是什么？
- Redis 的哨兵是什么？
- Redis 的集群模式是什么？
- Redis 集群模式的优缺点是什么？

### Redis 的性能优化

- Redis 的性能瓶颈是什么？
- 如何提高 Redis 的性能？
- Redis 的并发模型是什么？
- Redis 的线程模型是什么？

### Redis 的应用场景

- Redis 适用于哪些场景？
- Redis 在实时系统中的应用是什么？
- Redis 如何应用于分布式锁？
- Redis 如何实现计数器？

# 案例

## PHP 实现并发自旋锁

```php
/**
 * 增加自旋等待 和 锁释放时安全检查，避免被非加锁端释放
 * @param sting $lockKey
 * @param int $waitTimeout 最长等锁时间：秒
 * @param int $expire 超时时间，单位为秒
 * @param string $act 锁操作，lock | unlock
 * @param string $lockValue 加锁时返回的钥匙，解锁时必传！！！
 * @return mixed 加锁成功返回解锁专用钥匙，加锁失败返回false
 */
function concurrent_lock_safe($lockKey, $waitTimeout = 3, $expire = 10, $act = 'lock', $lockValue = '') {
    $redis = get_redis_instance();
    $lockKey = 'lock_'.md5($lockKey);//令牌键值
    $res = false;
    try {
        if($act === 'unlock') {//解锁
            $value = $redis->get($lockKey);
            //防止被非加锁客户端解锁
            if (!empty($value) && $value == $lockValue) {
                $redis->del($lockKey);
            }

            $res = true;
        } else {//加自旋锁
            $lockValue = uniqid('', true);
            $waitTimeout = $waitTimeout * 1000;
            $start = microtime(true) * 1000;
            while ((microtime(true) * 1000 - $start) < $waitTimeout) {
                $res = (bool)$redis->set($lockKey, $lockValue, ['nx', 'ex' => $expire]);
                if ($res) {
                    return $lockValue;
                } else {
                    usleep(100000); // 0.1秒
                }
            }
        }
    } catch (\Exception $e) {}//屏蔽错误
    return $res;
}
```