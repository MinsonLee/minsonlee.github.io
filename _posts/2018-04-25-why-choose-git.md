---
layout: post
title: "02.Git与SVN的比较"
date: 2018-04-25
tag: Git
---
## 写在前面的话
> 1. 考虑到很多人或很多公司依然在用SVN,所以在介绍具体使用之前,翻阅资料总结了该文.
> 2. 目的是为了让大家对SVN和Git有个更好的认知,无意争执SVN和Git孰优孰劣,如有冒犯请忽略该文![工具那个都是用,选你合适的,学习流行的]
> 3. 文中设计个别操作命令,不懂可以直接跳过,明白意思即可,等学会操作Git之后,你真的想在此了解Git与SVN的时候你会再回来的看的!
> 4. 本文选择性的记录了参考文献中的部分重点,想深入了解者可[阅读原文](http://blog.sina.com.cn/s/blog_765348af0102uyo9.html)并自行实践!

## SVN的优缺点
### 优点
1. 相比老版本控制系统(本地版本控制系统)而言,SVN最大的优点是解决了协同合作问题,让每个人在一定的程度上知道其他人的工作
2. 提交的Commit号是连续的,整个仓库中是唯一的
> Commit号是连续的:可以非常直观的就能看出提交记录的先后顺序
> Commit号是在仓库中唯一:相比CVS(每个文件都有各自独立的版本号)这是一个伟大的进入,意味着SVN可以实现事务提交

3. 拉取/更新代码,只能连接到唯一的版本库,取得最新数据[不用怀疑该仓库代码是不是最新]
4. 权限管理方便,能做到"精细"分配

### 缺点
1. 由于集中式版本控制系统只有一个中心服务器,最容易遇到的就是:中心服务器单点故障.
> 如果中央服务器磁盘发生故障，且没做过备份或者备份得不及时的话，还会有丢失数据的风险,最坏的情况是彻底丢失整个项目的所有历史记录,并且还不能保证所有的数据都已经有人提取出来(虽然分布式版本控制系统也不能保证所有数据都已经有人提取出来,但只要有一个人提取过最新数据,那么所有的提交与历史记录都可以简单快捷的进行恢复)

2. 提交、比较版本差异等都必须有网络连接[本地版本库只记录最近一次提交的状态];
3. 权限不支持分支继承;
4. SVN原理上只关心文件内容的具体差异--进行还原的时候需要反复计算差异得到结果[切换版本状态时慢,迁移版本库时工作量大]
5. SVN的工作区和版本库物理上分开，只能通过http、https、svn等协议访问"某一历史状态下的快照"
6. 服务器压力大，数据库容量暴增[因为SVN是采用复制克隆方式实现分支操作的]

## Git的优缺点
### 优点
1. 只要你愿意，你的"仓库"就是所有人的仓库--只要你开源
2. 从技术上讲:Git可能永远做不到类似SVN的路径授权(精细授权)--公司对代码库进行合理拆分,按库授权
3. 每一次提交都是对代码仓库的完整备份--快照模式==>Git在切换操作上能如此的"速度"
> - 正因为是快照方式存储,Git在切换操作上能如此的"速度",检出、比较任意版本等操作都可以看做是仅对两个指针的操作罢了
> - 正是因为每一次提价都是对仓库的完整备份,因此发生托管服务器故障的时候,只需要将其中一个最新的人的本地仓库复制作为裸仓库在修复了的服务器重现部署一次即可恢复所有的提交记录及数据

4. 工作区与本地仓库如影随行,不受"外界"干扰--你做你的,我做我的,必要的时候再提交到远程仓库合并更新
> 即使"断网","服务器故障期间"...你仍然可以继续在你本地提交、比较代码差异,等需要的时候再推送到服务器上让别人拉取合并你的代码即可!

5. Git使用SHA-1散列哈希值作为全球唯一版本号!这样的好处是什么呢?
> - 对于一个"分布式版本控制系统"是必要的,保证了每个人每次提交后的版本号都不会重复
> - 保证了数据的完整性:①Git的Commit哈希ID值是根据文件内容+目录结构计算出来的,能简洁的标明每个版本每个对象[文件、Commit对象]的变化;②该实现被设计在Git的底层,因此几乎是不可能绕过Git进行其他操作的

6. Git的工作模式非常的灵活,远不是SVN可比的[当然工作模式没有好坏,只有"最适合"]
> - Git可以在完全脱离Git服务器所在网络环境的情况下进行工作
> - Git提供变基操作,可以让你的修改提价历史,只保留有用的提交
> - Git可以肆无忌惮的使用分支进行功能/模块...的方式进行工作

### 缺点
1. 代码的保密性差,开发者可以克隆得到所有的代码和版本信息

## SVN和Git的区别
### 1. 版本库目录的区别:
> SVN的工作区中"每一个目录"都包含一个名为`.svn`的控制隐藏目录,Git只在工作区的根目录下有"唯一"的`.git`的子目录

#### `.svn`的作用:
> 1). 标识"当前工作区"和"版本库最近一次检出时"的状态关系
> 2). 包含了一份"检出时"的原始拷贝,当比较文件改动差异&&本地改动回退时,可直接参考原始拷贝进行操作不需要联网
> 3). 在目录下按文件搜索时,`.svn` 下的文件原始拷贝会导致多出一倍的搜索时间和搜索结果
> 4). `.svn`很容易在集成时引入产品中,从而导致Web服务器安全隐患
> 5). 由于每个目录下都包含了一个`.svn`,因此SVN可以将整个库检出到工作区，也可以将某个目录检出到工作区(对于一个庞大、臃肿的版本库用户来说，部分检出是非常方便的)

