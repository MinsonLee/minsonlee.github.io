# 深入剖析 Kubernetes 学习笔记

[TOC]

- Kubernetes Demo：https://github.com/jxlwqq/kubernetes-examples
- [阿里云《云原生技术公开课》](https://edu.aliyun.com/roadmap/cloudnative?spm=a1z389.11499242.0.0.65452413sISWj4&utm_content=g_1000072542)
- [《深入剖析Kubernetes》](https://time.geekbang.org/column/intro/100015201)
- [《从 Docker 到 Kubernetes 进阶》](https://youdianzhishi.com/web/course/1007/1053)


## 1、云原生的一些基本概念：[什么是 IaaS、PaaS、SaaS？](https://www.ruanyifeng.com/blog/2017/07/iaas-paas-saas.html)

- IaaS：基础设施服务，Infrastructure-as-a-service
- PaaS：平台服务，Platform-as-a-service
- SaaS：软件服务，Software-as-a-service

企业部署一个项目有哪些方法呢？

第一种：亲力亲为

公司自己购买物理服务器、自己搭建专线网路、安装软件服务、安装各类中间件软件和项目运行环境、部署项目，所有的东西都亲力亲为。这样做意味着企业可以根据自己的实际需要自由的组合配置自己的资源，但同时意味着必须有这么一群人来维护各个环节服务的稳定。例如：除了正常的开发测试人员，你还需要有人懂得物理服务器维护、需要有人懂得操作系统、网络组建的问题、需要有人懂得各项服务软件的运维，甚至随着时间久了换机器这又是一场“大动干戈”。这些成本对于一个小型公司来说，简直就是“高射炮打蚊子”的操作。

譬如：公司有各方面的人才，但处于发展时期还未定到底要买多少物理服务器、网络的带宽要开多少合适？这些基础问题即至关重要又无关重要。至关重要的原因是后续所有的服务和收益都需要依赖这些基础设施才能跑起来，无关重要的原因是这些东西只要有且稳定就可以了对收益产生不了更大的影响，而且为了稳定购买这些基础设施往往都是需要“超配置”的进行购买，这无疑更是浪费。

第二种：IaaS（基础设施服务）

IaaS（基础设施服务）的概念：企业出钱直接向云服务商购买云服务器，能将硬件/网络等这些基础设施问题交给云服务商。根据企业自己的需求订制自己的基础设施配置，前期不仅能省掉一大笔的购买设施费用，还能不用雇那么多员工让专业的公司来帮你的企业保障这些基础设施问题。

虽然市面上的产品是成千上万的，但是技术栈却是大同小异的，甚至对于同样的开发语言开发的产品，其：运行环境、需要的各类服务软件、数据库服务软件等基本都大同小异。

第三种：PaaS（平台即服务）

PaaS（平台即服务）的概念：基于 IaaS 的基础上，向云服务商购买操作系统、各类软件服务。企业自身只需要专注产品的研发、部署、数据即可，将**应用托管**到 PaaS 平台上让云服务商来保障基础设施及各类中间件服务的稳定性即可。

第四种：SaaS（软件即服务）

SaaS（软件即服务）的概念：有了一个赚钱的点子，那么看看市面上有没有现成的产品，直接买这个产品的授权，基于使用这个产品上去赚钱。譬如：微商、淘宝客这些都是依托于现成的软件产品，直接开展自己的“商业”，而绝大部分的用户接触的互联网服务其实都是 SaaS 服务。

四种方案如下图，绿色是企业自己控制，红色是服务提供商控制。在使用上越来越便捷，但灵活性上也越来越局限。

![Iaas/PaaS/SaaS的局限](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20211011120406.png)


## 2、什么是容器？

谈容器（CaaS），就一定离不开提上一嘴 PaaS 时代。

随着云计算服务的兴起，“企业上云”逐渐普及。所谓“企业上云”是指：企业通过网络，将企业的基础系统、管理及业务部署到云端，利用网络便捷地获取云服务商提供的计算、存储、软件、数据等服务，以此提高资源配置效率、降低信息化建设成本、促进共享经济发展、加快新旧动能转换。

对于绝大部分的企业上云来说，使用 PaaS 项目的方式（**应用托管是 PaaS 项目被各大企业接受的最重要的一种能力**）来实现“企业上云”应该是最好的：既保留了产品和自身产品数据的灵活性，又无需过多理会基础设施及各类软件服务的稳定性。

而一个完整的产品往往是多个不同应用相互依赖的。此时 PaaS 项目会**调用操作系统的 Cgroups 和 Namespace 机制为每一个独立应用创建一个“沙盒”（隔离）环境，使的各应用间能在同一台宿主机中互不影响的运行于隔离环境中。这个“隔离环境”，就称之为：容器。**

从上述的描述中也可以看出：**容器对于宿主机而言，其实也是一个特殊进程而已**。而容器的概念也不是什么新鲜的概念，容器技术也一直不是什么新的技术。


## 3、Docker 解决了什么问题？

![Iaas/PaaS/SaaS的局限](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20211011120406.png)

一个 Java 项目、一个 PHP 的项目、一个 Node 前端项目、一个 HTML 页面项目它们需要的运行环境肯定是不同的。但这些应用包对于基础设施、操作系统内核（Kernl）依赖在绝大多数企业内部来说都是一样的（没啥企业会凭空弄几个不同的操作系统来部署应用吧？），只是应用对各类软件服务（Middleware）以及其运行状态（Runtime）依赖可能会有很多的区别。

**前面提到 PaaS 是当时企业上云的最佳方案，而 PaaS 最核心的组件就是：应用打包、应用包分发机制（PaaS 项目的应用包包含：应用的可执行文件 + Middleware/Runtime 的配置脚本）。**

而由于 PaaS 项目的操作系统、Middleware、Runtime 是托管给云服务商的，开发者往往需要不断的试错才能将配置脚本调试好。

因此，当时 PaaS 的产品有一个巨大的问题：==**解决了企业的问题但对其实际使用者-研发人员非常的不友好（环境差异、打包方式不统一且毫无章法可言）**==

IaaS 相当于虚拟机，存在机器资源的浪费，而 PaaS 又由于本地环境与项目环境不一致导致人力资源的浪费。

虽然当时在虚拟机技术中已经出现了“镜像”这一概念，但如果利用虚拟机的镜像方式来处理 OS 不一致的痛点，那么跟直接使用 IasS 没有什么区别，且还需要维护升级一个稳定的 OS 镜像，似乎 IaaS 和 PaaS 中间的平衡点才是最佳的方案。

**Docker 提出自己的==镜像分层结构==：将操作系统依赖的文件目录结构差异、各类中间件应用进行分层存储为只读的镜像层。**

Docker 容器是将 **整个应用 + 操作系统文件目录** 进行整体的打包然后进行解压部署，只要保证本地和生产操作系统的内核信息一致即可，那么应用打包面临的环境差异问题就被极大的缩小了；且可以通过统一的 Dockerfile 文件方式对打包操作进行定义。

这种**分层存储的方式也使的整个应用打包更加的高效（相同的镜像层会被缓存）**，结合 copy-on-write 机制又能相对的提供较好的隔离性。

不难看出，**如果你的应用是对操作系统内核有过多依赖，那么可能你的应用未必适合使用容器进行部署**，因为容器是公用一个操作系统内核的。

Docker 项目使的开发者们能更加方便的、快捷的尝试一番容器技术。开发者们也乐于使用容器进行开发，因为：“明明在我本地运行可以，怎么上了XX环境之后就跑不起来了？”这也是一直困扰运维-研发-测试的问题，而容器的普及使的运维、研发、测试都能更加专注于自己的职责。

- 运维人员：更加方便、专注于镜像的管理和分发；
- 研发人员：更加专注于业务逻辑的开发而不用再理会环境差异所带来的问题；
- 测试人员能更加好的专注于测试工作，不需要担心环境差异带来的各种阻碍测试进度的问题。

==**实质上：Docker 改变了一直以来人们的交付方式（由交付应用变为了交付应用+环境）**==

而随着 dotCloud 公司开源出来的 Docker 项目的走红，dotCloud 公司索性将自己的公司名字就改为了 Docker。

Docker 项目在短时间内迅速崛起的三个重要原因：
1. PaaS 概念已经深入人心的完美契机
2. Docker 镜像通过技术手段解决了 PaaS 的根本性问题；
3. Docker 容器同开发者之间有着与生俱来的密切关系；

![image](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20211011120418.png)


### 为什么要用 Docker ？

- 更高效的利用系统资源
- 更快速的启动时间
- 一致的运行环境
- 持续交付部署
- 更轻松的迁移
- 更轻松的维护和扩展

## 4、为什么要学 Kubernetes ?

Docker 容器项目的解决了 PaaS 应用打包的痛点，使的容器技术得以普及。

如何更加合理的管理越来越多的容器云项目？如何更加高效的部署容器云项目？即：“容器编排” 成为了开发者们的下一个关注的问题。

实际上，如：极客时间专栏《深入剖析 Kubernetes》 第 5 讲中说道的一样：容器本身没有价值，有价值的是“容器编排”。

不管 Docker 容器解决了多大的痛点，但是如果不能实现“批量、高效、快捷”的创建、部署、管理容器，那么它也就失去了商业价值。

“容器编排”就是对：容器的一系列定义、配置和创建动作的管理，“编排”是容器云项目的灵魂所在。

[Kubernetes](https://kubernetes.io/zh/docs/home/) 是由 Google 开源，由 Google、Redhat 等多家大头公司共同牵头研发支持的容器编排引擎，目前该项目托管与 CNCF。 Kubernetes 开源，依靠其“民主化”：**从 API 到容器运行时的每一层，Kubernetes 项目都为开发者暴露出了可以扩展的插件机制，鼓励用户通过代码的方式介入 Kubernetes 项目的每一个阶段** 直接终结了当时市面上“容器编排”的纷争。

Kubernetes 无疑是当下最主流的容器编排工具，因此 Kubernetes 值得大家学习一波。

Docker 的三件套：
- Docker Machine ：批量创建和管理 Docker 主机
- Docker Comporse ：容器的编排
- Docker Swarm ：Docker 的集群管理工具


## 5、容器是一个特殊的进程

在上述 [2、什么是容器]() 中提到了：**容器就是调用操作系统的 Cgroups 和 Namespace 机制为每一个独立应用创建一个“沙盒”（隔离）环境，从而使的各应用间能在同一台宿主机中互不影响的运行在容器（隔离环境）中。**

即：容器其实就是操作系统在启动进程时通过设置一些参数实现了隔离相关资源后的一个特殊进程（如下图）。

![Container Is A Special Process](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20211013214545.png)
![Container Is A Special Process](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20211013215823.png)

## 6、容器的隔离与限制

容器是在进程启动时候通过一些参数，利用操作系统本身对宿主机资源的隔离（Namespace）与限制（Cgrop）机制而创建出来的特殊进程。

提到资源的隔离和限制，早先在网上确实看过如下的图示：

![VirtualMachine VS Container](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20211013222541.png)

经过对专栏的学习，如 [5、容器是一个特殊的进程]() 文中图示，确实如专栏所说：

> 不应该把 `Docker Engine` 或者任何容器管理工具放在跟 `Hypervisor` 相同的位置，因为它们并不像 `Hypervisor` 那样对应用进程的隔离环境负责，也不会创建任何实体的“容器”，**真正对隔离环境负责的是宿主机操作系统本身**。

下图是根据 `pstree -a` 画出来的图解。

![VirtualMachine VS Container](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/727cfea83dc13ade442768cba9eb8f5.png)

> 此处的图解和专栏中老师的图解有一点点不一样：文中老师觉得“应该把 Docker 画在跟应用同级别并且靠边的位置”，但我结合 `pstree -a` 我觉得 Docker 应该是跟 `Binds/Libs + Apps` 加起来构成的整体同级才对。留个疑问？？？

### 虚拟机的工作原理

1. 通过 Hypervisor 将宿主机上的硬件资源进行虚拟化，模拟出了运行一个操作系统需要的各种硬件资源。比如： CPU、内存、I/O 设备等。
2. 在这些虚拟的硬件上安装了一个新的操作系统，即： Guest OS
3. 在 Guest OS 上运行对应进程（运行中的程序）

**优点：隔离彻底**

**缺点：**
- 占用额外资源：虚拟机本身也要占用宿主机的各项硬件资源、 Guest OS需要分配资源
- 系统调用浪费：宿主机和虚拟机内部相互的系统调用都要经过虚拟化软件的拦截和处理
- 启动速度慢：启动是系统层面级的

相比之下：**容器在宿主机上只是一个启动时加了特殊参数的普通进程，启动快且没有因虚拟化而带来的性能损耗、不依赖单独的 Guest OS**，因此容器所带来的额外资源占用可以忽略不计。**虽然容器使用 Namespace 作为隔离手段，但从隔离性来说：==容器的隔离性是不够彻底的==。**

### 资源的隔离与限制

既然容器只是运行在宿主机上的一种特殊的进程，虽然可以通过 `Mount Namespace` 挂载不同版本的操作系统文件目录，但是多个容器之间使用的就还是同一个宿主机的操作系统内核（OS Kernel）。可阅读：[操作系统 OS 与内核 Kernel 有什么区别？](https://mp.weixin.qq.com/s?__biz=Mzg4OTYzODM4Mw==&mid=2247485744&idx=1&sn=1b24a140d79238c7f68c975eb64332e6&chksm=cfe995b0f89e1ca6d58e6f6f882ce95312ab28df8946638b7f70848148f9424bc05720b91ba7&token=2096033094&lang=zh_CN#rd)

Namespace 技术实际上修改了应用进程看待整个计算机“视图”，即它的“视线”被操作系统做了限制，只能“看到”某些指定的内容。

Linux Cgroups 的全称是 Linux Control Group。它最主要的作用，就是限制一个进程组能够使用的资源上限，包括 CPU、内存、磁盘、网络带宽等等。此外，Cgroups 还能够对进程进行优先级设置、审计，以及将进程挂起和恢复等操作。

Cgrounp 通过配置文件限制进程可占用资源，通过查看 /sys/fs/cgroup目录，可以查看所支持的配置。

通过虚拟机，在虚拟机中执行以下命令

```sh
while : ; do : ; done &
```

由于我的虚拟机分了 2核4G 资源，因此我执行了两条命令

![后台死循环执行任务](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20211014225158.png)

然后再虚拟机内通过 `top` 命令监听看 `CPU` 资源占用。可以看到资源由近 0 us 飙升到了 65 us

![top show the cpu status](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20211014225536.png)

根据专栏介绍，我在虚拟机实操了一把。
1. 在 `/sys/fs/cgroup/cpu/` 目录下建了 `container` 目录（建了目录后，系统会自动在 `container` 目录中生成对应的 `cgroup` 资源限制文件）
2. 将上述的两个 PID 写入 tasks 文件中-container组：`echo 2244 > /sys/fs/cgroup/cpu/container/tasks`、`echo 2245 > /sys/fs/cgroup/cpu/container/tasks`
3. 限制指定进程组 CPU 资源最大使用 `10 us`：`echo 10000 > /sys/fs/cgroup/cpu/container/cpu.cfs_quota_us`

如上操作后，发现 top 监控的 CPU 状态一下子就掉下来了。


### 容器是一个“单进程”模型

一个正在运行的 Docker 容器，其实就是一个启用了多个 Linux Namespace 的应用进程，而这个进程能够使用的资源量，则受 Cgroups 配置的限制。

即：[**容器是一个“单进程”模型**](https://mp.weixin.qq.com/s/y5S8Tj5P_foc2V_laLHiqg) 。


为什么容器没办法同时运行两个不同的应用？

> 一个容器的本质就是一个进程，用户的应用进程实际上就是容器里 PID=1 的进程，也是其他后续创建的所有进程的父进程。

如何突破限制，让一个容器运行多个应用呢？（不推荐：因为容器本身的设计，就是希望**容器和应用能够同生命周期**）

>事先找到一个公共的 PID=1 的程序来充当两个不同应用的父进程，这也是为什么很多人都会用 systemd 或者 supervisord 这样的软件来代替应用本身作为容器的启动进程。

### 容器所被吐槽的点？

1. 在 Linux 内核中，有很多资源和对象是不能被 Namespace 化的。
2. Cgroups 对资源的限制能力也有很多不完善的地方。
    - /proc 文件系统的问题：/proc 文件系统并不知道用户通过 Cgroups 给这个容器做了什么样的资源限制，即：/proc 文件系统不了解 Cgroups 限制的存在。==> 必需用 lxcfs 进行修复

> Linux 下的 /proc 目录存储的是记录当前内核运行状态的一系列特殊文件，用户可以通过访问这些文件，查看系统以及当前正在运行的进程的信息，比如 CPU 使用情况、内存占用率等，这些文件也是 top 指令查看系统信息的主要数据来源。
> 
> 但是，在容器里执行 top 指令，就会发现，它显示的信息居然是宿主机的 CPU 和内存数据，而不是当前容器的数据。


top 是从 /prof/stat 目录下获取数据，所以道理上来讲，容器不挂载宿主机的该目录就可以了。lxcfs 就是来实现这个功能的，做法是把宿主机的 /var/lib/lxcfs/proc/memoinfo 文件挂载到Docker容器的/proc/meminfo位置后。容器中进程读取相应文件内容时，LXCFS的FUSE实现会从容器对应的Cgroup中读取正确的内存限制。从而使得应用获得正确的资源约束设定。kubernetes环境下，也能用，以ds 方式运行 lxcfs ，自动给容器注入争取的 proc 信息。

```shell
wget https://copr-be.cloud.fedoraproject.org/results/ganto/lxc3/epel-7-x86_64/01041891-lxcfs/lxcfs-3.1.2-0.2.el7.x86_64.rpm

rpm -ivh lxcfs-3.1.2-0.2.el7.x86_64.rpm --force --nodeps

# 安装lxcfs，直接后台启动，然后跑一个容器测试：

lxcfs /var/lib/lxcfs &

docker run -it -m 512m \
      -v /var/lib/lxcfs/proc/cpuinfo:/proc/cpuinfo:rw \
      -v /var/lib/lxcfs/proc/diskstats:/proc/diskstats:rw \
      -v /var/lib/lxcfs/proc/meminfo:/proc/meminfo:rw \
      -v /var/lib/lxcfs/proc/stat:/proc/stat:rw \
      -v /var/lib/lxcfs/proc/swaps:/proc/swaps:rw \
      -v /var/lib/lxcfs/proc/uptime:/proc/uptime:rw \
      ubuntu:latest /bin/bash
```



**总结：Namespace 实现资源隔离（能看到什么？）、Cgroup（control group） 实现资源控制（能用什么？用多少？）**

- Namespace：让当前进程误以为自己是当前系统视图的头号进程（PID=1）独占所有资源。（通过系统调用对应的 API 实现）
    - UTS: 主机名与域名
    - IPC: 信号量、消息队列和共享内存
    - PID: 进程编号
    - Network:网络设备、网络栈、端口等等
    - Mount: 挂载点
    - User: 用户和用户组
    - [Time：时间（内核后续新增的）](https://man7.org/linux/man-pages/man7/time_namespaces.7.html)
- Cgroup：将一组进程放在放在一个控制组里，为这一组进程分配指定的资源。（它就是一个子系统目录加上一组资源限制文件的组合）
    - 如：CPU、内存、网络带宽、磁盘存储

-----

## 搭建 k8s 集群

集群配置如下

名称 | IP | 其他信息
---|---|---
 k8s-master | 192.168.31.80/20 | 4核8G/CentOS7
 k8s-node | 192.168.31.81/20 | 2核4G/CentOS7
 
 ### 使用 kubeadm 搭建
 
 https://zhuanlan.zhihu.com/p/415297992
 
 #### 1、对 master 及节点机器进行标注化
 
 所有机器都需要执行下述的命令进行服务安装和配置
 
 ```shell
systemctl stop firewalld.service
systemctl disable firewalld.service

setenforce 0
sed -i 's/enforcing/disabled/' /etc/selinux/config

swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab

wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
yum -y install docker-ce
systemctl enable docker
systemctl start docker.service
systemctl status docker.service
docker --version

vi /etc/docker/daemon.json
{
    "registry-mirrors": ["https://pgkejwlo.mirror.aliyuncs.com", "http://hub-mirror.c.163.com/"]
}

cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
epo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

cat /etc/yum.repos.d/kubernetes.repo

yum install -y kubelet kubeadm kubectl kubernetes-cni
kubelet --version
kubeadm version -o json
kubectl version -o json

yum autoremove
```

cgroupfs 配置：

- [docker cgourpfs配置](https://www.cnblogs.com/architectforest/p/12988488.html)：`/usr/lib/systemd/system/docker.service`

![show docker Cgroup Driver](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/show-docker-cgrop-driver.png)

方法1：编辑 `vi /etc/docker/daemon.json` 文件，将 `"exec-opts": ["native.cgroupdriver=systemd"]` 加入到配置文件的 JSON 中。

方法2：编辑 `/usr/lib/systemd/system/docker.service` 文件，在 `ExecStart=xxx`启动命令中配置 `--exec-opt native.cgroupdriver=systemd` 启动参数

修改完后，重启 docker 服务

```shell
systemctl daemon-reload && systemctl restart docker
```

- kubelet cgroupfs配置：`/var/lib/kubelet/config.yaml`，但该文件需要在 `kubeadm init` 之后才会生成。。。

https://cloud.tencent.com/developer/article/1454325

![kubelet cgroup driver is different from docker cgroup driver](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20211021235344.png)


#### 2、master 节点搭建

在 master 节点机器上执行下述命令和配置，将所有的配置信息都放在 `mkdir -p /apps/k8s/xxx` 下。

```shell
mkdir -p /apps/k8s/kubeadm
```


`kubeadm config print init-defaults` 查看 apiVersion 配置 kubeadm.yaml。

```yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
controllerManager:
  ExtraArgs:
    horizontal-pod-autoscaler-use-rest-clients: "true"
    horizontal-pod-autoscaler-sync-period: "10s"
    node-monitor-grace-period: "10s"
apiServer:
  ExtraArgs:
    runtime-config: "api/all=true"
kubernetesVersion: "v1.22.2"
imageRepository: registry.aliyuncs.com/google_containers
```

```shell
[root@k8s kubeadm]# kubeadm reset
[reset] Reading configuration from the cluster...
[reset] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
W1022 01:00:12.703262   27358 configset.go:77] Warning: No kubeproxy.config.k8s.io/v1alpha1 config is loaded. Continuing without it: configmaps "kube-proxy" not found
[reset] WARNING: Changes made to this host by 'kubeadm init' or 'kubeadm join' will be reverted.
[reset] Are you sure you want to proceed? [y/N]: y
[preflight] Running pre-flight checks
The 'update-cluster-status' phase is deprecated and will be removed in a future release. Currently it performs no operation
[reset] Stopping the kubelet service
[reset] Unmounting mounted directories in "/var/lib/kubelet"
[reset] Deleting contents of config directories: [/etc/kubernetes/manifests /etc/kubernetes/pki]
[reset] Deleting files: [/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]
[reset] Deleting contents of stateful directories: [/var/lib/etcd /var/lib/kubelet /var/lib/dockershim /var/run/kubernetes /var/lib/cni]

The reset process does not clean CNI configuration. To do so, you must remove /etc/cni/net.d

The reset process does not reset or clean up iptables rules or IPVS tables.
If you wish to reset iptables, you must do so manually by using the "iptables" command.

If your cluster was setup to utilize IPVS, run ipvsadm --clear (or similar)
to reset your system's IPVS tables.

The reset process does not clean your kubeconfig files and you must remove them manually.
Please, check the contents of the $HOME/.kube/config file.
[root@k8s kubeadm]# kubeadm init --config kubeadm.yaml
[init] Using Kubernetes version: v1.22.2
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8s.master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.31.80]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8s.master localhost] and IPs [192.168.31.80 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8s.master localhost] and IPs [192.168.31.80 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 11.507190 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.22" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node k8s.master as control-plane by adding the labels: [node-role.kubernetes.io/master(deprecated) node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node k8s.master as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: gsulfd.k4zq9hdfsn7a5317
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.31.80:6443 --token gsulfd.k4zq9hdfsn7a5317 \
        --discovery-token-ca-cert-hash sha256:30cc5cadfac54d1a6542e9b450527c8fe727168a3895bfda5c14c8e315d8003b
[root@k8s kubeadm]#
```

配置 kube config 文件

```
[root@k8s kubeadm]# kubectl get nodes

The connection to the server localhost:8080 was refused - did you specify the right host or port?
[root@k8s kubeadm]#
[root@k8s kubeadm]# ps -aux | grep 8080
root     31251  0.0  0.0 112824   972 pts/0    S+   01:13   0:00 grep --color=auto 8080
[root@k8s kubeadm]#
```

![ubectl-get-nodes-error-8080-refused](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/kubectl-error-8080-refused.png)

方法1：
```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

方法2：
```shell
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
source ~/.bash_profile
```

```shell
[root@k8s ~]# kubectl get nodes
NAME         STATUS     ROLES                  AGE     VERSION
k8s.master   NotReady   control-plane,master   6h50m   v1.22.2

[root@k8s ~]# kubectl get pods -n kube-system
NAME                                 READY   STATUS    RESTARTS        AGE
coredns-7f6cbbb7b8-22hpq             0/1     Pending   0               6h49m
coredns-7f6cbbb7b8-qsbjs             0/1     Pending   0               6h49m
etcd-k8s.master                      1/1     Running   4 (5h41m ago)   6h49m
kube-apiserver-k8s.master            1/1     Running   4 (5h41m ago)   6h50m
kube-controller-manager-k8s.master   1/1     Running   7 (5h41m ago)   6h49m
kube-proxy-pbq78                     1/1     Running   2 (5h41m ago)   6h49m
kube-scheduler-k8s.master            1/1     Running   8 (4m50s ago)   6h50m


[root@k8s ~]# kubectl apply -n kube-system -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
serviceaccount/weave-net created
clusterrole.rbac.authorization.k8s.io/weave-net created
clusterrolebinding.rbac.authorization.k8s.io/weave-net created
role.rbac.authorization.k8s.io/weave-net created
rolebinding.rbac.authorization.k8s.io/weave-net created
daemonset.apps/weave-net created



```
PS C:\Users\Minso> VBoxManage.exe startvm k8s-master -type headless
Waiting for VM "k8s-master" to power on...
VBoxManage.exe: error: The VM session was closed before any attempt to power it on
VBoxManage.exe: error: Details: code E_FAIL (0x80004005), component SessionMachine, interface ISession


```shell
lms@lms:~$ ssh root@k8s.node
Last login: Fri Oct 22 02:02:22 2021 from 192.168.31.200
[root@k8s ~]# kubeadm join 10.114.1.39:6443 --token ajk7gh.zqo5ldmo84subl5h --discovery-token-ca-cert-hash ^C
[root@k8s ~]# kubeadm join 192.168.31.80:6443 --token gsulfd.k4zq9hdfsn7a5317 \
> ^C      --discovery-token-ca-cert-hash sha256:30cc5cadfac54d1a6542e9b450527c8fe727168a3895bfda5c14c8e315d8003b
[root@k8s ~]# kubeadm join 192.168.31.80:6443 --token gsulfd.k4zq9hdfsn7a5317 --discovery-token-ca-cert-hash sha256:30cc5cadfac54d1a6542e9b450527c8fe727168a3895bfda5c14c8e315d8003b
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.


lms@lms:~$ ssh root@k8s.master
Last login: Fri Oct 22 08:08:29 2021 from 192.168.31.200
[root@k8s ~]# kubectl get nodes
NAME         STATUS     ROLES                  AGE    VERSION
k8s.master   Ready      control-plane,master   7h8m   v1.22.2
k8s.node     NotReady   <none>                 26s    v1.22.2
[root@k8s ~]#
```

![virtualbox-high-cpu](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/virtualbox-high-cpu.png)

![NMI watchdog: BUG: soft lockup](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/k8s-kernel-error-soft-lockup.png)

```shell
Oct 22 23:37:18 k8s kernel: watchdog: BUG: soft lockup - CPU#1 stuck for 107s! [containerd:970]
```

- https://www.aityp.com/kubernetes%E5%88%A0%E9%99%A4node%E8%8A%82%E7%82%B9/
- https://blog.51cto.com/u_12462495/2472207
- https://zhuanlan.zhihu.com/p/415297992
- https://www.cxyzjd.com/article/lisongyue123/109715589
- https://seekplum.github.io/deploy-kubernetes-cluster/#%E5%AE%89%E8%A3%85Pod%E7%BD%91%E7%BB%9C
- https://segmentfault.com/a/1190000020675199
- https://cloud.tencent.com/developer/article/1709844
- https://segmentfault.com/a/1190000020675199
- https://zhuanlan.zhihu.com/p/114072542
- https://github.com/kubernetes/dashboard/tree/v2.4.0


```shell
kubectl describe pod weave-net-7jq74 --namespace=kube-system
```

```shell
[root@k8s ~]# kubectl --namespace=kubernetes-dashboard get service kubernetes-dashboard
NAME                   TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
kubernetes-dashboard   NodePort   10.102.172.200   <none>        443/TCP   4h18m

[root@k8s ~]# kubectl --namespace=kubernetes-dashboard edit service kubernetes-dashboard

# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
# services "kubernetes-dashboard" was not valid:
# * spec.ports[0].nodePort: Forbidden: may not be used when `type` is 'ClusterIP'
#
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"k8s-app":"kubernetes-dashboard"},"name":"kubernetes-dashboard","namespace":"kubernetes-dashboard"},"spec":{"ports":[{"port":443,"targetPort":8443}],"selector":{"k8s-app":"kubernetes-dashboard"}}}
  creationTimestamp: "2021-10-23T04:15:30Z"
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
  resourceVersion: "14361"
  uid: c781b0bd-7cd4-4bf0-9165-649a7c2865d3
spec:
  clusterIP: 10.102.172.200
  clusterIPs:
  - 10.102.172.200
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - ort: 443
    protocol: TCP
    targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}

[root@k8s ~]# kubectl --namespace=kubernetes-dashboard get service kubernetes-dashboard
NAME                   TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
kubernetes-dashboard   NodePort   10.102.172.200   <none>        443:32443/TCP   4h5m
[root@k8s ~]# kubectl get secret -n kubernetes-dashboard | grep token
default-token-fkfmk                kubernetes.io/service-account-token   3      4h9m
kubernetes-dashboard-token-gqwkg   kubernetes.io/service-account-token   3      4h9m
[root@k8s ~]#
[root@k8s ~]#
[root@k8s ~]# kubectl describe secret -n kubernetes-dashboard kubernetes-dashboard-token-gqwkg
Name:         kubernetes-dashboard-token-gqwkg
Namespace:    kubernetes-dashboard
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: kubernetes-dashboard
              kubernetes.io/service-account.uid: bb92dad2-7d73-4577-a480-46f3f4710a64

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1099 bytes
namespace:  20 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IkdzeTZld2g5WkJXYktWczJNN1pjOGxvYzF6aG1sUm1aRk9oeUVaQ3NtczAifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZC10b2tlbi1ncXdrZyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImJiOTJkYWQyLTdkNzMtNDU3Ny1hNDgwLTQ2ZjNmNDcxMGE2NCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDprdWJlcm5ldGVzLWRhc2hib2FyZCJ9.VMMAAhncC8pZb1Q9Y2C0k1ZFBClJhnnHTLFwtv0ZYZmzjEGxVLWR-ruLu0E4aVTswTrG_xgCKR1Re1CRY-C6OORzhTUJiqtGLNKUT-MNGAiAvH-C09PHz94ENwb9Aop0tVmYb25sVOj39kX36LGe2d5h2-kbFsSn2mxohtM6IXgWDghCgLWmTXmFRpJWNPRqs7Vlx46YuOTxHXe3m4qQ_CrNOLluDZ-EljD1olkB5s2njsW6wMJYWCRfpeOvRSU4i_J9w_Ho2VR0pzp9eQjV5fuuXWq3-xGB9zoxb9QEMQugljh4Y3P6LTaZehaALCrC7wckv778eT8s8uuH48wEVQ
[root@k8s ~]#
```

内核升級：https://www.jianshu.com/p/fdf6bb6c5b9c

![uname -sr](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/uname-sr.png)

## What is the difference between kubectl apply and kubectl replace

https://stackoverflow.com/questions/47241626/what-is-the-difference-between-kubectl-apply-and-kubectl-replace

命令式系统关注：“如何做”==>由用户定义具体的每一步操作过程
声明式系统关注：“做什么”==>用户告诉服务方要的结果即可，服务方的具体步骤对用户是屏蔽、无感知的【用户只负责定义结果】

1、Kubernetes 是声明式系统

2、Kubernetes 推荐 YAML 文件来描述要部署的 API 对象的状态变化：kubectl create -f conf.yaml

3、控制器模式：使用一种 API 对象（Deployment）管理另一种 API 对象（即： Pod ）的方法，在 Kubernetes 中，叫作“控制器”模式（ controller pattern ）。

4、常用命令：
- 查看 kubectl 版本： `kubectl version -o json`
- 获取节点：` kubectl get nodes`
- 获取所有 Pod ： `kubectl get pods -A`
- 获取指定 Namespace 下的 pod ： `kubectl get pods -n <namespace>`
- 查看 pod 详细信息( debug 利器)： `kubectl describe pod -n <namespace> <podName>`
- 进入 pod ：`kubectl exec -it <podName> -- /bin/bash`
- 在集群中创建对应的 Deployment： `kubectl create -f <conf.yaml>`
- 在集群中删除对应的 Deployment： `kubectl delete -f <conf.yaml>`

5、对 Kubernetes 对象的创建和更新操作推荐统一使用 kubectl apply 命令，而不是 kubectl replace。
- kubectl replace 会首先删除资源，然后从您提供的文件中创建资源；
- kubectl apply 则是尝试直接在当前活动资源中直接热更新文件中赋予它的属性

若 yaml 文件错误的情况下： kubectl replace 直接会使 pod 被删除后无法创建，而 kubectl apply 则会是更新失败但不影响原来的 pod


推荐使用`replica=1`而不使用单独pod的主要原因是pod所在的节点出故障的时候 pod可以调度到健康的节点上，单独的pod只能在节点健康的情况下由kubelet保证pod的健康状况吧

[Kubernetes入门：Pod、节点、容器和集群都是什么？](https://zhuanlan.zhihu.com/p/32618563)

[从零开始入门 K8s：详解 Pod 及容器设计模式](https://www.infoq.cn/article/xyxndh6oiook75vo4zie)