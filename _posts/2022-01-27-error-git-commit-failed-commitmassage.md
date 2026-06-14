---
layout: post
title: pre-commit hooks 引起的 GIT_DIR 下 COMMITMESSAGE 提交失败
date: 2022-01-27
tags: [Git,Fork]
---

## 背景

最近在研究 git hooks 实现代码质量检测，并能否结合 git worktree 的方式实现目前测试环境的多分支环境的全量包部署。

在 `pre-commit` 这个 hooks 脚本最后，我增加了自动检测 `*.go` 文件，使用 `gofmt` 自动格式化的脚步，然后今天突然发现 `git commit` 不了了。

用命令行执行 `git commit -m "message"` 没有任何报错，但是用 GUI 工具提交的时候报了下面这个错误出来。

![$ git commit --file="XXX/.git/COMMITMESSAGE"](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/ERROR-GIT_DIR-COMMITMESSAGE.png)

## 排查

一开始给整懵了，考虑到 `Fork` 是 GUI 工具只是对 `git` 命令的封装，想着用命令行看看具体报错信息，结果发现用命令行反而什么错误信息都没有。

最初也没往 hooks 文件错误方向去思考，因为修改了 hooks 文件后，我在家里的 repository 提交成功过，但今早来公司更新了 hooks 后却不行。

但确实除了更新 hooks 文件并未有其他改动，于是将 `git config core.hooksPath` 配置的 hooks 路径注释了，发现确实又可以提交了，**初步定位：确实是 hooks 文件引起；然后：逐个执行排查昨天更新的 hooks 文件确定有问题的脚步**。

单独在项目中执行 `/<HOOKS_PATH>/pre-commit` 脚步，通过 `eco $?` 发现这个脚本返回的错误码是 1。即：文件执行返回的错误码异常，从而引起了 `$GIT_DIR/COMMITMESSAGE` 文件异常，导致执行 `git commit` 操作失败。

## 解决

`pre-commit` 脚步最后执行（更新的内容）如下：

```shell
command -v gofmt >/dev/null 2>&1 && {
    # 获取暂存区中待 commit 的 *.go 文件
    golang_files=$(git diff --cached --name-only --diff-filter=ACM -- '*.go')
    for FILE in $files
    do
        gofmt -w $FILE
        echo "格式化："$FILE
        git add $FILE
    done
}
```

脚步最后通过 `command -v gofmt >/dev/null` 检测当前环境是否安装了 `gofmt` ，若有安装则自动格式化暂存区中的 `*.go` 代码文件然后重新添加到暂存区中进行提交。

> 这里的写法是 `Shell` 脚步中实现三元运算符 `?:` 的操作，可以通过 `<command> && <yes-PS:when the command return the error code is 0> || <no-PS:when the command return the error code is not 0>` 方式。

由于公司电脑没有安装 `Go` 的环境，因此命令执行错误返回了错误码 1，整个 `pre-commit` 脚步会将 `$?` 的值作为脚步的错误码进行返回。因此，`pre-commit` 执行失败，阻止了 `git commit` 的动作，解决只需要保证脚步的最后是通过 `exit 0` 结束整个脚步的即可。

即，如下：

```shell
# 最后至关重要！！！
# 防止上述命令有非成功推出，shell脚本默认返回 $?
# return 只能用于 function 中
exit 0
```

## 附录：$GIT_DIR/COMMITMESSAGE 和 $GIT_DIR/COMMIT_EDITMSG 的区别

在排查过程中，查了一下 [Git 官方的文档](https://git-scm.com/docs/git-commit#_files) 也没有查到 `$GIT_DIR/COMMITMESSAGE` 的信息，只有 [`$GIT_DIR/COMMIT_EDITMSG`](https://git-scm.com/docs/git-commit#Documentation/git-commit.txt-codeGITDIRCOMMITEDITMSGcode) 文件的描述。

> **$GIT_DIR/COMMIT_EDITMSG**
>
> This file contains the commit message of a commit in progress. If `git commit` exits due to an error before creating a commit, any commit message that has been provided by the user (e.g., in an editor session) will be available in this file, but will be overwritten by the next invocation of `git commit`.

即：`.git/COMMIT_EDITMSG` 文件会保存了每次 `git commit` 的内容，即便`git commit`的过程出错了（注意：pre-commit hooks 发生在 `git commit` 之前，因此这个 hooks 出错的话，该文件的内容是不会被记录更新的）也会记录这个信息。

对 `.git/COMMITMESSAGE` 文件却只字未提，在`Git`源码中也未曾找到这个关键词的信息。

通过做了实验，得如下信息（简易记录一下）：

1. `.git/COMMITMESSAGE` 是由 `Fork` 这个 GUI 工具在触发 `pre-commit` 前创建出来的，并非 Git 自身所创建
2. `.git/COMMIT_EDITMSG` 文件由 `commit-msg` 这个 hooks 文件几乎同时被创建并写入信息的（注意：并非触发才会被创建）
3. `pre-commit` 早于 `commit-msg` 被触发
4. 不管是 `git commit` 操作是结果如何，`.git/COMMIT_EDITMSG` 总是会更新记录 `git commit [-m "msg"]` 的 msg 信息