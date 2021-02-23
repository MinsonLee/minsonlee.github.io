---
layout: post
title: SQL 语句：ORDER BY 排序查询子句 && LIMIT 范围查询
date: 2021-02-23
tags: [MySQL,SQL,sql_mode]
---

> 文中涉及的数据表见文章：[SQL DML 语句简介](https://minsonlee.github.io/2021/01/sql-dml-select)

## ORDER BY 排序查询

`ORDER BY` 的作用：**对临时查询结果集进行排序**，而不是针对从磁盘加载到内存的初始数据集进行排序后再查询！

## LIMIT 范围查询

`ORDER BY` 的作用：**对临时查询结果集进行排序**！

## ORDER BY 与 LIMIT 的应用

要求针对商品表 `goods` 做以下查询

1. 按价格由高到低排序

```SQL
SELECT goods_id,goods_name,shop_price FROM goods ORDER BY shop_price DESC;
```

2. 按发布时间由早到晚排序

```SQL
SELECT goods_id,goods_name,add_time FROM goods ORDER BY add_time;
```

3. 接栏目由低到高排序,栏目内部按价格由高到低排序【有冲突时，顺序决定优先】

```SQL
SELECT goods_id,cat_id,goods_name,shop_price FROM goods ORDER BY cat_id ,shop_price DESC;
```

4. 取出价格最高的前三名商品

```SQL
SELECT goods_id,goods_name,shop_price FROM goods ORDER BY shop_price DESC LIMIT 3;
```

5. 取出点击量前三名到前5名的商品

```SQL
SELECT goods_id,goods_name,click_count FROM goods ORDER BY click_count DESC LIMIT 2,3;
```

### ORDER BY 与 LIMIT 的经典应用-分页

#### 普通分页原理介绍

#### 分页如何优化？


## ORDER BY 的优化

## LIMIT 的优化

## ORDER BY 与 LIMIT 共同使用的坑？


## 工作中注意的事项
1. 生产环境对验证 SQL 是否正常，一定要先用 LIMIT 校验一下，避免更改影响全表或扫描全表