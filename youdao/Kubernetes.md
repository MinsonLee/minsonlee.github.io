# Kubernetes Learning Notes

> - [云原生词汇表：Cloud Native(云原生) Glossary](https://glossary.cncf.io/zh-cn/)
> - [Computer science glossary 计算机科学词汇表单词卡 | Quizlet](https://quizlet.com/ca/476764915/computer-science-glossary-%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%A7%91%E5%AD%A6%E8%AF%8D%E6%B1%87%E8%A1%A8-flash-cards/)


[TOC]

```txt
Info for Kubernetes Learning Notes
    Latest Version : `2022/04/18`
    Author : limingshuang
```

## Kubernetes 是什么？设计目标是什么？架构是如何的？

`Kubernetes` 是 Google 发起的一个用于**自动化部署、自动扩缩容、监控和维护容器化程序**（即：容器编排）的开源系统，最初源于谷歌内部的 Borg（面向应用的容器集群部署和管理系统）系统。`K`与`S`中间刚好 8 个字母，其简称又叫：K8S，K8S 使用 Go 语言进行实现。

- K8S 的目标：消除编排物理/虚拟计算、网络和存储基础设施的负担，并使应用程序运营商和开发人员完全将重点放在以容器为中心的原理上进行自助运营。
- K8S 的设计理念：面向分布式集群架构而设计的编排系统，具备完善的集群管理能力（即：K8S 天生就是支持分布式集群系统部署设计的）
- K8S 的架构模式：K8S 属于主从分布式架构，由一个 Master 和多个 Node 组成。客户端命令行工具 `kubectl`

![K8S简易架构图](https://minsonlee.github.io/images/pig/K8S简易架构图.png)

[`Kubernetes` 的特性](https://kubernetes.io/zh/)：
- 自动化上线和回滚
- 存储编排
- 自动装箱
- IPv4/IPv6 双协议栈
- 自我修复
- 服务发现与负载均衡
- Secret 和配置管理
- 批量执行
- 水平扩缩
- 为扩展性而设计

## K8s 中各种资源对象的理解和定义

1. 传统应用是怎么部署的？

2. 为什么要上云？


### 资源对象

K8S 相当于云原生时代的操作系统，它在架构设计理念上借鉴了操作系统设计 的分层架构设计， K8S 将整个分布式集群架构按照作用抽象为了不同的“资源对象”模块。

**代码即环境**，K8S 通过各类 `*.yml` 文件来定义各类资源对象，简单安装、灵活配置，尽可能的保证了环境一致。

在谈具体的各类资源模块之前，先来谈几个可能会常常接触到的名词：

- `CRI` - Container Runtime Interface（容器运行时接口）基于 gRPC 使用 Protocol Buffer 实现
- `CNI` - Container Network Interface(容器网络接口) 这是 Google 和 CoreOS 主导制定的容器网络标准，并非一个具体的实现或代码，该标准基于 `rkt` 网络提议的基础上发展起来的
- `CVI` - Container Volume Interface(容器存储卷接口)
- `OCI` - Open Container Initiative 是 Linux 基金会与 2015年6月 成立的组织，旨在：围绕容器格式和运行时制定一个开放的工业化标准，目前主要有两个标准文档：**容器运行时标准(runtime spec)**、**容器镜像标准(image spec)**
- `runc`- 符合 OCI 标准的容器引擎（容器运行时），顾名思义：处于运行状态的容器。
- `Addons` 插件（扩展）

#### Pod（po）

**Pod = N 个业务容器 + 1个根容器(Pause 容器)**

- ==Pod 是 Kubernetes 中最小的“部署调度”单元==，K8S 中 Pod 的概念是：一组进行了资源限制的，在隔离环境（该环境又叫：PodSandbox）中的容器集合。
- 每个 Pod 可以由一个或多个业务容器和一个根容器（Pause 容器）组成
- 一个 Pod 就表示某个应用的一个实例（即：一个 Pod 就是一个完整的项目）
- Pod 中的容器不一定是 Docker，只要是符合 CRI 规范即可
- **Pod 中的所有容器共享 Pod 的资源**，如：网络资源、进程资源、共享卷等

**[1、为什么有了容器，还需要 Pod？
即：容器和 Pod 的区别？Docker 和 Pod 的关系？](https://www.redhat.com/zh/topics/containers/what-is-kubernetes-pod)**

1. 容器是一个或多个进程的集合(包含其运行所需的必备文件系统)，可以方便的在相同内核的计算机上快速的部署移植
2. Docker 本身并不是容器，它是创建容器的工具，是应用容器引擎，Docker 的出现解决了旧容器时代打包困难的问题。
    - Docker 将容器的操作简化为其“三板斧”：Build, Ship and Run（搭建、发送、运行）
    - 并且通过创新的 分层镜像、Dockerfile 方式方便快捷的实现了：Build once，Run anywhere 的目标
3. Pod  是一个或多个容器的集合，一个 Pod 中的所有容器，共享相同的计算资源。在 K8S 资源对象中，一个 Pod 就是一个完整的应用
4. K8S 将容器打包为容器集（Pod），通过集群管理来最大程度发挥资源共享的优势，也更具有扩展性
    - 资源共享的优势：多个容器彼此之间往往是需要共享某些资源的（如：配置信息、环境变量、网络、内存等资源）,抽象出一层 Pod 的资源对象，Pod 中的容器共享计算资源
    - 扩展性：**Kubernetes 不依赖于底层某一种具体的规则去实现容器技术，而是通过抽象出 CRI 接口层来操作符合 CRI 规范的容器，从而实现整个 K8S 集群 与 具体容器技术 之间的解耦，更是通过实现了 CRI-O 接口扩展来接入了 OCI 组织所规范的容器运行时**
    - 扩展性：对容器技术进行了规范、抽象，更容易去定义一组容器的状态，从而更方便对容器以及整个 Pod 进行监控
    - 资源共享的优势：pause 容器有一个 ip 地址，和一个存储卷，pod中的其他容器共享pause容器的ip地址和存储，这样就做到了文件共享和互信。

**结论：在生产中我们最终的目的能对一个完整可用的“应用” 进行快速复制，而通过容器只能实现快速复制应用中的一个部分，但 “一个 Pod 就是一个应用” 的概念显然更符合需求**

> 在 https://www.jianshu.com/p/62e71584d1cb 发现了这么一句话，一言道尽精髓：
>
> ==**制定容器格式标准的宗旨概括来说就是不受上层结构的绑定，如特定的客户端、编排栈等，同时也不受特定的供应商或项目的绑定，即不限于某种特定操作系统、硬件、CPU架构、公有云等。**==

**[2、K8S 底层移除对 Dockershim 的支持，意味着 K8S 中不能使用 Docker 了吗？](#)**

**如果非要将容器编排系统分类，那么可以按名气来分可以分为：K8S 和 其它容器编排系统，**，而就是在 `2020/12/02` K8S 官方在其 v1.20 版本中说到 K8S 底层突然宣布其底层将会考虑弃用 Dockershim（在 v1.22 版本中被彻底移除），很多标题党公号都来蹭流量的说“Docker 已死”...，想要详细了解的可以看看官方的博客：[弃用 Dockershim 的常见问题](https://kubernetes.io/zh/blog/2020/12/02/dockershim-faq/)、[Dockershim Removal FAQ](https://kubernetes.io/blog/2022/02/17/dockershim-faq/)。

简明扼要说两点：

1. 为什么早期 K8S 底层要支持 Docker ？

早期 Docker 火爆了市场，迅速占领了容器市场，随后 Docker 推出了“三架马车”、继而进一步想将 Docker 自己的容器标准推广作为整个容器行业的标准，意图继续趁热打铁占领容器编排的江山，而 K8S 作为容器编排系统是在 Docker 之后被几大巨头公司一起联合推出，不管在概念设计、还是功能应用、亦或是产品背景...K8S 都甩其它编排系统几条街，但没法子出生晚了，所以为了抢夺市场只能“卧薪尝胆”-附和当时的市场情况，增长自己的势力，因此 [Rkt](https://cloud.tencent.com/developer/news/58175) 和 [Docker的docker-shim](https://blog.csdn.net/u013812710/article/details/79001463) 两大容器引擎在早期的 K8S 中是直接被集成源码中的。

但 K8S 是 Docker 的推行其自己编排工具的竞争对手这一格局始终是存在的，一直依附在他人势力之下生长还处处受限制始终不是个办法。所谓“卧榻之下，岂容他人酣睡？”，如果 Docker 自己的编排工具真的被广泛应用开来了，保不齐 Docker 辉煌那一天就是对 K8S 动刀子的时候。

K8S 为了解决这一困局，在 v1.5 版本时候首次推出了 Container runtime interface (CRI) 这个概念，定义了 K8S 的 “容器运行时” 接入标准，使得自己能容纳更多的“盟友”，让更多容器运行时的开发者能够轻松地将其容器与 Kubernetes 生态系统集成。

2. 为什么后期 K8S 底层要弃用 Docker ？：

如上文说的，Docker 本身自己就想推行自己容器编排工具（Docker Compose、 Docker Machine、 Docker Swarm）并且 Docker 还想踢开其他容器巨头公司（Google/AWS/CoreOS/RedHeat）自己来制定标准。虎口夺食，还不愿意分一杯羹想独吞蛋糕...于是就被其他大头联合创建了 OCI 组织，专门用来规范容器、镜像标准，并且 K8S 自己的 CRI 也专门通过 CRI-O 扩展接入支持这一标准。随着 K8S 接入的“盟友”越来越多（而原来的 Rkt 则通过 [rktlet](https://github.com/kubernetes-retired/rktlet) 接入 K8S 的 CRI），其势力也越来越大，Docker 又不肯配合 K8S 标准进行改造，正所谓“一山不容二虎”，Docker 最终被 K8S 给踢出了局...

但是“由俭入奢易，由奢入俭难”，Docker 曾经登顶过行业的高峰怎么甘心没落呢？于是 Docker 自己准备“决定洗心革、面重新做人”，将自己 Docker Daemon 核心抽离分割成几个模块，其中对 “容器运行时和生命周期管理” 的部分就被分割成了符合 OCI 标准的 containerd 模块，而 K8S 更是基于 CRI 孵化出了 `CRI-O` 用来支持接入符合 OCI 标准的容器运行时，于是即使 K8S 登上皇位之后，即使直接废弃了对 docker-shim 的底层支持，但 Docker 还是能在 K8S 中被使用的。

至于 Docker 后续会不会弯道超车，逆风翻盘？亦或就此沉沦变为配角呢？只能静待岁月来验证了。但不管怎么说，Docker 也是在容器行业的时间画轴中留下了重重的一抹彩色的

**[3、Pod 就是一个应用的实例，那么 Pod 和 服务 的区别是什么？](#)**

Pod 与服务的关系应用类似于面向对象语言中继承关系的使用：“子类对象”实例化“接口父类”

- Pod 是应用的具体实例
- Pod 是多变的，可扩展的
- 服务是要稳定的、对外不变
- 服务为 Pod 对外访问提供稳定性


**[4、一个 Pod 的创建流程是怎样的？](#)**

![一个 Pod 的创建流程](https://minsonlee.github.io/images/pig/k8s-create-a-pod-process.png)

**[5、如何为 Pod 中的容器指定使用私有镜像？](https://kubernetes.io/zh/docs/tasks/configure-pod-container/pull-image-private-registry/)**

- [镜像 | Kubernetes](https://kubernetes.io/zh/docs/concepts/containers/images/)
- [在Kubernetes集群如何支持私有镜像 (aliyun.com)](https://help.aliyun.com/document_detail/86562.html)

#### 用于标记分组、描述 Pod 的对象

##### Label（标签）/Selector（选择器）

> [官文文档：标签和选择算符](https://kubernetes.io/zh/docs/concepts/overview/working-with-objects/labels/)

- 作用
	- 通过一个键值对来给 Pod 进行标记，方便对 Pod 进行分组/选择，可进行高效查询和监听 Pod 的情况
	- 标签的 KEY 对于给定的对象必须是唯一的。
如：在所有 Pod 对象一个 KEY 必须是唯一的，但在 svc/rc 对像中可以重用当前这个 KEY
	- 标签旨在用于指定对用户有意义且相关的对象的标识属性，但不直接对核心系统有语义含义

- 语法
	- 1. 键值对方式，KEY/VALUE 都必须是字符串，格式： KEY: "VALUE"
	- 2. 有效的标签有两个段：可选的前缀+必须的名称，前缀和名称通过 / 进行分隔
	- 3. 名称必须小于等于 63 字符，以字母或数字开头结尾，中间字符支持的正则表达式：[a-z0-9A-Z_.-]

- 注意事项
	- 对象的 YAML/JSON 构建文件中 `selector` 必须和 `labels`一一对应，
否则在 `kubectl apply -f xx.yml`构建时会报错：`selector` does not match template `labels`

##### Annotations（注解）

> [官方文档：注解](https://kubernetes.io/zh/docs/concepts/overview/working-with-objects/annotations/)

- Label 用于对象分组可进行查询，而 Annotations 则是通过键值对的方式来描述对象
- annotations 的语法上没有标签那么多约束，只要是键值对即可

```yaml
## $ cat rc.yml
apiVersion: v1
kind: ReplicationController
metadata:
    name: nginx
spec:
    replicas: 3
    selector:
        app: nginx
    template:
        metadata:
            name: nginx
            labels:
                app: nginx
            annotations:
                imageregistry: "https://hub.docker.com/"
                test: "is a Annotations test"
        spec:
            containers:
            - name: nginx
                image: nginx
                ports:
                - containerPort: 80

# kubectl describe replicationcontroller/nginx
```

##### Namespace

[Namespace 机制]((https://kubernetes.io/zh/docs/concepts/overview/working-with-objects/namespaces/))将“同一个集群”中的资源划分为相互隔离的"组"。

**注意事项**
- 1、同一个 Namespace 中的资源名称要唯一 即：`matedata.name`
- 2、作用域仅针对带有 `namespace` 属性的对象，例如 Deployment、Service、Pod 等
对集群访问的对象不适用，例如 StorageClass、Node、PersistentVolume 等
- 3、前缀 `kube-*` 的命名空间是为 K8S 系统名字空间保留字，避免使用
- 4、Kubernetes 会创建四个初始名字空间【**我们应当始终保证不去对这4个命名空间进行修改**】
	- default : 没有指明使用其它名字空间的对象所使用的默认名字空间
	- kube-system : Kubernetes 系统创建对象所使用的名字空间
	- kube-public : 该命名空间是 K8S 下自动创建的，在整个集群中应该是可见和可读的，所有用户都可以访问
	- kube-node-lease : 该命名空间含有与每个节点关联的Lease对象，节点lease允许kubelet发送heartbeat（心跳），以便控制平面（节点控制器）可以检测节点故障

#### 对 Pod 进行管理的资源对象

- RC： Pod 的进程管理器
- RS： 新一代的 RC，除了对 Labels 支持不同，其它基本一致
- Deployment：用于管理 RS 和 Pods 的资源对象
- StatefulSet：用于部署无状态服务的部署对象
- HPA：实现 Pod 的自动水平扩缩的对象
- Job：类似于用于执行一次性任务的特殊 RS 资源对象
- CronJob：加了时间调度的 Job 对象

##### Replication Controller（RC）

[ReplicationController](https://kubernetes.io/zh/docs/concepts/workloads/controllers/replicationcontroller/) 用于 Pod 的自动部署、监控、升级，确保在任何时候都有一个 Pod 或一组同类的 Pod 总是可用的，它就像**Pod 的“守护进程管理器”**。

**最主要作用如下：**

1. 确保 Pod 的数量
    - Pod 数量过多：RC 会 kill 掉多余的 Pod
    - Pod 数量不足: RC 会通过 template 的方式快速创建补足 Pod 数量
2. 确保 Pod 的健康
    - 通过 RC 来创建的 Pod 在失败、被删除、被终止时会被自动替换
    - 反之，手动创建 Pod 资源对象，则需要自己手动管理这些状态
3. 弹性伸缩：在业务高峰或低峰期，可通过 rc 动态调整 Pod 的数量来提高资源的利用率
4. 滚动升级：采取逐步替换的策略，进行平滑过度升级，保证整体系统的稳定

**注意事项**

1. RC 对象的 YAML/JSON 构建文件中 `spec.selector` 必须和 `spec.template.metadata.labels`必须一样，
否则在 `kubectl apply -f xx.yml`构建时会报错：`selector` does not match template `labels`
2. **现在推荐使用配置 ReplicaSet 的 Deployment 来建立副本管理机制**，因为：**RC 不支持回滚操作**。譬如，若 Pod 中的容器在升级版本过程中出现错误，只能手动将 Pod 容器版本改为上一个版本再通过滚动升级方式替换有问题的 Pod。

##### ReplicaSet（RS）副本集

[ReplicaSet（RS）副本集](https://kubernetes.io/zh/docs/concepts/workloads/controllers/replicaset/) 是 Pod 的副本对象集（又称：复制集），是用于解决 Pod 的快速横向扩容与横向伸缩。

RC 和 RS 在功能上基本完全一样，唯一的区别在于 labels/selector 的不同：
①. RC selector 只支持 `=` 查询（类似：只支持 where key=value）；
②. RS labels 支持定义集合、selector 支持 `=`、`!=`、`in` 的复杂查询。


- **RC 有的功能 RS 全都有，因此：如果你要用 RC，那么请用 RS 进行代替**
- **RS 一般结合 Depolyment 使用**

##### Deployment：管理 Pod 和 Replica Set

[Deployment](https://kubernetes.io/zh/docs/concepts/workloads/controllers/deployment/) 表示一个部署对象，实现了对 Pod 的生命周期管理、Pod 的调度、Pod 的监控、Replica Set 的管理等问题。

Deloyment 的作用如下：

1. **Deployment 具有 ReplicationController 全部功能，是目前最新一代官方推荐用于替换 ReplicationController 的一种部署资源对象**
2. 事件状态查看：可以查看 Deployment 的升级详细进度和状态
3. 版本记录&&回滚：每一次对 Deployment 的操作都能被保存下来，**可以使用回滚操作回滚到指定的稳定版本**
4. 暂停和启动：对于每一次升级操作，支持函随时暂停和启动（即：实现了类似快照的功能）
5. 多种升级方案
    - Recreate: 删除所有已存在的 pod，重新创建
    - RollingUpdate: 滚动升级，逐步替换


**Deloyment 其实是对 RS 管理进而实现对 Pod 的管理，并通过维护多个 RS 副本来实现 Pod 的回滚**

- 推荐阅读：[Replication controller与Deployment的区别](https://cloud.tencent.com/developer/article/1145286)

##### HorizontalPodAutoscaling（HPA）

[Horizontal Pod Autoscaling（HPA）](https://kubernetes.io/zh/docs/tasks/run-application/horizontal-pod-autoscale/) 是基于 RC 和 Deployment 之上的一种部署资源对象，它可以根据 RC/RS/Deployment/StatefulSet 资源对象中 的负载边框情况来针对性地调整 Pod 的数量（即：水平自动扩缩）。

- 1、 CPU 利用率：targetCPUUtilizationPercentage
- 2、应用程序自定义度量指标，如：TPS、QPS...

![HPA 水平自动扩展 Pod 机制原理](https://minsonlee.github.io/images/pig/k8s-hpa.png)

##### StatefulSet（部署有状态服务）

[StatefulSet](https://kubernetes.io/zh/docs/concepts/workloads/controllers/statefulset/) 与 Deloyment 一样也是一个部署对象，但不同的是：

- Deployment 用于部署无状态服务（如 Nginx）；
- StatefulSet 用于部署有状态服务（如 数据库）；

**如何区分是有状态？无状态？**

1. 不同时刻，同样的请求得到的服务状态/数据是否有变更
2. [无状态服务](https://kubernetes.io/zh/docs/tutorials/stateless-application/)：不需要在本地存储持久化数据（如 Nginx）;
3. [有状态服务](https://kubernetes.io/zh/docs/tutorials/stateful-application/)：需要在本地存储持久化数据（如 MySQL）
4. 有状态和无状态不是严格区分的，如：一个 Web 服务理论应该是无状态服务的；
但如果我们将该 Web 服务的 session 数据持久化到 Pod 上，那么就变成了一个 有状态 的服务了

##### DaemonSet

[DaemonSet](https://kubernetes.io/zh/docs/concepts/workloads/controllers/daemonset/) 用于在“节点”上部署守护进程的 Pod 副本资源对象

1. 部署对象是基于 节点 而设计的
2. DaemonSet 能让所有或指定 Node 节点上运行有且一个相同的 Pod。如：
    - 集群存储守护进程，如：glusterd、ceph、etcd（只是仅在 master 节点部署）
    - 节点监控守护经常 Pod，如：Prometheus 监控集群
    - 日志收集守护进程，如：fluentd、logstash
    - 节点健康检查守护进程
3. 当有新节点加入到 K8S 集群中来，DaemonSet 会自动将其 Pod 调度到该节点上运行
4. 当删除 DaemonSet 资源对象时，该对象产生的所有 Pods 会一并在对应节点上被自动删除
5. DaemonSet 可以在即使调度器还没有启动的情况下创建 Pod

##### Job（任务）

[Job](https://kubernetes.io/zh/docs/concepts/workloads/controllers/job/) 是一种执行一次性任务即销毁的资源对象。其保证了一个或多个 Pod  在批处理任务执行成功后被释放

1. Job 的 .spe.restartPolicy 仅支持 Never 和 OnFailure 两种，不支持 Always
2. 一旦 Job 被删除，Job 中的 Pod 也会被删除

##### CronJob（定时任务）

[CronJob](https://kubernetes.io/zh/docs/concepts/workloads/controllers/cron-jobs/) 就是加上了时间调度的 Job 资源对象，只是在其被执行完后不会自动被销毁。

1. CronJob YAML 文件中 .spec.schedule字段是必须填写的
格式与 Linux-Crontab 一样：分 时 日 月 星期
2. 当我们删除一个 CronJob 资源对象时
    - 正在运行中的 Job 即其 Pod 不会被清理，需要手动清理
    - 正在创建中的 Job：会被终止
3. CronJob YAML 中 `.spec.jobTemplate` 也是必填，用于指定运行的任务 `.spec.jobTemplate` 其实就是一个 Job 格式的任务


FAQ：K8S 中秒级定时任务如何处理？
- [作业帮 Kubernetes Serverless 在大规模任务场景下的落地和优化](https://www.infoq.cn/article/3u8psdfaybd0bfrauyy4)
- [实现GAE和GKE k8s cron job的秒级调度单位](https://github.com/mrdulin/blog/issues/73)

#### 网络访问资源

使的资源具备对外提供服务的网络能力：
- Service 对服务集群内（内网）提供稳定的服务；
- Ingress 对服务集群外（公网）提供稳定的服务；

##### Service（svc） 服务

[Service（简称：SVC）](https://kubernetes.io/zh/docs/concepts/services-networking/service/) 是 K8S 中最重要的一个资源对象。其对应我们平常说的微服务架构中的一组“**微服务**”。

SVC 将运行在一组 Pods 上的应用程序公开为网络服务的抽象方法，前端的应用通过 `<service>.<namespace>` 地址进行访问 Service 后端的 Pod 副本实例，并且 SVC 在其内部实现了服务发现、内部负载均衡、DNS 等功能。

我们可以通过更改 Service 的类型来更改服务发布的方式：

- ClusterIP（默认）: 通过集群内部的 IP 暴露服务，只能在集群内部访问
- NodePort: 通过 SVC 所在节点上的 IP 和 静态端口(NodePort) 向外部暴露服务。
- LoadBalancer: 通过[各大云厂商提供的负载均衡器](https://kubernetes.io/zh/docs/concepts/services-networking/service/#loadbalancer)向外部暴露服务。 LB 可以将流量路由到自动创建的 NodePort 服务和 ClusterIP 服务上
- ExternalName: 通过 CNAME 方式将服务映射到 externalName 字段的内容（PS:xxx.example.com），无需创建任何类型代理

**为什么要有 SVC？**

这个问题转换为：为什么不使用 Pod 的 IP 直接访问服务？服务和 Pod 的区别？

K8S 使用 Overlay Network 的方式，在 Pod 所在节点创建了一个实实在在的虚拟网卡产生的，并为该为其提供一个自己的 IP 地址，并在 Pod 内部提供相同的 DNS 解析。

但 Pod 是一种 **非永久性资源**，即：Pod 是有状态能被销毁重建的、能被不断调度到不同节点的，因此 Pod 的 IP 地址不是固定的，故而使用 Pod 的 IP 来访问服务显然是不合理了。

但我们向外暴露一个服务，“**稳定性**”是我们需要首要考虑的必备特性之一，因此： K8S 基于 Deployment 之上，抽象出了一层“**虚拟的、能提供访问服务的**”网络层，SVC 去除了 IP 这一个概念，而是通过 `<service>.<namespace>` 的方式来访问内部服务，但该域名仅在集群内有效，是由 K8S 内部的 DNS 负责解析的。

**当我们创建一个 SVC 时，K8S 会创建一个相应的 DNS 记录**，格式为：`<service>.<namespace>.svc.cluster.local`.

##### Ingress 服务入口

![Ingrees 访问路由规则](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/ingress-route-rule.png)


[Ingress](https://kubernetes.io/zh/docs/concepts/services-networking/ingress/) 是对集群中服务的外部访问进行管理的 API 对象，典型的访问方式是 HTTP/HTTPS。它是一个抽象，仅创建 Ingress 资源本身没有效果，需要一个 [Ingress Controller](https://kubernetes.io/zh/docs/concepts/services-networking/ingress-controllers/)。如：Istio Ingress、Nginx Ingress、Traefik、[OpenELB](https://mp.weixin.qq.com/s/eB0oA5qWxJw3nypGNxhMow)、MetalLB


##### Service 和 Ingress 发布服务的区别？既然 SVC 已经可以暴露服务了，为什么又要有 Ingress 呢？

- [使用 Service 暴露您的应用](https://kubernetes.io/zh/docs/tutorials/kubernetes-basics/expose/expose-intro/)
- [Service 发布服务的类型](https://kubernetes.io/zh/docs/concepts/services-networking/service/#publishing-services-service-types)


#### 扩展 API 对象

##### CustomResourceDefinition（CRD）

K8S 提供 CRD 这种 API 资源对象给开发者，使得用户可以对 [Kubernetes API](https://kubernetes.io/zh/docs/concepts/extend-kubernetes/api-extension/custom-resources/) 进行扩展。

#### Node资源对象

K8S 属于主从分布式架构，由一个 Master 节点和多个 Node 节点组成（节点可以是一个虚拟机或者物理机器，取决于所在的集群配置）。

K8S 通过将容器放 Pod 中，Pod 部署在 [节点（Node） ](https://kubernetes.io/zh/docs/concepts/architecture/nodes/) 上运行，以此种方式来执行工作负载。

其架构简易示意图如下

![K8S简易架构图](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/K8S简易架构图.png)

- Master 节点是整个集群的控制节点，负责整个集群的管理和控制
- Worker 节点（通常我们说的 Node 都是指工作节点）负责承载具体的 Pod，具体负载情况由 Master 节点进行调度。

##### Master 节点

Master 节点上包含以下重要组件：

- kube-apiserver : 集群控制的入口，通过 RESTAPI 风格的接口实现对 K8S 集群的管控
- kube-controller-manager : Kubernetes 集群中所有资源对象的控制中心（每个Controller负责一种具体的控制流程）的管理者
- kube-scheduler : 负责 Pod 的调度，为新创建的 Pod 选择一个节点
- Etcd : 相当于集群的数据库

##### Worker Node

- kubelet : 负责与 Master 节点交互，操作调用 CNI/CVI/containerd 实现对节点上 Pod 的管理（创建、启动、监控、重启、销毁等...）
- kube-proxy : 实现 Kubernetes Service 之间的通信和负责均衡
- Container : 可以是Docker容器、也可以是 Podman容器，只要创建出的容器是“符合CRI规范”的即可
- Fluentd : 负责Pod的日志收集、存储、查询

### 存储对象

[K8S 中的存储对象](https://kubernetes.io/zh/docs/concepts/storage/)主要指的就是各种“卷”对象。按照生命周期上来分类，K8S 的卷可以分为：

- 临时卷：Pod 上的一个目录，生命周期与 Pod 相同
- 持久卷：生命周期与 Pod 独立，存储在 K8S API 服务器（etcd、secret）上

#### Volume

[存储卷](https://kubernetes.io/zh/docs/concepts/storage/volumes/)：与 [Docker 的 volume](https://docs.docker.com/storage/) 类似，但  K8S 中的 volume 是定义在 Pod 上的
该 Pod 中所有的容器都可以挂载到该存储卷上，实现同一个 Pod 中容器间的资源共享

- Docker 卷是磁盘上或另一个容器内的一个目录，而 K8S 所支持的卷类型则非常丰富
- Pod 可以同时使用任意数目类型的卷

#### PersistenVolume（持久卷）

[PersistenVolume](https://kubernetes.io/zh/docs/concepts/storage/persistent-volumes/)：一种持久类型的卷 API 资源对象，实现了 Node 之间的资源共享，每个 Node 都可以挂载。

在 Pod 中可以通过定义一个 PersistenVolumeClaim（PVC）对象来使用 PersistenVolume 资源。

#### ConfigMap

[ConfigMap](https://kubernetes.io/zh/docs/concepts/configuration/configmap/) 是一种 API 对象资源，它可以创建出一种 configMap Volume 的资源对象，用于向 Pod 注入配置数据

- ConfigMap 对象中存储的数据可以被 configMap 类型的卷引用，然后被 Pod 中运行的容器化应用使用
- 在使用 ConfigMap Volume 之前你首先要创建它 ConfigMap 对象
- 如果容器以 subPath 卷挂载方式使用 ConfigMap 时，将无法接收 ConfigMap 的更新

#### Secret

[Secret](https://kubernetes.io/zh/docs/concepts/configuration/secret/) 卷是由 tmpfs（基于 RAM 的文件系统）提供存储的持久卷，用于向 Pod 传递敏感信息，如：密码

### 策略对象

[策略对象](https://kubernetes.io/zh/docs/concepts/policy/) 主要是 K8S 内部为了约束集群内部节点对资源的侵占而设定的一种资源使用约束机制。

#### SecurityContext（安全上下文）

[安全上下文](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#securitycontext-v1-core) 是一种定义 Pod 或 Container 的特权与访问控制设置的 API 安全策略对象。

Kubernetes 提供了三种配置 Security Context 的方法:

- Container-level Security Context：仅应用到指定的容器
- Pod-level Security Context：应用到 Pod 内所有容器以及 Volume
- Pod Security Policies（PSP）：应用到集群内部所有 Pod 以及 Volume

[优点知识：Security Context](https://www.qikqiak.com/k8strain/security/security-context/#security-context)
、[Security Context 和 Pod Security Policy](https://feisky.gitbooks.io/kubernetes/content/concepts/security-context.html)

#### ResourceQuota（资源配额）

资源配额通过 [ResourceQuota 对象](https://kubernetes.io/zh/docs/concepts/policy/resource-quotas/)来定义，其主要作用如下：

- 对每个命名空间的资源消耗总量提供限制
- 限制命名空间中某种类型的对象的总数上限
- 限制命令空间中的 Pod 可以使用的计算资源总上限

#### LimitRange（范围限制）

默认情况下， Kubernetes 集群上的容器运行使用的计算资源没有限制，通过 ResourceQuota 对象我们可以以命名空间为单位，限制其资源的使用与创建。而 [LimitRange](https://kubernetes.io/zh/docs/concepts/policy/limit-range/) 是在命名空间内限制多个 Pod 或 Container 之间的资源分配策略对象。

- 在一个命名空间中实施对每个 Pod 或 Container 最小和最大的资源使用量的限制
- 在一个命名空间中实施对每个 PersistentVolumeClaim（持久卷对象） 能申请的最小和最大的存储空间大小的限制
- 在一个命名空间中实施对一种资源的申请值和限制值的比值的控制，如：CPU、内存
- 设置一个命名空间中对计算资源的默认申请/限制值，并且自动的在运行时注入到多个 Container 中

自 Kubernetes 1.10 及其以上版本默认启用对 LimitRange 的支持，LimitRange 的名称必须是合法的 [DNS 子域名](https://kubernetes.io/zh/docs/concepts/overview/working-with-objects/names/#dns-subdomain-names).

### 身份对象

K8S 提供了一组 API 对象用于对 [K8S 访问安全控制](https://kubernetes.io/zh/docs/reference/access-authn-authz/) 进行认证、鉴权。

同时 K8S 中还提供一组[基于角色（Role）的访问控制（RBAC）机制](https://kubernetes.io/zh/docs/reference/access-authn-authz/rbac/) 的 API 对象，用于实现集群内用户的角色来调节控制访问权限。

RBAC API 声明了四种 Kubernetes 对象：`Role`、`ClusterRole`、`RoleBinding` 和 `ClusterRoleBinding`。

#### ServiceAccount

[ServiceAccount](https://kubernetes.io/zh/docs/reference/access-authn-authz/authentication/#service-account-tokens) 是一种自动被启用的用户令牌认证机制，使用经过签名的“持有者令牌”来验证请求。

#### Role（角色）

Role API 资源对象用于限制某个 Namespace 内的访问权限。

#### ClusterRole（集群角色）

ClusterRole 也是基于角色的鉴权规则，用于限制一个集群作用域内的资源访问权限



## K8S 集群环境搭建

### 本地调试： K3S 搭建单节点 Kubernetes 环境

### 学习环境：Minikube 安装单节点 K8S 集群

安装先决条件：

- 2 CPUs or more
- 2GB of free memory
- 20GB of free disk space
- Internet connection
- Container or virtual machine manager，such as: Docker

**！！！注意：minikube 不能通过 root 用户进行启动，否则会启动失败**，因此可以先创建一个 K8S 专用的账户，然后使用该账户进行下述操作。

1. 根据自己的系统及系统架构版本，结合 [minikube start](https://minikube.sigs.k8s.io/docs/start/) 文档所说下载对应的二进制安装包
2. 启动 minikube 安装集群：`minikube start --memory=1974mb` 或直接执行下方的 `start.sh` 文件

```sh
# `--driver=docker` 指定使用 docker 作为容器底层
echo -n "Starting Kubernetes..."

minikube version
minikube start --memory=1974mb --wait=false
sleep 2
n=0
until [ $n -ge 10 ]
do
   (minikube addons enable metrics-server && minikube addons enable dashboard) && break
   n=$[$n+1]
   sleep 1
done
sleep 1
n=0
until [ $n -ge 10 ]
do
   kubectl apply -f /opt/kubernetes-dashboard.yaml &>/dev/null  && break
   n=$[$n+1]
   sleep 1
done

echo "Kubernetes Started"
```

> 如果你使用的是 WSL2或虚拟机安装要确认一下可使用内存是否满足 1947MB，这是 minikube 能正常运行所需的内存空间

![minikube start install](https://minsonlee.github.io/images/pig/minikube-start.png)

3. 启动 Kubernetes Dashboard : 在一个新窗口执行 `minikube dashboard` （我们可以使用 `nohup minikube dashboard &` 将 dashboard 放到后台运行，通过 `cat nohup.out` 查看输出信息获取 dashboard 地址）

![Start Kubernetes Dashboard With Minikube](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/minikube-start-dashboard.png)

4. 开放外网访问
```sh
# 同理，若要放到后台运行，则通过 nohup 方式处理
kubectl proxy --port=<port> --address='0.0.0.0' --accept-hosts='^.*'
```

- [CentOS7 Minikube - Kubernetes 单机安装](https://kebingzao.com/2020/11/06/k8s-install-minikube/)

### 测试/生产环境：kubeadm 安装 K8S 集群

> 目前 Kubeadm 被 K8s 接受并持续更新，可用于生产。

- [使用 kubeadm 创建集群](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
- [Kubernetes 文档 > 参考 > 安装工具 > Kubeadm](https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/)
- [Kubeadm 安装指南](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/)
- [用 kubeadm 搭建集群环境](https://www.qikqiak.com/k8s-book/docs/16.%E7%94%A8%20kubeadm%20%E6%90%AD%E5%BB%BA%E9%9B%86%E7%BE%A4%E7%8E%AF%E5%A2%83.html)
- [kubeadm 搭建多 master 高可用 K8S 集群（亲测）](https://blog.51cto.com/u_11573159/4955693)
- [k8s【如果忘记master节点init后join命令怎么办】](https://blog.csdn.net/wzy_168/article/details/106552841)
    - `kubeadm token create --print-join-command`
- [kubeadm reset 重置](https://www.cnblogs.com/shunzi115/p/14776507.html)

### 生产环境：二进制方式安装 K8S 集群

- [手动搭建高可用Kubernetes集群](https://youdianzhishi.com/web/course/1004/1019)

### kubectl 安装及自动补全

`kubectl` 命令行工具是用来管理控制 Kubernetes 集群的。

```
# 安装 kubectl

cd /tmp
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin
sudo chown root:root /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl # root 用户的 PATH 路径中是没有 /usr/local 这个目录的，因此放到 /usr/local/bin 中也能保证不能直接使用 ROOT 用户访问 K8S

# 验证安装成功
kubectl version

# 安装自动补全
echo 'source <(kubectl completion bash)' >>~/.bashrc
source ~/.bashrc

# 如果安装了 bash-completion 可通过下述方式为全局用户安装补全
# 验证是否安装 bash-completion : `type _init_completion`
# install bash-completion: `apt-get install bash-completion` or `yum install bash-completion`
# kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
# reflash bash-completion : `source /usr/share/bash-completion/bash_completion`
```

`kubectl` 配置文件加载顺序：
1. 通过 `--kubeconfig` 临时强行指定配置文件
2. 通过环境变量 [`KUBECONFIG`](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#:~:text=If%20the%20KUBECONFIG%20environment%20variable,in%20the%20KUBECONFIG%20environment%20variable.) 指定配置文件 `export KUBECONFIG="config file path"`
3. `${HOME}/.kube/config` 默认配置文件（如果 kubectl 报错，一般都是查看这个文件，检查是否有问题）


> 详细参阅：[在 Linux 系统中安装并设置 kubectl](https://kubernetes.io/zh/docs/tasks/tools/install-kubectl-linux/)

在正式进入学习 K8S 之前，需要简单的学一学 [YAML 的语法](#)、对 Kubectl 的使用有个大致的了解。 这两点是必要的，`kubectl` 简述可先浏览一次 [kubectl 概述](https://kubernetes.io/zh/docs/reference/kubectl/overview/)、[kubectl cheatsheet](https://kubernetes.io/zh/docs/reference/kubectl/cheatsheet/)，后续有问题可到 [kubectl Reference Docs](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands) 查阅。

- [ ] [『Kubernetes 101』案例](http://kubernetes.kansea.com/docs/user-guide/walkthrough/)
- [ ] [『Kubernetes 201』案例](http://kubernetes.kansea.com/docs/user-guide/walkthrough/k8s201/)

`kub`

1. 通过 YAML 创建资源对象

```sh
kubectl create -f <path_for_yaml_file> # 单纯创建资源对象
kubectl apply -f  <path_for_yaml_file> # 若资源不存在则创建资源对象，存在则更新资源对象
```

2. 获取 Pods 信息

```
kubectl get pods --all-namespaces # 所有命名空间下的 pods
kubectl get pods -n <namespace> # 指定命名空间下的 pods (默认值是：default 命名空间)
kubectl describe pod <pod_name> # 查看 Pod 详细信息
```

## 深入理解 K8S 中的资源对象

如何查看 K8S 集群的版本信息呢？

`kubectl version` 可以打印 `kubectl` 和 K8S Master 节点的版本信息（` kubectl version --short=true` 只打印简短版本号），我们在写 YAML 时遇到有问题可以去 `https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23` （最后的版本号替换为你集群的版本号即可）去查询问题。【[Kubernetes API](https://kubernetes.io/docs/reference/kubernetes-api/)】

```json
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.5", GitCommit:"c285e781331a3785a7f436042c65c5641ce8a9e9", GitTreeState:"clean", BuildDate:"2022-03-16T15:58:47Z", GoVersion:"go1.17.8", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.3", GitCommit:"816c97ab8cff8a1c72eccca1026f7820e93e0d25", GitTreeState:"clean", BuildDate:"2022-01-25T21:19:12Z", GoVersion:"go1.17.6", Compiler:"gc", Platform:"linux/amd64"}
```

### 深入理解 Pod 对象

#### 静态 Pod

一般来说，我们使用 Pod 都会结合下方提到的 ReplicaSet、 Deployment、Service 等资源对象一起使用，然后通过 Master 节点的 API Server 来进行管理和调度。但有些情况下，我们会希望我们的 Pod 能和固定的 Node 进行绑定而不会被随意调度到其他节点上（如：API Server 的 Pod 有且只需要在 Master 节点上运行）。我们可以通过 `Static Pod` 的方式进行创建并由节点所在的 kubelet 直接操作管理。

Static Pod 由节点所在的 kubelet 进程直接监控，如：当 pod 崩溃时候自动重启 pod；通过 kubelet 对 pod 进行更新...**但 kubelet 也无法对其进行健康检查**。

kubelet 会自动为每一个 Static Pod 在 Master 节点上创建一个 Mirror Pod，因此我们可以通过 API Server 查看，但是对其进行的操作（如：删除、更新）却是无效的，因为它只是 Static Pod 的一个镜像而已。

[创建 Static Pod](https://kubernetes.io/zh/docs/tasks/configure-pod-container/static-pod/#static-pod-creation) 有两种方式（通过启动 kubelet 服务时不同的参数进行指定）：

- kubelet 配置文件指定目录:
    - 指定 StaicPod Path 方式1：`kubelet --pod-manifest-path=/path/for/kubelet.d/` 
    - 指定 StaicPod Path 方式2：`/etc/kubernetes/kubelet.conf` 配置文件中指定 `staticPodPath: </path/for/kubelet.d/>`
    - 在 kubeletConfigFile 添加 `KUBELET_ARGS="--cluster-dns=10.254.0.10 --cluster-domain=kube.local --pod-manifest-path=/etc/kubelet.d/"` 指定 kubelet 启动时自动添加的参数
- HTTP 方式: `kubelet --manifest-url=<URL/for/kubelet.d/>`

两种方式都是一样：定期从指定目录/Web路径去拉取 Static Pod 的 YAML/JSON 配置文件，然后**根据目录下配置文件的变更来自动创建、自动更新、自动删除静态 Pod**。

如果我们不想每次启动 kubelet 都要通过 `--pod-manifest-path=/path/for/kubelet.d/` 方式进行指定可以考虑通过除了通过 kubeletConfigFile 中添加 `staticPodPath` 字段，还可以通过环境变量的方式指定 kubelet 服务每次启动时自动添加对应的 arguments（参数）进行启动。

1. `systemctl status kubelet` 查看 kubelet.service 启动时每次都会加载的配置（PS：如通过 minikube 安装的 K8S 单节点服务 ` /etc/systemd/system/kubelet.service.d/10-kubeadm.conf`）
2. 在 `10-kubeadm.conf` 配置中添加上 
`Environment="KUBELET_SYSTEM_PODS_ARGS=--cluster-dns=10.254.0.10 --cluster-domain=kube.local --pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true"`
3. 重启 kubelet: `systemctl daemon-reload && systemctl restart kubelet` 

![ systemctl status kubelet](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/systemctl-status-kubelet.png)

`Minikube` 方式 `10-kubeadm.conf` 文件如下：

```conf
[Unit]
Wants=docker.socket

[Service]
ExecStart=
ExecStart=/var/lib/minikube/binaries/v1.23.3/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime=docker --hostname-override=minikube --housekeeping-interval=5m --kubeconfig=/etc/kubernetes/kubelet.conf --node-ip=192.168.49.2

[Install]
```

`Kubeadm` 方式 `10-kubeadm.conf` 文件如下：

```conf
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf -kubeconfig=/et c/kubernetes/kubelet.conf"
Environment="KUBEYT_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true"
Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"
Environment="KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local"
Environment="KUBELET_AUTHZ_ARGS=--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt"
Environment="KUBELET_CADVISOR_ARGS=--cadvisor-port=0"
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"
Environment="KUBELET_CERTIFICATE_ARGS=--rotate-certificates=true --cert-dir=/var/lib/kubelet/pki"
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"

ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_SYSTEM_PODS_ARGS $KUBELET_NETWORK_ARGS $KUBELET_DNS_ARGS $KUBELET_AUTHZ ARGS $KUBELET_CADVISOR ARGS $KUBELET_CGROUPARGS $KUBELET_CERTIFICATE_ARGS $KUBELET_EXTRA_ARGS
```

测试 Static Pod YAML

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: static-pod-test-nginx
  labels:
    app: static
spce:
  containers:
  - name: web
    image: nginx
    ports:
      - name: web
        containerPort: 80
```

#### Pod Hook

[Pod Hook](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/) 是由 kubelet 发起的，当**容器中的进程启动前 或 容器中的进程终止之前被同步阻塞运行**，即：Hook 被执行完之前，kubelet 会锁住容器。

Kubernetes 目前提供了两种 Pod Hook 函数：

- PostStart: 在容器创建后，被同步阻塞调用。
    - **[虽然同步阻塞调用，但是不能确保一定是在 Entrypoint 执行之前被同步阻塞调用](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks)**。
    - 只有当 Hook 执行完成且成功容器状态才会变为 RUNNING
    - PostStart 如果执行失败会直接终止容器
    - 应用：资源部署、环境准备等
- PreStop: 容器终止之前被同步阻塞调用
    - 只有当 Hook 执行完成且成功容器状态才会从 RUNNING 变为 Failed
    - PreStop 如果执行失败，容器会被终止
    - 如果 PreStop 在执行过程中，对应容器被挂起（PS: docker stop <container>），那么 Pod 对外会一直显示 RUNNING
    - 应用：优雅的关闭应用程序、通知其他系统等

Hook 被执行的方式有两种：

- Exec: 执行一段特定的命令，格式和 Dockerfile 中写 ENTRYPOINT 一样。该命令的执行所需的资源会一并被记入当前容器所占资源中
- HTTP: 对容器上的特定端口执行 HTTP 请求

**注意事项：**

1. Hook 程序应该尽可能轻量，避免容器因为钩子花费过长时间而长时间不能运行或挂起
2. Hook 调用的日志并没有暴露给 Pod event，所以我们只能通过 `kubectl describe pod xxx` 命令来查看，若钩子执行有错误会看到 `FailedPostStartHook` 或 `FailedPreStopHook` 这样的 event

在 YAML 中使用 `.spe.containers[0].lifecycle.postStart` 属性 

测试 Pod 的 YAML

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hook-demo1
spec:
  containers:
  - name: hook-demo1
    image: nginx
    lifecycle:
      postStart:
        exec:
          command: ["/bin/sh", "-c", "echo Hello from the postStart handler > /usr/share/message"]

---
apiVersion: v1
kind: Pod
metadata:
  name: hook-demo2
spec:
  containers:
  - name: hook-demo2
    image: nginx
    lifecycle:
      preStop:
        exec:
          command: ["/usr/sbin/nginx","-s","quit"]

---
apiVersion: v1
kind: Pod
metadata:
  name: hook-demo2
  labels:
    app: hook
spec:
  containers:
  - name: hook-demo2
    image: nginx
    ports:
    - name: webport
      containerPort: 80
    volumeMounts:
    - name: message
      mountPath: /usr/share/
    lifecycle:
      preStop:
        exec:
          command: ['/bin/sh', '-c', 'echo Hello from the preStop Handler > /usr/share/message']
  volumes:
  - name: message
    hostPath:
      path: /tmp
```

#### Pod 健康检查

- `liveness probe`（存活探针）：捕获当前应用程序的状态，若状态是异常或崩溃则重启容器
- `readiness probe`（可读性探针）：确定容器是否已经准备就绪可以接收流量了，只有当 Pod 中所有容器都准备就绪了才会认为该 Pod 已经准备就绪。


#### Pause 容器（Infra 容器）


[Pause 容器](https://github.com/kubernetes/kubernetes/tree/master/build/pause) 又叫 Infra 容器（全称：Infrastructure Container-基础容器），因为该容器**永远处于挂起暂停状态**，所以我们也会叫它 Pause 容器，且 **Pause 容器是 Pod 中第一个被启动的容器，Pause 容器的更新不会导致整个 Pod 的重启**。

通过 `--pod-infra-container-image` 参数指定 infrastructure 镜像地址。在前面简单介绍 Pod 资源对象时说过：**Pod 中的所有容器共享 Pod 的资源**。此处要解决的资源共享主要是：存储资源（通过 Volumes 资源来解决）、网络资源两方面。

Pause 容器主要就是**用来处理网络资源共享**的问题，如：如何让一个 Pod 中的所有容器共享同一个 IP？容器相互间可以通过 localhost 互相访问？

Pause 容器为每个业务容器提供了下述的功能：

- PID 命名空间：Pod 中的不同应用程序可以看到其他应用程序的进程ID
- 网络命名空间：Pod 中的多个容器能够访问同一个 IP 和端口范围
- IPC 命名空间：Pod 中的多个容器能够使用 SystemV IPC 或 POSIX 消息队列进行通信（[IPC:Inter-Process Communication](https://www.cnblogs.com/huansky/p/13170125.html)）
- UTS 命名空间：Pod 中的多个容器共享一个主机名

K8S 通过让 Pod 中的其它容器都通过 Join Namespace 的方式来加入到 Pause 容器的 NeatWork Namespace，从而实现了同一个 Pod 中所有容器共享同一份网络资源的问题。 

**介绍 Docker 的网络模式时提到，Docker 有四种网络模式  bridge 模式、host 模式、container 模式、None 模式。其实 K8S Pod 中的容器就是采用 container 模式来实现**。如：

```shell
docker run -d --name pause -p 8880:80 --ipc=shareable <pause-image>
docker run -d --name <name> --net=container:pause --ipc=container:pause --pid=container:pause <app-image>
```

- https://k8s.iswbm.com/c02/p02_learn-kubernetes-pod-via-pause-container.html
- https://jimmysong.io/kubernetes-handbook/concepts/pause-container.html

#### Init 容器

- https://jimmysong.io/kubernetes-handbook/concepts/init-containers.html
- [Init 容器 | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/workloads/pods/init-containers/)
- https://k8s.iswbm.com/c02/p03_kubernetes-pod-init-container.html

#### Pod 的生命周期

- https://kubernetes.io/zh/docs/concepts/workloads/pods/pod-lifecycle/
- Init 容器和 PostStart 钩子的区别是什么？
    - Init 容器是针对整个 Pod 而言的
    - PostStart 是针对 main 容器而言的
- Infra 容器和 Init 容器的区别？场景？

![Pod 生命周期](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/pod-live-cycle.png)

#### 注意事项：Pods/ReplicationController/ReplicaSet/Deployment

**尽可能不要单独手动使用和管理 Pod，为什么呢？**

尽量避免刀耕火种年代的亲力亲为，使用 RC/RS 能自动检测节点是否异常、Pod的运行状态，有条件性的自动调度 Pod 的数量，维持 Pod 所提供的服务稳定。

1. 即使是1个Pod，也要用 RS/Deployment 来进行管理，而不要单独处理
2. 尽可能使用 YAML 来管理资源对象描述，方便追溯和管理
3. 修改 Pod 信息：优先通过修改 yaml 来修改；其次通过 `kubectl edit xxx` 来修改。尽可能做到修改可追溯
4. **使用 Deployment 来进行滚动升级，一定注意设置好滚动[升级策略](https://kubernetes.io/zh/docs/concepts/workloads/controllers/deployment/#strategy)**

#### Deloyment 滚动升级

Kubernetes 中使用 Deployment 资源对象来对 Pod 进行升级，目前支持两种方式：
- 重新创建（Recreate）：先删除当前执行中的所有 Pod ，删除成功之后再进行创建新的 Pod 进行替代
- 滚动升级（RollingUpdate）：先创建一定数量的新 Pod，创建成功之后再删除原来对应数量的 Pod 进行逐步替换。

```yaml
spec: 
  revisionHistoryLimit: 10 # 设置 etcd 记录并存储最近的 RS 历史版本的版本数量（默认是 10，0 表示删除所有历史版本）  
  minReadySeconds: 5 # 让新建的 Pod 在 Ready 状态等待 5 秒后才进行替换升级，避免新启动容器有异常
  strategy： # 配置升级策略
    type: RollingUpdate # RollingUpdate-滚动升级（默认值）；Recreate-重新创建
    rollingUpdate: 
        maxSure: 1 # 升级过程中最多可以比原先设置多出的 POD 数量（可以是一个明确数字，亦可是一个百分比，默认：25%）
        maxUnavailable: 1 # 升级过程中最多有多少个 POD 可以处于无法提供服务的状态（可以是一个明确数字，亦可是一个百分比，默认：25%）
```

对于每一次升级操作，支持函随时暂停和启动（即：实现了类似快照的功能）

- 应用升级：`kubectl apply -f <deployment.yaml>  --record=true`
- 查看状态：`kubectl rollout status deployment/<DeploymentName>`
- 暂停升级：`kubectl rollout pause deployment <DeploymentName>`
- 继续升级：`kubectl rollout resume deployment <DeploymentName>`
- 查看历史：`kubectl rollout history deployment <DeploymentName> [--revision=<versionNum>]`
- 回滚版本：`kubectl rollout undo deployment <DeploymentName> [--to-revision=<versionNum>]`
- 删除 RS: `kubectl delete rs <ReplicaSet Name>`

**我们在使用 Deployment 进行升级时最好带上 `--record=true` 参数，这样便于我们记录、查看历史版本信息**。操作 Deployment 资源时带上该参数会被 `Kubernetes` 将当前的 `ReplicaSet` 持久化记录到 `etcd` 中，这无形其实是带来了维护成本的：①. 资源占用；②. 时间久没有清理会造成垃圾 RS 堆积。

但相比“出现问题能快速回滚版本”来说，以上问题的代价是小的。生产中，我们可以通过设置 Deployment 的 `.spec.revisionHistoryLimit` 




#### Pod 的自动扩缩容

- 为什么用扩容？
- Pod 扩容有哪些方式？
    - [手动：kubectl scale 指定](http://docs.kubernetes.org.cn/664.html)
        - `kubectl scale --replicas=<COUNT> rs/<podName>[ rs/<podName> ...]`
        - `kubectl scale --replicas=<COUNT> rc/<podName>[ rc/<podName> ...]`
        - `kubectl scale --replicas=<COUNT> deployment/<podName>`
        - `kubectl scale --replicas=<COUNT> -f file.yml`
    - [自动：HPA-水平自动扩容](https://kubernetes.io/zh/docs/tasks/run-application/horizontal-pod-autoscale/#scaling-on-custom-metrics)
    - [自动：VPA-垂直自动扩容](https://www.servicemesher.com/blog/kubernetes-vertical-pod-autoscaler/)
- 什么场景下用自动扩容（HPA）？
- 用它能带来什么好处？
- 解决什么问题？
- 带来哪些收益？
- HPA 支持哪些检测标准？如何来选定适合自己业务的检测标准？
    - 从 [Heapster](https://kubernetes.io/zh/docs/tasks/run-application/horizontal-pod-autoscale/#scaling-on-custom-metrics) 中获取 CPU 使用率来自动扩缩（目前基本弃用）
    - 用户自定义资源指标，如：TPS/QPS/内存使用率
    - https://blog.51cto.com/u_14143894/2458468
    - https://www.orchome.com/1260


- https://kingjcy.github.io/post/cloud/paas/base/kubernetes/k8s-autoscaler/
- 

## K8S 的一些参考资料

- [CNCF Cloud Native Interactive Landscape](https://landscape.cncf.io/)
- [Kubernetes 中文文档](https://kubernetes.io/zh/docs/home/)
- [Kubernetes 知识图谱](https://www.processon.com/view/designer/5ac61d63e4b00dc8a02ed698#map)
- [Kubernetes Handbook——Kubernetes 中文指南/云原生应用架构实战手册](https://jimmysong.io/kubernetes-handbook/)
- [Kubernetes 入门指南](http://kubernetes.kansea.com/docs/)
- [Kubernetes 指南](https://kubernetes.feisky.xyz/)
- [Kubernetes中文社区 | 中文文档](http://docs.kubernetes.org.cn/)
- [优点知识：从 Docker 到 Kubernetes 进阶](https://youdianzhishi.com/web/course/1007)
- [优点知识-K8S 开发课](https://youdianzhishi.com/web/course/1018)
- [优点知识：深入理解 Kubernetes 开发课文档](https://www.notion.so/cnych/K8S-b33520bf4f2c4005adb66f5ee1785502)
- [极客时间：
深入剖析Kubernetes](https://time.geekbang.org/column/intro/100015201)
- [优点知识：Kubernetes 进阶训练营第3期](https://youdianzhishi.com/web/course/1030)
- [阿里公开课：云原生技术公开课](https://edu.aliyun.com/roadmap/cloudnative?spm=a1z389.11499242.0.0.65452413sISWj4&utm_content=g_1000072542)
- 马哥的 K8S 课程（重理论，知其然）
- 阿良的 K8S 高级课程（重实操）
- [优点知识：K8S 进阶训练营](https://www.qikqiak.com/k8strain/)
- [优点知识：K8S 二开（百度云）](https://youdianzhishi.com/web/course/1018) 的 [课程资料](https://www.notion.so/cnych/K8S-b33520bf4f2c4005adb66f5ee1785502)
- 极客时间：Kubernetes 专栏
- 极客时间：云原生训练营(阿里云)

## 一些阅读过的文章

- [x] [容器开放接口规范（CRI OCI CNI）](https://www.jianshu.com/p/62e71584d1cb)
- [x] [Container Runtime Interface (CRI): Past, Present, and Future](https://www.aquasec.com/cloud-native-academy/container-security/container-runtime-interface/)
- [x] [容器与 Pod 有什么区别和联系？](https://mp.weixin.qq.com/s/hM44tL1Ai6US15vDYJrWEQ)
- [x] [一关系图让你理解K8s中的概念，Pod、Service、Job等到底有啥关系](https://mp.weixin.qq.com/s/-CsK00RkXepZQXOxbNumEA)
- [x] [什么是 Kubernetes 容器集？](https://www.redhat.com/zh/topics/containers/what-is-kubernetes-pod)
- [x] [k8s pod和容器概念的区分](https://blog.51cto.com/u_11093860/2337707)
- [x] [Kubernetes 基本概念与组件](https://www.qikqiak.com/k8s-book/docs/15.%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5%E4%B8%8E%E7%BB%84%E4%BB%B6.html)
- [x] [初识Kubernetes（K8s）：理论基础](https://blog.51cto.com/andyxu/2308937)
- [x] [初识Kubernetes（K8s）：各种资源对象的理解和定义](https://blog.51cto.com/andyxu/2329257)
- [x] [Minikube 安装和简单使用](https://www.cnblogs.com/jhxxb/p/15220729.html)
- [x] [弃用 Dockershim 的常见问题](https://kubernetes.io/zh/blog/2020/12/02/dockershim-faq/)
- [x] [Dockershim Removal FAQ](https://kubernetes.io/blog/2022/02/17/dockershim-faq/)
- [x] [谈谈docker，containerd，runc，docker-shim之间的关系](https://blog.csdn.net/u013812710/article/details/79001463)
- [x] [Rkt容器介绍](https://cloud.tencent.com/developer/news/58175)
- [ ] [初识Kubernetes（K8s）：kubectl命令使用详解](https://blog.51cto.com/andyxu/2334922)
- [ ] [K8s 中 Service、Endpoints、Pod 之间的关系](https://blog.csdn.net/catoop/article/details/122072608)
- [ ] [一篇文章让你搞懂K8s Ingress，Traefik 2.0为例（上）](https://mp.weixin.qq.com/s/1sMwe2VsRPoy1eMXic9g7Q)
- [ ] [你知道K8S暴露服务的方式有哪些吗？](https://cloud.tencent.com/developer/article/1882237)
- [ ] [图解 Kubernetes Ingress](https://www.qikqiak.com/post/visually-explained-k8s-ingress)
- [ ] [图解 Kubernetes Service](https://www.qikqiak.com/post/visually-explained-k8s-service/)
- [ ] [聊聊Service和Ingress](https://zhuanlan.zhihu.com/p/88304095)
- [ ] [关于Amazon EKS中Service和Ingress深入分析和研究](https://aws.amazon.com/cn/blogs/china/in-depth-analysis-and-research-on-service-and-ingress-in-amazon-eks/)
- [ ] [容器与Pod到底有什么区别和联系？](https://new.qq.com/omn/20220410/20220410A03M6U00.html)
- [ ] [一文搞懂容器运行时 Containerd](https://www.qikqiak.com/post/containerd-usage/)
- [ ] [使用 k8s 部署你的第一个应用: Pod，Deployment 与 Service](https://shanyue.tech/k8s/pod.html)
- [ ] [Google Kubernetes Engine(GKE)](https://cloud.google.com/kubernetes-engine/docs/deploy-app-cluster?hl=zh-cn)
- [ ] [作业帮 Kubernetes Serverless 在大规模任务场景下的落地和优化](https://www.infoq.cn/article/3u8psdfaybd0bfrauyy4)
- [ ] [实现GAE和GKE k8s cron job的秒级调度单位](https://github.com/mrdulin/blog/issues/73)
- [ ] [聊聊你可能误解的Kubernetes Deployment滚动更新机制](https://blog.csdn.net/WaltonWang/article/details/77461697)
- [ ] [Kubernetes Deployment滚动更新原理解析](https://blog.dianduidian.com/post/kubernetes-deployment%E6%BB%9A%E5%8A%A8%E6%9B%B4%E6%96%B0%E5%8E%9F%E7%90%86%E5%88%86%E6%9E%90/)
- [ ] [如何优雅的对 Pod 进行抓包](https://mp.weixin.qq.com/s/gC1GEvtS9-la2GT4iZvwuA)
- [ ] [Kubernetes 集群部署 之 多Master节点 实现高可用](https://blog.csdn.net/duanbaoke/article/details/119667328)
- [ ] [使用 kube-vip 搭建高可用 Kubernetes 集群](https://www.qikqiak.com/post/use-kube-vip-ha-k8s-lb/)
- [ ] [如何优雅地使用 kubectl 访问多集群多 namespace ☕️—— kubectl-cf, kubectx 和 kubens](https://juejin.cn/post/6968129599070797837)
- [ ] [使用 kubectl 管理多个 k8s 集群](https://zhuanlan.zhihu.com/p/104687460)
- [ ] [Kubernetes pod状态出现CrashLoopBackOff 的原因](https://zhangfuwei.blog.csdn.net/article/details/126606394) 
- [ ] [图解 K8s](https://k8s.iswbm.com/index.html)
- [ ] [kubernetes系列教程大纲](https://cloud.tencent.com/developer/article/1515095)
- [ ] [Kubernetes 学习笔记](https://imroc.cc/k8s/)
- [ ] [k8s中挂载的configmap或者secret更新后服务自动更新](https://blog.csdn.net/wzy_168/article/details/118482758)
- [ ] [kubeadm更新证书及配置](https://blog.csdn.net/wzy_168/article/details/110921089)
- [ ] [kubeadm初始化k8s集群延长证书过期时间](https://blog.csdn.net/weixin_38320674/article/details/105721879)
- [ ] [k8s证书过期之后如何自动续订证书](https://blog.csdn.net/weixin_38320674/article/details/128597536)
- [ ] [kubernetes HPA-超详细中文官方文档](https://blog.csdn.net/weixin_38320674/article/details/105460033)
- [ ] [Kubernetes 实践指南 >     大规模集群优化](https://imroc.cc/kubernetes/best-practices/ops/large-scale-cluster-optimization.html)
- [ ] [大规模场景下 k8s 集群的性能优化](https://blog.51cto.com/coderaction/2996825)
- [ ] [高手问答第 271 期 —— 聊聊大规模 K8s 集群管理](https://www.oschina.net/question/4855753_2324480)
- [ ] [当 K8s 集群达到万级规模，阿里巴巴如何解决系统各组件性能问题？](https://developer.aliyun.com/article/719079)
- [ ] [美团集群调度系统的云原生实践](https://tech.meituan.com/2022/02/17/kubernetes-cloudnative-practices.html)
- [ ] [
5个维度对 Kubernetes 集群优化](https://opscloud.vip/2020/09/29/5%E4%B8%AA%E7%BB%B4%E5%BA%A6%E5%AF%B9%20Kubernetes%20%E9%9B%86%E7%BE%A4%E4%BC%98%E5%8C%96/)
- [ ] [K8S 面试题：service 到底能不能 ping 通](https://segmentfault.com/a/1190000039349716)
- [ ] [k8s 问题排查Pod内无法ping通集群外部的网络IP](https://www.cnblogs.com/wswind/p/14808756.html)
- [ ] [k8s event事件的重要性（重要） ](https://www.cnblogs.com/cheyunhua/p/16095231.html)
- [ ] [ubernetes 网络排错骨灰级指南！](https://www.cnblogs.com/testzcy/p/16629805.html)
- [ ] [Kubernetes Operator 快速入门教程](https://www.qikqiak.com/post/k8s-operator-101/)
- [ ] [k8s服务发现 headless svc和 普通svc 区别](https://haoxuanli.blog.csdn.net/article/details/115491346)
- [ ] [如何合理使用 CPU 管理策略，提升容器性能？](https://developer.aliyun.com/article/872282)
- [ ] [Linux性能优化实战：案例篇-为什么应用容器化后，启动慢了很多？](https://blog.csdn.net/weixin_30235225/article/details/102054155)
- [ ] [docker容器性能低 docker容器性能分析](https://blog.51cto.com/u_16213657/7068065)
- [ ] [Docker容器、虚拟机和裸机运行的性能比较](https://aijishu.com/a/1060000000206531)
- [ ] [我的docker随笔15：MySQL启动时自动创建数据库](https://juejin.cn/post/6982779631149514783)
- [ ] [安装kubernetes高可用集群(v1.26)](https://www.rhce.cc/4017.html)
- [这样的设计太妙了!K8S 神秘架构终于揭开面纱!-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/2290821)
- [马哥教育干货分享|GitOps 常用工具盘点 - 知乎](https://zhuanlan.zhihu.com/p/547104017)
- [kubernetes DaemonSet是如何保证pod只在一个节点上运行并且保证数量是1 · HAOJX |郝建勋的笔记与博客](https://haojianxun.github.io/2019/03/01/kubernetes%20DaemonSet%E6%98%AF%E5%A6%82%E4%BD%95%E4%BF%9D%E8%AF%81pod%E5%8F%AA%E5%9C%A8%E4%B8%80%E4%B8%AA%E8%8A%82%E7%82%B9%E4%B8%8A%E8%BF%90%E8%A1%8C%E5%B9%B6%E4%B8%94%E4%BF%9D%E8%AF%81%E6%95%B0%E9%87%8F%E6%98%AF1/)
- [23 个必知必会的 Kubernetes 高频面试题 - 文章详情](https://z.itpub.net/article/detail/297D228124BA2E06FA1943031E84C48D)
- [为什么我不能获取到镜像，ImagePullBackoff | Kuboard](https://kuboard.cn/learning/faq/image-pull-backoff.html)
- [k8s环境下处理容器时间问题的多种姿势 - SSgeek - 博客园](https://www.cnblogs.com/ssgeek/p/15192028.html)
- [如何排查容器日志采集异常_日志服务-阿里云帮助中心](https://help.aliyun.com/zh/sls/user-guide/what-do-i-do-if-an-error-occurs-when-i-use-logtail-to-collect-logs-from-containers)
- [深入k8s归档 - luozhiyun`s Blog](https://www.luozhiyun.com/archives/tag/%e6%b7%b1%e5%85%a5k8s)
- [24 个 Docker 常见问题处理技巧-docker常见问题](https://www.51cto.com/article/712932.html)
- [容器服务故障排查处理](https://main.qcloudimg.com/raw/document/product/pdf/457_40331_cn.pdf)
- [K8s 日志高效查看神器，提升运维效率10倍！](https://mp.weixin.qq.com/s/r0pEqyfGM9oM5eISEGNrNQ)
- [Kubernetes 上调试 distroless 容器](https://atbug.com/debug-distroless-container-on-kubernetes/)
- [GitOps 与 DevOps：了解关键差异，为企业做出最佳选择 - Seal软件的个人空间 - OSCHINA - 中文开源技术交流社区](https://my.oschina.net/u/5841507/blog/10093990)
- [云原生_程序员洲洲的博客-CSDN博客](https://blog.csdn.net/weixin_51484460/category_11839151.html)
- [Minikube创建本地Kubernetes集群 - 云斋随笔](https://www.mikesay.com/2021/10/06/create-kubernetes-minikube/#Minikube%E7%9A%84%E6%9E%B6%E6%9E%84)
- [k8s中为什么需要br_netfilter与net.bridge.bridge-nf-call-iptables=1](https://blog.csdn.net/qq_43684922/article/details/127333368)
- [从零学习云计算 - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/column/1717?tag=10652)
- [ ] [Kubernetes探针原理详解 - 史振兴 - 博客园](https://www.cnblogs.com/szx666/p/16109838.html)


## K8s 资源对象

-----

- Etcd 充当集群中的 SSOT ：单一事实来源 (Single source of truth)
    - [什么是「可信单一数据源」（SSOT）？ - 掘金](https://juejin.cn/post/6925765811055362061)
- “云计算”能力（网格计算）：分布式计算的一种，指的是通过网络“云”将巨大的数据计算处理程序分解成无数个小程序，然后，通过多部服务器组成的系统进行处理和分析这些小程序得到结果并返回给用户。 云计算早期，简单地说，就是简单的分布式计算，解决任务分发，并进行计算结果的合并。
    - worker 节点通过  kubelet-proxy 上报数据给 master 节点的 api-server，由 master 节点将数据汇总到 etcd 进行存储、分析，然后根据“声明式”语法，结合节点上报的资源情况，进一步对各节点进行资源优化或调配
- K8s 的意义：通过该系统，让中小型公司也可以借助“云计算”能力，轻松运维海量计算节点，借助 Google 15 年的运维经验从而对业务应用产生正向促进
- master 节点
    - api-server ： “打电话的接线员”，通过 REST API 的方式进行通信
    - controller-manager：“负责问诊的医生-提供丹方”， 控制中心，负责维护容器和节点等资源的状态信息，实现故障检测、服务迁移、应用伸缩
    - schedule “负责开单抓药的药剂师-炼药师”，调度器，负责容器的编排工作，检查节点的资源状态，把 Pod 调度到最合适的节点上
    - etcd 高可用的 Key-Value 数据库，持久化存储系统中的各类资源对象和状态（只与 api-server 有联系）
- node 节点
    - kubelet ： 节点代理，指挥 Node 节点容器引擎实现管理本机容器工作，并和 master 节点进行通信
    - container runtime ： 容器运行时，容器和镜像的实际使用者，在 kubelet 指挥下完成容器的工作，管理 pod 的生命周期
    - kube-proxy ： 网络通信，实现 pod 网络的代理，维护节点网络规则和四层负载均衡（即：IP+端口的方式进行路由转发）- [面试常问：四层与七层负载均衡有啥区别？-七层和四层负载均衡](https://www.51cto.com/article/711605.html)


----

- `modprobe br_netfilter` 加载内核模块，开启网络过滤，支持 `Docker` 等虚拟化
- `chrony` 时间同步服务
- Endpoint
    - [Endpoint 是什么？ | JohnsonLin](https://www.linjiangxiong.com/2023/04/19/what-is-an-endpoint/)
- containerd
    - ctr 是作为 containerd 项目的一部分提供的命令行客户端 
        - [Containerd客户端工具（CLI）介绍ctr,nerdctl,crictl，podman以及docker_Michaelwubo的博客-CSDN博客](https://blog.csdn.net/Michaelwubo/article/details/122745348)
        - [实战：containerd的本地CLI工具ctr使用-20211024 - mdnice 墨滴](https://mdnice.com/writing/78929e9fe39442fbba982009faf371b1)
    - crictl 是 K8s 子项目 `cri-tools` 提供的一个命令行客户端，用于与 K8s CRI 容器交互操作 - [使用 crictl 对 Kubernetes 节点进行调试 | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/debug/debug-cluster/crictl/)
    - [Akiraka - Container 命令ctr、crictl 命令使用说明](https://www.akiraka.net/kubernetes/1139.html)
- [YAML 简记](http://note.youdao.com/noteshare?id=5fc0fc969c7ddef7dcbfd2f3a6052262&sub=43B01A75BEC54D62B6F1522EBA6CC433)



-----

Pod生命周期包括以下几个阶段：

- Pending:在此阶段，Pod已被创建，但尚未调度到运行节点上。此时，Pod可能还在等待被调度，或者因为某些限制(如资源不足)而无法立即调度。
- Running: 在此阶段，Pod已被调度到一个节点，并创建了所有的容器。至少有一个容器正在运行，或者正在启动或重启。
- Succeeded: 在此阶段，Pod中的所有容器都已成功终止，并且不会再次重启。
- Failed: 在此阶段，Pod中的至少一个容器已经失败(退出码非零)。这意味着容器已经崩溃或以其他方式出错。
- Unknown: 和比阶段，Pod的状态无法由Kubernetes确定。这通常是因为与Pod所在节点的通信出现问题。

除了这些基本的生命周期阶段之外，还有一些更详细的容器状态，用于描述容器在Pod生命周期中的不同阶段:

- ContainerCreating: 容器正在创建，但尚未启动。
- Terminating:容器正在终止，但尚未完成。
- Terminated: 容器已终止。
- Waiting: 容器处于等待状态，可能是因为它正在等待其他容器启动，或者因为它正在等待资源可用
- Completed: 有一种Pod是一次性的，不需要一直运行，只要执行完就会是此状态。
- CrashLoopBackOff ： 由于某个容器原因，导致 Pod 一直重启（CrashLoop），而 K8s 正在尝试
    - [Kubernetes pod CrashLoopBackOff错误排查 — Cloud Atlas 0.1 文档](https://cloud-atlas.readthedocs.io/zh_CN/latest/kubernetes/debug/k8s_crashloopbackoff.html)
    - [部署的pod处于CrashLoopBackOff状态_翟海飞的博客-CSDN博客](https://blog.csdn.net/zhaihaifei/article/details/79415579)
    - [CrashLoopBackOff - Kubernetes 实践指南](https://imroc.cc/kubernetes/troubleshooting/pod/status/pod-crash.html)

-----

Deployment
- [kubernetes进阶之四：Label和Label Selector - 学无止尽，不忘初心 - 博客园](https://www.cnblogs.com/521football/p/10405208.html)
- [Labels and Selectors | Kubernetes](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)
- [kubernetes进阶之五：Replication Controller&Replica Sets&Deployments - 学无止尽，不忘初心 - 博客园](https://www.cnblogs.com/521football/p/10405310.html)
- [3.8. 使用节点选择器将 pod 放置到特定节点 OpenShift Container Platform 4.7 | Red Hat Customer Portal](https://access.redhat.com/documentation/zh-cn/openshift_container_platform/4.7/html/nodes/nodes-scheduler-node-selectors)


-----------
Service 暴露服务的 4 种类型
- [详解k8s 4种类型Service - kubernetes solutions - SegmentFault 思否](https://segmentfault.com/a/1190000023125587)
- [Service | Kubernetes](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)
    - ClusterIP（默认，仅限服务内部可访问）
    - NodePort（有安全隐患，通过节点IP:端口可外部访问）
    - LoadBalancer（需要外部 LB 支持，通过 节点IP（还是LBIP？这个LBIP不是临时且内部的吗）:端口 可外部访问）
        - [k8s系列06-负载均衡器之MatelLB - TinyChen's Studio](https://tinychen.com/20220519-k8s-06-loadbalancer-metallb/)
        - [在 Kubernetes 集群中使用 MetalLB 作为 LoadBalancer（上）- Layer2](https://atbug.com/load-balancer-service-with-metallb/)
        - [本地集群使用 OpenELB 实现 Load Balancer 负载均衡-阳明的博客](https://www.qikqiak.com/post/openelb/)
        - [Metallb 介绍 - DaoCloud Enterprise](https://docs.daocloud.io/network/modules/metallb/what/)
    - ExternalName



Endpoint 对象（简称 `ep`）：表示一个或多个 Pod 的 IP 地址和端口，这些 Pod 提供了一个具体的 Service 的功能。（通俗来说就是：**为 Service 提供后端的 Pod（或其他服务）信息，用于流量路由**，因此单独的 ep）。

当一个 Service 被创建时，**Kubernetes 会根据 Service 的 selector 字段自动创建一个相应的“同名”的 Endpoint 对象**。

这个 Endpoint 对象会持续地与满足 selector 的 Pod 同步，以保证 Service 的流量能正确地路由到这些 Pod。

比如，如果你有一个提供 HTTP 服务的 Pod 集合，你可能会创建一个 Service 对象以暴露这个 HTTP 服务。Kubernetes 会为这个 Service 自动创建一个 Endpoint 对象，里面包含提供这个 HTTP 服务的所有 Pod 的 IP 地址和端口。

当其他 Pod 或外部客户端通过 Service 访问这个 HTTP 服务时，Kubernetes 会查找这个 Endpoint 对象，以决定将流量路由到哪个具体的 Pod。

虽然通常 Endpoint 会由 Kubernetes 根据 Service 的 selector 自动创建和管理，但用户也可以手动创建 Endpoint。这在 Service 没有定义 selector 或你需要将流量路由到 Kubernetes 集群外的服务时尤其有用。

**手动创建 Endpoint 可以让你绕过 selector，直接指定流量应该路由到的 IP 地址和端口。这样，你就可以把一个 Service 配置为路由到集群外的服务或者特定的 Pod。**

**Service 和 Endpoint 通过名称进行关联，两者具有相同的名称**。这种通过名称关联的方式允许 Service 和 Endpoint 对象解耦，使得你可以**灵活地路由流量**，不仅限于集群内的 Pod，也可路由到集群外的服务。

以下是一个手动创建 Endpoint 的简单示例。

假设你有一个在 Kubernetes 集群外运行的数据库，其 IP 地址是 `192.168.1.100`，端口号是 `3306`。你想让集群内的应用能通过一个 Service 访问这个数据库。

首先，创建一个没有 `selector` 的 Service。

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db-service
spec:
  ports:
  - port: 3306
```

然后，手动创建一个对应的 Endpoint 对象。

```yaml
apiVersion: v1
kind: Endpoints
metadata:
  name: external-db-service
subsets:
  - addresses:
      - ip: 192.168.1.100
    ports:
      - port: 3306
```

通过这样的配置，当集群内的 Pod 尝试访问 `external-db-service` Service 时，流量会被路由到 `192.168.1.100:3306`，即集群外的数据库。

这样，你就手动创建了一个 Endpoint，使得 Service 可以路由到 Kubernetes 集群外的资源。


- [kubernetes endpoints是什么_软件工程小施同学 的技术博客_51CTO博客](https://blog.51cto.com/shijianfeng/2914937)

-----

Headless Service 通常用于需要直接访问每个 Pod 的场景，比如数据库集群、分布式存储等

Headless Service 是一种 Kubernetes Service 的类型，它不会创建负载均衡器或 ClusterIP，而是为每个后端 Pod 分配一个独立的 DNS 记录

- [K8S 之 Headless 浅谈-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1638722)
- [无头服务（Headless Services）](https://kubernetes.io/zh-cn/docs/concepts/services-networking/service/#headless-services)

-----------

- [给应用注入数据 | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/inject-data-application/)


- 通过 `env` 直接在 pod 中声明环境变量

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: print-greeting
spec:
  containers:
  - name: env-print-demo
    image: bash
    env:
    - name: GREETING
      value: "Warm greetings to"
    - name: HONORIFIC
      value: "The Most Honorable"
    - name: NAME
      value: "Kubernetes"
    - name: MESSAGE
      value: "$(GREETING) $(HONORIFIC) $(NAME)"
    command: ["echo"]
    args: ["$(MESSAGE)"]
```

- ConfigMap : `Key-Value` 格式的明文配置 API 对象， **ConfigMap 在设计上不是用来保存大量数据的。在 ConfigMap 中保存的数据不可超过 `1 MiB`**
    - [配置 Pod 使用 ConfigMap | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/configure-pod-container/configure-pod-configmap/)
- Secret ： 跟 `ConfigMap` 一样，但是 `value` 采用了 `base64` 进行了编码
    - [Secret | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/configuration/secret/)
- [k8s env、configmap、secret外部数据加载配置](https://mp.weixin.qq.com/s/wPNmLtwKXwdBEPHlmHxQOg)


在 pod 的 yaml 中可以通过以下方式注入数据

```yaml
# 方式1 env 声明 key/value
env:
- name: test-key
  value: "this is value for test-key"

# 方式2: 通过 envFrom 的方式，需要结合 configMap 或 Secret 中注入
env:
- name: test-key
  valueFrom: 
    configMapRef:
      name : <configMap-resource-name>
      key : <The key from configMap.data> # 批量全部导入，则删除 `key` 即可
- name: test-key2
  valueFrom: 
    secretKeyRef:
      name : <Secret-resource-name>
      key : <The key from Secret.data> # 批量全部导入，则删除 `key` 即可
```

区别 | env | envFrom
-----|-----|--------
存储方式 | `name-Value` 设置单个值 | `name-ValueFrom(name-key)` 数组形式设置
批量导入 | 不支持 | 支持，不写 `key` 即可
优先级 | 最高 | `env` > `envFrom`
重复设置 | 最后一个设置的值生效 | 同 `env`
使用变量 | $name 即可，$$name 会当做 $name 处理 | 同 `env`


查看相关变量详细信息可以在 - [Kubernetes |API Overview](https://kubernetes.io/docs/reference/using-api/) > [Kubernetes API Reference Docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/) 中查询


1. `ConfigMap`、`Secrets` 不管是通过 `env`、还是 `volume` 方式，都是在 `Pod` 中容器启动的时候注入到容器内部的，后续 `ConfigMap/Secrets` 改变容器内部是不会更新的


------

水平自动扩容和缩容 HPA


场景：replicaset 设置了 1， minreplicaset 设置了 2 ，maxreplicaset 设置了 8。启动时副本集是 1 个，当 HPA 标准达到扩容标准时候会逐步扩容到上限 8，但当缩容时只会缩减到 2。



- [Pod 水平自动扩缩 | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/run-application/horizontal-pod-autoscale/)
- [HorizontalPodAutoscaler 演练 | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/)
- [Kubernetes HPA 的三个误区与避坑指南_阿里巴巴中间件的博客-CSDN博客](https://blog.csdn.net/weixin_39860915/article/details/127563730)
- [kubernetes HPA - breezey - 博客园](https://www.cnblogs.com/breezey/p/11711077.html)
- [The Guide To Kubernetes HPA by Example](https://www.kubecost.com/kubernetes-autoscaling/kubernetes-hpa/#summary-20)
- [挖掘Kubernetes 弹性伸缩：利用 KEDA实现基于事件驱动的自动缩放器](https://mp.weixin.qq.com/s/Fu8kfzUhl2EyNQdxrg3uew)


------------

## K8s 安全


Networkplicy：控制 K8s 集群中 **Pod 间的流量通信**规则（K8s 的 iptables）-基于“**白名单**”方式的**四层（Ip+Port）控制网络流量**

- policyTypes
    - Ingress
    - Egress
- ingress（入口）
    - from  控制流量进入规则
- egress(出口) 
    - to 控制流量流出则规


- [网络策略 | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/services-networking/network-policies/)

------------------------

安全控制三阶段：认证 --> 授权 --> 准入控制

![Kubernetes API 访问控制](https://d33wubrfki0l68.cloudfront.net/d9ac747fa78f56cb303a0cb26ad8abf78e387caf/886b3/zh-cn/docs/images/access-control-overview.svg)

- 认证（Authentication）方式：（查看用户身份是否合法）
    - Kubeconfig 基于 https ca 证书认证（K8s 采用 RestAPI 方式进行通信）
    - Token 用来识别用户（dashboard采用的就是这种方式）
- 授权（Authorization）模式：（检查用户权限）
    - AlwaysDeny : 拒绝所有请求，一般用于测试
    - AlwaysAllow
    - ABAC - `Attribute-Based Access Control`，基于属性的访问控制（现在淘汰了）
    - Webhook
    - RBAC - `Role-Based Access Control` 基于角色的访问控制（1.5 版本引入，现行版本默认标准，主流的一种方式）
- 准入控制：（对 RestAPI 请求进行校验、以及默认填充请求参数 `-v=9` 参数）

```sh
kubectl get node -o wide # 查看 master 节点的 IP，SSH 上 master 机器，然后执行下列操作

# 查看 master 节点上文件，查找集群授权模式
cat /etc/kubernets/mainfests/kube-apiserver.yaml | grep authorization-mode

# /etc/kubernets/mainfests/kube-apiserver.yaml 文件不一定存在
[dev@node-master-11 ~]$ ps -aux | grep apiserver | grep -- '--authorization-mode'
root      3274 15.1 26.7 2399028 2179540 ?     Ssl  Jul12 11328:29 /opt/kube/bin/kube-apiserver --advertise-address=10.4.129.11 --allow-privileged=true --anonymous-auth=false --authorization-mode=Node,RBAC --bind-address=10.4.129.11 --client-ca-file=/etc/kubernetes/ssl/ca.pem --endpoint-reconciler-type=lease --etcd-cafile=/etc/kubernetes/ssl/ca.pem --etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem --etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem --etcd-servers=https://10.4.129.11:2379,https://10.4.129.12:2379,https://10.4.129.13:2379 --kubelet-certificate-authority=/etc/kubernetes/ssl/ca.pem --kubelet-client-certificate=/etc/kubernetes/ssl/admin.pem --kubelet-client-key=/etc/kubernetes/ssl/admin-key.pem --kubelet-https=true --service-account-key-file=/etc/kubernetes/ssl/ca.pem --service-cluster-ip-range=10.4.140.0/22 --service-node-port-range=20000-40000 --tls-cert-file=/etc/kubernetes/ssl/kubernetes.pem --tls-private-key-file=/etc/kubernetes/ssl/kubernetes-key.pem --requestheader-client-ca-file=/etc/kubernetes/ssl/ca.pem --requestheader-allowed-names= --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --proxy-client-cert-file=/etc/kubernetes/ssl/aggregator-proxy.pem --proxy-client-key-file=/etc/kubernetes/ssl/aggregator-proxy-key.pem --enable-aggregator-routing=true --v=2 --logtostderr=false --log-dir=/var/log/kubernetes --event-ttl 24h0m0s


# 查看当前 K8s 可以启用的准入控制器
./kube-apiserver -h | grep -- '   --enable-admission-plugins'

# 查看当前 K8s 启动的准入控制器
```

![K8s RBAC Access Control](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/k8s-rbac-access-control.png)


- [Kubernetes API 访问控制 | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/security/controlling-access/)
- [Kubernetes: Authorization Part1-Authorization Modes Overview | by Claire Lee | Medium](https://yuminlee2.medium.com/kubernetes-authorization-part1-authorization-modes-overview-18538759e2d5)
- [API 访问控制 | Kubernetes](https://kubernetes.io/zh-cn/docs/reference/access-authn-authz/)


--------

## K8s 网络（了解）

> K8s 的网络比较稳定，一旦设置好之后基本不会更改。但又比较重要，因此了解即可。

目前容器的网络模型主要有两个：
- CNM（Container Network Model），Docker 公司剔除
- CNI（Container Network Interface），CoreOS 公司提出，K8s 使用的便是该接口模块：本身不提供网络服务，只是定义了容器网络进行操作和配置的“规范”，本身的实现由CNI插件来完成（如：Calico、Flannel、Terway、WeaveNet、Contiv）。仅关注
    - 创建容器时分配网络资源
    - 销毁容器时删除网络资源



- `Pod` 的网络创建过程是怎么样的？
- `SVC` 的网络通信过程是如何的？（ClusterIP、NodePort、LoadeBalancer）
- [k8s网络之Calico网络 - 金色旭光 - 博客园](https://www.cnblogs.com/goldsunshine/p/10701242.html)
- [K8s为什么需要calico? calico 原理深入理解.-阿里云开发者社区](https://developer.aliyun.com/article/1273995)
- [05 | 常说的四层和七层到底是什么？五层、六层哪去了？ | NOTE-BOOK2](https://zq99299.github.io/note-book2/http-protocol/02/05.html#tcp-ip-%E5%8D%8F%E8%AE%AE%E6%A0%88%E7%9A%84%E5%B7%A5%E4%BD%9C%E6%96%B9%E5%BC%8F)
- [网络知识梳理--OSI七层网络与TCP/IP五层网络架构及二层/三层网络 - 散尽浮华 - 博客园](https://www.cnblogs.com/kevingrace/p/5909719.html)
- [Kubernetes教程(三)---纯三层网络方案 -](https://www.lixueduan.com/posts/kubernetes/03-pure-layer-3-network/)
- [Calico - Kubernetes指南](https://kubernetes.feisky.xyz/extension/network/calico)
- [【Kubernetes】 Calico 网络插件详解 – Ganfeng 的部落阁](https://blog.thexqf.top/posts/cloudnative/k8s/cni-calico/)
- [非 Overlay 扁平网络 Calico | 云原生资料库](https://lib.jimmysong.io/kubernetes-handbook/networking/calico/)
- [calico cni 插件配置详解](https://xujiyou.work/%E4%BA%91%E5%8E%9F%E7%94%9F/Calico/calico-cni%E6%8F%92%E4%BB%B6%E9%85%8D%E7%BD%AE%E8%AF%A6%E8%A7%A3.html)  
- [追踪 Kubernetes 中的网络流量](https://atbug.com/tracing-path-of-kubernetes-network-packets/)
- [打通到kubernetes集群的网络 - jeremy的技术点滴](https://jeremyxu2010.github.io/2019/03/%E6%89%93%E9%80%9A%E5%88%B0kubernetes%E9%9B%86%E7%BE%A4%E7%9A%84%E7%BD%91%E7%BB%9C/)
- [利用 VXLAN 打通多集群网络 | 云原生社区（中国）](https://cloudnative.to/blog/vxlan-calico-l2-network/)

SVC默认和虚机是不可以通讯的，coredns的覆盖范围只能在kubernetes集群，在公有云上，默认做了打通。如上铭哥这部分的数据 应该是做了虚机和K8S集群网络的打通。
2种验证方式，要么kubectl run起来一个busybox去做测试（走K8S集群网络），要么通过nodePort进行服务的暴露


` kubectl get node -owide | awk -F" " '{printf "%26-s\t%s\n", $1, $6}' ` 是为了看你虚拟机的IP，虚拟机是10.0.0.xx 这个网段，而你 K8s 集群的 IP 网段是由 K8s 内部的 CoreDNS 组建的一个集群局域网（相当于你在虚拟机里面又“虚拟了一个集群”，这里可明白？）。

1、公有云上一般会自动的帮我们将“宿主机”和“虚拟集群”两者打通，因此你可以直接 curl 访问通

2、铭哥的视频里，应该是自己手动的处理了“打通宿主机和集群”这一步，因此视频里面也可以直接 curl 访问通

但是你没有做这个处理，所以你访问不通。此处你的这3个node，你可以理解为宿主机，而 K8s 集群可以理解为虚拟机，如果你要访问集群内部的网络，有两个方式：

1、进到集群内：通过一个集群内的 pod 或 容器，自然就进到了 K8s 集群内（因此：不是说你在 node 节点的机器上，你就在集群内了，这是两个概念）

2、你自己通过配置路由的方式，打通 node 和 K8s 集群的访问（这个你可以自己去百度一下）

3、如果你单纯是想看一下效果，那么可以考虑将 clusterIP 的方式改为 nodeport ，这样集群就可以通过暴露的节点IP进行访问

-------

### K8s 中的网络

- 网络组件（如Cilium, Calico, Flannel）主要关心底层网络，包括IP分配和Pod间通信，主要负责集群内部通信，包括Pod-to-Pod和Service-to-Pod的网络
- Service 是K8s 中用于抽象一组Pod并提供稳定访问方式的对象。它处理Pod的自动注册与发现和负载均衡

**网络组件（Cilium, Calico, Flannel）负责实现这些 Service 对象背后的底层网络路由和策略：Service定义了如何访问Pod，而网络组件实现了这种访问的底层机制。**


- 网关插件（如Istio Gateway, Kong, Ambassador）主要负责集群外部到内部的通信，包括路由、负载均衡和API管理
- Ingress 负责管理集群外部到内部服务的HTTP/S路由，它是K8s原生的路由解决方案，功能比较简单：路由、重定向、基础负载均衡

网关插件（如Istio Gateway, Kong, Ambassador）会更为复杂和全面，支持多协议（HTTP, gRPC, TCP等），除了 Ingress 的基本功能还有更多高级的功能，如：API管理、安全认证、限流、熔断。

**网关插件不完全是 Ingress，它们通常提供比原生Ingress 更多功能，可以创建自己版本的 Ingress 资源或使用 CRDs（自定义资源定义）来扩展K8s的功能。简而言之：网关插件和Ingress都处理入口流量，Ingress适合基础用途，但网关插件提供更多高级和定制功能。**

**Service 定义如何使用网络通信，而网络组件则处理实现数据包级别的通信， Ingress/网关组件则处理应用级别的通信，共同为 K8s 提供网络解决方案。**


-----------

在Service Mesh微服务架构中，我们常常会听到东西流量和南北流量两个术语。

南北流量（NORTH-SOUTH Traffic）和东西流量（EAST-WEST Traffic）是数据中心环境中的网络流量模式。下面我们通过一个例子来理解这两个术语。

假设我们尝试通过浏览器访问某些Web应用。Web应用部署在位于某个数据中心的应用服务器中。在多层体系结构中，典型的数据中心不仅包含应用服务器，还包含其他服务器，如负载均衡器、数据库等，以及路由器和交换机等网络组件。假设应用服务器是负载均衡器的前端。

当我们访问web应用时，会发生以下类型的网络流量：

客户端（位于数据中心一侧的浏览器）与负载均衡器（位于数据中心）之间的网络流量；
负载均衡器、应用服务器、数据库等之间的网络流量，它们都位于数据中心。

在这个例子中，前者即即客户端和服务器之间的流量被称为南北流量。简而言之，南北流量是server--client流量。

第二种流量即不同服务器之间的流量与数据中心或不同数据中心之间的网络流被称为东西流量。简而言之，东西流量是server-server流量。

当下，东西流量远超南北流量，尤其是在当今的大数据生态系统中，比如Hadoop生态系统（大量server驻留在数据中心中，用map reduce处理），server-server流量远大于server-client流量。

该命名来自于绘制典型network diagrams的习惯。在图表中，通常核心网络组件绘制在顶部（NORTH），客户端绘制在底部（SOUTH），而数据中心内的不同服务器水平（EAST-WEST）绘制。

![什么是南北流量、东西流量](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/what-is-NORTH-SOUTH-Traffic-and-EAST-WEST-Traffic.png)

- [弄清楚流量的南北与东西 · Issue #77 · bingoohuang/blog](https://github.com/bingoohuang/blog/issues/77#issuecomment-476029139)

----

Flannel 是一个简单的、易用的Kubernetes（K8s）网络解决方案。

解决痛点：
1. 简单性：为Pod提供跨主机网络（创建一个覆盖网络，使得不同节点上的Pods可以像在同一局域网内一样通信...Calico、Cilium也具备，这是一个网络插件所必备的功能）。
2. 易部署：无需复杂配置。

优点：
1. 简单易用：适合新手或小型集群。
2. 兼容性：与多种网络和存储解决方案兼容。
  
缺点：
1. 功能限制：缺乏高级网络策略和安全特性。
2. 性能：相对于其他方案（如Calico或Cilium）可能较低。

Flannel 主要用于简化K8s网络配置，适用于简单或初级场景。

---

Calico 是开源的网络和网络安全解决方案，用于容器、虚拟机和原生主机环境，常用于Kubernetes。

解决痛点：
1. 网络隔离：通过网络策略实现精细的安全控制。
2. 可扩展性：适用于大规模集群。
3. 性能：优化的路由和数据包处理。

优点：
1. 稳定性：广泛应用，成熟。
2. 灵活性：支持多种网络模型（如BGP）。
3. 安全性：提供强大的网络策略功能。

缺点：
1. 配置复杂：特别是在高级用例和大规模部署中。
2. 学习曲线：相对高，尤其是网络背景较弱时。

Calico 是解决K8s网络和安全需求的成熟和多功能方案。

---

Cilium 是一个开源项目，用于提供并加强Kubernetes（K8s）中的网络和网络安全。它使用扩展Berkeley包过滤器（eBPF）来实现高性能、可扩展性和安全性。

解决痛点：
1. 网络性能：通过eBPF提高数据包处理速度。
2. 精细粒度安全：能够定义基于API级别的网络策略。
3. 可观察性：提供丰富的网络监控和调试能力。

优点：
1. 高性能：eBPF提供近乎原生的网络性能。
2. 灵活性：易于集成和定制。
3. 丰富的安全特性：包括API级别的访问控制。

缺点：
1. 复杂性：eBPF和Cilium的学习曲线可能较高。
2. 资源消耗：高级功能可能需要更多的系统资源。

适用于需要高性能和高级网络安全策略的K8s环境。

-----------

选型因素：

1. 复杂性：
   - Flannel：最简单。
   - Calico：中等。
   - Cilium：最复杂。

2. 功能需求：
   - Flannel：基础网络。
   - Calico：网络+一些安全策略。
   - Cilium：网络+高级安全+可观察性。

3. 性能：
   - Flannel：一般。
   - Calico：好。
   - Cilium：最佳（基于eBPF）。

4. 安全：
   - Flannel：最少安全特性。
   - Calico：中等安全特性。
   - Cilium：最多安全特性。

5. 可观察性：
   - Flannel：低。
   - Calico：中。
   - Cilium：高。

6. 社区支持：
   - Flannel：一般。
   - Calico：强。
   - Cilium：增长快。

根据你的需求（性能、安全、复杂性等）来选择最适合的。简单场景可选Flannel，复杂需求可考虑Calico或Cilium。

------

- [Kubernetes网络 — Cloud Atlas 0.1 文档](https://cloud-atlas.readthedocs.io/zh_CN/latest/kubernetes/network/index.html)
- [扁平网络 Flannel · Kubernetes 中文指南——云原生应用架构实战手册](https://jimmysong.io/kubernetes-handbook/concepts/flannel.html)
- [非 Overlay 扁平网络 Calico · Kubernetes 中文指南——云原生应用架构实战手册](https://jimmysong.io/kubernetes-handbook/concepts/calico.html)
- [基于 eBPF 的网络 Cilium · Kubernetes 中文指南——云原生应用架构实战手册](https://jimmysong.io/kubernetes-handbook/concepts/cilium.html)
- [kubernetes学习记录（4）——创建kubernetes覆盖网络-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1008781?areaId=106001)
- [Kubernetes网络插件详解 - Flannel篇-开源基础软件社区-51CTO.COM](https://ost.51cto.com/posts/15847)
- [Kubernetes容器网络及Flannel插件详解-开源基础软件社区-51CTO.COM](https://ost.51cto.com/posts/15845)
- [Kubernetes网络插件详解 - Calico 篇 - 概述-开源基础软件社区-51CTO.COM](https://ost.51cto.com/posts/15848)
- [Cilium 网络概述 | Koenli's Blog](https://www.koenli.com/fcdddb4a.html)
- [Kubernetes 网络模式之 Cilium eBPF | Infvie Envoy](https://www.infvie.com/ops-notes/kubernetes-network-cilium-ebpf.html)
- [k8s系列14-calico开启eBPF - TinyChen's Studio - 互联网技术学习工作经验分享](https://tinychen.com/20230117-k8s-14-calico-enable-ebpf/)
- [介绍 - Cilium学习笔记](https://skyao.io/learning-cilium/introduction/)
- [最Cool Kubernetes网络方案Cilium入门](https://cilium.io/blog/2020/05/04/guest-blog-kubernetes-cilium/)
- [Kubernetes 网络学习之 Cilium 与 eBPF](https://atbug.com/learn-cilium-and-ebpf/)
- [【云原生利器之Cilium】什么是Cilium_西京刀客的博客-CSDN博客](https://blog.csdn.net/inthat/article/details/122435233)
- [什么是 Calico - DaoCloud Enterprise](https://docs.daocloud.io/network/modules/calico/what/)
- [什么是 Cilium - DaoCloud Enterprise](https://docs.daocloud.io/network/modules/cilium/what/)
- [Cilium 网络概述 | Koenli's Blog](https://www.koenli.com/fcdddb4a.html)
- [云原生时代的中外 API 网关之争](https://2d2d.io/s1/kong-vs-apisix/)
- [保姆级教程，从概念到实践帮你快速上手 Apache APISIX Ingress | 支流科技](https://www.apiseven.com/blog/apisix-ingress-details)
- [全新一代API网关，带可视化管理，文档贼友好！ - 知乎](https://zhuanlan.zhihu.com/p/387334540)
- [目前B站唯一把Gateway网关讲透的视频教程！一天即可掌握Gateway！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1hd4y1q71b/)
- [B站讲的最好的云原生API网关 Apache APISIX实战教程全集（2023最新版）_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1y14y1N7fK/)
- [Kong入门与实战教程_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1iS4y1p76t/?vd_source=53b4bc277159163c329436ad5004e713)
- [API网关KONG与APISIX现状对比 – 智汇云技术社区](https://zyun.360.cn/blog/?p=2454)

---------

## 访问集群的各种方式

- [访问集群中的应用程序 | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/access-application-cluster/)
- [kubectl port-forward 踩坑记录_嗷大猫...的博客-CSDN博客](https://blog.csdn.net/aodamao/article/details/117292308)

## K8s 调度策略

调度：将 Pod 指派到 Kubernetes 集群中的特定节点

- [Kubernetes 调度器 | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/scheduling-eviction/kube-scheduler/)
- [调度器：Kubernetes 文档 > 参考 > 组件工具 > kube-scheduler](https://kubernetes.io/zh-cn/docs/reference/command-line-tools-reference/kube-scheduler/)
- [调度 | Kubernetes](https://kubernetes.io/zh-cn/docs/reference/scheduling/)

-----

节点选择器：通过给 node 打标签，给 pod 增加 `nodeSelector` 字段匹配节点标签，使得集群可以为 `Pod` “**优先选择**”节点进行指派。

- [节点选择器-NodeSelector ：将 Pod 分配给节点 | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/configure-pod-container/assign-pods-nodes/)

优先级：`nodeName` > `nodeSelector`


------

亲和性（affinity）- 白名单模式/反亲和性（anti-affinity）-黑名单模式:

- 亲和性可以实现就近部署，增强网络能力实现通信上的就近路由，减少网络的损耗。
    - 节点亲和性：可以根据节点上的标签来约束 Pod 可以调度到哪些节点上（节点选择器只是基于简单的标签匹配，而节点亲和性支持更为复杂的操作）
    - Pod 亲和性：让两个 Pod 尽可能的调度到同一个节点上
- 反亲和性主要是出于高可用特性考虑，尽量分散实例，某个节点故障的时候，对应用的影响只是 N 分之一或者只是一个实例。
 

！！！场景：当一个 `pod` 的亲和性和反亲和性互斥时，以反亲和优先级更高。

- [用节点亲和性把 Pod 分配到节点 | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/#schedule-a-Pod-using-preferred-node-affinity)
- [将 Pod 指派给节点 | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity)
- [[知识讲解篇-153] k8s 中的亲和性和反亲和性 - 知乎](https://zhuanlan.zhihu.com/p/405150555)
- [Kubernetes 亲和性调度 · 从 Docker 到 Kubernetes 进阶手册](https://www.qikqiak.com/k8s-book/docs/51.Kubernetes%E4%BA%B2%E5%92%8C%E6%80%A7%E8%B0%83%E5%BA%A6.html)
- [重新理解 kubernetes 亲和性调度-阳明的博客](https://www.qikqiak.com/post/kubernetes-affinity-scheduler/)


节点选择器和节点亲和性：都是将 pod 根据规则调度到符合规则的节点上。两者的区别是：选择器更多针对于单个节点做一些特殊情况调度，而 节点亲和性 更注重匹配“一批规则”的场景。

------

节点的污点（Taint）、Pod 的容忍度（Toleration）

> 可以将“污点”理解为节点的“反向选择器”

- 节点污点：使得节点能够排斥一类特定的 `Pod`
- Pod的容忍度：“允许”（但不保证）调度器将 Pod 自身调度到带有对应污点的节点



- `NoSchedule`：只有拥有和这个污点相匹配的容忍度的 `Pod` 才能够被分配到这个节点（！！！已经在运行中的 Pod 不受影响）
- `PreferNoSchedule`： 尽量避免将 `Pod` 调度到其不能容忍污点的节点上， 但如果实在没有节点可调度的情况可以调度到该节点
- `NoExecute`：只有拥有和这个污点相匹配的容忍度的 `Pod` 才能够被分配到这个节点，已经在运行的 Pod 如果不匹配会被驱逐
    - `tolerationSeconds` 设置驱逐延缓执行的时间（单位秒）

**`Kubenetes` 中的 `daemonsets` 资源默认情况下是容忍所有污点的，即使该节点设置了污点为 `NoExecute`！**


- [ ] [[知识讲解篇-154] k8s 的污点（Taint）和容忍度（Toleration） - 知乎](https://zhuanlan.zhihu.com/p/405348246)
- [ ] [污点和容忍度 | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/scheduling-eviction/taint-and-toleration/)
- [ ] [Kubernetes 文档 > 概念 > 调度、抢占和驱逐 > 节点压力驱逐](https://kubernetes.io/zh-cn/docs/concepts/scheduling-eviction/node-pressure-eviction/)
- [ ] [kubernetes：驱逐node上所有pod](https://blog.csdn.net/textdemo123/article/details/103733328)
- [ ] [图文轻松说透 K8S Pod 各种驱逐场景](https://mdnice.com/writing/021f4593dbd6463c873dc96a95de36cc)



## K8s 存储

- 卷：
    - configMap/Secret ： 总是以 `readOnly` 的模式挂载，容器以 `subPath` 卷挂载方式使用 `ConfigMap/Secret` 时，将无法接收 `ConfigMap/Secret` 的更新
- 静态持久卷：PV（PersitentVolume）、PVC（PersitentVolumeCliaim）、StorageClass
    - [存储 | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/storage/)
    - [Storage Classes | Kubernetes](https://kubernetes.io/docs/concepts/storage/storage-classes/)
    - 动态存储卷对象：Provisioner
- CSI（Container Storage Interface）
    - NFS
    - Ceph 
    - [分布式文件系统FastDFS入门与实战_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Df4y1o72u/)
    - [分布式文件系统MinIO入门到实战_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1aY4y1n7Vj/)



- 本地存储：依赖宿主机的磁盘作为 pv，延迟低，性能高；与节点强绑定不能分布式存储（`Pod`通过节点亲和性同的 `node-name` 方式进行强依赖），需要考虑节点异常时数据持久性策略，调度限制
- NFS 存储：简单稳定，本地开发环境或测试环境或简单的生产环境中使用；`NFS`存在单点故障风险，不方便扩容，性能一般（延迟高）
- Ceph 集群存储：分布式文件存储，


- [Local 本地存储 - K8S训练营](https://www.qikqiak.com/k8strain/storage/local/)
- [Ceph 存储 - K8S训练营](https://www.qikqiak.com/k8strain/storage/ceph/)
- [Dynamic Volume Provisioning | Kubernetes](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/)
- [Kubernetes 存储设计 | 凤凰架构](http://icyfenix.cn/immutable-infrastructure/storage/storage-evolution.html)
- [K8S NFS Provisioner 已经停止维护,赶紧将它替换掉！](https://mp.weixin.qq.com/s/oLFWDcFkuo4bsmN2xrIsgA)
- [史上最全之K8s使用nfs作为存储卷的五种方式](https://mp.weixin.qq.com/s/CR1tZ9D01bAy8tcsWPTsvw)
- [实战：用“廉价”的NFS作为K8S后端存储](https://mp.weixin.qq.com/s/f8eCJNxztMFc3uQ_YJzwgg)
- [NFS (Kubernetes) 高可用方案（NFS+keepalived+Sersync) | hwholiday](https://hwholiday.com/2021/nsf/)
- https://github.com/kubernetes-retired/external-storage/tree/master/nfs-client
- [Ceph Tags | 飞行的蜗牛](https://www.r9it.com/tags/Ceph/)
- [centos7搭建ceph集群-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1927693)



## API 资源对象：CustomResourceDefinition(CRD)

- CRD：通过 K8s API 创建和管理自定义资源的类型。（要使用该资源类型【类】，还需要定义并创建具体的自定义资源实例【这个具体的 `Custom Resource`，我们可以称呼 `CR` ，类似对象和类的关系】，创建实例后想要进一步的使用该实例的数据还需要定义  Controller）
- Operator：由 CoreOS 公司开发，是一种自定义控制器（Custom Controller），扩展了 K8s API 的功能，用于管理特定应用或服务在 K8s 集群中的生命周期。（可以简单的理解为：Operator = CRD + Controller）
    - 核心思想：将应用程序的专业只是嵌入到自定义控制器中，以便控制器能够理解和管理特定类型的应用程序
    - 根据 CRD 的规范和状态，自定执行与应用程序相关的任务
    - 响应集群时间，自动修复故障和应用程序状态的健康性


- [使用 CustomResourceDefinition 扩展 Kubernetes API | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/)
- [定制资源 | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions)
- [从零到一开发 Operator_Docker_的博客-CSDN博客](https://blog.csdn.net/M2l0ZgSsVc7r69eFdTj/article/details/122206891)
- [Operator - Kubernetes 进阶训练营(第2期)](https://www.qikqiak.com/k8strain2/operator/operator/)
- [Operator 开放框架：kubebuilder - The Kubebuilder Book](https://cloudnative.to/kubebuilder/introduction.html)
- [3. KubeBuilder 简明教程 - Mohuishou](https://lailin.xyz/post/operator-03-kubebuilder-tutorial.html)
- [Operator SDK | 云原生资料库](https://lib.jimmysong.io/kubernetes-handbook/develop/operator-sdk/)


## K8s Operator

- [Kubernetes 自动化诊断工具：k8sgpt-operator](https://atbug.com/automatic-diagnosis-of-kubernetes-clusters-using-k8sgpt-operator/)
- [K8sGPT: 一款使用 ChatGPT 快速诊断 Kubernetes 故障的效率神器_运维之美的博客-CSDN博客](https://blog.csdn.net/easylife206/article/details/130939348)


## Helm

K8s 的包管理器 + 模板引擎（类似：Java的maven、PHP的composer，但功能更加丰富一些），基本简单的阅读一下文档就能掌握。

- https://helm.sh/zh/
- [Helm | Docs 文档](https://helm.sh/zh/docs/)
- [Harbor 入门指南 - 牧之丨 - 博客园](https://www.cnblogs.com/exmyth/p/17071034.html)   
- [Kubernetes Harbor · abcdocker运维博客 | Kubernetes集群实战文档](https://k.i4t.com/kubernetes_harbor.html)
- [Helm 命名模板的使用-阳明的博客|Kubernetes|Istio|Prometheus|Python|Golang|云原生](https://www.qikqiak.com/post/helm-name-template-usage/)


包管理命令：- [Helm | Helm 命令行](https://helm.sh/zh/docs/helm/helm/)


模板引擎：写法和 `PHP Laravel Framework` 的 `Blade` 模板差不多都是用 `{{ xxx }}` - [Helm | Chart 模板指南](https://helm.sh/zh/docs/chart_template_guide/getting_started/)。功能相对比较简略但目前已经足够。

- with 限定作用域，不能直接引用父类作用域的变量
- range 遍历：一维数组遍历、二维数组要怎么遍历、对象要怎么遍历...这些要知道
- 命名模板：类似于抽离公共函数文件，Helm 中将这类整个项目公共的模板抽离到 `templates/_helpers.tpl` 文件里
- include 包含的用法：`templates/_helpers.tpl` 中将公共模板通过 `{{- define "xxx" -}}` 拆分为多个小模块，然后在其它 YAML 模板中可以通过 `{{ include "xxx" }}` 引入包含这个模块

-------------------


## K8s 集群监控-Prometheus

- `kubectl top`、`MetricsServer` 方式，`kubectl logs`、`kubectl get events`
    - `kubectl top` 不支持 `-w|--watch` 参数，可以通过 `watch -n 1 'kubectl top node|pod [<nodeName>|<PodName>]'` 来实现持续观察
    - [`watch linux` 命令 在线中文手册](http://linux.51yip.com/search/watch)
- [kubectl top pod输出的cpu、内存使用率是怎么计算的_panbuhei的博客-CSDN博客](https://blog.csdn.net/qq_43584691/article/details/130763380)
- [从kubectl top看K8S监控原理 - container-monitor](https://yasongxu.gitbook.io/container-monitor/yi-.-kai-yuan-fang-an/di-2-zhang-prometheus/kubectl-top)
- [第2章 Prometheus - container-monitor](https://yasongxu.gitbook.io/container-monitor/yi-.-kai-yuan-fang-an/di-2-zhang-prometheus)
- [Introduction - prometheus-book](https://yunlzheng.gitbook.io/prometheus-book/#parti-prometheus-ji-chu)
- [Prometheus 中文文档 - prometheus 中文文档](https://hulining.gitbook.io/prometheus/)
- [Prometheus - Monitoring system & time series database](https://prometheus.io/)
- [用Prometheus监控K8S](https://dbaplus.cn/news-134-3247-1.html)
- [GitHub - prometheus/prometheus: The Prometheus monitoring system and time series database.](https://github.com/prometheus/prometheus)
- [Prometheus - K8S训练营](https://www.qikqiak.com/k8strain/monitor/prometheus/)
- [监控 Kubernetes 集群节点](https://www.qikqiak.com/post/promethues-monitor-k8s-nodes/)
- [𝑬𝒏𝒅𝒘𝒂𝒔 -- Grafana入门教程-从零上手](https://endwas.cn/blog/97)
- [微服务监控 - Grafana 使用教程 | MakeOptim](https://makeoptim.com/service-mesh/prometheus-grafana/)
- https://mp.weixin.qq.com/mp/appmsgalbum?action=getalbum&__biz=MzUxNTg5NTQ0NA==&scene=1&album_id=3052572658971705345&count=3&uin=&key=&devicetype=Windows+10+x64&version=63090621&lang=zh_CN&ascene=0
- [kube-state-metrics - Prometheus 入门到实战](https://p8s.io/docs/k8s/kube-state-metrics/)
- [优点知识文档库|Prometheus 从入门到实战](https://docs.youdianzhishi.com/prometheus/)
- [前言 · Prometheus 实战](https://songjiayang.gitbooks.io/prometheus/content/)





- `Prometheus`（普罗米修斯）最初是一个在 `SoundCloud` 上构建的监控系统。2012年开源，2016加入CNCF，是K8s之后的第二个托管项目
- `Prometheus` 是一个开源、基于时序的数据库，基本原理：**通过 HTTP 协议周期性的抓取被监控组件的状态，任意组件只要提供对应的 HTTP 接口就可以接入。不需要任何的 SDK 或者其他的集成过程（无侵入性）。**非常适合做虚拟化环境监控系统，比如：VM、Docker、Kubernetes 这类接口操作的系统
    - 被监控组件暴露出的 HTTP 接口被叫做 `exporter` - [Exporters and integrations | Prometheus](https://prometheus.io/docs/instrumenting/exporters/)

Prometheus 特点：

-  多维数据模型：由度量名称和 Key=>Value 标识的时间序列数据
- `PromQL（Prometheus Query Language）`：一种灵活的查询语言，可以利用多维数据完成复杂的查询（类似 SQL 之余 数据库）
- 不依赖分布式存储，单个服务器节点可直接工作
-  基于 HTTP 的 PULL 方式采集时间序列数据
-  推送时间序列数据通过 PushGateway 组件支持
-  通过服务发现或静态配置发现密保
-  多种图形模式以及仪表盘支持（Grafana)
-  适用于以及其为中心的监控以及高度动态面向服务架构的监控

为什么选择 Promethues ？

1. 开源: 无需高额许可费，易于试验和部署。
2. 社群支持: 大量插件和集成，持续更新。
3. 高度可配置: 查询、警报和仪表板可定制。
4. 数据模型: 多维度标签，灵活的查询。
5. 可扩展: 支持水平和垂直扩展。
6. 自服务: 开发人员可自行添加和修改监控项。
7. 适应性: 与Kubernetes等云原生工具有良好集成。
8. 性能: 高效的存储和查询引擎。

这些特性使得Prometheus适合云原生环境的监控。

- [Prometheus · Kubernetes 中文指南——云原生应用架构实战手册](https://jimmysong.io/kubernetes-handbook/practice/prometheus.html)
![](https://jimmysong.io/kubernetes-handbook/images/006tNbRwly1fwcgsn11fej311j0mjadw.jpg)


1. Promethues 能干嘛？
2. 时序数据库的优缺点？

---------

2、在 K8s 中部署 Prometheus

3、Prometheus 的 Exporter 介绍

4、PromQL 查询监控指标

5、Prometheus 自动发现机制
    - K8s 自身的服务发现：实现公司的 PHP-FPM 镜像监控
    - 基于 Consul 的服务注册与发现：监控 Nginx 操作

6、kube-state-metrics 和 metrics-server
    - 抓取什么数据？控制器
    - [Kubernetes监控手册10-使用 kube-state-metrics 监控 Kubernetes 对象_SRETalk的技术博客_51CTO博客](https://blog.51cto.com/ulricqin/6004594)

7、Prometheus 监控 K8s 集群
    - 监控 node
    - 监控 api-server、kubelet
    - 监控容器、svc

8、Grafana 实现监控指标可视化

- 官方文档：https://grafana.com/docs/grafana/latest/
- github 地址：https://github.com/grafana/grafana
- [官方Demo : Grafana 体验地址](https://play.grafana.org/)
- [Dashboards | Grafana Labs](https://grafana.com/grafana/dashboards/)
    - Go语言编写、开源、跨平台的可视化度量分析应用程序
    - 经常被用左基础设施的时间序列数据和应用程序分析的可视化
    - 支持多数据源：Graphite，InfluxDB，OpenTSDB，Prometheus，Elasticsearch，CloudWatch和KairosDB
    - 可视化过程：通过插件获取到服务器性能并存储到数据库中，然后使用Grafana 连接数据库形成可视化的图表。
    - 官方提供了丰富了 Dashboard 支持，可以直接导入使用
- Helm 部署 Grafana：
    - 通过端口转发 `port-forward` 方式暂时访问 - [端口转发 · Kubernetes指南](https://feisky.gitbooks.io/kubernetes/content/practice/portforward.html)
    - [源码解析 kubectl port-forward 工作原理](https://atbug.com/how-kubectl-port-forward-works/)
    - `helm status grafana` 可以查看安装后的获取密码信息


- [Grafana | 优点知识文档库](https://docs.youdianzhishi.com/k8s/monitor/grafana/)
- [Grafana 入门教程](https://blog.csdn.net/freeking101/article/details/128585245)
- [Grafana | Prometheus](https://prometheus.io/docs/visualization/grafana/)
- [Prometheus 入门教程（二）：Prometheus + Grafana实现可视化、告警 - 陈树义的博客](https://shuyi.tech/archives/02-grafana-quick-start)
- [Prometheus 入门教程（三）：Grafana 图表配置快速入门 - 陈树义的博客](https://shuyi.tech/archives/03-grafana-chart-quick-start)
- [第5章 数据与可视化 - prometheus-book](https://yunlzheng.gitbook.io/prometheus-book/part-ii-prometheus-jin-jie/grafana)
- [Grafana全网最佳实战视频教程合集_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1PV411k7Rz/?vd_source=53b4bc277159163c329436ad5004e713)
    - 文档：- [tghfly/grafana-manual: Grafana最佳实践教程](https://github.com/tghfly/grafana-manual) 

9、AlertManager-Promethues的一个告警组件

- 告警规则：[Awesome Prometheus alerts | Collection of alerting rules](https://samber.github.io/awesome-prometheus-alerts/)
- 告警媒介设置：邮件、微信、钉钉、飞书...
    - [企业微信报警：AlertManager实现监控告警 - Mr.Ye Blog](https://system51.github.io/2021/07/12/Alertmanager/#AlertManager%E5%AE%9E%E7%8E%B0%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%8A%A5%E8%AD%A6)
    - [AlertManager 微信告警配置 | abcdocker运维博客](https://i4t.com/5260.html)
- 告警分组：将相同类别的告警进行归类，合并为一条告警通知
    - `group_by: ['alertname', '<labels  Key>']`
    - `group_wait` 分组信息汇集的等待时间
- 告警抑制：当出现其它告警的时候，一只当前告警的通知，可以有效的防止告警风暴（即：当A出现告警时，抑制与之关联的B告警）
    - `inhibit_rules.source_match`（定义A的条件）、`inhibit_rules.target_match`（匹配B）、`inhibit_rules.equal`（定义A/B关联关系）
    - [Prometheus 之 Alertmanager告警抑制与静默_51CTO博客_alertmanager告警抑制](https://blog.51cto.com/u_12965094/2690336)
    - [一文彻底搞懂 Alertmanager 的告警抑制与静默_云计算-Security的博客-CSDN博客](https://blog.csdn.net/IT_ZRS/article/details/129932353)
    - [Prometheus+alertmanager实现分组告警 - 简书](https://www.jianshu.com/p/5f72052b857a)
- 告警静默：设置某个规则在某段时间内不发告警
    - [屏蔽告警通知 - prometheus-book](https://yunlzheng.gitbook.io/prometheus-book/parti-prometheus-ji-chu/alert/alert-manager-inhibit)
    - [屏蔽告警通知 - prometheus-book](https://yunlzheng.gitbook.io/prometheus-book/parti-prometheus-ji-chu/alert/alert-manager-inhibit)
    - [prometheus告警静默 - 郭大侠1 - 博客园](https://www.cnblogs.com/gered/p/13648149.html)
    - [Kubernetes监控专栏 - 快猫星云](https://flashcat.cloud/categories/kubernetes%E7%9B%91%E6%8E%A7%E4%B8%93%E6%A0%8F/)




-----------

## K8s 集群监控

1、资源监控

2、集群 CA 证书

- [K8S 集群中的认证、授权与 kubeconfig | Vermouth | 博客 | docker | k8s | python | go | 开发](http://www.xuyasong.com/?p=2054)
- [Kubernetes集群证书过期后，使用kubeadm重新颁发证书](https://www.cnblogs.com/zhangmingcheng/p/15980034.html)
- [Kubeadm证书过期时间调整 | CloudNative 架构](http://team.jiunile.com/blog/2018/12/k8s-kubeadm-ca-upgdate.html?utm_source=ld246.com)
- 如何续签证书？续签证书后，集群服务如何平滑重启？


3、集群版本升级

- 为什么要升级？
- 升级的过程，如何保证稳定性？注意事项：备份集群、新搭集群，分流量（测试-预发布-生产，边缘业务-主业务）
- 如何升级？
    - 先升级 master，再升级 worker
- [升级 kubeadm 集群 | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)
- [手动升级 Kubernetes 集群 · Kubernetes 中文指南——云原生应用架构实战手册](https://jimmysong.io/kubernetes-handbook/practice/manually-upgrade.html)
- [升级集群的最佳做法  |  Google Kubernetes Engine (GKE)  |  Google Cloud](https://cloud.google.com/kubernetes-engine/docs/best-practices/upgrading-clusters?hl=zh-cn)
- [定时备份etcd数据 - 人艰不拆_zmc - 博客园](https://www.cnblogs.com/zhangmingcheng/p/13892140.html)


4、节点维护（节点的上线和下线）

- [部署Kubernetes(k8s)时，为什么要关闭swap、selinux、firewalld？-CDA数据分析师官网](https://www.cda.cn/bigdata/201242.html)
- [部署Kubernetes(k8s)时，为什么要关闭swap、selinux、firewalld - 老油条666 - 博客园](https://www.cnblogs.com/shuai666/p/16994554.html)
- [如何使用三台虚拟机搭建一个kubernetes集群？](https://xie.infoq.cn/article/29cc515a6333b8e66153e68ad)



5、集群高可用

- [kubernetes集群备份与恢复 - 偷得浮生](https://zhangzhuo.ltd/articles/2022/01/09/1641718314281.html)
- [使用 Velero 备份还原 Kubernetes 集群资源 | 云原生社区（中国）](https://cloudnative.to/blog/introducing-velero/)
- [概览 | sealer](http://sealer.cool/zh/getting-started/introduction.html)
- [VIP的实现原理-赵化冰的博客 | Zhaohuabing Blog](https://www.zhaohuabing.com/post/2019-11-27-vip/)
- [使用 kube-vip 搭建高可用 Kubernetes 集群-阳明的博客](https://www.qikqiak.com/post/use-kube-vip-ha-k8s-lb/)
- [快速搭建kubernetes与kubeSphere环境（亲测有效）-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1539233)
- [记一次kubesphere生产环境证书过期问题 - 屌丝大叔的笔记 - 博客园](https://www.cnblogs.com/subendong/p/15604340.html)
- [k8s踩坑(三)、kubeadm证书/etcd证书过期处理_etcd 换证书报 etcdmain/etcd.go204 tls: failed to parse-CSDN博客](https://blog.csdn.net/ywq935/article/details/88355832?utm_source=ld246.com)
- [Kubernetes可视化界面kubesphere · GitBook](http://victorfengming.gitee.io/kubernetes/31_Kubernetes%E5%8F%AF%E8%A7%86%E5%8C%96%E7%95%8C%E9%9D%A2kubesphere/#%E6%A3%80%E6%9F%A5%E5%AE%89%E8%A3%85%E6%97%A5%E5%BF%97)
- [搭建KubeSphere+k8s环境 | Tangly Blog](https://blog.tangly1024.com/article/kuberkey-kubesphere-k8s)
- [LVS+Keepalived 实现高可用负载均衡 - Fururur - 博客园](https://www.cnblogs.com/Sinte-Beuve/p/13392747.html)
- [Haproxy/LVS负载均衡实现+keepalived实现高可用 - 简书](https://www.jianshu.com/p/4b80ce2874cd)
- [高可用架构中 LVS,Keepalived,HAProxy解析以及实战-CSDN博客](https://blog.csdn.net/u011563903/article/details/89600167)
- [用 Keepalived+HAProxy 实现高可用负载均衡的配置方法 - 运维派](http://www.yunweipai.com/40460.html)
- [Nginx、LVS、HAProxy负载均衡软件的优缺点详解 | 落井下石](http://www.hangdaowangluo.com/archives/2816)





6、集群的备份和迁移

- 混合云集群部署问题？
- Terraform - [#terraform](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=Mzg2OTYwNTM1MA==&action=getalbum&album_id=2963347337521709060&scene=173&from_msgid=2247483848&from_itemidx=1&count=3&nolastread=1#wechat_redirect)
- Argo CD

7、集群优化

## 链路监控 - Skywalking

- [7 个免费分布式跟踪工具 [2023 年更新]](https://uptrace.dev/blog/distributed-tracing-tools.html)
- [链路追踪 | 凤凰架构](http://icyfenix.cn/distribution/observability/tracing.html)
- [可视化全链路日志追踪 - 美团技术团队](https://tech.meituan.com/2022/07/21/visualized-log-tracing.html)
- [链路追踪 | RuoYi](https://doc.ruoyi.vip/ruoyi-cloud/cloud/skywalking.html#%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8)
- [字节跳动开源 Kelemetry：面向 Kubernetes 控制面的全局追踪系统](https://mp.weixin.qq.com/s/Dnz4_z50QYL_dOY8jULwXg)
- [原来10张图就可以搞懂分布式链路追踪系统原理 - 开发者头条](https://toutiao.io/posts/eaiifaf/preview)
- [全链路追踪系统_微学苑](https://www.weixueyuan.net/a/fimw2.html)
- [链路追踪系统 | 深入架构原理与落地实践](https://www.thebyte.com.cn/MicroService/tracing.html)
- [43 | 一个完整的分布式追踪系统是什么样子的？](https://time.geekbang.org/column/article/348006)
- [全链路跟踪系统(一):理论篇 - zhonghua | 钟华的博客 | zhongfox](https://zhonghua.io/2017/10/14/hunter-1/)
- [分布式链路追踪实战-完](https://learn.lianglianglee.com/%E4%B8%93%E6%A0%8F/%E5%88%86%E5%B8%83%E5%BC%8F%E9%93%BE%E8%B7%AF%E8%BF%BD%E8%B8%AA%E5%AE%9E%E6%88%98-%E5%AE%8C)


8、集群安全

一般选择公有云，安全问题可以适当注意

- [Kubernetes 加固指南 | 云原生资料库](https://lib.jimmysong.io/kubernetes-hardening-guidance/)


## 服务网格 - Istio



8、集群链路跟踪与监控


--------------

## 辅助定位

- 准备一个备份镜像：装好 Git、curl、ping、wget、tar、vim 工具，便于恢复初始环境
- [Kubernetes 必备工具：2021](https://atbug.com/translation-kuberletes-essential-tools-2021/)
- `Watch` 机制
- set grace period of 30 sec 设置 30 秒的宽限期
 

从公网下载镜像然后倒入到k8s里步骤：

使用 Docker：
1. 下载镜像: `docker pull IMAGE_NAME`
2. 保存镜像: `docker save -o IMAGE_NAME.tar IMAGE_NAME`
3. 传到K8s节点: `scp IMAGE_NAME.tar user@k8s-node:/path/`
4. 在节点上加载: `docker load -i /path/IMAGE_NAME.tar`
5. 在节点上更新镜像标签: `docker tag OLD_IMAGE_NAME NEW_IMAGE_NAME`
6. K8s部署: `kubectl apply -f xxxx.yaml`

使用 Containerd ：

- [containerd 手动导入镜像 - ZengXu's BLOG](https://www.zeng.dev/post/2020-containerd-image-import/)
- [containerd使用ctr导入镜像成功，crictl为何查询不到](https://blog.csdn.net/qq_37837432/article/details/123929774)
    - ctr是containerd自带的工具，有命名空间的概念，若是k8s相关的镜像，都默认在k8s.io这个命名空间，所以导入镜像时需要指定命令空间为k8s.io

1. 在本地拉取：`ctr image pull IMAGE_NAME`
2. 保存：`ctr images export /path/IMAGE_NAME.tar IMAGE_NAME`
3. 上传到节点：`scp IMAGE_NAME.tar user@k8s-node:/path/`
4. 在节点加载：`ctr -n k8s.io image import /path/IMAGE_NAME.tar` （因为 K8s 只会使用 `k8s.io` 这个命名空间下的镜像）
5. 标签：`ctr image tag OLD_IMAGE_NAME NEW_IMAGE_NAME`
6. 更新`deployment.yaml`：`image: NEW_IMAGE_NAME`
7. 应用：`kubectl apply -f deployment.yaml`
