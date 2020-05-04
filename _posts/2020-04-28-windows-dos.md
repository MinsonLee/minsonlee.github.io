---
layout: post
title: "Windows DOS 常用命令"
date: 2020-04-28
tag: Windows
---

## Windows 下使用命令行的一些前言
前几日一个朋友在群里问了一个问题：如何通过 `CMD` 切换盘符？作为一名 IT 行业的从业人员，身边大家都在推荐使用 `Linux`，但现实中却是使用 `Windows` 的人更多，而在  `Windows` 操作简单的 `DOS` 命令反而让人忽略。由于懒惰，对于常用的 `Windows` 操作，能通过快捷命令一步到位的尽量不两步操作，我也就一直记录了些零散笔记，整理后遂有此文，以作备忘和 `DOS` 命令入门介绍。

作为当下(2020年)使用最多的桌面操作系统 `Windows` 系统其实也是一堆的`图形 Shell` 集合(`Windows` 底层集成了 `DOS` 系统，称为 `MS-DOS`。`DOS` 即：`Disk Operating System`的简写)。用户使用鼠标点击完成的各类操作，其实都可以通过 `DOS 终端`，如：`cmd.exe` 来直接执行 `DOS` 命令完成操作。

尽管 `Windows` 官方发布：`Windows 7` 支持将于2020 年1 月14 日终止，但是应该还是有人依然在坚持不懈的使用着 `Win7`，尽管使用着 `Win10` 可能还是使用着 `CMD.exe` 终端而不是使用 `PowerShell` 来操作 `DOS` 命令。实际上，如果在 `Windows` 上操作 `DOS` 还是强烈推荐使用 `PowerShell` 或者 `git-bash`(更偏向 `Linux` 系统的命令风格)。

或许你还听过 `Cygwin`，这是一款可以让你在 `Windows` 下使用 Linux 的软件，但随着 `Win10` 系统下日渐流行的 `WSL`（`Windows Subsystem for Linux `）以及体检逐渐在变得更加友好的 `Linux` 桌面系统，`Cygwin` 的学习使用成本是较大的.

