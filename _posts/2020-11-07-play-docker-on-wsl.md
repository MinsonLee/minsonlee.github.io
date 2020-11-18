---
layout: post
title: "01.WSL2 安装 Docker"
date: 2020-11-07
tags: [Docker,WSL2]
---
## 背景

`WSL2`相较于`WSL`除了`I/O`性能有了巨大的改进，最主要的：`WSL2` 的底层是一个跑在`Hyper-V`上的**完整**的`Linux`系统，而不是像`WSL`一样是穿着`Linux` 的外衣和`Windows`打交道的系统。

因此，在`WSL2`没有出现之前如果要在`Windows`上玩`Docker`很多人是不建议的。
- 因为即使是使用`Docker`官方的提供的`Docker for Windows`也是经常出些奇奇怪怪的错误并迟迟得不到解决。
- 通过虚拟机安装`boot2docker.iso`，在虚拟出来的`Linux`系统下玩，但启动虚拟机是真慢。而且随着`WSL2`的推出`boot2docker`也不在维护。

因此`WSL2`，对于经常需要使用一些办公程序软件、又想玩`Docker`、还没钱买`Mac`的用户来说，确实是一个福音！


## 安装 WSL2

### 查看系统版本

![Update to WSL2 Requirements](/images/article/wsl-os-requirements.png)

即：最新的`WSL2`特性要求在 `Windows 10 x64 Version 1903`及以上版本的系统或`ARM64 systems: Version 2004`及以上版本的系统.

`Win+R` 输入 `winver`，即可查看到当前自己`Windows`版本信息：

![winver](/images/article/winver.png)

> 更新Windows工具：https://www.microsoft.com/zh-hk/software-download/windows10

### 安装 WSL 并升级到 WSL2

一定要确保系统已经达到标准，不然通过`WSL`使用`Docker`会遇到各种不知道为啥的坑，而且启动`Docker`也非常慢。
> WSL2 更新特性：https://docs.microsoft.com/en-us/windows/wsl/compare-versions#whats-new-in-wsl-2

**下列命令都需要使用管理员身份运行`PowerShell`，运行下列脚本！！！**
1. 安装`WSL`：开启`Windows-Subsystem-Linux`特性

```sh
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

2. 升级`WSL2`-开启Windows的虚拟平台特性

```sh
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**升级完毕之后，需要重启计算机！！！**

3. 下载安装 Linux 内核更新包

查看系统类型，在 `PowerShell` 中输入`systeminfo`即可查看，如下图是`x64`的版本：

![systeminfo](/images/article/windows-os-systeminfo.png)

