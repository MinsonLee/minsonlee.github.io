- https://blog.csdn.net/qmhball/article/details/7917033
- https://blog.csdn.net/xixihahalelehehe/article/details/105743583


背景：

之前让 DBA 将一个非主业务的表保留一部分数据，其余的 100w+ 无用数据删掉，对方让提供 `id`，结果对方一条条 `where id = xxx` 的删除，删了几个钟，让我等的抓狂...他说这样不会锁表。(⊙o⊙)…没理由反驳。

但是：

1. 非主业务的表，可接受短暂几十毫秒的锁表
2. 该表的并发查询/更新不高

在测试环境模拟了一下，`where id in (xxx)` 删除 5k 左右数据，基本是毫秒级执行完毕。

这次又有一个需求，有 70w+ 的废弃数据需要删除，这次自行处理好 SQL 文件发给 DBA，让他直接执行即可。

使用到了 `split` 命令将 `id` 分隔为多个文件，然后通过 `sed` 自动替换成完整 `SQL` 命令.

## `split` 示例

用法：`split [<options>...] [File [Prefix]]`。

默认：
- 以 1000 行来分隔文件
- 默认分隔后文件前缀是 `x`，即：分隔生成的文件是 `xaa`、`xab` 这样的文件

参数 | 说明 | 示例
-----|------|-----
`-b,--bytes=size` | 将文件切分为每个大小为 size 的小文件 | `split -b 500k test.tar.gz`
`-l, --lines=line` | 将文件每 line 行切分为的小文件 | `split -l 5000 test.sql`
`-d, --numeric-suffixes` | 添加数字后缀，默认添加的是字母后缀 |`split -l 5000 -d test.sql`
`-a, --suffix-length=N` | 输出文件后缀长度，默认为：2 | `split -l 5000 -d -a 3 test.sql`
`--verbose` | 显示文件的切分过程 | `split --verbose -l 5000 test.sql`

## 实战

```sh
# 测试文件，模拟 SQL 查出 id 导出到了 test.sql 文本
$ cat test.txt
1
2
3
4
5
6
7
8
9
10
11
12

# 按照每 5 行拆分为 1 个文件，前缀为 example_，以数字后缀，后缀长度为 3 
$ split --verbose -l 5 -d -a 3 test.txt example_
creating file 'example_000'
creating file 'example_001'
creating file 'example_002'

# 替换每个小文件中的换行符
$ ls example_* | xargs -I {} sed -i ':label;N;s/\n/,/;t label' {}
$ cat example_*
1,2,3,4,5
6,7,8,9,10
11,12

# 组装 SQL：DELETE FROM table_name WHERE condition;
$ ls example_* | xargs -I {} sed -i 's/^\(.*\)$/DELETE FROM table_name WHERE id IN\(\1\);/g' {}
$ cat example_*
DELETE FROM table_name WHERE id IN(1,2,3,4,5);
DELETE FROM table_name WHERE id IN(6,7,8,9,10);
DELETE FROM table_name WHERE id IN(11,12);

# 合并 SQL
$ cat example_00* > del.sql
$ cat del.sql
DELETE FROM table_name WHERE id IN(1,2,3,4,5);
DELETE FROM table_name WHERE id IN(6,7,8,9,10);
DELETE FROM table_name WHERE id IN(11,12);
```

- [sed 命令替换换行符](https://my.oschina.net/shelllife/blog/118337)
- [delete 会不会锁表?](https://blog.csdn.net/weixin_39939530/article/details/110506783)
- [How to delete lots of rows from a MySQL database without indefinite locking](https://www.bram.us/2021/01/14/how-to-delete-lots-of-rows-from-a-mysql-database-without-indefinite-locking/)
- [How to safely delete records in massive tables on AWS using Laravel](https://flareapp.io/blog/7-how-to-safely-delete-records-in-massive-tables-on-aws-using-laravel)