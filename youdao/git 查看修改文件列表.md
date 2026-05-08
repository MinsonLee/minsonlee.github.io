## 通过 `git diff` 的方式

```sh
# 显示最近一次提交修改的文件名
git diff --name-only HEAD~ HEAD

# 显示最近一次提交修改的文件名及状态
git diff --name-status HEAD~ HEAD
```

![show change file list with git diff](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/git-diff-show-file-list.png)

## 通过 `git log` 方式

```sh
git log --no-merges --name-status -1 # 最近一次修改的文件列表, 显示状态
git log --no-merges --name-only -1 # 最近一次修改的文件列表
git log --no-merges --stat -1 # 最近一次修改的文件列表, 及文件修改的统计
# 只显示修改文件列表，不显示 commit Log
$ git log --name-only --not origin/master  origin/branc1..origin/master --format=''

$ git branch -r | grep -vE 'master|dev' | xargs -I {} echo 'echo -e "\r\n"{} && git log --name-only --not origin/master  {}..origin/master --format=""' | bash
```

![show change file list with git log](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/git-log-show-change-file-list.png)


## 通过 `git whatchanged` 方式

```sh
git whatchanged -1 # 最近次修改的文件列表
```

注：`git whatchanged` 命令也支持 `--name-status`、`--name-only`、`--stat` 参数进行查看对应的信息。对于显示非 `meger request` 的请求和 `git log` 没有太大区别。

对于 `meger request`，`git whatchanged` 会显示更改的文件信息，而 `git log` 则不会显示。

