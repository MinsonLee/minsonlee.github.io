---
layout: post
title: "08.Git分支-分支游离"
date: 2018-09-08
tag: Git
---

## 什么是分支游离?为什么?
>在说分支游离之前,先来说一个生活中场景！

现实生活中,我们每个人都有`身份证`和`名字`【因为Git在命名的时候就确保了不能同名,所以这里我们也假设不会有同名的人出现】。法律上是没有限制一个人取很多个名字的,但是一个人在一个国家里却有且只能对应一个身份证号！试想一下：在一场很大的活动中，在场每个人都取了很多个名字的时候(但没有重复人名存在),你依然是可以通过名字很顺利的找到一个人的身份证号的,但是如果你直接念身份证号来确定这个人是可以的,但是却不能确定他当前正在使用的名字是那个!所以我们在拜访别人的时候,都是自保家门姓名的,而没人会自报身份证号的!同样：Git也不会做这么傻的事,因此你可以通过`分支名`来进行相互切换,但是却不能直接通过HASH字串来进行切换！

但正如前面文章所说的一样,`Git`的分支、提交、Tag、远程分支等在本质上都是一样的--都是一串SHA-1加密后得到的哈希字符串【`Git`是一套"内容寻址 (content-addressable) "文件系统】。我们工作的时候都是在各自的分支行上进行工作的,分支其的本质就是一个有`名字`的HASH字串，所以我们切换分支"本质"上与切换至对应的HASH节点上一样的,只是你要每个人去记一串32位长的字符串进行切换显示是不合理的而已！

如果你非要如此不合理的去做,那么这个时候Git就会将你孤立为`异类`,并通知你:你处于一个独立的HEAD状态！如果你要让Git将你当成同类,那么你就只能乖乖的`注册一个用户名--分支名`

**正确的分支状态** 

![show the index by git status](/images/article/git/correct_branch_status.png)

**游离的分支状态**

![you are in 'detached HEAD' state](/images/article/git/detached_HEAD_state.png)


## 什么时候会产生分支游离呢?
> 只要是切换分支的时候没有使用你`当前本地`的`分支名`进行切换,都会产生分支游离(也有人将其称作HEAD指针游离)的状况

- 直接使用指定的commitID进行切换
```sh
$ git checkout fb564768be694dd112431b5a5114a4c70997b871
```

- 直接使用指定的tag进行切换
> tag是在Git中被命名了的一个特殊标记节点,是不会变动的。而分支如[07.Git操作-分支]()第6点所讲的一样：分支是一个`命了名称的变动HASH字串`。所以Tag只能相当于现实生活中被打上了人生污点的有名字的人一样,只能算是Git公民,却不能像`分支`一样作为Git人民存在

```sh
git check Tag_name
```

- 直接指定不在本地的远程分支名进行切换
> 虽然说Git是分布式的,但是其能够直接管辖范围也还是在本地工作区,但变更的记录是记录在本地的!就像张三在A村当村长,他可以在A村肆意妄为,但是跑到B村了也就硬不起来了,毕竟强龙压不过地头蛇!就算在B村做了什么违法犯罪的事,清算起罪状来的时候，还是到A村的头上来

```
$ git check origin/master
```

## 产生了分支游离,并在该游离状态下做出了一系列变更该如何解决?
1. 以当前节点为基准创建一条分支
```sh
# 只要你基于节点创建了分支名,这个时候你就可以像操作任何正常分支一样进行你要的操作了
$ git branch temp [HEAD 或 最后的节点号 fb564768b]
```

2. 切换至分支
```sh
# 只要你基于节点创建了分支名,这个时候你就可以像操作任何正常分支一样进行你要的操作了
$ git checkout temp
```

3. 进行操作分支合并
```sh
# 合并操作
$ git merge temp
```