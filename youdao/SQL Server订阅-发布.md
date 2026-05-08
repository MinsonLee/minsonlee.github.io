## 前置工作

**注意：前置工作需要在发布-订阅的机子上都进行配置**

1. 确认SQL Server主机名、网络主机名一致

```T-SQL
use master
go
select @@servername
select serverproperty('servername')

# 或直接执行下面这条命令
sp_helpserver
```

![image](AC69C1DB4D57465C907AFC7C1BB4FC04)

> 若不一致，需要修改属性将两者设置为一致，[点击查看方法](https://dotblogs.com.tw/mis2000lab/2011/08/10/32842)

2. 开启`SQL Server代理(MSSQLSERVER)`服务，设置登录信息
> 注意：需要设置为系统用户，此处直接用`Administrator`。
> 否则走推送订阅的方式订阅服务器的`SQL Server代理`会报错：由于操作系统错误 5，进程无法读取文件"xxxx"

![image](36E02C17EF644C6E9D960F68213A4282)

3. 配置订阅-发布机器`IP-network_name`到`C:\Windows\System32\drivers\etc\hosts`文件中
> 此处的`network_name`即步骤1截图中的`network_name`

```txt
10.10.0.229 MASTER-YZJGXH25
10.10.0.247 ECS-C170
10.10.0.70 ECS-FEFE
```

注意：发布的主机需要将自己的 `network_name` 配置到自己的 `hosts` 中，否则订阅主机的快照位置填写的



## 数据校验
1. 确认表是否有主键

```T-SQL
use BodyCheck
Go
exec  sp_helpconstraint 'dbo.checkupEye'
```

