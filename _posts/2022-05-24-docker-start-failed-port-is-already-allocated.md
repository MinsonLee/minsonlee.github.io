---
layout: post
title: "Docker 启动错误：Bind for xxx failed“port is already allocated”"
date: 2022-05-24
tags: [Docker]
---

早上启动 Docker 容器时，报错信息如下：

```sh
lms@LMS:/docker/erc-docker$ ./app.sh start
Starting erc_php74 ...
Starting erc_php74 ... error

ERROR: for erc_php74  Cannot start service erc_php74: driver failed programming external connectivity on endpoint erc_php74 (b29cfd755ce5c654b162fec96b7b8475f9e276586bcdd902e38c6f0eb84cb38d): Bind for 0.0.0.0:443 failed: port is already allocated

ERROR: for erc_php74  Cannot start service erc_php74: driver failed programming external connectivity on endpoint erc_php74 (b29cfd755ce5c654b162fec96b7b8475f9e276586bcdd902e38c6f0eb84cb38d): Bind for 0.0.0.0:443 failed: port is already allocated
ERROR: Encountered errors while bringing up the project.
```

通过 `docker ps` 发现当下是没有任何容器在运行着的，预想应该是跟我昨晚强制重新关机有关，可能有服务没有正常退出导致 443 端口一直被占用没有释放。

```sh
su # 切换到 root 用户

root@LMS:/docker/erc-docker# lsof -i:443
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
docker-pr 281 root    4u  IPv4  19790      0t0  TCP *:https (LISTEN)

root@LMS:/docker/erc-docker# netstat -apn | grep 443
tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN      281/docker-proxy

root@LMS:/docker/erc-docker# ps -aux | grep -v grep | grep 443
root       281  0.0  0.1 1222836 11700 ?       Sl   09:19   0:00 /bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 443 -container-ip 172.19.0.2 -container-port 443
```

通过 `lsof` 或 `netstat` 发现 `443` 端口果然没有释放，被 `docker-proxy` 占用着。

```sh
# 1. 停止 docker 服务
sudo service docker stop

# 2. 删除 docker-proxy 的 db 文件
sudo rm -f /var/lib/docker/network/files/local-kv.db

# 3. 重启 docker 服务
sudo service docker start
```

重新启动容器即可。

推荐阅读：

- [docker-proxy存在合理性分析](https://www.jianshu.com/p/91002d316185)
- [理解Docker容器端口映射](https://tonybai.com/2016/01/18/understanding-binding-docker-container-ports-to-host/)