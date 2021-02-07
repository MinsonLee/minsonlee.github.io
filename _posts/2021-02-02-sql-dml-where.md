---
layout: post
title: SQL 语句：WHERE 条件查询子句
date: 2021-02-02
tags: [MySQL,SQL,DML]
---

> 文中涉及的数据表见文章：[SQL DML 语句简介](https://minsonlee.github.io/2021/01/sql-dml-select)

条件运算在很多程序设计语言中都是存在的，其结果是布尔型，只有两种情况：真-true，假-false！

> 关于条件语句，PHP核心开发者鸟哥的博客有一篇文章-[一个关于if else容易迷惑的问题](https://www.laruence.com/2020/07/09/6015.html) 提到一句话：**这个世界上本无 `elseif`，有的只不过是 `else (if statement)`**，对条件运算的结果阐释的非常到位！

![mysql-select-where-true-or-false.png](/images/article/mysql-select-where-true-or-false.png)

- 查询出第4号、第11号商品的名称、价格

```sql
select goods_id,goods_name,shop_price from goods where goods_id in(4, 11);
```

![mysql-select-where-in.png](/images/article/mysql-select-where-in.png)

- 查询出第4号到第11号之间商品的名称、价格

```sql
select goods_id,goods_name,shop_price from goods where goods_id between 4 and 11;
```

![mysql-select-where-between-and.png](/images/article/mysql-select-where-between-and.png)

`SELECT` 可以使用 `LIKE` 运算符进行模糊查询：`%`-通配任意长度任意字符；`_`-通配单一任意字符

- 取出名字以"诺基亚"开头的商品

```sql
select goods_id,goods_name,shop_price from goods where goods_name like '诺基亚%';
```

![mysql-select-where-like-%](/images/article/mysql-select-where-like-%25.png)

- 取出名字为"诺基亚Nxx"的手机

```sql
select goods_id,goods_name,shop_price from goods where goods_name like '诺基亚N__';
```

![mysql-select-where-like-\_](/images/article/mysql-select-where-like-_.png)

- 取出名字不以"诺基亚"开头的商品

```sql
select goods_id,goods_name,shop_price from goods where goods_name not like '诺基亚%';
```

![mysql-select-where-not-like](/images/article/mysql-select-where-not-like.png)

当涉及到多重条件查询可以使用逻辑运算符： `AND`、 `OR`、 `NOT`...之类的来修饰条件时候，不管是 `SQL` 还是其他编程语言，多重条件一定要注意运算符的优先级问题，建议使用括号`()`将条件进行分类，避免优先级问题！

## 算数运算符

| 运算符 | 描述 | 
| ------ | ---- |
| + | 加法 |
| - | 减法 |
| * | 乘法 |
| / | 除法 |
| % | 取模（取余数） |


## 比较运算符

| 运算符 | 描述 |
| ------ | ---- |
| = | 检查两个操作数的值是否相等，如果是，则条件为真(true) |
| != | 检查两个操作数的值是否相等，如果值不相等则条件为真(true) |
| <> | 检查两个操作数的值是否相等，如果值不相等则条件为真(true) |
| > | 检查左操作数的值是否大于右操作数的值，如果是，则条件为真(true) |
| < | 检查左操作数的值是否小于右操作数的值，如果是，则条件为真(true) |
| >= | 检查左操作数的值是否大于或等于右操作数的值，如果是，则条件为真(true) |
| <= | 检查左操作数的值是否小于或等于右操作数的值，如果是，则条件为真(true) |
| !< | 检查左操作数的值是否不小于右操作数的值，如果是，则条件变为真(true) |
| !> | 检查左操作数的值是否不大于右操作数的值，如果是，则条件变为真(true) |

## 逻辑运算符

| 运算符 | 描述 | 
| ------ | ---- |
| AND | AND 运算符允许在SQL语句的WHERE子句中指定多个条件 |
| OR | OR 运算符用于组合SQL语句的WHERE子句中的多个条件 |
| BETWEEN | BETWEEN 运算符用于搜索在给定范围内的值 |
| LIKE | LIKE 运算符用于使用通配符运算符将值与类似值进行比较 |
| IS NULL | IS NULL 运算符用于将值与NULL值进行比较 |
| IN | IN 运算符用于将值与已指定序列的值列表进行比较 |
| EXISTS | EXISTS 运算符用于搜索指定表中是否存在满足特定条件的行 |
| NOT | NOT 运算符反转使用它的逻辑运算符的含义。 例如：NOT EXISTS, NOT BETWEEN, NOT IN, IS NOT NULL 等等，这是一个否定运算符 |
| ANY | ANY 运算符用于根据条件将值与列表中的任何适用值进行比较 |
| ALL | ALL 运算符用于将值与另一个值集中的所有值进行比较 |
| UNIQUE | UNIQUE 运算符搜索指定表的每一行的唯一性(无重复项) |

对于以上提到的绝大部分运算符都很好理解，有几个点需要特别注意： `NULL` 值的判断、 `EXISTS` 与 `IN` 的使用区别、 `ALL` 和 `ANY` 的用法、 `BETWEEN` 和 使用 `>` `<` 符号进行判断范围的区别。

## `NULL` 值的判断

`NULL` 表示的是什么都没有，它与空字符串、0 这些是不等价的，是不能用于比较的！
如： `<expr> = NULL` 、 `NULL = ''` 得到的结果为 `false`，判断 `NULL` 必须使用 `IS NULL` 或 `IS NOT NULL` 进行判断。

如下图，在 `result` 表中插入一条含有 `NULL` 值的数据，进行演示！

```SQL
insert into result values ('王五',NULL,NULL);
```

![mysql-null-demo-table-result](/images/article/mysql-null-demo-table-result.png)
![mysql-null-where-expr-comper](/images/article/mysql-null-where-expr-comper.png)

**数据库建表的时候默认是 `NULL`，但在工作中一般建表的时候都会禁止使用 `NULL` 的！**

1. 不利于代码的可读性和可维护性，特别是强类型语言，查询 `INT` 值，结果得到一个 `NULL`，程序可能会奔溃...如果要兼容这些情况程序往往需要多做很多操作来兜底
2. 若所在列存在 `NULL` 值，会影响 `count()`、 `<col> != <value>`、 `NULL + 1` 等查询、统计、运算情景的结果
3. 虽然 `NULL` 代表什么都没有，但是 `MySQL` 需要一个额外字节作为判断是否为 `NULL` 的标志位（这就有点脱裤子放屁了）

**因此：`NULL` 的操作判断不管在数据库、程序中都很麻烦，一般会通过一个有意义的同类型值表示 `NULL` 值**

- [MySQL文档：Problems with NULL Values](https://dev.mysql.com/doc/refman/8.0/en/problems-with-null.html)
- [MySQL文档：Working with NULL Values](https://dev.mysql.com/doc/refman/8.0/en/working-with-null.html)
- [MySQL文档：How MySQL Partitioning Handles NULL](https://dev.mysql.com/doc/refman/8.0/en/partitioning-handling-nulls.html)

## `EXISTS` 与 `IN` 的使用区别

## `ALL` 和 `ANY` 的用法

## `BETWEEN` 和 使用 `>` `<` 符号进行判断范围的区别
