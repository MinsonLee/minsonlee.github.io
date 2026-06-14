---
layout: post
title: "01.Git的安装"
date: 2018-04-24
tag: Git
---

## 1. 写在前面的话
- **下载地址：**[Git官网](https://git-scm.com/)
- **参考资料：**[Pro Git](https://git-scm.com/book/zh/v2)

> 这里只介绍最简单的安装方法,本系列的重点不在"安装",如果你连Git的安装都不会,就先学最简单的并学会使用再去深究什么源码编译安装啥的吧！！！

## 2. 在Linux下安装Git
> 查看一下当前系统是否已经安装git:`git --version`,如果没版本信息即系统没有附带默认安装

### 2-1). 包管理工具直接安装
如果你是在CentOS/Fedora上安装,可以直接使用yum:
```sh
$ sudo yum install git
```
如果是在基于Debian发行版上,尝试用apt-get:
```sh
$ sudo apt-get install git
```
> - 如果全都不想在安装过程中修改任何东西,请直接在以上安装命令后方加上 -y 参数
> - 想了解更多Unix风格系统使用安装工具安装Git的,可以点击[传送门](http://git-scm.com/download/linux)

### 2-2). 源码编译安装
1. 找到你自己想安装的版本:[https://mirrors.edge.kernel.org/pub/software/scm/git/](https://mirrors.edge.kernel.org/pub/software/scm/git/)
2. 下载源码
```sh
$ wget -P <path> url/xxx.tar.gz # 下载你需要安装版本的tar包到指定目录[建议统一规范存放你电脑中下载的tar包]
```
3. 解压
```sh
$ tar -zxvf xxx.tar.gz -C <path> # 解压安装包到指定目录[同样建议规范统一存放]
$ cd <path/git-xxx> # 进入解压后的目录
```
4. 设置安装配置
```sh
$ ./configure --prefix=/你想安装到什么位置去
```
5. 安装
```sh
$ make && make install
```
6. 设置环境变量
```
$ echo "export PATH=$PATH:/git安装目录bin所在绝对路径">>/etc/bashrc # 还有其他的方式可以设置,自定百度
$ source /etc/bashrc # 重新加载一次bashrc文件使得设置生效
```
7. 验证是否安装成功
```sh
$ git --version # 有版本信息则证明安装成功
```


## 3. 在Mac下安装Git
1. 下载Git:[http://git-scm.com/download/mac](http://git-scm.com/download/mac)
2. 傻瓜式安装法

> 人穷没在Mac上安装过,如果客官用的是苹果自行百度一下吧,觉得本文有用顺便请打赏一下,哈哈哈～

## 4. 在Windows下安装Git
1. 点击[此处](https://git-scm.com/download/win)下载Git
2. "傻瓜式下一步安装法"安装即可！

`git update-git-for-windows` 可以直接一键式更新 Git 到最新版本。这是我觉得 Git 在 Windows 下操作最棒的了

## 5.基础设置
> Git是为了进行"协同开发"而设计的版本控制系统,那在使用前你总要告诉Git最基本的信息吧:你是谁？出了问题如何才能联系到你?

- **告诉Git:你是谁?**
```git
$ git config --global user.name "yourname"
```

- **告诉Git:你的联系方式?**
```git
$ git config --global user.email "youremail"
```

> 设置了以上最基本的信息之后,你已经可以正式开始使用Git了!