如果使用 `Cygwin` 是为了体验使用 `Linux`，倒不如装个双系统来的更好，能更加深入的体验、学习 `Linux`；如果使用 `Cygwin` 是因为在使用 `Windows` 的同时还需要使用 `Linux`，那无疑 `WSL` 是你不二的选择。但 `Cygwin` 确实是一个伟大的软件，知乎上有位大神更是手把手的写了这一系列的教程，值得一看：[Cygwin前传：从割据到互补](https://zhuanlan.zhihu.com/p/56572298)

![image](/images/article/windows/shut-up.png)

废话不多说，且看下文！

## DOS 基本介绍
`DOS` 是 `Disk Operating System` 的简写，中文名称为：磁盘操作系统。如其名称所述，其作用就是：可以直接操作和管理磁盘上的文件。最早的 `DOS` 系统是 `86-DOS` 后来被比尔.盖茨以 5 美元收购并更名为 `MS-DOS`，由此可见 `MS-DOS` 仅仅只是基于 `Windows` 上的一个 `DOS` 系统分支，并不是完整的 `DOS` 系统全貌，只是随着微软 PC 产品的普及，普通人一般说的 `DOS` 其实大多指的都是 `MS-DOS` 罢了。

## DOS 基本操作原理
> The command shell is a separate software program that provides direct communication between the user and the operating system. The non-graphical command shell user interface provides the environment in which you run character-based applications and utilities. The command shell executes programs and displays their output on the screen by using individual characters similar to the MS-DOS command interpreter Command.com.

以上是微软对 `CMD-Command Shell` 的定义，可以看出：
- `Command Shell` 是一个独立的应用程序
- 为用户提供对操作系统直接通信的功能（即：`CMD` 只是个命令解释器，只是调用系统交互接口）
- 基于字符的应用程序和工具提供了<b style="background: yellow;">非图形界面的运行环境</b>
- 执行命令，并在屏幕回显 `MS-DOS` 风格的字符

![DOS运行原理](/images/article/windows/how-does-dos-do.png)

如果了解 `Linux Shell ` 编程的，应该知道：`Linux` 系统中 `壳-Shell` 也只是一个`命令解释器`，用户通过 `Shell` (包含`图形 Shell` 和 `命令行 Shell`)可以通过操作系统提供的接口和 `内核-Kernel` 进行交互。

`Linux` 下的 `Shell` 一般我们是指 `Bash`，一般说的 `Shell 编程` 其实也是指学习如何通过 `Bash` 调用系统接口完成任务。 

`Windows` 的内核可以看作是 `DOS 操作系统`，而操作终端，如 `CMD` 可以近似看作为就是 `Windows Shell`. `Windows` 下写批处理文件(`bat`文件)其实就是 `DOS 编程`。

## 如何打开 CMD
> `Windows` 键又称 `Win` 键，指的就是键盘上按一下就能出系统菜单的哪个按键. 一般在：左下角 `Alt`键隔壁。一般长下面这样：
>
> ![Windows 健](/images/article/windows/where-is-windows-key-board.png)

有以下2种方法都可快速打开：
1. `系统菜单`》`Windows 系统`》`命令行提示符`（直接在开始菜单处搜索`cmd`可能更快）
2. `Win 键` + `R` 打开 `运行` 程序，输入 `cmd`

## 目录指令
- 查看当前目录层级下的所有目录及文件：`dir`
- 查看当前目录及其子孙级目录下的所有目录和文件：`tree`
- 进入指定目录：`cd 路径`
- 切换目录：`盘符:`(==注意：该命令会默认进入到最后一次在当前盘符下执行 cd 命令的哪个目录下==)
- 创建一个目录：`md 目录名称 ... `（①.默认支持递归创建；②.同时创建多个目录使用空格分隔）
- 删除**空目录**：`rd 目录名称`
- 交互式删除目录及其中的文件：`rd /s 目录名称`(注意：该命令不会交互询问删除目录下的文件)
- 强制删除目录及文件：`rd /q/s 目录名称`

## 文件指令
- 新建/写入文件：`echo 内容 > 文件路径`（`>`表示清空当前内容写入；`>>` 下一行追加）
- 查看文件内链：`type 文件名`（如果查看的是 `txt` 文件，该命令会直接输出文本内容）
- 复制文件：`copy 旧文件 新文件`
- 移动文件：`move 旧文件 新文件`
- 删除文件：`del 文件名/文件表达式`（如，删除当前目录所有txt文件：`del *.txt`）

## 其他指令
- 清空当前屏幕：`cls`
- 退出当前 CMD 程序：`exit`

## 常用的运行命令
### 可能需要经常打开的程序
- 快速打开`运行`：`win+R`
- 打开本机`服务`列表：`services.msc`
- 程序和功能：`appwiz.cpl`
- 任务管理器：`taskmgr`
- 控制面板：`control`
- 注册列表：`regedit`
- 控制面板\网络和 Internet\网络连接：`ncpa.cpl`
- 控制面板\系统\属性：`sysdm.cpl`【你可以快速设置`环境变量的地方`】

### 设置定时关机
- 定时关机，如，3600秒后关机：shutdown -s -t 3600
- 设置具体时间关机：at 21:20 shutdown -s
- 取消关机命令：shutdown -a

### 磁盘清理
- 磁盘清理：`c:\windows\SYSTEM32\cleanmgr.exe /小写盘符Drive` 
> 注意：在此命令中，占位符驱动器表示要清除硬盘的驱动器号。不过自从我用了 Dis++ 和火绒，已经不怎么用这个命令了。
- 直接进行磁盘清理(所有磁盘)： cleanmgr /SAGERUN:99


### 系统设置
- 系统设置(开机启动项)：msconfig
- 关闭休眠模式：powercfg -h off
> 如果觉得休眠功能没用可以关闭，避免C盘下产生不必要垃圾
> - pagefile.sys 系统文件转移(可以直接删除 hiberfil.sys )：http://www.windows764.org/news/17155.html

### 系统信息
- 展示 windows 系统版本信息：winver

我常用的基本就是上述命令了，如果想了解更多推荐阅读：[Window系统命令行调用控制面板程序](https://www.cnblogs.com/lsgxeva/p/8426893.html)


## 写在最后
Windows 上常用操作执行 DOS 的终端有：`CMD.exe` 和 `PowerShell`，而正如 `https://www.varonis.com/blog/powershell-vs-cmd/` 中介绍到的一样

> There isn’t any command left in CMD that isn’t in PowerShell, and PowerShell includes cmdlets for any administration function you could need. 

也就是说：`CMD` 有的 `PowerShell` 都有，`PowerShell` 有的 `CMD` 不一定有，因此能使用 `PowerShell` 就不要使用 `CMD`.

## 推荐阅读
- [shell、cmd、dos和脚本语言区别和联系](https://www.cnblogs.com/steamedfish/p/7123749.html)
- [浅谈Windows环境下DOS及MS-DOS以及常见一些命令的介绍](http://www.imooc.com/article/details/id/252112)
- [Windows 用户需要知道的 CMD 常用命令总结](https://zhuanlan.zhihu.com/p/67513308)
- [Linux下的shell工作原理是什么？](https://blog.csdn.net/YEYUANGEN/article/details/6858062)
- [电影推荐：硅谷传奇](https://movie.douban.com/subject/1298084)


转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)

扫描下方二维码，关注公众号，接收更多实时内容
![关注公众号：Leaders工作室](/images/article/WeChat/Leaders.png)