#### `.git`的作用:
> 1). `.git`目录就是"完整的版本库"本身,存放了所有的元数据与对象数据[一旦你删除,就是破坏了整个版本库],除了和其他人交换数据外
> 2). 因为存放了所有的元数据与对象数据,所以任何版本库相关的操作都在本地完成[本地操作,避免了冗长的网络延迟--速度快]
> 3). 版本库"可以"脱离工作区而存在,成为"赤裸"版本库--搭建git仓库(git init --bare),但是工作区"不可以"脱离版本库而存在
> 4). 由于`.git`只在根目录下有一个文件,因此Git在检出项目的时候,只能全部检出,不能按照目录进行部分检出[虽然Git有子模块、控制检出深度等方式,但是实现的成本都比SVN要大]

> 思考：因为`.git`是整个仓库的核心,破坏了`.git`就登录破坏了整个版本库,那么在使用Git管理资料时如何做到数据备份安全呢？
> ① 本地的数据镜像化:在A磁盘分区中创建"赤裸"版本库( --bare) ，然后在另B磁盘分区中克隆A中的版本库作为工作区,定时脚本把B工作区的提交定时的PUSH到A分区的版本库;从而备份数据
> ② 理解"`.git`目录就是完整的版本库本身"与"分布式版本控制系统"的内涵:你可以让其他人clone项目并按时pull备份

### 2. Commit版本号的区别
> SVN的版本号是从仓库的角度是全局唯一并且连续的,Git的版本号是40位十六进制字符串(SHA-1散列值)

#### SVN版本号
> 1). SVN的全局版本号较CVS的每个文件都独立维护一套版本号而言,是版本控制系统的一个非常大的进步，看似简单的进步实际标明：SVN开始提供支持"事务提交,原子操作"了
> 2)`.svn`的版本号是"连续"的,这样我们可以非常清晰直观的看出提交操作是第几次提交的,但这样也意味着我们可以预判到下一个版本号,从而进行一些其他的违规操作

#### Git版本号
> 1). Git的版本号是全球唯一的(SHA-1碰撞+数据长度一致的情况下才会有问题),Git每一次提交,会对"文件内容和目录结构"计算出一个SHA-1散列哈希值作为版本号
> 2). 下一个版本号几乎是不可能预判的,因此别有用心的人几乎很难针对下一个提交者的提交做手脚
> 3). Git一般使用从左面开始的7位字串作为简化版本号,只要该简化的版本号不产生歧义(只要不会出现重复的，你也可以使用更短的版本号)即可

