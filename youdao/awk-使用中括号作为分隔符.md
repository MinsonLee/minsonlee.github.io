[TOC]

## awk 语法

awk系列博文直达链接：
- [AWK命令总结之从放弃到入门（通俗易懂，快进来看）](https://www.zsythink.net/archives/tag/awk)
- 官方文档：https://www.gnu.org/software/gawk/manual/gawk.html

## awk 自定义分隔符

### awk 处理特殊字符作为分隔符

### 来个"栗子"-使用中括号作为分隔符

通过 `awk` 将文件 `[abc][abc]xxx` 重命名为 `xxx`

1. 批量查找出 `[abc][abc]xxxx` 的文件
2. 通过 `awk` 处理文件名，输出重命名命令

```sh
find -type f -name "*abc*" | awk -F"[[]abc[]][[]abc[]]" '{print "mv \""$0"\" \""$1$2"\""}'
```
![use awk to rename `[abc\][abc\]00.test-awk.pdf` to `00.test-awk.pdf` ](606835E1F2F24C7DA30E0F50B614AFE8)

3. 执行命令

```sh
find -type f -name "*abc*" | awk -F"[[]abc[]][[]abc[]]" '{print "mv \""$0"\" \""$1$2"\""}' | bash
```
![use awk to rename `[abc\][abc\]00.test-awk.pdf` to `00.test-awk.pdf` ](E561BF2F80894852B9D667F93EBF4F07)

## awk-打印指定列到最后一列

```shell
history|awk -F " " '{for (i=2;i<=NF;i++)printf("%s ", $i);print ""}' 
```

## 设置列宽

```shell
# 打印第1、3 列：第一列左对齐，60个字符宽度；第 2 列，左对齐，10字符宽度
kubectl get pods | awk '{printf "%-60s %-10s\n", $1,$3}'
# kubectl get pods | awk '{printf "%-60s %-s\n", $1,$3}'
```