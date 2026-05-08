```sh
# https://stackoverflow.com/questions/5188320/how-can-i-get-a-list-of-git-branches-ordered-by-most-recent-commit
# 查询远程分支最后一个提交信息
git for-each-ref --sort=-committerdate refs/remotes/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:short)%(color:reset))'

# 查询分支最后提交时间
git for-each-ref --sort=-committerdate refs/remotes/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) -  %(authorname) (%(color:green)%(committerdate:short)%(color:reset))'

# 删除往年分支
git for-each-ref refs/remotes/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) -  %(authorname) (%(color:green)%(committerdate:short)%(color:reset))' | grep -Ev "2023|dev|master|k8s" | sed 's/origin\/\(.*\) - .*/git push origin :\1/g' | bash

# 查看非 dev/master/非今年的分支
git for-each-ref refs/remotes/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) -  %(authorname) (%(color:green)%(committerdate:short)%(color:reset))' | grep -Ev "dev|master|(`date +%Y`)"
```


- `% (committerdate:iso)`：标准 ISO 8601 格式，例如 2023-04-05T09:23:41+08:00。
- `% (committerdate:rfc)`：RFC 2822 格式，例如 Wed, 5 Apr 2023 09:23:41 +0800。
- `% (committerdate:short)`：短日期格式，例如 2023-04-05。
- `% (committerdate:relative)`：相对时间格式，例如 2 days ago。
- `% (committerdate:unix)`：UNIX 时间戳格式，例如 1653497021。

除了 committerdate 以外，还有其他一些格式化选项可用，包括：

- `% (refname)`：引用的完整名称，例如 refs/heads/master。
- `% (refname:short)`：引用的短名称，例如 master。
- `% (objectname)`：引用所指向的 Git 对象的 SHA-1 校验和。
- `% (objecttype)`：引用所指向的 Git 对象的类型，例如 commit 或 tag。
- `% (authorname)`：作者名称。
- `% (authoremail)`：作者电子邮件地址。
- `% (authordate)`：作者提交的日期。
- `% (subject)`：提交信息标题行。
- `% (body)`：提交信息正文。

```sh
# 查询当前分支是否需要合并远程 master
git log origin/master ^HEAD --no-merges  --invert-grep --grep="子模块依赖更新" --oneline  --pretty=format:"%h %cn %ce %cd %s" -1
```

```sh
# 获取当前分支的名称
git symbolic-ref --short -q HEAD
```

```sh
# 自动 fetch 远程仓库，拉取当前远程分支
git fetch $(git remote) && git pull $(git remote) $(git symbolic-ref --short -q HEAD)
```

```
# 批量删除远程分支
git branch -r --merged | egrep -v "(->)" | sed 's/origin\//:/' | xargs -n 1 git push origin
```

```
# 批量删除远程分支
git branch -r | grep -E "feature-20(19|200[0-6])" | sed 's/origin\//:/' | xargs -n 1 git push origin
# git branch -r 查看远程分支
# grep -E "feature-20(19|200[0-6])" 查询过滤出 feature-2019 和 feature-202000-6 的分支
# sed 's/origin\/:/' 变更输入流，将标准输入中的origin/替换为:，作为标准输出
# xargs -n 1 每次读取一行标准输入，并将其作为命令行参数传递
# xargs -L 1 逐行读取
# xargs -i 指定参数位置
```

```
# 批量删除（除当前分支及master、dev外）本地分支
git branch --merged | egrep -v "(^\*|master|dev)" | sed 's/origin\//:/' | xargs -n 1 git branch -d
```

```sh
# 删除本地远程丢失的分支
git branch -v | grep -F [gone] | awk '{print $1}' | xargs -L 1 git branch -d
```
![image](37413C9881E84114A18D4D61F86D7915)

```sh
# grep 查找 git log limit number
git log --grep="reg" -number

# 反向 grep 查找
git log --invert-grep --grep="reg"
```

```sh
# 比较两个分支：在 “contact-form” 分支的哪些改动并不存在于 “master” 上
git diff master..contact-form
```
> 参考：https://www.git-tower.com/learn/git/ebook/cn/command-line/advanced-topics/diffs

```sh
# 如何判断一个文件是否被 GIT 添加追踪？
git ls-tree --name-only HEAD | grep <file or dir> # 如果没有被追中命令返回码返回非零值

# git ls-tree --name-only HEAD | grep vendor 2>&1 > /dev/null && echo "被追踪" || echo "未被追踪"
```

```sh
# 检查文件或目录是否符合 .gitignore 忽略规则
git check-ignore <path_or_file> -v|q
```


```sh
# Git list of staged files
git status -s # 查看当前工作区的变动文件
git diff --name-only --cached # 查看工作区准备 commit 的文件
```

## Tips
### 检查冲突是否处理干净
![image](987799B6769147D5997F5B15652F89ED)
```sh
# 检查工作区代码冲突是否处理干净
git diff --check

# 检查暂存区代码是否存在冲突未解决
git diff --cached --check
```
![image](AD7BFCEC1FCF41B0BB57DC619BFCF360)
> - `--check` 命令会检查代码中是否含有：`>>>>>>>` 或 `<<<<<<<` 标识
> - 开启 git 的 pre-commit 钩子 `cp ./.git/hooks/pre-commit.sample ./.git/hooks/pre-commit`【--no-verify 可以跳过该钩子的检查】

## 有用的 alias 配置
> alias配置[~/.gitconfig]
>
> 注意：alias 别名不能含有下划线 _

- pull 当前远程 track 分支到本地
```
[alias]
    pull-head = !"git pull $(git remote) $(git symbolic-ref --short -q HEAD)"
```

- fetch 指定分支到本地
```sh
# 服务器采用裸仓库进行部署的时候是无法checkout到远程分支的，需要先将远程指定分支信息fetch到本地在进行操作
fetch-branch = !"git fetch $(git remote) $1:refs/remotes/$(git remote)/$1"
```

- 获取提交树日志信息：
```vim
$ vi ~/.gitconfig
[alias]
    hist = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<author:%an%Creset == %C(bold blue)commitor:%cn>%Creset' --abbrev-commit
```
- 获取本地仓库所有分支最后一次提交时间(定时清理过期分支是一个好习惯)
```vim
$ vi ~/.gitconfig
[alias]
    lb = !"for k in `git branch|perl -pe s/^..//`;do echo `git show --pretty=format:\"%Cgreen%ci %Cblue%cr%Creset\" $k|head -n 1`\\\t$k;done|sort"
```
- 删除本地除当前外所有分支
```vim
$ vi ~/.gitconfig
[alias]
    del-branch-a = !"for branch in `git branch |grep -v '*' `;do git branch -d $branch;done"
```
- 检出远程所有分支到本地：
```vim
$ vi ~/.gitconfig
[alias]
    cho-branch-a = !"for remote in `git branch -r|grep -v '\\->'`;do git branch --track ${remote#origin/} $remote;done"
```
```git
$ git branch -r | grep -v '\->' | while read remote; do git branch --track ${remote#origin/} $remote; done
```

- 查看远程所有分支（附带最后一次提交信息/用户）
```vim
$ vi ~/.gitconfig
[alias]
    show-br = !"for branch in `git branch -r| grep -v HEAD`;do echo -e `git show --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<author:%an%Creset == %C(bold blue)commitor:%cn>%Creset' $branch | head -n 1`; done | sort -r"
```