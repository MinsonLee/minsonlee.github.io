---
layout: post
title: "Shell 收集"
date: 2020-08-02
tag: Shell,awk,sed,grep,xargs
---
[TOC]

## 1. 批量重命名：使用管道，通过`sed`文本替换，实现批量重命名
![rename file](/images/article/shell-pipline-renamefile.png)
```shell
ls *.pdf | grep -F "[天下无鱼][shikey.com]" | sed "s/\[天下无鱼\]\[shikey.com\]//" | xargs -I {} mv [天下无鱼][shikey.com]{} {}
```