---
layout: post
title: Web压测工具-ApacheBench（ab）
date: 2021-01-15
tags: [Tools,ab,压力测试,高并发]
---

[`Apache Bench（ab）`](https://www.tutorialspoint.com/apache_bench/index.htm)是一个对`HTTP Web`服务器（**基于`HTTP/HTTPS`协议**）进行负载测试和基准测试的**开源免费、跨平台**的**单线程**命令行工具。

如果此前你已经安装了 `Apache Web Server`，那么 `ab` 工具应该也是一起自动安装了的。当然`ab`也可以单独作为`Apache`实用工具单独安装。

**注意：**

1. `ab`的负载测试类似于`DOS`攻击，没有指令可以在运行测试时按特定间隔增加/减少并发性（即：不能梯度加压测试或梯度减压测试-[JMeter可以实现加压测试](https://blog.csdn.net/qq_36396763/article/details/89472691)，但使用上没有`ab`简单）
2. 不论将 `ab` 的并发数设置到多大，`ab` 始终是通过**单线程**的方式来执行的，因此：当需要进行量级非常大的高并发测试时，`ab`本身单线程的处理能力却成了瓶颈从而导致**并发测试结果不准确**（一下子发起的请求或请求返回来的结果太多，`ab`自身处理不过来）！

> 原句：Apache Bench uses only one operating system thread irrespective of the concurrency level (specified by the -c flag). Therefore, when benchmarking high-capacity servers, a single instance of Apache Bench can itself be a bottleneck. To completely saturate the target URL, it is better to use additional instances of Apache Bench in parallel, if your server has multiple processor cores.

因此：`ab` 更适合**单一`URL`**的非精准压力测试！

## 安装

```sh
# Ubuntu/Debian
apt-get install apache2-utils

# RHEL/CentOS/Fedora
yum -y install httpd-tools
```

安装完毕之后，可以使用 `ab -V` 或 `ab -h` 验证安装是否成功！

![ab-verify-apache-bench-installation.png](/images/article/ab-verify-apache-bench-installation.png)

## 使用说明

`ab` 的功能定位都很简单，用法：`ab [options] [http[s]://]hostname[:port]/path`。

![ab-multiple-requests-testing.png](/images/article/ab-multiple-requests-testing.png)

## 参数

### 请求设置

| 参数 | 作用 |
| ---- | ---- |
| -X <proxy:port> | 设置代理信息 |
| -P <proxy_user:proxy_password> | 设置代理网络认证 |
| -A <user:password> |  添加基本网络请求认证 |
| -E <certfile> |  指定客户端私钥证书 |
| -B <address> |  绑定出口`IP`地址 |
| -H <Header_string> |  设置额外请求头信息，如：'Accept-Encoding: gzip' （该参数可重复添加多个值）|
| -C <key=value> | 为请求头附加`Cookie`信息（该参数可重复添加多个值） |
| -n <requests> |  发起的请求次数 |
| -c <concurrency> |  并发请求数（！！！注意：并发数设置不能大于请求总数） |
| -t <timelimit> |  设置整个测试过程的时间限制-默认没有限制 |
| -s <timeout> |  设置测试过程中每一个请求的等待时间-默认为 30 秒 |
| -b <windowsize> |  设置`TCP`发送/接收缓冲区的大小，单位-字节 |
| -T <content-type> |  为`POST/PUT`请求设置`Header`中的`Content-type`。如：`'application/x-www-form-urlencoded'`-默认`'text/plain'` |
| -k | 使用 `HTTP KeepAlive` 持久连接功能 |
| -i |  使用 `HEAD` 而不是 `GET` 请求方式 |
| -m <method> | 设置`HTTP`请求方法 |
| -p <postfile> |  `POST`请求的文件数据（**记得设置`-T`参数**） |
| -u <putfile> |  `PUT`请求的文件数据 （**记得设置`-T`参数**） |

### 打印结果

| 参数 | 作用 |
| ---- | ---- |
| -v <verbosity_level> |  设置输出信息的详细程度（1-打印测试结果；2-在上一个等级基础上额外增加打印请求头+打印警告信息；3-在上一个等级基础上额外增加打印响应头；） |
| -w |  用`HTML table` 方式将结果打印在`stdout`（通过管道重定向到文件便于查看、邮件） |
| -x <attributes> | 当使用`-w`参数输出时，在`<table>`标签的属性输出 |
| -y <attributes> | 当使用`-w`参数输出时，在`<tr>`标签的属性输出 |
| -z <attributes> | 当使用`-w`参数输出时，在`<td>`、`<th>`标签的属性输出 |
| -d | 不要显示请求百分比-毫秒时刻表 |
| -S | 不要打印结果 `warning` 级别信息 |
| -q | 当执行超过150个请求时，不显示进度 |
| -l | 接受可变的文档长度（用于动态页面） |
| -g <filename> | 将请求统计数据输出到文件（颇为鸡肋） |
| -e <filename> | 将请求进度-百分比数据输出到文件（颇为鸡肋） |
| -r | 不要在socket接收错误时退出 |

## 结果分析

### 服务器信息

- **Server Software** - `Web`服务器的名称，对应`HTTP Respone Headers`中`Server`的值，因此该值不一定有或正确
- **Server Hostname** - 服务器主机名
- **Server Port** - 服务器端口（80-http；443-https）
- **SSL/TLS Protocol** - 客户端和服务器之间协商的协议参数（只有使用了`SSL`才会有值）
- **Server Temp Key** - 服务器临时密钥信息（不一定有该结果）
- **TLS Server Name** - 公钥服务器名称

### 传输信息

- **Document Path** - 测试的页面路径
- **Document Length** - 页面大小

### （重点）压测结果

- **Concurrency Level** - 并发数（同一时间发起的）
- **Time taken for tests** - 整个测试过程的耗时
- **Complete requests** - 成功的请求数
- **Failed requests** - 失败的请求数
- **Total transferred** - 整个测试过程网络传输量（单位：字节）
- **HTML transferred** - 整个测试过程`HTML`传输量（单位：字节）
- **Requests per second** - 吞吐率（`RPS`-单位：reqs/s） = 成功总请求数(`Complete requests`) / 测试过程耗时（`Time taken for tests`）
- **Time per request** - 用户平均请求等待时间 = 总时间（`Time taken for tests`） / (总请求数-`Complete requests` / 并发用户数-`Concurrent Level`)
- **Time per request（across all concurrent requests）** - 服务器平均等待时间 = 总时间-`Time taken for tests` / 成功总请求数-`Complete requests`
- **Transfer rate** - 平均网络传输流量（可以帮助排除是否存在网络流量过大导致响应时间延长的问题）

### 网络连接耗时-毫秒

> 格式：最小值、平均值、中位数、最大值

- **Connect** - `TCP` 连接耗时
- **Processing** - 服务端处理耗时
- **Waiting** - 等待耗时
- **Total** - 完整请求耗时


推荐阅读：
- [Apache的ab进行并发性能测试的注意点](http://www.piaoyi.org/linux/apache-ab-test.html)