---
layout: post
title: "02.Git多平台换行符转换问题"
date: 2018-09-17
tags: [Git,疑难杂症]
---
## 背景
公司项目采用Vagrant进行统一开发环境,同事更新了项目配置文件,我进行了拉取,像往常一样`vagrant reload`,结果竟然报错了...

![line break error](/images/article/git/different-os-line-break.png)

年轻如我...对这个错误一脸懵逼.

![mengbi](/images/article/git/mengbi.jpg)

看不错啥报错信息,这个时候只能瞎JB乱猜了...难道是配置文件写错了?把配置文件看了一遍又一遍...还是没问题...把配置文件回退回去...哟嚯...回退回去竟然也不行啦?

拿着电脑找了公司一位对Vagrant深有研究的大佬看了一下...1秒就被指出了问题:看到`^M`就知道是你shell脚步的换行符错啦!

![mengbi](/images/article/git/mengbi.jpg)

啥?shell?换行符?我没改过启动脚步里面shell程序啊...

告知后,上网查阅了一下...原来如此：Git会根据用户所处平台将换行符进行自动转换【同时也告诉我：一个问题如果看了10分钟都没有头绪,虚心请教一下...也许别人点一下就通了】！

## 不同平台换行符问题
**文本文件所使用的换行符，在不同的系统平台上是不一样的**
- UNIX/Linux 使用的是 `0x0A（LF）`
- 早期的 Mac OS 使用的是 `0x0D（CR）`
- 后期的 Mac OS X 在更换内核后与 UNIX 保持使用`0x0A（LF）`
- 但是...唯独... DOS/Windows 一枝独秀,别出心裁,匠心独运,千年如一日的使用着` 0x0D0A（CRLF）` 作为换行符

## Git提交和检出时检查换行符
1. **跨平台协作开发是现实开发过程中常有的，统一的换行符就显得极为重要了！**
2. **当文本文件的换行符发生改变时，Git 会认为整个文件都被修改了，造成我们使用`git diff`之后根本看不出本次的修改是啥...**

> Git 作为目前最流行的版本控制管理系统,在设计时又怎么能不考虑这一点呢?因此你可以在提交和检出时对文件换行符进行判断

**1.设置:使用`autocrlf`设置是否要转为`CRLF`换行符**
- true: 提交时转换为 LF，检出时转换为 CRLF
- false: 提交检出均不转换
- input: 提交时转换为LF，检出时不转换

```sh
# 提交时转换为LF，检出时转换为CRLF
$ git config --global core.autocrlf true

# 提交时转换为LF，检出时不转换
$ git config --global core.autocrlf input

# 提交检出均不转换
$ git config --global core.autocrlf false
```

**2.如果设置`core.autocrlf false`,则`safecrlf`最好设置为`true`,该选项用于检查文件是否包含混合换行符**
- true: 拒绝提交包含混合换行符的文件
- false: 允许提交包含混合换行符的文件
- warn: 提交包含混合换行符的文件时给出警告
```sh
#拒绝提交包含混合换行符的文件
$ git config --global core.safecrlf true   

#允许提交包含混合换行符的文件
$ git config --global core.safecrlf false   

#提交包含混合换行符的文件时给出警告
$ git config --global core.safecrlf warn
```

## 解决方案
> 按照上面方法进行设置，是从以下两种方式保证了换行符的正确!
> - `core.autocrlf`保证了检出和提交的时候对换行符统一处理
> - `core.safecrlf`保证在提交至远程服务器的时候二次保证换行符统一
>
> 但是你不能保证所有人都按照这个方式去设置了自己的`git config`,如果有人不按照这个方式来做，那么...就会导致文件在检出/更新的时候,由于换行符的问题，文件会被视为整个被修改，无法使用`git diff`进行对比出两次的修改...
>
> 是否可以强行的设置一种方式，在检出和提交的时候都强制的对换行符进行转换?并且能将这种强制方式同步到远程仓库让所有人在拉取更新的时候也收到该约束?

**使用自定义Git属性,强制使用LF换行符**
```sh
# 进入项目根目录,创建.gitattributes文件
$ touch .gitattributes
# 定义git属性,强制使用LF作为项目换行符,并强其同步至远程仓库
$ vi .gitattributes
# 键入: `*.sh text eol=lf`
```


转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)

扫描下方二维码，关注公众号，接收更多实时内容
![关注公众号：Leaders工作室](/images/article/WeChat/Leaders.png)