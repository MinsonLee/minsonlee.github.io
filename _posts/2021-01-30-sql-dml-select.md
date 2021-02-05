---
layout: post
title: SQL 查询语句：SELECT
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

## `WHERE` 条件查询子句

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

### 算数运算符

| 运算符 | 描述 | 
| ------ | ---- |
| + | 加法 |
| - | 减法 |
| * | 乘法 |
| / | 除法 |
| % | 取模（取余数） |


### 比较运算符

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

### 逻辑运算符

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

### `NULL` 值的判断

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

### `EXISTS` 与 `IN` 的使用区别

### `ALL` 和 `ANY` 的用法

### `BETWEEN` 和 使用 `>` `<` 符号进行判断范围的区别


## GROUP BY 分组查询子句

`GROUP BY` 查询子句可以根据给定列（该列称为：聚合列）的值对数据集进行分组，一般会结合聚合函数或聚合分析函数最终得到一个分组汇总表。

聚合函数是将组中的行汇总计算为单个值的函数，如：`COUNT()`-计算行数、`SUM()`-求和、`AVG()`-求平均值、`MAX()`-取集合中的最大值、`MIN()`-取集合中的最小值...等

需要注意的是：

1. 严格模式下：当 `SELECT` 语句配合 `GROUP BY` 子句一起使用时，`SELECT` 的列、`HAVING` 子句的列、`ORDER BY` 的非聚合函数列都必须要出现在 `GROUP BY` 列中（即：在使用 `GROUP BY` 语句时，非聚合列只有使用了聚合函数才能在 `SELECT` 列中）
2. 宽松模式下：如果非聚合列和聚合列是一一对应，那么得到的汇总结果是正确的，但是：若非聚合列和聚合列不是一一匹配时，非聚合列出现的值是随机不准确的

因此：工作中，`sql_mode` 一般我们都会设置为严格模式 `ONLY_FULL_GROUP_BY`！对问题的详细描述可以看官方文档-[《MySQL Handling of GROUP BY》](https://dev.mysql.com/doc/refman/8.0/en/group-by-handling.html)，或参考博文：[《神奇的 SQL 之层级 → 为什么 GROUP BY 之后不能直接引用原表中的列》](https://www.cnblogs.com/youzhibing/p/11516154.html)，深究可以学习一下集合论再去查看：《SQL基础教程》、《SQL进阶教程》书籍。

总的来说：`GROUP BY` 是按照某一列或几列进行“分组”查询，查询的信息必须是分组的依据或“组”属性信息。如：根据学生身高和性别进行分组，你只能得到这个组里身高、性别的分组信息，或者得到最高的身高、各自组有多少人等这类分组依据及组属性信息，但是**不能一步到位的得到**这个组里最高身高的男生是谁这类明确到具体组员的非分组依据信息！

![mysql-select-group-by-error-on-only_full_group_by](/images/article/mysql-select-group-by-error-on-only_full_group_by.png)

## HAVING 查询筛选子句

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

！！！注意：如果同时写了 `WHERE` 和 `HAVING` 子句， `WHERE` 子句一定要写在 `HAVING` 子句前面，因为：`WHERE` 子句针对的是磁盘中的数据集进行过滤筛选，而 `HAVING` 子句是针对 `WHERE` 子句查询放到内存中的临时结果集来操作的！


## 练习题：WHERE-HAVING-GROUP 综合练习

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

- https://blog.csdn.net/ccy950903/article/details/78184480
- https://blog.csdn.net/u011781769/article/details/48471013?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.control
