10、一个表（表名：t_score）结构如下：请用一条 SQL 语句列出各门课程成绩最好的两位学生（要求显示字段：姓名、科目、成绩）

ID | XM | KM | CJ
---|----|----|---
1  |张三|语文| 81
2  |张三|数学| 75
3  |张三|英语| 55
4  |李四|语文| 76
5  |李四|数学| 90
6  |王五|语文| 81
7  |王五|数学| 100
8  |王五|英语| 90
9  |赵六|语文| 61
10 |李四|数学| 90
11 |赵六|数学| 53
12 |赵六|英语| 95
13 |张三|数学| 75
14 |赵六|语文| 88
15 |王五|英语| 90

```sql
-- 测试数据 SQL

CREATE TABLE `t_score` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `XM` varchar(255) DEFAULT NULL,
  `KM` varchar(255) DEFAULT NULL,
  `CJ` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (1, '张三', '语文', 81);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (2, '张三', '数学', 75);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (3, '张三', '英语', 55);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (4, '李四', '语文', 76);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (5, '李四', '数学', 90);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (6, '王五', '语文', 81);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (7, '王五', '数学', 100);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (8, '王五', '英语', 90);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (9, '赵六', '语文', 61);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (10, '李四', '数学', 90);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (11, '赵六', '数学', 53);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (12, '赵六', '英语', 95);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (13, '张三', '数学', 75);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (14, '赵六', '语文', 88);
INSERT INTO `t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (15, '王五', '英语', 90);
```

思路如下：先定义类型、再分解问题、组合 SQL

1. 定义类型：这是一个和分组-排序-求 TopN 相关的 SQL，要用 1 条 SQL 实现那么大概率需要用到嵌套查询


2. 分解问题：
    1. 分组的纬度是什么？课程
    2. 排序的纬度是什么？成绩
    3. 数据有没有什么问题？有重复数据（需要排重）、需要考虑存在分数相同的学生情况...

即，如果我们首先需要初步得到一个类似如下的结果集：对相同课程记录按照成绩倒序排列

ID | XM | KM | CJ
---|----|----|---
14 |赵六|语文| 88
1  |张三|语文| 81
6  |王五|语文| 81
4  |李四|语文| 76
9  |赵六|语文| 61

然后针对上面的结果集，取 Top2 记录即可。

```sql
select * from t_score order by KM ASC, CJ DESC;
```

`TopN` 问题：相当于是给定一堆数字，然后求数字在这个序列中的排序，譬如：`[0 3 2 6 7 6]` 这 6 个数字序列（`test_num_tbl`）中，我要如何知道某个数字具体排第几个位呢？

临时构建出来的 `test_num_tbl` 相当于如下结构：

num|
---|
 0 |
 3 |
 2 |
 6 |
 7 |
 6 |

- Top 1：正常情况来说，没有比自身更大的数字（即：0 个比自身大的数字）
- Top 2：正常情况来说，只有 1 个比自身大的数字
- Top 3：正常情况来说，只有 2 个比自身大的数字
- ...


那么 `TopN` 的问题就变成了，求：有 ? 个数字比自身大的数字？


```sql
-- 譬如：7 排在第几？
select count(*) + 1 as px from test_num_tbl where num > 7;
```

而这个 `px` 就是我们需要的“值”。

`SQL` 的字段相当于是“变量”，变量有什么特性？即：可以是一个固定值、也可以是表达式得到的动态值


```sql
SELECT
	test1.num,
	( SELECT count(*) + 1 FROM test_num_tbl AS test2 WHERE test2.num > test1.num ) AS px 
FROM
	test_num_tbl AS test1 
ORDER BY
	px ASC;
```

这样就得到了一个如下的结果集：

num|px 
---|--
 7 | 1
 6 | 2
 6 | 2
 3 | 4
 2 | 5
 0 | 6
 
 此时只取结果集中的 `TopN` 记录，那么就是：对结果集进行过滤筛查-`HAVING`
 
 ```sql
SELECT
    test1.num,
    ( SELECT count(*) + 1 FROM test_num_tbl AS test2 WHERE test2.num > test1.num ) AS px 
FROM
    test_num_tbl AS test1 
HAVING
    px <= 2 
ORDER BY
    px ASC;
```

回到最初的面试题：

3. 写 SQL 解决：

如果不对 SQL 进行补充，那么 `SQL` 基本就可以写出来了：

```sql
SELECT
	t1.XM AS '姓名',
	t1.KM AS '科目',
	t1.CJ AS '成绩',
	( SELECT count(*) + 1 FROM `t_score` AS t2 WHERE t2.KM = t1.KM AND t2.CJ > t1.CJ ) AS px 
FROM
	`t_score` AS t1 
HAVING
	px < 3 
ORDER BY
	t1.KM ASC,
	CJ DESC,
	t1.ID ASC;