- [WSL2 Linux kernel update package for x64 machines](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
- [WSL2 Linux kernel update package for ARM64 machines](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_arm64.msi)

下载对应补丁包安装补丁！

4. 设置默认通过 `WSL2` 方式安装 `Linux`系统

要使用管理员身份运行`PowerShell`，运行下列脚本：

```PowerShell
wsl --set-default-version 2
```

> 如果你之前已经通过 `WSL1` 安装了 Linux，现在想转为`WSL2`运行，可参考：https://docs.microsoft.com/en-us/windows/wsl/install-win10#set-your-distribution-version-to-wsl-1-or-wsl-2

5. 安装 Linux 子系统
在`Microsoft Store`上搜索一个你自己喜欢的子系统进行安装

![Microsoft Store Result for search Linux](/images/article/search-linux-in-Microsoft-Store.png)

打开`PowerShell`，输入`wsl -l -v`可以看到你的子系统运行版本

![wsl -l -v](/images/article/wsl-list-version.png)

如果你想重启 WSL 系统，使用管理员身份打开 `PowerShell` 执行下列命令

```powershell
Get-Service LxssManager | Restart-Service
```

## 推荐安装终端工具`Windows Terminal`

`Windows`的命令行向来是以丑著称，`Windows Terminal`总算是挽救了一点它的颜值。详细参考[此处](/2020/11/how-to-use-windows-terminal-gracefully)

## 方式一：`Docker Desktop`+`WSL2` 运行 Docker

`Docker Desktop` 将 `Docker CE`、`Docker Compose`、`Kubernets` 等软件整合在了一起进行安装，省去了一一安装的烦恼。

### 下载安装`Docker Desktop`运行 `Docker`，可以让你在`Windows`中方便的管理配置`Docker`

- Docker for Windows：[https://desktop.docker.com/win/stable/Docker Desktop Installer.exe](https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe)
- Doecker for Mac：[https://desktop.docker.com/mac/stable/Docker.dmg](https://desktop.docker.com/mac/stable/Docker.dmg)

傻瓜式安装即可！

### 配置`Docker Desktop`使用`WSL2`运行`Docker engine`

![Use the WSL 2 based engine](/images/article/docker-desktop-set-wsl.png)

![Configure which WSL 2 distros you want to access Docker from](/images/article/configure-which-wsl2-distros-you-want-to-access-Docker-from.png)

现在你就可以在对应的子系统中玩 `Docker` 了，打开安装好的子系统，输入`docker info`就可以查看到对应的系统信息了.

## 方式二：`WSL2`子系统中安装Docker

### 安装最新`Docker CE`

```
curl -fsSL get.docker.com -o /tmp/get-docker.sh && sudo /bin/sh /tmp/get-docker.sh --mirror Aliyun && rm -f /tmp/get-docker.sh
```

### 启动并检验安装是否成功
```sh
# 启动 docker 服务
sudo service docker start # 注意：有的Linux系统时通过`systemctl start docker`启动

# 打印docker系统详细信息
docker info
```

![docker info](/images/article/docker-info.png)

看到以上信息证明已经安装完成并成功启动了服务！

#### 踩坑预警

使用`docker info`打印信息时可能会遇到下述信息，提示`/var/run/docker.sock`权限不足

```
Client:
 Debug Mode: false

Server:
ERROR: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.40/info: dial unix /var/run/docker.sock: connect: permission denied
errors pretty printing info
```
![/var/run/docker.sock connect permission denied](/images/article/error-docker-sock-permission-denied.png)

通过`ls -al /var/run/docker.sock`查看该文件权限信息，发现文件是`root`用户或`docker`组用户才能进行读写

![ls -al show files info](/images/article/ls-al-docker-sock.png)

可以通过`id`或`groups ${USER}`查看当前用户所在的组信息，发现当前用户的附加组信息里并没有`docker`，那么问题就好解决了：只需将当前用户加入到`docker`组即可.

![id show ${USER} groups](/images/article/id-show-user-info.png)

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

### 安装最新`Docker Compose`

> 可参考：https://docs.docker.com/compose/install/#install-compose-on-linux-systems

```
# 下载当前最新版本是：1.27.4

sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 赋予 docker-compose 可执行权限
sudo chmod +x /usr/local/bin/docker-compose

# 刷新当前进程信息
exec $SHELL -l

# 检查docker-compose是否安装成功
docker-compose --version
```

## 设置`Docker Server`镜像源加速

- Docker 官方中国区镜像地址：https://registry.docker-cn.com
- 网易镜像地址：http://hub-mirror.c.163.com
- ustc镜像地址：https://docker.mirrors.ustc.edu.cn
- 阿里云镜像地址设置参考文章底部：https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors

> 如果想使用阿里云镜像地址需要有阿里云账号，但我在广州试用了上述的镜像地址，确实设置了阿里云的镜像加速是效果最好的

### 通过`Docker Desktop`配置`registry-mirrors`
如果是使用 `Docker Desktop`+`WSL` 方式安装 `Docker` 直接使用面板即可修改！

![set registry-mirrors for Docker Desktop](/images/article/set-registry-mirrors-for-Docker-Desktop.png)

### 配置 `WSL2` 中的 `Docker` 镜像加速地址

当你的docker版本较新（Docker Version >= 1.10）时，建议直接通过 `/etc/docker/daemon.json` 进行配置（若没有该文件则直接新建，写入下述配置即可）

```json
{
    "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
```

若`Docker`版本比较旧，则需根据系统的不同而修改不同位置的配置文件，详细参考[此处](https://developer.aliyun.com/article/29941)

修改完成后，执行`sudo service docker restart`重启`docker`

![ update setting registry-mirrors ](/images/article/update-setting-registry-mirrors.png)

## 遗留问题
在安装之后，留下了两个问题：

1. **设置开机自启服务异常**

`WSL2`中设置开机`docker`服务自启，我尝试了使用注册列表、通过`VBScript`启动服务、创建文件夹，但是失败了！
> 问题已解决，参考文章：[解决  WSL 开机启动服务](/2020/11/how-to-auto-start-service-on-boot-WSL2)

2. **访问容器服务不方便**

由于每次重启`WSL`的网卡都会被重置，在公司的网络环境中`Docker`的IP网段也会不断的变化。
因此，通过直接在`WSL2`中直接安装`docker`的方式，若在网络复杂的环境中在宿主机访问`WSL`内部容器服务需要自己手动变更`IP-Domain`绑定信息。
如果通过`Docker Desktop`+`WSL2`的方式则不会有这样的问题，因为该方式`WSL2`内部访问的`daemom`服务仍然是`Windows`中，但该方式安装的`docker`文件挂载异常，偶尔会出现挂载目录为空的情况。

> 问题已解决，参考文章：[解决 WSL 开机网卡信息变动问题](/2020/11/set-private-ip-for-wsl)