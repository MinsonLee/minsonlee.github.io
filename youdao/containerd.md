- https://containerd.io/
- https://github.com/containerd/containerd/blob/main/docs/getting-started.md
- [替代Docker容器引擎首选：Containerd](https://mp.weixin.qq.com/s/A9zU7gZH0liLjc-e-dhk8A)
- [Containerd 使用教程](https://fuckcloudnative.io/posts/getting-started-with-containerd/)
- [再见 Docker ！分分钟转型 Containerd](https://mingongge.blog.csdn.net/article/details/117935935)
- [新一代 Kubernetes 容器运行时 Containerd 保姆级中文教程](https://mp.weixin.qq.com/s/Hqh15NMWxVJoXB--tzgBNg)
- [从Docker到Containerd：容器运行时的下一步](https://mp.weixin.qq.com/s/2QUjQBH8hoAVqqHlNnCwWg)
- [轻量级容器运行时：Containerd的部署与使用](https://mp.weixin.qq.com/s/LjkPpeDotTSguh4kDLE1mQ)
- [重学容器02: 部署容器运行时Containerd](https://blog.frognew.com/2021/04/relearning-container-02.html)
- [Kubernetes 进阶训练营(第2期) 讲义：containerd](https://www.qikqiak.com/k8strain2/containerd/runtime/)
- [containerd使用指南](https://www.jxhs.me/2021/10/31/containerd%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97/)



- [如何丝滑般将 Kubernetes 容器运行时从 Docker 切换成 Containerd ： https://www.51cto.com/article/678323.html](https://www.51cto.com/article/678323.html)

> 上述文章讲的需要将 docker 服务停止，切换 containerd 的服务为系统服务进行更换。

- [How to install the Containerd runtime engine on Ubuntu Server 22.04](https://www.techrepublic.com/article/install-containerd-ubuntu/)
- [How to switch container runtime in a Kubernetes cluster](https://dev.to/stack-labs/how-to-switch-container-runtime-in-a-kubernetes-cluster-1628)
 
```sh
# 下载安装 containerd：https://github.com/containerd/containerd/releases
# containerd 提供了两种压缩包
#     containerd-${version}-${os}-${arch}.tar.gz，这个压缩包中仅包含了 containerd、ctr 相关的二进制文件
#     cri-containerd-cni-${version}-${os}-${arch}.tar.gz，这里面是一个比较全的压缩包，（containerd、runc、ctr）
#    如果作为 K8s 的容器运行时，建议直接选择 cri-containerd-cni-${version}-${os}-${arch}.tar.gz 压缩包。
wget https://github.com/containerd/containerd/releases/download/v1.7.2/containerd-1.7.2-linux-amd64.tar.gz
tar xvf containerd-1.7.2-linux-amd64.tar.gz -C /apps/containerd

# 创建用户组 containerd
groupadd -g 1002 containerd
# 添加当前用户到 containerd 用户组
usermod -aG containerd ${USER}

# 生成配置文件


# 下载 containerd.service 服务启动文件，通过 systemctl 启动服务
# systemctl 启停服务的脚本在 /lib/systemd/system/* 
# 注意下载后自己修改 containerd 启动路径
curl "https://raw.githubusercontent.com/containerd/containerd/main/containerd.service" -o /lib/systemd/system/containerd.service
 
# 通过 systemctl 启动服务
systemctl start containerd.service

# 通过 service containerd start|stop|restart|status 启停 containerd
# service 启停服务的脚本在 /etc/init.d/* 



# 配置环境变量
echo 'PATH=/apps/containerd/bin:$PATH' >> /etc/profile
source /etc/profile
```

Containerd 命令

```shell
ctr i pull docker.io/library/nginx:alpine
docker.io/library/nginx:alpine:                                                   resolved       |++++++++++++++++++++++++++++++++++++++|
index-sha256:647c5c83418c19eef0cddc647b9899326e3081576390c4c7baa4fce545123b6c:    done           |++++++++++++++++++++++++++++++++++++++|
manifest-sha256:ccf066d2cfec0cfe57a63cf26f4b7cabbea80e11ab5b7f1cc11a1b5efd65ea0b: done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:e6a5b569446606ea05a88fc5be4097b4982fc4bc8aeae0818385fe13b8b6066e:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:a2a4fe64baa08a5a04c1acd107b0026f81a72c7e35cdb3647e164f3b87871d09:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:0777b518fc6e4d42454db10fd2da40eb3f2e9086aa2529066ce6b314c2ec08cb:    done           |++++++++++++++++++++++++++++++++++++++|
config-sha256:414132ff3b076936528928c823b4f3d1e1178b2692ae04defc8f8fdfd0a83a03:   done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:63f4060a8ef34058494aefc8ef63522d21056a40f00255d0c5d92ab51212e4c2:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:9398808236ffac29e60c04ec906d8d409af7fa19dc57d8c65ad167e9c4967006:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:9cbe387ec693ef1d8ece08c1ab2d510ac31d0745c157fbf948cacac343b47c34:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:7b8bdebbb770eb9a7ceaecd729a82d21052fcdb9915873a67d5834960944fcf2:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:48703ecfcf806f280f159af73a1688374148f4860c52d016646a40a1a84853ec:    done           |++++++++++++++++++++++++++++++++++++++|
elapsed: 21.4s                                                                    total:  16.1 M (769.7 KiB/s)
unpacking linux/amd64 sha256:647c5c83418c19eef0cddc647b9899326e3081576390c4c7baa4fce545123b6c...
done: 1.140733527s
```

- [How to run and manage containers using ctr](https://labs.iximiuz.com/courses/containerd-cli/ctr/container-management)
- [命令行大全 & docker、containerd、ctr、crictl 的联系-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/2242227) 



--------------



查看Docker的`containerd`组件的Sock文件路径：

1. **查看Docker进程信息**: 执行`ps aux | grep dockerd`，在输出信息中找到`--containerd`标志后的路径。

   示例输出：

   ```
   /usr/bin/dockerd ... --containerd=/var/run/docker/containerd/containerd.sock ...
   ```

2. **或查看Docker配置**: 检查Docker配置文件，通常在`/etc/docker/daemon.json`。
3. **或使用Docker info**: 运行`docker info`，查看`containerd version`字段或相关信息。
4. **或查看 containerd 进程信息**： 执行 `ps aux | grep containerd`，在 输出信息找到 `--address` 后的路径

通常默认路径是`/var/run/docker/containerd/containerd.sock`。找到这个路径后，你就可以用它连接到`containerd`。

----------

`containerd`的Sock文件路径通常在其配置文件中指定。默认配置文件通常位于`/etc/containerd/config.toml`。

1. **配置文件**: 打开`/etc/containerd/config.toml`，查找`[grpc]`或`address`字段。
  
2. **进程信息**: 执行`ps aux | grep containerd`，在输出信息中找`--address`或`-a`标志。

3. **服务文件**: 如果通过systemd管理，检查`/etc/systemd/system/containerd.service`或`/lib/systemd/system/containerd.service`。

找到该路径后，你可以用它与`containerd`进行通信。

----


要使用`ctr`连接Docker的`containerd`组件，执行以下步骤：

1. **找到Socket文件**: Docker通常使用Unix Socket与`containerd`通信。默认路径通常是`/var/run/docker/containerd/containerd.sock`。

2. **设置命名空间**: Docker使用`moby`作为默认命名空间。

3. **运行ctr命令**: 使用`--address`和`--namespace`（或`-n`）标志。

示例：

```bash
ctr --address /var/run/docker/containerd/containerd.sock --namespace=moby containers ls
```

这样，`ctr`就会连接到Docker的`containerd`组件，并在Docker的命名空间下列出容器。


-----

- [containerd系列（一）：containerd 的介绍与安装_51CTO博客_containerD](https://blog.51cto.com/flyfish225/5360370)
- [containerd系列（二）：containerd 的镜像管理_51CTO博客_containerd构建镜像](https://blog.51cto.com/flyfish225/5364379)
- [containerd系列（三）：containerd 的容器管理_51CTO博客_containerD](https://blog.51cto.com/flyfish225/5366113)
- [containerd系列（四）：containerd 镜像提交与命名空间_51CTO博客_containerd构建镜像](https://blog.51cto.com/flyfish225/5366830)
- [containerd系列（五）：containerd 的CNI 网络配置_51CTO博客_containerD](https://blog.51cto.com/flyfish225/5367096)
- [containerd系列（六）：Containerd容器数据持久化存，命名空间共享，与docker的集成_51CTO博客_containerD](https://blog.51cto.com/flyfish225/5367127)
