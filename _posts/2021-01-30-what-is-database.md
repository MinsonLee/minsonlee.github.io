---
layout: post
title: 数据库知识小记
date: 2021-01-30
tags: [MySQL]
---

概念是对事物的特征描述，理解数据库的概念对掌握数据库的使用、学习有很大帮助！

## 1. 什么是数据库？

数据库，又叫做“数据管理系统”-就是一个**存储**和**管理**数据的仓库系统！大致可以划分为：关系型数据库：`RDS` 和非关系型数据库：`NoSQL-Not Only SQL`。数据库 = 数据库引擎服务 + 数据库查询程序 + 数据库客户端。

非关系数据库没有统一固定的数据结构类型，但是关系型数据库一般都是通过二维表结构的方式组织存放数据的：由 “表” 组建成一个 “库”，由多个 “库” 组建为一个数据库服务。

关于 `NoSQL` 的小记可以看看左耳朵耗子译过来的一篇文章：[`NoSQL` 数据建模技术](https://coolshell.cn/articles/7270.html)。

### 数据库引擎服务

数据库引擎服务是指提供给客户端连接，便于客户端和数据仓库相互操作的一个程序。一般来说这个服务程序都需要设置为随系统自动启动并运行在后台。数据库引擎服务可以说就是“数据与客户端之间的门户”！

例如： `MySQL` 的 `mysqld` 程序；`MS SQLServer` 的 `sqlserver.exe` 或 `sqlserver` 程序。

![mysql-ps-grep-mysqld.png](/images/article/mysql-ps-grep-mysqld.png)

![sqlserver-services.png](/images/article/sqlserver-services.png)

### 数据库查询程序

每种数据库都有其自己的查询语言（获取数据的手段），非关系型数据库的语句各不相同，但绝大部分的关系型数据库服务都是支持通过结构化查询语句-`SQL` 来查询获得数据的（语法上可能有差异，但总的来说都是大同小异，言简意赅）。

数据库查询程序一般来说都包含：数据库查询解析器、查询优化器、查询执行程序，它们的职责就是：将用户传入的查询语句解析、优化、执行、统计等操作，最后将得到的结构返回给数据库引擎服务。

### 数据库客户端

数据库客户端是**提供给用户操作**的前台程序，可以说是“用户与数据库服务引擎沟通的门户”！这类工具可就多了，例如： `MySQL` 自己提供的 `mysql` 命令行客户端程序、 `Navicat`-支持连接多种数据库的 `GUI`、PHP 编写的 `phpmyadmin`、Python 编写的 `mycli` 等等。


## 2. 什么是 SQL ？

`SQL` 的全程是： `Structured Query Language`-结构化查询语言。它 是一种编程术语，基于**集合论和关系代数**进行**集合运算**（如并集，交集和差级等）以达到**描述（组织和检索）**关系数据库中的信息。

`SQL` 是一种 `What` 类型语言，即：你告诉我你想要什么东西，我直接给你，你不需要关心我到底是怎么组织、怎么描述、从什么地方拿、做了什么操作...你只需要关心我给你的结果是不是你想要拿的即可！

这与其他的编程式的 `How` 类型语言不一样，即：你想要得到什么结果需要你自己亲力亲为从头到尾设计、生产、获取、组织、执行才能得到结果，你需要参与整个过程中大部分的环节和所有决定性的细节点。如：使用 `PHP`、 `Go`、 `Java`、 `Python` 获取一段数据，你需要自己编程设计实现所有的细节，才能得到结果。

`SQL` 语句按照功能进行划分，又分为： `DML`、 `DDL`、 `DCL` 三类语句。

- [`DML-Data Manipulation Languages`](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_dml)-数据库操作语言：绝大部分都是在使用 `DML` 语句。如：增删改查操作，相当于工地里“工人”的角色，充当“使用者”的角色
- [`DDL-Data Definition Language`](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_ddl)-数据定义语言：小部分人使用 `DDL` 语句，用来定义数据库中所有的对象。如：建库、建表、建视图、建索引...，相当于工地里“工头、设计师”的角色，充当“建设者”的角色
- [`DCL-Data Control Language`](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_dcl)-数据控制语言：用于授予或回收访问数据库的权限、控制数据库操作事务发生的时间及效果、对数据库实行监视...等操作，相当于工地里“项目经理、监工”的角色，充当“管理者”的角色

## `MySQL` 操作语句小记

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