---
layout: post
title: "09.Git操作-追踪工作区的变更"
date: 2018-09-09
tag: Git
---

## Git中的分区
> 先上一张镇楼图,详细的讲解可以看[05.三张图了解Git工作原理](https://minsonlee.github.io/2018/04/05.git-theory)

![Git life cycle](/images/article/git/git-life-cycle.jpg)

上图已经非常清晰的阐述了Git中的各个分区,以及他们之间是如何配合工作的！

- 工作区:是我们直接工作的区域,这里记录了你所有的操作记录(增/删/改)
- 暂存区:顾名思义,暂时存放,用于给你确定是否真的要将变更提交给仓库中
- 本地仓库:本地正式存储变更的地方【这里是给你存放你`流水账般`的更改记录的,你的变更也只有通过本地仓库才能被`出口`到远程仓库上】
- 远程仓库:云端仓库,只要有权限的人都可以将自己本地仓库的变更推送上来,这样大家就可以共享这些变更,达到协同合作的目的了

接下来,主要会讲述一下在工作区、暂存区、本地仓库三个区中的增、删、改操作.只讲这3个是因为：只有在这3个区中,我们才有自己的主动权,远程仓库是大家共同协作的地方,一般我们除了`正常推送/拉取`信息外,不建议也不会随便去进行操作(本地与远程仓库的交互在[06.Git操作-仓库](https://minsonlee.github.io/2018/04/06.git-repository/)一文中也介绍的差不多了)!

### 工作区-->暂存区
>从`工作区`-->`暂存区`这个过程有点像：新生婴儿出生要入户一样,只有入户之后的婴儿才会有资格入学,`入学档案`相当于`文件的变更历程`

1. **Git的操作(追踪)对象只针对在`Git`中注册过(即:当前已经在暂存区或已经在本地仓库存储过一次)的`文件`==>①空目录不在追踪范围内;②文件首次被新增并且没有被加入到暂存区的时候是不受Git约束的**
2. **如果对各个分区的工作范围有疑问的,可以先看一下：[05.三张图了解Git工作原理](https://minsonlee.github.io/2018/04/05.git-theory/)**
> - 工作区的范围是：在包含`.git`文件下,除了`.git`目录以外的所有目录及文件
> - 在工作区中执行增删改操作,跟你在平常文件目录中执行增删改是一样的,因此在此处我们主要说从`工作区`到`暂缓区`所要做的事！

#### 增加
- 将工作区中指定的文件提交到暂存区:
```sh
$ git add filename
```
- 将工作区中所有文件提交到暂存区: 
```sh
# 事实上我们经常添加的时候使用.代表全部文件,但是却不建议,尤其是项目初建的时候
# 因为你可能会把一堆废的文件或不需要被追踪的文件添加进来,并当你变更的文件很多的时候,检查漏了就直接将它们直接推送到了远程服务器上去
# 例如:你使用了IDE进行创建项目,很有可能把.idea/文件夹的所有文件
git add .
```
- 将工作区中被追踪了文件添加到暂存区：
```sh
# 注意`-u`参数只针对已经被追踪的文件,如果不指定操作对象,该命令会使用通配符.(点号--所有文件)作为其操作对象
# 如果你将一个完全新增的文件作为命名的对象,虽然不会报错,但文件并不会被暂存成功
$ git add -u [filename]
```
- 指定一个文件,并进行交互式分块将其变更逐个提交到暂存区中
```sh
# 注意：
# 既然是交互式分块,那么一定是将指定文件`当前`和`以前`相比产生了不同才能进行分块
# 因此该指定的工作区中的文件一定是已经在被追踪的文件
# 如果是没有被追踪的文件,前后的状态根本不会有差异,因此也不会被添加
$ git add -p <file>
```

#### 删除
- 删除工作区与版本库中的文件：
```sh
$ git rm <file>
```
>1. 注意①：删除一定是针对已经在Git中的文件【因此使用该命名去删除一个完全没有被追踪的文件是会报错的,如下图】
>2. 注意②：这条命令相当于以下两条命令结合:`rm file` + `git add file`;

![Git life cycle](/images/article/git/git-rm-error.png)

**很长的时间我一直在纠结:`rm`和`git rm`到底有什么不同?为什么操作系统下已经有了`rm`命令或操作功能,git还要创建一个`git rm`命令呢?**
> 以下是个人的理解:`rm`命令的操作对象是操作系统下的文件, `git rm`的针对对象是Git中的文件；`rm`的操作最终是被记录在操作系统层面的变更,还需要使用`git add file`将这个`rm`变更添加到git的暂存区,那么这个删除操作才会被`Git`所记录

- 强制删除
```sh
# 若当前文件的部分变更已经在暂存区中了,直接执行`git rm file`是报错的
$ git rm -f <file>
```
![Git life cycle](/images/article/git/git-rm-f-error.png)

- 将文件在版本库中删除,但仍将文件留存在工作区(相当于仅仅从Git中`销户`,但不是`死亡证明`)
```sh
# 从Git中进行了销户或开了死亡证明的文件,这个时候有变更都不会再被Git继续追踪
git rm --cached <file>
```

#### 修改
- 重命名文件
```
# 如果你不是使用这条命令进行重命名,在Git中会被认为你做了两个操作:①你执行了`git rm file`删除了文件;②使用`git add new_file`新增了一个文件
$ git mv <old_file> <new_file>
```
#### 查看
- 查看当前工作区和暂存区状态
```sh
# 这几乎是一条万能的命令,推荐你有事没事的时候都可以执行一下,它会告诉你下一步你可以怎么做
$ git status
```
![git status](/images/article/git/git-status-en.png)

- 查看当前工作区【即：改动文件】文件的简要信息
```sh
$ git status -s
```
![git status -s](/images/article/git/git-status-short.png)



### 暂存区
> `暂存区`有点像生活当中到爬出所登记户籍一样的地方,该分区自身是不会有新增功能的,所有的新增都是来源于工作区的`add`命令
> 暂存区，事实上你可能除了`储藏`操作外,你并不会用到,所以`储藏`会细说,其他的当了解一下吧

#### 查看
- 查看当前暂存区所有已经被追踪的文件及:`git ls-files --stage`
- 显示冲突的文件：`git ls-files -u `
- 显示标记为冲突已解决的文件：`git ls-files -s`

#### 储藏
> 在网上很多看到很多文章都说:储藏(贮藏)操作文件是放到了暂缓区,实际上我发现这个用词是不准确的,因为`储藏`操作放置保存的东西和`暂存`操作防止保存东西的位置是不同的,如下图:

![git stash](/images/article/git/git-statsh.png)

**什么是储藏?**
> 储藏相当于：将当前工作区和暂存区中的变更暂时`隐藏`起来,那么当前的工作区和暂存区就变得干净了,你可以重新开始做事情!

**为什么要储藏这个功能?**
> 试想:当你在当前分支工作到一半的时候,你老板突然让你更改线上的一个可能就只是一行代码完事的bug,并且立即修复上线
> - 你可以将当前所有的变更删了,然后进行修复上线,修复上线后再重新写一次 -- 当然这显然是沙雕才会做的
> - 建立一条新的分支,然后改动一行代码,修复上线后，回到现在分支将修复的问题合并到当前分支,然后继续工作！【**每一个紧急的修复在上线之后都应该合并到其它没有问题的分支中,以确保其他人不会因为这个问题而产生新的问题**】 -- 可是：你又不想为了这一行代码而新建立一条分支去单独完成这个事情,如果能有个类似`系统快照`的功能,将你当前的变更记录下,而你直接在当前分支修复上线,并通知大家更新这个分支代码，然后再迅速的将所有工作恢复到`快照`记录的样子就好了==>这就是`储藏`存在的意义！

**什么时候用储藏?**
> 1. 只要你暂时不想将当前工作区和暂存区的变更，在当前时刻(当前分支)下进行提交到本地仓库,那么你就可以使用储藏功能,将这些变更藏起来,等你要用的时候再取出来即可!
> 2. 不建议你频繁的储藏太多的`快照`,因为太多你可能会忘记每一个快照到底存储的是什么东西,即使写了标记,前后存储的快照可能会有冲突的地方,导致你在恢复的时候不得不进行一些丢弃，因此:谨记`储藏`只是给你临时保存东西用的,如果一个东西需要长期进行保存,然后进行各种场景测试,你应该毫不犹豫的选择使用`分支`进行隔离开发测试

**如何使用储藏功能?**
#### 增加
- 储藏工作区与暂存区文件的变更,并写上备注
```sh
# 注意:储藏功能也依然是针对被追踪的文件的,如果你要将没有被追踪的文件也一并储藏起来,需要将这些文件添加到暂存区中
$ git stash save -u "message"
```
- 储藏当前工作区和暂存区的变更，同时将暂存区文件保留一份副本
```sh
$ git stash save --keep-index -u "message"
```

#### 查看
- 查看当前储藏栈列表【相当于往一个桶里放东西,最后放的东西在最前面】
```sh
$ git stash list
```
![git stash list](/images/article/git/git-stash.png)

#### 删除
- 删除储藏栈指定记录
```sh
git stash drop stash@{num}
```

#### 应用
> `快照`一旦被存储,只能拿出来使用,是不允许更改的

- 应用指定储藏记录
```sh
$ git stash apply stash@{num}
```
 - 应用指定一个储藏记录,并在成功应用后将其在储藏栈中删除
 ```sh
 $ git stash pop [ stash@{num}] # 如果没有指定储藏记录,则应用最近的一个,并在成功后将其删除
 ```
 
- 基于指定的储藏记录创建一个新的分支
```sh
$ git stash branch <branch_name> [ <stash@{num}>] # 如果没有指定储藏记录,则应用最近的一个,并在成功后将其删除
```

### 暂存区-->本地仓库
> - "暂存区"是用于文件从工作区到本地仓库的过渡区间,相当于二次确定.
> - "本地仓库"是用于存放本地所有数据的,也正是有了"本地仓库",所以Git可以让你在没有网络的情况下可以正常工作,等有网络的时候再将变更推送至服务器【没有网络的情况下SVN不能推送,且不能分节点保存你的工作】

**此文最后只讲从`暂存区`提交记录到`本地仓库`进行保存,撤销暂存和分支合并会分开单独进行讨论**

#### 新增
> 新增记录至本地仓库就只有一个命令

```sh
$ git commit
```

**若多使用命令行进行提交,且在提交前有校验提交差异的习惯**
```sh
# 此时Git会弹出内置的编辑器给你填写备注信息,并在界面上展示出文件前后变更的差异
$ git commit -v
```

**若没有校验习惯**
```sh
$ git commit -m "message"
```

**如果比较偷懒,且当前工作区变更的文件全部都是已追踪文件,企图直接从工作区-->本地仓库**
```sh
# 该命令等同于:`git add -u` + `git commit -m "message"` 
# 注意：`git add -u`只是针对已追踪文件
$ git commit -am "message"
```

**如果你发现本次提交应该附属追加在上一次的提交中**
```sh
# 该命令会将当前的提交和上一次(最近一次)提价整合作为一个提交
$ git commit [ -am "new message"] --amend
```