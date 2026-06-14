---
layout: post
title: SQL 练习题：WHERE-HAVING-GROUP 综合练习
date: 2021-02-05
tags: [MySQL,SQL,DML,练习题]
---

> 文中涉及的数据表见文章：[SQL DML 语句简介](https://minsonlee.github.io/2021/01/sql-dml-select)

有如下 `result` 表及数据，要求查询出 2 门及 2 门以上不及格者的平均成绩！

![mysql-demo-table-result](/images/article/mysql-demo-table-result.png)

思路应该都知道：①.先找出有 2 门及 2 门以上不及格的人；②. 利用 `avg()` 函数求平均值！

取平均值没什么难度，仅仅是函数的简单运用而已，那么怎么找出 2 门及 2 门以上不及格的人，就成了关键！

**错误示范：**

说到统计不及格的人数，可能一下子就想到了 `count( score < 60 )`，这是最显著的一种错误：`count()` 函数的理解错误！如下：

```SQL 
select name,count(score < 60) as num ,avg(score) as average from result group by name having num > 1;
```

![mysql-demo-error-count](/images/article/mysql-demo-error-count.png)

乍一看结果是正确的！

但是若此时再增加几条合格的记录，然后再执行上述查询，上述的错误就昭然若揭了。如下：

```SQL
-- 添加一条王五合格的数据，三条赵六合格数据
INSERT INTO result (`name`, `subject`, `score`) VALUE ('王五', '语文', 99), ('赵六','A',100),  ('赵六','B',99), ('赵六','C',98)

-- 查询有 2 门及 2 门以上不及格者的平均成绩
select name,count(score < 60) as num ,avg(score) as average from result group by name having num > 1;
```

![mysql-demo-error-select-count.png](/images/article/mysql-demo-error-select-count.png)

王五只有 1 科不合格，但是结果给统计出来了；赵六 3 科都合格，还是给统计出来了！

也就是说 `count(score < 60)` 理解错误了。理解如下：

- `COUNT(*)` 返回结果集中所有的行数，包括：`NULL` 和所有非 `NULL` 的记录数
- `COUNT(expression)` 返回所有非 `NULL` 记录
- `COUNT( DISTINCT expression)` 返回所有排重之后的非 `NULL` 记录

在刚才的 `result` 表中插入一条 `NULL` 的数据，如下：

![mysql-demo-count-table-result](/images/article/mysql-demo-count-table-result.png)

分别看看 `COUNT(*)`、`COUNT(expression)`、`COUNT( DISTINCT expression)`、`COUNT(1)`、`COUNT(0)` 几种情况的结果

![mysql-demo-count-*-table-result](/images/article/mysql-demo-count-all-table-result.png)
![mysql-demo-count-column-table-result](/images/article/mysql-demo-count-column-table-result.png)
![mysql-demo-count-0-table-result](/images/article/mysql-demo-count-0-table-result.png)
![mysql-demo-count-distinct-column-table-result](/images/article/mysql-demo-count-distinct-column-table-result.png)
![mysql-demo-count-1-table-result](/images/article/mysql-demo-count-1-table-result.png)


从上述图可以看出：`COUNT()` 函数只要不涉及列，那么返回的都是所有行记录，如果表达式涉及了列那么会过滤掉 `NULL` 记录（因为 `NULL` 表示什么都没有，不能做比较）！

**正确解答：**通过 `SUM(expression)` 解决，如下图！

![mysql-demo-select-table-result](/images/article/mysql-demo-select-table-result.png)
![mysql-demo-select-sum-table-result](/images/article/mysql-demo-select-sum-table-result.png)

```SQL
select name, sum(score < 60) as num, avg(score) as average from result group by name having num > 1;
```

![mysql-select-sum-group-by-having](/images/article/mysql-select-sum-group-by-having.png)
