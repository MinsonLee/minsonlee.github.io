## `Docker`客户端命令：`docker`
### `Docker`系统信息
```sh
docker info # 查看当前系统`Docker`信息：系统、版本、CPU、占用磁盘空间、镜像数、容器实例数...
docker version # 查看`Docker`的版本信息(包括Client、Server)-一般用于验证`Docker`服务是否安装成功
```

### `Docker`镜像信息
#### 远程镜像

#### 本地镜像
```sh
docker images # 查看本地已存在的镜像
```

### `Docker`容器信息
```sh
docker attach
docker config 
docker create 
docker exec 
docker image 
docker inspect 
docker logout 
docker node 
docker ps 
docker restart 
docker save 
docker stack 
docker swarm 
docker trust 
docker volume 
docker build
docker container 
docker diff 
docker export 
docker images 
docker kill 
docker logs 
docker pause 
docker pull 
docker rm 
docker search 
docker start 
docker system 
docker unpause 
docker wait 
docker builder
docker context 
docker engine 
docker help 
docker import 
docker load 
docker manifest 
docker plugin 
docker push 
docker rmi 
docker secret 
docker stats 
docker tag 
docker update 
docker commit
docker cp 
docker events 
docker history 
docker info 
docker login 
docker network 
docker port 
docker rename 
docker run 
docker service 
docker stop 
docker top 
docker version
```


- docker rename image `docker tag <old-img>[:version] myname:latest && docker rmi <old-img>`

从主机复制到容器`sudo docker cp host_path containerID:container_path`

从容器复制到主机`sudo docker cp containerID:container_path host_path`

