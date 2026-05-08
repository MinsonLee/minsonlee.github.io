[TOC]
# 1. Git 简史
## 1.1 “版本控制”简史？
### 本地版本控制系统
> 复制整个项目目录的方式来保存不同的版本，或许还会改名加上备份时间以示区别
- 优点：简单
- 缺点：容易混淆所在工作目录，一旦弄错文件丢失数据无法恢复

![版本控制 -- VCS](https://git.oschina.net/progit/figures/18333fig0101-tn.png)

### 集中式版本控制系统（ Centralized Version Control Systems -- CVCS）
![CVCS](https://git.oschina.net/progit/figures/18333fig0102-tn.png)

- 优点：管理员也可以轻松掌控每个开发者的权限，并且管理一个 CVCS 要远比在各个客户端上维护本地数据库来得轻松容易
- 缺点：最显而易见的缺点是中央服务器的单点故障 -- “鸡蛋”都放在了一个篮子里

### 分布式版本控制系统--（ Distributed Version Control System -- DVCS ）
![DVCS](https://git.oschina.net/progit/figures/18333fig0103-tn.png)

## 1.2 Git设计目标：
- 速度
- 简单的设计
- 对非线性开发模式的强力支持(允许上千个并行开发的分支)
- 完全分布式
- 有能力高效管理类似Linux内核一样的超大规模项目[速度和数据量]

## 1.3 Git☞“速度”
### Git 和其他版本控制系对待数据方式
>- Git 只关心文件数据的整体是否发生变化
>- 大多数其他系统则只关心文件内容的具体差异

1.3.1 其他版本控制系统对待数据方式：
![其他版本控制系统对待数据方式](https://git.oschina.net/progit/figures/18333fig0104-tn.png)

1.3.2 Git保存数据方式
![Git保存数据方式](https://git.oschina.net/progit/figures/18333fig0105-tn.png)

### Git提供近乎所有操作都是本地执行
> 在 Git 中的绝大多数操作都只需要访问本地文件和资源，不用连网。
> 但如果用 CVCS 的话，差不多所有操作都需要连接网络。因为 Git 在本地磁盘上就保存着所有当前项目的历史更新，所以处理起来速度飞快

## 1.4 Git☞简单设计
### 时刻保持数据完整性
> 在保存到 Git 之前，所有数据都要进行内容的校验和（checksum）计算，并将此结果作为数据的唯一标识和索引。换句话说，不可能在你修改了文件或目录之后，Git 一无所知。这项特性作为 Git 的设计哲学，建在整体架构的最底层。所以如果文件在传输时变得不完整，或者磁盘损坏导致文件数据缺失，Git 都能立即察觉

### 多数操作仅添加数据
> 常用的 Git 操作大多仅仅是把数据添加到数据库。因为任何一种不可逆的操作，比如删除数据，都会使回退或重现历史版本变得困难重重。在别的 VCS 中，若还未提交更新，就有可能丢失或者混淆一些修改的内容，但在 Git 里，一旦提交快照之后就完全不用担心丢失数据，特别是养成定期推送到其他仓库的习惯的话。

### 文件的三种状态
对于任何一个文件，在 Git 内都只有三种状态：`已提交（committed）`，`已修改（modified）`和`已暂存（staged）`。已提交表示该文件已经被安全地保存在本地数据库中了；已修改表示修改了某个文件，但还没有提交保存；已暂存表示把已修改的文件放在下次提交时要保存的清单中。

由此我们看到 Git 管理项目时，文件流转的三个工作区域：Git 的`工作目录`，`暂存区域`，以及`本地仓库`。
![文件的三种状态](https://git.oschina.net/progit/figures/18333fig0106-tn.png)

### 基本的 Git 工作流程如下：
1. 在工作目录中修改某些文件
2. 对修改后的文件进行快照，然后保存到暂存区域
3. 提交更新，将保存在暂存区域的文件快照永久转储到 Git 目录中

# 2. Git基础
```
# 1. 初始化仓库: 创建一个名为 .git 的子目录，这个子目录含有你初始化的 Git 仓库中所有的必须文件
$ git init

# 2. 克隆现有仓库[--bare 裸仓库]
$ git clone [-b branch] [--bare] <remote url> <local pro name>

# 3. 跟踪文件
$ git add .

# 4.提交信息
$ git commit -m "msg"

# 5. 撤销提交操作【有时候我们提交完了才发现漏掉了几个文件没有添加，或者提交信息写错了】
$ git commit --amend

# 6.检查当前Git仓库状态
$ git status

# 7.查看尚未暂存的文件更新信息
$ git diff 

# 8.查看已暂存文件和上一次快照间的差异
$ git diff --cached [git diff --staged (1.6.1版本)]

# 9.移除文件 -- 删除工作目录中指定文件【并删除追踪】
$ git rm file

# 10. 移除文件--从Git仓库中删除，但希望保留在工作目录中
$ git rm --cached file

# 11. 查看日志
$ git log
$ gitk -- GUI界面查看git日志

# 12.贮藏当前更改
$ git stash save "stash msg" # 贮藏当前index中的改变
$ git stash list # 查看贮藏队列
$ git stash apply stash@{num} # 应用某个贮藏
$ git stash drop stash@{num} # 删除队列中某个贮藏
$ git stash clear # 清理贮藏队列
$ git stash -u/--include-untracked # 贮藏未被跟踪的文件
$ git stash push */*file -m "msg" # stash 指定文件
$ git stash -m "msg" -- just_my_file.txt # stash 一个文件


# 13.分支
$ git branch # 查看当前本地分支list
$ git branch -a # 查看所有分支list[本地+remote's branch]
$ git symbolic-ref --short -q HEAD # 通过查看HEAD引用的方式实现过去当前分支名
$ git branch -v # 查看本地所有分支及最新一次commit信息
$ git rev-parse --abbrev-ref [<local_branch>]@{u} # 获取指定本地分支的远程分支（upstream 分支）
$ git branch --set-upstream-to=<remote>/<branch> <local-branch> # 将本地分支(默认当前分支)关联到远程分支
$ git branch --track <local-branch> [<remote>/<branch> | <local-branch>]  # 创建本地分支并创建关联
$ git branch -u <remote>/<branch> <local-branch> # 将本地分支(默认当前分支)关联到远程分支
$ git branch --unset-upstream <local-branch> # 取消本地分支关联
$ git branch --merged # 查看所有已经merge到该分支的分支【即：最后一次commit信息已经包含在该分支中】
$ git branch --no-merged # 查看所有未merge到该分支的分支【即：最后一次commit信息已经包含在该分支中】
$ git checkout <branch> # 基于当前分支情况创建并切换分支
$ git symbolic-ref HEAD refs/heads/test # 通过修改 .git/HEAD 引用文件切换分支
$ git checkout -b <new_branch> [remote/branch] # 检出远程分支到本地
$ git checkout -b <new_branch> [tag name] # 检出新分支到某个标签版本
$ git checkout - # 切换回上一次操作的分支
$ git branch --contains  <commit hash> # 查找包含某个提交ID的分支列表
$ git branch --no-merged master # 获取所有没有合并到master的分支
$ git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)' # 获取本地最近操作的30个分支
$ git for-each-ref --count=30 --sort=-committerdate refs/remotes/ --format='%(refname:short)' # 获取远程仓库最近操作的30个远程分支

# 删除分支
$ git branch -d <branch_name> # 删除已合并到主干的指定分支（若指定分支有变更未合并到主干，则终止删除操作）
$ git branch -D <branch_name> # 强制删除指定分支
$ git branch -Dr <branch_name> # 强制删除指定本地的远程分支fetch信息

# 14.撤销
$ git checkout <file> # 撤销当前工作区指定文件的修改【危险命令】
$ git reset <commit>[ <file>] # 撤销当前暂存区到某个提交点
$ git reset --soft <commit> # 回退指定版本号，保留修改至工作区
$ git reset --hard # 回退且不保留

# 15.远程仓库
$ git remote -v # 查看当前remote详细信息
$ git remote add <remote_name> <remote url>
$ git fetch [remote-name] # 拉取远程指定仓库[-a 拉取全部]
$ git remote rename <old> <new># 重命名远程仓库
$ git remote rm <remote> # 删除指定remote

# 16.打标签[两种主要类型的标签：轻量标签（lightweight）与附注标签（annotated）]
# 一个轻量标签很像一个不会改变的分支 - 它只是一个特定提交的引用
# 附注标签是存储在 Git 数据库中的一个完整对象,包含打标签者的名字、电子邮件地址、日期时间；还有一个标签信息
$ git tag # 显示现有所有标签
$ git tag -l '正则' # 正则筛选标签
$ git tag <light weight name> -m "msg" # 轻量标签
$ git tag -a <annotated name> -m "msg"[ <commit>] # 附注标签
## 默认git push是不会推送标签，git push <remote> <tag name> ##
## 推送所有tag : git push --tags ##

# 17. 获取 Git 内置常用变量
git var [-l|<variable>] # https://git-scm.com/docs/git-var

# 18. 生成 Signed-off 信息
git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/Signed-off-by: \1/p'

# 19. 恢复数据
# 回复数据的原理：
# Git 会将每次 HEAD/分支 的变化信息记录在 .git/logs 文件夹下，当我们执行 git reflog 时也是从这个目录下遍历获取出对应的 HASH 值
# 只要获取到 HASH 值，我们就能通过 
git reflog # 查看所有分支的所有操作记录（对于 stash 数据删除了，目前应该是没有办法找回的）
git fsck --lost-found # Git 仓库一致性检查，会将仓库中“悬空commit”列出来，可能包括了已经删除的 stash 信息 （https://blog.csdn.net/hongchangfirst/article/details/45339565）


# 子模块
git submodle init # 初始化生成 .gitmodles 文件
git submodle add <url> <sub-path> # 自动 clone 一个子模块仓库到指定目录
git submodle update --init --remote # 更新子模块
```

## 文件状态
1. 你工作目录下的每一个文件都不外乎这两种状态：已跟踪或未跟踪
2. 已跟踪的文件是指那些被纳入了版
本控制的文件，在上一次快照中有它们的记录，在工作一段时间后，它们的状态可能处于：`未修改`，`已修改`或`已放入暂存区`.
![文件的状态变化周期](https://git.oschina.net/progit/figures/18333fig0201-tn.png)

https://git.oschina.net/progit/2-Git-%E5%9F%BA%E7%A1%80.html#2.2-%E8%AE%B0%E5%BD%95%E6%AF%8F%E6%AC%A1%E6%9B%B4%E6%96%B0%E5%88%B0%E4%BB%93%E5%BA%93