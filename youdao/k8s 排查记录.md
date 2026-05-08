# 工作中遇到的 K8s 问题，排查记录

[TOC]


## 2023/08/14 Statefulset zookepper 内部域名解析失败

`ERCP` 的同事发了一个截图部署的 `Zookeeper` 服务显示 `while listening to address zookeeper-0.zk-hs.ercp-dev.svc.cluster.local:3888 java.net.SocketException: Unresolved address`

![ercp zookeeper unresolved address](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/k8s-20230815111651.png)

从 `pod` 命名看出了这是一个 有状态服务（`Statefulset`） 资源对象。等后来空下来看的时候，伙伴说，已经解决了，问题是：**集群默认域名修改了，因此导致了 `.svc.cluster.local` 域名解析不通**。

1、第一时间执行了 `get pods` 查看 `pod` 是否异常：看到 `Pod` 是正常的，证明服务自身应该是没有问题，应该是那个地方的配置异常

```sh
$ kubectl -n ercp-dev get statefulsets.apps zookeeper

NAME        READY   AGE
zookeeper   3/3     19h

$ kubectl -n ercp-dev get pods | grep zook

zookeeper-0                                1/1     Running   0          13h
zookeeper-1                                1/1     Running   0          13h
zookeeper-2                                1/1     Running   0          13h
```

通过 `kubectl -n ercp-dev logs zookeeper-0` 报错

```sh
2023-08-15 04:00:34,387 [myid:] - ERROR [ListenerHandler-zookeeper-0.zk-hs.ercp-dev.svc.cluster.local:3888:o.a.z.s.q.QuorumCnxManager$Listener$ListenerHandler@1099] - Exception while listening to address zookeeper-0.zk-hs.ercp-dev.svc.cluster.local:3888
java.net.SocketException: Unresolved address
        at java.base/java.net.ServerSocket.bind(ServerSocket.java:388)
        at java.base/java.net.ServerSocket.bind(ServerSocket.java:349)
        at org.apache.zookeeper.server.quorum.QuorumCnxManager$Listener$ListenerHandler.createNewServerSocket(QuorumCnxManager.java:1141)
        at org.apache.zookeeper.server.quorum.QuorumCnxManager$Listener$ListenerHandler.acceptConnections(QuorumCnxManager.java:1070)
        at org.apache.zookeeper.server.quorum.QuorumCnxManager$Listener$ListenerHandler.run(QuorumCnxManager.java:1039)
        at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:515)
        at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
        at java.base/java.lang.Thread.run(Thread.java:829)
```

2、`kubectl -n ercp-dev exec -it zookeeper-0 -- bash` 进入容器，发现 `ping、telnet、wget、curl` 这些命令都没有，给整不会了...

