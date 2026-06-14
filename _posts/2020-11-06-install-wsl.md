---
layout: post
title: "Windows Subsystem for Linux"
date: 2020-11-07
tags: [WSL2,Linux]
---

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
