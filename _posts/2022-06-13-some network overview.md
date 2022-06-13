---
layout: post
title: "一些网络概念"
date: 2022-06-13
tags: [Network]
---

记录一些不算常听，但需要知道的基本概念。

## DNS 记录类型

参考：[DNS 记录类型](https://www.cnblogs.com/bluestorm/p/10345334.html)

- 域名解析：就是域名到IP地址的转换过程，相比 IP，使用域名标识站点更加简单好记
- A 记录：A-address，A 记录就是将一个域名解析到一个特定的 IP-v4 地址，在公网域名解析经常遇到
- AAAA记录：是将一个域名解析到一个特定的 IP-v6 地址，目前IP-v6 还未普及，见的不多
- NS 记录：Name Server 记录是指域名服务器记录，用于指定该域名是由哪个 DNS 服务器来进行解析
- MX 记录：Mail Exchanger 记录，记录邮件服务器的解析记录（查看 MX 记录：`nslookup -q=mx <domain>` 或 `dig mx <domain>`）
- CNAME：又称“别名记录”，即：将A/B/C等多个主机名(即：域名)都指向一个别名 D 主机名。这样有什么好处呢？当A/B/C服务域名的DNS需要改动时，A/B/C指向D不需要调整，只需要改动D-->DNS即可。

CNAME 最常见应用场景是在：CDN 中的使用（参考：[CDN 工作原理](https://support.huaweicloud.com/productdesc-cdn/cdn_01_0109.html)），用户只需要将域名和 CDN 提供的 CNAME 做指定，至于具体的 IP 链路选择由 CDN 服务器自行选择更换。

通过 `CNAME` 将 Domain 和 IP 进行了一层关系解耦，有利于避免 Domain、IP 相互修改时产生的互相影响。

![cname demo for cdn](/images/pig/dig-domain-show-cname.png)

![CDN 工作原理](https://support.huaweicloud.com/productdesc-cdn/zh-cn_image_0000001129063959.png)