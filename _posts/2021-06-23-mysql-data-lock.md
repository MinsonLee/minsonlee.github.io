---
layout: post
title: MySQL 数据库中查询表是否被锁
date: 2021-06-23
tags: [MySQL,SQL,sql_mode]
---

由于线上数据库有一个字段类型太小，导致数据溢出产生了线上 bug。现需将 days 字段由 tinyint(3) 类型变更为 smallint(5)。变更数据库要考虑**该操作是否会发生锁表操作？发生了锁表对当前业务是否会有致命影响？**

查阅了一下网上的资料，发现 `5.6.11` 之后 `alter` 操作“大部分”都是不会锁表了。因此，我想确认一下：我要执行的 SQL 到底是否会锁表呢？

在网上翻阅了很久的资料，这里记录一下结果。

1、确认表是否在被使用

```sql
show open tables where in_use > 0 ;
```

![show open tables in use](/images/article/mysql-data-lock/mysql-in-use.png)

2、查看当前数据库进程中正在执行的 SQL 线程信息

```sql
show processlist;
```

![mysql show processlist](/images/article/mysql-data-lock/mysql-show-processlist.png)

3、当前运行的所有事务

```sql
SELECT * FROM information_schema.INNODB_TRX;
```

4、当前出现的锁

```sql
# mysql 8.0.* 之前的版本使用该方式查询
SELECT * FROM information_schema.INNODB_LOCKS\G

# mysql 8.0.1 之后的版本使用
SELECT * FROM performance_schema.data_locks\G
```

5、由于锁占用导致等待的表

```sql
# mysql 8.0.1 之前的版本使用该方式查询
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCK_WAITS\G

# mysql 8.0.1 之后的版本使用
SELECT * FROM performance_schema.data_lock_waits\G
```

注意：第4-5步，在 `8.0.*` 版本中对应的表发送了变更。目前在网上找的资料都是 `8.0.*` 之前的版本。对于`information_schema.INNODB_LOCKS`、`INFORMATION_SCHEMA.INNODB_LOCK_WAITS` 在 `5.6.40` 和 `5.7.29` 中这两个表确实是存在的。

![mysql5.6.47 INNODB_LOCKS](/images/article/mysql-data-lock/mysql5.6-information_schema-INNODB_LOCK%25.png)

但我个人数据库版是 `8.0.23` 版，发现该表不存在了

![mysql 8.0.* INNODB_LOCKS](/images/article/mysql-data-lock/mysql8.0.11-information_schema-INNODB_LOCK%25.png)

查阅了官方的文档，发现这两个表已经被移除了，对应的锁信息在`performance_schema.data_lock_*` 中

![mysql 8.0 document](/images/article/mysql-data-lock/doc-remove-INNODB_LOCKS.png)

通过人为模拟一个不提交事务发生锁表，查询 `data_locks` 情况如下图

![data_locks and data_lock_waits](/images/article/mysql-data-lock/mysql8.0-data-lock-waits.png)

## 参考文档

- MySQL 锁表后快速解决方法 及 MySQL中的锁：https://weikeqin.com/2019/09/05/mysql-lock-table-solution/
- 21.4.14 The INFORMATION_SCHEMA INNODB_LOCKS Table：https://dev.mysql.com/doc/refman/5.6/en/information-schema-innodb-locks-table.html
- 21.4.15 The INFORMATION_SCHEMA INNODB_LOCK_WAITS Table：https://dev.mysql.com/doc/refman/5.6/en/information-schema-innodb-lock-waits-table.html
- 27.12.13.1 The data_locks Table：https://dev.mysql.com/doc/refman/8.0/en/performance-schema-data-locks-table.html
- 27.12.13.2 The data_lock_waits Table：https://dev.mysql.com/doc/refman/8.0/en/performance-schema-data-lock-waits-table.html