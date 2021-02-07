---
layout: post
title: SQL DML 语句简介
date: 2021-01-30
tags: [MySQL,SQL,DML]
---

1. 测试 `SQL` 语句准备：[点击下载SQL测试文件](https://minsonlee.github.io/attaching/test-mysql.sql)

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

![source file.sql](/images/article/mysql-sour-sql-file.png)

详细的 SQL 语法文档，见：[https://dev.mysql.com/doc/refman/8.0/en/sql-statements.html](https://dev.mysql.com/doc/refman/8.0/en/sql-statements.html)

常用的 `DML` 基础语句基本就是：`CRUD`

- 新增-`INSERT` :`INSERT INTO <table> (col1, col2,....) values (value1, value2,....)`-"插入值"与"列"要一一对应
- 删除-`DELETE`：`DELETE from <table> [where <expression>];`-**一般来说工作中删除操作是必须携带 `where` 条件限制的**
- 更新-`UPDATE`：`UPDATE <table> set <key=value>[, <key2=value2>..] [where <expression>];`-更新指定列，**一般来说工作中更新操作是必须携带 `where` 条件限制的**
- 查询-`SELECT`：`SELECT (col1, col2,...,or function) FROM <table> [WHERE <expression>] [GROUP BY <cols>] [HAVING <expression>] [ORDER BY <col> ASC|DESC] [LIMIT 0,100]`-**查询遇到最多的就是查询优化问题-也是重点！！！**

**注意：更新和删除操作一定要记得检查 `WHERE` 条件，除非对生活心灰意冷了否则还是加上比较好！即使真的是需要影响整个表的数据也加上，养成写上 `WHERE` 条件，检查 `WHERE` 条件再执行的好习惯！**

`SELECT` 查询有 5 种子句:
- `WHERE` 子句：条件查询-`WHERE <expression>`
- `GROUP BY` 子句：分组查询-`GROUP BY <cols>`
- `HAVING` 子句：筛选查询-`HAVING <expression>`
- `ORDER BY` 子句：排序查询-`ORDER BY <cols> ASC|DESC`
- `LIMIT` 子句：范围查询-`LIMIT <start>,<end>`

> 注意：5 种子句在书写 `SQL` 的时候是有严格顺序的： `where` > `group by` > `having` > `order by` > `limit`**

## 列相当于“变量”，可以进行计算！

关系型数据库是通过二维表的方式进行组织数据：一**行**代表**一条完整的记录**，一**列**代表**同一类数据**！

所有的数据都是按照“列”的关系进行组织，然后按照“行”的形式进行存储，从编程语言的角度来说：列相当于变量，而行相当于变量的值！

变量是统计学中引入的概念，它的定义如下：它表示数字的字母字符，具有任意性和未知性。 把变量当作是显式数字一样，对其进行代数计算，可以在单个计算中解决很多问题！

因此：列也具备同样的作用：可以进行代数计算！

如：从 `user` 表中查找所有 `uid`、 `name`、 `age` 三列，并给 `age` 列所在值进行加一操作！
```sql
select uid, name, age+1 from user;
```

![mysql-select-colum-as-param.png](/images/article/mysql-select-colum-as-param.png)

如图对列进行代数计算，语句是可以正常执行的！

`SELECT` 语句还可以配合算数运算符、逻辑运算符和位运算符以及相关函数写出更高效率的查询语句（注意运算符的优先级）！