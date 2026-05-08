前面说到，前几天由于数据库有一个字段类型太小，导致数据溢出产生了线上 bug。现需将 days 字段由 tinyint(3) 类型变更为 smallint(5)。变更数据库要考虑**该操作是否会发生锁表操作？发生了锁表对当前业务是否会有致命影响？**

由于部门业务是面向全球，因此停服变更一般都不会是我们要考虑的手段，而更多需要面临的是“飞机飞行的时候换引擎”的场景，即使不能实现“飞行换引擎”也必须要将时间缩到最短。

线上服务器是 `5.6.47.0`，个人服务器的数据版本为 `8.0.23`。表行数为 130w+，表数据约 1.3G+，索引长度 650M+。

![mysql-count-table](F5BD667D1ADB4342BB373BE118D1D2F4)

为了验证该操作是否会锁表，我将线上的大表进行导出，然后在本地做一下实验。此处记录一下 MySQL 的导入/导出操作。

## 导出方法

### 1、利用 GUI 客户端

GUI 客户端（如：Navicat）使用起来非常方便，利用这个客户端将线上的大表进行导出，结果用了 3 个多小时才全部导出完毕。

![mysql use navicat dump data and struct](CD6AA93BDFCF43A489C2D470518AB50A)

![use-navicat-source-sql-file-info](6D1427C75A4E4B76A9E9842FB5861059)

该方式的优缺点很明显：操作简单、不需要依赖服务器权限、最慢。

如果数据多又紧急，可以叫运维同事帮忙导出。

**通过该方式导出来的 SQL File，其特点就是每一条记录就是一条完整独立的 INSERT 语句**。

这样的好处是：在导入时，即使中断了也不会导致整个脚本数据写入无效，需要重新导入。虽然一条一条记录的写入缺点是慢，但对于某些情况来说一条条记录进行更改这样的低效牺牲是值得的。

### 2、利用 `INTO OUTFILE`

为了验证更大的数据量，我将上述的表数据扩增到了 **297w+**记录，然后利用该方式进行导出。

```sql
SELECT * FROM data_tbl --查找数据源，如果是全表所有字段也可以用 TABLE <talbe>
INTO OUTFILE "/tmp/data.txt" --数据输出文件
FIELDS TERMINATED BY ','  --字段分隔符
OPTIONALLY ENCLOSED BY '"' --字段引用符
LINES TERMINATED BY '\n' --整条记录分割符
;
```

![mysql-select-into-outfile-use-time](E0A957124F134DBDB44C5B74DBF2FEF4)

导出的数据文件约 `3.7G`，耗时仅仅 `4.5min`，这个耗时比起使用客户端来说简直是**速度飞快**。

该方式仅仅是导出 SQL Query 的数据结果，是不含数据结构的。

![select-into-file-records](6B27232A05324E48AAB4CDF35BDCB87A)

关于 `INTO OUTFILE` 的详细用法可参考官网：`https://dev.mysql.com/doc/refman/8.0/en/select-into.html` 此处不过阐释。

