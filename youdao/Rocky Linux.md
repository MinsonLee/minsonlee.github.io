- 配置 Rocky Linux 镜像源加速：https://developer.aliyun.com/mirror/rockylinux

```shell
sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.aliyun.com/rockylinux|g' \
    -i.bak \
    /etc/yum.repos.d/Rocky-*.repo

dnf makecache
```

- Linux 查询 MAC 地址：https://www.howtouselinux.com/post/linux-command-get-mac-address-in-linux
    - ifconfig -a
    - ifconfig eth0
    - ip link show
    - ip -o link show eth0
    - ip -o link show |cut -d ' ' -f 2,20
    - cat /sys/class/net/*/address


- 设置静态 IP：https://www.golinuxcloud.com/set-static-ip-rocky-linux-examples/
- Linux 设置静态 IP：https://blog.csdn.net/u010521062/article/details/114067036

```sh
# vi /etc/sysconfig/network-scripts/ifcfg-<xxx>

TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static # 分配IP的方式，static-静态IP; dhcp-DHCP协议自动获取
HWADDR= xxxx # 网卡 mac 地址
DEFROUTE=yes 
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eno1
UUID=c75724a4-ae29-4ba4-a098-f6d490357d38 # 可以通过 uuidgen <网卡名> 生成
DEVICE=eno1
ONBOOT=yes # 电脑重启
IPADDR=192.168.100.149 # 静态IP地址
PREFIX=24 # 网段
GATEWAY=192.168.100.1 # 网关
DNS1=114.114.114.114 # DNS 地址，只能设置 2 个，设置多个也只有两个有用
DNS2=8.8.8.8
DOMAIN=lms.local # 主机名
```

- 中文 Rocky Linux 指南：https://docs.rockylinux.org/zh/guides/
- 设置启动时不启动 GUI：
```
[lms@local ~]$ vi /etc/inittab
[lms@local ~]$ cat /etc/inittab
# inittab is no longer used.
#
# ADDING CONFIGURATION HERE WILL HAVE NO EFFECT ON YOUR SYSTEM.
#
# Ctrl-Alt-Delete is handled by /usr/lib/systemd/system/ctrl-alt-del.target
#
# systemd uses 'targets' instead of runlevels. By default, there are two main targets:
#
# multi-user.target: analogous to runlevel 3
# graphical.target: analogous to runlevel 5
#
# To view current default target, run:
# systemctl get-default
#
# To set a default target, run:
# systemctl set-default TARGET.target

#Removed /etc/systemd/system/default.target.
#Created symlink /etc/systemd/system/default.target → /usr/lib/systemd/system/multi-user.target.
```

- [解决错误：Couldn't open file /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7](https://blog.csdn.net/nirendao/article/details/79313025)