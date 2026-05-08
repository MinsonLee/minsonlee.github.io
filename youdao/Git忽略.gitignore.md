# 解决.gitignore无法忽略文件以及忽略.gitignore方法
[TOC]

## .gitignore须知

- `.gitignore`文件使用正则的表达语法进行文件忽略
- `.gitignore`只能忽略`Untrack files` (即：自创建项目仓库以后，从未 add 及 commit 过的文件)

-   如果你确实想添加该文件，可以用 `-f` 强制添加到Git：

```
$ git add -f xxx[具体文件/正则匹配的文件]
```

- 检查修改文件到底是被`.gitignore`中哪一个规则所忽略的：

```
$ git check-ignore -v vendor/autoload.php
.gitignore:2:**vendor   vendor/autoload.php
```
> 告诉我们是.gitignore文件的第2行:`**vendor`规则，导致了`vendor/autoload.php`被忽略


```
$ git check-ignore -v vendor/*
.gitignore:2:**vendor   vendor/autoload.php
.gitignore:2:**vendor   vendor/bin
.gitignore:2:**vendor   vendor/composer
```

## 通过update-index忽略.gitignore自身
在每个clone下来的仓库中手动设置不要检查特定文件的更改情况。

```
# 标识指定文件修改不被记录
$ git update-index --assume-unchanged PATH/FILE
```

```
# 重新标识文件被记录
$ git update-index --no-assume-unchanged PATH/FILE
```
在`PATH/FILE`处输入要忽略的文件。

## 使用.gitignore忽略自身

**项目未创立**

在项目仓库创立最初，确定不追踪.gitignore，直接在.gitignore文件中添加自身

**项目已创立**

```
git rm -r --cached .
git add .
git commit -m 'update .gitignore'
```

> `git rm -r --cache <files>` --删除指定文件的追踪状态，但并不会删除本地物理文件及过往对该文件的提交

1. 参考：[https://segmentfault.com/q/1010000000430426](https://segmentfault.com/q/1010000000430426)