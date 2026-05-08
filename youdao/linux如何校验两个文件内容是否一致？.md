一般来说各发行版的 Linux 系统都会安装了 diff 扩展命令（可以通过 `diff -v` 验证是否已经安装）

没有安装的话，可以通过以下方式安装 `diff` 扩展。若不是下列安装方式自行在网上搜索一下即可。

```sh
sudo apt-get install diffutils
# 或 
sudo yum install diffutils
# 或 
sudo dnf install diffutils
```

目标：比较两个文件内容是否一致（忽略各类空格符号的差异），可以使用 `diff -Bwb file1 file2` 进行比对，若 $? 返回 0 则表示两文件一样，若非 0 则表示不一致。
命令详情请阅读：[Linux diff 命令](https://www.runoob.com/linux/linux-comm-diff.html)。

背景：我想尝试通过 `git worktree` 的方式实现 PHP 项目多分支环境部署，若不同分支的 `composer.json` 文件（PHP 包管理器 composer 的配置文件）内容是相同的，那么我就直接将 master 分支目录下的 vendor 软链到指定文件夹下，从而减少 composer 重复执行的时间。

## 扩展

1. 比较两个文件是否被人篡改过？

可以使用 `md5sum file` 的方式比较两个文件的 md5 摘要值。详细请阅读：[linux比较两个文件是否一样(linux命令md5sum使用方法)](https://www.jb51.net/LINUXjishu/123859.html)

文件空格（是使用空格还是 Tab）或换行方式（是 \n 还是 \n\r）都会对 md5 结果值产生影响。用于对文件防篡改的校验有很大帮助。

2. 判断一个目录是否是软链目录？

可以通过 `test -L <dir>` 的返回码是否是零值来进行判断，若 $? 为 0，则表示是一个软链目录。

3. 如何正确的删除一个软链目录？

https://fantiq.github.io/2017/07/06/%E5%A6%82%E4%BD%95%E6%AD%A3%E7%A1%AE%E7%9A%84%E5%88%A0%E9%99%A4%E8%BD%AF%E8%BF%9E%E6%8E%A5/

