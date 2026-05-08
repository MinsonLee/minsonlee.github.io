# Windows Subsystem for Linux (WSL)

[TOC]

`WSL` 的全称是 `Windows Subsystem for Linux`，简单来说就是：运行在 `Windows` 系统上的一个 `Linux` 系统。对于工作高度依赖 `Windows` 但又想玩或学习 `Linux` 的朋友来说简直是一个福音。

最初版本的 `WSL 1` 只能是一个运行在 `Windows` 系统上的高仿真 `Linux` 系统，因此网上对 `WSL` 所谓的兼容性整体评论都比较低。

而 `WSL 2` 是一个全新的升级版本，它实现了在 `Windows` 系统上运行完整的 `Linux` 内核，实现了对 `ELF64 Linux` 二进制文件的完整支持，**提高文件系统性能**，以及添加**完全的系统调用兼容性**。


![wsl-Comparing-WSL1-and-WSL2.png](3D43D95026D247259D887F1E03DCE02C)

从上述比较表中可以看出，除了跨操作系统文件系统（即：`Windows` 和 `Linux`之间相互进行文件读写）的性能外，`WSL 2` 体系结构在多个方面都比 `WSL 1` 更具优势。而这一劣势最主要的：`WSL 2` 的底层是一个跑在`Hyper-V`上的**完整**的`Linux`系统，文件的传输需要走`网络I/O`进行传输，而不是像`WSL 1`一样是穿着`Linux` 的外衣和`Windows`打交道的系统。

> WSL 1 和 WSL 2 的比较：https://docs.microsoft.com/en-us/windows/wsl/compare-versions

## 安装 WSL2

### 查看系统版本

![Update to WSL2 Requirements](56211CDAD8CA4A11BDA053B1B8DD9CF7)

即：最新的 `WSL 2` 特性要求在 `Windows 10 x64 Version 1903` 及以上版本的系统或 `ARM64 systems: Version 2004` 及以上版本的系统。

我们可以通过 `Win+R` 输入 `winver`，即可查看到当前自己 `Windows` 版本信息：

![winver](058D8D402EB24A809427915C5FB06B8B)

