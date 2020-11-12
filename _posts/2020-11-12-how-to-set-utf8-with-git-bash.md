---
layout: post
title: "解决 Git Bash 在 windows 下中文乱码的问题"
date: 2020-11-12
tags: [Git,中文乱码]
---

## 背景
中文乱码的根源在于 `Windows` 基于一些历史原因无法全面支持 `UTF-8` 编码格式，并且也无法通过有效手段令其全面支持，对于中文，`Windows`系统默认使用`GB2312`编码进行处理，而`Git`默认使用`UTF-8`。

而对于在`Windows`下喜欢用命令行的朋友，`Git Bash`是一款不可多得的好工具：安装简单、操作简单、集成部分实用`Linux Shell`工具。但`Git Bash`在`Windows`下中文会乱码的问题的确着实令人头痛。

## 解决

### Git-Gui 右键设置编码

![git-gui-set-utf8.png](/images/article/git-gui-set-utf8.png)

### 修改`gitconfig`

进入`Git`安装目录，打开`git-bash.exe`程序，依次输入下列命令：

```sh
$ git config --global core.quotepath false          # 设置显示 status 编码
$ git config --global gui.encoding utf-8            # 设置图形界面编码
$ git config --global i18n.commit.encoding utf-8    # 设置提交信息编码
$ git config --global i18n.logoutputencoding utf-8  # 设置输出 log 编码
```

### 修改环境变量

`Git`命令在输出`log`信息时使用的是`less`这个工具，默认和`Windows`中的编码格式不兼容，因此导致在使用`git log`时中文会乱码。

设置`LESSCHARSET`环境变量使用 `UTF-8` 即可解决该问题！

1. **设置`Git Bash`环境变量-修改文件`$GIT_INSTALL_DIR/etc/profile`**

> `Git`安装目录下的`/etc`目录是个非常值得研究的目录，很多配置文件都放在其中！

```sh
# 在文件最后追加
export LESSCHARSET=utf-8
```

关闭`Git Bash`重新打开，输入`echo $LESSCHARSET`，如果输出`utf-8`证明设置成功！此时输入`git log`可以看到中文乱码问题已得到解决！

![git-bash-show-git-log-with-chinese.png](/images/article/git-bash-show-git-log-with-chinese.png)


2. **设置`Windows`系统常量-解决`PowerShell`或`CMD`等命令行工具输出`git log`中文乱码**

`Windows`键+`R`打开运行，输入`sysdm.cpl`打开系统属性，选中“高级”这个Tab，点击“环境变量”。新建系统变量

![windows-set-PATH-lesscharset.png](/images/article/windows-set-PATH-lesscharset.png)

关闭`PowerShell`重新打开，输入`echo $env:LESSCHARSET`，如果输出`utf-8`证明设置成功！此时输入`git log`可以看到中文乱码问题已得到解决！

![powershell-show-git-log-with-chinese.png](/images/article/git-powershell-show-git-log-with-chinese.png)

## `WSL 2`集成`Git Bash`并解决其乱码问题
> 感谢知乎网友-喵NLI：https://zhuanlan.zhihu.com/p/166407830

但我并没有像上文中网友说的那么复杂的情况，我只做了如下修改就已经解决了`WSL 2`集成`Git Bash`的乱码问题：将`commandline`位置从`$GIT_INSTALL_DIR\\bin\\bash.exe`修改为了`$GIT_INSTALL_DIR\\usr\\bin\\bash.exe --login -i`

附上`WSL`设置的`profiles`文件即可
```json
{
    // guid 可以通过网上查询 guid 生成器生成：http://tool.pfan.cn/guidgen
    "guid": "{ce7a80b8-da75-4628-a2e1-663af0f3ce7c}",
    "name": "git",
    "icon": "C:\\Self\\code\\CVS\\Git\\git-for-windows.ico",
    "commandline": "C:\\Self\\code\\CVS\\Git\\usr\\bin\\bash.exe --login -i",
    "startingDirectory":"D:\\htdocs",
    "hidden": false,
    "acrylicOpacity" : 0.8,
    "colorScheme" : "Campbell",
    "cursorColor" : "#FFFFFD",
    "fontFace" : "Fira Code",
    "useAcrylic" : true,
    "backgroundImage":"C:\\Users\\Minso\\Pictures\\Camera Roll\\goldfish.png",
    "backgroundImageOpacity":0.35,
}
```