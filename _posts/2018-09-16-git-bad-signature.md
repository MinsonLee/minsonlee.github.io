---
layout: post
title: "01.Git error: bad signature and fatal: index file corrupt"
date: 2018-09-13
tags: [Git,疑难杂症]
---
## 背景
写项目写到一半,电脑突然断电了...

![what the fuck?](/images/article/git/what-the-fuck.png)

电脑上电后,急忙检查了一遍,幸好之前写的都还在...

![留下欣慰的泪水](/images/article/git/happy.png)

于是,继续笔墨横飞,写完准备提交之前习惯性的`git status`,结果...

![no fuck saying](/images/article/git/no-fuck-saying.png)

给我整个错误...一脸懵逼!

![error bad signature](/images/article/git/bad-signature-index-corrupt.png)

`git remote`等命令都可以执行,唯独`git status`命令会报错,并且使用`GitKraken`工具也打不开项目,从错误提示来看,应该是我突然断电破坏了`./git`的内部文件,上网查了一下(⊙﹏⊙)果然如此,在此简单记录!

## 解决方法
> 主要是`./git/index`索引文件被破坏了导致的

1. 删除`./git/index`
2. 重建索引文件
- 直接`git reset`重建
- `cd .git`然后`touch index`最后回到工作目录执行`git read-tree`

![git reset](/images/article/git/git-reset-error-bad-signtrue.png)


转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)

扫描下方二维码，关注公众号，接收更多实时内容
![关注公众号：Leaders工作室](/images/article/WeChat/Leaders.png)