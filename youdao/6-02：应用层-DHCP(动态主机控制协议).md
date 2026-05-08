[TOC]
# 应用层-DHCP(动态主机控制协议)

## DHCP 协议
- https://baike.baidu.com/item/DHCP
- https://blog.csdn.net/weixin_42155195/article/details/80683853
- https://blog.csdn.net/kkkkde/article/details/84949215
- https://blog.csdn.net/u012359618/article/details/51872678
- https://www.cnblogs.com/anorferde/p/5777552.html
- https://www.jb51.net/network/299962.html
- https://cloud.tencent.com/info/255e2f737e92e63c91a9bba6bab7205c.html
- https://mp.weixin.qq.com/s?src=11&timestamp=1560188903&ver=1660&signature=UWozToiJhSb5OsEA5vFMy3V-CNXKS*LpDW0O6OxQMZhhmUeWjm0zbOMnDhv8uqnN5gLNagdmVH5VGEm*jewnizPGEeaRcNAFSxZ2tSQvYnxDwHro2oo2Z0nNPdhbdXj7&new=1

### DHCP 分配地址流程

### DHCP 作用域
作用域是指指派给请求动态 IP 地址的计算机的 IP 地址范围。DHCP 服务器管理员必须创建并配置一个作用域之后才能指派动态 IP 地址。



## DHCP Server

### Windows 中安装/配置 DHCP Server
#### 如何安装 DHCP Server？

#### 如何配置DHCP Server？
- https://www.cnblogs.com/yutingliuyl/p/6800673.html



### Linux 中安装/配置 DHCP Server
> http://releases.ubuntu.com/18.04.2/ubuntu-18.04.2-live-server-amd64.iso?_ga=2.176190317.955879580.1560299334-288676457.1556816924
> http://mirrors.huaweicloud.com/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso


### DHCP 跨网段配置


## DHCP Client
### Windows 中如何设置自动获取 IP 地址?
- `Windows+R`【运行】 ==> 键入 `ncpa.cpl` ==> 打开 `控制面板\网络和 Internet\网络连接` ==> 右键当前连接网络设备【属性】 ==> 选中`TCP/IPv4` ==> 属性 ==> 选择`自动获取 IP 地址`

> **注意**： 如果遇到选择`自动获取 IP 地址`仍然不能自动分配获得 IP 地址信息，可以查看一下是否是本机的 DHCP Client  服务停止了。
>
>![image](6BD71D353E564FD28A6676B7C53A63E6)


### Linux 中如何设置自动获取 IP 地址？


## DHCP 安全攻防
> DHCP 过程是没有认证的，因此局域网中的 DHCP 服务器也是需要严加管控的！

- DHCP 冒充
- DHCP 欺骗
- DHCP 耗尽攻击
- https://edu.51cto.com/center/course/lesson/index?id=62552