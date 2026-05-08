[TOC]
# 1. 准备工作
1. 首先你要有能在Windows下安装破解Navicat Preminm的能力
2. 去"[官网](http://www.navicat.com.cn/download/navicat-premium)"下载你所需要的"Navicat Preminm for Linx"版本

# 2. Navicat Preminm for Linx安装
1. 解压下载后的源码文件：tar -xzvf navicat_premium_cs_x64.tar.gz
2. 是不是看到“Wine”这个文件夹了(要是没看到，可以离开这篇文章了)?
>可以看出：
>- 所谓的”Navicat Preminm for Linx“其实就是Windows的程序通过Wine在Linux上跑而已;
>- Navicat文件夹下面的文件文件跟你在Windows下安装Navicat后的目录结构一样
3. 执行安装：sudo ./start_navicat 【然后就是傻瓜式操作，自动会下载Wine然后就OK了】

# 3. 激活
> 把Windows下安装激活后的文件夹直接"复制替换"就好

# 4. 解决Navicat Preminm for Linux中文乱码
1. 查看自己电脑所用的语言字符集：locale
2. 将start_navicat中的`export LANG="en_US.UTF-8"`改为跟你电脑`LANG=zh_CN.UTF-8`
> 如果你安装Linux发行版时选择的语言是中文才会有这个问题

# 5. 添加快捷方式到桌面
1. 做面新建：navicat.desktop > touch navicat.desktop
2. 编辑键入以下信息：
```
[Desktop Entry]
Encoding=UTF-8
Name=Navicat Preminm
Comment=The Smarter Way to manage database
Exec=/bin/sh "/Program/navicat_premium/start_navicat"
Icon=/Program/navicat_premium/Navicat/icon.png
Categories=Application;Database;MySQL;navicat
Version=12.0.20
Type=Application
Terminal=0
```
> 注意点：
>- Exec=/bin/sh "这里是start_navicat的绝对路径"
>- Icon="这里填写你定制化的图标：桌面快捷图标"
3. 赋权执行：sudo chmod 777 navicat.desktop