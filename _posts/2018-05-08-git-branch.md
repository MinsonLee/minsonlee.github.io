---
layout: post
title: "07.Git操作-分支"
date: 2018-04-30
tag: Git
---

## 背景
> 克隆操作一般默认会在本地创建一个`master`分支且与远程仓库的`master`建立跟踪.
> 实际上我们工作中也几乎是基于`人手一条分支`或`一个功能/模块一条分支`等要求来进行开发协作的.
> 因此,对分支的灵活应用尤为关键

## 基本
> - 你可以将分支理解为`树枝`，只是我们为每一条`支`都进行了`命名`
> - 一个分叉节点可以分出无限个`树枝`
> - 这个`树枝`可以拥有`该树枝节点前主干上的所有东西`(只要其他的`树枝`在该节点前与`主干`形成了闭合的回路).
> - 各个`树枝`之间只要不是合并,那么一定是相互独立不影响的

![how to description git-branch](/images/article/git/branch-tree.jpg)

## 思考
> 分支的使用是非常灵活的,有许多不同方式可以实现同一个目的,因此该篇将会提问的方式来引导你对分支的操作.
> 试想：现在你知道了分支的大概意义,那么关于`分支`你会提出那些疑问?你需要那些操作来辅助你完成`分支`的协作?
> 下图为网上流传广泛的一个[分支模型](https://www.oschina.net/translate/a-successful-git-branching-model?lang=chs),建议仔细看看.【关于分支的合并后续会讲到】

![git-branch-model](/images/article/git/git-branch-model.png)

> - 主干master分支  -- 稳定、发布使用,产品/项目的主干使用分支【产品/项目使用 && 产品验收 && 线上回归测试】
> - 预发布(Release)分支 -- 待最后一步验证稳定,等待合并到master分支【产品验收&&仿真测试】
> - develop集成开发分支 -- 稳定，可等待集成到Release分支进行预发布【集成测试】
> - 热修复(hotfixes)分支 -- 修复紧急问题,起始于master,回归于master和每一个develop分支【紧急测试】
> - 功能开发(feature)分支 -- 开发模块功能(开发人员应该直接接触的)【功能测试验收】

1. 什么时候该创建什么类型的分支来进行工作呢?我要如何创建一个分支?如何切换到指定的分支？
2. 我要怎么知道我当前在那条分支呢?我要怎么知道有那些分支呢?这些的分支的状态是如何的呢?
3. 本地分支要如何和远程分支联系起来呢?
4. 我要如何修改一条分支呢?如何修改远程的分支呢?
5. 我要如何删除一条分支呢?如何删除远程的分支呢?
6. 我能否就某一个提交点拉取创建一条分支出来呢?该如何做呢?

> 虽然答案就在下面,但如果不急其实不建议直接看答案,Google搜一下吧,能看到更多的知识!

## 解答
### 1. 什么时候该创建什么类型的分支来进行工作呢?我要如何创建一个分支?如何切换到指定的分支？
- **什么时候该创建什么类型的分支进行工作?**
> 事实上Git鼓励多用分支来进行工作,就像前面说的一样:Git创建一条分支的代价非常廉价.这个问题的最好答案就是上面的分支模型图.

- **如何创建一个分支?如何切换到指定分支?**

```sh
# 以当前节点创建一条新的分支
$ git branch <branch_name>

# 切换到新创建的分支
$ git checkout <branch_name>
```
```sh
# 创建并切换分支:一条命令顶上面两条
$ git checkout -b <branch_name>
```
### 2. 我要怎么知道我当前在那条分支呢?我要怎么知道有那些分支呢?这些的分支的状态是如何的呢?
- **当前在那条分支?**
```sh
# 前面带`*`的就是你当前所在的分支
$ git branch
```
```sh
# 前面的文章也说过:如果不知道下一步要干嘛,就尝试一下
$ git status
```
- **远程有那些分支呢?**
1. 命令`git branch`让你知道你处于什么分支,也让你知道你本地一共有那些分支.那么远程有那些分支行呢?
2. 参数`-a`可以告诉你答案:`git branch -a`

- **这些分支现在都处于什么状态呢?【最后的提交信息是啥?】**
1. 参数`-v`可以告诉你：`git branch -v`

![show-branch-status](/images/article/git/show-branch-status.png)

### 3. 在本地分支完成工作之后,要如何和远程分支联系起来呢?
**分支的操作是灵活的,命令`git status`可以告诉你当前分支的详细情况,其中包括:当前分支的`上游分支`[与之关联的远程分支]**

**1. 创建分支的时候同时设定关联的远程分支**
```sh
$ git branch -t <new_branch> <remote>/<remote_branch> 
```
**2. 创建检出分支的时候同时设定关联的远程分支**
```sh
$ git checkout -b <new_branch> -t <remote>/<remote_branch> 
```
```
# 如果不想重新命名新的分支或想要本地分支与远程分支同名
$ git checkout -t <remote>/<remote_branch> 
```
**3. 如果为本地已经存在了分支设定关联呢?**
```sh 
# 默认设定当前分支与远程分支关联
$ git branch -u [<local_branch>] <remote>/<remote_branch>
```
```sh
# 默认设定当前分支与远程分支关联
$ git branch --set-upstream-to=<origin>/<branch> [<local_branch>]
```

![band-remote-branch](/images/article/git/band-remote-branch.png)
> 也许设定了上游分支之后执行`git push`会提示你当前分支与推送的分支名字不同,导致推送失败,修改推送模式配置即可:`git config --global push.default upstream`

![push-model](/images/article/git/push-model-config.png)

### 4. 我要如何修改一条分支呢?如何修改远程的分支呢?
1. **修改(重命名)分支只需要加`-m`参数即可,由于`git创建/删除分支都非常廉价`,大的改动只需要删除再创建即可**
2. **修改远程分支......实际上是不存在的,这辈子都不可能的了**
```sh
$ git branch -m old-branch new-name
```

### 5. 我要如何删除一条分支呢?如何删除远程的分支呢?
**1. 删除本地分支**
```sh 
# 删除本地分支
$ git branch -d <local_branch_name>
```
```sh 
# 强制删除本地分支(如果删除的分支还有commit没有合并到主干分支,以上命令会提示删除失败)
$ git branch -D <branch_name>
```
**2. 删除远程分支**
以下方式都可以达到删除远程分支目的：
- 命令删除远程分支
- 推一个空分支到指定远程分支;

```sh 
# 推送一条删除命令到远程
$ git push --delete <remote>/<remote_branch>
```
```sh 
# 推送一个空分支覆盖指定远程分支
$ git push <remote> :<remote_branch>
```

- **Git创建分支很方便且廉价,及时的清理无用的分支是一个很好的习惯**
- **Git除了内置的命令,还可以配置shell命令,可以将以下命令全局配置到Git中[~/.gitconfig]**
```sh
# 强制删除除当前分支外的所有本地分支
[alias]
	del-branch-a = !"git branch | grep -v '*' | while read branch; do git branch -d $branch ; done"
# 命令行下执行以下命令即可
$ git del-branch-a
```
```sh
# 删除所有已经merge到master的分支
[alias]
    del-branch-m = !"git branch --merged master | grep -v '^\\*\\| master' | xargs -n 1 git branch -d $branch"
```
```sh 
# 删除在远程已被删除的本地分支[网上一把抄,但我在此并没有实践到一个通用的,待补充......]
```

### 6. 我能否就某一个提交点拉取创建一条分支出来呢?该如何做呢?
**1. 能否就某一个提交点拉取创建一条分支出来呢?**
答案是 : 肯定可以的!
>为什么呢?
> - 正如前面文章[05.三张图了解Git工作原理](https://minsonlee.github.io/2018/04/05.git-theory)中所说到的一样：`Git`是一套"内容寻址 (content-addressable) "文件系统,在Git中一切操作都是引用：Git分支(本地、远程)、标签、HEAD、暂存区(index)、储藏(stash)、对象(tree/blob/commit/tag)的存储……这些都是引用,它们都是一串SHA-1加密后得到的哈希字符串
> - 因此：`分支`可以看作为一个`命了名称的变动HASH字串`，而每一次的提交操作都相当于变更了分支名与HASH字串的对应关系

**2. 如何就某一个分支点拉取创建一条分支出来?**
```sh
# 回顾：如何就当前节点创建一条分支?
git branch new_branch [HEAD] #其实这条命令默认缺省是HEAD--当前节点
# 那么只需要在创建分支的时候,将`HEAD`节点替换你要拉取的节点(HASH字符串)即可
git branch new_branch_name fb564768be694dd112431b5a5114a4c70997b871
```

**参考文献**
- [介绍一个成功的 Git 分支模型](https://www.oschina.net/translate/a-successful-git-branching-model?lang=chs)

转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)

扫描下方二维码，关注公众号，接收更多实时内容
![关注公众号：Leaders工作室](/images/article/WeChat/Leaders.png)