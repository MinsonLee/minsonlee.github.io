---
layout: post
title: "强大的测网速工具-speedtest"
date: 2020-11-07
tag: Linux
---

`Speedtest`是一款由`Ookla`团队提供用于测试当前计算机互联网连接速度和性能的官方命令行客户端。该工具会下载、上传、延迟和丢包等互联网连接性能指标并可以将结果进行导出。

当然如果是个人电脑也可以直接通过访问[`Speedtest`的官网：https://www.speedtest.net/](https://www.speedtest.net/)直接进行测速。

## 安装speedtest

以下仅展示`Redhat`发行版系列的`Linux`系统安装方式，更多方式请参考：[此处](https://www.speedtest.net/apps/cli)

```sh
# 更新speedtest的镜像信息到本地的yum仓库中，便于使用yum进行安装
sudo curl -l "https://bintray.com/ookla/rhel/rpm" -o /etc/yum.repos.d/bintray-ookla-rhel.repo

# yum 安装 speedtest 工具
sudo yum install speedtest

# 如何使用yum卸载speedtest
# rpm -qa | grep speedtest | xargs -I {} sudo yum -y remove {}

# 验证是否安装成功，看到下图证明安装成功！
speedtest -V
```

![speedtest -V](/images/article/speedtest-v.png)

当然如果你的机器上有安装`Python`版本在`2.4-3.9.0`之间，也可以通过`Python`的`pip`包管理工具进行安装，详情可以参考[`Github`上的指南](https://github.com/sivel/speedtest-cli)

当然如果你只是简单使用一下，而恰好也安装了`Python`那么完全可以直接使用下述命令进行测试
```sh
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3
```

![curl speetest.py by python](/images/article/curl-speedtest-python.png)



## `speedtest` 常用
1. 列出`Speedtest`官方给与的测速服务器列表中，距离当前测速服务器最近的服务器列表
```sh
speedtest --servers
```
![speedtest --servers List nearest servers](/images/article/speedtest-servers.png)

2. 使用指定id的服务器进行测速
```sh
speedtest --server-id=<id number>
```
> speedtest 官方提供的测速服务器列表：http://c.speedtest.net/speedtest-servers-static.php

```text
Speedtest by Ookla is the official command line client for testing the speed and performance of your internet connection.

Version: speedtest 1.0.0.2

Usage: speedtest [<options>]
  -h, --help                        Print usage information
  -V, --version                     Print version number
  -L, --servers                     List nearest servers
  -s, --server-id=#                 Specify a server from the server list using its id
  -I, --interface=ARG               Attempt to bind to the specified interface when connecting to servers
  -i, --ip=ARG                      Attempt to bind to the specified IP address when connecting to servers
  -o, --host=ARG                    Specify a server, from the server list, using its host's fully qualified domain name
  -p, --progress=yes|no             Enable or disable progress bar (Note: only available for 'human-readable'
                                    or 'json' and defaults to yes when interactive)
  -P, --precision=#                 Number of decimals to use (0-8, default=2)
  -f, --format=ARG                  Output format (see below for valid formats)
  -u, --unit[=ARG]                  Output unit for displaying speeds (Note: this is only applicable
                                    for ‘human-readable’ output format and the default unit is Mbps)
  -a                                Shortcut for [-u auto-decimal-bits]
  -A                                Shortcut for [-u auto-decimal-bytes]
  -b                                Shortcut for [-u auto-binary-bits]
  -B                                Shortcut for [-u auto-binary-bytes]
      --selection-details           Show server selection details
      --ca-certificate=ARG          CA Certificate bundle path
  -v                                Logging verbosity. Specify multiple times for higher verbosity
      --output-header               Show output header for CSV and TSV formats

 Valid output formats: human-readable (default), csv, tsv, json, jsonl, json-pretty

 Machine readable formats (csv, tsv, json, jsonl, json-pretty) use bytes as the unit of measure with max precision

 Valid units for [-u] flag:
   Decimal prefix, bits per second:  bps, kbps, Mbps, Gbps
   Decimal prefix, bytes per second: B/s, kB/s, MB/s, GB/s
   Binary prefix, bits per second:   kibps, Mibps, Gibps
   Binary prefix, bytes per second:  kiB/s, MiB/s, GiB/s
   Auto-scaled prefix: auto-binary-bits, auto-binary-bytes, auto-decimal-bits, auto-decimal-bytes
   
   
使用方法：speedtest [<选项>] 。
  -h, --help 打印使用信息
  -V, --版本 打印版本号
  -L, --servers 列出最近的服务器。
  -s, --server-id=# 从服务器列表中使用其id指定一个服务器。
  -I, -interface=ARG 当连接到服务器时，尝试绑定到指定的接口。
  -i, --ip=ARG 当连接到服务器时，尝试绑定到指定的IP地址。
  -o, --host=ARG 从服务器列表中指定一个服务器，使用其主机的完全限定域名。
  -p, --progress=yes|no 启用或禁用进度条 (注意：仅适用于 "人类可读 "的情况或'json'，交互式时默认为是。)
  -P, --precision=# 使用的小数点数量(0-8, 默认=2)
  -f, --format=ARG 输出格式（有效格式见下文）。
  -u, --unit[=ARG] 显示速度的输出单位（注：这只适用于以下情况
                                    为 "人类可读 "的输出格式，默认单位为Mbps)
  -a [-u auto-decimal-bits]的快捷方式。
  -[-u auto-decimal-bytes]的快捷方式。
  -b [-u auto-binary-bits]的快捷方式。
  -B [-u auto-binary-bytes]的快捷方式。
      --selection-details 显示服务器选择的详细信息。
      --ca-certificate=ARG CA证书捆绑路径。
  -v 记录字数。多次指定更高的verbosity。
      --output-header 显示CSV和TSV格式的输出头。

 有效的输出格式。人类可读（默认）、csv、tsv、json、jsonl、json-pretty。

 机器可读格式(csv, tsv, json, jsonl, json-pretty)使用最大精度的字节作为计量单位。

 [-u]标志的有效单位。
   十进制前缀，每秒比特数：bps、kbps、Mbps、Gbps。
   十进制前缀，每秒字节数：B/s, kB/s, MB/s, GB/s。
   二进制前缀，每秒比特数：kibps, Mibps, Gibps。
   二进制前缀，每秒字节数：kiB/s、MiB/s、GiB/s。
   自动缩放前缀：自动二进制位、自动二进制字节、自动十进制位、自动十进制字节。
```