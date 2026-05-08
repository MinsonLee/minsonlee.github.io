1. `Windows`防火墙设置-开启对应端口(`TCP/1433`)

![image](E3F5BC8FB94541078F7A6B8D33F50FCE)

或

```powershell
netsh advfirewall firewall add rule name = SQLPort dir = in protocol = tcp action = allow localport = 1433 remoteip = localsubnet profile = DOMAIN
```

2. `SQL Server 2019`的`Management Studio`需要额外安装：点击"安装 SQL Server 管理工具"，在下载页下载对应语言包的安装包安装即可

![image](965C98788B3C45428251D45CBA0DB4E7)

3. `SQL Server`多实例安装

`SQL Server`的安装不同于其他数据库服务的是：可以在同一台机器上安装多个独立的实例。只要安装时实例名不同即可！

![image](3B88337505B54A87B9A7C349370A2556)