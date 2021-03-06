---
layout: post
title: "Shell 收集"
date: 2020-08-02
tag: Shell
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
- `-exec rm -rf {} \;` --查找完毕后对每一行记录执行删除操作，`{}`表示变量；
- `-exec rm -rf {} \+` --查找完毕后将所有记录作为一个参数传递到`rm`命令中，执行一次命令 

## 通过`awk`实现批量重命名并归档文件
将所有文件下的`.avi`文件移动到当前目录下，并将文件`xxx.avi`统一命名为`文件名称.avi`的方式

![linux-tree-awk-mv-file](/images/article/linux-tree-awk-mv-file.png)

```sh
find -type f -name *.avi | awk -F"/" '{print "mv \""$0"\" \""$2".avi\""}'|sh
```
- 先通过 `find`命令查询匹配出所有的`.avi`文件，因为文件名有重复，因此需要额外进行文本提取再执行`mv`
- 通过 `awk` 进行文本提取，但是 `awk` 本身无法调用执行 `mv`，因此此处通过`print`出完整的`mv`命令
- 由于文件名中可能含有空格等字符，因此`mv`需要将后续的路径作为一个完整的整体看待
- 通过管道将`mv`命令传递给`sh`进行调用执行

## 对指定目录下的所有文件，进行匹配查找
```sh
find <path> -type f -name ".*.conf" | xargs grep "server_name"

或

find <path> -type f -name ".*.conf" -exec 'grep "server_name"'
```

等价于

```sh
grep "server_name" -r <patn> -n 
# -r <path> 递归查询指定目录
# -n 显示行编号
```

## 遍历目录，对config_center目录执行composer更新
![tree fo config_center](/images/article/linux-tree-coinfig_center.png)
### 通过 `find-exec`方式
```sh
find <path> -maxdepth 2 -type d -name "config_center" -exec bash -c "cd {} && /apps/xxx/bin/php /apps/xxx/composer update --no-dev" \;
```

### 通过`find|xargs`方式
```sh
find <path> -type d -maxdepth 2 -name config_center | xargs -t -L 1 bash -c 'cd "$0" && /apps/xxx/bin/php /apps/xxx/composer update --no-dev'
```

### 通过通配符方式进入`config_center`
```sh
find <path>/*/config_center -type d -maxdepth 0 | xargs -t -L 1 bash -c 'cd "$0" && /apps/xxx/bin/php /apps/xxx/composer update --no-dev'
```
- `bash -c <string>`： If the `-c` option is present, then commands are read from string.  If there are arguments after the string, they are assigned to the positional parameters, starting with `$0`.



## 树状打印目录层级

- `tree`打印指定目录层级
```sh
tree -L n
```
- `-L n` 指定打印目录层级

## 递归删除空目录
![tree empty dir](/images/article/linux-tree-empty-dir.png)
```shell
#!/usr/bin/bash
# author:limingshuang
# description:递归删除空目录
# error:
#     1 - 检查目录缺失
#     2 - 输入路径非目录文件

if [ -z $1 ];
then
    echo "请输入需要检查的目录路径"
    exit 1
fi

if [ ! -d $1 ];
then
    echo "输入路径不是一个目录！！！"
    exit 2
fi

while [ `find $1 -depth -empty -type d | wc -l` -ne 0 ];
do
    find $1 -depth -empty -type d -delete
done
```
![delete empty dir](/images/article/linux-receive-delete-empty-dir.png)

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



