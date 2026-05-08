- [集装箱的起源与发展 - 知乎](https://zhuanlan.zhihu.com/p/165102849)
- [Docker 如此之好，但是为什么还有人用 k8s？ - 知乎](https://www.zhihu.com/question/560490738/answer/3175216294)


--- 

Docker 的不安全到底是怎么一回事？

- [Introducing runC: a lightweight universal container runtime | Docker](https://www.docker.com/blog/runc/)
- [Podman Tutorial For Beginners: Step By Step Guides](https://devopscube.com/podman-tutorial-beginners)
- [Docker 与 Podman，你应该选择哪一个？他们有什么区别？ - 知乎](https://www.zhihu.com/zvideo/1678412856897462272)
- [容器安全 - 不要以root用户在容器内运行_nklinsirui的博客-CSDN博客](https://blog.csdn.net/nklinsirui/article/details/112744446)
- [在 Docker 容器中以 root 身份启动 app 是否合理？ - 知乎](https://www.zhihu.com/question/25580965/answer/52978807)

---

- [使用 Podman 运行 WordPress 6 Arturo](https://liangdi.me/p/run-wordpress-6-arturo-with-podman/)
- [选择 podman 的理由, 以及它和 Kubernetes , Docker 的区别](https://liangdi.me/p/what-is-podman-and-different-from-kubernetes-and-docker/)
- [What is Podman? — Podman documentation](https://docs.podman.io/en/latest/index.html)
- [使用Podman 签名和分发容器镜像并推送到harbor仓库中_podman harbor_lang212的博客-CSDN博客](https://blog.csdn.net/weixin_56774628/article/details/126360891)
- [Podman vs Docker: What are the differences?](https://www.imaginarycloud.com/blog/podman-vs-docker/#privileges)
- [podman的基本设置和使用,签名分发镜像推送到harbor仓库 - linux-ada - 博客园](https://www.cnblogs.com/Clannaddada/p/16590249.html)



-----

- [从Docker到Containerd：容器运行时的下一步](https://mp.weixin.qq.com/s/2QUjQBH8hoAVqqHlNnCwWg)


-----

为什么 Docker 守护进程会成为被人诟病的点？

1. **单点故障**: Docker 守护进程崩溃会影响所有容器。
2. **权限问题**: 守护进程通常需要 root 权限，可能导致安全风险。
3. **资源消耗**: 守护进程占用系统资源。
4. **复杂性**: 守护进程增加了管理和调试的复杂性。
5. **系统集成**: Docker 守护进程和系统服务管理（如 SystemD）集成不如 Podman 优雅。
6. **跨平台问题**: 在非 Linux 系统上，Docker 守护进程可能需要特殊配置。

守护进程并非全然坏，但它在上述方面有一些缺点和挑战。    


----

那 Podman 和 containerd 有什么区别？

1. **用途**: Podman 是全功能的容器引擎，用于开发、运行、管理容器和 Pod。Containerd 主要用作 Kubernetes 下层运行时或作为 Docker 的组成部分。

2. **界面**: Podman 提供 Docker 兼容的 CLI，适合开发者。Containerd 提供 gRPC API，更侧重于集成和编程。

3. **Pod 支持**: Podman 可以创建和管理 Pod，容器可以共享网络和存储。Containerd 不直接处理 Pod。

4. **SystemD 集成**: Podman 更好地与 SystemD 集成。

5. **Rootless 运行**: Podman 和 Containerd 都支持，但 Podman 更倾向于无 root 运行。

6. **OCI 兼容**: 两者都兼容 OCI 规范。

7. **Daemonless**: Podman 不需要守护进程。Containerd 是一个守护进程。

8. **跨平台**: Podman 主要用于 Linux。Containerd 也支持多平台，但主要用于 Kubernetes。

9. **社群和商业支持**: Containerd 在 CNCF（云原生计算基金会）下，主要由 Docker 和 Kubernetes 社群支持。Podman 由 Red Hat 支持。

两者目标和用途不同，但都是容器生态系统的重要组成部分。

----------

- [将节点上的容器运行时从 Docker Engine 改为 containerd | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/migrating-from-dockershim/change-runtime-containerd/)
- [浅谈dockerd、contaierd、containerd-shim、runC之间的关系 - jame_xhs's blog](https://www.jxhs.me/2019/08/05/%E6%B5%85%E8%B0%88dockerd%E3%80%81contaierd%E3%80%81containerd-shim%E3%80%81runC%E4%B9%8B%E9%97%B4%E7%9A%84%E5%85%B3%E7%B3%BB/)
- [What is containerd ? | Docker](https://www.docker.com/blog/what-is-containerd-runtime/)

---------------

- [What is the difference between kubectl and kubelet in Kubernetes?](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/compare-Kubernetes-kubectl-vs-kubelet-when-to-use)
- [(13) OCI, CRI, ??: Making Sense of the Container Runtime Landscape in Kubernetes - Phil Estes, IBM - YouTube](https://www.youtube.com/watch?v=RyXL1zOa8Bw&ab_channel=CNCF%5BCloudNativeComputingFoundation%5D)
- [Comparison of container runtimes or managment technologies [Docker, containerd, Podman, rkt] - DEV Community](https://dev.to/theyasirr/comparison-of-container-runtimes-or-managment-technologies-docker-containerd-podman-rkt-1b8b)
- [Containerd和Docker的关系 - 哈喽哈喽111111 - 博客园](https://www.cnblogs.com/hahaha111122222/p/15814400.html)
- [Docker、Podman、Containerd 三分天下，谁才是其背后运行容器的真正王者？_运维之美的博客-CSDN博客](https://blog.csdn.net/easylife206/article/details/121133833)


-----


- CRI（Container Runtime Interface）: 是 Kubernetes 的一个插件接口标准，用于容器运行时与 Kubernetes 之间的通信。
  
- CRI-O: 是一个具体实现了 CRI 的容器运行时，专门为 Kubernetes 设计。

CRI 是标准，CRI-O 是这个标准的一个实现。


Podman 是无守护进程的。它直接与操作系统的容器功能交互，不需要中间的守护进程。这与 Docker（需要 Docker Daemon）等有守护进程的容器解决方案不同。

Podman 创建的容器不是按照 CRI 标准来的，因为 Podman 本身不是一个 CRI 实现。它是为通用容器管理设计的，而不是专为 Kubernetes 设计。

Podman 本身不使用 CRI（Container Runtime Interface）与 Kubernetes 或 CRI-O 直接通信。但 Podman 和 CRI-O 共享相同的后端数据存储，所以在底层资源上有共通性。

Podman 和 CRI-O 都基于相同的 Go 扩展库（如 containers/storage 和 containers/image）来管理容器镜像和存储。这意味着它们可以访问和操作相同的本地镜像和容器存储，使得在同一系统上两者可以交互操作相同的容器和镜像，尽管它们自身不直接通信。这种共享是通过文件系统级别和相应的 API 调用来实现的。

虽然 Podman 和 CRI-O 可能共享相同的底层库和数据存储，但它们各自维护自己的容器和 Pod 生命周期。Kubernetes 通过 CRI-O（或其他 CRI 兼容运行时）管理其容器和 Pod。

理论上，由于共享底层存储，Podman 可能能“看到”由 CRI-O 创建的容器和镜像，但直接用 Podman 操作这些可能会导致不可预见的行为或问题。因此，通常不推荐这样做。