---
layout: post
title: "MySQL Cheat Sheet"
date: 2019-12-18
tag: MySQL
---

`MySQL Cheat Sheet` 记录一些 `SQL` 用法

## 查询

```sql
-- 使用正则查询：binary - 严格区分大小写
SELECT * FROM db.`seo_landmark` WHERE binary url_code REGEXP '[^a-zA-Z0-9\-]'

-- MySQL 8.0 以前，匹配中文无法使用十六进制的方式
SELECT `code`,content FROM db.translate_poor_tbl WHERE `language` = 'en' and  binary content REGEXP '[一-龥]';

-- 所有非英文状态的字符：[^!-~]
SELECT `code`,content FROM db.translate_poor_tbl WHERE `language` = 'en' and  binary content REGEXP '[^!-~ ]';
```

```sql
-- language = en 排在最前，然后根据 id 顺序排列
SELECT * FROM db.`translate_poor_tbl` WHERE code='xxx' AND is_del=0 ORDER BY case when `language` = 'en' then 0 ELSE `id` end;
```

```sql
-- 清空表数据
TRUNCATE db.member_discount_order;
INSERT INTO db.member_discount_order (order_id,user_id,currency,save_price,add_time,order_type,business_id)

-- 确认页单卖保险订单 && 管理员续保订单
SELECT insurance.* FROM (SELECT
	i.order_id, 
	IF(o.user_id = 0 , ot.userid, o.user_id) AS user_id, 
	i.currency, 
	i.discount AS save_price, 
	i.add_time, 
	2 as order_type,
	IF(i.policy_number != '', i.id, MAX(i.id)) AS business_id
FROM db.order_insurance_tbl AS i 
INNER JOIN db.order_child_tbl AS o ON o.order_id = i.order_id AND o.insurance_type = i.`type`
INNER JOIN db.order_tbl AS ot ON ot.order_id = i.order_id
WHERE i.add_time > 1610467200 AND i.discount > 0 AND i.policy_status IN (1,5) AND ot.status_no = 1 GROUP BY i.order_id,i.`type` 
HAVING user_id IN (
	SELECT `id` FROM `erc_user_db`.`user_tbl` WHERE grade_id = 4 OR paid_grade_id = 4
) ORDER BY i.add_time) AS insurance 

UNION 

-- 租车订单
SELECT car.* FROM (
SELECT 
	order_id,
	userid AS user_id, 
	TRIM('"' from JSON_EXTRACT(CAST(currency_in_use AS JSON),'$."markup_currency"')) AS currency, 
	JSON_EXTRACT(CAST(currency_in_use AS JSON),'$."markup_member_save_price"') AS save_price, 
	add_time,
	1 AS order_type,
	0 AS business_id
FROM db.order_tbl
WHERE add_time > 1610467200 AND userid != 0 AND status_no = 1 AND userid IN (
	SELECT `id` FROM `erc_user_db`.`user_tbl` WHERE grade_id = 4 OR paid_grade_id = 4
) AND currency_in_use LIKE '%markup_member_save_price%' HAVING save_price > 0 
ORDER BY add_time
) AS car

ORDER BY add_time;

-- 查询构造出一个 JSON 对象
SELECT
    JSON_OBJECT(
        'X', json_extract(my_json_column, '$.X'),
        'Y', json_extract(my_json_column, '$.Y'),
        'KB', json_extract(my_json_column, '$.KB'),
        'Name', json_extract(my_json_column, '$.Name')
    ) my_new_json
FROM my_table;
```

```sql
-- 多字段 in 查询的一种情况 ==> 等价于 (clid = 999234 and id = 626555200) or (clid = 1067005 and id = 1700000)
SELECT * FROM `order_tbl` where (clid,id) in ((999234, 626555200), (1067005, 1700000))
```

