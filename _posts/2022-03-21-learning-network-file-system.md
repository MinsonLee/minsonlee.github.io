---
layout: post
title: "Linux 网络共享存储学习记录"
date: 2022-03-21
tags: [NFS, SSHFS]
---

对于 Linux 系统来说，远程挂载就相当于“移动硬盘”，我们经常会用：NFS、rsync、SMB、sshfs 这些方式来进行网络文件共享（Docker 或 Vagrant 还有 unionfs 、 vboxfs 等挂载方式）。

这篇文章是为了汇总（逐渐记录）对这些网络共享存储方式的学习。

## NFS 共享存储

NFS（Network File System-网络文件系统）主要功能是：通过 TCP/IP 方式，通过 RPC 服务调用让不同的主机系统之间可以共享文件或目录（企业集群架构中，还有更复杂的分布式文件系统：FastDFS，glusterfs，HDFS）。

### NFS 挂载交互过程

1. 用户进程访问 NFS 客户端，使用不同的函数对数据进行处理
2. NFS 客户端通过 TCP/IP 的方式传递给 NFS 服务端。
3. NFS 服务端接收到请求后，会先调用 portmap 进程进行端口映射。
4. nfsd 进程用于判断 NFS 客户端是否拥有权限连接 NFS 服务端。
5. Rpc.mount 进程判断客户端是否有对应的权限进行验证。
6. idmap 进程实现用户映射和压缩
7. 最后 NFS 服务端会将对应请求的函数转换为本地能识别的命令，传递至内核，由内核驱动硬件。

### nfs 安装与使用

#### 安装

```sh
# Ubuntu/Debian
apt show nfs-common # 检查是否已经安装
ll /usr/sbin/showmount # 检查是否已经安装
sudo apt-get install -y nfs-common # 安装 nfs clent（已经包含了 rpcbind 依赖）
sudo apt -y install nfs-kernel-server # 安装 nfs server（已经包含了 rpcbind 依赖）

# RedHat/CentOS
rpm -ql nfs-utils # 检查是否已经安装
ll /usr/sbin/showmount # 检查是否已经安装
sudo yum install -y nfs-utils # 安装 nfs client && nfs server
yum -y install rpcbind # 安装 rpc 服务依赖
```

#### 配置及使用 nfs

1. 服务端（nfs-server）的几个配置文件 
    - `/etc/idmapd.conf`-用户映射管理（该文件在 Client-Server 两端是一致，**`Domain` 如果设置了，两端一定要一致**）
    - `/etc/exports`-权限配置（配置客户端网段、操作权限...，服务端配置文件）
    - `/var/lib/nfs/etab` nfs 共享目录会记录在此，该文件自动生成，若不存在则 `/etc/exports` 配置可能出错了
2. 设置开机启动：`systemctl enable rpcbind nfs-server`
3. 启动服务： `systemctl start/restart rpcbind nfs-server`
4. 客户端挂载远程目录：`sudo mount -t nfs -o nfsvers=3,fsc <remote_addr>:<remote_path> <local_path>`
5. 卸载挂载： `sudo umount -f <local_path>`



### 參考文章

- https://www.server-world.info/en/note?os=Ubuntu_20.04&p=nfs&f=1
- https://www.server-world.info/en/note?os=Ubuntu_20.04&p=nfs&f=2
- https://docs.oracle.com/cd/E24847_01/html/E22299/rfsrefer-13.html
- https://mp.weixin.qq.com/s/XMY0-PMGiDwocgBhxIH1XA
- https://mp.weixin.qq.com/s/VSv9ohQT6XnwZ3w2govzvg
- [关于NFSv4服务共享目录里的文件UID和GID显示为nobody的解决方法](https://blog.51cto.com/sunwangbackup/1953303)
- [Ubuntu - nfsv4 用户映射](https://www.qedev.com/linux/201413.html)

## SSHFS 远程挂载目录

### Ubuntu 使用 sshfs 挂载共享

```shell
# Ubuntu 检查是否已经安装 sshfs 
apt show sshfs

#Ubuntu 安装 sshfs
apt -y install sshfs

# 挂载：需要密码或密钥进行验证
sshfs node01.srv.world:/home/ubuntu/work ~/sshmnt

# 卸载
fusermount -u ~/sshmnt
# 或者
umount ~/sshmnt
```

### CentOS 使用 sshfs 挂载共享

```
# 检查当前系统是否已经安装 sshfs
rpm -ql fuse-sshfs

# 安装 sshfs（需要安装 fuse-sshfs 包）
yum -y install fuse-sshfs

# 挂载：需要密码或密钥进行验证
sshfs node01.srv.world:/home/ubuntu/work ~/sshmnt

# 卸载
fusermount -u ~/sshmnt
# 或者
umount ~/sshmnt
```

### SSHFS 的优缺点

- **优点** ：相比于 NFS，sshfs 基于 SSH 方式实现远程文件夹的挂载，这种挂载的文件系统是 fuse 虚拟文件系统的一种实现，其更轻量简洁，使用也更加简单。
- **缺点：sshfs 只能挂载远程目录，像普通文件、块设备(如/dev/sda2)等无法挂载**。

「NFS 比 sshfs 要完整的多，nfs 属于【小型】**分布式文件系统**，对**数据的一致性、完整性实现的都比较完美，访问权限控制**也比sshfs要丰富的多」

### SSHFS 总结 && FAQ

sshfs 适合**个人临时**用来快速访问操作远程文件夹，对于协同操作方面，其功能丰富性上是不足的。

- `sshfs` 取消挂载：`fusermount: failed to unmount /mount/point: Device or resource busy`

```sh
fusermount -zu /mount/point
sudo umount -l /mount/point
```

### 参考文章

- https://www.server-world.info/en/note?os=Ubuntu_20.04&p=ssh&f=8
- https://www.junmajinlong.com/linux/sshfs/
- https://tianws.github.io/skill/2018/11/14/remote-filesystem/