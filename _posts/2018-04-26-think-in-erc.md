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
- [ ] Docker的深入了解
- [ ] 通过对vagrant的了解和学习发现"计算机网络"连一些基础知识都已经还给老师了?但是这很重要,抽时间整理、记录、深入学习?计算机四大原理:操作系统原理、编译原理、计算机组成原理、网络原理;线性代数;算法与数据结构
 
### 消息队列
> 思考:当前使用gearman做消息队列,做异步操作,并没有真正发挥消息队列的"作用",虽然老大说gearman迟早要换,好奇:
> - 为啥当初要选型用gearman呢?
> - gearman的劣势是什么?
> - gearman的应用场景是啥?
> - gearman相比MQ是不是真的没有可取之处?

- [ ] 消息队列的运用:①削峰-->es:秒杀活动<==>地铁拉闸限流;②业务解耦-->MQ,互联网架构解耦神器[寄信人和邮差的场景==>消费者];③异步

### 服务
> 思考:现在公司用到的一些服务,以前也是粗浅掌握,现在也是用公司封装的,是时候真正掌握和学习了解它们了

#### 缓存服务
- [ ] [Memcache && Memcached](https://blog.linuxeye.cn/345.html)==>[类似MySQL和mysqld:`d`是`daemon`守护进程的意思]; PHP中的memcache(使用PHP实现)和PHP中的memcached(使用C的libmemcached实现,更加完善);==>使用Memcache的CAS做法
- [ ] Radis
- [ ] MongoDB

#### 全文搜索服务
- [ ] sphinx
- [ ] Elasticsearch搜索服务==>Elasticsearch是否可以代替Mongo成为搜索存储服务器?

#### 数据库服务
- [ ] MySQL都出8啦...还不学习了解干嘛?
- [ ] 上一次帝明分享了MySQL的优化、慢查询的优化、索引的优化,整理深入学一下吧
- [ ] 公司大神们都推荐了《MySQL高性能》这本书,是不是该提上日程来看啦～
- [ ] 做了这么多次统计,自己踩了这多坑,看别人踩了这么多坑,该总结了吧?[select主键方式来代替count方案;使用一张临时表来存储定时执行记录:多批少量跑大表数据]
- [ ] CAS原则:Compare and Set

### 编程思维
> 最近写代码脑子有点抽,抽空整理学习一下以下的知识吧

- [ ] 面向过程编程[你没看错,现在项目里还有一些古来代码还是这样写的,改也难改...但至少优雅点吧]
- [ ] 面向对象编程[兄台看框架源码去吧]
- [ ] 面向切面编程[兄台看框架源码去吧]


### PHP
> 工作中发现掌握火候还不够的问题和知识点

- [ ] opcache深入学习[以前只是知道有这个东西,但是没怎么深入了解过]
- [ ] PHP生成器:[①PHP生成器详解](https://www.virtualbox.org/manual/) [② 在PHP中使用协程实现多任务调度 
](https://www.virtualbox.org/manual/)
- [ ] Composer的深入了解学习与运用


### 工具
> 工具一直都有在用,但是随着工作和平时慢慢积累的一些好用的配置和设置该记录一下啦

- [ ] PHPStrom主题设置;格式化代码设置;插架安装-Git
- [ ] SublimeText3:主题设置;插件安装-GoAnyWhere
- [ ] VIM:使用vim一开始真的只是装逼,装逼失败之后...发现原来这个东西真的是我用的所有编辑器里最不卡/最牛逼的
- [ ] Git:被运维哥哥(海明)怼过之后,潜心学习Git的使用,发现Git真的很棒,也学习到很多以前所不懂的,并与同事做了分享![感谢那些让你进步的人～]

### 运维
- [ ] 最近公司服务器一直CPU报警,消耗太高,如何排查CPU过高?
- [ ] 运维生成空间:[http://www.ttlsa.com](http://www.ttlsa.com)
- [ ] 数据恢复:[https://mp.weixin.qq.com/s/Ozqu2A7Sy_TGKkF6yF1rDQ](https://mp.weixin.qq.com/s/Ozqu2A7Sy_TGKkF6yF1rDQ)

转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)
