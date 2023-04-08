---
layout: post
title: "是时候清理你的 Git 分支了”"
date: 2023-04-05
tags: [Git,Tools]
---

背景：

1. 历史原因，拆分了 20 几个仓库出来，仓库太多而人员太少，没有人维护项目分支的管理
2. `Git` 分支的成本太廉价，创建且不删除的代价很小
3. `Windows` 上的 GUI 工具太给力，轻易就能搜索对应的分支，但在 `Linux` 下 `Git GUI Tools` 没什么很好的工具 
4. 开发人员没有良好的习惯，自己创建的分支经常不删除、经常在过期的迭代分支调试代码...

长期下来，导致分支泛滥，最严重的一个历史项目居然积压了 256 个无效分支。目前后端团队就 10 来人，因此 95% 的分支估计都是没什么用的！

很多已经合并到了 `origin/master` 没有删除，很多虽然没有合并到 `origin/master` 但最后一次提交都要追溯到 2019-2022 年期间去了。

写一个脚本完成以下目标：

1. 自动拉取最新稳定项目的主干分支（master）
2. 清除本地已经丢失了的远程追踪的分支及其远程追踪记录
3. 提醒对应的开发人员及时清理已经合并到了 origin/master 的远程分支
4. 提醒对应的开发人员及时清理已经远远落后 origin/master 的远程分支

清明假期间写了一个脚本，自动清理 1100+ 个分支。

很久没发文，保号发一篇，脚本如下：

```sh
#!/bin/bash
#title       : git-branch-alert
#description : Git 已合并/过期分支清理提醒脚本
#author      : limingshuang
#date        : 2023/04/05
#version     : 1.0
#===============================================

# 定义项目目录
project_path='/mnt/d/htdocs'
if [ $1 ];then
    project_path=$1
fi
# 定义默认检查最深目录层级
level=4
if [ $2 ];then
    level=$2
fi
# 定义过期分支时间参数，默认：非当前年的分支都视为过期分支
timeReg=$(date +%Y);
if [ $3 ];then
    timeReg=$3
fi

# 定义 log 输出文件
log='/tmp/project-branch-alert-log_'$(date +%Y%m%d)'.log'
if [ ! -a $log ]; then
    touch $log
    echo -e "创建 $log\n"
fi
cat /dev/null > $log

# 定义主干远程分支, 一般都为 master，Github 现在为了避嫌改为了 main
master='master'

# 定义通用 Git命令
keepBranch='dev|master|main|HEAD|->'
# 自动拉取当前分支
fb='git pull $(git remote) $(git symbolic-ref --short -q HEAD)'
# 检查远程分支列表中，有哪些远程分支是没有合并到当前所指向的远程分支的
cm='git branch -r --merged $(git remote)/$(git symbolic-ref --short -q HEAD) | grep -vE "$keepBranch"'
# 检查过期分支命令定义
cv='git for-each-ref refs/remotes/ --format="%(refname:short) %(authorname) (%(committerdate:short))" | grep -Ev "$keepBranch|$timeReg"'

function action()
{
    echo -e "\n更新：$1"
    # reset 当前工作域自动 fetch 远程信息
    cd $1 && git reset --hard HEAD && git fetch -pa $(git remote) && git worktree prune

    # fix：处理 github 仓库将 master 改为 main，导致上游分支丢失问题
    # 自动将本地 master 切换为 main 分支
    if [[ `git symbolic-ref --short -q HEAD` = 'master' && `git branch -r | grep origin/main | wc -l` != 0 ]];then
        master='main'
    elif [[  `git symbolic-ref --short -q HEAD` != 'master' && `git branch -r | grep origin/master | wc -l` != 0 ]];then
        master='master'
    fi

    # 先更新当前分支，然后切到主分支, 更新主干分支
    eval $fb
    if [[ `git symbolic-ref --short -q HEAD` != $master ]];then
        git switch $master && eval $fb
    fi

    # 清理本地已经丢失了远程分支的分支
    git branch -v | grep -F [gone] | awk '{print $1}' | xargs -I {} bash -c "if [ ! -z {} ];then git branch -D {};fi"

    # 检查没有合并到当前分支所在远程分支
    local cmLog=$(eval $cm)
    if [ ! -z "$cmLog" ];then
        echo -e "\n已经合并到 - "$(git remote)/$(git symbolic-ref --short -q HEAD)"分支($1# " $(git remote get-url --push $(git remote))")，请及时清理：\n$cmLog" >> $log
    fi

    # 检查过期分支
    local cvLog=$(eval $cv)
    if [ ! -z "$cvLog" ];then
        echo -e "\n过期分支 - "$(git remote)/$(git symbolic-ref --short -q HEAD)"($1# " $(git remote get-url --push $(git remote))")，请相关人员检查并清理：\n$cvLog" >> $log
    fi

    # 如果存在子模块，则同步更新子模块
    if [ -f "$1/.gitmodules" ];then
        git submodule update --init --remote --recursive && git submodule foreach 'echo "清理 $sm_path" && git fetch -pa $(git remote)'
    fi
}

function listDir()
{
    local project_path=$1;
    # 如果传入目录已经是一个 Git 项目直接执行更新退出
    if [ -d "$project_path/.git" ];then
        action $project_path
        if [ $(echo $project_path | grep "/library" | wc -l) -eq 1 ] && [ -d "$project_path/erc-model" ]; then
             action $project_path/erc-model
        fi
        return
    fi
    # 如果不是 Git 目录
    for dir in `ls -l $project_path/ | grep -E "^d" | awk '{print $NF}' | grep -v "vendor"`;
    do
        local l=$2
        # 判断目录层级
        if [ $l -le $level ] && ((l+=1));then
            listDir $project_path/$dir $l
        fi
    done
}

listDir $project_path 1
```

将脚本拷贝到 `/usr/local/bin` 下，创建脚本名为：`git-branch-alert`，使用 `git-branch-alert <dir-path> <dir-level> <fileter>`
- <第1个参数：dir-path> ：指定检查目录，不想每次都输入可以修改一下脚本的 `project_path` 默认值
- <第2个参数：dir-level> ：指定检查目录层级，这个根据自己项目部署情况修改，默认值是 4 层，本来想放开限制，但是...有个项目真尼玛太人才，子目录太多了
- <第3个参数：filter> ：默认过滤 `HEAD|dev|master|main|->|(当前年份-2023)`，如果想保留其它年份和规则可以传递参数

**！！！注意：使用这个脚本之前记得先提交你项目目录的记录，因为脚本中的 `git reset --hard HEAD` 会清掉你当前工作区的信息**。