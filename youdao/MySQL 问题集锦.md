# MySQL 问题集锦

[TOC]


## 1、自增主键问题

1. 范围溢出：**warning: Duplicate entry '4294967295' for key 'PRIMARY'**

该错误报的是主键冲突，测试环境主键设置的属性为 `int(10) auto_increment`，被人误改为到 了`4294967295`，导致数据无法再继续插入。

类型 | 字节 | 最大值 (无符号)
-----|------|----------------
TINYINT | 1 | 255
SMALLINT | 2 | 65535
MEDIUMINT | 3 | 16777215
INT | 4 | 4294967295

查看当前表的 auto_increment 

```sql
select auto_increment from information_schema.tables where table_schema='db name' and table_name='table name';
```

修改表的 auto_increment

```sql
alter table <db>.<table> auto_increment = <NUMBER>;
```

对于 MySQL5.x 的版本，自增主键范围溢出报错信息显示的是：主键冲突，但在 MySQL8.X 的版本中报错信息显然就更加的友好了：`Out of range value for column 'id' at row 1`

- [45 | 自增id用完怎么办？](https://time.geekbang.org/column/article/83183)