## Docker 服务端命令：`dockerd`
```sh
Flag shorthand -h has been deprecated, please use --help

Usage:  dockerd [OPTIONS]

A self-sufficient runtime for containers.

Options:
      --add-runtime runtime                     Register an additional OCI compatible runtime (default [])
      --allow-nondistributable-artifacts list   Allow push of nondistributable artifacts to registry
      --api-cors-header string                  Set CORS headers in the Engine API
      --authorization-plugin list               Authorization plugins to load
      --bip string                              Specify network bridge IP
  -b, --bridge string                           Attach containers to a network bridge
      --cgroup-parent string                    Set parent cgroup for all containers
      --cluster-advertise string                Address or interface name to advertise
      --cluster-store string                    URL of the distributed storage backend
      --cluster-store-opt map                   Set cluster store options (default map[])
      --config-file string                      Daemon configuration file (default "/etc/docker/daemon.json")
      --containerd string                       containerd grpc address
      --cpu-rt-period int                       Limit the CPU real-time period in microseconds
      --cpu-rt-runtime int                      Limit the CPU real-time runtime in microseconds
      --cri-containerd                          start containerd with cri
      --data-root string                        Root directory of persistent Docker state (default "/var/lib/docker")
  -D, --debug                                   Enable debug mode
      --default-address-pool pool-options       Default address pools for node specific local networks
      --default-gateway ip                      Container default gateway IPv4 address
      --default-gateway-v6 ip                   Container default gateway IPv6 address
      --default-ipc-mode string                 Default mode for containers ipc ("shareable" | "private") (default "private")
      --default-runtime string                  Default OCI runtime for containers (default "runc")
      --default-shm-size bytes                  Default shm size for containers (default 64MiB)
      --default-ulimit ulimit                   Default ulimits for containers (default [])
      --dns list                                DNS server to use
      --dns-opt list                            DNS options to use
      --dns-search list                         DNS search domains to use
      --exec-opt list                           Runtime execution options
      --exec-root string                        Root directory for execution state files (default "/var/run/docker")
      --experimental                            Enable experimental features
      --fixed-cidr string                       IPv4 subnet for fixed IPs
      --fixed-cidr-v6 string                    IPv6 subnet for fixed IPs
  -G, --group string                            Group for the unix socket (default "docker")
      --help                                    Print usage
  -H, --host list                               Daemon socket(s) to connect to
      --icc                                     Enable inter-container communication (default true)
      --init                                    Run an init in the container to forward signals and reap processes
      --init-path string                        Path to the docker-init binary
      --insecure-registry list                  Enable insecure registry communication
      --ip ip                                   Default IP when binding container ports (default 0.0.0.0)
      --ip-forward                              Enable net.ipv4.ip_forward (default true)
      --ip-masq                                 Enable IP masquerading (default true)
      --iptables                                Enable addition of iptables rules (default true)
      --ipv6                                    Enable IPv6 networking
      --label list                              Set key=value labels to the daemon
      --live-restore                            Enable live restore of docker when containers are still running
      --log-driver string                       Default driver for container logs (default "json-file")
  -l, --log-level string                        Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --log-opt map                             Default log driver options for containers (default map[])
      --max-concurrent-downloads int            Set the max concurrent downloads for each pull (default 3)
      --max-concurrent-uploads int              Set the max concurrent uploads for each push (default 5)
      --metrics-addr string                     Set default address and port to serve the metrics api on
      --mtu int                                 Set the containers network MTU
      --network-control-plane-mtu int           Network Control plane MTU (default 1500)
      --no-new-privileges                       Set no-new-privileges by default for new containers
      --node-generic-resource list              Advertise user-defined resource
      --oom-score-adjust int                    Set the oom_score_adj for the daemon (default -500)
  -p, --pidfile string                          Path to use for daemon PID file (default "/var/run/docker.pid")
      --raw-logs                                Full timestamps without ANSI coloring
      --registry-mirror list                    Preferred Docker registry mirror
      --rootless                                Enable rootless mode; typically used with RootlessKit (experimental)
      --seccomp-profile string                  Path to seccomp profile
      --selinux-enabled                         Enable selinux support
      --shutdown-timeout int                    Set the default shutdown timeout (default 15)
  -s, --storage-driver string                   Storage driver to use
      --storage-opt list                        Storage driver options
      --swarm-default-advertise-addr string     Set default address or interface for swarm advertised address
      --tls                                     Use TLS; implied by --tlsverify
      --tlscacert string                        Trust certs signed only by this CA (default "/home/lms/.docker/ca.pem")
      --tlscert string                          Path to TLS certificate file (default "/home/lms/.docker/cert.pem")
      --tlskey string                           Path to TLS key file (default "/home/lms/.docker/key.pem")
      --tlsverify                               Use TLS and verify the remote
      --userland-proxy                          Use userland proxy for loopback traffic (default true)
      --userland-proxy-path string              Path to the userland proxy binary
      --userns-remap string                     User/Group setting for user namespaces
  -v, --version                                 Print version information and quit
  ```


## Docker 编排工具：`docker-composer`
```sh
Options:
  -f, --file FILE             Specify an alternate compose file
                              (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name
                              (default: directory name)
  -c, --context NAME          Specify a context name
  --verbose                   Show more output
  --log-level LEVEL           Set log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
  --no-ansi                   Do not print ANSI control characters
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to

  --tls                       Use TLS; implied by --tlsverify
  --tlscacert CA_PATH         Trust certs signed only by this CA
  --tlscert CLIENT_CERT_PATH  Path to TLS certificate file
  --tlskey TLS_KEY_PATH       Path to TLS key file
  --tlsverify                 Use TLS and verify the remote
  --skip-hostname-check       Don't check the daemon's hostname against the
                              name specified in the client certificate
  --project-directory PATH    Specify an alternate working directory
                              (default: the path of the Compose file)
  --compatibility             If set, Compose will attempt to convert keys
                              in v3 files to their non-Swarm equivalent (DEPRECATED)
  --env-file PATH             Specify an alternate environment file

Commands:
  build              Build or rebuild services
  config             Validate and view the Compose file
  create             Create services
  down               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  images             List images
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  version            Show version information and quit
```