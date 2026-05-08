- linux 网络涉及的所有配置文件详解：https://www.cnblogs.com/sbchen/p/10143762.html
- Linux下IP的配置：https://blog.51cto.com/u_15858333/5817440

## 网络信息查看

- 查看 IP 地址信息： ifconfig、ip addr
- 查看路由：`route -n` 或 `netstat -rn`
- 检查网络是否通畅： `ping xxxx`
- 检查链路情况： `tracepath xxxx` 或 `traceroute xxx`(traceroute 比 tracepath 更加的详细)
- 查看网络端口等信息： [`netstat`](https://wangchujiang.com/linux-command/c/netstat.html) 或 [`ss`](https://wangchujiang.com/linux-command/c/ss.html)
- 重启网络服务：`service network restart` 或 `systemctl restart network`
- 如何确定 IP 是动态获取还是静态获取的？ `ifconfig` 查看网卡 IP 信息，如果在 IP 的显示行看到是 `global noprefixroute` 则是静态 IP；如果是 `global dynamic` 则是动态获取

## 网络配置文件

在 Linux 中配置网络可以通过 `NetworkManager`、`system-config-network` 这些图形界面管理工具进行配置管理。但是由于 Linux 发行版众多，各个发行版提供的工具大不相同，且我们一般通过 CLI 登录操作 Linux 服务器因此也无法使用这些图形界面工具。其实这些工具都是通过操作若干个文本文件来进行配置的。这里简单的介绍和学习一下各个文件的用途：

- `/etc/sysconfig/network` 用于指定服务器上全局的网络配置信息，包括：控制和网络有关的文件和守护程序

```conf


```

- `/etc/resolv.conf`
- `/etc/sysconfig/network-scripts/ifcfg-<interfacce>`
- `/etc/services`
- `/etc/nsswitch.conf`
- `/etc/xinetd.conf`
- `/etc/host.conf`
- `/etc/hosts`

1. 网卡配置文件：`/etc/sysconfig/network-scripts/ifcfg-<interfacce>` 用于配置有线网卡信息
2. Hosts 配置文件： `/etc/hosts`
3. DNS 配置文件：[/etc/resolv.conf ](https://blog.csdn.net/lcr_happy/article/details/54867510)

`/etc/resolv.conf` 是DNS客户机配置文件，用于设置DNS服务器的IP地址及DNS域名，还包含了主机的域名搜索顺序。

如果我们这个文件没有配置正确，就会出现 ping 外网显示 `未知的名称或服务`。


### ping 外网出现  `未知的名称或服务`

1. 检查自己的 /etc/hosts 是否设置了特殊规则
2. ping 114.114.114.114 看是否能 ping 通，如果可以则证明是 DNS 的问题，检查 /etc/resolv.conf 是否设置了正确的 DNS 地址


### ping: socket: Operation not permitted

```
# 零时设置
sudo sysctl -w net.ipv4.ping_group_range="0 1000"

# 或修改 /etc/sysctl.conf
net.ipv4.ping_group_range="0 2147483647"
# 或者 
sudo chmod 4711 /bin/ping
```

- [2022-07-27 ping: socket: Operation not permitted](https://qiita.com/taro-hida/items/54436a5a9e8f8cfc34d7)
- [ping: socket: Operation not permitted](https://www.suse.com/zh-cn/support/kb/doc/?id=000020581)

## 防火墙

- Linux 对外开放端口
https://blog.csdn.net/laidanlove250/article/details/97667113