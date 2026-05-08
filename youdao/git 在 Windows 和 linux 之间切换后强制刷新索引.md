- https://stackoverflow.com/questions/59061816/git-forces-refresh-index-after-switching-between-windows-and-linux
- https://www.zhihu.com/question/22672994
- https://blog.csdn.net/u012501054/article/details/91543773

每次在 Windows 和 WSL 之间切换使用 `git` 时，都会造成：Refresh index xxx 的操作，严重拖慢了 git 命令操作。

导致原因：.git/index 文件是一个二进制文件。Git 命令在 Windows/Linux 系统底层之间所调用的 API 有差异，导致二进制文件的格式会有变动。而 Git 对于二进制文件的变动是不知道具体差异的，因此会整个文件产生变化。

.git/index 该文件在不同操作系统之间切换时会产生变更。因此，在切换系统后 git 会自动重新生成并覆盖原来的索引文件（ Refresh index），当项目越大这个刷新操作就越久。

