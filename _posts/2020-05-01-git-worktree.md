---
layout: post
title: "16.Git 工作树：多分支并行工作"
date: 2020-05-01
tag: Git
---

## 什么是`worktree`？使用场景是什么？
在谈论 `worktree` 之前，先来看两个开发过程中经常会遇到的情景。

### 情景1
目前在公司由于人手问题，一般一个开发都会同时接2-3个不同的需求。这些独立的需求可能是同一个仓库（不同的仓库相互根本不会影响，没有讨论价值），因此开发可能需要==在同一个仓库下相互独立的开发需求==。

由于 Git 的分支策略是很廉价的，因此选用不同分支开发是毫无疑问的，但是问题来了...当你需要在本地来回调试各个独立需求时，要怎么搞呢？

### 情景2
A 需求的代码都已经开放完了，写好了测试用例，可以进入 B 需求开发阶段...可是怎么能做到在等待跑 A 需求测试用例的同时开发 B 需求呢？面对二选一的情况...似乎只能是等或者另外复制一个目录出来处理了。

### 情景方案思考
面对这种“老婆和老妈同时掉水里，只能选一个救”的难题，憨厚老实的程序员似乎也是无法给出完美答案，而以下可能是大多数人会想到的方案。

**方案 1：A 需求分支正在进行调试...当 B 需求更加紧急需要对接调试时，先将 A 分支修改 `stash` 然后切换到 B 需求分支？或者先将当前修改 `commit` 在本地等处理完之后再`reset`回来继续开发？**

方案 1 的方式应该是大多数所采取的方式。但是...若总是有紧急的需求插入进来，你是否认为方案 1 是最佳的选择操作呢？如果不是你会怎么操作呢？

1. 显然如果总是遇到这种情况，方案 1 的方式是个很糟糕的体验...也很难进行维护
2. 方案 1 只能解决情景 1 的问题而并不能解决情景 2 所面临问题...

**方案 2：为每一个需求都克隆一个独立的仓库目录，随时进行目录切换，即不影响当前分支代码的开发调试情况，又不影响相互切换**

显然在需求总是交替的情况下，方案 2 的操作会更加方便。但是...克隆仓库的代价是昂贵的。特别遇到仓库较大而网络又不好的情况...等待克隆仓库的时候心里真是日了狗一般的痛苦，毕竟浪费一秒，加班的风险又增加了一分；或者项目较大，每多克隆一个项目...那么电脑磁盘中小电影的空间又要遭到挤压了(例如：我司之前的前端项目一个仓库`2.xG`，WR...克隆两次可就占了一部高清MV的空间了呀，而且用公司比肩地铁WiFi的速度，克隆一次至少15分钟...)。

**综上，可以看出方案 2 的缺点：**
1. 相较切换一个分支来说，检出速度极慢
2. 克隆的项目多了，管理维护麻烦...不知道到底克隆了多少个项目？每个项目分布在哪？
3. 绝对的浪费空间...

那么如果说：方案 2 的成本代价能跟切换分支一样廉价、快速、方便管理，那么方案 2 就完美了。

