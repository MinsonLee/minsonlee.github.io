## 备份检查
1. 检验数据库恢复模式：右键》属性》选项》恢复模式(必须是完整) ==> 只有如此才可进行事务日志备份

## 备份操作

> - 顺序：完备-->差异备份-->事务日志
> - 自动备份计划：管理》维护计划》右键“新建维护计划”》备份计划》清除维护任务(保留一周)
> - 手动执行计划：SQL Server代理》

1. 完整备份(.bak)：右键》任务》备份》备份类型(选择完整)==>一周一次
2. 事务日志备份(.trn)：右键》任务》备份》备份类型(选择事务日志)==>一般0.5-1h备份一次
3. 差异备份(.bak)：右键》任务》备份》备份类型(选择差异)==>一天一次

## 宕机情况下备份与还原
1. 设置生产库为单用户模式：右键“属性”》选项》状态》限制访问（SIGNLE_USER）

```T-SQL
# 获取所有数据库名称
Select Name FROM Master.dbo.SysDatabases orDER BY Name

# 数据库访问模式修改为：SIGNLE_USER
USE [master]
GO
ALTER DATABASE [BodyCheck] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [CHIS] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [depm] SET  SINGLE_USER WITH NO_WAIT;
GO


USE [master]
GO
ALTER DATABASE [doc] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [EhcSms] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [HCRM2] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [HealthCase] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [HealthCase_2] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [HIS30] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [Inter] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [MPI] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [physique_cis] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [ReportServer] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

USE [master]
GO
ALTER DATABASE [ReportServerTempDB] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [RHIN] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [rhipmidphs] SET  SINGLE_USER WITH NO_WAIT;
GO

USE [master]
GO
ALTER DATABASE [whp] SET  SINGLE_USER WITH NO_WAIT;
GO
```
- BodyCheck
- CHIS
- depm
- doc
- EhcSms
- HCRM2
- HealthCase
- HealthCase_2
- HIS30
- Inter
- MPI
- physique_cis
- ReportServer
- ReportServerTempDB
- RHIN
- rhipmidphs
- whp

2. 进行全备操作（勾选：常规》仅复制备份）
3. 进行尾部事务日志备份

> 注意：需要勾选“选项”中几个选项点
> - 可靠性：完成后验证备份、写入日志前检查校验和
> - 事务日志：备份日志尾部，并使数据库处于还原状态
> - 压缩：压缩备份

4. 新建一个数据库，依次进行还原：右键“任务”》还原》数据库【如果宕机一般还原时会勾选“选项》还原选项》覆盖现有数据库(With Peplace)”】
5. 还原访问模式：右键“属性”》选项》状态》限制访问（MULTI_USER） 

```T-SQL
USE [master]
GO
ALTER DATABASE [BodyCheck] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [CHIS] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [depm] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [doc] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [EhcSms] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [HCRM2] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [HealthCase] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [HealthCase_2] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [HIS30] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [Inter] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [model] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [MPI] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [physique_cis] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [ReportServer] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [ReportServerTempDB] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [RHIN] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [rhipmidphs] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [master]
GO
ALTER DATABASE [whp] SET  MULTI_USER WITH ROLLBACK IMMEDIATE;
GO
```


自动还原数据库
```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='BodyCheck';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\BodyCheck_backup_2020_11_29.bak';

-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='BodyCheck';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\BodyCheck_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='CHIS';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\CHIS_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='depm';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\depm_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='doc';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\doc_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='EhcSms';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\EhcSms_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='HCRM2';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\HCRM2_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='HealthCase';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\HealthCase_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='HealthCase_2';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\HealthCase_2_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='HIS30';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\HIS30_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='Inter';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\Inter_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='MPI';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\MPI_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='physique_cis';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\physique_cis_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='ReportServer';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\ReportServer_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='ReportServerTempDB';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\ReportServerTempDB_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='RHIN';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\RHIN_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='rhipmidphs';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\rhipmidphs_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

```T-SQL
use [master]
Go
-- 设置变量
declare @dbName nvarchar(max)='whp';
declare @dbFullName nvarchar(max)='E:\db\SQLBackup\whp_backup_2020_11_29.bak';
-- 将数据库改为单用户链接模式
exec(N'ALTER DATABASE '+@dbName+' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');

-- 结束其余数据库连接进程
DECLARE @kid varchar(max) SET @kid='' 
SELECT @kid=@kid+'KILL '+CAST(spid as Varchar(10))  FROM master..sysprocesses WHERE dbid=DB_ID(@dbName);
exec(@kid);

-- 执行还原
restore database @dbName from  disk=@dbFullName with replace;

-- 将数据库恢复多用户连接模式
exec(N'ALTER DATABASE '+@dbName+' SET MULTI_USER WITH ROLLBACK IMMEDIATE');
```

## 更改SQL Server数据库名
1. 修改数据库名
```SQL
sp_dboption '旧数据库名称','single user','true'   
EXEC sp_renamedb '旧数据库名称','kaiya'
EXEC sp_dboption '新数据库名称','single user','false'  
数据库备份计划-每周

1. 周一至周六差异备份
2. 周日全量备份
3. 周日全量备份后进行数据清理，保留两周数据
```


## 20201114-问题
1. 【已解决：已改装与生产机器系统一致】Windows Server 2016缺少`.Net Framwork 3.5` 扩展包
2. 【已解决】Windows Server 2008 缺少虚拟光驱驱动，挂载不了 SQLServer ISO镜像
3. 【已解决60%】备份日志丢失4个库：HealthCase ...【磁盘空间不足，缺HealthCase库无法备份】
4. 【需购买】读写分离缺少Moebius for SQL Server软件及其授权




5. 数据库压测工具-需提供数据库服务IP、端口、用户、密码等信息：SQLQueryStress
