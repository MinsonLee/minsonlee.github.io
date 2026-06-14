---
layout: post
title: "硬链接和软链接有什么区别？"
date: 2022-02-27
tags: [Linux]
---

## ln 命令简介

`ln <source path> <link path>` 是 *inux 系统下建立链接文件的命令。 

`ln` 的解释如下：

```txt
Usage: ln [OPTION]... [-T] TARGET LINK_NAME   (1st form)
  or:  ln [OPTION]... TARGET                  (2nd form)
  or:  ln [OPTION]... TARGET... DIRECTORY     (3rd form)
  or:  ln [OPTION]... -t DIRECTORY TARGET...  (4th form)
In the 1st form, create a link to TARGET with the name LINK_NAME.
In the 2nd form, create a link to TARGET in the current directory.
In the 3rd and 4th forms, create links to each TARGET in DIRECTORY.
Create hard links by default, symbolic links with --symbolic.
By default, each destination (name of new link) should not already exist.
When creating hard links, each TARGET must exist.  Symbolic links
can hold arbitrary text; if later resolved, a relative link is
interpreted in relation to its parent directory.
```

由上述解释可以看出 `ln` 创建出来的链接文件可以分为：硬链接-`hard links`、软链接-`symbolic links`。

## ext4 文件系统的简述

在说 `ln` 命令创建出来的两种文件类型区别之前要谈一下 Linux 的文件系统 `ext4`，其简单的示意图如下：

![ext4 File System Schematic](/images/pig/ext4-file-system-schematic.png)

- ext4 文件系统可以简单的划分为：inode + block
- 一个文件都独自占用一个 inode，占用1个或多个 block。
- inode 的默认大小为 128 Byte，用来记录文件的权限（rwx）、文件的所有者和属组、文件的大小、文件的状态改变时间（ctime）、文件的最近一次读取时间（atime）、文件的最近一次修改时间（mtime）、文件的数据真正保存的 block 编号（PS：通过 `stat File` 可以查看这些信息。**文件名不记录在 inode 中**）。
- block 的大小可以是 1KB、2KB、4KB，默认为 4KB。block 用于实际的数据存储，如果一个 block 放不下数据，则可以占用多个 block。例如，有一个 10KB 的文件需要存储，则会占用 3 个 block，虽然最后一个 block 不能占满，但也不能再放入其他文件的数据。这 3 个 block 有可能是连续的，也有可能是分散的。

![stat file for ln](/images/pig/20220227111239.png)

PS ：可以通过 `df -T` 查看系统的文件类型

```txt
lms@lms:/$ df -T /dev/sda
Filesystem     Type 1K-blocks    Used Available Use% Mounted on
/dev/sda       ext4 263174212 6341468 243394588   3% /
```

-------

## 硬链接和软链接的区别

### 软链接

软链接：类似于 Windows 系统中给文件创建快捷方式，即产生一个特殊的文件，该文件存储了指向另一个文件的位置信息。

通过 `ln -s <source path> <link path>` 或 `ln --symbolic` 命令建立的软链接文件，使用 `ls -ahl` 可以查看到是 `l` 开头的（PS:`lrwxr-x---`），通过 `test -L <link file>` 返回得到的结果是 0 （即：是一个软链接文件）


**注意：如果是创建软链文件 <source path> 必须要写绝对路径，否则会报错（而创建硬链接没有这样的要求）。**


### 创建硬链接

硬链接：从上述知道文件的基本信息都存储在 inode 中，而硬链接指的就是给一个文件的 inode 分配多个文件名，通过任何一个文件名，都可以找到此文件的 inode，从而读取该文件的数据信息。

创建硬链接文件可以通过 `ln <source path> <link path>` 或者 `cp -l <source path> <link path>` 两种方式创建。

使用 `ls -ahl` 可以查发现它就是一个和源文件一样的正常文件。

### 修改或删除源文件带来影响

硬链接和软链接文件的非准确示意图可以简单表示为如下：

![硬链接和软链接文件的简单示意图](/images/pig/linux-diffrenct-link-file.png)

- 修改源文件：源文件和硬链接文件的最后修改时间同步修改，软链接文件的最后修改时间不变。
- 删除源文件：硬链接文件依然可用（源文件和 block 断开了联系，但是硬链接文件的 inode 和 block 依然存在联系）；删除软链接文件的源文件，软连接不可用（因为软链接只是一个“路标”，最终只是指引软链去找源文件的 inode）

### 对磁盘空间的影响

参考这篇文章： [关于硬链接与软连接占用磁盘空间问题的分析研究](https://blog.51cto.com/jk6627/1949090) 里面写的很清楚了。

结论：**硬链接不占用磁盘空间，软链接占用的空间只是存储路径所占用的极小空间**。