- [为什么 Kubernetes Service 不能 ping ？](https://kuboard.cn/learning/faq/ping-service.html)

总结：

1. 通过 `get pods` 查看 `pod` 服务本身是否有问题，只是 Pod 内部的域名解析有问题。
2. 第二步想通过 `ping/wget/curl` 这些来判断 `Pod` 内域名解析配置是正常的...这里不妥当应当先判断：
    - 到底是用户配置的域名错误了（即本身这个域名就不正确）？
    - 还是域名正确但是解析不通？

`/etc/resolv.conf` 在 `Kubernetes pod` 创建时由 `kubelet` 自动生成，基于集群的 `DNS` 配置（即：节点上的 `kubelet` 根据集群信息自动生成的 ns 记录）。

```sh
kubectl -n ercp-dev exec -it zookeeper-0 -- bash -c "cat /etc/resolv.conf"
nameserver xx.x.xxx.xx
search ercp-dev.svc.rocketos.local svc.rocketos.local rocketos.local
options ndots:5
```

这样稍微一对比就能知道：`zookeeper-*` 中请求的是 `zookeeper-0.zk-hs.ercp-dev.svc.cluster.local` 而真正正确的 `nameserver` 应该是：`ercp-dev.svc.rocketos.local`.

即：用户配置域名错误，应该改为 `zookeeper-0.zk-hs.ercp-dev.svc.rocketos.local`，以上是最快能定位排除确定是否配置正确的方式。

-----

- K8s 集群采用 FQDN（完全限定域名）格式定义内部域名 `servicename.namespace.defaultDomain`
- 默认域名是：`.svc.cluster.local`，即：`servicename.namespace.svc.cluster.local`，默认命名空间是 `default`；所以如果一个 `Service` 资源对象刚好是在 `default` 命名空间下，且集群默认域名没有修改的情况下，可以通过 `servicename` 作为其域名
- `StatefulSet` 可以看做一种特殊的 `Deployment`，内部蕴含了一个 `Service Headless` 的 `Service` 模板配置，因此，我们可以通过：`podname.servicename.namespace.defaultDomain` 的方式来访问


```sh
$ bectl -n ercp-dev get statefulsets.apps zookeeper -o yaml

apiVersion: apps/v1
kind: StatefulSet
metadata:
  ... ...
  labels:
    app: zookeeper
  name: zookeeper
  namespace: ercp-dev
  ... ...
spec:
  podManagementPolicy: OrderedReady
  replicas: 3
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: zookeeper
  serviceName: zk-hs
....
```

```sh
$ kubectl -n ercp-dev exec -it zookeeper-0 -- bash

I have no name!@zookeeper-0:/$ cat /etc/resolv.conf
nameserver xx.xx.xxx.xx
search ercp-dev.svc.rocketos.local svc.rocketos.local rocketos.local
options ndots:5
```

-----------

![systemd kubelet.service 配置](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/k8s-error-node-notready-kubelet-service-config.png)

```planit
Name:               192.168.44.137
Roles:              control-plane
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=192.168.44.137
                    kubernetes.io/os=linux
                    node-role.kubernetes.io/control-plane=
                    node.kubernetes.io/exclude-from-external-load-balancers=
Annotations:        kubeadm.alpha.kubernetes.io/cri-socket: unix:///var/run/containerd/containerd.sock
                    node.alpha.kubernetes.io/ttl: 0
                    projectcalico.org/IPv4Address: 192.168.44.137/24
                    projectcalico.org/IPv4IPIPTunnelAddr: 10.18.49.192
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 14 Aug 2023 12:26:09 -0400
Taints:             node.kubernetes.io/unreachable:NoExecute
                    node-role.kubernetes.io/control-plane:NoSchedule
                    node.kubernetes.io/unreachable:NoSchedule
Unschedulable:      false
Lease:
  HolderIdentity:  192.168.44.137
  AcquireTime:     <unset>
  RenewTime:       Mon, 14 Aug 2023 14:29:46 -0400
Conditions:
  Type                 Status    LastHeartbeatTime                 LastTransitionTime                Reason              Message
  ----                 ------    -----------------                 ------------------                ------              -------
  NetworkUnavailable   False     Mon, 14 Aug 2023 13:02:36 -0400   Mon, 14 Aug 2023 13:02:36 -0400   CalicoIsUp          Calico is running on this node
  MemoryPressure       Unknown   Mon, 14 Aug 2023 14:25:18 -0400   Mon, 14 Aug 2023 14:39:54 -0400   NodeStatusUnknown   Kubelet stopped posting node status.
  DiskPressure         Unknown   Mon, 14 Aug 2023 14:25:18 -0400   Mon, 14 Aug 2023 14:39:54 -0400   NodeStatusUnknown   Kubelet stopped posting node status.
  PIDPressure          Unknown   Mon, 14 Aug 2023 14:25:
```



- [Kubernetes Pod 驱逐详解](https://icloudnative.io/posts/kubernetes-eviction/)
- [k8s 节点资源是如何管理的？](https://zhuanlan.zhihu.com/p/400520689)
- [调度、抢占和驱逐 > 节点压力驱逐](https://kubernetes.io/zh-cn/docs/concepts/scheduling-eviction/node-pressure-eviction/)
- [节点故障排查](https://docs.ucloud.cn/uk8s/troubleshooting/node_debug_summary.pdf)
- [K8S线上集群排查，实测排查Node节点NotReady异常状态](https://cloud.tencent.com/developer/article/1790799)
- [Pod 完整生命周期](https://wghdr.top/archives/546)
- [pod状态异常排查总结](https://wghdr.top/archives/1569)
- [节点|Kubernetes](https://kubernetes.io/zh-cn/docs/concepts/architecture/nodes/#info)
- [k8s node的几种状态](https://www.cnblogs.com/Gdavid/p/17496345.html)
- [Kubelet 状态更新机制](https://www.qikqiak.com/post/kubelet-sync-node-status/)
- [华为云云原生王者课程集训营](https://edu.huaweicloud.com/activity/Cloud-native3.html)
- [K8s 集群节点状态显示notready问题处理](https://blog.csdn.net/hedao0515/article/details/123607252)
- [k8s节点为NotReady的常见原因](https://blog.51cto.com/omaidb/5068303)
- [集群故障排查](https://kubernetes.io/zh-cn/docs/tasks/debug/debug-cluster/)
- [对处于 Critical 或 NotReady 状态的工作程序节点进行故障诊断](https://cloud.ibm.com/docs/containers?topic=containers-ts-critical-notready&locale=zh-CN)
- [k8s新增node节点一直notready状态的解决方法](https://sulao.cn/post/816.html)
- [K8S节点状态NotReady问题解决](https://blog.csdn.net/u013092227/article/details/118895324)
- [节点 NotReady](https://tencentcloudcontainerteam.github.io/tke-handbook/troubleshooting/node-notready.html)
- [记录一次kubernetes中node节点NotReady异常](https://www.wulaoer.org/?p=2760)
- [解决Kubernetes node NotReady故障案例](http://www.knockatdatabase.com/2022/12/16/how-to-solve-kubernetes-node-notready/)
- [K8S线上集群排查，实测排查Node节点NotReady异常状态](https://www.cnblogs.com/fenjyang/p/14417494.html)



- 查看 `kubelet` 日志：`journalctl -u kubelet`