# Linux 问题集锦

[TOC]

## 用户管理

### 1. 用户权限管理 -xx is not in the sudoers file 问题解决


![sudo --login](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/sudo--login.png)
- https://www.cnblogs.com/davis12/p/14595668.html
- https://developer.aliyun.com/article/654810
- https://linux.cn/article-10768-1.html
- https://mp.weixin.qq.com/s/1Q5tTwNmftnl3ei8VBBK1g

### 2. 根据 uid 反查 username 信息

```sh
getent passwd <uid>
```

### 3. uid 变更会导致什么问题？

使用 NFS 服务在各个机器之间同步静态资源信息（`/data/img`），该目录的宿主用户是 `www`，由于测试环境的 Web 机被挖矿因此重装了系统，导致出现了 web机和其它机器之间的 `www` 用户其 uid 不一致（原：测试环境 `www` 的 `uid` 统一是 `500`，生产是 `504`）。

Linux 的用户最终在 `/etc/passwd` 中其实是映射为一个个 UID 的，而 Linux 目录的权限看起来是 www，但实际目录的权限是跟 UID 进行关联的，导致了 Web 机虽然是 www 用户但是却无法写入 `/data/img` 目录，而将 web 机上的 `/data/img` 目录改为 web 机上的 www 用户后又会导致其他机器在同步 `/data/img` 目录时内容无法写入。