注：有的文章说该方式会锁表，但我在官网的文档上没有找到对应的依据。因此自己进行了试验（参考前面的文章：[《MySQL 数据库中如何查询表是否被锁》](https://mp.weixin.qq.com/s/HTaijVK4Ys0NElpOkK6dvw)）。

![mysql-select-into-outfile-processlist](21CC24021C424908A09ABB5AA41C2D5E)

从上述截图可以看出，该操作是不会锁表的，但是系统的 CPU 会飙高，不过这是导出操作无法避免的呀。

### 3、使用 mysqldump

`mysqldump` 主要是用于数据库备份的，其功能十分强大。

```shell
# -uroot 使用 root 用户操作数据库
# -p 需要密码
# --database 指定具体的数据库
# --tables 指定具体的表（注意：如果使用了 --tables 那么 --databases 只能接一个数据库）
# --skip-comments 不导出注释
# --skip-add-locks 不导出锁表语句
$ /apps/mysql/bin/mysqldump -uroot -p --databases test --tables data_tbl --skip-comments --skip-add-locks > /tmp/dump.sql
```

使用该方式导出的文件，耗时大概是：8min+、导出的是一个 SQL 文件，且这个文件是一个 `INSERT INTO <table> VALUES (...),(...)` 的文件。

如果你既需要 SQL 文件又对速度有一定的要求，可考虑使用该方式。

由于此文不是讲述命令用法，详细的使用推荐大家看博客园一位博主-pursuer.chen 整理的文章：https://www.cnblogs.com/chenmh/p/5300370.html 或查看官方最新的文档 https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html

## 导入数据

先通过 `scp` 将压缩包上传到服务器 `/tmp` 目录，耗时大概：6m

```shell
scp /mnt/c/Users/Administrator/Desktop/sql.tar.gz root@lmscvm:/tmp
```

其实导入也分为：客户端、MySQL 自带两种方式。

### 1、利用 GUI 客户端

通过 Navicat 导入的操作，如下图。如果是大数据量极不推荐，TMD...速度极其缓慢，还直接将我电脑卡死了

![use Navicat source SQL file](98F8A33C417E49D487EA5562AD758A1F)

### 2、利用 source file

通过 [`source file.sql`](https://dev.mysql.com/doc/refman/8.0/en/reloading-sql-format-dumps.html) 方式运行

`source` 命令是用来加载通过 `mysqldump` 导出的 `sql` 备份文件，用于进行数据库恢复的。一般来说它跟的 `file.sql` 文件是已经包含了 `create database <db>` 和 `use <db>` 的操作。

但这里我们可以通过手动先 `create database <db>` 和 `use <db>`，然后再通过下方的语句进行数据导入恢复

 ```sql
 source /tmp/sql.sql
 ```

### 3、利用 mysql 命令

`mysql` 命令也是用来加载通过 `mysqldump` 导出的 `sql` 备份文件的 Shell 命令。

如果 dump.sql 中含有 `create database` 和 `create table` 等这些 SQL 语句时，使用如下方式执行

```shell
$ /apps/mysql/bin/mysql < dump.sql
```

如果 dump.sql 中不包含 `create database` 和 `USE <database>` 语句时候，那么你需要先确定数据库是存在的，然后使用如下方式执行

```shell
$ /apps/mysql/bin/mysql <dbName> < dump.sql
```

**注意：**
1. `source` 和 `mysql` 不同的是：`source` 是一个 MySQL 命令，而 `mysql` 是一个 Shell 命令
2. `source` 和 `mysql` 的方式虽然也是一条条 `INSERT` 语句的执行，所以速度也较慢
3. 但这两个命令都是需要在服务器上通过 CLI 方式执行，胜在**稳定**且操作**不会长时间的锁住表**
4. 我们可以对语句进行合并通过批量插入的方式来提高写入速度

我在本机进行测试，写入速度：15分钟只导入了80w+数据，本机 WSL2 安装的数据库，300w 级数据写入花费了 5.5+ 小时

![image](736E01C643234DAB9B21897DED85C486)

详细的使用看官方文档：`https://dev.mysql.com/doc/refman/8.0/en/reloading-sql-format-dumps.html`

### 4、利用 LOAD DATA

`LOAD DATA INFILE` 和 `SELECT INTO OUTFILE` 是相互依赖的，即：如果你导出方式使用了 `SELECT INTO OUTFILE`，那么导入的时候就需要使用 `LOAD DATA INFILE` 进行导入。使用方式如下

```sql
LOAD DATA INFILE "/tmp/data.txt" --数据导入源
IGNORE INTO TABLE test.<table> --此处通过 IGNORE 修饰符允许重复记录不中断
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
;
```

**注意：该方式会==锁全表==**

![load-data-infile-into-table](4180E9B9C48B4AF1B2CDF9D48F13AA24)

## sysvar_secure_file_priv 小记

注意：`select into file` 和 `load data infile` 的方式都依赖启动服务时 `--secure-file-priv`  参数，若该参数的值不正确，则会报错。

```shell
ERROR 1290 (HY000): The MySQL server is running with the --secure-file-priv option so it cannot execute this statement
```

![mysql-load-data-infile-into-table](3F7BD117F4CE44508846CE61468C3DDB)

`--secure-file-priv` 是一个只读 mysql 服务变量，不能进行修改。需要修改 MySQL 配置文件（即：`my.cnf`或`my.conf`）后重新启动实例才会生效。

![mysqld-secure-file-priv](8D8921F78C474C688028715A454891DB)

下述表格内容翻译自：[MySQL `--secure_file_priv` 文档说明](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_secure_file_priv)


内容 | 描述
---|---
命令行格式 | `--secure-file-priv=dir_name` 用于命令行启动 mysqld 服务时的参数
系统变量 | `secure_file_priv` 用于 `select @@secure_file_priv;`
作用范围 | 全局-`show global variables like '%secure_file_priv%';`
Dynamic | 否（没懂这个是啥意思）
SET_VAR Hint Applies | 否（这个也没懂啥意思）
值类型 | String-字符串
默认值 | platform specific-不同平台不一致
有效值 | ""-空字符串<br/>"<dirname>"-详细目录<br/>NULL-空值

- **""-空字符串**：表示不限制，支持任意目录的导入导出
- **"/tmp"-详细目录**：只能在`/tmp`目录中执行导入导出
- **NULL-空值**：不允许导入或导出（我测了3台机好像 Linux 应该默认就是 NULL）

该配置的修改在 `my.cnf`或`my.conf` 的 `[mysqld]` 模块下添加或修改如下图所示一行配置，然后重启实例即可。

![secure_file_priv](1E2248B16177465AB04391FA610B6BEC)

![select @@secure_file_prv](905B3A80A1604289BF5465B1DCE3CAF3)








- MySQL 亿级数据导入导出/数据迁移笔记：https://blog.csdn.net/qq_21108311/article/details/82559119
- MySQL mysqldump数据导出详解：https://www.cnblogs.com/chenmh/p/5300370.html
- mysqldump — A Database Backup Program：https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html
- 使用命令行工具mysqlimport导入数据：https://www.cnblogs.com/shamo89/p/9925801.html