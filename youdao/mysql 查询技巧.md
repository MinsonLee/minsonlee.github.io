```sql
-- 使用正则查询：
SELECT * FROM zuzuche_world_db.`seo_landmark` WHERE url_code REGEXP '[^a-zA-Z0-9\-]'
```

```sql
-- update by select
UPDATE tableA a
INNER JOIN tableB b ON a.name_a = b.name_b
SET validation_check = if(start_dts > end_dts, 'VALID', '')
WHERE clause
```

```sql
-- insert into
INSERT INTO table2
(column_name(s))
SELECT column_name(s)
FROM table1;
```


```sql
-- 清空表数据
TRUNCATE zuzuche_world_db.member_discount_order;
INSERT INTO zuzuche_world_db.member_discount_order (order_id,user_id,currency,save_price,add_time,order_type,business_id)

-- 确认页单卖保险订单 && 管理员续保订单
SELECT insurance.* FROM (SELECT
	i.order_id, 
	IF(o.user_id = 0 , ot.userid, o.user_id) AS user_id, 
	i.currency, 
	i.discount AS save_price, 
	i.add_time, 
	2 as order_type,
	IF(i.policy_number != '', i.id, MAX(i.id)) AS business_id
FROM zuzuche_world_db.order_insurance_tbl AS i 
INNER JOIN zuzuche_world_db.order_child_tbl AS o ON o.order_id = i.order_id AND o.insurance_type = i.`type`
INNER JOIN zuzuche_world_db.order_tbl AS ot ON ot.order_id = i.order_id
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
FROM zuzuche_world_db.order_tbl
WHERE add_time > 1610467200 AND userid != 0 AND status_no = 1 AND userid IN (
	SELECT `id` FROM `erc_user_db`.`user_tbl` WHERE grade_id = 4 OR paid_grade_id = 4
) AND currency_in_use LIKE '%markup_member_save_price%' HAVING save_price > 0 
ORDER BY add_time
) AS car

ORDER BY add_time;
```


- MySQL使用DISTINCT过滤重复数据


- [SQL 中将制定的数据排在第一行](https://blog.csdn.net/qq_36903131/article/details/88997817)

```sql
SELECT * FROM zuzuche_world_db.`translate_poor_tbl` WHERE code='xxx' AND is_del=0 ORDER BY case when `language` = 'en' then 0 ELSE `id` end;
```


## 常用函数

### 字符串函数

- `CONCAT("xxx", "bbb", clom)` 字符串拼接



### 时间函数

- `from_unixtime(unix_timestamp, format)` 格式化时间戳
- `UNIX_TIMESTAMP("2024-02-17")` 获取时间戳


### JSON 相关

- `JSON_VALID(json_string)` 判断字符串是否是 `JSON`，1-是；0-否；NULL