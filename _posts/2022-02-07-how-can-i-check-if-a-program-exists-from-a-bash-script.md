---
layout: post
title: Shell 中检查某个命令是否存在
date: 2022-02-07
tags: [Shell]
---

本文仅为参考文章的学习笔记记录。

在 Linux 中，我们想检查某个命令是否存在，往往会使用：`which`、`type`、`hash`、`command` 进行查看。若存在对应命令则会返回命令路径信息且 `$?` 返回零值，若不存在则 `$?` 返回非零值且显示错误行。


以下命令的展示效果是在 Ubuntu 系统下进行实验得到，不同发行版对于输出信息可能会不一致，但 `$?` 返回值绝大部分都是一致的。

- `which` 命令的作用是在 `PATH` 变量指定的路径中，搜索某个系统命令的位置，并且返回第一个搜索结果。
    - **注意：`which` 不是 Shell 的内置命令。即：不是所有发行版都支持该命令的**
    - which <command> 存在：返回对应命令路径且 `$?` 返回零值
    - which <command> 不存在：无信息输出，`$?` 返回非零值


- `type <command>` 命令用来显示指定命令的类型，判断给出的指令是内部指令还是外部指令
    - alias 命令是用户或系统自定义的别名的命令。PS：`ll is aliased to 'ls -alF'`
    - keyword 命令是 Shell 的关键保留词
    - function 命令是 Shell 的方法名
    - builtin 命令是 Shell 内建命令
    - file 文件，磁盘文件，外部命令
    - unfound 没有找到（**当且仅当这种情况情况，`$?` 返回非零值**）


- `hash`命令负责显示与清除命令运行时系统优先查询的哈希表（hash table）
    - hash <command> 无信息输出，若命令存在 `$?` 返回零值，不存在则返回非零值
    -  hash <command> 若命令存在，可通过 `hash -l` 可以查看命令所在路径
    

- `command -v <command>` command 命令调用指定的指令并执行，通过 `-v` 或 `-V` 参数可以不执行命令，但搜索命令和打印不执行命令。
    - `command -v command` 其实和 `type` 命令的返回类似，但`command`不查询 shell 函数

**总结：推荐使用 `command -v <command>` 命令来进行检查。因为对于`POSIX`风格的 Shell 脚本，`type` 和  `hash` 对于 `$?` 的返回值支持不是很好（即：命令不存在也可能返回零值）。**

```shell
command -v ssh > /dev/null 2>&1 && {
 echo "ssh 命令存在";
} || {
    echo "ssh 命令不存在";
}
```

**参考阅读：**

- [命令参数的三大风格：Posix、BSD、GNU](https://my.oschina.net/u/589241/blog/2876942)
- 原文：[How can I check if a program exists from a Bash script?](https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script)
- 译文：[Shell 中检查某个命令是否存在](https://blog.51cto.com/xoyabc/1902804)