---
layout: post
title: "06.Git操作-仓库"
date: 2018-04-30
tag: Git
---

## 背景
> 如果是初学者,建议直接看本文最后一部分:[如何在本地搭建一个Git仓库服务](#),结合[廖雪峰的官网:Git教程](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)实际动手操作一番,后面的篇幅是建立你已经能基本操作Git的前提上写的!

## 克隆仓库
> 前面[三张图了解Git工作原理](/2018/04/05.git-theory)中已经画出Git的几个工作区是如何沟通联系的?在每个区的变化是如何被记录的?看了[Git基础操作](/2018/04/04.git-basic-base)也应该知道:将远程的仓库克隆到本地使用的命令是:`git clone <remote-url>`,也知道我们克隆之后最后提交的时候需要提前告诉Git你是谁?

**思考：如何为一个项目设置其他的用户?如果仓库太大,怎么部分检出历史?**
```sh
$ git clone [-o origin] [-b master] [--depth 1] -c user.name="other-user" -c user.email="other-user@email.com" git@gitlab.com:test:test.git [dir]
```

> - -o 指定远程仓库的"别名" 没有指定的情况,默认是使用`origin`的,如果你不是有很多个仓库,也不建议你改!因为这是共识
> - -b 指定克隆远程仓库的"分支" 没有指定的情况,默认是克隆`master`分支
> - --depth <num>  如果仓库太大了,提交了很多很多,你不想全部克隆下来可以指定克隆深度,只克隆最新的一次
> - -c <key=value> 如果你针对这个项目需要单独的使用其他`用户名`或者`邮箱`或`其他配置信息`可以在此指定


## 远程仓库
> 现在克隆了远程的仓库下来了,这些信息被记录在哪里呢?前面我们已经知道这些信息都会被记录到`.git`目录中.

**思考:你想知道远程仓库的信息要怎么查看呢?**
- 你可以直接到`.git/config`里面查看或设置该项目的配置信息;
- 可以到`.git/refs/remote/`里面查看所有被克隆到本地的远程仓库资料

**或**

> - 查看远程仓库信息：git remote -v 查看当前仓库所绑定的远程信息详细信息【fetch pull】
> - 获取远程仓库URL:git remote get-url <remote>
> - 添加远程仓库：git remote add <remote_name> <remote url>
> - 重命名远程仓库：git remote rename <old> <new>
> - 修改远程仓库URL:git remote set-url <remote_name> <new_url>
> - 删除远程仓库： git remote remove <remote_name>


## 本地仓库

### 本地仓库和远程仓库交互
- 推送当前分支到远程并设置默认追踪：git push -u <remote> <local_branch>:<remote_branch>
- 拉取本地仓库所有分支的最新远程信息：git pull --all
- 拉取本地仓库所有分支的最新远程信息并清除本地无效的远程分支：git pull -p --all

### 查看本地当前分支与远程分支相差的log信息
> 如果你提交前想知道自己的分支相对远程分支到底相差了那些提交可用以下方式查看

```sh
$ git log <remote/branch>..<branch>
```

## 如何在本地搭建一个Git仓库服务
> Git本来就是分布式的版本控制系统,所以你可以在`本地`模拟一个远程仓库来操作以上和以后的交互操作


**创建一个裸仓库**
```sh
$ mkdir -p /git/server && cd /git/server

$ git init --bare test.git # 你会看到生成了一个`test.git`的文件夹,其结构和`.git`一样
```

**现在test.git是没有分支的,只是一个`仓库`,现在我们要为它创建一个默认`master`分支以供别人拉取时使用**
```sh
$ mkdir -p /git/rep && cd /git/rep
$ git clone /git/server/test.git # 先将空仓库克隆到一个地方

$ touch README.md # 创建一个README.md文件
$ # 然后进行`add` `commit`操作,`commit`完成就会默认创建一个`master`分支

$ # 将现在你这个`master`分支推到裸远程仓库中
$ git push -u master:master
```
**现在就可以了,你可以在其他的地方尝试拉取一下了～**


**推荐阅读**
- [廖雪峰的官网:Git教程](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)

**如果你是刚刚学习Git,比较建议你停下实际动手操作使用一下Git,如果你使用Git时间不久,比较建议你把前面的推荐阅读都看一下,然后继续回来看一下后面的内容!!!**

转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)

扫描下方二维码，关注公众号，接收更多实时内容
![关注公众号：Leaders工作室](/images/article/WeChat/Leaders.png)