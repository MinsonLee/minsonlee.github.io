---
layout: post
title: 为什么Navicat行数和表实际行数不一致？
date: 2021-06-24
tags: [MySQL,SQL,sql_mode]
---

前天下班的时候将 130w+ 条数据导入到本地数据库中，第二天早上回来一看提示已经执行完毕。我通过 Navicat 打卡表查看数据，偶然瞟见 Navicat 的行数记录居然只是显示 2W+ 行。

![Navicat-table-rows](/images/article/why-table-rows-is-different-with-count-table/Navicat-table-rows.png)

吓了我一跳，难道中途中断了？没全部导入成功？随即打开表 COUNT 查了一下表

![select-count-table](/images/article/why-table-rows-is-different-with-count-table/select-count-table.png)

发现表数据确实是导入成功了的。那么为什么 Navicat 的行数记录居然只是显示 2W+ 行呢？

按理来说 Navicat 只是显示 MySQL 的表信息而已，所以先翻查了 MySQL 的手册找了一下答案，确实是如此。

MySQL 将所有表的信息存放在 `information_schema.TABLES` 表中，查询了一下该表中的记录信息，发现确实是这个表里统计记录的信息有误。

![select-table-rows](/images/article/why-table-rows-is-different-with-count-table/select-table-rows.png)

MySQL 的官方文档对 `TABLE_ROWS` 的解释如下：

**· TABLE_ROWS**

The number of rows. Some storage engines, such as `MyISAM`, store the exact count. For other storage engines, such as InnoDB, this value is an approximation, and may vary from the actual value by as much as 40% to 50%. In such cases, use `SELECT COUNT(*)` to obtain an accurate count.

行的数量。一些存储引擎，比如 MyISAM，存储的是精确的计数。对于其他的存储引擎，比如 InnoDB，这个值是一个近似值，可能与实际值相差 40%-50%。
在这种情况下，使用 SELECT COUNT(*) 来获得一个准确的计数。

疑惑得到了解答。因为此处显示的只是一个近似值，虽然网上说可以通过其他方式（`analyze table tableName`）得以更正这个数据，但是我实验之后发现是并不能更正数据，不建议使用。