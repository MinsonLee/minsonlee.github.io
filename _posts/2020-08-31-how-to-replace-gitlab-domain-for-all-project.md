---
layout: post
title: "Shell：批量替换Gitlab仓库remote地址"
date: 2020-08-31
tags: Shell 实例记录
---

## 安装shell格式化json工具
参考阅读：[http://openskill.cn/article/357](http://openskill.cn/article/357)

```shell
# 安装
yum -y install jq
# 使用：将标准输入信息的JSON字符串进行格式化
<stdin> | jq .
```

## 利用GitLab API 获取所有仓库的git分支
因为发现直接调用GitLab API获取拥有git仓库，得到的结果不完整，因此此处分开多个组进行获取。
[GitLab API 文档地址](https://docs.gitlab.com/ee/api/groups.html#list-a-groups-shared-projects)

### 新建一个PRIVATE-TOKEN
1. 点击当前用户头像，进入`Setting`
2. 找到：`Access Tokens`，链接地址应该为：`https://<gitlab-host>/profile/personal_access_tokens`

![how-to-create-access-tokens-in-gitlab](/images/article/gitlab-how-to-create-access-tokens.png)

!!!注意：用完`Access Tokens`记得删除，如需长期使用注意备份和保存安全！

### 获取每个分组下的git仓库地址

```shell
curl --header "PRIVATE-TOKEN: QHStkxyyNyhwAbywqaf3" 'https://<gitlab-localhost>/api/v4/groups/world-stage?simple=true&per_page=200' 
```

API接口返回结构如下：
```json
{
  "id": 68,
  "web_url": "https://<host>/groups/side-project",
  "name": "side-project",
  "path": "side-project",
  "description": "后端非主线项目",
  "visibility": "private",
  "lfs_enabled": true,
  "avatar_url": null,
  "request_access_enabled": false,
  "full_name": "side-project",
  "full_path": "side-project",
  "parent_id": null,
  "projects": [
    {
      "id": 103,
      "description": "翻译代码",
      "name": "translate",
      "name_with_namespace": "side-project / translate",
      "path": "translate",
      "path_with_namespace": "side-project/translate",
      "created_at": "2017-08-15T09:44:13.273+08:00",
      "default_branch": "master",
      "tag_list": [],
      "ssh_url_to_repo": "git@<host>:side-project/translate.git",
      "http_url_to_repo": "https://<host>/side-project/translate.git",
      "web_url": "https://<host>/side-project/translate",
      "readme_url": "https://<host>/side-project/translate/blob/master/README.md",
      "avatar_url": null,
      "star_count": 0,
      "forks_count": 0,
      "last_activity_at": "2019-04-09T11:20:49.452+08:00",
      "namespace": {
        "id": 68,
        "name": "side-project",
        "path": "side-project",
        "kind": "group",
        "full_path": "side-project",
        "parent_id": null,
        "avatar_url": null,
        "web_url": "https://<host>/groups/side-project"
      },
      "_links": {
        "self": "https://<host>/api/v4/projects/103",
        "issues": "https://<host>/api/v4/projects/103/issues",
        "merge_requests": "https://<host>/api/v4/projects/103/merge_requests",
        "repo_branches": "https://<host>/api/v4/projects/103/repository/branches",
        "labels": "https://<host>/api/v4/projects/103/labels",
        "events": "https://<host>/api/v4/projects/103/events",
        "members": "https://<host>/api/v4/projects/103/members"
      },
      "archived": false,
      "visibility": "private",
      "resolve_outdated_diff_discussions": null,
      "container_registry_enabled": true,
      "issues_enabled": true,
      "merge_requests_enabled": true,
      "wiki_enabled": true,
      "jobs_enabled": true,
      "snippets_enabled": false,
      "shared_runners_enabled": true,
      "lfs_enabled": true,
      "creator_id": 20,
      "import_status": "none",
      "open_issues_count": 0,
      "public_jobs": true,
      "ci_config_path": null,
      "shared_with_groups": [],
      "only_allow_merge_if_pipeline_succeeds": false,
      "request_access_enabled": false,
      "only_allow_merge_if_all_discussions_are_resolved": false,
      "printing_merge_request_link_enabled": true,
      "merge_method": "merge",
      "external_authorization_classification_label": null
    }
  ],
  "shared_projects": []
}
```

从上述结构可以看出，GitLab API 返回的信息其实很多在本次需求中是没有作用的，实际信息我们只需要得到 `ssh_url_to_repo`字段信息即可。
因此此处结合`jq-格式化JSON`、`grep-匹配字段`和`awk-处理分割字段`对结果进行处理，只获取`ssh_url_to_repo`即可。

完整处理如下：
```shell
curl --header "PRIVATE-TOKEN: QHStkxyyNyhwAbywqaf3" 'https://<gitlab-localhost>/api/v4/groups/world-stage?simple=true&per_page=200' | jq . | grep ssh_url_to_repo | awk -F"\"" '{print $4}' >> /tmp/test.json
```

![gitlab-api-demo-get-ssh_url_to_repo-info](/images/article/gitlab-api-demo-get-ssh_url_to_repo.png)

## 将所有远程仓库拉到本地
需要注意的是：
1. 如果不同`Groups`下`Git`仓库名相同，在`clone`过程中会出现覆盖，因此在`clone`的时候最好指定克隆岛对应的组的目录下
2. 因为对项目的提交历史并不关注，因此此处使用最小粒度的克隆：只克隆`master`分支的最后一个`commit`信息

```shell
#! /usr/bin/bash
remote=(
git@<gitlab-localhost>:side-project/erc-sdk.git
git@<gitlab-localhost>:side-project/java-project-template.git
)

for url in "${remote[@]}"
do
        git clone --branch master --depth 1 ${url} $(echo $url | awk -F":" '{ sub(/.git/, ""); print $2}')
done
```

## 遍历所有文件，批量替换
- `grep -Hr`：参数`H`-在每行行首输出匹配到的文件名称；参数`r`-递归遍历指定路径
- `grep --exclude-dir=<dir>`：排除指定目录的匹配结果
- `grep --exclude=<file>`：排除指定文件的匹配结果
- `awk -F"<string>"`：重新指定`awk`命令对字符串的分割符
- `sort`：对结果进行顺序排序
- `uniq`：对相邻结果进行去重操作处理
- `sed`结合管道对结果进行处理

```shell
grep -Hr "<old_gitlab_localhost>" --exclude-dir="\.git" --exclude-dir="vendor" --exclude="composer.lock" --exclude="README.md" | awk -F":" '{print $1}' | sort | uniq | xargs -L 1 sed -i 's/niubibi\.<old_root_domain>\.com/niubibi\.<new_root_domain>\.cn/g'
```

## 查看变更情况，自动提交信息并推到master分支
```shell
for pro in `ls /d/git-remote | grep '/'`
do 
    cd "/d/git-remote/$pro"
    if [[  `git status -s | wc -l` -ne 0 ]]
    then 
        git add . && git commit -m "refactor：替换仓库remote信息" && git push
    fi
done
```

上述两步汇总脚本如下：

```shell
#! /usr/bin/bash
project_path='/d/git-remote';
if [ $1 ];then
    project_path=$1;
fi;

function action()
{
    cd $1
    # 过滤JAVA项目目录
    if [[ `git log --invert-grep --grep="替换仓库remote信息" --oneline  --pretty=format:"%ce" -1 | grep -c heng` -eq 0 ]]
    then
        # 执行替换
        grep -Hr "<old_gitlab_localhost>" --exclude-dir="\.git" --exclude-dir="vendor" --exclude="composer.lock" --exclude="README.md" $1 | awk -F":" '{print $1}' | sort | uniq | xargs -r -L 1 sed -i 's/<old_gitlab_localhost>/<new_gitlab_localhost>/g'
    fi
    # 提交信息
    if [[  `git status -s | wc -l` -ne 0 ]]
    then
        echo $1 # 先确认仓库无误，再执行 push 操作
        # git add . && git commit -m "refactor：替换仓库remote信息" && git push
    fi
}

# 递归遍历处理目录
function listDir()
{
    local project_path=$1;
    for file in `ls $project_path`;
    do
        # 过滤前端目录
        if [[ `echo $file | grep -c '\-static'` -eq 0 ]];then
            if [ -d "$project_path/$file/.git" ];then
                action $project_path/$file
            elif [ -d "$project_path/$file" ];then
                listDir $project_path/$file;
            fi;
        fi;
    done;
}

listDir $project_path;
```

## 对旧仓库`remote`地址批量替换
```shell
#!/usr/bin/bash

# 定义项目目录
project_path='/d/htdocs';
if [ $1 ];then
    project_path=$1;
fi;

# 执行 Git 操作
function action()
{
    cd $1 && git checkout master # 切到master分支
    if [[ `git remote get-url --push origin | grep -c niubibi.easyrentcars.com` -eq 1  ]]
    then
         # 修改仓库remote地址
         git remote set-url origin `git remote get-url --push origin | sed 's/easyrentcars\.com/qeeq\.cn/'`
         # featch本地仓库当前分支代码
         git fetch $(git remote) $(git symbolic-ref --short -q HEAD):refs/remotes/$(git remote)/$(git symbolic-ref --short -q HEAD)
         # pull 当前分支代码
         git pull $(git remote) $(git symbolic-ref --short -q HEAD)
    fi

    # 更新子模块信息
    if [ -f "$1/.gitmodules" ]
    then
        git submodule sync && git submodule update --init --remote
    fi
}

# 遍历目录
function listDir()
{
    local project_path=$1;
    for file in `ls $project_path`;
    do
        if [ -d "$project_path/$file/.git" ];then
            action $project_path/$file
            if [ $file = "library" ];then
                action $project_path/$file/erc-model
            fi;
        elif [ -d "$project_path/$file" ];then
            listDir $project_path/$file;
        fi;
    done;
}

listDir $project_path;
```