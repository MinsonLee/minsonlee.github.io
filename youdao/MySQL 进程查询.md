- [关于查询mysql processlist的建议 - 简书](https://www.jianshu.com/p/f409d3aea2e6)
- [MySQL :: MySQL 8.0 Reference Manual :: 13.7.7.29 SHOW PROCESSLIST Statement](https://dev.mysql.com/doc/refman/8.0/en/show-processlist.html)
- [MySQL SHOW PROCESSLIST - 墨天轮](https://www.modb.pro/db/337567)

## 连接进程数超标

一般来说，`MySQL` 的连接数 `SELECT COUNT(*) FROM information_schema.processlist;` 应该处于一个比较稳定的值，如果是报 `too many connections` 错误，需要检查：`show variables like '%max_connections%'` 是否设置的过小？或者检查代码中是否有「只建立连接，没有关闭资源连接」的代码，导致大量的连接处于 `SLEEP` 状态。

或服务被注入攻击，产生了大量耗时的执行连接一直没有释放。

```mysql
-- 查看最大连接数
mysql> show global variables like '%max_connections%';
+-----------------+-------+
| Variable_name   | Value |
+-----------------+-------+
| max_connections | 3000  |
+-----------------+-------+
1 row in set (0.10 sec)


-- 查看当前实例的连接线程信息
mysql> show global status like 'Threads%';
+-------------------+-------+
| Variable_name     | Value |
+-------------------+-------+
| Threads_cached    | 293   |
| Threads_connected | 183   |
| Threads_created   | 5582  |
| Threads_running   | 1     |
+-------------------+-------+
```


## 服务负载异常

当 `MySQL` 服务出现 `SQL` 注入的情况，往往第一时间需要通过查询出当前 `MySQL` 连接情况将这些大量的注入 `SQL` 连接给 `Kill` 掉，从而暂时“吊住 `MySQL` 服务的最后一口气”，给其一些喘息的机会。

查询 `MySQL` 数据库进程可以通过： `SHOW PROCESSLIST`（只能查看前 100 条） 或 `SHOW FULL PROCESSLIST`（全部列出） 命令，但是：**当数据库处于高连接数、高负载的情况下，不建议使用 `SHOW PROCESSLIST` 或 `SHOW FULL PROCESSLIST`，而是尽量用 `SELECT FROM information_schema.processlist` 的方式进行查询**

```
mysql> SHOW PROCESSLIST;
+----------+-----------+--------------------+-----------------------------+---------+-------+----------+------------------+
| Id       | User      | Host               | db                          | Command | Time  | State    | Info             |
+----------+-----------+--------------------+-----------------------------+---------+-------+----------+------------------+
|  2594091 | developer | 10.x.xxx.xxx:1273  | xxxxx_hotel_sp_db           | Sleep   |     0 |          | NULL             |
|  2986375 | developer | 10.x.xxx.xxx:28183 | xxxxxxxx_world_db           | Sleep   |     6 |          | NULL             |
...
```

```
mysql> SHOW FULL PROCESSLIST;
+----------+-----------+--------------------+-----------------------------+---------+-------+----------+-----------------------+
| Id       | User      | Host               | db                          | Command | Time  | State    | Info                  |
+----------+-----------+--------------------+-----------------------------+---------+-------+----------+-----------------------+
| 90493492 | developer | xxx.xx.x.xxx:14043 | NULL                        | Query   |     0 | starting | SHOW FULL PROCESSLIST |
| 90494066 | developer | xx.x.xxx.xxx:37567 | xxxxxxx_world_statistics_db | Sleep   |     0 |          | NULL                  |
.....
```

- `Id` 显示连接进程 `ID`，通过 `KILL <ID>` 可以将对应的连接中断执行并杀死连接
- `User` 连接用户，如果值为 `system user` 表示 `MySQL` 服务器产生的非客户端线程
- `Host` 客户端连接的 `IP`
- `db` 正在操作的数据库
- `Command` 执行命令类型，常见的容易出问题的如下（持续补充）：
    - 查询-`Query`、更新-`Update`
    - 被挂起休眠-`Sleep`，大量 `Sleep` 会占用连接数
- `Time` 该连接处于**截止当前执行的耗时秒数**
- `State` 连接的操作状态（**若某连接在某一个状态停留时间过长，则很可能存在问题需要排查**）
- `Info` 正在执行的 `SQL`，未执行 `SQL` 时显示 `NULL`，这一列是**用于判断 `SQL` 是否有问题的重要依据**

如果是拥有 `PROCESS` 权限的用户才可以查看到其他用户的连接进程信息，否则只能查看到自己账户所产生的连接进程信息。

```mysql
-- 赋权
mysql> grant process on *.* to '<username>'@'%'

-- 查询所有的连接进程
mysql> SELECT COUNT(*) FROM information_schema.`PROCESSLIST`;
+----------+
| COUNT(*) |
+----------+
|      182 |
+----------+
1 row in set (0.07 sec)

-- 查询正在 running 的进程
mysql> SELECT COUNT(*) FROM information_schema.`PROCESSLIST` WHERE `info` IS NOT NULL;
+----------+
| COUNT(*) |
+----------+
|        2 |
+----------+
1 row in set (0.07 sec)

-- 查询当前正则 running 执行时间最长的 10 条记录
mysql> SELECT * FROM information_schema.`PROCESSLIST` WHERE `info` IS NOT NULL ORDER BY `time` DESC LIMIT 10;
+----------+-----------+-------------------+------+---------+------+-----------+------------------------------------------------------+
| ID       | USER      | HOST              | DB   | COMMAND | TIME | STATE     | INFO                                                 |
+----------+-----------+-------------------+------+---------+------+-----------+------------------------------------------------------+
| 90945853 | developer | xxx.xx.xx.xxx:xxx | NULL | Query   |    0 | executing | SELECT * FROM xxx.`order_tbl` WHERE `order_id` = 111 |
+----------+-----------+-------------------+------+---------+------+-----------+------------------------------------------------------+
1 row in set (0.07 sec)

-- 查询执行 `SQL` IP 的数量（一般 MySQL 都是内网，通过跳板机连接，感觉这个操作比较局限）
mysql> SELECT LEFT(`HOST`,instr(`HOST`,':') - 1) AS `ip`, COUNT(*) AS `num` FROM information_schema.`PROCESSLIST` GROUP BY `ip` ORDER BY num DESC;
+--------------+-----+
| ip           | num |
+--------------+-----+
| 10.4.xxx.xxx |  65 |
| 10.4.xxx.xxx |  64 |
| 10.4.xxx.xxx |  40 |
| 10.4.xxx.xx  |   8 |
| 10.4.xxx.xxx |   4 |
| 172.xx.x.xxx |   2 |
+--------------+-----+
6 rows in set (0.04 sec)

-- 查询执行 `SQL` 用户的连接数（一般 MySQL 都是固定几个账号，通过跳板机连接，感觉这个操作比较局限）
mysql> SELECT `USER`, COUNT(*) AS `num` FROM information_schema.`PROCESSLIST` GROUP BY `USER` ORDER BY num DESC;
+-----------+-----+
| USER      | num |
+-----------+-----+
| developer | 123 |
| erc_local |  60 |
+-----------+-----+
2 rows in set (0.04 sec)

-- 查询慢查询连接， kill 掉
mysql> SELECT CONCAT('KILL ', id, ';') FROM information_schema.`PROCESSLIST` WHERE `info` LIKE "%SELECT count(*) AS count from `zuzuche_world_db`.`faq_tbl`%";
+--------------------------+
| CONCAT('KILL ', id, ';') |
+--------------------------+
| KILL 90945853;           |
+--------------------------+
1 row in set (0.05 sec)
```

### 常见 `State` 异常状态分析

- [Thread States线程状态](https://www.modb.pro/db/337567)
- [事件记录 | performance_schema全方位介绍-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1123328)
- [千金良方：MySQL性能优化金字塔法则.pdf > explain 执行计划详解](https://zhishutang.com/files/APPX-D-explain.pdf)
- [MySQL默认数据库之performance_schema库_ITPUB博客](http://blog.itpub.net/26736162/viewspace-2651257/)
- [MySQL调优性能监控之performance schema - 等不到的口琴 - 博客园](https://www.cnblogs.com/Courage129/p/14188422.html)




- `Sending data` 从 `innodb` 层获取大量的数据，包括读磁盘、传输数据等等，会导致 `CPU/IO` 耗尽
- `Sorting index` 语句没有命中索引，通过临时表进行排序，会导致 `CPU` 资源耗尽，建议添加索引或修改查询语句
- `Copying to tmp` 大量生成临时表，`SQL` 中往往伴有多表 `JOIN` 查询 或者 `show global variables like '%table_size%';` 设置太小