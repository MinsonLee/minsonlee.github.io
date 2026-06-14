---
layout: post
title: "Vagrant搭建Jekyll无法访问小记"
date: 2018-06-05
tag: "网络"
---

## 背景
> 使用Vagrant搭建了Jekyll的服务,在虚拟机中使用`jekyll server`启动服务,在本地浏览器访问`127.0.0.1:4000`,抛出以下错误

![Can't access this site](/images/article/internet/can-not-access-this-site.png)

## 解决方法
1. 设置虚拟机代理端口`4000`
![虚拟机4000端口转发](/images/article/internet/4000-port-forwarding.png)

2. 启动服务的时候将`Jekyll`代理到回环地址`0.0.0.0`
```sh
# jekyll server --host 0.0.0.0
```