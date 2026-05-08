```sql
SELECT count(*) as num,origin_id,origin_type,end_id,end_type FROM wp_route GROUP BY origin_id,origin_type,end_id,end_type HAVING num > 1;
```

**查询结果如下：**

num | origin_id | origin_type | end_id | end_type
----|-----------|-------------|--------|---------
2 | 1992 | 11 | 43945 | 1
2 | 1992 | 11 | 43946 | 1
2 | 1992 | 11 | 43947 | 1
2 | 2765 | 11 | 39588 | 1
2 | 2765 | 11 | 39619 | 1
2 | 3243 | 11 | 44527 | 1
2 | 3243 | 11 | 44901 | 1
2 | 3243 | 11 | 45454 | 1
2 | 3359 | 11 | 47335 | 1
2 | 3359 | 11 | 47337 | 1
2 | 102297 | 11 | 47649 | 1
2 | 102297 | 11 | 51051 | 1

**目的：重复的数据只保留 id 最小的那条记录，其余的不删除**

```
-- 当前任务情况
SELECT * FROM run_task_data;
-- 当前路线总数
SELECT count(*) FROM wp_route;
-- 已经跑过的路线总数
SELECT count(*) FROM wp_route WHERE open_status != 0;
-- 开放的路线总数
SELECT count(*) FROM wp_route_detail;
-- 重复的路线
SELECT count(*) as num,origin_id,origin_type,end_id,end_type FROM wp_route GROUP BY origin_id,origin_type,end_id,end_type HAVING num > 1;
-- 死循环的路线(起点和终点一样)
SELECT id, origin_id,origin_type,end_id,end_type FROM wp_route WHERE origin_id = end_id and origin_type = end_type;
-- 最后一条城市<-->城市路线
SELECT id, origin_id,origin_type,end_id,end_type FROM wp_route WHERE origin_type = 11 and end_type = 11 order by id desc limit 1;
-- 最后一条城市-->景点路线
SELECT id, origin_id,origin_type,end_id,end_type FROM wp_route WHERE origin_type = 11 and end_type = 1 order by id desc limit 1;
-- 最后一条地标<-->地标路线
SELECT id, origin_id,origin_type,end_id,end_type FROM wp_route WHERE origin_type != 11 order by id desc limit 1;
-- 可开放国家
SELECT * FROM wp_region WHERE region_id in (SELECT origin_region_id FROM wp_route WHERE id <= (SELECT route_id FROM run_task_data) and open_status = 1);
```