> 可能有人了解过关于哈希碰撞问题,有兴趣可以看一下Git的解决方法：[How would Git handle a SHA-1 collision on a blob?](https://stackoverflow.com/questions/9392365/how-would-git-handle-a-sha-1-collision-on-a-blob/9392525#9392525)

### 3. 分支的区别
> SVN分支的是通过拷贝方式实现的,而Git实现分支的代价仅仅只是在`.git/refs/`目录下创建了一个对应文件并写入41个字符

#### SVN的分支实现
> 1). SVN的分支是通过`svn cp`命令实现的,即:带历史的拷贝
> 2). SVN的分支与分支之间没有完全"隔离":`svn cp`是一种廉价拷贝,即并不是拷贝所有数据，而是建立一个已存在目录树的入口

#### Git的分支实现
> 1). Git实现分支的命令:`git branch dev`,这就创建了一条分支
> 2). Git中的分支实际上仅仅是一个包含所指对象校验和的文件,例如master分支是在:`.git/refs/heads/master`中记录了其最新一次提交的Commit值
> 3). 综上所述,Git创建和销毁一个分支都非常的廉价(①新建一个文件;②写入41个字节：40位版本号+1个换行符)
> 4). Git的分支是完全隔离的,所有的关联都是通过"指针"的方式来进行关联的

> Git实现分支的成本非常的廉价,因此Git官方也极力的推荐我们使用分支进行开发协作,这也正符合了Git设计时所要满足的:可同时支持成千上万人协同工作

### 4. 识别提交操作的来源
> SVN不区分提交操作来源,而Git对于提交来源分析的非常清晰,所以:
> - 当你使用分支进行工作时,销毁分支时Git能快速清晰的知道你到底那些提交合并到了master,那些提交没有合并到master
> - 当你查看提交日志树的时候能清晰的看出那些是合并提交,那些是非合并提交

#### SVN无法识别提交来源
> 1). 由于SVN不会记录任何"合并操作",当你提交本地修改,版本库并不能判断改提交来源于`svn merge`还是你手工修改之后`svn commit`的,因此要区分你只能在提交信息上手动备注进行区分!

#### Git对于提交来源清晰分辨
> Git则可以很清晰的分辨出你的提交来源是:`git commit` 还是 `git merge` 亦或是`git pull`导致的merge提交
> 查看Git提交日志树上所有合并提交:`git log --merges`
> 查看Git提交日志树上所有非合并提交:`git log --no-merges`

### 5. 提交历史重写
> SVN不能重写提交历史,Git可以重写提交历史,让你只提交你想提交的历史

#### SVN不支持历史重写
> 1). 集中式版本控制系统都具有这个问题:一旦完成向服务器的数据提交,就没法从客户端追回，只能在后续提交中覆盖修正。因为大家都在同一个中心服务器上拉取/更新代码,如果不这样做其他人会经常发生冲突!
> 2). 因此,SVN的修改历史只能由管理员来进行完成,在服务端进行撤销和修改提交历史,而且这样的代价也是极大的
> 3). 但是也正是因为是集中式版本控制系统,SVN能修改任意节点的提交日志说明.

#### Git重写提交历史
> 1). Git是分布式的,代码库允许任意的修改和丢弃,可以使用:`git rebase` `git filter-branch` `git reset`等方式来实现修改和重构历史提交,且非常灵活
> 2). 相比SVN能修改任意节点的提交说明的灵活性来说,Git只能修改最后一个commit的信息，且修改后将产生一个新的提交(commit号会变)


**参考文献:**
- 《SVN与Git的比较》：[http://blog.sina.com.cn/s/blog_765348af0102uyo9.html](http://blog.sina.com.cn/s/blog_765348af0102uyo9.html)

转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)

扫描下方二维码，关注公众号，接收更多实时内容
![关注公众号：Leaders工作室](/images/article/WeChat/Leaders.png)