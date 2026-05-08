# 虚拟机@VirtualBox

[TOC]

## 资料前线
> - VirtualBox 下载：https://www.virtualbox.org/wiki/Downloads
> - VirtualBox 使用手册：[https://www.virtualbox.org/manual/](https://www.virtualbox.org/manual/)
> - VirtualBox 使用手册 PDF 版：[http://download.virtualbox.org/virtualbox/UserManual.pdf](http://download.virtualbox.org/virtualbox/UserManual.pdf)
> - 后台启动 VirtualBox 章节：[https://www.virtualbox.org/manual/ch08.html#vboxmanage-startvm](https://www.virtualbox.org/manual/ch08.html#vboxmanage-startvm)


## Windows 中启动虚拟机的多种方式

### 通过 GUI 启动

1. 打开 VirtualBox 
2. 点击对应的虚拟机来运行

> 弊端：
> - GUI 比较耗费系统资源
> - 使用 GUI 无法自由的来回切换鼠标，比较麻烦

### 通过后台启动虚拟机

> - 由于 VirtualBox VM 仅作为一个后台进程在执行而不显示画面，所以不会出现VirtualBox增强工具导致的一系列问题，从而节省了很多系统资源。
> - 后台启动虚拟机之后，可以通过 `putty`、`winscp` 或 `xshell` 等 SSH 链接工具链接登录即可，因此：虚拟机应当配置好网络，开启了 sshd 服务

1. 打开 Windows 命令行：`cmd ` 或 `powershell`
2. 切换到 VirtualBox 安装目录（可以直接将目录配置到环境变量中-`sysdm.cpl`）
3. 查看当前已经安装了的虚拟机：`.\VBoxManage.exe list vms`，会看到如下格式的一个列表

```shell
# "CentOS7" 是指虚拟机的名称
# {4c75d00f-5709-44a4-ab49-223e2ab2c357} 是指虚拟机的 uuid（唯一ID）

"CentOS7" {4c75d00f-5709-44a4-ab49-223e2ab2c357}
```

4. 后台启动指定虚拟机：`.\VBoxManage.exe startvm "name_or_uuid" –type headless `

> `--type xxx`指定启动方式
> - headless 方式：启动一个没有窗口的 VM，仅用于远程显示所用
> - gui 方式： 启动一个带 GUI 窗口的 VM，默认就是使用该方式启动的
> - sdl 方式：启动一个小型的 GUI VM，带有部分功能【阉割版 GUI 】

5. 关闭虚拟机：`VBoxManage.exe controlvm name_or_uuid acpipowerbutton`


## 虚拟机网络配置

- [搞懂虚拟机VirtualBox网络配置](https://mp.weixin.qq.com/s/CBeOtN6kL2P4TU40DD3aSQ)
- [Virtual Box虚拟机CentOS 7.x网络配置](https://mp.weixin.qq.com/s/rZC0TgYvb1ynuoMZO_394g)
- [虚拟机的网络模式，你配置对了吗](https://mp.weixin.qq.com/s/yvZtdDEtE4QGiFyqBnu9dg)
- [VirtualBox虚拟网络环境配置【两台虚拟机互通】](https://juejin.cn/post/7082663538770051102)