```

姓名 | 科目 | 成绩 | px 
-----|------|------|---
王五 | 数学 | 100  | 1
李四 | 数学 | 90   | 2
李四 | 数学 | 90   | 2
赵六 | 英语 | 95   | 1
王五 | 英语 | 90   | 2
王五 | 英语 | 90   | 2
赵六 | 语文 | 88   | 1
张三 | 语文 | 81   | 2
王五 | 语文 | 81   | 2

简单来说，一般笔试的话，写到这里这个面试题的结果算是做出来了，但这个只能是“不求有功，但求无过”的“面试”状况。

**我建议你：在题目旁边写上「需求有问题，待确定」的字样，这样可以吸引面试官的眼光，便于引导面试官和你互动沟通，确定需求...**

**工作中：「主动沟通能力很重要！」**。而这种 “无形的沟通能力” 如果你可以在面试中主动的提起并加以展现能，那么对初中级面试者来说是**非常**为自己面试过程中加分的。

类似题目开始最初提到的思路 「2. 分解问题」中的第 3 点：「数据有没有什么问题？有重复数据（需要排重）、需要考虑存在分数相同的学生情况...」 这些问题在实际工作中或者面试中就是需要我们主动的去找需求方、面试官去沟通和确定：这些特殊情况要怎么处理？？

如：

- 存在的重复数据对接过筛选有影响吗？譬如：若需显示数据的 ID，那么重复数据到底应该取哪一条记录的 ID 为准？
- 存在重复数据需要排重显示吗？数据的排重纬度是什么（单纯以“姓名-科目”来定义数据的唯一，还是以“姓名-科目-分数”来定义数据的唯一性呢）？
- 如果以“姓名-科目”纬度来确定数据唯一，排重是以取最大 ID 为准？还是取最大分数的记录为准？
- 线上表是否存在这种情况？出现重复数据是否是允许的？
- 如果不允许的话，为什么会出现这种情况？能否快速定位找到为什么，能否直接快速的修复这个情况（譬如：给数据表加唯一索引）？
- 如果不能简单粗暴有效的修复，那么后续产品应该要提优化需求来规避，需要将这个问题简单跟产品方反馈并让其自行跟进？

这样才是一个需求在“产品-研发-测试”中“研发端”的“简单闭环”，而不是：“淡出的写完 SQL 解决了问题” 就可以了。


上述用 SQL 将结果写出来了，从数据的角度来说结果确实是“正确”的，但是从“需求方的角度”来说，可能需求方是不接受这样的数据的。

例如：结果存在两条 「王四-数学-90-2」和两条「王五-英语-90-2」 的记录，显然这在真正的生产场景中是不对的。

而单纯的增加 `GROUP BY t1.XM,t1.KM` 进行去重会发现问题依然有问题...

```sql
SELECT
	t1.XM AS '姓名',
	t1.KM AS '科目',
	t1.CJ AS '成绩',
	( SELECT count(*) + 1 FROM `t_score` AS t2 WHERE t2.KM = t1.KM AND t2.CJ > t1.CJ ) AS px 
FROM
	`t_score` AS t1 
GROUP BY
	t1.XM,
	t1.KM 
HAVING
	px < 3 
ORDER BY
	t1.KM ASC,
	CJ DESC,
	t1.ID ASC;
```

姓名 | 科目 | 成绩 | px 
-----|------|------|---
王五 | 数学 | 100  | 1
李四 | 数学 | 90   | 2
赵六 | 英语 | 95   | 1
王五 | 英语 | 90   | 2
张三 | 语文 | 81   | 2
王五 | 语文 | 81   | 2


因为：「xx-语文-xx-1」的数据丢失了...简单一对比：「赵六-语文-88」、「赵六-语文-61」导致了丢失...

如果以最大成绩（即：最小的排名值）为有效成绩，那要如何解决呢？

```
SELECT
	t1.XM AS '姓名',
	t1.KM AS '科目',
	MAX(t1.CJ) AS '成绩',
	MIN(( SELECT count(*) + 1 FROM `t_score` AS t2 WHERE t2.KM = t1.KM AND t2.XM != t1.XM AND t2.CJ > t1.CJ )) AS px 
FROM
	`t_score` AS t1 
GROUP BY t1.XM,t1.KM
HAVING px < 3
ORDER BY
	t1.KM ASC,
	px ASC;
```

 姓名 | 科目 | 成绩 | px 
-----|------|------|---
 王五 | 数学 | 100 |1
 李四 | 数学 | 90 |2
 赵六 | 英语 | 95 |1
 王五 | 英语 | 90 |2
 赵六 | 语文 | 88 |1
 张三 | 语文 | 81 |2
 王五 | 语文 | 81 |2


最后如果再插入 1 条数据且问题进行补充：

1. 请用一条 SQL 语句列出各门课程成绩最好的 3 位学生
2. 要求显示字段： ID、姓名、科目、成绩、排序
3. 以“姓名-科目”纬度对数据进行去重，优先以分数最大的记录为准，如果分数相同则以 `ID` 值最小的记录为准
4. 要求在去重后对“单科”成绩的排序数据进行修正。如下方「张三-数学-75」在去重后，真正的排序应该是 `3`

```sql
-- 新增 1 条重复记录数据
INSERT INTO `test`.`t_score`(`ID`, `XM`, `KM`, `CJ`) VALUES (16, '王五', '数学', 100);
-- 新增后结果集
SELECT
	t1.ID,
	t1.XM AS '姓名',
	t1.KM AS '科目',
	t1.CJ AS '成绩',
	( SELECT count(*) + 1 FROM `t_score` AS t2 WHERE t2.KM = t1.KM AND t2.CJ > t1.CJ ) AS px 
