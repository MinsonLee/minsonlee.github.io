---
layout: post
title: "解决  WSL 开机启动服务"
date: 2020-11-08
tag: WSL2
---

`WSL`的是一个基于`Windows`系统的`Hyper V`服务运行的`Linux`系统，但没有对应的开机自检程序，因此在`WSL`中设置服务开机启动是没有用的。

因此，通过实现`Windows`的开机启动项执行一端脚本调用`WSL`内的服务，从而达到 `WSL` 开机启动服务的目的。

查阅并试验了网上的一些文章，大致分为两类：

- 通过将`VBScript`脚本的快捷方式放到`C:\Users\{USER}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`下，从而实现开机自启【试验结果：最新`Windows 10`由于权限问题，不能将 `*.vbs` 格式脚本放置到改目录下】
- 通过修改注册列表的实现开机自动执行一段命令【试验结果：可行】

## 测试准备

首先准备好`WSL`中的开机启动脚本，通过`PowerShell`手动调用一次看看脚本是否执行调用成功，没有问题之后再设置注册列表开机启动。

1. **脚本如下**

![shell-script-init.wsl](/images/article/init.wsl-shell.png)

2. **设置`sudo`执行时不需要输入密码**

配置`/etc/sudoers`文件，将下述信息加入到文件末端

```ini
# 设置sudo脚本-无需输入密码验证
%sudo ALL=NOPASSWD: /etc/init.wsl
```

3. **`PowerShell`如下**

```sh
# -d Ubuntu-20.04 启动 Ubuntu-20.04 发行版
# -u root 通过roo用户启动wsl
# -e /etc/init.wsl 启动执行 /etc/init.wsl脚本

wsl -d Ubuntu-20.04 -u root -e /etc/init.wsl
```
![powershell 调用 wsl内部脚本](/images/article/do-wsl-script-on-powershell.png)

> [设置 WSL 默认 Linux 发行版](/2020/11/WSL2-getting-started#设置子系统运行版本)

## 修改注册列表

`Windows`键+`R`，输入`regedit`打开注册列表，在地址栏输入`计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`定位到对应注册表位置，右键新建一个字符串值，键入对应命令即可，如下图！

![set regist service](/images/article/regedit-HKEY_LOCAL_MACHINE-RUN-init-wsl.png)

事实上在下列两类注册表中添加上述脚本命令都是可以实现开机自动执行的
- `计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run` 开机不管是哪个用户登录都会被执行
- `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run` 当前用户登录被执行

重启计算机即可发现，`WSL`中的对应的服务已经被启动！

参考文章：
- [Windows 开机自启注册表位置整理](https://zijieke.com/d/168)
- [Run and RunOnce Registry Keys](https://docs.microsoft.com/en-us/windows/win32/setupapi/run-and-runonce-registry-keys)