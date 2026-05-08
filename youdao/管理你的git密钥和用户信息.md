# 管理你的 Git 账号信息

[TOC]

我们使用 `git clone` 代码的时候基本就两种方式： HTTP(S)、SSH

*   HTTP(S) : 私人项目需要手动输入用户名和密码，而公开的项目是可以直接下载无需账户信息的。

![git clone with https](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20220320003007.png)

*   SSH : 不管是公有还是私有的项目，都需要你配置正确的公司要密钥对（引申踩过的一个坑：你添加 Git 子模块时应该用哪种协议？怎么选择呢？），否则就会报错：`fatal: Could not read from remote repository. Please make sure you have the correct access rights and the repository exists.`

一般情况下，我们都是推荐走 SSH 方式进行拉取、推送项目的。但有些特殊情况，可能不能用 SSH 协议，只能走 HTTPS 方式进行项目的拉取、提交。

本文会介绍如何统一管理两种方式的账号信息

## 管理你的 Git SSH 密钥和用户信息

正常情况下，我们的 Git 项目只需要一个密钥对即可了，但有些情况下不得不要用到多个密钥对。

如：部分公司为了管理员工的权限问题会统一分发办公的密钥对、我们需要针对不同的项目组使用不同的密钥对。

我们要怎么让 Git 自动针对不同的项目使用不同的邮箱、用户、密钥验证呢？？

如何生成密钥对？这里就不细说了，可以查看对应链接阅读详细操作：[Gitee 生成添加SSH公钥](https://gitee.com/help/articles/4181) 或 [Adding a new SSH key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) 或 [Add an SSH key to your GitLab account](https://docs.gitlab.com/ee/ssh/index.html#add-an-ssh-key-to-your-gitlab-account)。

我们添加了密钥对后可以通过 `ssh -T git@<host> [-i <ssh-key-path>]` 方式验证是否添加成功。可以手动通过 `-i` 参数指定要使用的私钥，但是每次都指定也挺烦人的。

从验证密钥对的方式，可以看出 `git clone git@<repository>` 走的其实也是 SSH 协议的方式。

### 密钥对的管理

密钥对的配置走的和 SSH 设置是同一个文件：`~/.ssh/config` 或 `/etc/ssh/ssh_config`。

```config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
# SSH 密码登录命令 : ssh -l <user> hostname -p <pwd>
# SSH 密钥登录命令 : ssh -l <user> hostname -i <identity_file>

# 配置 Host <name> 然后就可以通过 ssh <name> 方式进行登录.(简化输入信息)
Host github
    # 设置 IP 或 HostName(即:Domain . IP 和 Domain 在 hosts 文件中指定就好)
    HostName github.com
    # login name 登录用户：Git 的话用户固定就是 git
    User git
    # 连接端口
    #Port 6xxx
    # 私钥路径:若配置了密钥登录，可免密登陆.比较方便
    # 可以针对不同的服务器配置不同的密钥对
    IdentityFile "~/.ssh/github_id_rsa"

Host myGitee
    HostName gitee.com
    User git
    IdentityFile "~/.ssh/gitee_id_rsa"
```

**！！！注意：配置之后，以现在我们需要拉取 `git@gitee.com:minson-lee/personal-config.git` 为例**

*   我们拉取的命令：`git clone git@myGitee:minson-lee/personal-config.git` 而不是 `git clone git@gitee.com:minson-lee/personal-config.git`
*   SSH 登录的时候也是同理：`ssh -T myGitee` 即可，如果你不想改变输入的 clone 地址，那么在配置文件的 `Host` 处改变输入即可
*   若通过 `git clone git@myGitee:minson-lee/personal-config.git` 的项目，查看 `git remote -v` 看到的远程仓库地址也是 `git@myGitee:minson-lee/personal-config.git` 而不是 HostName 的值

### `.gitconfig` 配置用户、密钥信息

通过 `git var GIT_AUTHOR_IDENT` 可以打印当前用户的身份信息，格式如：如：`Name <email> 1647749970 +0800` 。

```shell
lms@lms:~$ tree -a
.
├── .gitconfig
├── gitconfig
    └── gitconfig_erc
```

我的 `~/.gitconfig` 和 ` ~/gitconfig/gitconfig_erc` 配置简化如下：

```.gitconfig
# ~/.gitconfig

[user]
        name = MinsonLee
        email = lms.minsonlee@gmail.com
        
# 如果在 /tmp/work 目录下的项目，则使用下方 path 路径的配置文件覆盖上述配置
[includeIf "gitdir:/tmp/erc/"] 
    path = ~/gitconfig/gitconfig_erc
```

```.gitconfig
# ~/gitconfig/gitconfig_erc
[user]
    name = "limingshuang" # 设置用户名
    email = "limingshuang@zuzuche.com" # 设置邮箱
[core]
    sshCommand = ssh -i ~/.ssh/erc #指定work使用的密钥
```

![gitconfig 配置多用户名&&密钥](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20220320130726.png)

**注意：`includeIf "gitdir:/tmp/erc/"` 是需要在该目录下的 Git Project项目下才会使用 Path 目录的配置文件进行覆盖。**

## 管理你的 Git HTTPS 账户信息

### Windows 用户通过 HTTPS clone 项目

如果你是 Windows 用户，那么在你第一次使用 HTTPS 拉取私人项目时 `git clone https://<you-gitlab-host>/<group>/<project>.git` 一定会陆续弹出一个提示框让你输入账号/密码（此处输入的是你登录公司 GitLab 系统的账号和密码），它应该是长这个样子：

![Git For Windows](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/Git-For-Windows.png)。

如果你安装了 `Git Credential Manager for Windows` 那么它可能长下面这个样子：

![Git-Credenial-Manager](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/Git-Credenial-Manager.png)。

这样当你输入过一次账号密码之后，你输入的账户、密码信息可以在：`控制面板\所有控制面板项\凭据管理器\Windows 凭据`下方找到对应的信息，后续对该项目的操作就可以不用再输入用户名和密码了。

![windows-credential-manager](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/windows-credential-manager.png)

### Linux 用户通过 HTTPS clone 项目

如果你是 Linux 用户，那么在你第一次使用 HTTPS 拉取私人项目时，看到的界面应该是如下这样：

![git clone project by https on linux](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/git-clone-by-https-on-linux.png)

### 管理 HTTPS 账户信息

Git 的 HTTPS 的账户信息存储方式可以通过 `git config --global credential.helper` 进行查看账户管理方式

*   `manager-core`

*   `cache`（默认方式）：

*   `store`

*   <https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E5%87%AD%E8%AF%81%E5%AD%98%E5%82%A8>

*   <https://blog.miniasp.com/post/2016/02/01/Useful-tool-Git-Credential-Manager-for-Windows>

*   <https://cloud.tencent.com/developer/article/1838887>

*   <https://blog.51cto.com/idotest/2998460>

