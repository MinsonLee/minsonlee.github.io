[TOC]

## ls 使用

按照自然数进行排序
```sh
ls -v # -v natural sort of (version) numbers within text
```


## 正则匹配删除文件
```sh
ls | grep -P "^A.*[0-9]{2}$" | xargs -d"\n" rm
```
```sh
rm `ls |grep "_[0-9]\{4\}_project"`
```

## 对指定目录下的所有文件，进行匹配查找
```sh
find <path> -type f -name ".*.conf" | xargs grep "server_name"
```

## 强杀进程
```sh
ps -ef | grep firefox | grep -v grep | awk '{print $2}' | xargs kill -s 9
```

## 按照修改时间(`t`)倒序排序(`r`)
> https://man.linuxde.net/ls
```sh
ls -ltr
```

## 查看磁盘空间使用情况
```sh
du -h --max-depth=1 /
```

## 遍历目录并且更新分支
```sh
# 方法1：通过指定 find 查找目录深度，结合管道操作
find /data/htdocs_deploy/all_project/ -type d -maxdepth 2 -name config_center | xargs -t -L 1 bash -c 'cd "$0" && git pull-head'

# 方法2：通过 find 通配符方式，结合管道操作
find /data/htdocs_deploy/all_project/*/config_center -type d -maxdepth 0 | xargs -t -L 1 bash -c 'cd "$0" && git pull-head'

# 方法3：只通过 find 命令
# find /data/htdocs_deploy/all_project/ -maxdepth 2 -type d -name config_center -exec bash -c "cd {} && git pull-head" \;

find -type d 设置查找目录
find -maxdepth n 设置查找目录层级深度
find -name xxx 查找目录名称限制
find -exec {command} \; 对匹配结果遍历执行

xargs -t 输出执行的命令
xargs -L 1 以每1行的结果作为结果输入管道

因为 `cd xxx && git pull-head` 需要作为一个整体在`xargs`子进程管道中执行
因此需要将其作为一整体命令通过 `bash -c <commond>` 调用，bash 中通过 `$0` 获取第一个参数
```

![pull each project](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/git-fetch-each-project.gif)


## `tree`打印指定目录层级
```sh
tree -L n
```

## 查看系统用户登录日志
```sh
last -f /var/log/wtmp
```


## 批量重命名
### `for-in`方式实现批量重命名
```sh
#!/bin/bash
IFS=$'\n'
for file in $(ls *.$1)
do
        newfile=`echo $file | sed "s/$2/$3/g"`
        echo $newfile
        mv $file $newfile
done
```

### 使用管道，通过`sed`文本替换，实现批量重命名

![shell pipline rename file](121CAB8184F34D7FA82203E95E483072)

```shell
ls *.pdf | grep -F "[天下无鱼][shikey.com]" | sed "s/\[天下无鱼\]\[shikey.com\]//" | xargs -I {} mv [天下无鱼][shikey.com]{} {}
```

sed 结合反向引用，结合管道实现不规则批量重命名

```shell
ls *.mp4 | grep -E "^[0-9]+\.[0-9]+" | sed -e "s/\(.*\)\(\.[0-9 \.-]\+\)\(.*\)\((.*\..*\)/mv \"\0\" \"\1.\3.mp4\"/g" | bash
```

### 使用 `awk` 实现批量重命名

![image](69F9CCB955AE43B9906B6641D403F2C4)

```sh
ls *.pdf | grep -E "^[0-9]+" | awk -F"讲" '{ if ($2!="") {print "mv \""$0"\" \""$1" "$2"\""}}' | bash
```

- 通过 `awk` 配合 `if (condition) {}` 进行更加准确的重命名


## 批量删除 N 天前文件或文件夹
```
find /data/htdocs_deploy/all_project/ -maxdepth 1 -type d -mtime +30 -name "feature-*" -exec rm -rf {} \;
```
或
```
find /data/htdocs_deploy/all_project/ -maxdepth 1 -type d -mtime +30 -name "feature-*" | xrags rm -rf
```

