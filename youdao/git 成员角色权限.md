`GitHub` 和 `GitLab` 走的都是一套类似 `RBAC` 的角色控制权限。
一般我们基于角色权限来做 `Code Review - CR` 的简单控制权限。

*   GitLab Docs: <https://docs.gitlab.com/>
*   GitHub Docs: <https://docs.github.com/en>

分了[四个角色](https://docs.gitlab.com/ee/user/permissions.html)：

*   Guest : 权限最小，最基本的查看功能
*   Reporter : 只能查看，不能 push
*   Developer : 能 push/merge 非 protected branch/tag
*   Maintainer(也叫：Master) : 除了项目掐你有、删除等管理权限没有，其它的权限都有
*   Owner : 最高权限，包括了项目的迁移和删除

> Master to Main ： 政治原因，说 `Master` 容易让人联想到 `master and slave` 充满种族歧视，于是 GitHub/GitLab/MySQL 把 `Master --> Main`、主从的 `master/slave` 改为 `source/replica`、`blacklist/whitelist --> blocklist/allowlist`

<https://my.oschina.net/u/4352657/blog/3490751>
