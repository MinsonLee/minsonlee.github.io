---
layout: post
title: "如何将本地分支同时推送到多个远程分支？"
date: 2022-02-21
tags: [Git]
---

## 背景

由于在国内访问 Github 速断相对比较慢，因此一些项目我们可能需要同时推送到 Github 和国内的 Gitee。

我们可以通过 `git remote add <origin name> <url>` 设置多个 remote，如下:

![git for multi remote](/images/pig/git-multi-remote.png)

但是，推送的时候就需要分开逐个提交

```shell
# 先推送 github 远程
git push origin main:main

# 再推送 gitee 远程
git push gitee main:main
```

这样每次提交的时候都需要两步操作才可以，还是比较费时费力的。

## 设置多个远程推送分支

其实，我们可以通过为同一个 remote 设置多个 push 链接，来达到一键推送多个远程分支的效果。
`git remote set-url --push --add <name> <url>` 可以添加 push 远程地址；`git remote set-url --push --delete <name> <url> ` 可以删除 push 远程地址。

```sh
git remote set-url --add --push origin git@gitee.com:minson-lee/vim.git
```

![git for multi push url](/images/pig/git-multi-push-url.png)

或者可以直接编辑 `.git/config` 文件，添加 `pushurl` 属性进行上述设置

![git remote for multi push url](/images/pig/git-remote-multi-pushurl.png)

最后来看一下效果吧！

![git push for multi url](/images/pig/git-push-for-mulit-url.png)

注意：添加了多个 push url 的时候，第一次 push 的时候需要 `git push -u origin main` 命令， `-u` 属性是添加远程追踪。