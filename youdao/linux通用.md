# 需要知道的 Linux 小道消息

[TOC]

## 查看当前Linux系统版本、内核、系统架构信息

```sh
# 查看系统版本
cat /etc/issue
lsb_release -a # lsb_release 不一定所有系统都支持，可能需要自行安装

# 查看系统内核
uname -a
uname -r # 内核版本

# 系统发行版信息
cat /etc/os-release

# 查看 Linux 是 64位 还是 32 位
file /bin/ls

# 查看系统架构：amd64(x86_64)、arm64、arm、ppc64le、s390
# windows 系统中，通过 `systeminfo` 命令，查看 “系统类型”
dpkg --print-architecture
arch
file /lib/systemd/systemd
```

```shell
# 如何知道系统的发行版
get_distribution() {
	lsb_dist=""
	# Every system that we officially support has /etc/os-release
	if [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi
	# Returning an empty string here should be alright since the
	# case statements don't act unless you provide an actual value
	echo "$lsb_dist"
}
```

```shell
lsb_release -a
```

## CentOS各版本区别(DVD/Everything/Minimal等

- CentOS ISO：DVD是标准安装盘，一般下载这个就可以了，里面包含大量的常用软件，大部分情况下安装时无需再在线下载，体积为4G
- Minimal ISO：精简版本，包含核心组件，体积才600多MB
- Everything ISO：顾名思义，包含了所有软件组件，当然体积也庞大，高达7G。对完整版安装盘的软件进行补充，集成所有软件
- NetInstall ISO：网络安装镜像
- LiveGNOME ISO：GNOME桌面版
- LiveKDE ISO：KDE桌面版
- LiveCD ISO：光盘上运行的系统，类拟于winpe

## 查看系统 CPU、内存信息