### 完美方案
`Git` 的 `worktree` 完美的解决了方案 2 的缺点。且看 [Git 官方对 `worktree` 的描述](https://git-scm.com/docs/git-worktree#_description)

> A git repository can support multiple working trees, allowing you to ==check out more than one branch at a time==. With `git worktree add` a new working tree is associated with the repository. This new working tree is called a "==linked working tree==" as opposed to the "main working tree" prepared by "`git init`" or "`git clone`". ==A repository has one main working tree (if it’s not a bare repository) and zero or more linked working trees==. When you are done with a linked working tree, remove it with `git worktree remove`.

一个 git 仓库可以支持多个工作树，允许你==在同一时间检出多个分支==.通过 `git worktree add` 将一个新的工作目录和一个仓库进行关联。
这个新的工作目录被称为“==linked working tree（链接工作树）==”，不同于通过 `git init` 或 `git clone`产生的主工作树。
==一个仓库只有**一个主工作树**(裸仓库是没有工作树的），可以有**零个或多个链接工作树**==.
当你在链接工作树已经完成了工作，使用 `git worktree remove` 就可以移除它了。

解释了 `worktree` 和其使用场景后，来看看如何使用。

## 创建 `worktree`
```sh
# 基于已存在分支创建 `worktree`
git worktree add <new-workpath> <existing-branch/commit-id/remote-branch-name>

# 基于当前 commit 新建一个分支并创建 `worktree`
git worktree <new-wokpath> -b <new-branch>

# 基于指定 commit 创建一个 worktree
git worktree <new-workpath> --detach <commit-hash>
```
### 注意事项：
1. `-b <branch>` 的作用是基于当前 HEAD 检出分支`<branch>`并创建链接，如果分支`<branch>`已经存在，该条命令执行会失败且不会创建`linked working tree`，而 `-B` 会忽略检出分支的错误直接创建`linked working tree`.
2. 如果 `git worktree add` 接的分支名前面没有`-b`、`-B`、`--detach` 参数，且分支名又不存在本地，==但刚好有这么一个同名的远程分支==，那么此时命令刚好等价于：①从远程`checkout`分支；②对检出的分支进行目录关联
```sh
git worktree add --track -b <branch> <path> <remote>/<branch>
```

### 演示案例
保留当前分支代码现状，基于 master 分支创建一个 hotfix 分支修复问题
```sh
# 基于 master 分支头指针，在目录同级创建一个 hotfix 的工作树
git worktree add ../hotfix --detach master

# 进入 hotfix 工作树创建检出分支(注意：此时工作树的头指针是分离的，即：不属于任何一个分支的)
git checkout -b hotfix

# 在该工作树下处理工作
```

## 查看 `worktree`
```sh
# 查看当前仓库所有的 "linked working tree"
git worktree list
```
![git-worktree-list](/images/article/git/show-worktree-list.png)

## 移动 `worktree`
```sh
git worktree move <worktree> <new-path>/<new-worktree>
```

## 清理 `worktree`
```sh
# 删除存在的 worktree
git worktree remove <worktree>
```

```sh
# 清理失去关联的 worktree
git worktree prune
```
> If a linked working tree is stored on a portable device or network share which is not always mounted, you can prevent its administrative files from being pruned by issuing the `git worktree lock` command, optionally specifying `--reason` to explain why the working tree is locked.

如果关联的工作树是储存在移动硬盘或共享网络中的(即：工作树不总是会被挂载的目录)，为了防止其管理文件被删除， 你可以使用 `git worktree lock` 命令，通过参数 `--reason` 添加工作区被加锁的备注.

```sh
# 锁定指定 worktree
git worktree lock <worktree>

# 解锁
git worktree unlock <worktree>
```
### 演示案例
![git-worktree-add](/images/article/git/demo-worktree-add.png)

## 深入 `worktree` 使用
> 我将一个`977M` 的大项目从我电脑 `/d/htdocs/zuzuche` 中复制到了 `~/Desktop/git` 目录中做演示。项目情况如下：项目共`977M`，其中静态资源+代码`200+M`，而`.git`目录有`700+M`；本地共2个分支 `master` 和 `master-bak`

![project-disk-details](/images/article/git/demo-worktree-disk.png)

### 1. 执行 `git worktree add` 的速度和磁盘空间变化如何？
- 速度：对于该项目创建链接工作树大约 20s 左右且无需依赖网络，而 `clone` 该项目是分钟级别的耗时且需要依赖网络传输拉取项目
- 磁盘空间变化：仅仅只是代码及静态资源被 copy 了一份，极大的节约了空间。因为：一个日益持久的项目.git势必是比原代码目录还要大的

![when-git-worktree-add-disk-change](/images/article/git/demo-worktree-add-disk-change.png)

### 2. 执行 `git worktree add` 后主工作树目录的`.git`中有什么变化？
![GIT-DIR!'s-changes-when-git-worktree-add](/images/article/git/demo-worktree-add-GIT-DIR!.png)
- 主工作树的 `.git` 下会多出一个 `.git/worktrees` 目录，用于记录各个 "linked working tree"，如：`bak`
- `commondir` 下记录着该链接工作树相对于主工作树下`GIT_DIR!`（即：.git）的相对目录层级路径
- `gitdir` 下记录着该链接工作树下的`.git`文件的==绝对路径==，而链接工作树下的`.git`文件又记录着主工作树`GIT_DIR!`中保存其自身所在目录的绝对路径
- `HEAD` 记录着链接工作树所对应的远程分支名
- `ORIG_HEAD`记录着链接工作树初始检出时的`commit-HASH`（即：`git worktree add`是基于哪个`commit-HASH`创建链接工作树的）
- `logs/HEAD` 记录着从链接工作树创建到当前状态所`commit`的日志信息
- `index` 是一个二进制文件，记录着当前状态链接工作树各个文件/目录的状态信息（可使用：`git ls-files --stage`查看）

![GIT-DIR!-detail-when-git-worktree-add](/images/article/git/demo-worktree-add-GIT-DIR!-detail.png)

### 3. 擅自变更工作树位置信息，会发生什么？
从 **2. 执行 `git worktree add` 后主工作树目录的`.git`中有什么变化？** 从了解到主工作树和链接工作树中记录的`GIT_DIR!`位置信息都是绝对路径。

因此，如果改动了主工作树的路径或名称，那么在链接工作树中就无法根据`.git`寻址到信息，会直接报错，如下图：

![linked-working-tree-changed-error.png](/images/article/git/demo-worktree-change-error.png)

如果非使用`git worktree move`改变位置信息或重命名，那么：当在主工作树中执行 `git worktree prune` 时对应丢失的链接工作树就会被当做垃圾清理掉

### 4. `linked working tree`存在的时候，主工作树中执行 `git branch -d `删除分支会发生什么？
经实验，当链接工作树存在时，不需要担心它对应的分支会被删除，其对应的分支是无法被删除
```sh
$ git branch -d master-bak
error: Cannot delete branch 'master-bak' checked out at 'C:/Users/Minso/Desktop/git/bak'
```

## 推荐阅读
- [git-worktree - Manage multiple working trees](https://git-scm.com/docs/git-worktree)

## 思考
测试环境的部署是属于全量包部署，通过环境切换系统种植 cookie 进行 nginx 重定向目录访问，如何利用工作树减少测试服务器资源部署的耗时及磁盘占用空间呢？
![image](/images/article/git/)


转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)

扫描下方二维码，关注公众号，接收更多实时内容
![关注公众号：Leaders工作室](/images/article/WeChat/Leaders.png)