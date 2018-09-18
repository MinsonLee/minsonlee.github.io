---
layout: post
title: "13.Git操作-忽略文件"
date: 2018-09-13
tag: Git
---

## 背景
上一篇中记录了Git中的撤销操作,但是Git的撤销是针对于需要进行提交的文件的变更来说的

但在项目开发的时候,很多时候我们是不需要将整个工作目录下的所有文件或目录全部提交到远程仓库的,并且我们希望Git能在一开始就完全忽略这些文件或目录,不对他们产生追踪.例如:
- 使用IDE工具进行开发,会在目录下生成`.idea`目录
- 使用框架时,框架的`vender目录`是不需要进行版本控制的
- 在当前目录下写的一些测试代码文件,仅存于你本地用于测试即可,是不需要
- ......

## git中的忽略
### 忽略未被跟踪文件
> - git中的忽略方式一般来说都仅仅是针对未被追踪的文件/目录来说的,因为对于已被追踪的文件:如果设置了忽略变更,那么`设置忽略变更`的这个操作本身`就是应该要同步告诉其他人的也设置忽略`才是对的,所以git也就不能将这个设置操作忽略,这个过程本身就是矛盾的！因此,git中忽略仅仅只是针对未被追踪的文件/目录

**假设情况如下**

![git ignore](/images/article/git/git-ignore.png)

1. 使用`.gitignore`文件忽略未跟踪文件
> 使用`.gitignore`文件进行忽略的文件或目录应该是要同步到该项目仓库下所有人共同进行忽略的，PS:数据模型目录(因为数据的操作不应该有版本控制的变化)、一些第三方维护的拓展存放目录vender/library目录...

```sh
# 生成.gitignore文件
$ touch .gitignore
# 编写忽略规则,忽略vender目录下所有文件, 输入`vender/`即可
$ vi .gitignore
# 将该忽略规则同步告诉其他人
$ git add .gitignore
$ git commit -m "add:add the .gitignore"
```
![vi .gitignore](/images/article/git/vi-gitignore.gif)

2. 全局设置`git config --global`忽略：
> 使用`git config --global`进行忽略的文件或目录应该是`不需要同步到该项目仓库下所有人共同进行忽略的`，PS:你所有的文档/代码/图片预览都是JetBrains全家桶进行的,该工具会在目录下生成一个`.idea`的目录,你不希望每个项目都去编写`.gitignore`来进行忽略

```sh
# 指定全局忽略设置的脚步【可以指定一个文件里面存放忽略规则,也可以直接指定一条忽略规则】
$ git config --global core.excludesfile ~/。gitignore
# 在全局目录下,生成.gitignore文件(名字可以随便取)：~/.gitignore
$ touch ~/.gitignore
# 编写忽略规则,忽略global-test目录下所有文件, 输入`global-test/`即可
$ vi ~/.gitignore
```
![git global_gitignore_file ](/images/article/git/vi-gitignore.gif)

3. 通过`.git/info/exclude`设置忽略
> 通过`.git/info/exclude`设置忽略与通过`.gitignore`文件进行忽略的方式是完全一样的,但该方式适合:个人暂时或永久忽略未跟踪文件，不需要同步到中心仓库.PS:新建的一个项目需要频繁的在本地开发目录下新建了一个test目录来存放一些测试脚本,该目录下所有脚本都是不需要同步到远程仓库的

```sh
# 编写忽略规则,忽略blog-test目录下所有文件, 输入`blog-test/`即可
$ vi ./git/info/exclude
```
![vi .git/info/exclude](/images/article/git/vi-project-exclude.gif)

**上述3种方式,如果使用`.gitignore`方式会产生额外的提交,因为这种忽略设置是需要同步给其他人的!!!**

### 忽略已被跟踪文件
> 如果要忽略已被追踪的文件,那么该忽略设置应该`让该文件/目录不再被继续追踪`且这个忽略设置仅仅是`针对个人`而`不需要同步告知其他人也一般设置忽略`的一个设置操作才对！
>
> PS：当前项目有一个公共的数据库,仓库的用户名和密码都是写死在一份配置文档里的.但是每个人的权限是不一样的,所以每个人都有自己的用户名与密码,当你在本地运行的时候就需要将其替换为你自己的用户名与密码.那么你对这份配置文档的改动是不能提交到线上去的,但是这份文件在初始化项目的时候又是需要被追踪同步给所有人的...遇到类似的情况,我们就需要对这种已经被追踪的文件/目录进行忽略
>
> **git工作区中对文件的变更都是注册记录到`.git/index`文件中的,只有这样才会被git追踪,因此:要做到`个人对已被追踪的文件`进行忽略,只能依靠`个人`与`git`之间共同去协定,凭借是彼此之间的信任**.即:
> - 个人:告诉git,请`假设`xxx文件为不会变更(本地的变动及远程的更新)的状态,如果我`需要变更一定告诉你`.
> - git:就这么傻傻的相信了
>
> 什么时候告诉git需要变更?当这份配置文件新增了一个需要大家都同步的配置时候,你需要将其设置为可更新状态,并将最新信息拉取下来，然后重新设置会忽略更新状态!

```sh
# 将一个已追踪文件注册为忽略变更
$ git update-index --assume-unchanged FILE
# 将一个已追踪文件的忽略变更设置取消注册
$ git update-index --no-assume-unchanged FILE
```
![git-update-index-assume-unchanged](/images/article/git/git-update-index-assume-unchanged.gif)

**如果你在设置了忽略的状况下进行了变更,并且没有告诉git,你就进行一些其他的操作【例如:切换分支--切换分支一定要保证当前工作区和暂存区是干净的;或者拉取更新,而拉取更新的文件中刚刚好涉及了你设置忽略更新的文件】**

![git-update-index-assume-unchanged-error](/images/article/git/git-update-index-assume-unchanged-error.png)

**这个时候你只能将忽略变更的设置取消了,然后再做其他的操作了**
![git-update-index-assume-checkout-error](/images/article/git/git-update-index-assume-error.gif)

![git-update-index-assume-pull-error](/images/article/git/git-update-index-assume-pull-error.gif)