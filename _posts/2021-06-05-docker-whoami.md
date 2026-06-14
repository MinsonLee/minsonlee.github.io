---
layout: post
title: "容器：我是谁？"
date: 2021-06-05
tags: [Docker]
---


![whomai](/images/article/docker-whoami/封面-whoami.jpg)

`Linux` 中我们可以使用 `whoami` 或 `id` 命令进行查询打印当前用户的信息。今天在容器的技术群里，碰到一个群友询问：如何查询自己当前在那个容器中？

![question.png](/images/article/docker-whoami/question.png)

我们都知道 `Docker` 在构建镜像时每一层镜像都有一个唯一镜像ID，同样每一个容器实例也都有其自己唯一的容器ID（叫：`CONTAINER ID`），我们可以有多种方式来确定当前自己的容器，譬如：通过容器ID、容器IP 这些唯一信息进行对比知道自己到底在那一个启动的容器中。想要获取这些信息我们可以通过 `docker inspect <container>` 的方式打印容器的详细信息。

如果你遵循的是：**一个容器仅运行一个应用服务** 的原则，也可以通过 `ps` 查看当前的服务进程知道答案。

这里说一个最简单的方式：通过对比 `hostname` 知道自己当前所在的容器。

`/etc/hosts` 会在每次容器启动的试试生成，只要不是通过挂载文件的方式进行了覆盖，那么一定会有一条记录 `<容器IP> <容器ID>` 在 `hosts` 文件中。因此我们可以通过`cat /etc/hosts` 或 `hostname` 命令得到当前容器的 HostName 信息，然后和 `docker ps` 打印的容器列表信息进行对比，操作如下：

![get-hostname](/images/article/docker-whoami/docker-whoami.png)

