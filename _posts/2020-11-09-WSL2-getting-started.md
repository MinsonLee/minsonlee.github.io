---
layout: post
title: "WSL2 常用指南"
date: 2020-11-09
tag: WSL2
---

`WSL2`的逐渐完善，使得在`Windows`中使用完整内核的`Linux`变得越来越方便，用户可以在`Windows`中使用多个不同`Linux`的发行版。

`Windows`提供了两套命令接口用于管理、操作子系统：
- `wslconfig`命令只用于在 `Windows` 上对其 `Linux` 的子系统上管理操作
- `wsl`命令提供了比较完整的功能，可在 `Windows` 上对其 `Linux` 的子系统进行-配置管理、执行操作等功能

## 查看当前已经注册激活的实例

> 当你从`Windows Store`中下载安装了对应的`Linux`发行版，没有首次运行设置用户。该发行版系统是属于没有被激活的，好比：下载了一个`ISO`镜像，没有进行安装。

```sh
# 列出已注册的子系统【只列出子系统名称】
wslconfig /l 

# 列出正在运行的子系统
# wslconfig /l /running

# 列出已注册的子系统的详细信息
# -l --list 显示列表【只显示名称】
wsl -l -v
```
![wsl-show-list-distribution.png](/images/article/wsl-show-list-distribution.png)

## 设置`wsl`命令启动的默认子系统

```sh
# DistributionName 可以通过 `wsl -l` 查看
wslconfig /s <DistributionName>

或

wsl -s <DistributionName>
```

设置后，可以通过 `wsl -l` 或 `wslconfig /l` 查看对应列表，`<DistributionName>` 后括号写着`(默认)`的则表示该发行版为 `wsl` 命令启动的默认子系统

## 停止一个正在运行的子系统
```sh
wslconfig /t <DistributionName>
# 或
wsl -t <DistributionName>

# 关闭所有正在运行的子系统
wsl --shutdown
```

## 注销一个子系统【子系统中的所有数据会丢失，相当于重装系统】
```sh
wslconfig /u <DistributionName>
# 或
wsl --unregister <DistributionName>
```

## 设置子系统运行版本
```sh
# 设置子系统运行`WSL`默认版本
wsl --set-default-version <1|2>

# 设置指定子系统的运行`WSL`版本
wsl --set-version <DistributionName> <1|2>
```


![wsl-Comparing-WSL1-and-WSL2.png](/images/article/wsl-Comparing-WSL1-and-WSL2.png)

`WSL 2`和宿主机系统之间的I/O交互功能有所减弱，其余性能、隔离层度等方面做的都比`WSL 1`要好很多。

> WSL 1 和 WSL 2 的比较：https://docs.microsoft.com/en-us/windows/wsl/compare-versions

## `wsl`其余常用指令
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
![windows-os-use-wsl-linux-shell.png](/images/article/windows-os-use-wsl-linux-shell.png)

## 在宿主机中访问`WSL`目录

![access-wsl-filesystem-in-windows-os.png](/images/article/access-wsl-filesystem-in-windows-os.png)

![add-wsl-filepath-in-my-computer.png](/images/article/add-wsl-filepath-in-my-computer.png)