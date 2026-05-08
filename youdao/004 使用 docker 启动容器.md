1. 获取镜像：
    - 镜像市场： https://hub.docker.com/，搜索 `hello-world`，选择官方提供的 `hello-world` 案例(https://hub.docker.com/r/dockercloud/hello-world)
    - 拉取镜像： `docker pull dockercloud/hello-world`，但是我发现这样非常慢(可能因为要翻墙的原因)
2. 默认IP/账号/密码：192.168.99.100/docker/tcuser
3. 


- https://trial.docker.com/demo

## 容器
```
# 查看 docker 宿主机版本、容器版本、Go版本、Git版本、Docker镜像最后的提交版本、系统等信息
docker version

# 查看docker软件版本
docker --version
```
![image](4BC6D7509FE543AB8D7AE0B4ECA71403)


``` 
# 在 docker hub 上查找指定镜像
docker search IMAGE
```
![image](B3EB3231D64C466D8A9AFCB473A5F07E)


```
# 拉取 docker 镜像到本地
docker pull IMAGE

# 查看镜像列表
docker images
```
![image](76471FB51D284C46AA3717679842E816)

```sh
# 启动容器
docker container run -it <container_name/container_hash> /bin/bash
# -i 以交互式方式启动进入容器
# -t 切换到容器内部终端
# /bin/bash 启动容器内终端 /bin/bash 程序

# Ctrl + PQ 可以临时退出容器但不会杀死容器
```
![image](18F8448A23E045C6AC51AC697862A217)

```sh
# 查看正在运行的容器
docker container ls
# 查看所有容器
docker container ls -a
```
![image](2D0C9BB9605C40F6A0CB17F74FFE1E1A)

```sh
# 连接到正在运行中的容器的 bash 终端
docker container exec -it <NAMES/CONTAINER ID/> bash
```
![image](E9A6510087EE484F8140FDB396249A89)

```sh
# 停止容器
docker container stop <NAMES/CONTAINER ID/>
```
![image](91459ED3F7BA42B4BB513589C6CC6D6F)

## 初识`Dockerfile`和镜像`images`


```
# 运行 docker 并安装 ping 命令（此处默认 Ubuntu）
docker run IMAGE apt-get install -y ping
```

```
# 查看当前 docker 运行的进程
docker ps -l
```

```
# 提交新版本的 docker，并命名新提交的 docker，成功后悔得到一个新的 Docker commit ID
docker commit DOCKERID IMAGE_NAME
```

```
# 运行新的 docker 并运行 ping 命令
docker run IMAGE_NAME ping www.google.com
# ping 命名会一直运行在 docker 内部，docker 是不支持在客户端直接 ctrl+c 停止 docker 运行的
```

```
# 查看 docker 内部运行的容器
docker inspect DOCKER_ID
```

```
# 查看当前 docker 运行的容器及其状态
docker images
```

```
# 将指定的 docker 镜像提交推送到仓库中
docker push IMAGE_NAME
```

