top 命令可以动态地查看系统的整体运行情况，是一个综合了多方信息监测系统性能和运行信息的实用工具。每 3 秒会刷新一次动态数据信息

https://www.booleanworld.com/guide-linux-top-command/#Tasks

![top demo](5A793250FB6340B1A01654374BDFB2FA)

![top demo](EB454F7237DB4B87B855170C8CC250CE)




```txt
top - 15:16:24 up  2:59,  2 users,  load average: 1.58, 1.68, 1.72
Tasks: 379 total,   1 running, 377 sleeping,   0 stopped,   1 zombie
%Cpu(s):  5.8 us,  0.5 sy,  0.0 ni, 93.5 id,  0.0 wa,  0.0 hi,  0.1 si,  0.0 st
KiB Mem : 16431056 total,  5050832 free,  9069916 used,  2310308 buff/cache
KiB Swap:        0 total,        0 free,        0 used.  6652204 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND 
 4628 www       20   0  699436 152684 132848 S  12.0  0.9   1:23.15 php-fpm
```



## 查看负载

负载-load average：1分钟内负载平均值, 5分钟内负载平均值, 15分钟内负载平均值
- https://brendangregg.com/blog/2017-08-08/linux-load-averages.html
- https://www.site24x7.com/blog/load-average-what-is-it-and-whats-the-best-load-average-for-your-linux-servers
- https://www.hostinger.com/tutorials/vps/how-to-manage-processes-in-linux-using-command-line
- https://www.tecmint.com/12-top-command-examples-in-linux/
 
第一行：`top - 15:16:24 up  2:59,  2 users,  load average: 1.58, 1.68, 1.72`
- `top -` 标识出当前是打印 top 命令信息。单纯显示负载信息还可使用 `uptime`打印，两者就负载信息是完全一致的
- `15:16:24` 当前系统所设时区的时间
- `up   2:59,` 当前系统已经运行的时间
- `2 users,` 当前系统有 2 个 Shell 登录用户
- `load average: 1.58, 1.68, 1.72` 系统平均负载（1分钟内负载平均值, 5分钟内负载平均值, 15分钟内负载平均值）

## 查看进程

第二行：`Tasks: 379 total,   1 running, 377 sleeping,   0 stopped,   1 zombie`