---
layout: post
title: "Windows 和 Linux 下如何查看内存条硬件信息"
date: 2025-09-19
tags: [Windows, Linux]
---

## Windows 查看内存条信息

- 通过命令 `wmic` 查看：`xxx get /format:list` 可以将列数据转为行显示
	- 获取当前内存条的详细信息：`wmic memorychip`
	- 如果只关心「当前有多少条内存条？给自多大字节？」` wmic memorychip get Tag,Capacity /format:list`
	- 当前电脑主板支持最大扩展到多大内存？`wmic MEMPHYSICAL get /format:list`

![当前计算机内存卡槽信息](/images/pig/windows-wmic-memorychip.png) 

![当前计算机主板支持扩展最大内存](/images/pig/windows-wmic-memorychip.png) 

- 通过「任务管理器-`taskmgr`」查看：

![通过“任务管理器-性能”查看内存条插槽信息](/images/pig/windows-taskmgr-show-memorychip.png)



## Linux 查看内存条信息

- 通过 `dmidecode -t memory` 获取内存条硬件信息
- 通过 `lsmem` 或 `free -h` 命令可以获取当前计算机的总内存信息