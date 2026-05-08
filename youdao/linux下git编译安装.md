# Linux下Git编译安装

[TOC]

## 安装

```sh
# 安装依赖：zlib.h: No such file or directory
# Ubuntu 下 apt-get install zlib-devel
yum install gcc-c++ make curl-devel openssl-devel -y

# 下载最新的Git源码： https://mirrors.edge.kernel.org/pub/software/scm/git/
curl -L "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.29.2.tar.gz" -o /tmp/git.tar.gz

# 解压
cd /tmp && tar -zxf git.tar.gz

# 进入
cd git-2.29.2

# 创建git安装目录
mkdir -p /apps/git

# make configure 
./configure --prefix=/apps/git

# 编译安装
make install

# 将git二进制文件到软链到/usr/local/bin目录下，便于全局使用
ln -s /apps/git/bin/git /usr/local/bin/git

# 检验是否安装成功，打印 Git Version
git --version
```

## 通过包管理工具安装

```sh
# Deepin/Ubuntu 也可以通过下列命令直接安装
apt-get update # 更新安装源
apt-get install git # 安装git
git --version #查看是否安装版本信息

# CentOS 安装
# 查看是否已经安装，及版本
git --version

# 移除旧版本
sudo yum remove git
sudo yum remove git-*

# 添加 End Point Package Repository（为 RHEL 系列的 Linux 系统提供高质量 RPM 软件包的一个社区项目）
# https://packages.endpointdev.com/
sudo yum install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm

# 安装新版
 sudo yum install -y git
```

## 自动补全`git`命令

1.  下载 `git` 命令补全配置

```sh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o /apps/git/git-completion.bash
```

1.  设置 `~/.bashrc` 用户登录自动加载 `git-completion.bash`

```sh
if [ -f /apps/git/git-completion.bash ]; then
    . /apps/git/git-completion.bash 
fi
```

1.  重新加载配置，使其立即生效

```sh
source ~/.bashrc
```

## 更新 Git 版本

<https://git-scm.com/download/linux>

## 创建密钥对

    $ ssh-keygen -t rsa -C "youremai@email.com"

详情可以点击[此处](https://help.github.com/articles/connecting-to-github-with-ssh/)

### 测试密钥是否生效

    ssh -T git@gitlab.com -- 测试连接gitlab
    ssh -T git@github.com -- 测试连接GitHub

### 报错：'id\_rsa' are too open

    $ ssh-add id_rsa
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @       WARNING: UNPROTECTED PRIVATE KEY FILE!       @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    Permissions 0777 for 'id_rsa' are too open.
    It is required that your private key files are NOT accessible by others.
    This private key will be ignored.

```sh
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0666 for '/home/lms/.ssh/id_rsa' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
Load key "/home/lms/.ssh/id_rsa": bad permissions
git@niubibi.easyrentcars.com: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

从报错信息：`Permissions 0777 for 'id_rsa' are too open.` `This private key will be ignored.`看出，我们需要修改该私钥文件权限，不能过于开放该文件权限，否则Linux会忽略掉这个私钥文件【在windows中不会有这个问题】

### 解决措施

    # sudo chmod 0600 id_rsa

即可！

## 修改 Git 默认的编辑器为 vim

在 WSL 中安装了 Git，发现其默认的编辑器为 nano 而不是我熟悉的 vi/vim。

```sh
git config --global core.editor vi
```

如上命令就会在 \~/.gitconfig 文件末端加上一个配置，如下图：

![change Git default editor](https://minsonlee.github.io/images/pig/change-git-editor.png)
