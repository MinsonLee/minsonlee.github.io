---
layout: post
title: "如何利用 VSCode 远程开发？"
date: 2022-02-26
tags: [Tools,Editor,VSCode]
---

文章来源于公众号「奇伢云存储」大佬的文章 [《VSCode 阅读 Linux 代码怎么才不卡顿？这样做才能快的飞起！》](https://mp.weixin.qq.com/s/pNdiDyAAOvMh7KfvNNj1Mg) 的一部分，由于自己在实操过程中遇到一点小问题，记录一下。大家感兴趣的可以去阅读一下原文。

## 本地环境配置

根据自己系统去 [VSCode 官网](https://code.visualstudio.com/Download) 自行下载安装包并进行安装即可。

### 安装 VSCode

安装 VSCode 过程就不介绍了，安装完毕首次运行 VSCode 的时候会提示你安装中文语言扩展，可自行选择，配图是中文版，但中英版本差别不大。

### 安装 Remote-SSH

首先，安装 Remote-SSH 扩展，安装方式如下图【后文中提到的扩展安装步骤都如下图，不再放安装配图】：

![VSCode Install Remote-SSH](/images/pig/vscode-install-remote-ssh-pkg.png)

安装完成会有两个扩展【一个是 SSH 连接终端，一个是 SSH 配置 JSON 文件的扩展】，且左下角会出现 `><` 样式的符号：

![VSCode Install Remote-SSH Successed](/images/pig/VSCode-install-Remote-SSH-success.png)

### 配置 SSH config

Remote-SSH 扩展使用 OpenSSH 的方式进行连接远程主机的，可以通过 ssh_config 配置 SSH 连接主机信息。

方法一：通过 VSCode Remote-SSH 连接主机时配置。具体操作如下图：

![Create ssh_config by VSCode Remote-SSH](/images/pig/config-remote-ssh.gif)

方法二：直接编辑 `~/.ssh/config` 或 `/etc/ssh/ssh_config` 文件(没有就自己创建一个)，然后按照下属格式配置即可.

```config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
# SSH 密码登录命令 : ssh -l <user> hostname -p <pwd>
# SSH 密钥登录命令 : ssh -l <user> hostname -i <identity_file>

# 配置 Host <name> 然后就可以通过 ssh <name> 方式进行登录.(简化输入信息)
Host dev_web
    # 设置 IP 或 HostName(即:Domain . IP 和 Domain 在 hosts 文件中指定就好)
    HostName 10.4.xxxxx
    # login name 登录用户
    User xxxx
    # 连接端口
    Port 6xxx
    # 私钥路径:若配置了密钥登录，可免密登陆.比较方便
    IdentityFile "~/.ssh/id_rsa"
```

到此，本地环境就算是配置好了。 SSH config 文件的具体配置选项可以[点击此处](https://linux.die.net/man/5/ssh_config)查看.

## 远程主机配置

如果你只是想在 VSCode 中单纯浏览、编辑文件，我们已经可以点击 VSCode 左下方的 `><` 按提示操作就可以连上远程主机了。

VSCode 会在远程主机的 `~/.vscode-server` 目录下保存你在远程主机上安装的 VSCode 扩展和配置信息。

注意：本地的 VSCode 扩展是不会被同步加载到远程主机上的。因此，如果你需要一些其他的扩展，那么你需要在连接上远程的 VSCode 窗口中重新的安装配置即可。

### 安装 GNU GLOBAL

`GNU GLOBAL` 是一个阅读 Linux 内核源码阅读标记工具，可以实现代码的标记、跳转等功能。

先用 root 身份（或有 sudo 权限的身份）登录，安装 `global`

```shell
# Ubuntu 系统
apt install -y global
# CentOS 系统
yum install -y global
```

安装完之后会在 `/usr/bin` 或者 `/usr/local/bin` 目录下有 `global`、`gtags` 可执行文件。

### VSCode 安装远程主机扩展 C/C++ GNU Global

在确保自己是在连接到远程主机的 VSCode 窗口中搜索 `C/C++ GNU Global` 扩展，然后点击 `安装` 即可.

![VSCode Install C/C++ GNU Global In remote ](/images/pig/20220226011507.png)

### 配置 Global

如下图步骤打开 远程SSH 的配置文件 `setting.json`，将下列信息配置到文件中。

![How to open setting.json](/images/pig/vscode-open-remote-ssh-config.png)

```json
{
    "gnuGlobal.globalExecutable": "/usr/bin/global",
    "gnuGlobal.gtagsExecutable": "/usr/bin/gtags",
    "gnuGlobal.objDirPrefix": "/home/lms/.global"
}
```

`gnuGlobal.objDirPrefix` 目录用于给 Gtags 存储数据用的，但需要用户手动创建（这个路径不一定要跟我的一样，可随便）。

`global`、`gtags` 的所在路径可以通过 `type global gtags` 得到.

![How to get global and gtags path?](/images/pig/get-global-and-gtags-path.png)

**注意："gnuGlobal.objDirPrefix" 的路径必须要手动创建好，如果不存在，会导致后续 Rebuild 的失败。**

点击 VSCode 顶部的 `查看` 调出 `命令面板`，输入 `> Global: Show GNU Global Version`，如果右下角出现 `global (GNU GLOBAL) x.x.x` 的字样就表示安装配置成功了。

同样方式，通过命令面板，输入：`>Global: Rebuild Gtags Database` 创建索引，然后就可以用 VSCode 来阅读你从 Github 上拉下来的 Linux 的内核源码文件了。

-----

例如：我要阅读和编辑的是 PHP 的代码，所以安装了 `PHP Intelephense` 扩展就可以，至于你需要在 `setting.json` 文件中配置什么？？你安装完扩展，会自动提示你要配置什么信息的。

这样，我们就可以通过 文件>打开文件夹 随意查看远端的代码了。
