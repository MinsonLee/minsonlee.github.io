## 查看版本
```sh
git --version
```

## 更新客户端版本
### Windows 
![image](678C2404D42E447CAABBFB42441AB19B)
> 旧版本使用 `git update` 新版本需要使用 `git update-git-for-windows`

### Linux
> 除了Ubuntu可以通过 `apt upgrade` 的方式获取到最新的镜像源（见文章最后），貌似其余的发行版只能通过源码覆盖安装

#### 1.访问`https://github.com/git/git`，查看当前 git 最新版本
> 如图所示，当前 `2020-04-28` 查看最新版本为 `v2.26.2`

![image](213426CDA3A541848D20EEFC404CC2BC)

#### 2. 下载对应版本源码包
```sh
# 更换链接中的版本即可
sudo wget https://github.com/git/git/archive/v2.26.2.tar.gz -O git.tar.gz
```

#### 3. 解压
```sh
# 解压
sudo tar -xf git.tar.gz
# 进入解压后的文件夹
cd git-* # 我下载的2.26.2，因此我进入的是 git-2.26.2
```

#### 4. 编译生成工程文件
```sh
sudo make prefix=/usr/local all
```

编译生成工程文件时，可能会遇到些报错，自行谷歌解决，然后重新执行上述编译命令：
1. `openssl/ssl.h: No such file or directory`
```sh
    CC fuzz-commit-graph.o
In file included from commit-graph.h:4:0,
                 from fuzz-commit-graph.c:1:
git-compat-util.h:297:10: fatal error: openssl/ssl.h: No such file or directory
 #include <openssl/ssl.h>
          ^~~~~~~~~~~~~~~
```

- Ubuntu系统执行以下命令：`sudo apt-get install libssl-dev`
- CentOS系统执行以下命令：`sudo yum install openssl-devel`

2. `zlib.h: No such file or directory`
```sh
    CC fuzz-commit-graph.o
In file included from commit-graph.h:7:0,
                 from fuzz-commit-graph.c:1:
cache.h:21:10: fatal error: zlib.h: No such file or directory
 #include <zlib.h>
          ^~~~~~~~
```
- Ubuntu系统执行以下命令：`sudo apt-get install zlib1g-dev`
- CentOS系统执行以下命令：`sudo yum install zlib-devel`

3. `curl/curl.h: No such file or directory`
```sh
In file included from http.c:2:0:
http.h:6:10: fatal error: curl/curl.h: No such file or directory
 #include <curl/curl.h>
          ^~~~~~~~~~~~~
compilation terminated.
Makefile:2387: recipe for target 'http.o' failed
```
- Ubuntu系统执行以下命令：`sudo apt-get install libcurl4-openssl-dev`
- CentOS系统执行以下命令：`yum -y install curl-devel`

4. `tclsh failed; using unoptimized loading`
```sh
 * new locations or Tcl/Tk interpreter
    GEN git-gui
    INDEX lib/
    * tclsh failed; using unoptimized loading
    MSGFMT    po/de.msg Makefile:252: recipe for target 'po/de.msg' failed
make[1]: *** [po/de.msg] Error 127
Makefile:2078: recipe for target 'all' failed
```
- Ubuntu系统执行以下命令：`sudo apt-get install gettext`
- CentOS系统执行以下命令：`yum -y install curl-devel`

5. /bin/sh: cc: 未找到命令

没有安装 gcc 导致， `yum install gcc-c++ -y`

#### 5. 安装
```sh
sudo make prefix=/usr/local install
```

#### 6. 验证安装结果
```sh
git --version
```

### Ubuntu 系列更新
> Git 官方文章中对于Linux下安装有一段介绍：https://git-scm.com/download/linux
>
> For Ubuntu, this PPA provides the latest stable upstream Git version.

简单来说就是：PPA 提供 Git 最新的稳定版本.

> 安装 add-apt-repository 命令 ： https://www.myfreax.com/how-to-add-apt-repository-in-ubuntu/

```sh
# 为 Git 添加 PPA 镜像源
sudo add-apt-repository -y ppa:git-core/ppa
# 拉取可更新镜像源列表
sudo apt-get update
# 查看可更新列表
apt list --upgradable
# 安装 git
sudo apt-get install git -y
# 更新 git
sudo apt upgrade git
```
- 参考阅读：[什么是PPA?](https://imcn.me/ppa)

### MacOS
```sh
brew update && brew upgrade git
```