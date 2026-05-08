# 通过 K8s 常用命令学习 K8s
[TOC]

1. 快速回顾 K8S 的设计架构，将知识点与 [旧笔记](http://note.youdao.com/noteshare?id=5de82d11e0f6abd1de69cca86b38e5e2&sub=7FF959D31C604A15872BBEAC6C1587C2) 形成衔接
2. 在公司服务器上将张老师发的 `K8S常用命令.pdf` 敲一次
3. [高效率运维K8s 这些常用命令你得会](https://mp.weixin.qq.com/s/vJP1U-ReaGvMiR2tmAycrA)


## K8S 回顾

### 1、 `Master-Node` 分布式架构

`K8S` 虽然不是严格的传统的主-从架构，但它确实是一种主-从设备模型（Master-Slave 架构模型），即 ：

- `Master Node`-主节点负责核心的调度、管理、运维工作节点
- `Worker Node`-工作节点则负责执行用户的程序

与传统主从模式不同的是，K8S 集群中可以存在多个 `Master Node`，且 `Worker Node` 并非隶属于某一个 `Master Node` 的。

### 2、`kubectl` 的作用是什么？

[`kubectl`](https://kubernetes.io/docs/reference/kubectl/) 是一个封装了 `Kubernetes` 集群接口的独立的命令行工具，用于与 `Kubernetes` 集群进行交互和管理，且 `kubectl` 其实并不属于 `k8s` 集群架构中的一个模块。

`kubectl` 并不需要安装在 `K8S` 集群的任何节点上，但需要确保安装 `kubectl` 的机器和 `K8S` 的集群能够进行网络互通即可，其配置默认在 `$HOME/.kube/config` YAML 文件中。

**疑问：是确保与 K8S 的 Master 互通即可？还是需要和整个集群的节点互通？**

- [Command line tool (kubectl)](https://kubernetes.io/docs/reference/kubectl/) 
- [kubectl 创建 Pod 背后到底发生了什么？](https://cloud.tencent.com/developer/article/1525887)
- [深度解读：输入 kubectl run 后，到底发生了什么？](https://blog.csdn.net/M2l0ZgSsVc7r69eFdTj/article/details/100588468)
- [What happens when I type kubectl run?](https://github.com/jamiehannaford/what-happens-when-k8s/tree/master/zh-cn)
- [kubectl主体流程](https://github.com/Kevin-fqh/learning-k8s-source-code/blob/master/kubectl/(01)%20kubectl%E4%B8%BB%E4%BD%93%E6%B5%81%E7%A8%8B.md)
- [Kubernetes Master-Node通信](http://docs.kubernetes.org.cn/306.html)
- [k8s中各组件和kube apiserver通信时的认证和鉴权](https://www.anquanke.com/post/id/274074)

默认情况下 `kubectl` 会先通过检查是否设置 `KUBERNETES_SERVICE_HOST` 和 `KUBERNETES_SERVICE_PORT` 两个环境变量，以及是否存在服务帐户令牌文件( `/var/run/secrets/kubernetes.io/serviceaccount/token`) 这三者来确定自身是否在一个 `pod` 内运行，从而来判断自身是否在集群中，如果三者都通过就会假设是在集群内部进行身份验证。

`KUBERNETES_SERVICE_HOST` 和 `KUBERNETES_SERVICE_PORT` 两个环境变量通常在 `pod` 启动时由 `Kubernetes` 自动设置，并指向 `API Server` 的地址和端口，可以通过 `kubectl -n <namespace> exec <pod-name> -- bash -c 'echo $KUBERNETES_SERVICE_HOST $KUBERNETES_SERVICE_PORT'` 打印出来。


```sh
# https://kubernetes.io/zh-cn/docs/reference/access-authn-authz/authentication/#x509-client-certs
$ echo $(yq -o=json ~/.kube/config | jq '.users[0].user."client-certificate-data"' | sed -s 's/"//g') | base64 -d | openssl x509  -noout -text

Certificate:
    Data:
        Version: 3 (0x2)
        xxxx
        Subject: C = CN, ST = HangZhou, L = XS, O = system:masters, OU = System, CN = admin
......
```

可以看到 `~/.kube/config` 这个配置隶属 `admin` 用户（在集群中隶属 `system:master` 用户组），通过 `kubectl get ClusterRoleBinding -A -owide | grep admin` 可以查看用户在集群中的角色，然后 `kubectl get ClusterRole/admin -o yaml` 可以查看角色的权限



### 3、`kubectl` 的自动补全：[kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

```sh
# 安装 kubectl

cd /tmp
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# dl.k8s.io 域名现在被重定向到了 storage.googleapis.com
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -L -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

# 赋权
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

1. 通过 `--kubeconfig=<file>` 临时强行指定配置文件
2. 通过环境变量 [`KUBECONFIG`](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#:~:text=If%20the%20KUBECONFIG%20environment%20variable,in%20the%20KUBECONFIG%20environment%20variable.) 指定配置文件 `export KUBECONFIG="config file path"`
3. `${HOME}/.kube/config` 默认配置文件（如果 kubectl 报错，一般都是查看这个文件，检查是否有问题）

可以通过 `kubectl config view` 查看完整的 `kubectl` 配置信息.

### 4、写好 `Yaml` 的一些技巧？


`--dry-run` 选项用于预览操作，不实际执行。区别如下：

- `none`: 不进行 dry-run，实际执行创建命名空间。
- `client`: 在客户端进行 dry-run，不发送请求到服务器，只检查资源定义。
- `server`: 在服务器端进行 dry-run，会进行完整的验证和模拟执行，但不实际创建资源。


- https://mp.weixin.qq.com/s/LSzRs4dc8YSl5uQstzta2w

## K8S 常用命令

其实对于命令的操作，熟悉 `K8s` 之后通过 [kubectl Cheat Sheet | Kubernetes](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) 或 [cheatsheet-kubernetes-A4](https://github.com/dennyzhang/cheatsheet-kubernetes-A4) 基本能清楚，主要的疑惑点更多是在于一些命令参数上。

多使用 `--help` 参数，耐心看一下输出的帮助文档也许就能解决问题。

### 集群相关

#### **1、`kubectl version`：查看 `kubectl` 客户端工具的版本 和 `Kubernetes` 集群的版本信息**

```json
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.1", GitCommit:"86ec240af8cbd1b60bcc4c03c20da9b98005b92e", GitTreeState:"clean", BuildDate:"2021-12-16T11:41:01Z", GoVersion:"go1.17.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"16", GitVersion:"v1.16.9", GitCommit:"a17149e1a189050796ced469dbd78d380f2ed5ef", GitTreeState:"clean", BuildDate:"2020-04-16T11:36:15Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
WARNING: version difference between client (1.23) and server (1.16) exceeds the supported minor version skew of +/-1
```

上述警告信息的意思是：客户端和服务端的 `Minor` 版本信心相差大于 `+/-1`，当差异较大时可能会导致某些功能不兼容而出现问题。为了获得最佳的兼容性和稳定性，建议使用与 `Kubertnetes` 集群版本相匹配的 `kubectl` 版本。

1. 查看 `https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG` 发布记录，找到 `CHANGELOG-1.16.md` 发现最新的是 `v1.16.15`
2. 下载 `kubectl v1.16.15` 覆盖安装即可

```sh
curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.16.15/bin/linux/amd64/kubectl"
```

执行 `kubectl version --client` 验证版本信息是否为 `v1.16.15`

--------------------------

#### **2、`kubectl cluster-info`：查看 `Kubernetes` 集群的基本信息**

显示与当前上下文关联的 Kubernetes 集群的基本信息，包括集群的 API 服务器地址、当前使用的上下文以及控制平面组件的运行状态。

```yaml
Kubernetes master is running at https://<cluster-api-server>[:<port>]
CoreDNS is running at https://<cluster-api-server>[:<port>]/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
KubeDNS is running at https://<cluster-api-server>[:<port>]/api/v1/namespaces/kube-system/services/kube-dns2:dns/proxy
kubernetes-dashboard is running at https://<cluster-api-server>[:<port>]/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy
Metrics-server is running at https://<cluster-api-server>[:<port>]/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`kubectl cluster-info dump` 命令可以打印集群的详细信息，用于故障排查、问题诊断、集群配置分析。该命令需要具备适当的权限或与集群管理员才能运行，需具有足够的权限才能访问集群的各种资源和日志文件。

执行 `kubectl cluster-info dump` 命令时，它会执行以下操作：

1. 收集集群信息：命令会从集群的 API 服务器获取各种信息，包括节点、Pod、服务、配置映射、事件等。
2. 打包信息：命令将收集到的信息打包为一个压缩文件，通常是一个 tar 归档文件。
3. 下载压缩文件：命令将生成的压缩文件下载到本地机器，通常保存在当前工作目录中。

-----------------------------------

#### **3、`kubectl api-resources -owide` 查看当前 `Kubernetes` 支持哪些资源对象**

Google 出的产品，文档是出了名的详细，我们可以通过 [Kubernetes 官方帮助文档#Concepts-概念](https://kubernetes.io/docs/concepts/) 查看对应版本的 K8s 有哪些资源对象以及各自资源对象的详细说明。当然也可以通过 `kubectl api-resources --help` 查看该命令更多的用法。

但是也可以结合通过 `kubectl explain <resource_name:pod|service|xxx>` 命令，在 `CLI` 端查看这些资源概念到底支持哪些「资源描述对象的字段」。

-----------------------

#### **4、获取集群上下文信息**

一般来说我们只有一个 `Kubernetes` 集群，集群的配置信息都是运维发过来，然后我 `copy` 到 `~/.ssh/kube/config`，因此对集群的上下文很少会关注。打算本地安装一个 `minikube` 单节点集群，同时又希望能保留公司的集群配置信息。

- `kubectl config get-contexts` 获取当前机器中配置了的 「`Kubernetes` 集群上下文」 列表
- `kubectl config current-context` 查看当前是哪个上下文环境的集群

```shell
CURRENT   NAME                    CLUSTER           AUTHINFO                NAMESPACE
*         new-k8s-cluster-admin   new-k8s-cluster   new-k8s-cluster-admin   qeeq-dev
```

- `kubectl config use-context <context-name>` 切换上下文
- `kubectl config view` 查看当前上下文的配置信息（`kubectl config view --minify` 查看配置简要信息）
- `kubectl config view --minify | grep namespace` 查看当前上下文环境的默认命名空间（如果没有设置的话，就是 `default`）

------------------

#### **5、查看集群 DNS 域名**

- 默认 `K8s` 集群的域名是 `cluster.local`
- 如果通过 `Service` 访问 `Pod`，其全域名（FQDN）则为 ：`<pod-name>.<service-name>.<namespace>.svc.<cluster-domain>`
- 直接访问 `Pod`，其全域名为：`<pod-ip>.<namespace>.pod.<cluster-domain>`（注：`<pod-ip>` 需要将 `Pod` 的 `IP` 中的 `.` 改为 `-`）


**方式1：通过查看 `pod` 的 `/etc/resolv.conf` 该文件**

`/etc/resolv.conf` 文件是 `pod` 在创建时由 `K8s` 集群自动生成创建的，因此准确性来说是最无误的。

```sh
kubectl -n qeeq-dev exec erc-car-rental-api-c68758cb4-jsbl9 -it -c erc-car-rental-api -- cat /etc/resolv.conf

nameserver 10.4.139.11
search qeeq-dev.svc.rocketos.local svc.rocketos.local rocketos.local
options ndots:5
```

可以看到当前集群的域名被修改过，现在为：`rocketos.local`.

- `nameserver`: 定义`DNS`服务器的`IP`，其实就是`kube-dns`那个`service`的`IP`。
- `search`: 定义域名的查找后缀规则，当输入域名不完整时会自动加上后缀进行匹配，查找配置越多，说明域名解析查找匹配次数越多。最多进行 8 次查询（`IPV4/IPV6` 各 4 次)才能得到正确解析结果
- `option`: 定义域名解析配置文件选项，支持多个`KV`值。例如该参数设置成`ndots:5`，说明如果访问的域名字符串内的点字符数量超过`ndots`值，则认为是完整域名，并被直接解析;如果不足`ndots`值则追加`search`段后缀再进行查询。

**方式2：通过 `svc` 查看**

通常 `Kubernetes` 会通过 `Service` 运行集群内部的 `DNS` 服务，以便集群内部其他资源可以轻松访问到它

1. 查看集群的 `DNS` 服务信息

```sh
# 查看集群内部的 DNS 信息，从结果看出此处应该是做了一个 DNS 的高可用方案
# `CoreDNS` 服务被命名为了 `kube-dns`
# `KubeDNS` 服务作为备用，命名为 `kube-dns2`
kubectl cluster-info
Kubernetes control plane is running at https://10.4.129.100:9443
CoreDNS is running at https://10.4.129.100:9443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
KubeDNS is running at https://10.4.129.100:9443/api/v1/namespaces/kube-system/services/kube-dns2:dns/proxy
kubernetes-dashboard is running at https://10.4.129.100:9443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy
Metrics-server is running at https://10.4.129.100:9443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

# 查看对应 SVC
kubectl -n kube-system get svc | grep dns
kube-dns                             ClusterIP   10.4.140.2     <none>        53/UDP,53/TCP,9153/TCP         3y79d
kube-dns2                            ClusterIP   10.4.141.244   <none>        53/UDP,53/TCP                  2y65d

# 可以通过对应的 `ConfiMap` 查看 `CoreDNS` 信息
kubectl -n kube-system get cm coredns -o jsonpath='{.data.Corefile}' | grep kubernetes -A 3

    kubernetes rocketos.local in-addr.arpa ip6.arpa {
      pods insecure
      fallthrough in-addr.arpa ip6.arpa
    }

# KubeDNS 如果有 ConfigMap 也可以通过查看 configmap.data 字段
kubectl -n kube-system get cm kube-dns2 -oyaml
# 通过 deployment 查看 KubeDNS 的默认域名信息
kubectl -n kube-system get deploy kube-dns2 -o yaml | grep -- ' --domain='
        - --domain=cluster.local.
```
![Query DNS In Cluster](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/k8s-query-dns-info.png)

额(⊙o⊙)…两个域名居然不一样。。。


同时运行`CoreDNS`和`kube-dns`来实现 `DNS` 服务的高可用不是标准做法。应当选择一个，然后按照下述准则进行优化：

1. 多副本：运行多个CoreDNS和kube-dns副本以提供故障转移。
   ```
   kubectl scale --replicas=3 deployment/coredns -n kube-system
   kubectl scale --replicas=3 deployment/kube-dns -n kube-system
   ```

2. 负载均衡：使用Service对象分发流量。

3. 节点本地缓存：部署节点本地DNS缓存提高解析效率。

4. Pod反亲和性：确保DNS Pod分散在不同节点上。
   ```
   kubectl patch deployment coredns -n kube-system --patch='{"spec": {"template": {"spec": {"affinity": { ... }}}}}'
   ```

5. 监控和警报：使用Prometheus等工具监控DNS服务。

6. 测试：模拟故障，验证高可用性。

*************

#### **6、获取集群下所有命名空间的所有资源类型 `kubectl get all -A`**

一般来说，我们比较少场景需要获取所有命名空间下的所有资源类型。但当一个 `Pod` 资源出现异常，我们发现修改了之后依然不生效的时候，可能就需要确定：当前异常的 `Pod` 到底是 `deloyment/daemonset` 创建出来的呢？

此时就可以使用 `kubect get all | grep xxx` 进行配合定位。


*********


### 节点相关

#### **1、 `kubectl get nodes`：查看 `Kubernetes` 集群中的所有节点**

比较常用的一个命令，获取集群所有节点的简单运行信息

> kubectl get nodes -o wide 获取相对详细信息

```sh
/etc/apt/sources.list.d🔒  🕙 03:09:37 AM  ➜  kubectl get nodes
NAME               STATUS                     ROLES    AGE      VERSION
erc-node-118       Ready                      node     224d     v1.16.9-1+211b84cbb965ab
... ...
```

- `NAME` - 节点名称
- `STATUS` - 节点状态
    - `Ready` - 正常工作，可以接受调度和运行 Pod
    - `NotReady` - 某种原因节点不可用
    - `SchedulingDisabled` - 节点被禁用，不会接受**新**的 Pod 的调度
    - `Unkown` - 无法确定节点状态
- `ROLES` - 节点角色
    - `master`-主节点
    - `worker`或`node`-工作节点
    - `etcd`-表示 etcd 数据库节点
- `AGE` - 节点运行时间
- `VERSION` - 节点上运行的 Kubernetes 版本

1. 可以通过 `kubectl describe node <node-name>` 命令查看节点的详细描述信息，如：特别注意查看事件部分，以了解与该节点相关的任何错误、警告或异常事件。
2. 通过 SSH 登录到节点机器，查看 `/var/log` 目录下的相关日志

--------------------

#### **2、如何查看节点机器上运行的容器运行时是什么？**

`K8s` 最小编排单元是 `Pod`，最小运行单元是“符合容器运行时接口（CRI）的容器”。

其实通过 `Pod` 概念的引入，我们在操作 `K8s` 的时候已经能很大程度上屏蔽“容器”的概念。

- `kubectl describe node <node-name>| grep -i "container runtime"` 查看节点机器上的容器运行时引擎是什么

![show container runtime on node](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/show-container-runtime-interface-on-node.png)

补充：发现 `kubectl get nodes -o wide` 命令也线上了

![](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/kubectl-get-nodes-show-cri.png)

产生疑问：如果节点上安装了多个符合 CRI 的容器引擎，譬如：`Podman`、`Docker`、`containerd`，需要同时保证其它的容器引擎也可用的情况下，那么 `K8s` 是如何指定底层容器运行时引擎的呢？


### 资源对象的 `CURD`

`Kubernetes` 利用 “面向对象” 的设计思维，将所有的“资源”都抽离为“对象”，可以通过 `kubectel api-resources` 命令查看当前集群支持哪些资源对象的操作。同时 `K8s` 也提供和定义了丰富的 `API` 接口支持用户开发自定义资源类型。

但这样“对象”就有可能“重名”，因此 `K8s` 也像编程一样引入了 `NameSpace` 的概念，用于更好的区分、限定资源对象的“作用域”。

绝大部分的资源操作命令都需要通过 `-n <namespace>` 来指定资源在哪一个命名空间下，否则默认会去 `default` 命名空间下寻找对应的资源对象。

更多详细的资源对象概念可以查看官网：[Kubernetes 文档 > 概念](https://kubernetes.io/zh-cn/docs/concepts/)



#### NameSpace

编程中的「命名空间/名字空间」是一个**逻辑抽象概念**，用于将实体对象进行区域划分从而达到逻辑隔离、限定对象的可见范围（作用域），避免实体对象在命名上发生冲突。

`K8s` 中也抽象了[「命名空间」](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)这么一个逻辑概念的资源对象（名称叫 `namespaces` 简写为：`ns`），用于：**为了更好的管理 `K8s` 集群中的资源对象，通过 `namespace` 将同一集群中的资源划分为相互隔离的组。 同一名字空间内的资源名称要唯一，但跨名字空间时没有这个要求。**


--------

##### **虽然 `K8s` 的 `Master/Node` 架构已经能很好地管理集群，那为什么还要引入「命名空间」这个东西呢？**

假设采用 `Master/Node` 的架构方式来替代「命名空间」对集群的资源对象的管理，这样集群中的资源对象和物理架构就产生了直接的耦合关系，那么我们需要对：“到底需要分配多少资源？资源超出时该如何对资源实行扩容？应该将哪些资源重新分配到扩容的机器上？开发者该如何知道自己的这个资源在哪台机器上？...” 这些情况必须有一个清晰度规划，单独的看这些似乎都还好，但是结合「稳定-鸡蛋不能放在同一个篮子里（即：同类型资源不能都放在某一个节点上）」、「随业务增多而来的越来越多的资源对象 和 越来越多的物理资源，它们的关系该如何管理」两个点来思考上述问题，会发现 引入一个逻辑概念的「命名空间」来将“资源对象” 和 “物理资源” 的关系进行解耦 是一个更明智的选择。


**名字空间适用于存在很多跨多个团队或项目的用户的场景。对于只有几到几十个用户的集群，根本不需要创建或考虑名字空间。**

借助 `Kubenetes` 可以让中小企业也能借当下“云服务”的计算能力自动的实现“物理资源”调度分配，更加充分的将物理资源自动的利用起来。当集群资源越来越多，随之而来的问题也不可避免：

- 面对海量资源与节点的关系该如何管理？
- 各类应用需要划分多少资源？如何做做资源限额？

就显得格外重要，这个时候可以通过 `NameSpace` 对资源进行分类（可以根据业务场景、根据部门...等等纬度来进行划分），让研发人员/应用运维人员都聚焦在：资源应用与资源对象的逻辑关系即可。

--------------

##### **1、获取集群中的所有命名空间：`kubectl get namespaces`**

**不过 `K8s` 中的资源对象并非全部都是有「命名空间」的，譬如：「命名空间」资源对象本身、节点级别的资源对象...**

按照这个角度可以将 K8s 集群中的资源对象分为：

- 查看 `non-namespaced`（无命名空间）资源对象 ： `kubectl api-source --namespaced=false`
- 查看 `namespaced`（有命名空间） 资源对象： `kubectl api-source --namespaced=true` 

--------------

##### **2、设置当前操作的默认命名空间：kubectl config set-context --current --namespace=<namespace>**

`K8s` 集群自身启动的时候会伴随 4 个默认的初始化命名空间：`default`、`kube-node-lease`、`kube-public`、`kube-system`，默认情况下我们的操作都是在 `default` 命名空间之下。

对于 `namespaced` 类型的资源对象，我们执行 `kubectl get|edit|apply...` 操作的时候，如果该资源不是 `default` 命名空间都要通过 `-n <namespace>` 指定其他命名空间，或者 `-A, --all-namespaces` 限定该操作是针对所有命名空间下；对于 `non-namespaced` 资源类型对象则不用指定命名空间。

避免每次都要输入 `-n <namespace>`，可以通过 `kubectl config set-context --current --namespace=<namespace>` 设置当前操作的默认命名空间，通过 `kubectl config view --minify | grep 'namespace:'` 可以查看当前设置的默认命名空间。


- 生成一个命名空间 Yaml 文件：`kubectl create ns <namespace> -o yaml --dry-run=client`

--------------------

##### **3、创建命名空间**



---------------

##### **4、删除命名空间（谨慎操作）： `kubectl delete ns <namespace>`**

命名空间里的资源对象都是从属于“命名空间”这一资源对象的，所以在删除命名空间的时候一定要小心，**一旦命名空间被删除，它里面的所有对象也都会消失**。


----------------

##### **5、（待完善）如何对集群中的「命名空间」进行资源限额？**

不同职责的命名空间对资源的要求是不一样的，出于“单一职责”的面向对象设计原则考虑，`K8s` 又引入了 2 个 `API` 资源对象：

- `ResourceQuota`（简称：`quota`）：资源配额限制对象，用来限制命名空间级别的“资源配额管理”的工作（各类资源的数量、存储的大小...）
- `LimitRange`（简称：`limits`）：资源范围限制对象，用来限制命名空间内具体 `API` 对象的资源管理工作

即：

1. 限定资源对象的可见范围（作用域）：`NameSpace`
2. 限制命名空间的下资源对象/CPU/内存的消耗总量：`ResourceQuota`
3. 限定命名空间中具体资源对象（Pod 或 容器）的资源分配情况：`LimitRange`

**如果 `pod.yaml` 里没有 `resources` 字段，就可以无限制地使用 `CPU` 和内存**，这显然与命名空间的 `ResourceQuota` 资源配额相冲突。因此：**为了保证命名空间的资源总量可管可控，`Kubernetes` 会拒绝在有 `ResourceQuota` 限制的命名空间下创建没有 `resources` 字段的 `Pod`**。因此，要嘛：为该命名空间下所有 `Pod` 指定 `resources` 字段，要嘛通过 `LimitRange` 为其指定默认信息。

- [x] [Kubernetes Documentation > Concepts > Overview > Objects In Kubernetes > Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [x] [极客时间：Kubernetes 入门实战课 > 高级篇 > 29|集群管理：如何用名字空间分隔系统资源](http://gk.link/a/128xH)
- [ ] [限制范围 | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/policy/limit-range/)
- [ ] [资源配额 | Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/policy/resource-quotas/)
- [ ] [管理内存、CPU 和 API 资源 | Kubernetes](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/manage-resources/)


---------


#### Pod

`Pod` 是 `K8s` 中的一种抽象资源，用于：**管理一组应用程序容器以及这些容器所需要的共享资源**。同一组内的容器共享：存储、网络、IP地址、端口等信息...

##### **1、kubectl get pods：查看 Kubernetes 集群中当前命名空间下所有的 Pod 实例**

`kubectl config view --minify --output 'jsonpath={..namespace}'` 可以查看当前默认的命名空间，如果没有设置默认是 `default`.

```sh
kubectl get pods --all-namespaces # 所有命名空间下的 pods，简写为 kubectl get po -A
kubectl get pods -n <namespace> # 指定命名空间下的 pods (默认值是：default 命名空间)
kubectl get pods -n <namespace> -o <wide|json|yaml|name...>
```

命令结果如下

```txt
NAME          READY   STATUS    RESTARTS   AGE
pod-1         1/1     Running   0          2d
... ...
```

- `NAME` - Pod 名称
- `READY` - Pod 中容器的就绪状态：当前就绪的容器数/总容器数，当两者一致时表示 Pod 中所有容器都已就绪
- `STATUS` - Pod 的状态
    - `Running` : 正在运行且所有容器都就绪状态
    - `Pending` : Pod 正在等待调度中 或 Pod 中的容器尚未全部就绪
    - `Terminating` : Pod 正在被删除或终止中
    - `Succeeded` : Pod 中所有容器终止完成
    - `Failed` : Pod 中存在非 0 状态退出或终止的容器
    - `Unknown` : 因为某些原因无法取得 Pod 的状态，通常是因为与 Pod 所在主机通信失败
- `RESTARTS` - Pod 中 ==**容器** 的重启次数== （如何查看 Pod 的重启次数呢？`kubectl describe pod <pod_name>` 查看 `Status` 部分的 `Restart Count` 字段）
- `AGE` - Pod 的运行时间

`kubectl describe pod <pod_name>` 可以查看指定某一个 Pod 详细信息。[k8s排查Pod异常重启次数过多](https://www.ishells.cn/archives/pod-restart-exitcode-2)

还有一个常用的 `kubectl get pods -n <namespace> -o wide` 可以查看 `Pods` 的详细信息，例如 Pod 所在的节点和其他 IP 地址

`-o` 后可以接受的参数：

- `wide` 以表格的方式提供更详细的输出。例如，对于 pods，这将包括每个 pod 所在的节点和其 IP 地址。
- `json` 输出 JSON 格式的资源描述
- `yaml` 输出 YAML 格式的资源描述
- `custom-columns=自定义列名:.资源描述对象字段` 或 `custom-columns-file=<file>` 输出自定义列，如：`kubectl get pods -o=custom-columns=NAME:.metadata.name,NODE:.spec.nodeName`
- `jsonpath=自定义列名:.资源描述对象字段` 或 `custom-columns-file=<file>` 输出自定义 JSONPath 表达式结果
- `go-template=自定义列名:.资源描述对象字段` 或 `go-template-file=<file>` 输出自定义 Go 模板的结果

`-w` 参数：`--watch=false|true` 持续监听命名的请求信息

```sh
$ kubectl -n erc-test get po -w
NAME       READY   STATUS         RESTARTS   AGE
pod-demo   0/1     ErrImagePull   64         8h
pod-demo   0/1     ImagePullBackOff   64         8h
```

---------------

##### **2、`kubectl logs <pod-name> [-c <container-name> | --all-containers=true] [-f]` 查看 Pod 中的日志**

- [K8s日志查看利器之kubetail-云社区-华为云](https://bbs.huaweicloud.com/blogs/312631)
- `-f` 通过流输出日志信息
- `--all-containers=true` 是否查看所有容器日志信息
- `-c <container-name>` 指定查看单独某一个容器日志

----------------

##### **3、查看 Pod 中的容器列表**

`Pod` 是一组容器的集合，当我们使用 `kubectl logs` 查看日志时，若 `Pod` 内含有多个应用日志，就需要通过 `-c <container-name>` 指定具体要查看的容器进程。

可以通过 `kubectl -n <namespace> get pod <pod-name> -o jsonpath='{.spec.containers[*].name}'` 查看

```bash
$ kubectl get pod erc-car-rental-api-b476c4bc-xvnpd -o jsonpath='{.spec.containers[*].name}'

erc-car-rental-api container-consul filebeat
```

额外还可以通过 `kubectl describe pod <pod-name>` 查看 `Containers` 部分信息，可以得到结果

----------------

##### **4、`kubectl get pod -l <selector>` 过滤筛选 Pod 列表**

一个命名空间下往往会有非常多的 `Pod`，直接通过 `kubectl get pod | grep -Ei <filter>` 也是可以过滤筛选出来，其实也可以通过 `K8s` 中资源的选择器（`Selector`）来进行过滤查看。

`kubectl get po --show-labels` 可以显示 `Pod` 的 `label` 信息，然后结合 `kubectl get po -l app=<label>` 即可只查询符合标签的 `Pod` 列表。

如下，只查看有 `app=ERC-CAR-RENTAL-API` 这个属性的 `Pod`，并持续输出观察信息

```sh
$ kubectl get po -o wide -l app=ERC-CAR-RENTAL-API -w
```

---------

#### Job

#### CronJob

-------

#### ReplicaSet 

#### Deployment

#### DaemonSet

#### StatefulSet

------------

#### ConfigMap

#### Secret


--------

#### 持久卷：PersistentVolume 

--------

#### Service

**1、`kubectl get services` 查看 Kubernetes 集群中当前默认命名空间下的所有的 Service 实例**

`kubectl config view --minify | grep namespace` 可以查看当前集群上下文的默认命名空间，如果是空则表示当前没有指定，将使用 `default` 命名空间

可以通过 `-n xxx` 指定其他命名空间，或者 `-A, --all-namespaces` 查看所有命名空间下的所有资源对象

#### Ingress





6. kubectl get deployments：查看Kubernetes集群中所有的Deployment实例。
7. kubectl get replicasets：查看Kubernetes集群中所有的ReplicaSet实例。
8. kubectl get configmaps：查看Kubernetes集群中所有的ConfigMap实例。
9. kubectl get secrets：查看Kubernetes集群中所有的Secret实例。
10. kubectl get namespaces：查看Kubernetes集群中所有的Namespace实例。
11. kubectl describe node [node_name]：查看指定节点的详细信息。
12. kubectl describe pod [pod_name]：查看指定pod的详细信息。
13. kubectl describe service [service_name]：查看指定Service的详细信息。
14. kubectl describe deployment [deployment_name]：查看指定Deployment的详细信息。
15. kubectl describe replicaset [replicaset_name]：查看指定ReplicaSet的详细信息。
16. kubectl describe configmap [configmap_name]：查看指定ConfigMap的详细信息。
17. kubectl describe secret [secret_name]：查看指定Secret的详细信息。
18. kubectl describe namespace [namespace_name]：查看指定Namespace的详细信息。
19. kubectl create deployment [deployment_name] --image=[image_name]：创建一个Deployment实例。
20. kubectl create service [service_name] --tcp=80:8080：创建一个TCP类型的Service实例。
21. kubectl delete node [node_name]：删除指定节点。
22. kubectl delete pod [pod_name]：删除指定pod。
23. kubectl delete service [service_name]：删除指定Service。
24. kubectl delete deployment [deployment_name]：删除指定Deployment。
25. kubectl delete replicaset [replicaset_name]：删除指定ReplicaSet。
26. kubectl delete configmap [configmap_name]：删除指定ConfigMap。
27. kubectl delete secret [secret_name]：删除指定Secret。
28. kubectl delete namespace [namespace_name]：删除指定Namespace。
29. kubectl apply -f [file_name].yaml：使用YAML文件创建或更新资源。
30. kubectl get pods --show-labels：查看pod带有的Label。
31. kubectl label pods [pod_name] [label_name]=[label_value]：给指定的pod打上一个Label。
32. kubectl label service [service_name] [label_name]=[label_value]：给指定的Service打上一个Label。
33. kubectl label node [node_name] [label_name]=[label_value]：给指定的节点打上一个Label。
34. kubectl rollout status deployment [deployment_name]：查看指定Deployment的滚动升级状态。
35. kubectl rollout history deployment [deployment_name]：查看指定Deployment的滚动升级历史。
36. kubectl rollout undo deployment [deployment_name]：撤销指定Deployment的最后一次滚动升级。
37. kubectl scale deployment [deployment_name] --replicas=[number]：修改指定Deployment的副本数量。
38. kubectl expose deployment [deployment_name] --type=NodePort --port=8080：将指定的Deployment暴露到NodePort上。
39. kubectl exec [pod_name] -it [command]：在指定的pod上执行一个命令。
40. kubectl logs [pod_name]：查看指定pod的日志。
41. kubectl logs -f [pod_name]：实时查看指定pod的日志。
42. kubectl top pod：查看所有pod的资源使用情况。
43. kubectl top node：查看所有节点的资源使用情况。
44. kubectl run [pod_name] --image=[image_name]：使用镜像创建一个pod。
45. kubectl run [pod_name] --image=[image_name] --replicas=[number]：使用镜像创建一个具有多个副本的Deployment。
46. kubectl run [pod_name] --image=[image_name] --port=80：使用镜像创建一个pod，并开启80端口。
47. kubectl port-forward [pod_name] [local_port]:[pod_port]：将本地端口与pod端口进行映射。
48. kubectl apply -f [file_name].json：使用JSON文件创建或更新资源。
49. kubectl apply -f [directory_name]：使用目录中的YAML文件创建或更新资源。
50. kubectl get all --all-namespaces：查看所有命名空间中的所有资源。
51. kubectl api-resources：查看Kubernetes支持的所有API资源。
52. kubectl api-versions：查看Kubernetes支持的所有API版本。
53. kubectl auth can-i [verb] [resource]：检查当前用户是否有执行指定操作的权限。
54. kubectl auth reconcile -f [file_name].yaml：更新资源，确保用户拥有正确的权限。
55. kubectl auth reconcile -f [directory_name]：更新目录中的所有资源，确保用户拥有正确的权限。
56. kubectl config view：查看kubectl的配置文件。
57. kubectl config current-context 查看当前上下文
58. kubectl config use-context [context_name]：切换当前上下文
59. kubectl config set-context [context_name] --namespace=[namespace_name]：设置指定上下文的命名空间。
60. kubectl create ns [namespace_name]：创建一个命名空间。
61. kubectl delete ns [namespace_name]：删除一个命名空间。
62. kubectl get events：查看Kubernetes集群中的事件信息。
63. kubectl describe event [event_name]：查看指定事件的详细信息。
64. kubectl rollout restart deployment [deployment_name]：重启指定Deployment的所有pod实例。
65. kubectl rollout pause deployment [deployment_name]：暂停指定Deployment的滚动升级。
66. kubectl rollout resume deployment [deployment_name]：恢复指定Deployment的滚动升级。
67. kubectl set image deployment [deployment_name] [container_name]=[new_image]：更新指定Deployment中的容器镜像。
68. kubectl edit deployment [deployment_name]：编辑指定Deployment的定义文件。
69. kubectl apply -f [file_name].yaml --dry-run：测试在Kubernetes集群中创建资源的效果，但不实际创建资源。
70. kubectl annotate [resource_type] [resource_name] [annotation_key]=[annotation_value]：在指定的资源上添加注释。
71. kubectl create secret docker-registry [secret_name] --docker-server=[server] --docker-username=[username] --docker-password=[password]：创建一个Docker镜像仓库认证的Secret。
72. kubectl create configmap [configmap_name] --from-literal=[key]=[value]：创建一个ConfigMap实例。
73. kubectl apply -f [file_name].yaml --prune：删除集群中不存在于YAML文件中的资源。
74. kubectl rollout history deployment [deployment_name] --revision=[revision_number]：查看指定Deployment特定版本的滚动升级历史。
75. kubectl rollout undo deployment [deployment_name] --to-revision=[revision_number]：将指定Deployment回滚到特定版本。
76. kubectl cp [pod_name]:[source_path] [destination_path]：将指定pod中的文件复制到本地。
77. kubectl cp [source_path] [pod_name]:[destination_path]：将本地文件复制到指定pod中。
78. kubectl patch [resource_type] [resource_name] -p '[json_patch]'：修改指定资源的部分属性。
79. kubectl create cronjob [job_name] --image=[image_name] --schedule='*/1 * * * *' --restart=OnFailure --dry-run -o yaml > [file_name].yaml：创建一个CronJob实例，并将其定义文件保存到指定的YAML文件中。
80. kubectl delete cronjob [job_name]：删除指定的CronJob实例。
81. kubectl create ingress [ingress_name] --rule='[/path]'=[service_name]:[port]：创建一个Ingress实例并配置一个路径规则。
82. kubectl delete ingress [ingress_name]：删除指定的Ingress实例。
83. kubectl rollout status daemonset [daemonset_name]：查看指定DaemonSet的滚动升级状态。
84. kubectl rollout history daemonset [daemonset_name]：查看指定DaemonSet的滚动升级历史。
85. kubectl rollout undo daemonset [daemonset_name]：撤销指定DaemonSet的最后一次滚动升级。
86. kubectl scale daemonset [daemonset_name] --current-replicas=[current_replicas] --replicas=[replicas]：修改指定DaemonSet的副本数量。
87. kubectl create job [job_name] --image=[image_name] --restart=OnFailure --dry-run -o yaml > [file_name].yaml：创建一个Job实例，并将其定义文件保存到指定的YAML文件中。
88. kubectl delete job [job_name]：删除指定的Job实例。
89. kubectl create serviceaccount [service_account_name]：创建一个ServiceAccount实例。
90. kubectl delete serviceaccount [service_account_name]：删除一个ServiceAccount实例。
91. kubectl apply -f [file_name].yaml --prune --selector=[label_selector]：使用指定的Label选择器删除集群中不存在于YAML文件中的资源。
92. kubectl rollout undo [resource_type] [resource_name] --to-revision=[revision_number]：将指定资源回滚到特定版本。
93. kubectl set env deployment [deployment_name] [key]=[value]：设置指定Deployment的环境变量。
94. kubectl rollout restart daemonset [daemonset_name]：重启指定DaemonSet的所有pod实例。
95. kubectl rollout pause daemonset [daemonset_name]：暂停指定DaemonSet的滚动升级。
96. kubectl rollout resume daemonset [daemonset_name]：恢复指定DaemonSet的滚动升级。
97. kubectl scale deployment [deployment_name] --replicas=[number] --current-replicas=[current_number]：增加或减少指定Deployment的副本数量。
98. kubectl taint node [node_name] [taint_key]=[taint_value]:NoSchedule：在指定节点上添加一个污点，阻止
99. kubectl label [resource_type] [resource_name] [label_key]=[label_value]：在指定的资源上添加标签。
100. kubectl annotate [resource_type] [resource_name] [annotation_key]=[annotation_value] --overwrite：在指定的资源上覆盖现有的注释。
101. kubectl create secret generic [secret_name] --from-file=[file_path]：从本地文件创建一个通用的Secret实例。
102. kubectl create clusterrolebinding [binding_name] --clusterrole=[role_name] --user=[user_name]：创建一个将用户绑定到指定的ClusterRole的ClusterRoleBinding实例。
103. kubectl delete clusterrolebinding [binding_name]：删除指定的ClusterRoleBinding实例。
104. kubectl exec -it [pod_name] -- [command]：在指定pod中执行bash shell命令。
105. kubectl top [resource_type] [resource_name]：查看指定资源的CPU和内存使用情况。
106. kubectl get cronjob [cronjob_name] -o jsonpath='{.status.active}'：查看指定CronJob当前处于活动状态的Job数量。
107. kubectl rollout status statefulset [statefulset_name]：查看指定StatefulSet的滚动升级状态。
108. kubectl rollout history statefulset [statefulset_name]：查看指定StatefulSet的滚动升级历史。
109. kubectl rollout undo statefulset [statefulset_name]：撤销指定StatefulSet的最后一次滚动升级。
110. kubectl describe pvc [pvc_name]：查看指定PersistentVolumeClaim的详细信息。
111. kubectl delete pvc [pvc_name]：删除指定的PersistentVolumeClaim。
112. kubectl scale statefulset [statefulset_name] --replicas=[number]：修改指定StatefulSet的副本数量。
113. kubectl label nodes [node_name] [label_key]=[label_value]：在指定节点上添加标签。
114. kubectl apply -f [file_name].yaml --prune --selector=[label_selector] --dry-run：测试删除集群中不存在于YAML文件中的资源的效果，但不实际删除资源。
115. kubectl rollout restart statefulset [statefulset_name]：重启指定StatefulSet的所有pod实例。
116. kubectl get pod [pod_name] -o yaml --export：导出指定pod的定义文件，不包括自动生成的信息。
117. kubectl describe [resource_type] [resource_name] --show-events：查看指定资源的详细信息，并显示相关的事件。
118. kubectl create priorityclass [class_name] --value=[value] --description=[description]：创建一个PriorityClass实例。
119. kubectl delete priorityclass [class_name]：删除一个PriorityClass实例。
120. kubectl create quota [quota_name] --hard=[resource_name]=[resource_limit]：创建一个资源配额限制实例。
121. kubectl delete quota [quota_name]：删除指定的资源配额限制实例。
122. kubectl run [pod_name] --image=[image_name] --env [key]=[value]：使用指定镜像创建一个新的pod，并设置环境变量。
123. kubectl rollout pause statefulset [statefulset_name]：暂停指定StatefulSet的滚动升级。
124. kubectl rollout resume statefulset [statefulset_name]：恢复指定StatefulSet的滚动升级。
125. kubectl create networkpolicy [policy_name] --ingress --pod-selector=[selector] --namespace=[namespace] --policy-types=[policy_type]：创建一个网络策略实例。
126. kubectl delete networkpolicy [policy_name]：删除一个网络策略实例。
127. kubectl create deployment [deployment_name] --replicas=[number] --image=[image_name]：创建一个Deployment实例。
128. kubectl delete deployment [deployment_name]：删除指定的Deployment实例。
129. kubectl create service [service_name] --port=[port_number] --target-port=[port_number] --selector=[selector] --type=[service_type]：创建一个Service实例。
130. kubectl delete service [service_name]：删除指定的Service实例。
131. kubectl rollout restart deployment [deployment_name] --image=[new_image]：将指定Deployment的所有pod实例重启，并使用新的容器镜像。
132. kubectl run [pod_name] --image=[image_name] --port=[port_number] --expose：使用指定镜像创建一个新的pod，并将其暴露为一个Service。
133. kubectl create configmap [configmap_name] --from-literal=[key]=[value]：从指定的键值对创建ConfigMap实例。
134. kubectl delete configmap [configmap_name]：删除指定的ConfigMap实例。
135. kubectl rollout history deployment [deployment_name]：查看指定Deployment的滚动升级历史。
136. kubectl rollout undo deployment [deployment_name]：撤销指定Deployment的最后一次滚动升级。
137. kubectl patch [resource_type] [resource_name] -p '[json_patch]'：在指定的资源上应用JSON补丁。
138. kubectl create cronjob [cronjob_name] --schedule=[cron_schedule] --image=[image_name] --command=[command]：创建一个CronJob实例。
139. kubectl delete cronjob [cronjob_name]：删除指定的CronJob实例。
140. kubectl port-forward [pod_name] [local_port]:[pod_port]：将指定pod的端口转发到本地端口。
141. kubectl cp [pod_name]:[source_file_path] [destination_file_path]：从指定pod中复制文件到本地文件系统。
142. kubectl apply -f [file_name].yaml --prune --selector=[label_selector]：删除集群中不存在于YAML文件中的资源。
143. kubectl rollout status deployment [deployment_name]：查看指定Deployment的滚动升级状态。
144. kubectl run [pod_name] --image=[image_name] --env-file=[env_file_path]：使用指定镜像创建一个新的pod，并从环境文件读取环境变量。
145. kubectl expose deployment [deployment_name] --port=[port_number] --target-port=[port_number] --type=[service_type]：将指定Deployment暴露为一个Service。
146. kubectl rollout pause deployment [deployment_name]：暂停指定Deployment的滚动升级。
147. kubectl rollout resume deployment [deployment_name]：恢复指定Deployment的滚动升级。
148. kubectl create namespace [namespace_name]：创建一个新的命名空间。
149. kubectl delete namespace [namespace_name]：删除指定的命名空间。
150. kubectl get events --sort-by=.metadata.creationTimestamp：按创建时间排序查看集群中的事件记录。



```sh
$ kubectl --help

kubectl controls the Kubernetes cluster manager.

 Find more information at: https://kubernetes.io/docs/reference/kubectl/overview/

Basic Commands (Beginner):
  create        Create a resource from a file or from stdin
  expose        Take a replication controller, service, deployment or pod and expose it as a new Kubernetes service
  run           在集群中运行一个指定的镜像
  set           为 objects 设置一个指定的特征

Basic Commands (Intermediate):
  explain       Get documentation for a resource
  get           显示一个或更多 resources
  edit          在服务器上编辑一个资源
  delete        Delete resources by file names, stdin, resources and names, or by resources and label selector

Deploy Commands:
  rollout       Manage the rollout of a resource
  scale         Set a new size for a deployment, replica set, or replication controller
  autoscale     Auto-scale a deployment, replica set, stateful set, or replication controller

Cluster Management Commands:
  certificate   修改 certificate 资源.
  cluster-info  Display cluster information
  top           Display resource (CPU/memory) usage
  cordon        标记 node 为 unschedulable
  uncordon      标记 node 为 schedulable
  drain         Drain node in preparation for maintenance
  taint         更新一个或者多个 node 上的 taints

Troubleshooting and Debugging Commands:
  describe      显示一个指定 resource 或者 group 的 resources 详情
  logs          输出容器在 pod 中的日志
  attach        Attach 到一个运行中的 container
  exec          在一个 container 中执行一个命令
  port-forward  Forward one or more local ports to a pod
  proxy         运行一个 proxy 到 Kubernetes API server
  cp            Copy files and directories to and from containers
  auth          Inspect authorization
  debug         Create debugging sessions for troubleshooting workloads and nodes

Advanced Commands:
  diff          Diff the live version against a would-be applied version
  apply         Apply a configuration to a resource by file name or stdin
  patch         Update fields of a resource
  replace       Replace a resource by file name or stdin
  wait          Experimental: Wait for a specific condition on one or many resources
  kustomize     Build a kustomization target from a directory or URL.

Settings Commands:
  label         更新在这个资源上的 labels
  annotate      更新一个资源的注解
  completion    Output shell completion code for the specified shell (bash, zsh or fish)

Other Commands:
  alpha         Commands for features in alpha
  api-resources Print the supported API resources on the server
  api-versions  Print the supported API versions on the server, in the form of "group/version"
  config        修改 kubeconfig 文件
  plugin        Provides utilities for interacting with plugins
  version       输出 client 和 server 的版本信息
```

## K8s 故障排查

- [A visual guide on troubleshooting Kubernetes deployments](https://learnk8s.io/troubleshooting-deployments)
- [如何使用Journalctl查看并操作Systemd日志](https://blog.csdn.net/zstack_org/article/details/56274966)
- [系统运维|如何使用 journalctl 查看和分析 systemd 日志（附实例）](https://linux.cn/article-15544-1.html)
- [journalctl 分析日志 | myfreax](https://www.myfreax.com/analyze-logs-using-the-journalctl-command/)
- [Kubernetes 应用问题的通用排查思路-51CTO.COM](https://www.51cto.com/article/685652.html)
- [kubernetes集群问题排查 - kubernetes-notes](https://k8s.huweihuang.com/project/operation/kubernetes-troubleshooting)

![Kubernetes 故障排查指南](https://learnk8s.io/a/a-visual-guide-on-troubleshooting-kubernetes-deployments/troubleshooting-kubernetes.zh_cn.v4.png)