*   MySQL使用DISTINCT过滤重复数据
*   [SQL 中将制定的数据排在第一行](https://blog.csdn.net/qq_36903131/article/details/88997817)
*   强制索引的语法：`SELECT * FROM table_name FORCE INDEX (index_name) WHERE condition;`

```sql
-- 查询某个表是否存在
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '<db>' AND TABLE_NAME = '<table>';
```

`order by` + `case` 干扰排序：根据 `a` 列排序，但是希望 `a=xx` 的记录排在首位 `order by CASE WHEN a = 'xxx' THEN 0 ELSE 1 END, a ASC`
  
```sql
SELECT
  *
FROM
  (
    SELECT
      i.id,
      i.kid,
      s.`language`,
      FROM_UNIXTIME(s.update_time, '%Y-%m-%d %H:%i:%s') as last_update_time,
      s.`code`,
      s.content,
      CASE
        WHEN s.`language` = 'en' THEN ''
        ELSE s.operator
      END as operator,
      CASE
        WHEN s.`language` = 'en' THEN ''
        ELSE s.charge_admin
      END as charge_admin,
      i.last_admin_id
    FROM
      `zuzuche_world_manage_db`.`translate_task_info_tbl` as i
      INNER JOIN `zuzuche_world_manage_db`.`translate_task_tbl` as t on t.type = 'translate_poor'
      and t.id = i.kid
      INNER JOIN `db`.`translate_poor_tbl` as s on s.`code` = t.key_str_value
      and s.`language` IN ('en', i.`language`)
    WHERE
      i.type = 'translate_poor'
      AND i.audit_status = 6
      and i.`language` not in ('ru', 'nl', 'sv', 'el', 'no', 'da', 'uk')
  ) as tmp
GROUP BY
  kid,
  `language`
order by
  `code`,
  CASE
    WHEN `language` = 'en' THEN 0
    ELSE 1
  END,
  `language` ASC;
```


## 更新

```sql
-- update by select
UPDATE tableA a
INNER JOIN tableB b ON a.name_a = b.name_b
SET validation_check = if(start_dts > end_dts, 'VALID', '')
WHERE clause
```

```sql
-- 批量更新多列数据（wehere 条件一定要“准确”限制，最好准确限制id）
UPDATE tableA a
SET `列名` CASE
WHEN 条件1 THEN 值1
WHEN 条件2 THEN 值2
WHEN 条件3 THEN 值3
END
WHERE XXX AND `id` in (xxx, xxx)
```

```sql
-- 改表名：db 需要是同样的
RENAME TABLE `db`.`old_tbl` TO `db`.`new_tbl`;
```

## 新增

```sql
-- insert into
INSERT INTO table2
(column_name(s))
SELECT column_name(s)
FROM table1;
```


## 创建表

```sql
-- 表不存在才创建 CREATE TABLE IF NOT EXISTS `table_name` ( xxx );
-- 覆盖创建：DROP TABLE IF EXISTS `table_name`; CREATE TABLE `table_name` (xxx);
-- 基于某个表，创建一个结构一样的表
CREATE TABLE IF NOT EXISTS `zuzuche_world_supplier_db`.`search_resource_fulltext_ar_tbl` LIKE `zuzuche_world_supplier_db`.`search_resource_fulltext_tbl`;
```


### 导入、导出

- 导入：先 `mysql -h xxxx -P 3306 -u xx -pxxx`，然后 `user <db>`，最后 `source </path/xxx.sql>`

## 常用函数

### 字符串函数

*   `CONCAT("xxx", "bbb", clom)` 字符串拼接
*   `GROUP_CONCAT(expr SEPARATOR ',')` 结合 `group by` 试用，将同组某个字段进行拼接
*   有 `a_b_c` 字符串：
    *   获取 `b,c` ：`REPLACE(SUBSTRING('a_b_c', LOCATE('_', 'a_b_c') + 1), '_', ',')`
    *   获取 `a,b` : `REPLACE(SUBSTRING('a_b_c', 1, CHAR_LENGTH('a_b_c') - LOCATE('_', REVERSE('a_b_c'))), '_', ',')`
*   `Base64` 加解码：
    *  加密：`TO_BASE64(xxx)`
    *  解码：`FROM_BASE64(xxx)`，要跟 `PHP` 中的 `base64_decode(xxx)` 等同的话，需要 `CONVERT(FROM_BASE64(li.new_info) USING utf8mb4`
*  转义函数
    *  `QUOTE(string)` 返回一个合法的 SQL 字符串，自动在首尾加引号并转义
    *  `JSON_QUOTE(string)` 将字符串转义为合法的 JSON 格式，常用于 JSON 列

### 时间函数

*   `from_unixtime(unix_timestamp, format)` 格式化时间戳
*   `UNIX_TIMESTAMP("2024-02-17")` 获取时间戳
*   `UNIX_TIMESTAMP(CURRENT_TIMESTAMP(6))` 获取时间戳（精确到毫秒）
*   `CURRENT_TIMESTAMP(6)` 或 `now(6)` 当前时间-精确到毫秒
*   `timestampdiff(hour, FROM_UNIXTIME(add_time, '%Y-%m-%d %H:%i %f'), FROM_UNIXTIME(from_date_bj, '%Y-%m-%d  %H:%i'))` 计算时间差异
    *   `FRAC_SECOND` 间隔单位是毫秒
    *   `SECOND` 间隔单位是秒
    *   `MINUTE` 间隔单位是分钟
    *   `HOUR` 间隔单位是小时
    *   `DAY` 间隔单位是天
    *   `WEEK` 间隔单位是周
    *   `MONTH` 间隔单位是月
    *   `QUARTER` 间隔单位是季度
    *   `YEAR` 间隔单位是年

### JSON 相关

*   `JSON_VALID(json_string)` 判断字符串是否是 `JSON`，1-是；0-否；NULL

