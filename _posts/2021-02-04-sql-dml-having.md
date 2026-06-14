---
layout: post
title: SQL 语句：HAVING 查询筛选子句
date: 2021-02-04
tags: [MySQL,SQL,DML]
---

> 文中涉及的数据表见文章：[SQL DML 语句简介](https://minsonlee.github.io/2021/01/sql-dml-select)

`HAVING` 是针对查询得到的结果集进行进一步的过滤筛选。因此：`HAVING` 条件涉及的列一定是在 `SELECT` 临时结果集中出现的列。

注意：如果 `SELECT` 的列使用了 `AS` 命名了别名，那么 `HAVING` 做筛选时候也需要使用别名！

以商品表-`goods` 表为例，要求：查询 `goods` 表中商品比市场价低出至少 200 的商品。如下：

1. 结合**列是变量，可以进行计算**，查询 `goods` 表中商品比市场价低出多少？

```SQL
SELECT goods_id, goods_name, (market_price - shop_price) as diff_price FROM `goods` WHERE market_price > shop_price;
```

注意：`MySQL 8` 的数据库模式默认是严格模式，若计算列及其结果超出了列类型所定义的数据类型范围，会报错：`(1690, "XXX value is out of range in 'xxxx'`，详细可阅读官方文档：[《11.1.7 Out-of-Range and Overflow Handling》](https://dev.mysql.com/doc/refman/8.0/en/out-of-range-and-overflow.html)。

测试表 `goods` 中，`market_price` 和 `shop_price` 都是非负小数：`DECIMAL UNSIGNED`，而 `(market_price - shop_price)` 可能会出现负数，因此在数据库严格模式下这个运算可能会出现报错，如下图：

![mysql-error-DECIMAL-UNSIGNED-value-is-out-of-range-in-goods](/images/article/mysql-error-DECIMAL-UNSIGNED-value-is-out-of-range-in-goods.png)

解决方法有如下几种：

- 在查询时候需要加上 ` WHERE market_price > shop_price` 确保计算结果范围正确！（推荐：养成书写严格模式的 SQL 是一个好习惯，兼容性也比较高）


- 给 `sql_mode` 增加设置 `NO_UNSIGNED_SUBTRACTION`，允许计算结果与计算列数据类型不同

![mysql-set-sql-mode-no-unsigned-subtraction](/images/article/mysql-set-sql-mode-no-unsigned-subtraction.png)

- 通过 `CAST()` 函数改变计算列的取值范围

```SQL
 SELECT goods_id, goods_name, (CAST(market_price as SIGNED) - CAST(shop_price AS SIGNED)) AS diff_price FROM `goods`;
 ```
 
 ![mysql-select-cast-change-colum's-data-struct.png](/images/article/mysql-select-cast-change-colum%27s-data-struct.png)


2. 查询 `goods` 表中商品比市场价低出至少 200 的商品？

- 利用 `WHERE` 子句实现：

```SQL
SELECT goods_id, goods_name, (market_price - shop_price) as diff_price FROM `goods` WHERE market_price > shop_price and  (market_price - shop_price) >= 200;
```

- 利用 `HAVING` 子句实现：

```SQL
SELECT goods_id, goods_name, (market_price - shop_price) as diff_price FROM `goods` WHERE market_price > shop_price HAVING  diff_price >= 200;
```

**！！！注意：如果同时写了 `WHERE` 和 `HAVING` 子句， `WHERE` 子句一定要写在 `HAVING` 子句前面，因为：`WHERE` 子句针对的是磁盘中的数据集进行过滤筛选，而 `HAVING` 子句是针对 `WHERE` 子句查询放到内存中的临时结果集来操作的！**
