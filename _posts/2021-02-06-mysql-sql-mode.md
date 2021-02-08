---
layout: post
title: MySQL 数据库模式：sql_mode
date: 2021-02-06
tags: [MySQL,SQL,sql_mode]
---

## 什么是数据库模式： sql_mode ？

数据库的 SQL 模式定义了当前数据库（如： MySQL、MSSQLServer）应该支持的 SQL 语法以及应该执行的数据验证检查类型。
这使得在不同环境中使用 MySQL 以及将 MySQL 与其他同样支持 SQL 语法的数据库服务器一起使用更加容易。MySQL 服务器将这些模式分别应用于不同的客户端。

简单来说，即： 

1. SQL 是一个独立的查询语法，没有强制跟任何数据库绑定
2. 绝大多数关系型数据库都支持 SQL 语法的查询语句，但不同类型关系型数据库中解析同一条 SQL 语句所做的校验规则可能稍有不同

基于上述原因：设置不同的数据库模式，可以让数据库使用不同的验证模式对 SQL 语句进行合法校验！

一般来说，在生产环境中是必须将 `sql_mode` 设置为严格模式（`STRICT_TRANS_TABLES`），开发、测试环境的数据库也应当要设置，这样在开发测试阶段就可以发现问题。


## MySQL 查看 sql_mode ？

`sql_mode` 的设置分为：全局设置-影响设置后所有新连接的客户端、会话设置-只影响当前连接的客户端。

- 查看当前客户端连接的数据库模式

```SQL
-- 查看当前连接的数据库模式
SELECT @@SESSION.sql_mode;

-- 查看当前连接的数据库模式
SELECT @@sql_mode;
```

![mysql-select-session-sql-mode](/images/article/mysql-select-session-sql-mode.png)

- 查看全局连接数据库模式

```SQL
-- 查看全局连接的数据库模式
SELECT @@GLOBAL.sql_mode;
```

或查看 `my.cnf` 配置文件，搜索关键词 `sql-mode`，一般数据库安装完毕后配置文件中默认是不显示设置 `sql-mode` 这个配置项的，因此可能找不到！

## MySQL 修改 sql_mode ?

### 临时修改

通过 SQL 语句修改数据库模式
```SQL
SET GLOBAL sql_mode = 'modes';
SET SESSION sql_mode = 'modes';
```

- `SET SESSION sql_mode = 'modes'` 生命周期：只能修改当前数据库客户端所连接的数据库模式，只要当前客户端断开连接那么该设置的生命周期就完结了
- `SET GLOBAL sql_mode = 'modes';` 生命周期：影响当前数据库服务进程所有的客户端连接，但只要当前服务进程被中断或重启后该设置的生命周期就完结了

### 持久化修改

通过修改 `my.cnf` 配置中的 `sql-mode` 选项

```conf
[mysqld]
#set the SQL mode to strict
sql-mode="modes..."
```

**注意：**

1. 配置是 `sql-mode`，中间使用英文状态的中横线 `-` 连接的，而不是下划线
2. 配置项 `sql-mode` 要放在 `[mysqld]` 下

![set sql-mode in my.cnf](/images/article/mysql-set-sql-mode-by-my.cnf.png)

## 有什么坑？

**1. 不同的数据模式对数据的校验规则不同，因此：强烈建议一旦使用了定义的 `sql_mode` 建表并写入数据后，就不要更改 `sql_mode`**

- 在数据写入表里面以后更改 `sql_mode` 可能会导致表中的数据发生损坏、丢失、默认值被改变等情况！
- 在做数据复制、数据迁移时，最好保持主库和从库的 `sql_mode` 一致，否则可能在复制、迁移过程中会失败或操作完成后两端数据不一致

## sql_mode 重要模式说明

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

    ![ERROR_FOR_DIVISION_BY_ZERO](/images/article/mysql-sql-mode-ERROR_FOR_DIVISION_BY_ZERO.jpg)
- `NO_ENGINE_SUBSTITUTION`：若需要的存储引擎被禁用或未编译安装，则抛出错误。没有设置该模式，会使用默认的存储引擎进行替代，并抛出一个异常
- `NO_UNSIGNED_SUBTRACTION`：没有设置该模式的时候，要求：计算两个无符号整数的差值时，其结果一定要为无符号整数（即：结果不能为负数），否则会报错！设置了该模式则不会报错！

    ![mysql-sql-mode-NO_UNSIGNED_SUBTRACTION](/images/article/mysql-sql-mode-NO_UNSIGNED_SUBTRACTION.png)

完整的 `sql_mode` 可以参考：[5.1.11 Server SQL Modes](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sql-mode-full)