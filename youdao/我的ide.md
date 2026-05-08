# 我用 IDEA 的一些问题

[TOC]

- [Jetbrains系列产品重置试用方法](https://zhile.io/)
- [PHPStrom 主题配置](https://raw.githubusercontent.com/daylerees/colour-schemes/master/jetbrains/peacock.icls)
- [解决IDEA CPU 100%导致IDE卡慢的问题](https://blog.csdn.net/weixin_41846320/article/details/106264297)
- [IDEA的CPU占用率高问题解决方法](https://www.xiaoguantongxue.com/blog/26)
- [PHPStrom 主题 Github 推荐](http://daylerees.github.io/)

**修改图标**

1. 打开 `Preferences>Plugin`，点击 `Browse repositories`
2. 搜索 `Material Theme UI`

## IDEA 重置

- 在`Settings/Preferences... -> Plugins` 内手动添加第三方插件仓库地址：`https://plugins.zhile.io`
- 搜索：`IDE Eval Reset`插件进行安装

## 工具：`PHPStrom` 修改 `IDE` 终端 `Terminal` 为 `Git-Bash`

- 打开设置（快捷键： `Ctrl + Alt + S` ），进入 `Plugins`, 搜索栏搜索 `Terminal`，查看 `Terminal` 插件是否安装，如果没有，请打勾进行安装。
- 进入设置（快捷键：`Ctrl + Alt + S` ），进入 `Tools` 字段，再进入 `Terminal` 字段，在 `Shell path` 那一栏中，输入你主机 `Git Bash` 的安装位置

```sh
"C:\Self\code\CVS\Git\bin\bash.exe" -login -i
```

重新启动 `Idea IDE`, `Terminal` 已成功更改为 `git-bash` 了

![change IDEA Terminal](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20220627145943.png)

## 工具：`phpstorm` 不能选择 `php language level` 问题

项目需要用 `php7.*.*` 版本 但是在编辑器里面写一些 `php7` 的新语法，编译器老是红波浪线报错，虽说不存在其他的影响，但总归看着好像自己写了很多 `bug` 一样，很不爽...

知道问题应该是需要修改 `PHPStrom` 中 `PHP` 版本的设置，找到了位置却发现修改不了...

**解决方法**

1. 取消 `composer` 设置：同步 `composer` 中的 `PHP` 版本到 `PHPStrom`

![IDEA Cancel Synchronize composer.json](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/idea-cancel-synchronize-composer.png)

**取消勾选之后，一定要应用然后先关闭，再打开进行下列操作**

如果勾选了，这个地方的列表是选择不了的

2. 选择设置 PHP 版本

![Select PHP Version](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/idea-change-php-version.png)


## `Intellij IDEA` 添加 `PHP` 项目依赖

`File` --> `Project Structure` --> 选择 `Modules` --> 点击 `+` --> `Import Module`，选择要添加的项目即可！

- [IntelliJ IDEA 教程](https://guobinhit.github.io/intellij-idea-tutorial/)


## IDEA Java 输出控制台中文乱码

乱码的原因：操作系统、输入流、输出流、输出承载展示工具 这几方有其中一项或多项的编码与其他不一样，从而导致了对于同一个字符用了不同编码来解析导致的。

一般来说，只要：输入编码、输出编码是一样的，那么就不会产生乱码。

1. 查看操作系统的编码

Windows + R 输入 cmd，打开 DOS 窗口，在命令行工具输入 `chcp` 查看当前系统默认设置的系统`cmd > chcp`

- 936-GBK
- 65001-UTF8]

2. 查看 IDEA 控制台的编码

一般默认是 CMD 或者 Powershell 工具，只要设置了系统的编码为 UTF-8 之后，CMD/PowerShell 的编码就会变成 UTF-8

如果是 Git Bash，则通过 [解决 Git Bash 在 windows 下中文乱码的问题](https://minsonlee.github.io/2020/11/how-to-set-utf8-with-git-bash) 处理

3. 查看文件的编码方式

通过“记事本”程序 或 IDEA 打开你的代码文本文件，查看编辑器右下方的文件编码，将文件改为 UTF-8 再进行保存

4. 查看 IDEA 的 Font 、File Encodings 

字体支持：一般来说绝大部分字体都是支持中文的，可以简单看一下：`File` > `Settings` > `Editor` > `Font` ，如果不确定自己的字体是否支持中文的，就选择微软雅黑吧。

文件编码：`File` > `Settings` > `Editor` > `File Encodings`，然后将：`Global Encoding`、`Project Encoding`、`Properties File` 都设置为 `UTF-8`

![IDEA File Encodings](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/idea-settings-file-encoding.png)

一般来说，以上设置之后应该就可以了。如果仍然是乱码，那么查看当前 Project 目录下的 `.idea` 中的 `encodings.xml` 文件，看一下是不是项目编码的缓存没有更改过来。如果此处不是显示 UTF-8，将该文件删除，关闭编辑器然后重新打开令其重新生成即可。

![encodings.xml](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/idea-project-encoding-cache-file.png)

5. 设置 IDEA 的 vmoptions

打开 IDEA 的安装目录，在 bin 目录下有`idea.exe.vmoptions` 或 `idea64.exe.vmoptions` 文件。

或者可以通过：打开 IDEA 编辑器，然后菜单栏选择 `Help` > `Edit Custom VM Options` 会自动打开 vmoptions 文件。在文件末尾新增行添加：`-Dfile.encoding=utf-8`，然后**重启编辑器**，再次查看中文是否乱码。

此时可能会出现：通过 logger 写入到文件的中文不是乱码，但是 `System.out.println()` 输出的中文仍然乱码。

查看是否手动设置了 Tomcat VM options 或 Spring Boot VM options，将 `-Dfile.encoding=UTF-8` 加上

![Edit Configurations](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/edit-project-vm-options.png)

设置完，重启编辑器查看是否有效。

6. 如果仍然没有效果，尝试重新安装 IDEA。这是最无解的操作...不过在操作中确实是有效的，莫名其妙可以。若仍然不行，希望你解决了之后能告诉我一下~谢谢