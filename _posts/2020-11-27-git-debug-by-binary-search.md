---
layout: post
title: Git工具-二分查找
date: 2020-11-27
tag: Git
---

## 背景

临时接到一个任务需要用到一位调岗同事的脚本，却发现该脚本被删掉不在仓库中了。幸好该仓库用了`VCS-Git`进行管理，可以通过找到在什么节点被删除从而恢复脚本。但由于经过了一年多的提交，中间掺杂了5K+多个提交记录。`git bisect`就在我脑子中冒了出来。

![git-log-show-how-may-commits-between-two-ids](/images/article/git/git-log-wc-l-rows-num.png)

## 二分查找

二分查找(`binary search`-又叫：折半查找)，是一种在**已知有序**阵列中搜寻某一**特殊元素**的**高效**查找算法，其时间复杂度为`O(log2n)`。

![binary search git](/images/article/binary-search.gif)

二分法的原理很简单：对有限区间进行对半拆分，确定问题是在节点的前半部分还是后半部分，然后不断的重复该过程，将问题缩小，直到确定问题。

## `Git`-启动二分查找

设置二分查找的区间，启动二分查找

```sh
git bisect start <from commitId> <end commitId>
```

![git bisect start 起点 终点](/images/article/git/demo-git-bisect-start.png)

有两点值得留意：

1. 由于`Git`的提交日志是按照时间顺序倒序排列的，此处的`from commitId`是近期提交，即：`<from commitId>`一定是在`end commitId`之后的时间提交的记录。如果两者顺序调转了会报下列的错误提醒
2. 启动二分查找、标记节点结果后，提示信息都会告诉你`roughly xx steps`大致还有多少步能确定出结果

```sh
$ git bisect start 4d83cfcbaef648345571d77db867b6f9e4146ba7 85530fd2d876544a88564c26ff1a656c3ef6ea0c

Some good revs are not ancestors of the bad rev.
git bisect cannot work properly in this case.
Maybe you mistook good and bad revs?
```

## 标记结果
```sh
git bisect [bad|new] # 标注当前节点是有问题的，向更早的记录折半查询
git bisect [good|old] # 标注当前节点是没有问题的，往后续提交的记录中折半查询
```

![git bisect pod result](/images/article/git/demo-git-bissect.png)

不断的标识结果，将区间不断缩小，直到确定问题。当区间不能再进行折半时，`Git`会打印出一个具体的提交点日志信息。

```sh
git bisect log # 查看二分查找的过程
```

![git bisect log](/images/article/git/git-bisect-log.png)

## 结束查找
```sh
git bisect reset [<commitId>] # 结束二分查找，切到指定的commit点-默认是HEAD
```

找到问题节点后，可以使用`git bisect reset`切换到对应节点，但要注意：此时的分支是处于游离状态的（即：不在任一有效分支上）。

```sh
git bisect reset <问题节点> # 切到问题节点

git checkout -b <bugfix-xxx> # 针对当前节点切换创建一个有效分支 
```

在临时有效分支上对问题进行修复，进行提交，再合并到主干分支中。

## 来一发

`GitHub`上有人提供了一个[小demo](https://github.com/bradleyboy/bisectercise)，供大家练习熟悉练习。

![git@github.com:bradleyboy/bisectercise.git](/images/article/git/demo-git-bisect-practice.png)