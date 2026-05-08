# Linux 包管理器-yum、apt、apk

[TOC]

-  清华大学开源软件镜像站 https://mirrors.tuna.tsinghua.edu.cn/help

## yum

配置 yum 加速

```shell
# 先备份一下原来的镜像文件
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

# 下载阿里云的镜像
curl -o /etc/yum.repos.d/CentOS-Base.repo -LO "http://mirrors.aliyun.com/repo/Centos-8.repo"
curl -o /etc/yum.repos.d/CentOS-Epel.repo  -LO "http://mirrors.aliyun.com/repo/epel-7.repo"

# 清理重新生成缓存
yum clean all //清理yum缓存，使设置生效
yum makecache //将服务器上的软件包信息缓存到本地,以提高搜索安装软件的速度
yum -y update	//更新本地yum

# 安装 wget 进行测试
yum install -y wget
```

## apt-get

> Ubuntu 的官方镜像源在国外，因此使用 `apt-get` 拉取安装包信息时，会比较慢，可以将系统的默认源改为国内的镜像源

- 不同版本其`Codename`不同（`lsb_release -a`），对应的源地址不同，详见：https://developer.aliyun.com/mirror/ubuntu

1. 备份原有镜像源配置
```sh
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
```
2. 替换镜像源为国内阿里云的镜像云
```sh
# 通过 VIM 打开 `source.list` 文件
sudo vim /etc/apt/sources.list

# 依次在 VIM 非输入状态下(按 ESC )，输入下方两条命令进行正则批量替换
:%s/security.ubuntu/mirrors.aliyun/g

:%s/archive.ubuntu/mirrors.aliyun/g
```
或直接copy下列覆盖
```
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
```

3. 更新镜像包缓存&&升级当前程序版本
```sh
# 更新镜像源
sudo apt update 
# 查看可更新的软件包
apt list --upgradable
# 升级更新
sudo apt upgrade
```

4. 安装 python3、python-pip 包
```sh
$ apt-get install -y python3
$ apt-get install -y python3-pip
```

```sh
# 更新 pip
$ pip3 install --upgrade pip
# 或
$ python3 -m pip install --upgrade pip
```


``