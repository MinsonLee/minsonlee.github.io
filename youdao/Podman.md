## Podman 与 Docker 的区别

### Docker 的致命缺点

- Docker 需要在系统后台运行一个守护进程，即 `dockerd - Docker Daemon`
- Docker 是以 `root` 身份在系统上运行该守护进程的。

以上两点让通过 Docker 运行应用的服务器存在一定的安全隐患，因此出现了 `Podman`。


 - | Podman  | Docker
---|---|---
架构 | 无守护进程，可以在启动容器的用户下运行容器 | 使用守护进程（dockerd-root用户启动）来创建镜像和容器
安全 | 允许容器使用 [Rootless 特权](https://zhuanlan.zhihu.com/p/64661985) | 守护进程需要有 Root 权限 
运行容器 | 需要另一个工具来管理服务并支持后台容器的运行 | 使用守护进程管理和运行容器
构建镜像 | 需要容器镜像生成器 Buildah 的辅助 | 可以构建自己的容器镜像
理念 | 采用模块haul的方式，依靠专门的工具来完成特定的任务 | 一个独立\自成体系、强大的工具（强调：`All In One`）
使用 | 兼容大部分的 Docker 命令，有专门的 docker 兼容插件 | 使用自己的命令



## 安装 Podman

## Podman 常用命令

## Podman 进阶使用

- https://mp.weixin.qq.com/s?__biz=MzI3MTI2NzkxMA==&mid=2247488720&idx=1&sn=56a3f0c46d3272f103216cf8330cf6af&scene=21#wechat_redirect
- Podman 和 Docker 的区别：https://www.51cto.com/article/699358.html
- https://developer.aliyun.com/article/1074126