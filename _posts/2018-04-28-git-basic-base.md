---
layout: post
title: "04.Git基础操作"
date: 2018-04-28
tag: Git
---

## 背景
> 其实工作中,你只需要掌握最基础的Git的使用即可了,你可以完全不理会Git的原理啥的,只是掌握了会更好,但一般只需要掌握以下几点,已经可以顺利完成工作了:

1. 第一次,如何将生成的SSH公钥`配置`到Github或自己公司搭建的GitLab服务器上?
2. 如何开展工作:`克隆`-->以此为基础`创建/切换`到你自己"地盘"-->`修改`你工作区的资料-->`标记确认`修改-->`提交`修改到本地仓库-->`合并`你地盘到master分支去-->`拉取/合并`远程仓库的最新情况-->将最后合并了他人的资料一起`推送`到远程仓库

**学习工具类的使用,没有什么比直接动手操作更加高效!!!什么原理、什么基础...都别说,先动手干!**

## 初始配置
> 一般公司内部项目都会要求使用SSH协议进行传输的!

### 公私秘钥对
> - Linux系统使用Git时会默认会到`/home/user/.ssh`目录读取私钥
> - Windows系统使用Git时会默认会到`c:\\User\username\.ssh`目录读取私钥
> - 读取的私钥文件权限至少要只读:Linux系统下至少要`0666`级别;Windows至少要可读

#### 生成秘钥对
```sh
$ ssh-keygen -t rsa -C "youemail@email.com"
```
![how to creat a ssh-key](/images/article/git/how-to-creat-ssh-key.png)

#### 赋权限
```sh
$ sudo chmod -R 0666 /home/user/.ssh
```

#### 添加公钥到Github/GitLab
![add ssh-key to github/gitlab](/images/article/git/add_ssh_key_to_server.gif)

#### 测试秘钥是否可用
```sh
$ # 验证秘钥是否在Github上可用
$ ssh -T git@github.com
$ # 验证秘钥是否在GitLab上可用
$ ssh -T git@gitlab.com
```
![verify ssh-key for github/gitlab](/images/article/git/verify_ssh_key_for_server.gif)
> - `id_rsa`为私钥文件【私钥是存放字个人电脑上即可的】
> - `id_rsa.pub`为公钥文件【公钥添加到Git服务器上的,添加完即使删掉也可以,但建议留作备份】
> - `known_hosts`用于保存你本机SSH验证通过的服务器信息

#### 配置使用指定私钥
```sh
$ # 亲测可行,BD了很多...天下文章一大抄...
$ vi ~/.ssh/config # 将以下代码写入,注释去掉

# 指定github使用的私钥
Host github.com
    HostName github.com[或者这里填写github的IP]
    IdentityFile /github-private-secret-key-path[指定私钥绝对路径]

# 指定gitlab使用的私钥
Host gitlab.com
    HostName gitlab.com[或者这里填写gitlab服务机的IP]
    IdentityFile /gitlab-private-secret-key-path[指定私钥绝对路径]
```

## 基本操作

### 设置用户基本信息
```sh
$ git config --global user.name "yourname" # 设置用户名
$ git config --global user.email "youremail@email.com" # 设置用户联系方式
```

### 1. `克隆`仓库
```sh
$ git clone gitserver-url/project.git [test-project] # 将仓库克隆到本地test-project目录
```
**默认是当前路径以`xxx.git`中的`xxx`为路径,因此[test-project]是不必填写的**

### 查看当前Git的情况
**如果你修改了资料不知道下一步要干嘛,时刻查看当前Git的情况,git会告诉你下一步该干什么了!**
1. 它会告诉你当前在什么分支?
2. 它还可能会告诉你当前分支与远程那个分支进行了关联追踪,如果没有就不会说明,因为你要明白Git是分布式的,对于它来说其实是没有"服务端"的
3. 如果你修改了资料:它会告诉你当前工作区你修改了那些资料?这些资料你是否已经"确认修改"了?你要怎么"确认修改"?
4. 如果你已经确认过文件:它会告诉你那些文件你已经确认过了?如何撤销你刚刚"确认"过的那部分资料?
```sh
$ git status
```
![show the index by git status](/images/article/git/git-status.png)

