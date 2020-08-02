---
layout: post
title: "sleep 在定时任务中的妙用"
date: 2020-07-01
tag: 编程分享
---
'service\pc\app\Console\Commands\HistoricalData.php:processingData()'

为什么处理while-true执行大数据任务时候需要中断sleep一下？-避免占用IO过高，独占资源导致系统挂站
但是如果是高并发访问脚本，则不可以使用sleep，否则会导致进程阻塞，瞬间子进程被耗尽，导致系统直接502