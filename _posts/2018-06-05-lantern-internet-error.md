---
layout: post
title: "本地客户端网络访问异常"
date: 2018-06-05
tags: [网络,系统]
---

## 背景
> 公司的网络之前不能翻墙,买的枫叶VPN也过期了,后来装了蓝灯(Lantern)免费版用了一段时间.现在公司网络可以翻墙了,由于Lantern免费一个月只有500M(在家用也够用了),所以公司的电脑就将Lantern卸载了,结果就JJ了...

## 问题
> 卸载了蓝灯,使用浏览器访问网络一切正常,登录Tim、微信、Foxmail...都正常,但是异常情况却出现了

- Tim群通知无法访问
![Tim群通知无法访问](/images/article/internet/internet-error.png)
- Foxmail接收邮件`部分图片`经常出现裂图
![图片出现裂图](/images/article/internet/split-img.png)

## 排查过程
1. 由于公司的傻逼网络经常不稳定,并且Foxmail接收到的邮件仅是部分图片产生裂图现象,一开始我以为公司网络问题,切了好几个WIFI,依然无果,想着隔天来看,发现依然异常
2. 与公司网管反馈,公司网管说最近公司的网络确实经常跳动不稳定,在维修中
3. 时至今日,离网络异常已有半个月...今天突然发现其他同事使用Foxmail接收到邮件都是正常的,只有我的才会有部分图片是裂图,突然想到：Lantern翻墙是通过PAC文件进行代理翻墙的
4. 排查确定问题:重新安装Lantern,发现以上说的异常情况都恢复正常了

> 问题的出现显然就是Lantern搞的鬼了,只需要卸载Lanter后将本地的全局代理自动设置取消即可

## 解决方法
> 方法是网上搜的:`Lantern 全局代理`,在此记录

![取消Lantern全局代理设置](/images/article/internet/cancel_lantern_global_proxy_setting.gif)

转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)

扫描下方二维码，关注公众号，接收更多实时内容
![关注公众号：Leaders工作室](/images/article/WeChat/Leaders.png)