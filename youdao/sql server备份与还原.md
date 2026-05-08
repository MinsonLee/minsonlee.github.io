

## 发布订阅
> https://my.oschina.net/u/4364052/blog/3235442

- 发布机器：10.10.0.70:1433（别名/serverName：ECS-FEFE）
- 订阅机器：14.116.199.139（10.10.0.229）:1433（别名/serverName：MASTER-YZJGXH25）【主】
- 订阅机器(发)：14.18.112.251（10.10.0.247）:1433（别名/serverName（ECS-C170）

```text
http://10.10.0.66  yunwei   34270513@yw
网盘资源：\\172.17.67.56\ctyunBackup   fzzdzx 34270513@hzq
14.116.199.139（10.10.0.229）administrator Bj78dFLi23@lx
14.18.112.251（10.10.0.247）administrator Bj78dFLi23@lx
fzzdzx 34270513@hzq
jetsun
```


### 步骤

#### 检查服务名称

```tl-sql
use master
go
select @@servername
select serverproperty('servername')
```
两者结果应当是一致！

检查确认结果
```tl-sql
sp_helpserver
```

#### 配置服务名称登录
数据库发布和订阅,不能用ip登陆,必须用服务名登陆！

其中一个方法是使用改服务器的登录名称!

##### 发布机中配置订阅机的登录别称
1. 登录到发布机，打开`SQL Server配置管理器`》`SQL Native Client 10.0配置(32位)`》新增别名》填写对应的别名、IP、端口
2. 在发布机添加`IP-ServerName`映射关系到`c:\windows\system32\drivers\etc\hosts`中

##### 订阅机中配置发布机的登录别称
1. 分别登录到登录机，打开`SQL Server配置管理器`》`SQL Native Client 10.0配置(32位)`》新增别名》填写对应的别名、IP、端口
2. 在订阅机添加`IP-ServerName`映射关系到`c:\windows\system32\drivers\etc\hosts`中



### 可能遇到问题
 1. 两台主机的 1433端口互相不通
 2. SqlServer Agent 代理或SQLServer Browser服务没有开启
 3. SQL Server网络配置(32位)》MSSQLSERVER 的协议》Named Pipes没有启用
 4. 没有配置 hosts 文件中的ip和主机名映射
 5. ReplData文件夹权限不足
 6. 发布订阅前没有进行完整备份
 7. 发布-订阅的表必须依赖主键列
 

## 订阅发布情况记录-库
- 【OK】BodyCheck【事务备份】
- 【OK】EhcSms【快照】
- 【OK】CHIS【部分表没有主键】【快照】
- 【OK】depm【部分表没有主键】
- 【失败】doc：该库下所有表皆丢失主键列【快照】
- 【OK】rhipmidphs【存在部分表没有主键】
- 【OK】HCRM2【部分表没有主键】
- 【OK】HealthCase【部分表没有主键】
- 【OK】HealthCase_2【部分表没有主键】
- 【失败】HIS30：【部分表没有主键】
- 【OK】MPI【部分表没有主键】
- 【OK】physique_cis【部分表没有主键】
- 【OK】RHIN【部分表没有主键】
- 【OK】whp【部分表没有主键】
- 【失败】Inter【部分表没有主键】
- 【ok】ReportServer
- 【ok】ReportServerTempDB
- 





## 语句
- 查看所有databases：Select Name FROM Master.dbo.SysDatabases orDER BY Name
- 查看表记录行数：select  a.name as '表名',b.rows as '表数据行数' from sysobjects a inner join sysindexes b on a.id = b.id where   a.type = 'u' and b.indid in (0,1) order by b.rows desc




![image](CAF36828C8CE433C9DC3D45181EF7787)


SELECT TOP 1000 [QueryContextId]
      ,[Identity]
  FROM [HealthCase].[data].[QueryContextIdentity]
  
  

## 问题

- https://www.cnblogs.com/TeyGao/p/3521109.html

```T-SQL
# 进程无法在“xxxx”上执行“sp_replcmds”
USE whp
GO
sp_changedbowner 'sa'
```

- 无法删除发布：https://blog.csdn.net/huyu107/article/details/51098462

```T-SQL
EXEC sp_removedbreplication 'DatabaseName';
```

![image](5D50309231F649FDB06B06E4B85B54C6)

- 出现操作系统错误 3，进程无法读取文件“xxxx.pre” 系统找不到指定的路径
- 出现操作系统错误 5，进程无法读取文件“xxxx.pre” 拒绝访问。
- 出现操作系统错误 53，进程无法读取文件“xxxx.pre” 拒绝访问。找不到网络路径。
![image](251144185AA741869FC9972BD88B7040)
> 更高发布属性》快照》快照文件位置
![image](D70CB6504CD6456EA8C20935F62DB633)



- 出现操作系统错误 1326，进程无法读取文件“xxxx.pre” 登录失败: 未知的用户名或错误密码

![image](190EC4A557654D10B4B074ED874735A2)

> - https://blog.csdn.net/LUOCHENLONG/article/details/88956413
> - https://blog.csdn.net/chenchen2360060/article/details/99687355
> - http://blog.itpub.net/31559985/viewspace-2673441/

![image](0D37D1E217634219863669EB5769C81A)

![image](914CCBF87F2E40EA81E8B2879A2B84EF)
![image](FEBAF78E40E046BFBB5EAC0E9D1B19D5)

## 验证数据库



```T-SQL
# 数据库访问模式修改为：SIGNLE_USER
USE [master]
GO
ALTER DATABASE [CHIS] SET  MULTI_USER WITH ROLLBACK IMMEDIATE
GO

# 修改数据库用户连接属性为多用户连接
USE [master]
GO
ALTER DATABASE [CHIS] SET  MULTI_USER WITH ROLLBACK IMMEDIATE
GO
```

```t-sql
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [RID]
      ,[地市]
      ,[区县]
      ,[姓名]
      ,[性别]
      ,[身份证件类别名称]
      ,[身份证号码]
      ,[居民健康档案编码是否全国统一]
      ,[户籍住址]
      ,[现住址]
      ,[联系电话]
      ,[患病情况]
      ,[签约家庭医生]
      ,[建档单位名称]
      ,[建档日期]
      ,[建档人]
      ,[档案状态电子和纸质电子纸质]
      ,[业务数据产生时间]
      ,[TODATE建档日期]
  FROM [doc].[dbo].[haizhu_jkxx]
  where RID = 'AAA+f1AAXAADgv5AAM'
  
  
  
  UPDATE [doc].[dbo].[haizhu_jkxx]
   SET 
      [性别] = '女'
  where RID = 'AAA+f1AAXAADgv5AAM'
GO

```

![image](8F19582E69CA4EC1942A4228E70325C5)
![image](F4C33617C65D4069A66170855D1FBD65)


- 值不能为空
- 无法读取此系统上以前注册的服务器列表
![image](5F89C25203064421ADEB36706333396C)
![image](79F956FD83AE476094963547143CE663)

> - 去`C:\Users\用户名\AppData\Local\Temp`将数字文件（如：1、2、3...，注意是“文件”，不是文件夹）删除，然后新建对应的文件夹命名为对应的数字
> https://blog.csdn.net/rosejeck/article/details/84338125


## 内存占用过大
- https://www.shuzhiduo.com/A/mo5kPZrEdw/
- https://www.imooc.com/article/27565
- https://support.huaweicloud.com/bestpractice-rds/rds_04_0008.html