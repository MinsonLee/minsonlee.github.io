---
layout: post
title: "05.三张图了解Git工作原理"
date: 2018-04-28
tag: Git
---

## 背景
> 这一章会着重介绍Git的工作原理,建议刚学Git的朋友可以`浏览`一遍,没明白没关系,知道个概念会更加便于日后对Git的使用和学习.先应用驱动的学习和使用,等需要和要了解原理的时候再回来细究...额(⊙o⊙)…装逼装不下去了.

## 大纲
- 通过一张图,告诉你Git的整个流程走下来涉及到的几个"区":`远程仓库-->工作区——>暂存区——>本地仓库——>远程仓库`,并让你知道这几个区之间是怎么`沟通联系`的
- 通过一张图,告诉你Git在你本地操作到底是如何变化的?这些变化被记录在什么地方?
- 通过一张图告诉你本地资料在Git运作流程的生命周期是如何的?从创建到最终被Git记录到仓库中

> 建议:随便安装个工具,去Github上随便克隆一个项目下来,然后用这个图形化界面工具打开,结合图片、目录、工具图形界面一起看会更容易理解

**帮助命令:在看图解的过程中,你可能需要用到的命令**
- 查看一个提交节点到底包含了那些东西
```sh
$ git cat-file -p SHA-1哈希值 # Git的CommitID && 分支标识 && 目录结构 && 文件内容 ... 都是一个SHA-1哈希值
```
![什么是Git的CommitID](/images/article/git/sha-1.png)

- 查看一个Blob对象(二进制文件)的内容
```
$ git show Blob的SHA-1哈希值
```
## `Git`是一套"内容寻址 (content-addressable) "文件系统
![Git是一套"内容寻址 (content-addressable) "文件系统](https://img.mubu.com/document_image/76245223-3942-44fd-85f4-79aa9cf50dec-747865.jpg)

## **一切都是`引用`:**
> Git分支(本地、远程)、标签、HEAD、暂存区(index)、储藏(stash)、对象(tree/blob/commit/tag)的存储……这些都是引用,它们都是一串SHA-1加密后得到的哈希字符串

![Git Every thing is SHA-1 string](https://img.mubu.com/document_image/2fae69d7-d9c4-4dd7-874b-13a9571fb24e-747865.jpg)

## Git中一份文件的生命周期
![Git life cycle](https://img.mubu.com/document_image/bf250bc8-110e-4660-a0fd-85dbfb4c356b-747865.jpg)

 **推荐阅读**
 - [Git 内部原理 - 底层命令和高层命令](https://git-scm.com/book/zh/v2/Git-内部原理-底层命令和高层命令)
 - [Git 内部原理 - Git 对象](https://git-scm.com/book/zh/v2/Git-内部原理-Git-对象)
 - [Git 内部原理 - Git 引用](https://git-scm.com/book/zh/v2/Git-内部原理-Git-引用)