- `/data/htdocs_deploy/all_project/` --设置查找的目录；
- `-maxdepth 1` 设置查询目录层级(若`-type`选项设置为`d-文件夹`，该选项必须放在type选项前)
- `-mtime +30` --设置修改时间为30天前；
- `-type d` --设置查找的类型为文件；其中f为文件，d则为文件夹
- `-name "*"` --设置文件名称，可以使用通配符；
- `-exec rm -rf {} ` --查找完毕后执行删除操作,`{}`表示变量；
- `\` --固定写法

## 通过`awk`实现批量归档文件
将所有文件下的`.avi`文件移动到当前目录下，并将文件`xxx.avi`统一命名为`文件名称.avi`的方式

![image](770DEC2BBD9749A0AA6A88194075096E)

```sh
find -type f -name *.avi | awk -F"/" '{print "mv \""$0"\" \""$NF".avi\""}'|sh
```
- 先通过 `find`命令查询匹配出所有的`.avi`文件，因为文件名有重复，因此需要额外进行文本提取再执行`mv`
- `find` 中可以通过 `-regex` 接正则表达式进行过滤
- `find` 查找多个文件后缀，只需要接多个 `-o -name` 参数即可：`find -type f -name *.avi -o -name *.flv -o -name *.mp4 | awk -F"/"  '{print "mv \""$0"\" \"./"$NF"\""}' | bash`
- 通过 `awk` 进行文本提取，但是 `awk` 本身无法调用执行 `mv`，因此此处通过`print`出完整的`mv`命令
- `awk` 中 `$NF` 表示最后一列
- 由于文件名中可能含有空格等字符，因此`mv`需要将后续的路径作为一个完整的整体看待
- 通过管道将`mv`命令传递给`sh`进行调用执行

## 递归删除空目录
![image](C3703F421AFF487CA71CAD968D738D83)
```sh
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

## 查找大文件

```
find /data/mysql/ -type f -size +50000k -exec ls -lh {} \; | awk '{ print $9 ": "$5 }';
```

- [如何在 Linux 终端高效搜索文件](https://www.freecodecamp.org/chinese/news/how-to-search-files-in-the-linux-terminal/)
- [如何在 Linux 终端高效搜索文件——高级指南](https://www.freecodecamp.org/chinese/news/how-to-search-files-effectively-in-linux/)

`find` 命令使用指南

- 通过名称搜索文件：`-name <fileName>` 可以通过通配符进行匹配搜索，如果需要对名称的大小写不敏感使用 `-iname`
- 指定查找类型：`-type <type>`


## 获取文本

```shell
head -10 slice2.go # 获取前 10 行
sed -n 21p slice2.go # 获取第 21 行(打印指定行)
tail -10 slice2.go # 获取尾部10行
tail -n +2 changes_link.md # 从第二行开始打印到末尾
```

## 比较两个文件内容是否一致

[Linux diff 命令](https://www.runoob.com/linux/linux-comm-diff.html)

```sh
diff -Bwb /mnt/d/htdocs/zuzuche/service/pc/composer.json ./composer.json
```

若上述命令结果返回码(即：`$?`) 返回 0 表示文件没有差异，若返回 1 表示文件存在差异。


## CURL 自动重试并返回结果

```sh
cat /tmp/url.txt | xargs -L 1 -I {} bash -c 'curl -Ls -o /dev/null -w "%{response_code} | %{url_effective} | " $0 && echo $0' {}
```

## 重复执行命令 N 次

```
# seq 结合 xargs 进行处理调用
seq 5 | xargs -i ~/clear_opcache.sh
```

## 如何判断一个 commit 是一个普通 commit 还是 merge commit？

`git cat-file`/`git show` 命令都可以查看一个提交的具体信息

![Distinguish merge commits when checking commit message.](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/distinguish-merge-commit-or-regular-commit.png)

```sh
# 1 - 普通提交
# 2 - merge 提交
git cat-file -p 0bee45c | grep "parent" | wc -l
```


```sh
# 1 - 普通提交
# 2 - merge 提交
git show --no-patch --format="%P" $commitId | wc -w
```