### 2. `创建&&切换`地盘==>分支
1. **一般克隆下来的分支默认都是master分支,且已经默认将本地master分支和远程master分支做了关联**
2. **但我们一般不直接在master分支上做修改的,而是创建一个其他类型分支,在这个分支上进行完成修改,没有问题了再将当前分支合并到master分支中去**
```sh
$ git checkout -b test-branch
$ # 你可以通过以下命令看你创建了多少个分支
$ git branch
```

### 3. `修改`资料
> 随便你,你现在在自己分支上,克隆下的资料就是你自己的,你喜欢怎么该就怎么改!

### 4. `标记确认`修改==>添加到`暂存区`
**"确认修改"(即:添加到暂存区,如果这里不懂继续看下去,看完之后百度一些版本控制系统,百度百科看看概念,里面有介绍)是Git和SVN的区别,这个过程相当于一枚"后悔药",所有你修改过的资料的所有`部分`都会在此帮你暂时存放着,你确认过了没有问题才会被提交到本地仓库中**

```sh
$ # 将工作区中的修改添加到`暂存区`
$ git add /file-path # 你可以使用通配符将文件批量添加

$ # 将工作区中的修改全部添加到`暂存区`
$ git add . # 使用这个不是一个好习惯,因为可能会把一些不用添加的修改都加到暂存区去了,所以使用前要确认好,不要添加一堆垃圾文件进去
```

### 5. `提交`确认到本地仓库
**注意：此处的提交只提交你已经确认过的那部分修改内容,例如:A文件,修改了2处地方,我只`标记确认`了其中一处地方,另一处修改后还没标记,那么`后面`没标记修改的那一处不会被提交!**
```sh
$ git commit -m "填写你的提交备注,简洁明了"
```

### 6. `合并`你的分支到"指定分支(master)"
**现在你已经在你的分支上完成了工作了,你需要将你的工作和别人的工作合并然后推到服务器上,让别人去同步,因此:**
- 你需要`切换`(注意:此处是切换,并没有创建)到`指定分支`,因为你等下是要将`指定分支`推到服务器上
- 然后合并你刚刚自己工作的那个分支`test-branch`

```sh
$ # 切换到指定分支`master`
$ git checkout master

$ # 将你自己的工作合并进来`test-branch`
$ git merge test-branch -m "你的合并备注,例如:merge test-branch into master"
```

### 7. `拉取/合并`远程仓库上别人的工作
**你修改合并了你的工作,但是可能在你修改合并的时间里,已经有其他人将工作合并并且推送到服务器上了,所以你肯定需要将别人的工作一起拉取下来,并合并后,再推送到服务器上才合理,不然你的推送在不包含别人工作的情况下强制推送到服务器上去,那...你等着被叼吧**
```sh
$ # 拉取/合并远程仓库中master分支的最新情况
$ git pull origin master # 如果你没有该远程仓库名字,那么默认是用origin命名的
```

### 8. 将最终结果`推送`到远程
```sh
$ # 将本地的master:(推送)到远程origin的master分支
$ git push -u orgin master:master # -u 参数是为了设置分支关联,关联成功后,以后的推送就可以直接`git push`即可
```


## 思考
1. 怎么将创建的个人分支推到远程服务器上,并在远程仓库上建立一模一样的分支呢?
2. 如何检出一个指定的节点呢?
3. 如何查看、重命名、删除一个分支呢?
4. 如何查看别人还有自己的提交历史记录呢?

> 使用GUI工具都会帮你解决掉以上的问题,即使你不再继续深入学习,我想工作应该不成问题了!

**推荐阅读**
- [廖雪峰的官网:Git教程](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)

**如果你是刚刚学习Git,比较建议你停下实际动手操作使用一下Git,如果你使用Git时间不久,比较建议你把前面的推荐阅读都看一下,然后继续回来看一下后面的内容!!!**