[计算机的cup颗数、核数、线程数](https://blog.csdn.net/u010250863/article/details/79965465)

```sh
# CPU 信息
cat /proc/cpuinfo

# 物理 CPU 个数
cat /proc/cpuinfo |grep "physical id"|sort |uniq|wc -l

# 逻辑 CPU 个数
cat /proc/cpuinfo |grep "processor"|wc -l

# CPU 中的 core 个数(即：核数-单个CPU所拥有的核心数量，即单个 CPU 能同时处理的任务个数)
cat /proc/cpuinfo |grep "cores"|uniq

# 查看 CPU 的主频信息
cat /proc/cpuinfo |grep MHz|uniq

# 查看 CPU 型号
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c

# 查看CPU运行在32bit还是64bit模式
getconf LONG_BIT
```

```sh
# 查看 内存 信息
cat /proc/meminfo

# 查看内存总量
grep MemTotal /proc/meminfo

# 查看空闲内存总量
grep MemFree /proc/meminfo
```

## 查看服务端口
```
# 切换 root 用户查看
netstat -apn | grep 服务名 # 知道服务名查对应端口
lsof -i:2375 # 知道端口，查看服务
```

## 打包&&压缩&&解压

- 打包：是指将文件放到一个集合包里，但并不进行压缩 *.tar
- 压缩：将文件(一般会先将文件夹进行打包)进行体积压缩
    - gzip 是 GNU 组织开发的一个压缩程序 *.gz（打包并压缩一般指定为： *.tar.gz）
    - bzip2 是一个压缩能力比 gzip 更强的压缩程序 *.bz2（*.tar.bz2）
    - compress 也是一个压缩程序，但使用率好像不高 *.Z（*.tar.Z）

```sh
tar -zxvf ruby-2.4.1.tar.gz -C /path #解压tar.gz包到指定路径
```

- `-z` 表示当前的压缩/解压对象是一个 gzip 包（*.tar.gz）
- `-j` 表示当前的压缩/解压对象是一个 bzip2 包（*.tar.bz2）
- `-Z` 表示当前的压缩/解压对象是一个 compress 包（*.tar.Z）
- `-c` 创建一个新的 *.tar 包
- `-r` 往一个已存在的 *.tar 包中添加新文件
- `-u` 更新已存在的 *.tar 包中的文件
- `-f <filename.tar>` 指定包名
- `-tf <filename.tar>` 列出 *.tar 包中的文件
- `-x` 解压一个 *.tar 包

**注意：压缩文件和压缩包文件是不同的**
- 对于 compress 压缩文件（和 compress 压缩包文件不同），使用 `uncompress <compressFile.Z>` 解压
- 对于 gzip 压缩文件，使用 `gunzip <file.gz> -d <path/to/decompress>`
- 对于 bunzip2 压缩文件，使用 `bunzip2 <file.bz2> -d <path/to/decompress>`
- 对于 zip 压缩文件，使用 `unzip <file.zip> -d <path/to/decompress>`
- 对于 rar 压缩文件，需要使用 `unrar e <file.rar>` 解压；使用 `rar a <file.rar>` 进行压缩。（[rar/unrar 包安装](http://www.rarsoft.com/download.htm)） 


```sh
gzip xxx.gz -d /path # 解压 gz 包到指定路径
```

- [18 Tar Command Examples in Linux](https://www.tecmint.com/18-tar-command-examples-in-linux/)
- https://www.runoob.com/w3cnote/linux-tar-gz.html

## 创建文件--touch
[在 Linux 下 9 个有用的 touch 命令示例](https://juejin.im/entry/5ae99458f265da0b863610b2?utm_source=gold_browser_extension)


## set-root-password
https://sharadchhetri.com/2014/06/26/set-root-password-ubuntu-debian-linux-mint/
```sh
sudo passwd root
```

## 进程的挂起与恢复

- `ctrl+z` 可以让当前的进程挂起
- `jobs` 查看当前后台有多少个挂起的进程
- `fg [%num]` 将后台挂起的进程恢复前台继续运行
- `bg [%num]` 将后台挂起的进程恢复后台继续运行
- `ctrl+c` 彻底退出进程

## 本地与服务器之间的文件传输
- sftp：https://blog.csdn.net/qq_29291085/article/details/87797620

```sh
# 服务器上执行：https://zhuanlan.zhihu.com/p/351748960
tar -cvf test.tar /path/for/files # 将文件归档为 1 个 tar 包 (tar -tf test.tar 查看归档文件中的列表)

# 客户端上执行
sftp <user>@<ip> [-P <port>] # 建立 sftp 链接
get /remote/path/file /local/path/file # 下载文件到本地服务器
get -r /remote/path/dir /local/path/dir # 下载目录到本地服务器指定目录
put /local/path/dir_or_file /remote/path/dir 上传本地文件或目录到远程服务器指定目录下

# 输入 help 查看更多 sftp 支持的命令
```

- scp：https://www.linuxcool.com/scp


## 查看 Linux 内核日志

```shell
dmesg 看内核日志
```

## Linux 内核升级

- [Linux升级内核的正确姿势](https://blog.csdn.net/wf19930209/article/details/81879777)
- [linux系统内核版本升级](https://www.cnblogs.com/jinyuanliu/p/10368780.html)
- [升级 Ubuntu Linux 内核的几种不同方法](https://linux.cn/article-12125-1.html)
- [Linux系统内核升级](https://mp.weixin.qq.com/s/q53_slylTDrplssdvHo7rw)


## 文章推荐
- [find命令的使用](http://www.codebelief.com/article/2017/02/26-examples-of-find-command-on-linux/)
- [Linux如何查找大文件或目录总结](https://www.cnblogs.com/kerrycode/p/4391859.html)
- [聊聊 Linux"三剑客"- awk、sed、grep](https://zhuanlan.zhihu.com/p/51392253)
- [xargs 命令教程](http://www.ruanyifeng.com/blog/2019/08/xargs-tutorial.html)
- [linux 管道](https://wiki.jikexueyuan.com/project/learn-linux-step-by-step/pipe-command.html)
- [流、管道和重定向](https://blog.csdn.net/u013710265/article/details/78007665)
- [Shell重定向 ＆>file、2>&1、1>&2 、/dev/null的区别](https://blog.csdn.net/u011630575/article/details/52151995)


## 服务器分割

多种方案：
- 1）安装linux系统，里面安装kvm或者vmware workstation
- 2）安装win，里面安装vmware workstation
- 3）直接安装vmware esxi
- 4）直接安装Proxmox VE 、vsphere
    - https://blog.whsir.com/post-5557.html
    - https://blog.whsir.com/post-5578.html
    - https://cloud.tencent.com/developer/article/1720429
    - https://blog.csdn.net/c13257595138/article/details/90385433
- 5）zstack ？？
- 6）devstack ？？
- 7）openstack ？？

## Linux 磁盘管理

- [fdisk 进行磁盘分区、删除](https://blog.csdn.net/wangzengdi/article/details/28109907)
- [linux下如何进行磁盘分区、格式化、挂载](https://www.php.cn/linux-460076.html)
- [linux系统下添加新硬盘、分区及挂载全过程详解](https://zhuanlan.zhihu.com/p/117651379)
- [【Linux】使用du、df 和 sort 命令快速找出Linux系统中的大文件 - 个人文章 - SegmentFault 思否](https://segmentfault.com/a/1190000017014841)
- [【Linux】使用du、df 和 sort 命令快速找出Linux系统中的大文件_媛测的博客-CSDN博客](https://blog.csdn.net/lijing742180/article/details/84112649)


## 特殊的 Linux 设备文件
- [/dev/zero - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki//dev/zero)


## `ls` 命令备忘录

- [看看技术大佬是如何把ls命令玩出花来](https://mp.weixin.qq.com/s/vOX_qpTzGwN9_jv2i7XjyA)

### 只查看文件夹

`ls -d /path/*/`