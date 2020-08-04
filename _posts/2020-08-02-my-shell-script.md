---
layout: post
title: "Shell 收集"
date: 2020-08-02
tag: Shell,awk,sed,grep,xargs
---

## 批量重命名：使用管道，通过`sed`文本替换，实现批量重命名
![rename file](/images/article/shell-pipline-renamefile.png)
```shell
ls *.pdf | grep -F "[天下无鱼][shikey.com]" | sed "s/\[天下无鱼\]\[shikey.com\]//" | xargs -I {} mv [天下无鱼][shikey.com]{} {}
```

`for-in` 遍历实现

```sh
#!/usr/bin/bash
IFS=$'\n'
for file in $(ls *.$1)
do
        newfile=`echo $file | sed "s/$2/$3/g"`
        echo $newfile
        mv $file $newfile
done
```

## 批量删除 N 天前文件或文件夹
```
find /data/htdocs_deploy/all_project/ -maxdepth 1 -type d -mtime +30 -name "feature-*" -exec rm -rf {} \;
```
或
```
find /data/htdocs_deploy/all_project/ -maxdepth 1 -type d -mtime +30 -name "feature-*" | xrags rm -rf
```

- `/data/htdocs_deploy/all_project/` --设置查找的目录；
- `-maxdepth 1` 设置查询目录层级(若`-type`选项设置为`d-文件夹`，该选项必须放在`type`选项前)
- `-mtime +30` --设置修改时间为30天前；(`-atime`-最后访问时间；`-ctime`-创建时间)
- `-type d` --设置查找的类型为文件；其中`f`为文件，`d`则为文件夹
- `-name "*"` --设置文件名称，可以使用通配符；
- `-exec rm -rf {}` --查找完毕后执行删除操作，`{}`表示变量；
- `\;` --固定写法

## 对指定目录下的所有文件，进行匹配查找
```sh
find <path> -type f -name ".*.conf" | xargs grep "server_name"
```

等价于

```sh
grep "server_name" -r <patn> -n 
# -r <path> 递归查询指定目录
# -n 显示行编号
```

## 树状打印目录层级
- `tree`打印指定目录层级
```sh
tree -L n
```
- `-L n` 指定打印目录层级

## 查看系统用户登录日志
```sh
last [-n 100 | -100] -f /var/log/wtmp
```
- `-n <num>`或`-<num>` 指定前<num>行记录
- `-f` 指定文件[默认从`/var/log/wtmp`文件读取]

## 查看磁盘空间使用情况
```sh
du -h --max-depth=1 <path>
```
- `-h | --human-readable` 以 K，M，G为单位输出，提高可读性
- `-max-depth=<num>` 指定打印信息的目录层级



