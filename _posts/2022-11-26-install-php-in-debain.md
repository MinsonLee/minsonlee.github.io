---
layout: post
title: "重学编程-PHP”"
date: 2022-11-26
tags: [PHP]
---

[TOC]

# WSL2 Debian 编译安装 PHP 8.1.13(LNMP)

- [php/apache 和 php/nginx的区别](https://cloud.tencent.com/developer/article/1119222)
- [PHP 线程安全与非线程安全版本的区别深入解析](https://m.html.cn/softprog/php/1158307757900.html)

## 安装 PHP

1. 前置准备

```shell
sudo apt update
sudo apt upgrade
```

安装依赖

```shell
sudo apt-get install -y \
 autoconf build-essential curl libtool \
 libssl-dev libcurl4-openssl-dev libsqlite3-dev \
 libxml2-dev libreadline8 libreadline-dev \
 libzip-dev libonig-dev libzip4 openssl \
 pkg-config zlib1g-dev libpng-dev libjpeg-dev \
 libfreetype-dev libsodium-dev libgmp-dev 
```

新增用户

```shell
sudo groupadd -g 500 www # 创建 www 用户组，指定用户组的 groupId 为 500
sudo useradd -u 500 -r -g www -d /home/www www # 创建 www 用户，Id 为 500
passwd www # 设置 www 密码
```

2. 下载安装 `PHP8.1.13`
```shell
sudo mkdir -p /apps/php81 /data/logs/php
cd /apps
wget https://www.php.net/distributions/php-8.1.13.tar.gz
tar -xf php-8.1.13.tar.gz && rm -f php-8.1.13.tar.gz
```

编译安装 `PHP8.1.13`，可以通过 `./configure -h` 查看支持的编译参数

> [configure 这些选项](https://www.php.net/manual/zh/configure.about.php)只用在编译的时候。如果想要修改 PHP 的运行时配置，请阅读 [运行时配置](https://www.php.net/manual/zh/configuration.php)

```shell
$ cd /apps/php-8.1.13
$ ./configure --prefix=/apps/php81 \
    --with-config-file-path=/apps/php81/etc \
    --with-fpm-user=www \
    --with-fpm-group=www \
    --with-freetype=/usr \
    --with-jpeg=/usr \
    --with-libzip=/usr/lib/x86_64-linux-gnu \
    --with-curl \
    --with-openssl \
    --with-pdo-mysql \
    --with-mysqli \
    --with-pdo-mysql=mysqlnd \
    --with-gmp \
    --with-zlib \
    --with-pear \
    --with-readline \
    --with-sodium \
    --with-zip \
    --enable-mysqlnd \
    --enable-gd \
    --enable-iconv \
    --enable-bcmath \
    --enable-fpm \
    --enable-mbstring \
    --enable-opcache \
    --enable-mbstring \
    --enable-phpdbg \
    --enable-shmop \
    --enable-sockets \
    --enable-soap \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-zip \
    --enable-pcntl 

$ make -j # 查看编译结果
$ make && make install
```

3. 配置信息
```shell
cp /apps/php-8.1.13/php.ini-* /apps/php81/etc/
cd /apps/php81/etc
cp php.ini-development php.ini
cp php-fpm.conf.default php-fpm.conf
cp php-fpm.d/www.conf.default www.conf
touch php-fpm.d/env.conf
```

`php.ini` 配置信息，见 [`php.ini`核心配置选项说明](https://www.php.net/manual/zh/ini.core.php)

`php-fpm.conf` 全局配置
```conf
[global]
pid = run/php-fpm.pid
error_log = /data/logs/php/php-fpm.log
syslog.facility = daemon
syslog.ident = php-fpm
log_level = notice
process.priority = -19
daemonize = yes
events.mechanism = epoll

include=/apps/php81/etc/php-fpm.d/*.conf
```

`php-fpm.d/www.conf` 配置 web 配置
```conf
[www]
user = www
group = www
listen = /dev/shm/php8-1-13-fcgi.sock
listen.owner = www
listen.group = www

pm = static
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 2
pm.max_requests = 500
pm.status_path = /status_php_81

slowlog = /data/logs/php/$pool.log.slow
request_slowlog_timeout = 5

rlimit_files = 1024

catch_workers_output = yes
```

`php-fpm.d/env.conf` 配置环境变量

```conf
[www]
env[CURRENT_ENV] = test
env[IS_NEW_TEST_ENV] = 1

;env[MYSQL_HOST] = xxx
;env[MYSQL_USERNAME]= xxx
;env[MYSQL_PASSWORD]= xxx
```

4. 设置软连
```shell
sudo ln -s /apps/php81/bin/php /usr/local/bin/php
```

5. 扩展安装
- 获取或者 Browse Packages ： https://pecl.php.net/packages.php
- 在 `php.ini` 中开启扩展 `extension=memcache`
- 配置： 可以查看 [PHP: 其它服务 - Manual](https://www.php.net/manual/zh/refs.remote.other.php)

```shell
# 安装 memcache
wget http://pecl.php.net/get/memcache && tar -zxvf memcache && cd memcache-* && /apps/php81/bin/phpize
./configure --with-php-config=/apps/php81/bin/php-config
make && make install
```

```shell
# 安装 memcached
sudo apt install -y libmemcached-dev
wget https://pecl.php.net/get/memcached && tar -zxvf memcached && cd memcached-* && /apps/php81/bin/phpize
./configure --with-php-config=/apps/php81/bin/php-config
make && make install
```

```shell
# 安装 Gearman
sudo apt install -y libgearman-dev
wget https://pecl.php.net/get/gearman && tar -zxvf gearman && cd gearman-* && /apps/php81/bin/phpize
./configure --with-php-config=/apps/php81/bin/php-config
make && make install
```

```shell
# 安装 amqp 扩展
sudo apt install -y librabbitmq-dev
wget https://pecl.php.net/get/amqp && tar -zxvf amqp && cd amqp-* && /apps/php81/bin/phpize
./configure --with-php-config=/apps/php81/bin/php-config
make && make install
```

```shell
# 安装 redis 扩展
wget https://pecl.php.net/get/redis && tar -zxvf redis && cd redis-* && /apps/php81/bin/phpize
./configure --with-php-config=/apps/php81/bin/php-config
make && make install
```

```shell
# 安装 mongodb 扩展
wget https://pecl.php.net/get/mongodb && tar -zxvf mongodb && cd mongodb-* && /apps/php81/bin/phpize
./configure --with-php-config=/apps/php81/bin/php-config
make && make install
```

```shell
# 安装 mcrypt 扩展
sudo apt install -y libmcrypt-dev
wget https://pecl.php.net/get/mcrypt && tar -zxvf mcrypt && cd mcrypt-* && /apps/php81/bin/phpize
./configure --with-php-config=/apps/php81/bin/php-config
make && make install
```

```shell
# 安装 timezonedb 扩展
wget https://pecl.php.net/get/timezonedb && tar -zxvf timezonedb && cd timezonedb-* && /apps/php81/bin/phpize
./configure --with-php-config=/apps/php81/bin/php-config
make && make install
```

```shell
# 安装 swoole 扩展
sudo apt install -y librabbitmq-dev
wget https://pecl.php.net/get/swoole && tar -zxvf swoole && cd swoole-* && /apps/php81/bin/phpize
./configure --with-php-config=/apps/php81/bin/php-config
make && make install
```

```shell
# 安装 gRPC 扩展
sudo apt install -y librabbitmq-dev
wget https://pecl.php.net/get/gRPC && tar -zxvf gRPC && cd grpc-* && /apps/php81/bin/phpize
./configure --with-php-config=/apps/php81/bin/php-config
make && make install
```

6. 安装包管理器 `composer`

```php
php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo ln -s /apps/php-composer/composer.phar /usr/local/bin/composer
```

## NGINX

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
- [Nginx Shell 部署文档](https://mp.weixin.qq.com/s/-EPKekSo5qeWE4ASnr3NPQ)

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

