# Git 的 4个阶段撤销
> 来源：张京
> [https://www.fengerzh.com/git-reset/](https://www.fengerzh.com/git-reset/)

[TOC]

## 前言
![Git 工作流程图|center|500*0px;](https://res.cloudinary.com/fengerzh/image/upload/git-reset_drbfhd.png)
       虽然git诞生距今已有12年之久，网上各种关于git的介绍文章数不胜数，但是依然有很多人（包括我自己在内）对于它的功能不能完全掌握。以下的介绍只是基于我个人对于git的理解，并且可能生编硬造了一些不完全符合git说法的词语。目的只是为了让git通俗化，使初学者也能大概了解如何快速上手git。同时，下面所有讨论，我们都假设只使用一个分支，也就是主分支master的情况，虽然这种作法并不符合git规范，但是现实情况中绝大部分用户是直接在master分支上进行工作的，所以在这里我们不去引入更加复杂的各种分支的情况，也不涉及标签tag的操作，只讲在最简单的主分支上如何回退。

## 基本概念
### 3个状态
![Git 工作区间](https://segmentfault.com/img/bVYnEY)
正常情况下，我们的工作流就是3个步骤，对应上图中的3个箭头线：

```powershell
$ git add .  # 将所有修改从本地"工作区"[woke area]==>"暂存区"[stage]
$ git commit -m "comment" # 将"暂存区"态提交到"本地仓库"[local ]
$ git push <remote> <branch> # 将"本地仓库/当前分支"推送到"远程仓库"指定分支[remote/branch]
```
> 事实上，在执行git push之前是需要先拉取远程信息进行检测差异的~
```
# git fetch <remote name:origin> <branch name:master> -- 获取远程更新信息
# git diff <remote>/<branch> -- 检查本地当前所在分支与<remote>/<branch>差别
# git merge <remote>/<branch>  -- merge <remote>/<branch> into 当前分支
# git pull <remote> <branch> -- 拉取并直接合并远程指定分支
# git pull -u <remote> <branch>
```
> 1.如果没有执行`pull`拉取或`fetch/merge`会报错
> 2.可以使用`git push -f`强行推送当前分支数据到远程分支
> 3.`git pull -u <remote> <branch>` && `git push -u <remote> <branch>` 绑定分支，再下一次执行的时候直接`git pull` && `git push`即可

### 4个区
git之所以令人费解，主要是它相比于svn等等传统的版本管理工具，多引入了一个`暂存区(Stage)`的概念，就因为多了这一个概念，而使很多人疑惑。其实，在初学者来说，每个区具体怎么工作的，我们完全不需要关心，而只要知道有这么4个区就够了：
-  工作区(Working Area)
-  暂存区(Stage)
-  本地仓库(Local Repository)
-  远程仓库(Remote Repository)

### 5种状态

以上4个区，进入每一个区成功之后会产生一个状态，再加上最初始的一个状态，一共是5种状态。以下我们把这5种状态分别命名为：
  - 未修改(Origin)
  > nothing to commit, working tree clean

  - 已修改(Modified)
> `Changes not staged for commit` || `Untracked files`
>  use `git add` and/or `git commit -a`

  - 已暂存(Staged)
> `Changes to be committed` -- `git commit -m 'commit message'`

  - 已提交(Committed)
  > `Your branch and '<remote>/<branch>' have diverged,
and have xx and xx different commits each, respectively`
> use  `git pull`  -- `git push`

  - 已推送(Pushed)

## 检查修改
了解了基本概念之后，我们来谈一谈犯错误之后如何撤销的问题。首先，我们要了解如何检查这3个步骤当中每一个步骤修改了什么，然后才好判断有没有修改成功。检查修改的二级命令都相同，都是diff，只是参数有所不同。
### 已修改，未暂存 -- 修改未git add .
首先，我们来看一下，如果我们只是简单地在浏览器里保存了一下文件，但是还没有做git add .之前，我们如何检查有哪些修改。我们先随便拿一个文件来做一下实验：

![change file|center|400*0px](https://segmentfault.com/img/bVYnIM)

我们在文件开头的第2行胡乱加了4个数字1234，存盘，这时文件进入了已修改状态，但是还没有进入暂存区，我们运行git diff，结果如下：
```
$ git diff

diff --git a/index.md b/index.md
index 73ff1ba..1066758 100644
--- a/index.md
+++ b/index.md
@@ -1,5 +1,5 @@
---
-layout: main
+1234layout: main
color: black
---
```
`git diff` 的结果告诉我们哪些文件已经做了哪些修改。

### 已暂存，未提交 -- 执行了git add . 未 git commit
```
$ git diff --cached
```
现在我们把修改放入暂存区看一下。先执行git add .，然后执行git diff，你会发现没有任何结果：

![git diff |center|400*0px;](https://segmentfault.com/img/bVYnKj)

这说明git diff这个命令只检查我们的工作区和暂存区之间的差异，如果我们想看到`暂存区`和`本地仓库`之间的差异，就需要加一个参数`git diff --cached`
```
$ git diff --cached

diff --git a/index.md b/index.md
index 73ff1ba..1066758 100644
--- a/index.md
+++ b/index.md
@@ -1,5 +1,5 @@
---
-layout: main
+1234layout: main
color: black
---
```
这时候我们看到的差异是暂存区和本地仓库之间的差异。

### 已提交，未推送 -- 执行了git commit 未 git push
```
$ git diff master origin/master
```
现在，我们把修改从暂存区提交到本地仓库，再看一下差异。先执行git commit，然后再执行git diff --cached，没有差异，执行git diff master origin/master，可以看到差异：

![git diff local-branch remote/branch | center |500*0px;](https://segmentfault.com/img/bVYnKY)

在这里，master就是你的本地仓库，而origin/master就是你的远程仓库，master是主分支的意思，因为我们都在主分支上工作，所以这里两边都是master，而origin就代表远程。

## 撤销修改
了解清楚如何检查各种修改之后，我们开始尝试各种撤销操作。

### 已修改，未暂存 -- 未执行 git add .
如果我们只是在编辑器里修改了文件，但还没有执行`git add .`，这时候我们的文件还在`工作区`，并没有进入`暂存区`，我们可以用：
```powershell
$ git checkout .
或
$ git reset --hard
```
来进行撤销操作。

![git diff after checkout file | center](https://segmentfault.com/img/bVYnLO)

可以看到，在执行完git checkout .之后，修改已被撤销，git diff没有任何内容了。

> ` git add .`的反义词是`git checkout .`。做完修改之后，如果你想向前走一步，让修改进入暂存区，就执行`git add .`，如果你想向后退一步，撤销刚才的修改，就执行`git checkout .`。

### 已暂存，未提交 -- 执行了git add 未 git commit

你已经执行了`git add .`，但还没有执行`git commit -m "comment"`。这时候你意识到了错误，想要撤销，你可以执行：
```powershell
$ git reset
$ git checkout .
或
$ git reset --hard
```
>`git reset`只是把修改退回到了`git add .`之前的状态，也就是说文件本身还处于`已修改未暂存状态`，你如果想退回未修改状态，还需要执行`git checkout .`。

或许你已经注意到了，以上两个步骤都可以用同一个命令git reset --hard来完成。是的，就是这个强大的命令，可以一步到位地把你的修改完全恢复到未修改的状态。

### 已提交，未推送 -- 执行git commit 未git push
你的手太快，你既执行了git add .，又执行了git commit，这时候你的代码已经进入了你的本地仓库，然而你后悔了，怎么办？不要着急，还有办法。
```powershell
$ git reset --hard origin/master
或
$ git reset HEAD^ # 撤销到上一个HEAD提交状态
```
还是这个`git reset --hard`命令，只不过这次多了一个参数`origin/master`，正如我们上面讲过的，`origin/master`代表远程仓库，既然你已经污染了你的本地仓库，那么就从远程仓库把代码取回来吧。

### 已推送 -- 执行git push
很不幸，你的手实在是太快了，你既git add了，又git commit了，并且还git push了，这时你的代码已经进入远程仓库。如果你想恢复的话，还好，由于你的本地仓库和远程仓库是等价的，你只需要先恢复本地仓库，再强制push到远程仓库就好了：
```
$ git reset --hard HEAD^
$ git push -f
```

![git push -f | center | 480*0px](https://segmentfault.com/img/bVYnWc)

## 总结
以上4种状态的撤销我们都用到了同一个命令`git reset --hard`，前2种状态的用法甚至完全一样，所以只要掌握了`git reset --hard`这个命令的用法，从此你再也不用担心提交错误了。