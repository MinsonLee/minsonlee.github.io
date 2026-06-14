---
layout: post
title: "浅尝`Alpine Docker`"
date: 2020-11-19
tag: Docker
---

[`Alpine Linux`](https://alpinelinux.org/) 是一个面向安全、非常轻量级`Linux`发行版（整个操作系统镜像一共120M+）。它基于`musl libc` 和 `busybox`减小了系统的体积和运行时资源消耗。由于其安全、轻量且功能又相对完善，因此深受开源社区的喜爱。

[`Alpine Docker`](https://hub.docker.com/_/alpine) 镜像继承了 `Alpine Linux`的这些优势，相比其它 `Docker` 基础镜像（如 `CentOS`、`Fedora`、`Ubuntu`、`Debian`），它仅仅只有 `5M`。因此使用`Alpine`做出来的容器镜像有以下优点：
- 镜像体积更小-下载速度快、易传播
- 镜像安全性更高-`Alpine`只继承了`Linux`的必要内核信息
- 容器与宿主机间的切换更方便、容器占用更少宿主机的磁盘空间

## `Alpine`源加速
`Alpine`的包管理工具是`apk`，可以通过 [`https://pkgs.alpinelinux.org/packages `](https://pkgs.alpinelinux.org/packages ) 查询包信息。

由于 `Alpine` 的源服务器`http://dl-cdn.alpinelinux.org/`在国外，访问可能比较慢。下述是几个国内的源：
- [清华大学开源软件镜像站：https://mirror.tuna.tsinghua.edu.cn/alpine/](https://mirror.tuna.tsinghua.edu.cn/alpine/)
- [阿里云官方镜像站：https://mirrors.aliyun.com/alpine/](https://mirrors.aliyun.com/alpine/)
- [中国科学技术大学镜像站：http://mirrors.ustc.edu.cn/alpine/](http://mirrors.ustc.edu.cn/alpine/)

一般情况下 `Alpine` 的几个重要配置信息如下：

- 系统内核版本：`/etc/alpine-release`
- 系统位数： `/etc/apk/arch`
- 默认源地址：`/etc/apk/repositories`

```sh
# 备份源地址配置
cp /etc/apk/repositories /etc/apk/repositories.bak
# 更新镜像源
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# 更新索引并升级软件
apk --update-cache upgrade
```

> - wsl 中设置 `Alpine` 中 `root` 密码：`wsl  --user root --distribution Alpine passwd`
> - [如何将Alpine Linux 3.11升级到3.12？](https://www.a5idc.net/helpview_989.html)

## `apk`包管理

详细可阅读官方 WIKI：[Alpine Linux package management](https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management)

```sh
$ apk update # 更新本地镜像源列表索引

$ apk search # 查找所以可用软件包
$ apk search --update # 查找所以可用软件包
$ apk search -v # 查找所有可用软件包及其描述内容
$ apk search -v <package> # 通过软件包名称（可使用通配符*匹配）查找软件包
$ apk search -v -d <package> # 通过描述文件查找特定的软件包

$ apk add  <package> [<package1> ...] # 安装一个或多个软件包
$ apk add --update-cache <package>  # 不使用本地镜像源缓存，相当于先执行 apk update ，再执行 apk add <package>
$ apk add --no-cache <package>  # 不使用本地镜像源缓存且不缓存源文件，相当于先执行 apk update ，再执行 apk add <package>

$ apk info # 列出所有已安装的软件包
$ apk info -a <package> # 显示软件包详细信息
$ apk info --who-owns /sbin/lbu #显示指定文件属于的包

$ apk upgrade # 升级所有已安装软件
$ apk upgrade <package> [<package1> ...] # 升级指定本地软件

$ apk del <package> [<package1> ...]  # 删除已安装的软件包
```

一般`Alpine Docker`的容器 `Dockerfile` 都是如下：
```yaml
# Dockerfile 文件
# 指定基础镜像为最新版本的`alpine`，一般都会指定固定版本
FROM alpine:latest
# 作者介绍
MAINTAINER <name> <email>

# 1. 替换镜像源为国内镜像源
# 2. 安装指定软件包，且不更新源列表索引(缩减空间)
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk --no-cache add <package list ...>

```

如果想要使用的其他工具，`Alpine Docker`里面可以没有，需要自行使用`apk`安装才能使用。可以使用`docker run -it alpine /bin/sh`进入`Alpine Docker`进行试玩，或者在虚拟机中安装一个`Alpine Linux`系统试玩，其他命令参考[此处](https://wiki.alpinelinux.org/wiki/Alpine_Linux_Init_System)