若你的系统版本低于安装要求中的指定版本，可以使用 [`Windows` 更新工具：`https://www.microsoft.com/zh-hk/software-download/windows10`](https://www.microsoft.com/zh-hk/software-download/windows10) 进行更新。

部分过于低级的版本进行升级的时候可能会遇到的问题：[`Windows 1909`升级失败问题 `https://www.win10gw.com/win10wenzhang/6507.html`](https://www.win10gw.com/win10wenzhang/6507.html)

### 安装 WSL 并升级到 WSL2


**下列命令都需要使用管理员身份运行`PowerShell`，运行下列脚本！！！**

1、安装`WSL`：开启系统对`Windows-Subsystem-Linux`支持特性

```sh
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

2、升级`WSL2`-开启Windows的虚拟平台特性

```sh
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**升级完毕之后，需要重启计算机！！！**

3、安装补丁包

查看系统类型，在 `PowerShell` 中输入 `systeminfo` 查看 `System Type` 选项的值即可。如下图，我是 `x64` 的版本：

![systeminfo](F2B6AFE9068247969B6DE53490FD5E6A)

- [WSL2 Linux kernel update package for x64 machines](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
- [WSL2 Linux kernel update package for ARM64 machines](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_arm64.msi)

此处只需要傻瓜式下载双击安装对应补丁包即可。

4、设置默认通过 `WSL2` 方式安装 `Linux`系统

要使用管理员身份运行`PowerShell`，运行下列脚本：

```PowerShell
wsl --set-default-version 2
```

如果你之前已经通过 `WSL1` 安装了 Linux，现在想转为`WSL2`运行，可参考：[此处](https://docs.microsoft.com/en-us/windows/wsl/install-win10#set-your-distribution-version-to-wsl-1-or-wsl-2)

```sh
wsl --set-default-version <version num>
```

![image](4EC649BD5CC54A35A95E67EC3380B7EF)

5、安装 Linux 子系统

在`Microsoft Store`上搜索一个你自己喜欢的子系统进行安装

![Microsoft Store Result for search Linux](55BE8FABF7F34A06823F57D78D8F776F)

打开`PowerShell`，输入`wsl -l -v`可以看到你的子系统运行版本

![wsl -l -v](48271B360FF1485F985618DCB8A4403A)

## 解决WSL2中Vmmem内存占用过大问题
1. Windows + R 调出运行窗口，输入 %UserProfile% 打开当前用户的根文件夹
2. 新建文件 .wslconfig，写入下述配置（限制内存使用上限）

```txt
[wsl2]
memory=4GB
swap=0
localhostForwarding=true
```
3. 通过 Powershell 键入 `wsl --shutdown` 重启子系统

## 重启 WSL 系统

更改了 `WSL` 中的系统信息，如果你只是想单独的重启 `WSL` 系统，使用管理员身份打开 `PowerShell` 执行下列命令即可。

```powershell
Get-Service LxssManager | Restart-Service
```

## 安装`Windows Terminal`

`Windows`的命令行向来是以丑著称，`Windows Terminal`总算是挽救了一点它的颜值。

![Windows Terminal](25D3EA0854CA43489FAE088BEB451A51)

- 安装：https://github.com/microsoft/terminal
- 使用指南：https://docs.microsoft.com/zh-cn/windows/terminal/customize-settings/global-settings
- [如何给 Windows Terminal 增加一个新的终端](https://blog.csdn.net/WPwalter/article/details/100159481)

1. 下述是我将`Git-Bash`添加到`Windows Terminal`的配置

```json
{
    // guid 可以通过网上查询 guid 生成器生成：http://tool.pfan.cn/guidgen
    "guid": "{ce7a80b8-da75-4628-a2e1-663af0f3ce7c}", // 终端唯一标识号，用于设置`defaultProfile`-默认打开哪个终端
    "name": "Git Bash", // 终端名称
    "icon": "C:\\Self\\code\\CVS\\Git\\git-for-windows.ico", // 终端ICON图标路径
    "commandline": "C:\\Self\\code\\CVS\\Git\\bin\\bash.exe --login -i", // 终端所在绝对路径
    "startingDirectory":"D:\\htdocs", // 打开终端默认打开路径，如果为null则默认上一次退出时路径
    "hidden": false, // 是否隐藏不展示
    "useAcrylic" : true, // 是否使用磨砂效果
    "acrylicOpacity" : 0.8, // 磨砂效果
    "colorScheme" : "Campbell", // 配色方案
    "cursorColor" : "#FFFFFD", // 光标颜色
    "fontFace" : "Fira Code", // 终端字体
    "backgroundImage":"C:\\Users\\Minso\\Pictures\\Camera Roll\\view.jpg", // 终端背景图
    "backgroundImageOpacity":0.75, // 背景图透明度
}
```

2. 将`Windows Terminal here`加入到右键菜单

- 默认`wt`打开的是`Windows Terminal`中的`defaultProfile`，可通过`wt -p <profile-name>`指定打开的终端
- 若右键打开需要进入当前路径，需要将配置文件中的对应`profile`的`startingDirectory`设置为`null`

```sh
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\Background\shell\wt]
@="Windows Terminal here"
"Icon"="C:\\Users\\Minso\\Pictures\\Camera Roll\\terminal.ico"

[HKEY_CLASSES_ROOT\Directory\Background\shell\wt\command]
@="C:\\Users\\Minso\\AppData\\Local\\Microsoft\\WindowsApps\\wt.exe -p git"
```

## `WSL` 常用指令


Windows 提供了两套命令接口用于管理和操作子系统：

1)、`wslconfig` 命令只用于在 Windows 上对其 Linux 的子系统上管理操作

2)、`wsl` 命令提供了比较完整的功能，可在 Windows 上对其 Linux 的子系统进行-配置管理、执行操作等功能

1、查看当前已经注册激活的实例

当你从 Windows Store 中下载安装了对应的 Linux 发行版，没有首次运行设置用户。该发行版系统是属于没有被激活的，好比：下载了一个`ISO`镜像，没有进行安装。

```sh
# 列出已注册的子系统【只列出子系统名称】
wslconfig /l 

# 列出正在运行的子系统
wslconfig /l /running

# 列出已注册的子系统的详细信息
# -l --list 显示列表【只显示名称】 
# -v --verbose 显示有关所有分发的详细信息
wsl -l -v
```

![wsl-show-list-distribution.png](A4A6AD64AB4143BBB2357EB09E63C6C6)

2、 设置`wsl`命令启动的默认子系统

```sh
# DistributionName 可以通过 `wsl -l` 查看
wslconfig /s <Distribution Name>

或

wsl -s <DistributionName>
```

设置后，可以通过 `wsl -l` 或 `wslconfig /l` 查看对应列表，`<DistributionName>` 后括号写着`(默认)`的则表示该发行版为 `wsl` 命令启动的默认子系统

![image](6945BAC0EF0F4DE49E41950AF04C6992)

3. 停止一个正在运行的子系统
```sh
wslconfig /t <DistributionName>
# 或
wsl -t <DistributionName>

# 关闭所有正在运行的子系统
wsl --shutdown
```

4. 注销一个子系统【子系统中的所有数据会丢失，相当于重装系统】
```sh
wslconfig /u <DistributionName>
# 或
wsl --unregister <DistributionName>
```

5. 设置子系统运行`WSL`版本
```sh
# 设置子系统运行`WSL`默认版本
wsl --set-default-version <1|2>

# 设置指定子系统的运行`WSL`版本
wsl --set-version <DistributionName> <1|2>
```




6. `wsl`其余常用指令
```sh
# 运行指定发行版
wsl -d <DistributionName> 

# 使用指定用于运行发行版
wsl -u <user>

# 执行`wsl`中的脚本
wsl -e <command-line>

# 调用`wsl`中默认的 `Linux shell` 处理数据
wsl <shell command-line>
```
![windows-os-use-wsl-linux-shell.png](DB50DCBCAF4244FB95B5CB25442A8D73)

7. 在宿主机中访问`WSL`目录

![access-wsl-filesystem-in-windows-os.png](1F7B4E4129364A0A8C4DFB9446111B55)

![add-wsl-filepath-in-my-computer.png](46E4D13435CE43D9A562D102414D4B8E)

## WSL2 安装 Docker

在 WSL 2 没有出现之前如果要在 Windows 上玩 Docker 很多人是不建议的。

首先：因为即使是使用 Docker 官方的提供的 Docker for Windows 也是经常出些奇奇怪怪的错误并迟迟得不到解决。

其次：通过虚拟机安装 boot2docker.iso，在虚拟出来的 Linux 系统下玩，但启动虚拟机是真慢。而且随着 WSL2 的推出 boot2docker 也不在维护。

因此：WSL 2 对于经常需要使用一些办公程序软件、又想玩 Docker、还没钱买 Mac 的用户来说，确实是一个福音。

因为 Docker 最初就是基于 Linux 内核的 cgroup，namespace，以及 OverlayFS 类的 Union FS 等技术，对进程进行封装隔离，属于**操作系统层面**的虚拟化技术。由于隔离的进程独立于宿主和其它的隔离的进程，因此也称其为容器。

Docker 最初实现是基于 LXC，从 0.7 版本以后 Docker 公司开始逐步去除 LXC，转而使用自行开发的 libcontainer，从 1.11 版本开始，则进一步演进为使用 runC 和 containerd。但经过大家验证，还是 Linux 内核的操作系统运行 Docker 是最好的。

### 方式一：Docker Desktop + WSL 2

Docker Desktop for Windows 把 `Docker CE`、`Docker Compose`、`Kubernets` 等软件整合在了一起进行安装，省去了一一安装的烦恼。

下载地址 [https://www.docker.com/get-started](https://www.docker.com/get-started),下载对应的安装包，傻瓜式安装即可。而通过 Docker Desktop 运行 Docker 的优点就是操作简单。

安装完毕后，配置 Docker Desktop 使用 WSL 2 运行 Docker engine 

![Use the WSL 2 based engine](B79CBDBC3D864B65907B1FDB73A47DE6)

![Configure which WSL 2 distros you want to access Docker from](1CA181ADE6F9452AA86CC7F183724FD3)

现在你就可以在对应的子系统中玩  Docker  了，打开安装好的子系统，输入 docker info 就可以查看到对应的系统信息了.

##### 踩坑预警
使用`docker info`打印信息时可能会遇到下述警告信息，提示网桥设置有问题。

```text
WARNING: bridge-nf-call-iptables is disabled
WARNING: bridge-nf-call-ip6tables is disabled
```

![ bridge-nf-call-iptables is disabled](3C92B46385414C93A3AC4B151E143BF1)


### 方式二：`WSL2`子系统中安装Docker

#### 安装最新`Docker CE`

```
curl -fsSL get.docker.com -o /tmp/get-docker.sh && sudo /bin/sh /tmp/get-docker.sh --mirror Aliyun && rm -f /tmp/get-docker.sh
```

#### 启动并检验安装是否成功
```sh
## 启动 docker 服务
sudo service docker start # 注意：有的Linux系统时通过`systemctl start docker`启动

## 打印docker系统详细信息
docker info
```

![docker info](CFF3FC5E538F49E79B9948B523D871D4)

看到以上信息证明已经安装完成并成功启动了服务！

##### 踩坑预警 - `docker info` 报错，Client/Server 信息都显示不出来

使用`docker info`打印信息时可能会遇到下述信息，提示`/var/run/docker.sock`权限不足

```
Client:
 Debug Mode: false

Server:
ERROR: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.40/info: dial unix /var/run/docker.sock: connect: permission denied
errors pretty printing info
```
![/var/run/docker.sock connect permission denied](D82ED347ABD64843B4A426D4012663D2)

通过`ls -al /var/run/docker.sock`查看该文件权限信息，发现文件是`root`用户或`docker`组用户才能进行读写

![ls -al show files info](5E27FDA110CB4651B4EC966042A2034A)

可以通过`id`或`groups ${USER}`查看当前用户所在的组信息，发现当前用户的附加组信息里并没有`docker`，那么问题就好解决了：只需将当前用户加入到`docker`组即可.

![id show ${USER} groups](157FC8625A94472896433A66EC41DA7A)

1. 创建 `docker` 组

```sh
sudo groupadd docker
```

2. 将当前用户加入到`docker`组

```sh
sudo usermod -aG docker ${USER}
```

3. 刷新用户的用户组信息

你需要先登出再重新登录一次，这样当前系统会重新刷新你的身份信息。或者，使用下列方式不用退出即可刷新当前进程的用户身份信息：

```sh
exec su -l ${USER}
```

此时再运行`docker info`应该就正常打印信息了！

##### 踩坑预警 - Failed to start docker on WSL `docker info` 报错，Client 可以查看，Server 信息显示异常，直接执行 `dockerd` 服务也启动不了

- [Failed to start docker on WSL](https://github.com/microsoft/WSL/issues/8450)

try `sudo dockerd --iptables=false`.

If you want to make the change permanent edit `/etc/default/docker` and add `DOCKER_OPTS="--iptables=false"`. After this you can use sudo service docker start to start your docker server, or stop, restart, and check status. Using `service` to start docker it will also log events to `/var/log/docker` which might come in handy later.

#### 安装最新`Docker Compose`

> 可参考：https://docs.docker.com/compose/install/#install-compose-on-linux-systems

```
## 下载当前最新版本是：1.27.4

sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

## 赋予 docker-compose 可执行权限
sudo chmod +x /usr/local/bin/docker-compose

## 刷新当前进程信息
exec $SHELL -l

## 检查docker-compose是否安装成功
docker-compose --version
```

### 设置`Docker Server`镜像源加速

- Docker 官方中国区镜像地址：https://registry.docker-cn.com
- 网易镜像地址：http://hub-mirror.c.163.com
- ustc镜像地址：https://docker.mirrors.ustc.edu.cn
- 阿里云镜像地址设置参考文章底部：https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors

> 如果想使用阿里云镜像地址需要有阿里云账号，但我在广州试用了上述的镜像地址，确实设置了阿里云的镜像加速是效果最好的

#### 通过`Docker Desktop`配置`registry-mirrors`
如果是使用 `Docker Desktop`+`WSL` 方式安装 `Docker` 直接使用面板即可修改！

![set registry-mirrors for Docker Desktop](FC2EDF554BE049CF96CEC63AF028C7AB)

#### 配置 `WSL2` 中的 `Docker` 镜像加速地址

当你的docker版本较新（Docker Version >= 1.10）时，建议直接通过 `/etc/docker/daemon.json` 进行配置（若没有该文件则直接新建，写入下述配置即可）

```json
{
    "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
```

若`Docker`版本比较旧，则需根据系统的不同而修改不同位置的配置文件，详细参考[此处](https://developer.aliyun.com/article/29941)

修改完成后，执行`sudo service docker restart`重启`docker`

![ update setting registry-mirrors ](FFDA4DA1CF564046AFC75899D41436D0)


### 解决 `WSL2` 安装 `Docker` 的一些问题

#### 1. 开机启动`Docker`服务

`WSL`的是一个基于`Windows`系统的`Hyper V`服务运行的`Linux`系统，但没有对应的开机自检程序，因此在`WSL`中设置服务开机启动是没有用的。

因此，通过实现`Windows`的开机启动项执行一端脚本调用`WSL`内的服务，从而达到 `WSL` 开机启动服务的目的。

查阅并试验了网上的一些文章，大致分为两类：

- 通过将`VBScript`脚本的快捷方式放到`C:\Users\{USER}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`下，从而实现开机自启【试验结果：Windows 10 似乎由于权限问题，不能将 `*.vbs` 格式脚本放置到该目录下】
- 通过修改注册列表的实现开机自动执行一段命令【试验结果：可行】

1. **脚本如下**

![shell-script-init.wsl](A27C2C10B8B843C994707AAB5AE84C63)

2. **设置`sudo`执行时不需要输入密码**

配置`/etc/sudoers`文件，将下述信息加入到文件末端

```ini
## 设置sudo脚本-无需输入密码验证
%sudo ALL=NOPASSWD: /etc/init.wsl
```

3. **`PowerShell`如下**

```sh
## -u root 通过roo用户启动wsl
## -e /etc/init.wsl 启动执行 /etc/init.wsl脚本

wsl -u root -e /etc/init.wsl
```
![powershell 调用 wsl内部脚本](FAEE9F0B8AA44D53B27CC3830D302941)

#### 2. 解决 WSL2 内网IP变动问题

由于`WSL 2`新的体系结构使用虚拟化的网络组件，每次计算机重启的时候都会重置`WSL 2`的虚拟网卡，因此每次重启完计算机后`WSL2`中的`IP`地址都不一定一样。

![Get-Servcie-LxssManager-Restarat-Service.png](3E17F181A6A94EB3B3588BEF0EA927E6)

虽然我们可以通过`localhost`访问到`WSL`中的服务，但是当需要配置多个虚拟域名的时候该方法显然就不适用了，此时若要在宿主机中通过虚拟域名访问`WSL 2`中的网络服务需要每次手动对宿主机的`hosts`文件修改其`IP-Domain`映射关系。

想了两个方案：
- 方法一：通过批处理脚本，启动时自动获取`WSL 2`的网卡信息，自动修改宿主机的`hosts`原有的`IP-Domain`信息

> 该方法需要懂批处理脚本语言，而且实际开发情景中开发环境一般都是整个开发组统一进行维护的。包括`hosts`文件一般也是统一进行维护然后通过`SwitchHosts`从远端拉取。因此方式一比较适用个人本地项目，因为`hosts`一般不会变动，但并不适用协同办公的情景。


- 方法二：想办法将`WSL`的网卡信息“固定下来”-设置私有`IP`，组建`宿主机-WSL 2`局域网

> 由于`WSL 2`的网卡每次都会被重置，因此设置静态`IP`的方式势必是走不通的。
因此：只能在每次计算机开机或重启的时候通过脚本为`WSL 2`增置一个新的私有网卡`IP`，并同时在宿主机上增设一个一样网段的以太网卡私有`IP`，在宿主机与虚拟机之间组建一个小型的局域网进行服务通信。

```sh
## `WSL 2`新增网卡
## - 设置私有IP网段为192.168.33.10
## - 广播地址为192.168.169.15
## - 网卡名称为 eth0
## - 设置网卡标签 eth0:1
wsl -u root ip addr add 192.168.33.10 broadcast 192.168.169.15 dev eth0 label eth0:1

## 设置宿主机网卡`vEthernet (WSL)`地址为 `192.168.33.1`-需要管理员权限
netsh interface ip add address "vEthernet (WSL)" 192.168.33.1 255.255.255.240
```

#### 3. 修改注册列表实现宿主机开机自动执行初始化脚本

1. `WSL2` 开机启动`Docker`服务脚本-放在虚拟机中`/etc/init.wsl`位置
```sh
##!/bin/sh

## 启动docker服务
sudo service docker start
## 开启 rpcbind 服务
sudo mkdir -p /run/sendsigs.omit.d/ && sudo /etc/init.d/rpcbind start
```

2. `Windows`宿主机开机需自动执行的`init-wsl.bat`脚本
```bat
@echo off
:: run task as administrator
%1 %2
ver|find "5.">nul&&goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin

:: set WSL distribution
set distribution=Ubuntu-20.04

:: 设置WSL初始化脚本位置
set initWSL=/etc/init.wsl

:: 配置宿主机私有网络IP、WSL2私有网络IP、广播地址、子网掩码
set hostOSIP=192.168.33.1
set WSL2IP=192.168.33.10
set WSL2Broadcast=192.168.33.15
set subnetMask=255.255.255.240

:: init WSL2 services
wsl -d %distribution% -u root -e %initWSL%
if %ERRORLEVEL% NEQ 0 (
    echo init WSL services error OR Already init WSL!
    pause
) else (
    echo init WSL success!
)

:: set wsl2 ip
wsl -d %distribution% -u root ip addr | findstr "%WSL2IP%" > nul
if !errorlevel! equ 0 (
    echo wsl ip has set!
) else (
    wsl -d %distribution% -u root ip addr add %WSL2IP% broadcast %WSL2Broadcast% dev eth0 label eth0:1
    echo set wsl ip success: %WSL2IP%
)

:: set windows ip
ipconfig | findstr %hostOSIP% > nul
if !errorlevel! equ 0 (
    echo windows ip has set!
) else (
    netsh interface ip add address "vEthernet (WSL)" %hostOSIP% %subnetMask%
    echo set windows ip success: %hostOSIP%
)
```

`Windows`键+`R`，输入`regedit`打开注册列表，在地址栏输入`计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`定位到对应注册表位置，右键新建一个字符串值，键入对应命令即可，如下图！

![set regist service](24869BA9868A4030A3C46C071A749ED0)

重启计算机即可发现，`WSL`中的`Docker`服务已经被启动，通过`192.168.33.10`可以直接访问到`WSL`内部的网络！

参考文章：
- [①BAT脚本自动获取管理员权限等功能](https://www.xilixili.net/2019/09/10/bat-request-admin-rights-and-others/)
- [②WSL2固定ip地址](https://blog.csdn.net/manbu_cy/article/details/108476859)

## WSL 修改安装目录

在 `Microsoft APP Store` 中安装 `WSL` 时，磁盘安装的位置一般是在`C`盘，路径类似于：`C:\Users\Administrator\AppData\Local\Packages\CanonicalGroupLimited.xxxonWindows_xxx`），子系统中的各类物理数据通过磁盘映像文件的方式存放在安装目录下的 `LocalState` 中。

磁盘映像文件在宿主机中是不能直接访问的，若想要访问 `WSL` 中子系统的目录可以通过`\\wsl$`的方式进行访问

![access-wsl-filesystem-in-windows-os.png](1F7B4E4129364A0A8C4DFB9446111B55)

上述网络文件位置对应在 `C:\Users\{用户名}\AppData\Roaming\Microsoft\Windows\Network Shortcuts`中。

占用空间的主要是子系统的磁盘映射文件，因此随着使用 `WSL` 的时间越长，我 `C` 盘的磁盘空间也有些捉襟见肘，因此我打算将几个占用空间大的子系统迁移到 `D:\wsl` 中，操作如下：

1. 查看所有分发版本及状态

```powershell
wsl -l -v
```

![image](A5F7AE762ACD417C9FA629A73CD11EFB)

迁移的子系统必须是 `Stopped`，如果对应的子系统处于 `Running` 状态，则使用 `wsl -t <NAME>` 的方式进行停止

2. 导出指定的分发子系统为`tar`包

```powershell
wsl --export <distribution-name，如：Ubuntu-18.04> <localPath，如：D:\wsl\Ubuntu-18.04.tar> 
```

3. 删除指定的分发子系统
```powershell
wsl --unregister <distribution>
```

4. 重新导入并安装分发版在 `D:\wsl` 目录中

```powershell
wsl --import <distribution-name> <local Install Path> <tar File's Path> --version 2
```

5. 设置新导入的分发版为**最初安装时的用户名**（注意：一定要保证当前用户名是已经存在的）

```powershell
<distribuName，如：ubuntu1804> config --default-user <UserName，如：lms>
```

6. 删除 tar 包
```powershell
del D:\wsl\file.tar
```

至此，迁移工作就已经完成了。

## WSL 内核更新

https://www.catalog.update.microsoft.com/Search.aspx?q=wsl

## StarShip 订制 Windows Terninal

[StarShip 终端订制](https://starship.rs/zh-CN/)

### 1. 安装  Nerd Font 系列的字体

如果是 Windows 一定要通过 “管理员身份” 打开 powershell，然后执行：

```powershell
choco install firacode
```

其他 OS 安装方式：https://github.com/tonsky/FiraCode/wiki/Installing

### 2. 安装 StarShip

```sh
# Windows 
scoop install starship

# Linux
curl -fsSL https://starship.rs/install.sh | sh
```

### 3. 启动 starship

Windows Powershell 下通过 `echo $PROFILE` 找到 powershell 启动配置文件（不存在则自行创建一个），然后打开文件，末尾添加：`Invoke-Expression (&starship init powershell)`

Linux 下：`vi /etc/bash.bashrc`，末尾添加 `eval "$(starship init bash)"`


### 4. 配置 `~/.config/starship.toml`

```config
command_timeout = 500
format = "$directory$git_branch$time$cmd_duration$character"
[line_break]
disabled = true

[character]
success_symbol = "[➜](bold green) "
error_symbol = "[✗](bold red) "

[cmd_duration]
min_time = 500
format = "took [$duration](bold yellow) "

[directory]
read_only = "🔒"
use_os_path_sep = true
truncate_to_repo = false
format = "[$path]($style)[$read_only]($read_only_style) "

[git_branch]
always_show_remote = true
symbol = "  "
style = "bold #e8ec00 inverted"
format = "on [$branch$symbol$remote_name/$remote_branch]($style) "

[time]
disabled = false
format = '[ 🕙 $time ]($style) '
time_format = "%I:%M:%S %p"
utc_time_offset = "+8"
style = "bold bg:#8a15e2"

[git_commit]
disabled = true

[git_state]
disabled = true

[git_status]
disabled = true

[package]
disabled = true
```

- 永久更改 cmd codepage 的方法：https://www.cnblogs.com/lcword/p/5854225.html
- 修改 cmd 命令行字体：https://blog.csdn.net/feinifi/article/details/102695889


- windows linux子系统对外提供服务的俩种方法:https://www.cnblogs.com/yyxianren/p/15961604.html
- 通过局域网访问 Windows 10 WSL 2 的网络服务 :https://www.cnblogs.com/tofengz/p/16337108.html
- 使用 WSL 访问网络应用程序：https://learn.microsoft.com/zh-cn/windows/wsl/networking

```powershell
netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectaddress=192.168.33.10 connectport=8080

netsh interface portproxy show v4tov4
```