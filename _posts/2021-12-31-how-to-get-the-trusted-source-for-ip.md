---
layout: post
title: 如何查看出口IP？
date: 2021-12-31
tags: [网络]
---


想查询自己的出口 IP 是多少，之前都是通过访问 [IP138.com](https://www.ip138.com/) 和 [IP.cn](https://ip.cn/) 的方式来得到出口 IP。今天碰到同事在问出口IP的问题，想了一下：命令行下如何查看自己的出口 IP (公网IP)呢？

在验证网上查阅的方法时，也遇到了一点小问题：之前一直用上述两个地址进行查询出口 IP，但是却没有仔细对比过，今天仔细一对比，居然发现两个站点给出的结果不一样。

问了公司的运维同事得到了解惑，遂记录于此。

**总结：**

- **同一个 WiFi 连接多台电脑，其出口 IP 不一定一样**
- **同一个网络环境访问不同的网站其出口 IP 不一定一样**
- **IP 的出口地址取决于 网络的NAT 和 网络出口策略**



## 国内出口查询：

- 网站：[ipw.cn/](https://ipw.cn/)、[ip138.com/](https://www.ip138.com/) 、 [cip.cc/](http://www.cip.cc/)、[IPIP](https://www.ipip.net/myip.html)

```shell
lms@LMS:~$ curl cip.cc

IP      : 14.xx.xx.xx4
地址    : 中国  广东  广州
运营商  : 电信

数据二  : 广东省广州市 | 电信

数据三  : 中国广东广州 | 电信

URL     : http://www.cip.cc/14.xx.xx.xx4
```

```shell
lms@LMS:~$ curl -s myip.ipip.net

当前 IP：14.xx.xx.xx4  来自于：中国 广东 广州  电信
```


## 国外出口IP查询

- 国外 https://ipinfo.io

```shell
lms@LMS:~$ curl ipinfo.io
{
  "ip": "103.xxxx.xxxx.97",
  "city": "Guangzhou",
  "region": "Guangdong",
  "country": "CN",
  "loc": "2x.xxx7,1xx.xxx0",
  "org": "AS137995 Shuangyu Communications Technology Co., Limited",
  "timezone": "Asia/Shanghai",
  "readme": "https://ipinfo.io/missingauth"
}
```

- 国外 https://ifconfig.me/

```shell
lms@LMS:~$ curl ifconfig.me

103.xxxx.xxxx.97
```

- 国外：http://ifconfig.io/

```shell
lms@LMS:~$ curl ifconfig.io

103.xxxx.xxxx.97
```

- 国外：http://httpbin.org/ip

```shell
lms@LMS:~$ curl httpbin.org/ip

{
  "origin": "103.xxxx.xxxx.97"
}
```