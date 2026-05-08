---
- layout: post
- title: "重学编程-Nginx"
- date: 2022-11-26
- tags: [PHP]
---

# 重学编程-Nginx

[TOC]

发现的好文章：

- [Nginx Shell 部署文档](https://mp.weixin.qq.com/s/-EPKekSo5qeWE4ASnr3NPQ)
- [神器 Nginx 的学习手册 ( 建议收藏 )](https://mp.weixin.qq.com/s/P4095a9SPVy0ZO5YFanJcQ)
- [朱双印的个人日志-Nginx](https://www.zsythink.net/archives/category/%e8%bf%90%e7%bb%b4%e7%9b%b8%e5%85%b3/nginx)
- [万字总结，体系化带你全面认识 Nginx ！](https://juejin.cn/post/6942607113118023710)
- [Nginx的跨域问题解决](https://mp.weixin.qq.com/s/AIDARsbuMUdEydr1iKjoOg)
- [一次线上ngix的504 gateway timeout排查](https://juejin.cn/post/7113402607409823752)
- [万字多图，搞懂 Nginx 高性能网络工作原理！](https://mp.weixin.qq.com/s/AX6Fval8RwkgzptdjlU5kg)
- [NGINX引入线程池 性能提升9倍](https://linux.cn/article-5684-1.html)
- [Nginx 这些问题你都实践过吗？](https://mp.weixin.qq.com/s/tQzFNQa3witNEDt5r9g_3w)
- [技术选型实战|BFE vs Nginx](https://mp.weixin.qq.com/s/IxGrbG6Jqtpet3hjfG8iOQ)
- [京东一面：Nginx 禁止国外 IP 访问网站！](https://mp.weixin.qq.com/s/HagZjWZ2wR-CdvLhjYiY4Q)
- [Nginx作为静态资源web服务，控制浏览器缓存、防盗链，你该如何配置](https://mp.weixin.qq.com/s/HflM39rVNkICpVjtYRmNMA)
- [使用 Kubernetes Ingress-Nginx 实现蓝绿、灰度发布！你会用了吗？](https://mp.weixin.qq.com/s/vAxJaV-1n9-fwoMOWzoCJw)
- [2.3W字，这可能是把Nginx讲得最全面的一篇文章了，建议收藏备用](https://mp.weixin.qq.com/s/_QJ2IkTP42RReJ4s7nduwA)
- [Nginx一网打尽：动静分离、压缩、缓存、黑白名单、跨域、高可用、性能优化...](https://mp.weixin.qq.com/s/W5y43U__o0BBFam3SBFaGQ)
- [Nginx 跨域配置](https://www.cnblogs.com/itzgr/p/13343387.html)
- [跨源资源共享（CORS）](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CORS)
- [OpenResty 科普](https://juejin.cn/post/7124986878432018469)
- [简单聊聊从 nginx 到 kong 的进化](https://mp.weixin.qq.com/s/BGzlJh8MIYnqZgDu8kE0Bg)
- [Nginx 的五大应用场景](https://mp.weixin.qq.com/s/WptxOa2ktXFX1rc3CGizHg)
- [Nginx代理转发Mysql](https://cloud.tencent.com/developer/article/1768431)
- [nginx 是怎么禁止访问php的](https://mp.weixin.qq.com/s/2kcOwlawYk1XgtKJM3MzJw)
- [为什么 NGINX 的 reload 命令不是热加载？](https://mp.weixin.qq.com/s/0RPpiywDYKEpVpivyeNKzg)
- [Nginx为什么快到根本停不下来？](https://mp.weixin.qq.com/s/HDQfcZ7JFzEH5mjDzvMO4g)
- [Nginx原理性科普](https://juejin.cn/post/7114474020765958181)
- [Nginx 架构原理科普](https://mp.weixin.qq.com/s/Q5Ar9y1a_fTUwb9j_85RDw)
- [Nginx 配置文件 nginx.conf 详解](https://mp.weixin.qq.com/s/Crj2Xo8-EJpbq40kXronug)
- [服务器排障 之 nginx 499 错误的解决](https://blog.51cto.com/yucanghai/1713803)
- Nginx 是什么？有什么优势和功能？
- Nginx 是如何处理一个 HTTP 请求的？
- [API 网关从入门到放弃](https://mp.weixin.qq.com/s/xFMn-Sd5RVOEogDJHf_HVg)，网关 和 NGINX 有什么区别？
- [有了 NGINX 和 Kong，为什么还需要 Apache APISIX](https://www.apiseven.com/blog/why-we-need-Apache-APISIX)
- https://apisix.apache.org/zh/
- [Apache APISIX 架构分析：如何动态管理 Nginx 集群？](https://apisix.apache.org/zh/blog/2021/08/10/apisix-nginx/)

## 需要梳理做笔记的问题

1. 我希望访问在同一个域名 `local.laravel` 同时访问两个 laravel 项目，`local.laravel/9/` 访问 laravelv9.0.x，`local.laravel/10/` 访问 laravelv10.0.x，默认访问 laravelv10.0.x，要如何配置？

```conf
server {
    listen 80;
    server_name local.laravel;

    location /9 {
        root /var/www/laravel-9/public;
        try_files $uri $uri/ /index.php?$query_string;
        index index.php;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        include fastcgi_params;
    }

    location /10 {
        root /var/www/laravel-10/public;
        try_files $uri $uri/ /index.php?$query_string;
        index index.php;
        fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        include fastcgi_params;
    }

    error_log /var/log/nginx/local.laravel_error.log;
    access_log /var/log/nginx/local.laravel_access.log;
}
```

2. 当我访问 `http://local.laravel/9` 时总是被 301 到 `http://local.laravel/9/` 是为什么

默认情况下，nginx将所有没有斜杠的URL重定向到相应的斜杠URL。例如，当您访问http://local.laravel/9时，nginx会自动重定向到http://local.laravel/9/。这是因为nginx认为URI应该以斜杠结尾，以便在处理相对路径时更加简单和一致。

要禁用此行为，可以在您的nginx配置中添加以下指令：

```conf
server {
    ...
    add_trailing_slash off;
    ...
}

```

## Nginx 能干嘛？




## Nginx 安装

安装依赖

```shell
mkdir -p /apps/nginx /data/logs/nginx && cd /apps
sudo apt install -y build-essential libpcre3 libpcre3-dev zlib1g-dev openssl libssl-dev libxml2-dev libxslt1-dev
```

下载源码：[nginx documentation](http://nginx.org/en/docs/)

```shell
wget https://nginx.org/download/nginx-1.22.1.tar.gz && tar -zxvf nginx-1.22.1.tar.gz && rm nginx-1.22.1.tar.gz

wget https://github.com/wandenberg/nginx-push-stream-module/archive/refs/tags/0.5.5.tar.gz && tar -zxvf nginx-push-stream-module-0.5.5.tar.gz && rm nginx-push-stream-module-0.5.5.tar.gz
```

配置&&编译，配置参数可以参考 [Nginx 官方 configure 说明](http://nginx.org/en/docs/configure.html)，也可以通过 `./configure --help` 查看说明（[Nginx模块-HTTP Push Stream | NGINX](https://www.nginx.com/resources/wiki/modules/push_stream/))）


```shell
cd nginx-1.22*/
./configure \
--prefix=/apps/nginx1.22 \
--sbin-path=/apps/nginx1.22/sbin/nginx \
--pid-path=/apps/nginx1.22/nginx.pid \
--lock-path=/apps/nginx1.22/nginx.lock \
--conf-path=/apps/nginx1.22/conf/nginx.conf \
--error-log-path=/data/logs/nginx/error.log \
--user=www \
--group=www \
--with-file-aio \
--with-threads \
--with-http_addition_module \
--with-http_auth_request_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_mp4_module \
--with-http_random_index_module \
--with-http_realip_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_sub_module \
--with-http_v2_module \
--with-mail \
--with-mail_ssl_module \
--with-stream \
--with-stream_realip_module \
--with-stream_ssl_module \
--with-stream_ssl_preread_module \
--add-module=/apps/nginx-push-stream-module-0.5.5

make && make install
```

- 启动 nginx ： /apps/nginx1.22/sbin/nginx
- 停止 nginx ： /apps/nginx1.22/sbin/nginx -s quit
- 重启 nginx ： /apps/nginx1.22/sbin/nginx -s reload
- 重启日志 ： /apps/nginx1.22/sbin/nginx -s reopen

> `reload` 重新检查加载配置文件（若配置文件错误则继续保持当前配置正常运行），采用滚动发布方式，Nginx 会使用新配置启动新的工作主进程，并向旧的工作进程发送关闭信号。当旧进程收到关闭信号后，它将会停止接受新的请求，并在处理完旧请求的自行退出；
>
> `reopen` 滚动日志，当Nginx的日志文件过大，我们将日志文件 `mv` 到其他位置后会发现日志文件仍在写入，这是由于`mv`后的文件 inode 相关信息不变，因此 Nginx 还会将日志写入到该文件中。这时我们就可以执行 `reopen` 操作，Nginx 就会关闭原来的句柄，在配置的日志目录下重新创建新的日志文件来进行日志记录。`inode` 相当于一个文件的身份证号，文件路径只是相当于一个住址而已。

- 查看 Nginx 进程 ： ps -ef | grep nginx 或 ps -ax | grep nginx
- [Nginx系列之nginx信号控制 (aiopsclub.com)](https://www.aiopsclub.com/nginx/nginx_signal/)


## 将 Nginx 注册为 System/init.d 服务

将 Nginx 注册为 System 服务 （通过 systemd 服务用 systemctl 管理，通过 放在：/lib/systemd/system/nginx.service或/etc/systemd/system/nginx.service）

```shell
ExecStart=
ExecReload=/apps/nginx1.22/sbin/nginx -s reload
ExecStop=/apps/nginx1.22/sbin/nginx -s quit
ps
/apps/nginx1.22/sbin/nginx -V # 查看编译参数

sudo vi /lib/systemd/system/nginx.service  #写入如下内容
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target
[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/bin/sh -c "/bin/kill -s HUP $(/bin/cat /usr/local/nginx/logs/nginx.pid)"
ExecStop=/bin/sh -c "/bin/kill -s TERM $(/bin/cat /usr/local/nginx/logs/nginx.pid)"
[Install]
WantedBy=multi-user.target
```

注册后需要 `systemctl daemon-reload` 重新加载服务，然后就可以通过 `systemctl start|stop|reload nginx`

如果想通过 service 进行管理 nginx 服务（通过 init.d 用 service 管理，在 /etc/init.d/nginx）

```shell
# Download nginx startup script
wget -O init-deb.sh https://www.linode.com/docs/assets/660-init-deb.sh

# Move the script to the init.d directory & make executable
sudo mv init-deb.sh /etc/init.d/nginx
sudo chmod +x /etc/init.d/nginx

# Add nginx to the system startup
sudo /usr/sbin/update-rc.d -f nginx defaults

# service nginx start
# service nginx stop
# service nginx reload
# 不支持 status 
```

可参考 docker 的脚本自行实现

```
❯ cat /etc/init.d/docker
#!/bin/sh
set -e

### BEGIN INIT INFO
# Provides:           docker
# Required-Start:     $syslog $remote_fs
# Required-Stop:      $syslog $remote_fs
# Should-Start:       cgroupfs-mount cgroup-lite
# Should-Stop:        cgroupfs-mount cgroup-lite
# Default-Start:      2 3 4 5
# Default-Stop:       0 1 6
# Short-Description:  Create lightweight, portable, self-sufficient containers.
# Description:
#  Docker is an open-source project to easily create lightweight, portable,
#  self-sufficient containers from any application. The same container that a
#  developer builds and tests on a laptop can run at scale, in production, on
#  VMs, bare metal, OpenStack clusters, public clouds and more.
### END INIT INFO

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

BASE=docker

# modify these in /etc/default/$BASE (/etc/default/docker)
DOCKERD=/usr/bin/dockerd
# This is the pid file managed by docker itself
DOCKER_PIDFILE=/var/run/$BASE.pid
# This is the pid file created/managed by start-stop-daemon
DOCKER_SSD_PIDFILE=/var/run/$BASE-ssd.pid
DOCKER_LOGFILE=/var/log/$BASE.log
DOCKER_OPTS=
DOCKER_DESC="Docker"

# Get lsb functions
. /lib/lsb/init-functions

if [ -f /etc/default/$BASE ]; then
        . /etc/default/$BASE
fi

# Check docker is present
if [ ! -x $DOCKERD ]; then
        log_failure_msg "$DOCKERD not present or not executable"
        exit 1
fi

check_init() {
        # see also init_is_upstart in /lib/lsb/init-functions (which isn't available in Ubuntu 12.04, or we'd use it directly)
        if [ -x /sbin/initctl ] && /sbin/initctl version 2>/dev/null | grep -q upstart; then
                log_failure_msg "$DOCKER_DESC is managed via upstart, try using service $BASE $1"
                exit 1
        fi
}

fail_unless_root() {
        if [ "$(id -u)" != '0' ]; then
                log_failure_msg "$DOCKER_DESC must be run as root"
                exit 1
        fi
}

cgroupfs_mount() {
        # see also https://github.com/tianon/cgroupfs-mount/blob/master/cgroupfs-mount
        if grep -v '^#' /etc/fstab | grep -q cgroup \
                || [ ! -e /proc/cgroups ] \
                || [ ! -d /sys/fs/cgroup ]; then
                return
        fi
        if ! mountpoint -q /sys/fs/cgroup; then
                mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup
        fi
        (
                cd /sys/fs/cgroup
                for sys in $(awk '!/^#/ { if ($4 == 1) print $1 }' /proc/cgroups); do
                        mkdir -p $sys
                        if ! mountpoint -q $sys; then
                                if ! mount -n -t cgroup -o $sys cgroup $sys; then
                                        rmdir $sys || true
                                fi
                        fi
                done
        )
}

case "$1" in
        start)
                check_init

                fail_unless_root

                cgroupfs_mount

                touch "$DOCKER_LOGFILE"
                chgrp docker "$DOCKER_LOGFILE"

                ulimit -n 1048576

                # Having non-zero limits causes performance problems due to accounting overhead
                # in the kernel. We recommend using cgroups to do container-local accounting.
                if [ "$BASH" ]; then
                        ulimit -u unlimited
                else
                        ulimit -p unlimited
                fi

                log_begin_msg "Starting $DOCKER_DESC: $BASE"
                start-stop-daemon --start --background \
                        --no-close \
                        --exec "$DOCKERD" \
                        --pidfile "$DOCKER_SSD_PIDFILE" \
                        --make-pidfile \
                        -- \
                                -p "$DOCKER_PIDFILE" \
                                $DOCKER_OPTS \
                                        >> "$DOCKER_LOGFILE" 2>&1
                log_end_msg $?
                ;;

        stop)
                check_init
                fail_unless_root
                if [ -f "$DOCKER_SSD_PIDFILE" ]; then
                        log_begin_msg "Stopping $DOCKER_DESC: $BASE"
                        start-stop-daemon --stop --pidfile "$DOCKER_SSD_PIDFILE" --retry 10
                        log_end_msg $?
                else
                        log_warning_msg "Docker already stopped - file $DOCKER_SSD_PIDFILE not found."
                fi
                ;;

        restart)
                check_init
                fail_unless_root
                docker_pid=`cat "$DOCKER_SSD_PIDFILE" 2>/dev/null`
                [ -n "$docker_pid" ] \
                        && ps -p $docker_pid > /dev/null 2>&1 \
                        && $0 stop
                $0 start
                ;;

        force-reload)
                check_init
                fail_unless_root
                $0 restart
                ;;

        status)
                check_init
                status_of_proc -p "$DOCKER_SSD_PIDFILE" "$DOCKERD" "$DOCKER_DESC"
                ;;

        *)
                echo "Usage: service docker {start|stop|restart|status}"
                exit 1
                ;;
esac
```

通过 service 启停查看 nginx `/etc/init.d/nginx`

```shell
#! /bin/sh

PATH=/apps/nginx/sbin:/sbin:/bin:/usr/sbin:/usr/bin
APPS=/apps/nginx1.22
NAME=nginx
DESC=nginx
PID_FILE=$APPS/$NAME.pid
DAEMON=$APPS/sbin/nginx

# Get lsb functions
. /lib/lsb/init-functions

test -x $DAEMON || exit 0

# Include nginx defaults if available
if [ -f /etc/default/$NAME ] ; then
        . /etc/default/$NAME
fi

set -e

case "$1" in
  start)
        echo -n "Starting $DESC: "
        start-stop-daemon --start --quiet --pidfile /opt/nginx/logs/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon --stop --quiet --pidfile /opt/nginx/logs/$NAME.pid --exec $DAEMON
        echo "$NAME."
        ;;
  restart|force-reload)
        echo -n "Restarting $DESC: "
        start-stop-daemon --stop --quiet --pidfile /opt/nginx/logs/$NAME.pid --exec $DAEMON
        sleep 1
        start-stop-daemon --start --quiet --pidfile /opt/nginx/logs/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;
  reload)
          echo -n "Reloading $DESC configuration: "
          start-stop-daemon --stop --signal HUP --quiet --pidfile /opt/nginx/logs/$NAME.pid --exec $DAEMON
          echo "$NAME."
          ;;
  status)
          status_of_proc -p "$PID_FILE" "$DAEMON" "$DESC"
          ;;
  *)
          N=/etc/init.d/$NAME
          echo "Usage: $N {start|stop|restart|reload|force-reload}" >&2
          exit 1
          ;;
    esac

    exit 0
```




> 推荐阅读：[Nginx配置文件的结构和最佳做法](https://www.myfreax.com/how-to-install-nginx-on-debian-10/)

根据上述文章，我的配置文件结构如下：


- Nginx配置文件存储在 `/apps/nginx1.22/conf/nginx.conf`
- 虚拟主机配置：[如何在Debian 10配置Nginx虚拟主机 | myfreax](https://www.myfreax.com/how-to-set-up-nginx-server-blocks-on-debian-10/)
  - 虚拟主机配置文件统一存储在 `conf/sites-available/*.conf`
  - 将 `conf/sites-available` 链接到 `conf/sites-enabled`目录 时，启用配置
  - 命名规范：`域名.conf`
- 日志统一存放路径：`/data/logs/nginx/*.log`（access.log 分域名存储不同的 log 文件中）
- [如何使用mkcert创建SSL证书 | myfreax](https://www.myfreax.com/how-to-create-locally-trusted-ssl-certificates-on-linux-and-macos-with-mkcert/)
- [Nginx——访问日志、错误日志、日志文件切割](https://blog.csdn.net/cold___play/article/details/106713416)


```nginx
user www www;
worker_processes  auto;
worker_rlimit_nofile 51200;
error_log  /data/logs/nginx/nginx_error.log error; # error_log 错误等级：debug info notice error

pid        /apps/nginx1.22/nginx.pid;

events {
    use epoll;
    multi_accept on;
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format    main    '$remote_addr - $remote_user [$time_local] "$host" "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for" '
                          'responsetime=$request_time';

    log_format    access    '$request_time|$remote_addr|$remote_user|$host|[$time_local]|$request|'
                            '$status|$body_bytes_sent|$http_referer|$http_x_forwarded_for|'
                            '$upstream_addr|$upstream_status|$upstream_response_time|'
                            '"$http_user_agent"|$request_body|$scheme';

    log_format    access-debug    '$request_time|$remote_addr|$remote_user|$host|[$time_local]|$request|'
                                  '$status|$body_bytes_sent|$http_referer|$http_x_forwarded_for|'
                                  '$upstream_addr|$upstream_status|$upstream_response_time|'
                                  '"$http_user_agent"|$request_body|$scheme|$http_if_modified_since';

    # access_log /data/logs/nginx/nginx_access_log.log;
    sendfile       on;
    tcp_nopush     on;
    tcp_nodelay    on;
    keepalive_timeout  10;

    gzip  on;
    gzip_static  on;
    gzip_proxied any;
    gzip_min_length 1k;
    gzip_buffers    4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types  text/plain application/javascript application/x-javascript text/javascript text/css application/xml application/json;
    gzip_vary  on;

    push_stream_shared_memory_size 128M;
    push_stream_max_channel_id_length 200;
    push_stream_max_messages_stored_per_channel 1;
    push_stream_message_ttl 1m;

    include sites-enabled/*.conf;
    add_header hostname $hostname always;
    port_in_redirect off; # 302 重定向时，不自动加上当前URL的端口
    add_header X-Frame-Options DENY; # 站点是否允许用 iframe 嵌套使用（DENY-不允许；SAMEORIGIN-同源允许；ALLOW-FROM <uri> - 指定链接允许）
}
```

## Nginx 调试技巧

- [Nginx调试必备](https://cloud.tencent.com/developer/article/1644736)
- [「Nginx」- 配置调试（打印查看、配置验证、Debug）](https://blog.k4nz.com/ede1cb3a6ee3609298844c335e05d197)


- 方式一：【推荐/常用】通过 NGINX 的日志来查看（[Nginx Configuring Logging](https://docs.nginx.com/nginx/admin-guide/monitoring/logging/)、[Module ngx_http_log_module](http://nginx.org/en/docs/http/ngx_http_log_module.html)）
- 方法二：通过 `add_header <key> "<value>"` 方式
- 方式三：通过 `return <HTTP_CODE> "<value>"` 方式
- 方式四：通过 [Debugging NGINX](https://docs.nginx.com/nginx/admin-guide/monitoring/debugging/)
- 方式五：编译 [echo 模块](https://github.com/openresty/echo-nginx-module)（实际和方式二、三区别不大）
- 方式六：编译 lua 模块支持（可以用 lua 实现一些其他的功能，如 openresty 就是 Nginx + Lua）

## 推荐的文章

- [为什么 NGINX 的 reload 命令不是热加载？](https://mp.weixin.qq.com/s/0RPpiywDYKEpVpivyeNKzg)
- [Nginx实践之使用MaxMind的GeoIP2实现处理不同国家或城市的访问最佳实践指南](https://blog.weiyigeek.top/2022/7-3-678.html)
