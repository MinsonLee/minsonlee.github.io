---
layout: post
title: Web压测工具-siege
date: 2021-01-16
tags: [Tools,siege,压力测试,高并发]
---

[`Siege`](https://www.joedog.org/siege-home/)是一个`HTTP Web`服务器负载测试和基准测试的**开源免费**的命令行工具。其支持：`HTTP`、`HTTPS`、`FTP`协议，但只能运行在类`Unix`系统之下（不支持`Windows`系统）。

相比于`ab`，`siege` 的压测更贴近真实用户，因为：
1. `siege`单次请求过程中是**模拟用户浏览器访问行为**，会将结果中涉及的资源链接都进行加载
2. `siege`可以支持从一堆链接中**随机**的进行访问

## 安装

```sh
# 1. 下载源码包
cd /tmp && wget -o /tmp/siege-latest.tar.gz http://download.joedog.org/siege/siege-latest.tar.gz

# 2. 解压源码包
tar -zxvf siege-latest.tar.gz

# 3. cd 进入解压目录，配置安装位置
./configure

# 4. 编译安装
make && make install
```

安装完毕之后，可以使用 `siege -V` 或 `siege -C` 验证安装是否成功！

![siege-verify-siege-installation.png](/images/article/siege-verify-siege-installation.png)

## 使用说明

`siege` 的功能定位都很单一-压测页面，用法：[`siege <options> [url]`](https://www.joedog.org/siege-manual/)。

![siege-multiple-requests-testing.png](/images/article/siege-multiple-requests-testing.png)

### 参数

注意：不同版本，参数支持不一样！！！

| 参数 | 作用 |
| ---- | ---- |
| -V, --version | 打印版本信息 |
| -h, --help | 打印帮助信息 |
| -C, --config | 打印当前`siege`配置信息 |
| -v, --verbose | 详细模式-打印详细信息 |
| -q, --quiet | 静默模式-不打印详细信息并抑制输出 |
| -p, --print | 打印模式-打印请求的`HTML`页面信息 |
| -c, --concurrent=NUM | 设置并发数-默认是每次10个并发
| -r, -reps=NUM | 设置请求次数 |
| -t, --time=NUMm | 持续长时间压测（S-秒, M-分, H-小时）
| -d, --delay=NUM | 在每个请求前随机的延迟指定时间（单位-秒） |
| -b, --benchmark | 请求之间没有延迟 |
| -i, --internet | 模拟用户请求，从`-f`指定的`URLs`中随机选择访问一条`URL` |
| -f, --file=FILE | 指定`URLs`文件 |
| -R, --rc=FILE | 指定`siege`的运行配置文件-默认的为`$HOME/.siegerc` |
| -l, --log[=FILE] | 将统计数据保存到日志文件中（可在`.siegerc`中自定义日志文件） |
| -m, --mark="string" | |
| -H, --header="string" | 设置`Request Headers` |
| -A, --user-agent="string" | 设置`User-Agent`的值 |
| -T, --content-type="string" | 设置 `Content-Type` 的值 |
| --json-output | 设置输出结果为 `json` 格式（注意：该参数会抑制详细模式的输出） |

`-f` 参数可以指定`URLs`文件，格式如下：
- `GET`请求-urls.txt
```txt
server=172.0.0.1:80
http://${server}/q?k1=v1&k2=v2
```

- `POST` 请求
```txt
server=172.0.0.1:80
http://${server}/q POST k1=v1&k2=v2
```

### 使用案例

公司的服务进行了服务器迁移，需要对迁移后的服务器、数据库等进行压测，其步骤如下：
1. 从`Nginx`的访问日志中拉取一天的数据下来，取出其中的访问 `URL` 放到 `urls.txt`中
2. 结合`Kibana`看板，查看流量高峰时段（由于是国外业务，高峰时段在下午的14:30-17:00之间）
3. 绑定新机器`hosts`，使用`siege`持续不断对新服务压测


```sh
# 单页面压测-对百度首页发起200个并发，100组请求，总共：2万次
siege -c 200 -r 100 https://www.baidu.com
```

```sh
# 每次都随机从urls.txt中列出所有的网址选取一条进行请求
siege -c 200 -r 100 -f urls.txt -i
```

```sh
# 每次都随机从urls.txt中列出所有的网址选取一条进行请求，每次请求之间不需要延迟
siege -c 200 -r 100 -f urls.txt -i -b
```

## 结果分析

- **transactions** - 完成请求总次数
- **availability** - 请求成功率
- **elapsed_time** - 整个测试过程使用时间（单位-秒）
- **data_transferred** - 整个测试过程共传输数据字节大小
- **response_time** - 响应时间，显示网络连接的速度
- **transaction_rate** - 平均每秒完成的处理次数
- **throughput** - 平均每秒传送数据
- **concurrency** - 实际最高并发连接数
- **successful_transactions** - 成功处理次数
- **tailed_transactions** - 失败处理次数
- **longest_transaction** - 传输消耗最长的时间
- **shortest_transaction** - 传输消耗最短的时间


## 遇到的问题

1. `siege-4.0.4`以上版本`-v`详细模式无效

导致该问题的产生是因为`json output`的值为`true`（可以通过`siege -C` 查看当前加载的配置文件所在位置），抑制了详细模式、`stdout`的其余输出。

![siege-error-verbose-invalid.png](/images/article/siege-error-verbose-invalid.png)

2. `siege-4.0.4`以上版本记录`log`日志失败-无法自动创建日志文件

将`~/.siege/siege.conf`的 `show-logfile` 配置设置为 `false` 抑制记录日志文件。如果需要记录日志文件，新版本需要先手动创建日志文件且保证权限无误才可以写入记录日志。

3. 修改`siege`最大并发数

根据机器的情况，`siege`默认的并发用户数是 `255`，由于`HTTP`是短连接，而机器的端口范围是：`0-65535`，如果想不限制并发数只需要将`~/.siege/siege.conf`配置中的`limit`属性值设置为 `65535` 即可！

但是，需要注意的是：
1. `siege` 工具每个并发都启用一个新的线程来执行比较消耗性能，因此设置的该值的时候请根据实际情况设置用户数量
2. 若`limit`设置为`65536`（即：不限制并发上限），当并发数太高的时候 `siege` 很容易将本地机器的端口耗尽，从而影响到其他程序的运行

4. 修复`siege`报`aborted due to excessive socket failure`问题（超过了`siege`的`TCP`连接数）

与“问题3-最大并发数”一样的原因导致的，只需要将`~/.siege/siege.conf`配置中的`failures`属性值设置为 `65535` 即可！

