## 系统准备
`WSL2`相较于`WSL`除了`I/O`性能有了巨大的改进，最主要的：`WSL2` 的底层是一个跑在`Hyper-V`上的**完整**的`Linux`系统，而不是像`WSL`一样是穿着`Linux` 的外衣和`Windows`打交道的系统。

### 查看系统版本

![Update to WSL2 Requirements](56211CDAD8CA4A11BDA053B1B8DD9CF7)

即：最新的`WSL2`特性要求在 `Windows 10 x64 Version 1903`及以上版本的系统或`ARM64 systems: Version 2004`及以上版本的系统.

`Win+R` 输入 `winver`，即可查看到当前自己`Windows`版本信息：

![winver](058D8D402EB24A809427915C5FB06B8B)

> - 更新`Windows`工具：https://www.microsoft.com/zh-hk/software-download/windows10
> - `Windows 1909`升级失败问题：https://www.win10gw.com/win10wenzhang/6507.html

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

![systeminfo](F2B6AFE9068247969B6DE53490FD5E6A)

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

![Microsoft Store Result for search Linux](55BE8FABF7F34A06823F57D78D8F776F)

打开`PowerShell`，输入`wsl -l -v`可以看到你的子系统运行版本

![wsl -l -v](48271B360FF1485F985618DCB8A4403A)

## 通过 Docker for Windows 运行 Docker

1. 下载安装`Docker Desktop`运行 `Docker`，可以让你在`Windows`中方便的管理配置`Docker`

- Docker for Windows：https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe
- Doecker for Mac：https://desktop.docker.com/mac/stable/Docker.dmg

傻瓜式安装即可！

2. 配置使用`WSL2`运行`Docker engine`

![Use the WSL 2 based engine](B79CBDBC3D864B65907B1FDB73A47DE6)

## 安装本地Docker开发环境

在菜单栏找到安装的 `Linux` 子系统，点击运行即可进入，按步骤设置用户信息即可完成！

![image](C71043806EAB4591B03C6765E88397B7)

1. 拉取 `ERC` 的 `docker compose`仓库

```git
git clone git@niubibi.qeeq.cn:erc_docs/php-docker-compose-deployment.git erc-docker
```

2. 设置 `htdocs` 位置

![set htdocs](A1BE9A8317E44AD0AB08F2483BF3D61C)

3. 安装`nfs-client` 开启 `rpcbind` 服务

由于项目之间的依赖比较复杂，且仓库较多，因此 `app.sh` 中安装`nfs-client`将远程测试机下的目录动态挂载到了本地，进而再挂载到容器中，屏蔽了开发对不必要项目依赖的困惑。

![mount nfs to local](8ADAD2952EF04600ABBC796D9A7630AF)

由于 `WSL2` 中可能没有开启`mount.nfs: rpc.statd` 可能会导致最后挂载到本地的目录失败是空的。单独运行截图中的信息，得到报错：

```
mount.nfs: rpc.statd is not running but is required for remote locking.

mount.nfs: Either use '-o nolock' to keep locks local, or start statd.
```

解决办法，开启`rpcbind` 服务

```sh
# 安装 nfs-client 服务，该服务系统本身是没有安装的，安装该服务的同时会安装 rpcbind 依赖服务
sudo apt-get install -y nfs-common

# 开启 `rpcbind` 服务
sudo /etc/init.d/rpcbind start
```

可能会启动失败，提示 `/run/sendsigs.omit.d/rpcbind` 文件不存在

```sh
sudo mkdir -p /run/sendsigs.omit.d && sudo touch /run/sendsigs.omit.d/rpcbind
```

若上述报错，创建文件后重新启动`rpcbind`即可

4. 拉取镜像，构建本地Docker

```sh
./app.sh start
```