FROM
	`t_score` AS t1 
ORDER BY
	t1.KM ASC,
	t1.CJ DESC,
	t1.ID ASC;
```

ID | 姓名 | 科目 | 成绩 | px 
---|-----|------|------|---
7  | 王五 | 数学 | 100 |1
16 | 王五 | 数学 | 100 |1
5  | 李四 | 数学 | 90 |3
10 | 李四 | 数学 | 90 |3
2  | 张三 | 数学 | 75 |4
13 | 张三 | 数学 | 75 |4
11 | 赵六 | 数学 | 53 |6
12 | 赵六 | 英语 | 95 |1
8  | 王五 | 英语 | 90 |2
15 | 王五 | 英语 | 90 |2
3  | 张三 | 英语 | 55 |4
14 | 赵六 | 语文 | 88 |1
1  | 张三 | 语文 | 81 |2
6  | 王五 | 语文 | 81 |2
4  | 李四 | 语文 | 76 |4
9  | 赵六 | 语文 | 61 |5

即：最终的结果应该是这样的

ID | 姓名 | 科目 | 成绩 | px 
---|-----|------|------|---
7  | 王五 | 数学 | 100 |1
5  | 李四 | 数学 | 90 |2
2  | 张三 | 数学 | 75 |3
12 | 赵六 | 英语 | 95 |1
8  | 王五 | 英语 | 90 |2
3  | 张三 | 英语 | 55 |3
14 | 赵六 | 语文 | 88 |1
1  | 张三 | 语文 | 81 |2
6  | 王五 | 语文 | 81 |2

思路上有什么需要改变的呢？最终 SQL 如下又该如何呢（可以不用写出来，思路的变化要想想）？

一些提示：

- 排序（`ORDER BY`）、分组（`GROUP BY`）功能的理解
- 对于 排序（`ORDER BY`）、分组（`GROUP BY`） 执行的顺序理解


一些可能有用的参考文章：

- [MySQL - WITH...AS 创建临时表复用子查询](https://developer.aliyun.com/article/946684)
- [MySQL - GROUP BY 默认查询第几条数据？](https://blog.csdn.net/Dream_Weave/article/details/117223109)
- [MySQL GROUP BY 详解](https://time.geekbang.org/column/article/80477)
- [MySQL GROUP BY](https://www.mysqltutorial.org/mysql-group-by.aspx)
- [sql中的join和inner join的区别](https://blog.csdn.net/hjfcgt123/article/details/84988077)

------

通过 ChatGPT 不断纠正明确需求得到的答案...强大的一匹

```sql
SELECT t1.ID, t1.XM, t1.KM, t1.CJ, COUNT(DISTINCT t2.CJ) AS 排序
FROM (
SELECT t.*, IF(@prev_XM_KM = CONCAT(XM, KM), @rank := @rank + 1, @rank := 1) AS rank,
         @prev_XM_KM := CONCAT(XM, KM)
  FROM t_score AS t, (SELECT @prev_XM_KM := NULL, @rank := 0) r
  ORDER BY KM, XM, CJ DESC, ID ASC
  ) t1
 JOIN ( 
  SELECT t.*, IF(@prev_XM_KM = CONCAT(XM, KM), @rank := @rank + 1, @rank := 1) AS rank,
         @prev_XM_KM := CONCAT(XM, KM)
  FROM t_score AS t, (SELECT @prev_XM_KM := NULL, @rank := 0) r
  ORDER BY XM, KM, CJ DESC, ID ASC
  ) t2
  ON t1.KM = t2.KM AND t1.CJ <= t2.CJ
WHERE t1.rank = 1
GROUP BY t1.ID, t1.XM, t1.KM, t1.CJ
HAVING 排序 <= 3
ORDER BY t1.KM, 排序, t1.ID;
```

| ID | XM | KM | CJ | 排序 | 
| ---: | --- | --- | ---: | ---: | 
| 7 | 王五 | 数学 | 100 | 1 | 
| 5 | 李四 | 数学 | 90 | 2 | 
| 2 | 张三 | 数学 | 75 | 3 | 
| 12 | 赵六 | 英语 | 95 | 1 | 
| 8 | 王五 | 英语 | 90 | 2 | 
| 3 | 张三 | 英语 | 55 | 3 | 
| 14 | 赵六 | 语文 | 88 | 1 | 
| 1 | 张三 | 语文 | 81 | 2 | 
| 6 | 王五 | 语文 | 81 | 2 | 


- 疑问：为什么“排序”是 `COUNT(DISTINCT t2.CJ)` 而不是 `COUNT(DISTINCT t1.CJ)`？