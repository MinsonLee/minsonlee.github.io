---
layout: post
title: "15.Git分支策略"
date: 2018-09-22
tag: Git
---

## 关于工作流程
**集中式工作流【大部分公司应该都是这种方式】**

![集中式工作流](/images/article/git/centralization-branch.jpg)  
**集成管理者工作流【开源项目的协作方式，开发者自行fork仓库，然后请求管理者拉取更新】**

![集成管理者工作流](/images/article/git/integration-manager.jpg)

**司令官与副官工作流【就是在集成管理者工作流之上又加了一层管理者，适用庞大的项目=>Linux】**

![司令官与副官工作流](/images/article/git/commander-and-adjutant.jpg)

## 分支策略
### 分支名规则
> 该规则是在创建分支时，底层会执行`git check-ref format`进行强制检查

- 分支名不能以减号"-"开头【"-"是git命令选项参数的选择标识】
- 使用斜杠"/"分层的分支名不能以点"."开头
- 分支名中不能包含连续的两个点"." [连续的两个点是有特殊意义的，代表分支区间]
- 分支名中不能包含任何空格与其他空白字符、ASCII码控制字符、Git中有特殊意义的字符：~ ^ : ? * [

**我个人是比较推荐:使用斜杠`/`对分支进行分类命名，而不是全部都用feature-xxx这种方式**
![使用/分类命名](/images/article/git/category-branch.jpg)


### 为什么每个人都应该写好自己的commit信息？
> 推荐阅读:[git commit 规范指南](https://segmentfault.com/a/1190000009048911)

1. 提供更多的历史信息，方便快速浏览
2. 可以过滤某些commit（比如文档改动），便于快速查找信息【commit信息即项目的change log】
3. 可读性好，清晰，不必深入看代码即可了解当前commit的作用
4. 为 Code Reviewing做准备
5. 方便跟踪工程历史
6. 方便进行git revert commitID操作
7. 方便通过git来进行debug时的操作
8. 提高整体项目质量与人工素质


转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)

扫描下方二维码，关注公众号，接收更多实时内容
![关注公众号：Leaders工作室](/images/article/WeChat/Leaders.png)