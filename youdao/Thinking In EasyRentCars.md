---
layout: post
title: "Thinking In EasyRentCars"
date: 2018-04-26
tags: [Thinking,EasyRentCars]
---
## 背景
> 最近在公司遇到了很多新的知识点、发现了很多新的思考点、对于一些问题学到了很多新的解决方案...感到脑子不够用,特开一个篇章用以记录在ERC工作过程中遇到的、悟到的东西！仅给自己作为整理知识用

## What are you thinking?

### 自动化部署
> 思考:当前公司使用vagrant进行本地自动化开发环境搭建,这个过程中遇到很多不爽的地方,哪:
> - 为什么我们会选择vagrant进行搭建本地开发呢?
> - 为什么没有选择Docker呢?vagrant与Docker的区别在什么地方呢?
> - 什么场景下去使用它们两者呢?它们的原理又是啥呢?

- [ ] vagrant同步更新文件延缓问题?[插件:`vagrant-winnfsd-1.4.0.gem`==>`vagrant plugin install /gem-path`]
- [ ] [如何使用VBoxManage加载box解决vagrant运行缓慢问题?](https://www.virtualbox.org/manual/)
- [ ] [Docker的深入了解](http://www.docker.org.cn/page/resources.html)
- [ ] 通过对vagrant的了解和学习发现"计算机网络"连一些基础知识都已经还给老师了?但是这很重要,抽时间整理、记录、深入学习?计算机四大原理:操作系统原理、编译原理、计算机组成原理、网络原理;线性代数;算法与数据结构
- [ ] Jenkins + K8S + Docker + apollo
 
### 消息队列
> 思考:当前使用gearman做消息队列,做异步操作,并没有真正发挥消息队列的"作用",虽然老大说gearman迟早要换,好奇:
> - 为啥当初要选型用gearman呢?
> - gearman的劣势是什么?
> - gearman的应用场景是啥?
> - gearman相比MQ是不是真的没有可取之处?

- [ ] 消息队列的运用:①削峰-->es:秒杀活动<==>地铁拉闸限流;②业务解耦-->MQ,互联网架构解耦神器[寄信人和邮差的场景==>消费者];③异步
- [ ] 使用环形队列解决自动确认订单问题,避免全表扫描
- [ ] Rabbitmq
- [ ] 幂等性，RocketMQ解决消息顺序和重复，Mysql与Java中的乐观锁悲观锁:https://blog.csdn.net/yzhou86/article/details/79156458
- [ ] 如何保证消息队列的幂等性？https://hacpai.com/article/1542160729029

### 服务
> 思考:现在公司用到的一些服务,以前也是粗浅掌握,现在也是用公司封装的,是时候真正掌握和学习了解它们了

#### 缓存服务
- [ ] [Memcache && Memcached](https://blog.linuxeye.cn/345.html)==>[类似MySQL和mysqld:`d`是`daemon`守护进程的意思]; PHP中的memcache(使用PHP实现)和PHP中的memcached(使用C的libmemcached实现,更加完善);
- [ ] Radis ![image](3FE16F6055964CBFA7827A1F61956A87)
> - 面试题（redis master和slave是怎么实现数据同步的）:https://blog.csdn.net/hxpjava1/article/details/78347890/
> - redis 键{user102}:last.name的有效部分为"user102",比如{user102}:first.name 和 {user102}:last.name 会分配到同一个节点：https://zhuanlan.zhihu.com/p/61985555
> - Radis 主从同步：https://www.cnblogs.com/zhao-blog/p/6131524.html
- [ ] MongoDB
- [ ] 各类缓存服务系统的CAS实现?
- [ ] 各类缓存服务系统的失效算法是如何的?LRU淘汰算法
- [ ] 安全：缓存击透问题



#### 数据库服务
- [ ] MySQL都出8啦...还不学习了解干嘛?
- [ ] 上一次帝明分享了MySQL的优化、慢查询的优化、索引的优化,整理深入学一下吧
- [ ] [MySQL的btree索引和hash索引的区别](http://www.cnblogs.com/hanybblog/p/6485419.html)
- [ ] 公司大神们都推荐了《MySQL高性能》这本书,是不是该提上日程来看啦～
- [ ] 做了这么多次统计,自己踩了这多坑,看别人踩了这么多坑,该总结了吧?[select主键方式来代替count方案;使用一张临时表来存储定时执行记录:多批少量跑大表数据]
- [ ] 使用记录目标数据的方式来避免全表扫描;
- [ ] MySQL计算大表count(*)替代方案:`SELECT id FROM  zuzuche_world_db.new_search_history_tbl {$where_str} LIMIT 5000,1`;
- [ ] CAS原则:Compare and Set【思考:如果重试失败呢？do...while?】
- [ ] 一致性哈希分表
- [ ] 主从的实现？数据库中间件？DBProxy 和 MyCat 的优缺点？
- [ ] 主从备份？主从同步【bin log 追加】![image](C2921FCB4EFD46C6817B30DFDF48D7D4)
- [ ] 读写分离的原理？架设？
- [ ] SQL 注入
- [ ] explain 的使用？



##### 锁机制
- [ ] 锁的概念?分类?MySQL中的锁：[https://blog.csdn.net/soonfly/article/details/70238902](https://blog.csdn.net/soonfly/article/details/70238902) [https://blog.csdn.net/soonfly/article/details/70238902](https://blog.csdn.net/soonfly/article/details/70238902)
- [ ] 不同类型锁的应用场景?
- [ ] 高级"锁"的设计思想：
- [ ] 数据库：表锁？行级锁？原理？区别？使用场景？死锁？什么是队列？排它锁，Myisam 死锁如何解决？
- [ ] 分布式并发锁？【抢位】
> 计算机原理学的，生产者消费者模型，银行家模型，都可以解决锁的问题。
> - mysql-行锁的实现:https://blog.csdn.net/alexdamiao/article/details/52049993
> - MySQL锁详解:https://www.cnblogs.com/luyucheng/p/6297752.html
> - Mysql数据库事务的隔离级别和锁的实现原理分析:https://blog.csdn.net/tangkund3218/article/details/47704527
- [ ] 数据库如果出现了死锁，你怎么排查，怎么判断出现了死锁？https://www.cnblogs.com/huanyou/p/5775965.html



#### 全文搜索服务
- [ ] sphinx
- [ ] Elasticsearch搜索服务==>Elasticsearch是否可以代替Mongo成为搜索存储服务器?

#### 日志监控
- [ ] Prometheus + Grafana（目前用紧ES的日志告警，应该会废弃用普罗米修斯+Grafana做监控告警）
- [ ] 日志收集：ELK 【告警：ES alert】
- [ ] skywalking 追踪链


### 分布式
- [ ] 分布式一致性？原理？
- [ ] 分布式事务？分布式事务补偿？
- [ ] 幂等性


### 电商实战场景
- [ ] 秒杀？并发？
- [ ] 库存保留
- [ ] 搜索数据缓存机制？(SQL 作为 Key)
- [ ] 购物车信息同步？

### SEO 场景
- [ ] URL 优化？URL 固化？
- [ ] 内容动态更新机制
- [ ] SEO 站群
- [ ] 子域名的使用



### 编程思维
> 最近写代码脑子有点抽,抽空整理学习一下以下的知识吧

- [ ] 面向过程编程[你没看错,现在项目里还有一些古来代码还是这样写的,改也难改...但至少优雅点吧]
- [ ] 面向对象编程[兄台看框架源码去吧]
- [ ] 面向切面编程[兄台看框架源码去吧]


### PHP
> 工作中发现掌握火候还不够的问题和知识点

- [ ] [PHP运行模式:https://blog.csdn.net/time888/article/details/53414809](https://blog.csdn.net/time888/article/details/53414809)
- [ ] [`php-fpm.conf`配置详解](https://blog.csdn.net/sinat_22991367/article/details/73431269)
- [ ] opcache 缓存深入学习[以前只是知道有这个东西,但是没怎么深入了解过]
- [ ] apc 缓存
- [ ] PHP生成器:[①PHP生成器详解](https://www.virtualbox.org/manual/) [② 在PHP中使用协程实现多任务调度 
](https://www.virtualbox.org/manual/)
- [ ] PHP协程调用
- [ ] Composer的深入了解学习与运用:[http://docs.phpcomposer.com](http://docs.phpcomposer.com)
- [ ] 推荐阅读博客:https://www.awaimai.com/2200.html
- [ ] `fsockopen`替代公司实现异步请求方案:[https://segmentfault.com/a/1190000002982448](https://segmentfault.com/a/1190000002982448) [https://blog.csdn.net/qq43599939/article/details/50570098](https://blog.csdn.net/qq43599939/article/details/50570098)
- [ ] [使用`fastcgi_finish_request`提高页面响应速度](http://www.laruence.com/2011/04/13/1991.html);
- [ ] [使用`fastcgi_finish_request`的踩坑问题:max_execution_time-超时问题]==>要看PHP运行的模式是啥?怎么处理?
- [ ] 使用`fastcgi_finish_request`的踩坑问题:客户端断开连接-生命周期问题--使用ignore_user_abort(true)解决,同时也要看执行模式是啥?
- [ ] PHP 静态方法、变量可用范围、抽象类、接口、继承、克隆、魔术方法、Trait、闭包、回调
- [ ] [掌握 PHP Trait 的概念和用法](https://zhuanlan.zhihu.com/p/31362082)？Trait 优先级？
- [ ] [使用`ignore_user_abort`实现定时任务方案](http://www.cnblogs.com/wgw8299/articles/2170092.html)==>[一般没人这么做吧,定时任务肯定是用cgi模式做居多的,`ignore_user_abort`是否对`cgi模式`有效?==>应该没效吧,不然尼玛怎么停呢?每次都kill掉这个进程?]
> **一般定时计划方案:**
1. linux系统的`crontab`
2. 使用进程管理工具:[Supervisor](http://wiki.jikexueyuan.com/project/docker-technology-and-combat/supervisor.html)
3. swoole-crontab


- [ ] [PHP使用curl_multi_init带来CPU高负荷问题](https://www.cnblogs.com/huanxiyun/articles/5329600.html)
- [ ] [限流器]( https://niubibi.easyrentcars.com/side-project/rate-limiter)
- [ ] [协商](https://niubibi.easyrentcars.com/side-project/negotiation)
- [ ] [RSA加解密](https://niubibi.easyrentcars.com/overseas_backend/library/tree/master/Lib/Crypt)
- [ ] [流式数据库读取](https://niubibi.easyrentcars.com/overseas_backend/library/tree/master/Lib/Util/StreamReader)
- [ ] [LRU算法](https://niubibi.easyrentcars.com/overseas_backend/library/blob/master/Lib/Util/LimitCache.php)
- [ ] 设计模式？应用场景？
- [ ] 多语言实现方案
- [ ] PHP7(最新) 的新特性？
- [ ] Token 机制
- [ ] Laravel 的了解？使用？
- [ ] 上传应该注意哪些问题?
- [ ] 分别讲讲XSS、CSRF原理和防范?
- [ ] Session 和 Cookie 的区别？联系？【会话机制】？禁用 cookie 后是否可以获取 session？
- [ ] 分布式Session共享？
- [ ] 数组和hash的区别？
- [ ] 无限极分类的分类和实现：数组引用？预排序遍历树（左右值）？毗邻目录模式？
- [ ] PHP 内存管理？内存释放(unset的了解和学习)？协程？yeild 关键字？
- [ ] PHP 引用的坑？释放？
- [ ] [十道海量数据处理面试题与十个方法大总结](https://blog.csdn.net/v_JULY_v/article/details/6279498)
- [ ] php 进程模型，php 怎么支持多个并发?php-fpm
> https://www.jianshu.com/p/542935a3bfa8
- [ ] 如何解决跨域？
- [ ] PHP 读取文件？数据库？那个快？TCP 链接数？文件句柄限制？


> - PHP 面试题：https://www.100txy.com/index.php/article/48.html
> - PHP 面试题： https://juejin.im/post/5c870297f265da2dd0527c8c
> - PHP 面试题：https://www.leon0204.com/article/119.html
> - PHP 面试题：https://learnku.com/articles/20714


### 网络原理
- [ ] HTTP2.0 
- [ ] HTTP 和 HTTPS？HTTPS 加密原理？
- [ ] 计算机网络原理
- [ ] 抓包

### 算法
- [ ] 加密算法？对称加密？非对称加密？ ![image](0059B4F228874C91ACAA4A47AC021061)
- [ ] 快排？冒泡？
- [ ] 二叉树查找？





### 工具
> 工具一直都有在用,但是随着工作和平时慢慢积累的一些好用的配置和设置该记录一下啦

- [ ] PHPStrom主题设置;格式化代码设置;插架安装-Git
- [ ] SublimeText3:主题设置;插件安装-GoAnyWhere
- [ ] VIM:使用vim一开始真的只是装逼,装逼失败之后...发现原来这个东西真的是我用的所有编辑器里最不卡/最牛逼的
- [ ] Git

### 运维
- [ ] 最近公司服务器一直CPU报警,消耗太高,如何排查CPU过高?
- [ ] 运维生成空间:[http://www.ttlsa.com](http://www.ttlsa.com)
- [ ] 数据恢复:[https://mp.weixin.qq.com/s/Ozqu2A7Sy_TGKkF6yF1rDQ](https://mp.weixin.qq.com/s/Ozqu2A7Sy_TGKkF6yF1rDQ)
- [ ] 正向代理(代理客户端访问中间机器,让其帮忙去访问服务机器:例如自己搭梯子去实现翻墙) && 反向代理(服务机器访问中间机器,让中间机器访问内部机器:例如:SLB负载均衡集群)
- [ ] [图解正向代理、反向代理、透明代理](https://blog.51cto.com/z00w00/1031287)
- [ ] [Squid服务]:[http://blog.51cto.com/guojiping/978839](http://blog.51cto.com/guojiping/978839) [http://wiki.jikexueyuan.com/project/linux/squid.html](http://wiki.jikexueyuan.com/project/linux/squid.html)
- [ ] [`Nginx`和`Squid`和`Varnish`的比较](https://www.cnblogs.com/kevingrace/p/6188123.html)
- [ ] `CDN`回源问题设置:Cookie、UA信息配置
- [ ] 504 502 499 等情况的排查
- [ ] 负载均衡？LVS 在项目运行之前需要注意哪些事项，或者说会出现什么问题?
- [ ] TCP 链接数？
- [ ] 从 0 开始构建一个 "固若金汤" 的nginx:https://klionsec.github.io/2017/11/20/nginx-sec/
- [ ] Nginx：https://wiki.linux78.com/read/Nginx/nginx
> 参考网站：https://wiki.linux78.com/

转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)
