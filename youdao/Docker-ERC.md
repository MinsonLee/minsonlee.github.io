- git@niubibi.easyrentcars.com:erc_docs/php-docker-compose-deployment.git

```
//在/etc/docker下，创建daemon.json文件，写入：

{ "insecure-registries":["172.16.110.32:5000"]}  

//重启docker

service docker restart
```

```sh
cd php-docker-compose-deployment/web && docker-compose up -d
```

![image](50C851A8FE1C43888D8797801C874416)

[host配置]![image](3C330BDE37FB44C99B518B205A0F0CE7)

[目录映射]![image](EE129A62CC954C36999441BC6FAD4002)

### boot2docker用户和密码

| 用户 | 密码 |	进入方式 |
|------|------|----------|
| docker | tcuser | ssh |
|root |  | command：sudo -i (docker用户下执行) |

### 问题
1. 启动报错
```sh
Cannot start service nginx: b'Mounts denied: \r\nThe path /data/htdocs\r\nis not shared from OS X and is not known to Docker.\r\nYou can configure shared paths from Docker -> Preferences... -> File Sharing.\r\nSee https://docs.docker.com/docker-for-mac/osxfs/#namespaces for more info.\r\n.'
```

1. Linux 和 windows 换行符不一致导致的！
2. 目录映射路径没有正确

https://blog.csdn.net/xbinworld/article/details/78945879


2. docker-compose up -d 执行报错
```sh
$ docker-compose up -d
[10764] Failed to execute script docker-compose
Traceback (most recent call last):
  File "docker-compose", line 6, in <module>
  File "compose\cli\main.py", line 71, in main
  File "compose\cli\main.py", line 124, in perform_command
  File "compose\cli\command.py", line 41, in project_from_options
  File "compose\cli\command.py", line 109, in get_project
  File "compose\config\config.py", line 283, in find
  File "compose\config\config.py", line 283, in <listcomp>
  File "compose\config\config.py", line 183, in from_filename
  File "compose\config\config.py", line 1434, in load_yaml
  File "site-packages\yaml\__init__.py", line 94, in safe_load
  File "site-packages\yaml\__init__.py", line 70, in load
  File "site-packages\yaml\loader.py", line 24, in __init__
  File "site-packages\yaml\reader.py", line 85, in __init__
  File "site-packages\yaml\reader.py", line 124, in determine_encoding
  File "site-packages\yaml\reader.py", line 178, in update_raw
UnicodeDecodeError: 'gbk' codec can't decode byte 0xad in position 1770: illegal multibyte sequence
```



## 项目
```sh
# 创建文件
mkdir -p www/htdocs/erc
mkdir -p www/htdocs/lms
```
