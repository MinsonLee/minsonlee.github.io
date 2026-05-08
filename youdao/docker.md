# My Docker Learning Notes


- Info for My Docker Learning Notes
- Latest Version : `2022/04/07`
- Author : limingshuang
- Docker Docs：[https://docs.docker.com/reference/](https://docs.docker.com/reference/)

****

[TOC]

## Docker 基础的目标

- 容器（lxc）是什么？容器解决了什么痛点？
- Docker 是什么？和容器是什么关系？Docker 又解决了什么痛点呢？为什么能火？
- 当下云原生时代，学习 Docker 的意义是啥？
    - 该掌握到什么程度？
    - Docker Hub 的使用
- Docker 的基本架构是怎么样的？为什么要是 `C/S` 架构（好处是什么）？`Docker` 的 `C/S ` 架构客户端-服务端是如何通信的？
- `Docker Composer` 的使用（一个聚合 Docker 操作的二进制工具程序，简便了我们多容器的部署）？Docker Composer 是如何和 dockerd 通信的（docker-compose 命令一定要在项目目录下运行）？
- 为啥要搭建私有镜像仓库？私有镜像仓库 Harbor 的搭建和使用？搭建和使用的注意事项是什么？
- 使用 `Docker` 将公司 LNMP 测试环境搭建起来
- 对 Docker 容器排查操作要熟悉（其他可以都不会，这个一定要多动手...）


## Docker 的基础架构

稍微了解和用过 Docker 的，大致都听过它的宣传口号是： **`Build, Ship, and Run Any App, Anywhere`**。

翻译过来就是：为了尽可能的减少**应用环境**的差异，Docker 通过将这些应用环境打包成一个**便携的、文件系统完整的镜像**，使用户可以快速构建起“一样”的应用环境，从而有效的解决了：**==缩短应用打包时间、应用环境部署、部署应用分发等问题==**。

可以通过快速浏览下方几篇文章粗略的了解一下：Docker 的生态及其架构是怎么样的？为何 Docker 的生态热度慢慢减热被 K8S 吞噬？

- [Docker 生态系统](https://ops.cnmysql.com/?file=002-Docker/00-Docker%E7%94%9F%E6%80%81%E7%B3%BB%E7%BB%9F)
- [Docker生态会重蹈Hadoop的覆辙吗？](https://developer.aliyun.com/article/674444)
- [Docker容器的原理、特征、基本架构与应用场景](https://mikechen.cc/7453.html#:~:text=Docker%E6%98%AFC%2FS%EF%BC%88%E5%AE%A2%E6%88%B7,%E6%88%96RESTful%20API%E8%BF%9B%E8%A1%8C%E9%80%9A%E4%BF%A1%E3%80%82)
- [Docker 核心技术与实现原理](https://draveness.me/docker/)

了解其生态系统，了解其发展的趋势，能更加好的理解 Docker 的适用场景、针对的解决痛点、为什么我上方说的只是“==**解决应用环境的差异**==”？

在 Docker 问世之前，早已经有 虚拟机/容器（Pass 平台） 技术来实现应用乃至操作系统级的“隔离”。其中虚拟机技术是通过对硬件的虚拟化，从而实现操作系统层的隔离，其安全性是极高的，**==共用Linux Kernel，让容器安全性先天不足（局限性也大，即：操作系统作业的系统无法使用容器技术实现）==**。而当时各大 Pass 云厂商（AWS、谷歌、OpenStack、VMWare的Cloud Foundry）的在容器技术上的运用其实已经挺多了，但容器技术一直没有火起来主要是因为：

1. 当时的容器技术严重依赖于 Linux 的 NameSpace、Cgroup、chroot 等核心技术（LXC），如果你要用使用容器技术其门槛比较高
2. 基于第1点，导致使用容器来部署应用时其流程及其繁琐，往往需要为不同语言、不同框架准备不同的应用打包脚本。也就是说：虽然容器技术好，但由于容器的核心技术门槛高，使的容器技术难以被“量产”。

而 Docker 采用 Dockerfile 的方式来定义应用容器的信息并且根据 Dockerfile 来进行自动构建容器从而屏蔽了容器技术的痛点（定义了容器的标准，使的容器一下子能被量产起来了）。这一操作使的用户可以更加关心应用本身，而不再是关心容器的底层技术原理实现，使的容器技术的门槛一下子就降低了。

Docker 是 C/S 架构，但所有操作都需要依赖 Docker Daemon 守护进程来进行交互，且该守护进程还必须要用 `root` 用户来启动，这又给宿主机带来了极大的安全隐患，也是其被人诟病的地方。（后起之秀：Podman 其实就是解决 dockerd 的这个隐患的）

### chroot，pivot_root 和 switch_root 区别

- [chroot，pivot_root和switch_root 区别](https://blog.csdn.net/u012385733/article/details/102565591)
- [Linux中chroot与pivot_root的区别](https://blog.csdn.net/linuxchyu/article/details/21109335)
- [chroot和pivot_root的区别](https://www.zsjweblog.com/2021/04/06/chroot%E5%92%8Cpivot_root%E7%9A%84%E5%8C%BA%E5%88%AB/)
- [容器工作原理简述](https://www.rondochen.com/how-containers-work/)


### Docker 技术架构所涵盖的一些概念

- Docker Client : 负责与用户进行交互，执行 docker 命令的封装
- Docker Daemo : Docker 服务的守护进程，也是整个 Docker 架构中最主体的一部分，包含：Docker Server 和 Engine 两部分
    - 在后台启动一个 docker server 并进行守护（`dockerd` 常驻系统进程）
    - 负责接收 Docker Client 的请求，并将请求转给 Docker Server
- Docker Server


### Docker 容器生命周期图了解 Docker 的一些概念

下面的图是网上找到的（暂不知实际出处）一张：Docker 容器生命周期图。

![Docker 镜像的生命周期](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/the-life-cycle-of-a-docker-images.png)

下图是一张 Docker 架构图

![Docker 组成架构](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20220327165109.png)

从上图，我们可以看到其核心的几个概念：

- Registry（仓库） : 存放镜像的地方，就像“代码”和“GitHub”的关系，你可以登录、查询检索、推送存储镜像。（DockerHub 类似 GitHub，而你自己搭建的私有仓库就类似你通过 GitLab 搭建你自己的 Git 代码仓库服务一样）。
- Images（镜像） : 正如面向对象编程中的 `类-对象` 中的“类”，镜像是应用环境的**静态定义**。
- Containers（容器） : 正如面向对象编程中的 `类-对象` 中的“对象”，容器是应用环境的**动态呈现**。既然是动态的，那么就意味着**容器是有状态改变可言的，如：创建、启动、运行时、暂停、停止、删除**。
- Dockerfile : 通过文件方式描述 Docker 镜像的构成


## 安装 Docker

Docker CE 是社区免费版本，Docker EE 是收费版本。 Docker CE 就已经包含了 : Docker Client、Docker Daemo、Docker En

- Docker CE 安装 : `curl -fsSL get.docker.com -o /tmp/get-docker.sh && sudo /bin/sh /tmp/get-docker.sh --mirror Aliyun && rm -f /tmp/get-docker.sh`


## 配置 Docker

1. [配置 Docker 镜像加速](https://blog.weihua.life/configuration-docker-mirror-acceleration/)
    - [阿里云的个人 Docker 镜像加速器](https://help.aliyun.com/zh/acr/user-guide/accelerate-the-pulls-of-docker-official-images)
    - 网易加速器：http://hub-mirror.c.163.com
    - 官方中国加速器：https://registry.docker-cn.com
    - ustc 的镜像：https://docker.mirrors.ustc.edu.cn
    - daocloud：https://www.daocloud.io/mirror#accelerator-doc（注册后使用）
2. 配置监听远程服务远程（默认 `2375` 端口）

- **==`2022-03-26` 2375 端口不要开启，有被注入挖矿的风险！==**
- 官方文档参考：[Configuring remote access Docker](https://docs.docker.com/engine/install/linux-postinstall/#configure-where-the-docker-daemon-listens-for-connections)
- [腾讯云容器服务产品文档](https://mc.qcloudimg.com/static/qc_doc/f3f5f63fadbc27ac56112cc8a320b52c/doc-Cloud+Container+Service-Image+Registries.pdf)

```sh
$ vi /etc/docker/daemon.json

# 如果你是通过 nohup dockerd & 方式启动服务，那么直接通过 daemon.json 配置 hosts 即可
# "https://mirror.ccs.tencentyun.com" 腾讯云 DockerHub 加速器（只有腾讯云内部服务器可用）
{
   "registry-mirrors": ["https://pgkejwlo.mirror.aliyuncs.com", "http://hub-mirror.c.163.com/"],
   "hosts": ["unix:///var/run/docker.sock", "tcp://xxxx:2375"]
}
```

如果通过 systemctl 来启动服务（推荐方式），那么需要通过配置 `/usr/lib/systemd/system/docker.service` （一般来说是这个位置）进行配置。


```sh
# vi /usr/lib/systemd/system/docker.service

ExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2375

# 修改完之后，需要执行下列命令重载 systemd 配置并重启 docker 服务
sudo systemctl daemon-reload
sudo systemctl restart docker.service
```

**注意：若通过 `systemcl` 控制服务，需将 `/ect/docker/daemon.json` 中 `hosts` 这一行删除，否则通过 `systemctl start docker` 的时候会报错 `unable to configure the Docker daemon with file /etc/docker/daemon.json: the following directives are specified both as a flag and in the configuration file: hosts`。**

通过 `sudo netstat -lntp | grep dockerd` 可以查看监听端口是否被成功开启。

此时，你在其它装了 Docker Client 的电脑，通过 `docker -H xxx ps` 就能查看到 `xxxx` 电脑上的 Docker 容器列表了。

3. 配置开机启动 Docker 服务

[Control Docker with systemd](https://docs.docker.com/config/daemon/systemd/) 是很多 Linux 发行版操作 Docker 服务的方式。

```sh
# systemd 方式：Ubuntu20、CentOS 现在都是用这种方式，其他系统没操作过...不妄言
systemctl enable docker # 设置开机启动


# WSL 或者低版本的 Ubuntu 是通过 service 方式启动
```

1. 如果配置了 systemd 开机自启 docker.service，修改完需要 `systemctl daemon-reload` 重新加载 systemd 的配置文件。
2. `systemctl restart docker` 重新启动 docker.service 


## Docker 调试模式

### 调试 `Dockerd` 服务

> - 官方文档：https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file
> - [如何调试 Docker](https://yeasy.gitbook.io/docker_practice/appendix/debug)

1. 通过 `vi /etc/docker/daemon.json` 将下列一段 `JSON` 追加到原有的 `JSON` 文件中：

```json
{
    "debug": true,
    "log-level": "debug"
}
```

2. 重启 `docker` 服务（`systemctl restart docker` 或 `service docker restart`）
3. 查看日志，不同的发行版 Linux 系统可能方式不一样
    - 通过 `journalctl -u docker` 命令查看
    - 查看一些系统日志，查找相关`docker`日志
        - `/var/log/syslog` 通常在 Debian-based 系统（如 Ubuntu）中使用，记录了系统的几乎所有日志活动，包括系统服务、守护进程、内核以及其他系统相关的消息
        - `/var/log/messages` 主要在 Red Hat-based 系统和一些其他类 Unix 系统中使用，用于记录通用的系统活动消息
        - `/var/log/daemon.log` 用于记录所有系统守护进程（daemon）的日志信息
    - 在某些系统上，`Docker` 可能有专用的日志文件，例如 `/var/log/docker.log`（WSL 的 Ubuntu18.x 就是记录在这个文件中）

```sh
# 实验方便，先清空 /var/log/docker.log 所有日志内容
$ cat /dev/null > /var/log/docker.log 

# 查看日志信息，然后新开一个窗口执行 `docker run --rm -it alpine:latest sh`
$ tail -f /var/log/docker.log

time="2023-08-15T22:59:17.627693680+08:00" level=debug msg="Calling HEAD /_ping"
time="2023-08-15T22:59:17.629807246+08:00" level=debug msg="Calling POST /v1.43/containers/create"
time="2023-08-15T22:59:17.630274497+08:00" level=debug msg="form data: {\"AttachStderr\":true,\"AttachStdin\":true,\"AttachStdout\":true,\"Cmd\":[\"sh\"],\"Domainname\":\"\",\"Entrypoint\":null,\"Env\":null,\"HostConfig\":{\"AutoRemove\":true,\"Binds\":null,\"BlkioDeviceReadBps\":[],\"BlkioDeviceReadIOps\":[],\"BlkioDeviceWriteBps\":[],\"BlkioDeviceWriteIOps\":[],\"BlkioWeight\":0,\"BlkioWeightDevice\":[],\"CapAdd\":null,\"CapDrop\":null,\"Cgroup\":\"\",\"CgroupParent\":\"\",\"CgroupnsMode\":\"\",\"ConsoleSize\":[50,188],\"ContainerIDFile\":\"\",\"CpuCount\":0,\"CpuPercent\":0,\"CpuPeriod\":0,\"CpuQuota\":0,\"CpuRealtimePeriod\":0,\"CpuRealtimeRuntime\":0,\"CpuShares\":0,\"CpusetCpus\":\"\",\"CpusetMems\":\"\",\"DeviceCgroupRules\":null,\"DeviceRequests\":null,\"Devices\":[],\"Dns\":[],\"DnsOptions\":[],\"DnsSearch\":[],\"ExtraHosts\":null,\"GroupAdd\":null,\"IOMaximumBandwidth\":0,\"IOMaximumIOps\":0,\"IpcMode\":\"\",\"Isolation\":\"\",\"Links\":null,\"LogConfig\":{\"Config\":{},\"Type\":\"\"},\"MaskedPaths\":null,\"Memory\":0,\"MemoryReservation\":0,\"MemorySwap\":0,\"MemorySwappiness\":-1,\"NanoCpus\":0,\"NetworkMode\":\"default\",\"OomKillDisable\":false,\"OomScoreAdj\":0,\"PidMode\":\"\",\"PidsLimit\":0,\"PortBindings\":{},\"Privileged\":false,\"PublishAllPorts\":false,\"ReadonlyPaths\":null,\"ReadonlyRootfs\":false,\"RestartPolicy\":{\"MaximumRetryCount\":0,\"Name\":\"no\"},\"SecurityOpt\":null,\"ShmSize\":0,\"UTSMode\":\"\",\"Ulimits\":null,\"UsernsMode\":\"\",\"VolumeDriver\":\"\",\"VolumesFrom\":null},\"Hostname\":\"\",\"Image\":\"alpine:latest\",\"Labels\":{},\"NetworkingConfig\":{\"EndpointsConfig\":{}},\"OnBuild\":null,\"OpenStdin\":true,\"StdinOnce\":true,\"Tty\":true,\"User\":\"\",\"Volumes\":{},\"WorkingDir\":\"\"}"
time="2023-08-15T22:59:17.632779579+08:00" level=debug msg="Calling POST /v1.43/images/create?fromImage=alpine&tag=latest"
time="2023-08-15T22:59:18.302527712+08:00" level=debug msg="hostDir: /etc/docker/certs.d/pgkejwlo.mirror.aliyuncs.com"
time="2023-08-15T22:59:18.352783085+08:00" level=debug msg="hostDir: /etc/docker/certs.d/hub-mirror.c.163.com"
time="2023-08-15T22:59:18.352941978+08:00" level=debug msg="Trying to pull alpine from https://pgkejwlo.mirror.aliyuncs.com/"
...
```

`K8s` 中可以通过 `kubectl -v=9` 的命令参数来打印每一条命令的详细 `API` 请求过程，会更加清晰一些...对于单条命令信息调试来说，感觉这一波 `K8s` 胜利。

-----

### 查看 `docker build` 构建过程

- 官方文档：https://docs.docker.com/engine/reference/commandline/build/#build-with-path
- 中文文档：https://dockerdocs.cn/engine/reference/commandline/build/#build-with-path

通过 `Dockerfile` 创建镜像是更为常见的一种做法，可以通过上面的一种方式查看对应的镜像构建日志，但是也可以通过指定 `docker build` 参数在控制台输出对应的信息：

`docker build --progress=plain --rm=false -t <image_name:tag> -f <Dockerfile> <build context>`

- `--progress=plain` 设置 Docker 构建过程输出信息的格式
    - `auto` 默认值，自动选择适当的输出格式，一般在标准终端只会提供一些简单、关键的步骤和进度
    - `plain` 详细的纯文本输出，展示完整的细节.（适用于 日志记录、非交互式的构建过程）
    - `tty` 会有一些颜色和其他可视化效果，对于阅读来说会更友好、直观一些，适用于交互式终端环境
- 【已废弃，应该是比较旧的版本才有】`--rm=false` 构建过程会产生一些中间容器
    - 默认是 `true`，即：构建完成后自动删除这些中间容器
    - 若设为 `false` 则会在构建完镜像后保留这些中间容器，然后可以通过 `docker ps -a` 进行查看这些中间容器
- `-t <image_name[:tag]>` 指定构建的镜像名称和标签
- `-f <Dockerfile>` 指定 `Dockerfile` 文件，如果没有指定则会在 `build-context` （构建上下文）目录中去寻找
- `<build context>` 一般来说我们可能会传入 `.` 即指定当前目录为构建上下文环境目录（详细的解释可以查看下方的内容：Frequently asked questions - 7）


如果你是在 `/` 目录下，那么你传 `.` 作为构建上下文环境，那你会发现可能你的构建会非常慢...

用一个小的 `Dockerfile` 测试一下：

```Dockerfile
FROM busybox
RUN ls -lha /
CMD echo Hello world
```

将上述内容写到 `/tmp/git/Dockerfile` 中，然后 `cd /tmp/git` 中执行：`docker build --progress=plain --rm=false -t build_test:0.1 .`

```plaint
❯ docker build --progress=plain --rm=false -t build_test:0.1 .
#1 [internal] load .dockerignore
#1 transferring context: 2B done
#1 DONE 0.0s

#2 [internal] load build definition from Dockerfile
#2 transferring dockerfile: 85B done
#2 DONE 0.0s

#3 [internal] load metadata for docker.io/library/busybox:latest
#3 DONE 15.5s

#4 [1/2] FROM docker.io/library/busybox@sha256:5acba83a746c7608ed544dc1533b87c737a0b0fb730301639a0179f9344b1678
#4 resolve docker.io/library/busybox@sha256:5acba83a746c7608ed544dc1533b87c737a0b0fb730301639a0179f9344b1678 0.0s done
#4 CACHED

#5 [2/2] RUN ls -lha /
#5 0.320 total 44K
#5 0.320 drwxr-xr-x    1 root     root        4.0K Aug 15 16:34 .
#5 0.320 drwxr-xr-x    1 root     root        4.0K Aug 15 16:34 ..
#5 0.320 drwxr-xr-x    2 root     root       12.0K Dec 29  2021 bin
#5 0.320 drwxr-xr-x    5 root     root         340 Aug 15 16:34 dev
#5 0.320 drwxr-xr-x    1 root     root        4.0K Aug 15 16:34 etc
#5 0.320 drwxr-xr-x    2 nobody   nobody      4.0K Dec 29  2021 home
#5 0.320 dr-xr-xr-x  221 root     root           0 Aug 15 16:34 proc
#5 0.320 drwx------    2 root     root        4.0K Dec 29  2021 root
#5 0.320 dr-xr-xr-x   11 root     root           0 Aug 15 16:34 sys
#5 0.320 drwxrwxrwt    2 root     root        4.0K Dec 29  2021 tmp
#5 0.320 drwxr-xr-x    3 root     root        4.0K Dec 29  2021 usr
#5 0.320 drwxr-xr-x    4 root     root        4.0K Dec 29  2021 var
#5 DONE 0.3s

#6 exporting to image
#6 exporting layers 0.0s done
#6 writing image sha256:c8bc1a0f5f51f2eda7f449d8676f15c7e06956ed7837cc790594ae10ab7f7d70
#6 writing image sha256:c8bc1a0f5f51f2eda7f449d8676f15c7e06956ed7837cc790594ae10ab7f7d70 done
#6 naming to docker.io/library/build_test:0.1 done
#6 DONE 0.1s
```

上述是详细的构建过程，而在 `/var/log/docker.log` 中可以看到详细的 `API` 请求过程信息。

虽然在 `Docker` 官方文档中看到了 `If you wish to keep the intermediate containers after the build is complete, you must use --rm=false. This does not affect the build cache.` 这么一句话（大致：`--rm=false` 可以保留中间容器），但是经过实验以及 `docker build --help`（版本：24.0.2） 并没有发现有这个效果和参数...

K8s 最初由 Google 出品，其产品文档的确详实，相比之下 `Docker` 的文档的实时性就非常差了。

附 `/var/log/docker.log` 日志信息：

```pliant
time="2023-08-16T00:42:55.794316627+08:00" level=debug msg="Calling HEAD /_ping"
time="2023-08-16T00:42:55.899963206+08:00" level=debug msg="Calling HEAD /_ping"
time="2023-08-16T00:42:55.900731309+08:00" level=debug msg="Calling POST /grpc"
time="2023-08-16T00:42:55.901506456+08:00" level=debug msg="Calling HEAD /_ping"
time="2023-08-16T00:42:55.902169610+08:00" level=debug msg="Calling HEAD /_ping"
time="2023-08-16T00:42:55.902588308+08:00" level=debug msg="Calling GET /v1.42/version"
time="2023-08-16T00:42:55.911097832+08:00" level=debug msg="Calling POST /grpc"
time="2023-08-16T00:42:55.927538399+08:00" level=debug msg="Calling POST /session"
time="2023-08-16T00:42:55.947892982+08:00" level=debug msg="Calling POST /session"
time="2023-08-16T00:42:55.953141743+08:00" level=debug msg="reusing ref for local: i529cl16840652yf4i6llr9i5" span="[internal] load .dockerignore"
time="2023-08-16T00:42:55.955069346+08:00" level=debug msg="diffcopy took: 1.75825ms" span="[internal] load .dockerignore"
time="2023-08-16T00:42:55.956833727+08:00" level=debug msg="reusing ref for local: dq0wzo7xy8udrfp2d660ju9zo" span="[internal] load build definition from Dockerfile"
time="2023-08-16T00:42:55.959117859+08:00" level=debug msg="diffcopy took: 2.146079ms" span="[internal] load build definition from Dockerfile"
time="2023-08-16T00:42:55.988783956+08:00" level=debug msg=resolving host=pgkejwlo.mirror.aliyuncs.com
time="2023-08-16T00:42:55.988869248+08:00" level=debug msg="do request" host=pgkejwlo.mirror.aliyuncs.com request.header.accept="application/vnd.docker.distribution.manifest.v2+json, application/vnd.docker.distribution.manifest.list.v2+json, application/vnd.oci.image.manifest.v1+json, application/vnd.oci.image.index.v1+json, */*" request.header.user-agent=buildkit/v0.11-dev request.method=HEAD url="https://pgkejwlo.mirror.aliyuncs.com/v2/library/busybox/manifests/latest?ns=docker.io"
time="2023-08-16T00:43:00.930129688+08:00" level=debug msg="2023/08/16 00:43:00 WARNING: [core] [Channel #47 SubChannel #48] grpc: addrConn.createTransport failed to connect to {" library=grpc
time="2023-08-16T00:43:00.930285565+08:00" level=debug msg="  \"Addr\": \"localhost\"," library=grpc
time="2023-08-16T00:43:00.930316364+08:00" level=debug msg="  \"ServerName\": \"localhost\"," library=grpc
time="2023-08-16T00:43:00.930332996+08:00" level=debug msg="  \"Attributes\": null," library=grpc
time="2023-08-16T00:43:00.930350720+08:00" level=debug msg="  \"BalancerAttributes\": null," library=grpc
time="2023-08-16T00:43:00.930366510+08:00" level=debug msg="  \"Type\": 0," library=grpc
time="2023-08-16T00:43:00.930464647+08:00" level=debug msg="  \"Metadata\": null" library=grpc
time="2023-08-16T00:43:00.930485957+08:00" level=debug msg="}. Err: connection error: desc = \"transport: Error while dialing only one connection allowed\"" library=grpc
time="2023-08-16T00:43:00.950812771+08:00" level=debug msg="healthcheck completed" actualDuration=1.707915ms timeout=30s
time="2023-08-16T00:43:05.950270037+08:00" level=debug msg="healthcheck completed" actualDuration=1.229072ms timeout=30s
time="2023-08-16T00:43:10.953597727+08:00" level=debug msg="healthcheck completed" actualDuration=1.093936ms timeout=30s
time="2023-08-16T00:43:11.470149765+08:00" level=debug msg="fetch response received" host=pgkejwlo.mirror.aliyuncs.com response.header.content-length=2295 response.header.content-type=application/vnd.docker.distribution.manifest.list.v2+json response.header.date="Tue, 15 Aug 2023 16:43:11 GMT" response.header.docker-content-digest="sha256:5acba83a746c7608ed544dc1533b87c737a0b0fb730301639a0179f9344b1678" response.header.docker-distribution-api-version=registry/2.0 response.header.etag="\"sha256:5acba83a746c7608ed544dc1533b87c737a0b0fb730301639a0179f9344b1678\"" response.status="200 OK" url="https://pgkejwlo.mirror.aliyuncs.com/v2/library/busybox/manifests/latest?ns=docker.io"
time="2023-08-16T00:43:11.470342642+08:00" level=debug msg=resolved desc.digest="sha256:5acba83a746c7608ed544dc1533b87c737a0b0fb730301639a0179f9344b1678" host=pgkejwlo.mirror.aliyuncs.com
time="2023-08-16T00:43:11.470911897+08:00" level=debug msg=fetch digest="sha256:5acba83a746c7608ed544dc1533b87c737a0b0fb730301639a0179f9344b1678" mediatype=application/vnd.docker.distribution.manifest.list.v2+json size=2295
time="2023-08-16T00:43:11.488298702+08:00" level=debug msg=fetch digest="sha256:839f94220ea4ab84e1b6364f7c3f311085a51904d4f5d76d022aead017fe2e1a" mediatype=application/vnd.docker.distribution.manifest.v2+json size=527
time="2023-08-16T00:43:11.488366370+08:00" level=debug msg=fetch digest="sha256:62ffc2ed7554e4c6d360bce40bbcf196573dd27c4ce080641a2c59867e732dee" mediatype=application/vnd.docker.distribution.manifest.v2+json size=527
time="2023-08-16T00:43:11.498150962+08:00" level=debug msg=fetch digest="sha256:f27022f63f9a62e1e6d09954eb0b21934ed45fcdf56f1ff8f4e9eeb2f10d5390" mediatype=application/vnd.docker.container.image.v1+json size=1454
time="2023-08-16T00:43:11.521228539+08:00" level=debug msg=fetch digest="sha256:beae173ccac6ad749f76713cf4440fe3d21d1043fe616dfbe30775815d1d0f6a" mediatype=application/vnd.docker.container.image.v1+json size=1456
time="2023-08-16T00:43:11.537720792+08:00" level=debug msg=fetch digest="sha256:5acba83a746c7608ed544dc1533b87c737a0b0fb730301639a0179f9344b1678" mediatype=application/vnd.docker.distribution.manifest.list.v2+json size=2295
time="2023-08-16T00:43:11.545297907+08:00" level=debug msg=fetch digest="sha256:839f94220ea4ab84e1b6364f7c3f311085a51904d4f5d76d022aead017fe2e1a" mediatype=application/vnd.docker.distribution.manifest.v2+json size=527
time="2023-08-16T00:43:11.545324348+08:00" level=debug msg=fetch digest="sha256:62ffc2ed7554e4c6d360bce40bbcf196573dd27c4ce080641a2c59867e732dee" mediatype=application/vnd.docker.distribution.manifest.v2+json size=527
time="2023-08-16T00:43:11.556779052+08:00" level=debug msg=fetch digest="sha256:f27022f63f9a62e1e6d09954eb0b21934ed45fcdf56f1ff8f4e9eeb2f10d5390" mediatype=application/vnd.docker.container.image.v1+json size=1454
time="2023-08-16T00:43:11.564329618+08:00" level=debug msg=fetch digest="sha256:beae173ccac6ad749f76713cf4440fe3d21d1043fe616dfbe30775815d1d0f6a" mediatype=application/vnd.docker.container.image.v1+json size=1456
time="2023-08-16T00:43:11.579886416+08:00" level=debug msg="load cache for [2/2] RUN ls -lha / with 46cd788e-b3bb-416c-acb7-ddaf3682644f::oxjfamdwmkleq9cw723rxie45"
time="2023-08-16T00:43:11.655375870+08:00" level=warning msg="no trace recorder found, skipping"
time="2023-08-16T00:43:15.951280114+08:00" level=debug msg="2023/08/16 00:43:15 WARNING: [core] [Channel #50 SubChannel #51] grpc: addrConn.createTransport failed to connect to {" library=grpc
time="2023-08-16T00:43:15.951432985+08:00" level=debug msg="  \"Addr\": \"localhost\"," library=grpc
time="2023-08-16T00:43:15.951481137+08:00" level=debug msg="  \"ServerName\": \"localhost\"," library=grpc
time="2023-08-16T00:43:15.951508790+08:00" level=debug msg="  \"Attributes\": null," library=grpc
time="2023-08-16T00:43:15.951553094+08:00" level=debug msg="  \"BalancerAttributes\": null," library=grpc
time="2023-08-16T00:43:15.951584404+08:00" level=debug msg="  \"Type\": 0," library=grpc
time="2023-08-16T00:43:15.951611115+08:00" level=debug msg="  \"Metadata\": null" library=grpc
time="2023-08-16T00:43:15.951633187+08:00" level=debug msg="}. Err: connection error: desc = \"transport: Error while dialing only one connection allowed\"" library=grpc
```

### 排查命令：`docker inspect` 和 `docker logs` 和 `docker event`

- [“ docker logs -f --tail ”查看日志：“docker logs“ requires exactly 1 argument.](https://developer.aliyun.com/article/840922)
- [日志管理之 Docker logs - 每天5分钟玩转 Docker 容器技术（87）](https://developer.aliyun.com/article/311396)
- [重启docker，访问不了面板，logs里报错：EXIT CODE: 0](https://developer.aliyun.com/ask/521591)
- [Docker 容器 9 类常见故障排查处理和使用规范建议](https://bbs.huaweicloud.com/blogs/264811)
- [Docker常见故障排查指南 - 阿里云容器服务](https://developer.aliyun.com/article/59144)
- 

## Docker 操作

![镜像、容器、应用的关系](https://minsonlee.github.io/images/pig/docker-images-container-app.png)

1. **镜像是一个特殊的文件系统，除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的配置参数（如匿名卷、环境变量、用户等）**
2. **容器是一个正在运行的进程实体**
3. **镜像是静态的描述，容器是镜像运行时的实体**，因此：镜像不包含任何动态数据，其内容在构建之后也不会被改变；容器可以被创建、启动、停止、删除、暂停等
4. 应用包含一组或多组容器，一个镜像可以启动多个容器


![Docker 操作图](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20220406091941.png)

### 系统操作

```sh
docker system info # 查看 docker 系统信息 （docker info）
docker system df # 查看 docker 镜像占用磁盘体积
docker system prune # 清理悬空的镜像层
docker system events # 获取 Docker Server 事件信息（如：容器的创建、启动、停止、删除...）
```

### 镜像操作

```sh
# 查看镜像列表
docker images
docker image ls
docker image list

# 查看镜像详细信息
docker image inspect <image name>:<tag> 

# 打包归档镜像，通过 gzip 压缩体积，便于离线传输
# 相比于 docker image save <image name>:<tag> -o /tmp/my_alpine.tar.gz 下方命令更常用
docker image save <image name>:<tag> | gzip > <image name>.<tag>.tar.gz

# 通过归档文件还原镜像
docker image load -i <image name>.<tag>.tar.gz

# 给镜像打 tag
# 注意：如果是要将镜像推送到私有仓库，目标镜像名需要按照以下格式
#   [私有镜像仓库host-默认是DockerHub/]组织/镜像名:<Tag>，如：
#       harbor-release.xxx.xxx/lms/php:7.1-alpine3.8
#       lms/php:7.1-alpine3.8 # 默认这是推送到 DockerHub 下面 lms 的账号
docker image tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]

# 删除镜像
# 镜像名删除：若该镜像还作为其他镜像的基础镜像层，实际该镜像层是不会被删除掉的
# IMAGE ID 删除：所有相同 IMAGE ID 的镜像层都会被删掉，若有其他镜像在使用需要 `-f` 强制删
docker rmi IMAGE[:TAG] # 通过镜像名删除镜像
docker rmi IMAGE_ID # 通过 IMAGE ID 删除镜像

# 通过 Dockerfile 构建新镜像
docker image build -t name:tag [-f /PATH/TO/Dockerfile] [.|/PATH/FOR/Context]
```

可以通过 `docker image inspect <image-name>[:tag] --format='{{json .RootFS}}' | jq .` 方式只查看镜像的文件层信息

命令 | 说明 | 备注
-----|------|-----
docker image save -o <tar> <image>[:tag] | 将一个镜像保存为一个归档文件 | -
docker image load -i <tar>| 将一个 `docker save` 得到的归档文件导入恢复为镜像 | 保留导出镜像的所有信息
docker container export -o <tar> <CONTAINER> | 将一个「容器」保存为一个归档文件 | 将当前容器运行时打包为一个只有1层镜像层的文件
docker image import | 将一个 `docker export` 得到的归档文件导入为一个文件系统镜像 | 将丢失原镜像的层信息



一般来说，我们都是通过 Dockerfile 来描述容器镜像，然后再用 [`docker build`](https://docs.docker.com/engine/reference/commandline/build/) 构建镜像。像 `docker save/load` 和 `docker export/import` 是比较少用的，一般的应用场景可能是在没网络的时候可能会考虑采用方式进行镜像的拷贝迁移。


#### Docker镜像列表中的 none:none 是什么？

- https://blog.csdn.net/boling_cavalry/article/details/90727359
- https://blog.51cto.com/u_14900374/2520123



### 容器操作

`Docker` 的容器信息通常存放在 `/var/lib/docker/containers/*` 目录下

- 创建容器

```
docker run -it --rm <images> <cmd>
    -i     Keep STDIN open even if not attached
    -t     Allocate a pseudo-TTY
    -d     Run container in background and print container ID（相当于 nohup <cmd> & 那么该 <cmd> 进程就不会被中断）
    -p <hostPort>:<containerPort> 端口映射
    -v <hostVolume>:<containerVolume> 挂载映射
    --rm   Automatically remove the container when it exits
    --name <name> Assign a name to the container
    --restart 容器重启策略，默认-no，还支持 yes、always，可以通过 docker inspect <container> | jq '.[0].HostConfig.RestartPolicy' 查看
```

- `docker cp </PATH/IN/Host> <container>:</path/in/container>` 将宿主机资源拷贝到容器中
- 容器状态操作： `docker start/stop/restart <CONTAINER/CONTAINER ID>`
- 在容器内部执行命令： `docker exec -it <CONTAINER/CONTAINER ID> <CMD>`
- 将当前容器保存为镜像： `docker commit -a "lms <lms.minsonlee@gmail.com>" -m "save container to image" alpine1 my_alpine:v1`
- 删除容器： `docker rm <CONTAINER/CONTAINER ID>`【running 中的容器要加 `-f` 强删】
- 批量删除所有容器 : `docker rm $(docker ps -qa)`
- 更新容器的启动配置：`docker update xxx <container>`，如将：`docker update --restart=no nginx-demo` 


- 查看容器
- https://www.rootop.org/pages/4208.html

#### 注意点

1、**容器内的第1号进程必须一直处于运行的状态，否则这个容器，就会处于退出状态！**

- Linux 系统来说 `PID=1` 的进程为 `init` 进程，是由 `PID=0` 的内核进程调用系统 `init` 函数创建的第一个用户进程。
- `PID=1` 的进程主要做用户态进程的管理，垃圾回收等动作（[Linux init、service、systemctl 三者区别](https://segmentfault.com/a/1190000038458363)）
- Docker 通过 NameSpace 技术实现了容器中进程隔离，即：不同的 PID NameSpace 中，相互的进程 PID 是完全隔离独立的（[容器中的一号进程](https://cloud.tencent.com/developer/article/1940904)）
- Docker 容器中的 `PID=1` 进程多为 **服务进程** 或 **服务 daemon 进程**。所有的其他进程都是该 `PID=1` 进程的衍生子进程，而容器实际也只是宿主机系统上的一个特殊进程（`docker top <containerID>` 查看），一旦该进程的运行状态结束，那么容器的生命周期也就结束了


- [Linux0号进程，1号进程，2号进程](https://blog.csdn.net/longwang155069/article/details/104363832)
- [Linux下1号进程的前世(kernel_init)今生(init进程)----Linux进程的管理与调度（六）](https://blog.csdn.net/gatieme/article/details/51532804)
- [Systemd 入门教程：命令篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
- [docker进程管理(1号进程，僵尸进程详解)](https://blog.csdn.net/zhangjikuan/article/details/114702299)
- [Docker 理解进程（1）：为什么我在容器中不能kill 1号进程？](https://blog.csdn.net/qq_34556414/article/details/118957789?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1.pc_relevant_default&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1.pc_relevant_default&utm_relevant_index=1)
- [容器中的一号进程](https://cloud.tencent.com/developer/article/1940904)
- [灵魂一问：为什么你的 Docker 容器刚启动就停了](https://www.51cto.com/article/609700.html)

2、**容器应当是短暂的：「短暂」意味着可以停止和销毁容器，并且创建一个新容器并部署好所需的设置和配置工作量应该是极小的。**

- [12 Factor(12要素)应用程序方法](https://12factor.net/zh_cn/)

### 仓库操作

- 登录 DockerHub : `docker login`
- 登录私有镜像仓库 : `docker login <host>`
- 检索 DockerHub 镜像 : `docker search <image>` # 该命令只提供给 DockerHub，私人仓库需要自己实现 API
- 拉取镜像 : `docker pull <image>:<tag>` 或 `docker pull [<host>/][org/]<image>:<tag>`
- 推送镜像 : `docker push <repository>:<tag>`
- 查看镜像 sha256 值 : `docker image inspect <image>:<tag> | grep Id`

初次使用 `dockerlogin` 登录镜像仓库时，需要提供用户名和密码。认证的信息会被保存在 `~/.docker/config.json` 文件，在后续与私有镜像仓库交互时就可以被重用，而不需要每次都进行登录认证。


**如何推送镜像到私有仓库？**

1. 先通过 `docker login [host[:port]]` 登录私有仓库
2. 需要先用 `docker tag SOURCE_IMAGE[:TAG] [host[:port]/]<username>/<image>[:tag]` 给镜像进行打 tag
3. 通过 `docker push [host[:port]/]<username>/<image>[:tag]` 进行推送

如果没有指定 host，默认是推送到 DockerHub 的 <username> 组织下。

目前没有通过 CLI 方式删除镜像操作的命令。

#### Docker 小型私有镜像仓库

[Docker 官方](https://docs.docker.com/registry/)在 DockerHub 上提供了一个 [`registry`镜像](https://hub.docker.com/_/registry) 给用户，让用户可以在本机自行搭建私有镜像仓库。

- Docker 官方提供的也是一个 `registry` 镜像，是通过 `Docker` 容器运行的。（即：不做数据持久化的情况下一旦容器消亡了，里面存储的数据就丢了）
- 推送的镜像默认存放在 `registry` 容器内部的 `/var/lib/registry` 目录中
- 可以通过 `v2/_catalog` 查看仓库中的 registry 信息，详细可以看官方的 [Docker Registry HTTP API V2](https://docs.docker.com/registry/spec/api/) 或 [简书-docker registry v2 api](https://www.jianshu.com/p/6a7b80122602)

1、本机安装 http basic 认证工具

- CentOS 安装 httpd-tools : `yum install httpd-tools  -y`
- Ubuntu 安装 htpasswd : `apt search htpasswd` 查询扩展包；`apt install -y apache2-utils` 安装 htpasswd 扩展包

```sh
# 设置认证
sudo mkdir /data/auth/ -p
sudo htpasswd -Bbn <username> <passwd>  > /data/auth//htpasswd
```

2、开启服务端 `registry` 访问 `vi /etc/docker/daemon.json`

```json
{
    "insecure-registries": ["192.168.0.13:5000"]
}
```

重启服务 `systemctl restart  docker.service`/`service docker restart`

3、创建 registry 容器

`registry` 是 Docker 官方提供的一个 registry 仓库容器，可以通过它创建一个小型的镜像仓库。

```sh
docker run -d -p 5000:5000 \
    -v /data/auth/:/auth/ \
    -v /data/registry:/var/lib/registry \
    -e "REGISTRY_AUTH=htpasswd" \
    -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd 
    --name registry
    registry
```

或者通过数据卷挂载数据

```shell
# docker volume create my_registry

# docker run -d -p 5000:5000 --name registry \
    --restart=always \
    -v /data/auth/htpasswd:/auth/htpasswd \
    -v my_registry:/var/lib/registry \
    -e "REGISTRY_AUTH=htpasswd" \
    -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
    registry
```

此时，你可以在 Client 端，通过 `docker login 192.168.0.13:5000`，然后通过 `<username>/<passwd>` 进行登录验证了。

![docker login to private registry](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20220326174714.png)

或者你也可以通过浏览器访问： `http://192.168.0.13:5000/v2/_catalog` 进行登录访问。

- 配置文件说明：https://cloud.tencent.com/developer/article/1047253


#### Docker 企业镜像仓库-Harbor

> `Harbor` 是一个由 `VMWare` 公司基于 `Docker Registry` 进行二次封装，用于管理镜像产品。

- [谈谈我对Harbor认识_harbor相比于原生的仓库](https://blog.csdn.net/u010278923/article/details/77941995)
- [Harbor 官方地址](https://goharbor.io/docs/2.4.0/)
- [docker registry migration to harbor](https://www.sobyte.net/post/2021-09/docker-registry-to-harbor/)
- [Harbor docs | Run the Installer Script](https://goharbor.io/docs/2.9.0/install-config/run-installer-script/#connect-http)

1. 拉镜像
2. 打标签：docker tag 源镜像:TAG [<REGISTRYHOST>/][USERNAME/]NAME[:TAG]
3. 登录私有镜像仓库：docker login <REGISTRYHOST>
4. 推送：docker push <image> // 如果镜像没有带 REGISTRYHOST 信息就是推送到 DockerHub

### 数据操作

#### 数据卷 Data Volumes

##### 数据卷的特性：

- **数据卷是被设计用来持久化数据的，它的生命周期独立于容器**。即：容器、镜像的删除，不影响数据卷
- 数据卷的数据被存放在宿主机的 `/var/lib/docker/volumes` 目录下
- **数据卷不存在垃圾回收这样的自动机制来处理没有任何容器引用的数据卷，必须用户手动清理**
- 数据卷在被容器使用情况，必须要先 stop 所有使用该数据卷的容器才能删除，没有强制删除方式

##### 数据卷的操作：

1. 创建新的数据卷 `docker volume create [<VOLUME NAME>]`
2. 查看数据卷列表 `docker volume ls`
3. 查看数据卷详情 `docker volume inspect <VOLUME NAME>`
4. 删除指定数据卷 `docker volume rm <VOLUME NAME>`
5. 清理悬空数据卷 `docker volume prune`
6. 删除容器时清理悬空数据卷 `docker rm -v <container>`（但我觉得应该是不推荐这种做法的，因为数据卷最好人工检查一下确定没用）

##### 数据卷的使用

- Dockerfile 中通过 `VOLUME /var/lib/mysql` 创建镜像的数据卷。
- 容器如何使用挂载卷 `docker run -v <VOLUME NAME>:<container path>`，可以通过多个 `-v/--volume` 挂载多个数据卷

实际应该是：` --mount source=<VOLUME NAME>,target=/path/in/container`


#### 挂载主机目录 Bind Mounts

本机目录挂载是在启动容器 `docker run ` 时通过 `--mount type=bind,source=<Host absolute path>,target=<Container absolute path>` 方式挂载的。

但我们使用的时候一般不这么复杂，我们可以使用和挂载数据卷一样的方式，也可以通过 `-v/--volume <Host absolute path>:<Container absolute path>` 方式进行挂载。不同的是**本机挂载 `bind` 是需要指定绝对路径，而数据挂载仅需要指定数据卷名即可**

但实际：该数据卷默认已经存放在 `/var/lib/docker/volumes` 下了，因此我觉得其实没啥区别...
不过使用数据卷，可以方便在一个固定的位置进行统一管理数据罢了。

其实我个人来说，我觉得 `Bind Mounts` 会更灵活一些。那么数据卷的特殊意义在于什么地方呢？？？？

#### Data Volumes 和 Bind Mounts 的应用场景区别？

https://www.qikqiak.com/k8s-book/docs/6.%E6%95%B0%E6%8D%AE%E5%85%B1%E4%BA%AB%E4%B8%8E%E6%8C%81%E4%B9%85%E5%8C%96.html



### Docker 网络模式

- 查看网络模式 `docker network ls`
- 创建网络模式 `docker network create`
- 自定义网络   `docker network connect -d <bridge/overlay> <network name>`
- 查看网卡详情 `docker network inspect  <network name/id>`
- 清理悬空网卡 `docker network prune`
- 删除指定网卡 `docker network rm`

Docker 有多种网络模式：bridge-网桥模式、host-共享宿主机网络、container-容器模式、overlay 模式。

#### Docker 网络模型总结

- **网络模式更多是学习和理解其原理，在 Docker 实际使用中，多容器之间的互联我们都是通过 Docker Compose 或 Kubernetes 的方式来进行配置处理**
- 默认是走 bridge 模式（即缺省值为：--net=bridge --network bridge）
    - `--link <container id/name>[:<hostname>]` 启动容器时添加 hosts 记录
- host 模式
    - **和宿主机共用一个 Network Namespace，共享宿主机的 IP/Port**
    - 通过 `--net=host` 或 `--network host` 方式指定
    - PS : `docker run -it --rm --net=host busybox sh`
- container 模式
    - **和已经存在的容器共用一个 Network Namespace，共享指定容器的 IP/Port**。
    - 通过 `--net=container:<container id/name>` 或 `--network container:<container id/name>` 指定
    - PS : `docker run -it --rm --net=container:busybox1 --name busybox2 busybox sh`
- None 模式
    - Docker 容器拥有自己的 Network Namespace，但是，并不为Docker 容器进行任何网络配置。即：容器使用者自行进入容器配置网卡、IP、路由等信息。
    - 通过 `--net=none` 或 `--network none` 指定

Docker 和 宿主机之间的端口映射，默认是通过 docker-proxy 加上 iptables 规则实现的，但 docker-proxy 也不是必须的。[docker-proxy存在合理性分析](https://www.jianshu.com/p/91002d316185)

![Docker 网络模型](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/network-model-for-docker.png)

#### bridge 模式（默认）

网桥模式下，Docker 会通过在宿主机创建一个 `docker0` 的网卡，然后所有的 Docker 容器都通过该网卡进行解析、进出网络、分配子网IP等...（相当于宿主机的 docker0 网卡就是所有容器的网关和 DHCP 服务器）。

这样容器内部就可以使用其自己独立的网卡、端口等信息。

> `docker0` 网卡的 IPV4 静态地址好像默认都是 `172.17.0.1`

```sh
# 宿主机网卡信息

lms@lms:/$ docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
c97aa4ae668c   bridge    bridge    local
711526158a74   host      host      local
2222dc7149fa   none      null      local

lms@lms:/$ ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:b1:a1:2d:d0  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
......

veth0463a95: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::d0dd:bff:febf:868c  prefixlen 64  scopeid 0x20<link>
        ether d2:dd:0b:bf:86:8c  txqueuelen 0  (Ethernet)
        RX packets 1270  bytes 81111 (81.1 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1444  bytes 3572188 (3.5 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

# 容器网卡及路由信息

lms@lms:/$ docker ps
CONTAINER ID   IMAGE     COMMAND     CREATED       STATUS          PORTS     NAMES
947ef1f8f371   alpine    "/bin/sh"   9 hours ago   Up 10 seconds             myalpine

lms@lms:/$ docker exec -it myalpine sh
/ # ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02
          inet addr:172.17.0.2  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:13 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:1102 (1.0 KiB)  TX bytes:0 (0.0 B)

......

/ # route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         172.17.0.1      0.0.0.0         UG    0      0        0 eth0
172.17.0.0      *               255.255.0.0     U     0      0        0 eth0
```

文章参考（好文）：
- [docker 查看虚拟网卡_Docker容器网络-实现篇](https://blog.csdn.net/weixin_40008566/article/details/109906688)
- [Docker 网络模式详解及容器间网络通信](https://zhuanlan.zhihu.com/p/212772001)

网桥模式也可以在容器内部 `/etc/hosts` 文件中指定 `<container ip> <container name>[ <container id>]` 方式，使得我们可以直接在容器中不仅可以通过 `ping <container ip>` 方式，还可以通过 `ping <container name/id>` 的方式进行容器之间的通讯。

在宿主机上创建一个新的网卡 `br-xxxx` ，然后让所有容器连接到这个网卡下，而不是走默认的 `docker0` 网卡。

```sh
# 创建一个测试网络模型
$ docker network create -d bridge demo # 创建一个网络模型
$ docker network inspect demo # 查看一个网络模型的具体信息

# 创建两个测试容器
docker run --name busybox3 -it --rm --network demo busybox sh
docker run --name busybox4 -it --rm --network demo busybox sh
```

此时通过在两个容器中执行 `cat /etc/hosts` 可以发现， hosts 文件中并没有指定 `ip <busybox3/busybox4>` 这样的记录，但是在容器内部通过 `ping busybox3/busybox4` 却是可以相互联通访问的。

因为它们共同的处于同一个网络模式下，我们通过 `docker network inspect demo` 可以看到 它们的配置信息了。

```json
{
    "Containers": {
            "be5ae66dc13363b3bd5edf4980ce9473b839abe5fe1782663e7db50660c3cbab": {
                "Name": "busybox3",
                "EndpointID": "0416f6d5bc9d45b686edecc24ea71f49e9b6c526357c47bb7f726a6013895935",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            },
            "fd057f949b76412a42e062006a61b87f0d68187eae7023bb7556fc1b10593069": {
                "Name": "busybox4",
                "EndpointID": "86a37ad369ebd050d273a9a9c268ac6292e9234ba59cd29a9b73bea4902be5f9",
                "MacAddress": "02:42:ac:12:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            }
        },
}
```

#### host 模式

host 模式就是启动容器的时候，不创建一个独立的网卡命名空间（Network Namespace），而是和宿主机共享同一个网卡和端口等信息。

只需要在启动容器时通过 `--net=host` 或 `--network host` 方式指定网络模式使用 host 模式即可。

我们进入容器，通过 `ifconfig`、`cat /etc/hosts`、`netstat -a` 等方式，可以看到容器内部和宿主机的信息是一样的。

此时容器和宿主机之间如果需要通信，就只能通过 回环地址 + 端口 的方式进行通讯了。


## Dockerfile

**代码即环境**，通过 Dockerfile 来描述定义开发环境所需要的依赖、资源、扩展，从而尽可能的保证环境的一致性。

- 官方文档 [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
- [《Best practices for writing Dockerfiles - Decouple applications》](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#decouple-applications)
- [编写Dockerfile的最佳实践](https://docs.docker.com.zh.xy2401.com/develop/develop-images/dockerfile_best-practices/)
- [【云原生】优雅的使用 Dockerfile 定制镜像](https://blog.csdn.net/qq_41779565/article/details/125804242)

CMD | 描述 | 备注
--- | ---- | ----
FROM <image> | 构建基础镜像 | 必须，且每个 Dockerfile 的第一行就是这个
MAINTAINER <name> | 作者信息 | 已经废弃，建议使用 `LABEL <KEY>="<VALUE>"` 进行设置




### Dockerfile 最佳实践



## Docker 三架马车

容器本身并不重要，重要且有价值的是“容器的编排”，Docker 官方为推进其容器编排事业提供了三架马车【推荐阅读：[如何理解编排？](https://cloud.tencent.com/developer/article/1484774)】：

> 编排（维基百科）：是对计算机系统和软件的自动化配置、协调和管理。

- Docker Compose ：Docker 容器关系描述，快速构建服务、工程
- Docker Machine ：Docker 环境管理，快速安装 Docker 单机/集群环境（最后提交：2019 年）
- Docker Swarm   ：Docker 容器集群管理和节点调度（最后提交：2020 年 1 月）

本地开发环境使用 Docker && Docker Compose 来构建还是很方便的 ，但生产中现在容器的集群编排都转用 Kubernetes ，而 Docker Machine、Docker Swarm 已经是废弃项目，因此可以简单了解学习即可（知道干嘛的就好了）。

### Docker Compose

#### Legacy container links 

上面介绍了 Docker 的各种网络模型，我们可以在运行容器的时候通过 `--net=<model>/--network <model>` 的参数实现不同容器在网络之间的相互通讯。但实际上容器之间可能不仅仅只是需要相互能通信，可能还需要容器相互之间的环境变量、系统上下文信息等等。

容器本身也提供一种方式给我们，来实现多个容器间网络即环境变量的访问，只需要在 `docker run` 的时候通过 `--link <container name/id>[:<container hostname>]` 的方式，将一个容器“分配注入”到另一个容器中即可。

这里只做了解学习，官方是不推荐我们手动通过 `--link` 方式来定义容器关联的，[因为这可能是一个会被废弃的选项](https://docs.docker.com/network/links/)，更加推荐我们通过 `Docker Compose` 的方式来定义这些连接。

```sh
# 创建一个测试容器 busybox1，并分配一个环境变量  MY_NAME="busybox1"
docker run -e MY_NAME="busybox1" -it --rm --name busybox1 busybox sh

# 创建一个测试容器 busybox2，并将 busybox1 分配注入到 busybox2 容器中
docker run -it --rm --link busybox1 --name busybox2 busybox sh
```

通过 `cat /etc/hosts`、`env` 就会发现异同。

![docker run --link  <name or id>](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/docker-container-with-link.png)

从图中可以看出： `--link <name or id>` 方式只能在被注入的容器中单向的访问环境变量及通讯。

#### Docker Compose 基础概念：服务、工程

[Docker Compose](https://github.com/docker/compose) 是 Docker 官方的编排工具之一。
即：「使用 `docker-compose.yml` 来定义和运行多个 Docker 容器应用程序的工具」，详细可阅读 [Overview of Docker Compose](https://docs.docker.com/compose/) 文档。【附：[YAML 入门教程](https://www.runoob.com/w3cnote/yaml-intro.html)】

> Using Compose is basically a three-step process:
> 1. Define your app’s environment with a Dockerfile so it can be reproduced anywhere.
> 2. Define the services that make up your app in docker-compose.yml so they can be run together in an isolated environment.
> 3. Run docker compose up and the Docker compose command starts and runs your entire app. You can alternatively run docker-compose up using the docker-compose binary.
>
> 使用 Compose 基本上是一个三步走的过程：
> 1. 通过 Dockerfile 定义你的 APP 环境，使得你的 APP 可以被复制到任何地方
> 2. 通过 docker-compose.yml 定义你的 「services-服务」，使得你的 APP 可以在同一个隔离环境中一起运行。
> 3. 通过 `docker compose up` 或者通过 docker-compose 可执行程序运行 `docker-compose up` 命令两种命令，`Docker compose` 就将你的整个应用启动并运行。

刚开始使用 Dockerfile 定义容器的时候就在官方文档 [《Best practices for writing Dockerfiles - Decouple applications》](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#decouple-applications) 中有提到 「每个容器只运行一个进程」这样的经验法则。

> 【诚如文档中后半句说的一样：但它不是一个硬性规定。你的应用进程到底是否应该拆成多个容器？是值得仔细思考之后做决定的，可以读一下这篇好文 [容器花絮：什么时候应该将应用程序切分为多个容器？](http://dockerone.com/article/1206)】。

实际上大部分人在使用 Dockerfile 定义容器的时候也是尽量遵循 「每个容器只运行一个进程」 这一原则的，因为这使得容器的职责能足够单一、可以足够灵活的扩展。但从上面 Docker Compose 的这段官方的描述来说（中文是我自己理解翻译过来的），可以看出来 「**一个服务并等同于一个容器，服务是多个容器的组合结果**」。

Docker Compose 有两个重要的概念：服务、工程。

- 容器（container）：一个或一组独立的进程，在同一个容器实例中对外提供独立的服务。如：Nginx 容器实例负责转发、PHP容器实例负责解析 PHP 代码、MySQL容器实例负责数据的存储。
- 服务（services）：一个完整的应用，实际上是包含若干个运行的容器实例，它们共同的组成了一个对外的「服务」，例如：LNMP 服务 = Nginx 容器 + MySQL 容器 + PHP 容器，共同组成了一个对外可用的 PHP Web 服务。
- 工程（project）：由一组相互关联的应用容器共同组成的一个完整业务单元。复杂的工程项目往往是需要各种服务相互间依赖、调用的，我们通过在 docker-compose.yml 中定义这些服务在工程中的联系。

用我们去酒楼吃饭举个例子：对用户来说最重要的其实就是饭菜、菜谱。至于配料、厨子、服务员、餐具什么，这些东西都是必须，但我们又不必关心的相互独立的东西。

- 容器：每一道菜可以看作是一个进程，一个进程可以看作是是一个容器，即：「每个容器只运行一个进程」原则。当然这个原则也不是一个硬性规定，因为**单独的一个菜其实是做好一道菜的**，它还需要一些必备的佐料，才能做得色香味俱全，因此我们也可以将**每一道菜及其所需的配料**组合起来作为一个容器。


- 服务：我们点了若干个菜就组合成了一桌酒席，这个就好比若干个独立容器组成了一个服务。而我们实际并非只享受这么一个单独的服务，还有被服务员礼貌的招呼到座位、点餐、呼叫酒水...这些都可以看作是一个个独立的服务。


- 工程：我们进入酒楼到吃完结账离开算是一整个完整工程。我们点了么多服务，其实里面还有很多东西需要考虑的，譬如：什么菜用什么碗碟来装？客人点的这么多菜里需要按照哪个顺序来做会保证菜温最好？哪个厨子更加擅长做哪道菜？做好了由哪个服务员送到餐桌上？酒楼能招待多少人？最少/最合适的服务员数量应该是多少？...等等这些细节问题，其实就是我们服务之间的相互依赖、调用关系，我们需要在酒楼开张之前就通过“企业规划书”之类的东西定下来。（这里这个“企业规划书”就是 docker-compose.yml 文件要做的）

实际生活中，我们其实需要的不是单一的“容器”、“服务”，而是要一个完整的“工程”，但是“容器”、“服务”。


#### Docker Compose 安装

[`docker/compose` 发布版本](https://github.com/docker/compose/releases)，目前最新的是 `v2.3.4`。

通过直接下载 docker-compose 的二进制可执行文件，执行 `docker-compose` 来运行执行 Docker Compose。同时 [Compose V2](https://docs.docker.com/compose/cli-command/#install-on-linux) 也支持 `docker compose` 的方式来运行 Docker Compose。

```shell
# 安装 docker-compose

sudo curl -L "https://github.com/docker/compose/releases/download/v2.3.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

# 支持 `docker compose` 方式
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
ln -s /usr/local/bin/docker-compose $DOCKER_CONFIG/cli-plugins/docker-compose

# 卸载 
sudo rm /usr/local/bin/docker-compose
sudo unlink $DOCKER_CONFIG/cli-plugins/docker-compose

# 验证是否安装成功
docker-compose version
docker compose version
```

#### docker-compose 常用命令

- 验证 docker-compose.yml 文件是否正确： `docker-compose config`
- 构建应用： `docker-compose create`
- 创建并启动应用，在后台运行 : `docker-compose [-f docker-compose.yml] up -d --build`
- 停止应用： `docker-compose down`
- 查看容器列表 : `docker-compose images/ps`
- **==查看日志 : `docker-compose logs -f <service name>`==**
- 扩容容器： `docker-compose scale <containerName>=<num> <containerName>=<num>`
- 管理应用中的某一个服务： `docker-compose start/stop <serviceName>`

#### 官网一个的 Docker Compose 小案例

1. Create a directory for the project:

```sh
mkdir -p /demo/composetest
cd composetest
```

2. Create a file called `app.py` in your project directory and paste this in:

```python
import time
import redis

from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='myredis', port=6379)

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def hello():
    count = get_hit_count()
    return 'Hello World! I have been seen {} times.\n'.format(count)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
```

3. Create another file called requirements.txt in your project directory and paste this in:

```sh
echo -e "flask\nredis" > requirements.txt
```

4. Create a Dockerfile

```Dockerfile
FROM python:3.7-alpine

WORKDIR /code

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache gcc musl-dev linux-headers

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

EXPOSE 5000

COPY . .

CMD ["flask", "run"]
```

5. Define services in a Compose file `docker-compose.yml`

```yml
version: "3.9"

services:
    web:
        build: .
        ports:
            - "8000:5000"
    redis:
        image: "redis:alpine"
```

6. Check your `docker-compose.yml`

我们可以看出， docker-compose 默认走的网络模式是 bridge 方式，网卡名叫 `composetest_default`

```sh
lms@lms:/work/composetest$ docker-compose config

name: composetest
services:
  redis:
    image: redis:alpine
    networks:
      default: null
  web:
    build:
      context: /work/composetest
      dockerfile: Dockerfile
    networks:
      default: null
    ports:
    - mode: ingress
      target: 5000
      published: "8000"
      protocol: tcp
networks:
  default:
    name: composetest_default
```

7. Build and run your app with Compose

```sh
docker-compose up --build
```

8. Stop your app

```sh
lms@lms:/work/composetest$ docker compose down

[+] Running 3/3
 ⠿ Container composetest-redis-1  Removed    0.5s
 ⠿ Container composetest-web-1    Removed    10.7s
 ⠿ Network composetest_default    Removed    0.6s
```

当我们执行 `docker compose down` 停止应用，Docker Compose 除了停止我们的服务，还会删除对应的网卡。

#### docker-compose.yml 

##### YAML 入门教程

- [YAML 入门教程](https://www.runoob.com/w3cnote/yaml-intro.html)


- 官方文档：[Compose file](https://docs.docker.com/compose/compose-file/)
- [Docker Compose](https://github.com/docker/compose) 
- [Overview of Docker Compose](https://docs.docker.com/compose/) 


### Docker Machie（了解）

[官方 GitHub Release](https://github.com/docker/machine/releases)

#### 安装最新 v0.16.2 

```sh
$ curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` > /tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo mv /tmp/docker-machine /usr/local/bin/docker-machine
```

#### 常用命令

- 查看版本： `docker-machine -v`
- 查看主机： `docker-machine ls`
- 通过 Virtualbox 驱动创建容器 `docker-machine create -d virtualbox test`（更多参数： `docker-machine create --driver virtualbox --help`）
- 查看配置连接 `docker-machine config <name>`
- 查看详细信息 `docker-machine inspect <name>`
- 获取 daemo 的IP `docker-machine ip <name>`
- 通过 docker-machine 在远程主机安装 docker 服务

```sh 
# 在远程主机安装
$ docker-machine create --driver generic \
    --generic-ip-address="124.221.195.154" \
    --generic-ssh-port "22"  \
    --generic-ssh-user "lighthouse" 
    --generic-ssh-key ~/.ssh/id_rsa \
    lighthouse

Creating CA: /home/lms/.docker/machine/certs/ca.pem
Creating client certificate: /home/lms/.docker/machine/certs/cert.pem
Running pre-create checks...
Creating machine...
(lighthouse) Importing SSH key...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with centos...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env lighthouse


Error creating machine: Error checking the host: Error checking and/or regenerating the certs: There was an error validating certificates for host "124.221.195.154:2376": dial tcp 124.221.195.154:2376: i/o timeout
You can attempt to regenerate them using 'docker-machine regenerate-certs [name]'.
Be advised that this will trigger a Docker daemon restart which might stop running containers.

# 第一步 docker-machine create 其实就已经在远程主机上安装好了 Docker 服务
# 可以通过 docker-machine ssh lighthouse 直接登录远程主机操作容器

# 创建完成查看远程主机的 Docker 服务（在本机，远程服务命名为：lighthouse）
docker-machine env lighthouse

# 执行 lighthouse 的 env 信息，改变当前 SSH 窗口的 Docker Daemo
# 实际是通过 export DOCKER_HOST = xxxx 这些临时环境变量更改 Daemo 连接
eval $(docker-machine env lighthouse)
```

Docker 是一个 C/S 架构的容器软件，`docker-machine create` 之后是通过修改临时环境变量的方式，改变当前的 DOCKER_HOST 从而变更 Server 地址。

变更地址之后，我们执行 `docker build/ps` 等命令其实都是通过 docker demond 通过 RESTAPI 方式将上下文打包请求到服务端。

### Docker Swarm（了解）

Docker Swarm 是用于 Docker 容器集群的管理编排工具，在云原生时代，面对 K8S 的冲击，Docker Swarm 完败。但理解 Docker Swarm 对容器的编排学习还是有利的。【[在微服务架构中服务的编排是什么意思？](https://www.zhihu.com/question/63556411)】

![Docker Swarm架构图](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/docker-swarm-架构图.png)

- 通过 `raft` 协议选举产生 Leader 节点（即：Manager）
    - 可以有多个 Manager
    - 一个对应多个 Worker
    - 一个 Worker 只受控一个 Manager
    - Manager 负责分发任务（一般来说是不执行 Task 的），Worker 节点为 Task 执行节点


![容器-任务-服务示意图](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/docker-servcie-示意图.png)

- 任务（Task）是 Docker Swarm 集群中最小的调度单位；服务（Service）是指一组任务的集合。
- 服务有两种模式：`replicated services`、`global services`
    - `replicated services` 按照一定规则在各个工作节点上运行指定个数的任务
        - 内部调度器会根据当前集群的资源使用情况，在不同的 node 节点上启停容器
        - 应用型服务资源，根据集群中节点资源的使用情况，弹性伸缩节点上的容器个数
        - 如果创建 service 时，不指定 `--model` 模式，默认是 `Replicated`
    - `global services` 每个工作节点上一定运行且有一个任务
        - 适合 daemon 类型的服务资源，充当该节点上的所有容器的出入口（单入口模式）
        - ==**强制在每个 node 节点上运行一个（有且仅有一个）容器任务副本**==【注意，不是说节点上只有一个容器，而是指在节点上有且仅有一个我们指定类型的任务容器】
        - `--model global` 指定 Global 服务模式，Swarm 会在当前存在及后续加入的 node 节点上自动创建一个容器任务 

## Docker GUI 管理工具 - Portainer

- [Rancher 企业级容器管理工具](https://www.rancher.cn/)
- [Portainer](https://docs.portainer.io/v/ce-2.9/start/install/server/docker/linux)

```sh
# 1. 创建数据卷存放数据
docker volume create portainer_data

# 启动服务
docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:2.9.3
```

通过访问 `9443` 端口进行访问：`http://192.168.33.10:9443/`. 访问时，可能会报错：`Client sent an HTTP request to an HTTPS server.`。通过 `https://192.168.33.10:9443/` 然后忽略警告继续访问即可。

## 企业级容器管理工具 Rancher

- [A Guide to Kubernetes with Rancher](https://more.suse.com/rs/937-DCH-261/images/guide-to-kubernetes-with-rancher.pdf)
- [rancher2.5 中文文档](https://docs.rancher.cn/docs/rancher2.5/quick-start-guide/deployment/quickstart-manual-setup/_index)

```sh
docker run -d --privileged --restart=unless-stopped \
-p 6080:80 \
-p 6443:443 \
rancher/rancher:latest
```

太TM费机器了...

## Docker GUI 监控工具 - cAdvisor

- [cAdvisor 容器监控工具](https://github.com/google/cadvisor)

**cAdvisor** 是 Google 开发的容器监控工具，可以显示当前 host 的资源使用情况，包括 CPU、内存、网络、文件系统等以及容器的资源使用情况，更为重要的是 cAdvisor 可以通过 [RESTAPI](https://github.com/google/cadvisor/blob/master/docs/api.md) 的方式将数据导出给第三方工具（如：Prometheus）使用。

```sh
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  google/cadvisor
```

## Docker 的多阶段构建（Multi-stage builds）

Docker 的口号：**Build,Ship,and Run Any App,Anywhere**（一处构建，到处运行）。

正常的构建容器过程：

- ①. 在容器中构建代码编译环境
- ②. 将代码打包到容器中进行构建
- ③. 在容器中运行构建好的程序

对于编译型语言来说，这个步骤没啥问题。但是对于编译型语言（Java、Golang、C/C++）来说，代码一旦构建成可执行二进制文件之后，步骤 ①、② 所产生的安装扩展包、代码包已经是没有任何意义的，且编译所需要的系统扩展包、应用代码还会增加镜像的体积，不仅会导致容器镜像分发浪费带宽资源，多余注入容器的资源还会给容器增加不必要的风险。

**多阶段构建的意义：将上诉步骤进行拆分，实现镜像的复用、缩减最终镜像的体积。**

- Dockerfile 中可以使用多个 `FROM <image> [AS <alias>]` 语句表示一个新的构建阶段
- Dockerfile 中通过 `COPY --from=<alias_for_image> /path/in/<imageA> /path/to/<imageB>` 实现跨阶段的拷贝
- 该拷贝是面向过程的，即：Dockerfile 是由上至下编译的

> `docker cp <containerA>:</path/in/containerA> </path/to/containerB>` 将 A 容器中的资源拷贝到 B 容器中，但 Dockerfile 是镜像层面的拷贝


## Frequently asked questions

- Compose file referance https://docs.docker.com/compose/faq/

### 1. `docker-compose.yaml` 如何定义全局变量？

- https://github.com/thundermagic/rpi_media_centre/blob/master/docker-compose.yaml
- https://stackoverflow.com/questions/56922773/make-a-global-variable-od-extra-hosts-in-docker-compose

### 2. 四个修改Docker默认存储位置的方法

https://blog.51cto.com/forangela/1949947

### 3. Docker 服务日志查看

- [journalctl 查看 systemctl 的日志：`journalctl -eu docker`](https://www.linuxcool.com/journalctl)

通过 `journalctl -xu docker` 查看 docker.service 启动过程的日志，比 `systemctl status docker` 更加的详细，便于找寻启动 Docker 服务报错。【附：[`journalctl` 日志清理](https://www.cnblogs.com/jiuchongxiao/p/9222953.html)】

- [如何调试 Docker？](https://vuepress.mirror.docker-practice.com/appendix/debug/)

### 4. Docker 容器日志查看

- [今天跟大家聊聊docker的日志！](https://www.1024sou.com/article/485152.html)

通过 Dockerfile 安装 go1.18 版本，最后是通过 `ENTRYPOINT ["/entrypoint.sh"]` 的方式执行，在 `entrypoint.sh` 中挂起一个常驻的 `/bin/sh` 进程，从而保证容器能在后台一直运行。

可以通过 `docker stats` 监控容器的运行状态，通过 `docker logs <CONTAINER ID>` 查看容器的运行日志。

### 5. ENTRYPOINT 和 CMD 的区别

- 在不带任何程序启动命令参数的前提下，`ENTRYPOINT` 容器每次启动（docker run、docker start）都会执行

通过在 `/entrypoint.sh` 中，我加入 `touch /tmp/log && date >> /tmp/log` 进行埋点，在 docker run/start 的时候都会被触发？？？？貌似 docker start 又不是这样，需要再理解验证一下。

- 如果 Dockerfile 中同时定义了 ENTRYPOINT 和 CMD，那么最终首次容器内部的 `PID = 1` 进程的命令实际是 `$ENTRYPOINT $CMD`，即： CMD 定义的内容会被作为参数传入到 ENTRYPOINT 定义的命令中。

![CMD As A param for ENTRYPOINT](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20220325172443.png)

#### 6. docker login 私人镜像仓库报错 ` http: server gave HTTP response to HTTPS client`

```
docker login 193.112.22.71:5000
Username: lms
Password:
Error response from daemon: Get "https://193.112.22.71:5000/v2/": http: server gave HTTP response to HTTPS client
```

意思其实比较明确：Server 端采用的是 http，但是客户端使用了 https 进行请求。

在**本地客户端 `/etc/docker/daemon.json` 加上私有仓库的地址和端口**，重启本地的 docker 服务即可：

```json
{
    "insecure-registries": ["193.112.22.71:5000"]
}
```

```sh
service docker restart # Ubuntu
systemctl restart docker.service # CentOS
```

### 7. `docker build -t <name> .` 最后的 `.` 是指 Dockerfile 文件的路径吗？

`docker build -t <name> .` 最后的 `.` 其实并非是指 Dockerfile 的路径，当我执行 `build` 过程的时候，看到第一句是：`Sending build context to Docker daemon ...`

Docker 是 C/S 架构，从 Docker 的组成架构也可以知道 Docker Client 是通过一组 RestAPI 跟 Docker daemon 进行交互的。因此，实际这里传给 Docker daemon 的是一个 `context-上下文`，Docker Client 实际是将整个目录的资源进行打包发送给 Docker daemon 进行构建镜像的。

Docker daemon 默认会在传输上来的上下文根目录中去找 Dockerfile 进行解析构建。
我们可以通过 `-f` 参数指定，如：`docker build -t <name> -f /path/to/Dockerfile .`，但最后的上下文还是不会省略的，如果我们不以当前整个目录作为上下文，那么就需要指定上下文的路径。如：`docker build -t <name>[:<tag>] -f /path/to/Dockerfile [.|<path/to/context>]`

我们还可以通过上下文所在的目录创建一个 `.dockerignore` 文件，用来指定在构建时需要忽略传到 Docker daemon 中的忽略文件（语法和 `.gitignore` 一样）。

其实，从这里可以看出来：Docker 在实现上很多思想借鉴了 Git 的思想，如：通过镜像分层进行增量构建，增加镜像层的复用性；`.dockerignore` 的设计...


### 8. Docker 是容器吗？docker-daemon、dockershim、containerd、runc 有什么关系？

容器是一种沙箱技术，是一种：利用一定的技术手段将应用进行命名空间隔离，且性能开销极地的技术，容器技术在 08 年的时候就已经出现了，因为 08 年 Linux 内核开始支持 cgroups，遂开始出现容器技术（利用 namespace、cgroups、chroot、unionfs 对进程进行隔离，资源控制）。

最初只有一些大云厂商内部才盛行，不仅是因为他们比其他互联网行业的人更迫切需要（可以让他们更加节省资源），还因为当时要用容器技术就需要对上述提到的那些 Linux 底层技术非常熟悉才能运用自如。

而 Docker 仅仅只是基于 Go 语言实现的一种容器引擎，最初只是对 Linux 容器技术（lxc）进行了封装了，但它创新性的提出了 Dockerfile、镜像分层的概念，为后续容器能被广泛推广起了关键的作用。

**Docker 不是容器，它只是一种实现容器的技术途径（容器引擎）**。docker-daemon 是 Docker 的守护进程，负责创建并守护 Docker 的后台服务 dockerd ，用户端所有的操作其实都是 dockerd 通过 RustAPI 的方式 与 Docker 服务进行交互完成的。

由于 Docker 的火爆，Kubernetes 所支持的第一个容器运行时就是 Docker 。当时 Docker 的代码是通过一个叫 dockershim 的组件被硬编码到 K8S 源代码中。

containerd 是从 Docker 项目中分离出来的一个项目，containerd 主要负责如下工作：

- 管理容器的生命周期(从创建容器到销毁容器)
- 拉取/推送容器镜像
- 存储管理(管理镜像及容器数据的存储)
- 调用 runC 运行容器(与 runC 等容器运行时交互)
- 管理容器网络接口及网络

[runC 简介](https://www.cnblogs.com/sparkdev/p/9032209.html)


### 9. docker compose 服务启动顺序控制

我们可以通过 `docker-compose.yml` 来定义多个服务容器，然后通过 `Docker Compose` 来批量启动服务容器。但是在实际工作环境中，服务之间往往是有依赖关系的。

通过 Docker 构建了本地开发环境，但是最近发现 nginx 服务偶发性会启动之后自行退出。通过查看 nginx 容器日志，发现错误如下：

```sh
lms@LMS:/docker/erc-docker/web$ docker logs erc_nginx
2022/05/10 10:16:40 [emerg] 1#0: host not found in upstream "php74" in /apps/nginx/conf/php-conf/php74.conf:2
nginx: [emerg] host not found in upstream "php74" in /apps/nginx/conf/php-conf/php74.conf:2
```

### 10. `ADD` 和 `COPY` 的区别是什么？

`ADD` 和 `COPY` 的作用都是用于将「“**指定源路径**”下的文件/文件夹」复制到「**新的一层镜像**的目标路径中」。

`COPY` 命令格式 如： `COPY [--chown=<user>:<group>] <build-context-path-for-source> <target>` 

- `COPY` 指令的源路径只能是：**构建上下文目录** 下的子孙路径
- 源文件的各种元数据都会保留，如：`rwx`权限、文件的 `Access/Modify/Change Time` 
- `--chown=<user>:<group>` 改变文件的所属用户及所属组（否则默认到容器中是 `root:root`）
- 目标路径可以是容器内的绝对路径，也可以是相对工作目录的相对路径（`WORKDIR` 指定工作路径）
- **目标路径不需要先创建，如果容器镜像的目录不存在会在复制文件之前自行创建缺失的目录**

`ADD` 命令格式也是：`ADD [--chown=<user>:<group>] <source> <target>` 

- **`COPY` 可以做的 `ADD` 都可以做到**
- `ADD` 指令的源路径可以是：**构建上下文目录** 下的子孙路径 或 **`URL`**
- 如果源路径是 `URL`，Docker Daemon 会尝试下载该链接的文件，并将其权限设置为 「600」放到目标路径中（若需修改权限，要额外的 `RUN chmod xxx file` 来修改处理）
- **如果源路径文件是 `tar.gz/tar.xz/tar.bz` 格式，那么 `ADD` 复制到镜像中后会自动进行解压缩**


!!!总结：**所有的文件复制均使用 `COPY` 指令，仅在需要自动解压缩的场合使用 `ADD`**

虽然在功能上 `ADD` 比 `COPY` 要更加丰富一些，但是 `Docker` 官方的 「[Dockerfile 最佳实践文档](https://yeasy.gitbook.io/docker_practice/appendix/best_practices)」 中却并不推荐使用 `ADD`。原因如下：

1. `COPY`（复制） 比 `ADD`（复制或下载并解压） 行为更加单一，语义更加明确和清晰
2. `ADD <url> <target>` 下载后的文件权限自动设置为 `600`，往往需要配合 `RUN chmod` 额外操作
3. `ADD <url>` 大多数情况都会是一个 `tar.xx` 的归档压缩包，自动解压后不会删除源压缩包，那么依然需要配合 `RUN rm` 进行清理...那么还不如直接使用 `RUN` 指令，然后使用 `wget` 或者 `curl` 工具下载，处理权限、解压缩、然后清理无用文件更合理
4. **如果我们真的是希望复制个压缩文件到容器中去，而不解压缩，这时就不可以使用 `ADD` 命令，而是需要用 `COPY` 命令了**
5. **`ADD` 指令会令镜像构建缓存失效，从而可能会令镜像构建变得比较缓慢**


## Docker 插件

- https://wbuntu.com/docker-plugin/

`docker info` 看到内置了 3 个插件： buildx、compose、scan


## 一些小经验

### 杂文

- 生产过程中，我们使用基础镜像时一般不会使用 `latest` 这个 tag，而是会指定一个特定版本的 tag 进行构建，因为 `latest` 是会改变的
- 容器与容器之间网络的互相共享可以通过 `docker run --link <containerA name or id>:<hosts name for A> <containerB>` 的方式，在 `<containerB>` 中就可以通过 `<hosts name for A>` 直接访问 `<containerA>` 了。 


- Nginx和HAProxy对比，各有什么优点与不足？ https://www.zhihu.com/question/34489042
- HAProxy用法详解 全网最详细中文文档 http://www.ttlsa.com/linux/haproxy-study-tutorial/
- https://mp.weixin.qq.com/s/_iJow1jXAPjbAV-KBdBktA
- https://www.qikqiak.com/k8s-book/
- [如何查询私有仓库的镜像？](https://www.cnblogs.com/elvi/p/8384675.html)、
- `docker search [my.registry.host]:[port]/library`
- https://stackoverflow.com/questions/23733678/how-to-search-images-from-private-1-0-registry-in-docker
- [docker run、docker exec、docker attach 的区别](https://www.cnblogs.com/doraman/p/12176888.html)
- [What is TTY and PTS in Linux?](https://www.compuhoy.com/what-is-tty-and-pts-in-linux/)
- [Linux中 tty 和 pts/0 的含义](https://www.cnblogs.com/FengZeng666/p/14211704.html)
- [Linux TTY/PTS概述](https://segmentfault.com/a/1190000009082089)
- Docker疑难杂症汇总 https://www.escapelife.site/posts/43a2bb9b.html
- [Docker Info内容详解](https://blog.csdn.net/qq_32641217/article/details/125417770)
- [dockerfile优化小技巧](https://blog.csdn.net/WuDan_1112/article/details/125857676)
- 问题排查：https://www.likakuli.com/categories/%E9%97%AE%E9%A2%98%E6%8E%92%E6%9F%A5/
- 极客教程：Docker（每一篇文章都是基于一个实际问题点来学习 docker） https://geek-docs.com/docker/docker-tutorials
- [Docker配置文件daemon.json解析](https://www.jianshu.com/p/c7c7dc24b9e3)
- [docker中config.json和key.json的作用](https://blog.csdn.net/xujiamin0022016/article/details/122740429)
- [Kunbernetes从私有仓库nexus拉取镜像](https://www.cnblogs.com/linyouyi/p/10878455.html)
- [Docker 网络模式与应用场景](https://www.jianshu.com/p/cc71aa34a67e)
- [Docker网络模式和案例分享](https://blog.51cto.com/ziyu/6690315)
- [Docker 反向导出 DockerFile](https://haoxuanli.blog.csdn.net/article/details/121826914)
- [docker、containerd、ctr、crictl 的联系_crictl和docker_catoop的博客-CSDN博客](https://blog.csdn.net/catoop/article/details/121240958)
- [如何解决Docker的权限错误？ - 极道](https://www.jdon.com/66918.html)

### redis 容器自启动

- https://blog.csdn.net/OceanWaves1993/article/details/131578052
- https://blog.csdn.net/enter89/article/details/89421859
- http://www.v3ged0ge.icu/project-2/doc-3/
- Redis 启动密码丢失问题：https://github.com/docker-library/redis/issues/176

![set env for docker-compose](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/docker-compose-env-file.png)

---

## runc 的一些补充

### runc：
- **是什么**: `runc`是一个轻量级的容器运行时，实现了OCI（Open Container Initiative）规范。
- **功能**: 创建和运行容器，但不负责管理容器生命周期。

### 关系：

1. **Docker**:
    - **旧版**: 使用自己的容器运行时。
    - **新版**: 使用`containerd`和`runc`作为底层。

2. **containerd**:
    - **上层**: 在Docker和K8s之下。
    - **下层**: 使用`runc`运行容器。

3. **K8s (Kubernetes)**:
    - **CRI (Container Runtime Interface)**: 可以与多种容器运行时（如`containerd`）集成。
    - **底层**: 可使用`runc`通过`containerd`。

4. **Podman**:
    - **独立**: 不依赖守护进程。
    - **兼容性**: 兼容Docker API。
    - **下层**: 可以使用`runc`或其它OCI兼容运行时。

`runc`是这些技术栈中的底层组件，负责具体的容器运行功能，但不管理容器生命周期。

### runc 的平替产品

除了`runc`，还有几个其他符合OCI规范的容器运行时：

1. **crun**: 用C语言编写，更注重性能和资源效率。
2. **gVisor**: 提供更强的隔离，由Google开发。
3. **Kata Containers**: 结合了轻量级容器和虚拟机的优点，提供更强隔离。
4. **Firecracker**: 由AWS开发，针对无服务器应用。
5. **Railcar**: 由Oracle开发，Rust编写。

这些运行时各有特点，但都遵循OCI规范，因此可以与`containerd`和其他容器管理平台互操作。