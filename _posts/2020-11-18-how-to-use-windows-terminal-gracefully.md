---
layout: post
title: "如何优雅的使用 Windows Terminal"
date: 2020-11-18
tag: Windows
---

`Windows`的命令行向来是以丑著称，`Windows Terminal`总算是挽救了一点它的颜值。

![Windows Terminal](/images/article/windows-terminal.png)

- 安装：https://github.com/microsoft/terminal
- 使用指南：https://docs.microsoft.com/zh-cn/windows/terminal/customize-settings/global-settings
- [如何给 Windows Terminal 增加一个新的终端](https://blog.csdn.net/WPwalter/article/details/100159481)

## 添加`Git-Bash`到`Windows Terminal`

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

## 将`Windows Terminal here`加入到右键菜单

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