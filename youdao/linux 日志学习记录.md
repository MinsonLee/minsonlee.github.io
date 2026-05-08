- Linux系统日志位置及包含的日志内容介绍： https://mp.weixin.qq.com/s/xR8JxFFDg0rYEPhICUpQRw
- Linux系统日志管理 http://c.biancheng.net/linux_tutorial/15/
- PHP-错误日志、PHP-FPM 错误日志
- https://www.jianshu.com/p/59171af68803
- NGINX 访问日志、错误日志
- MySQL binlog、redolog、undolog、错误日志、慢日志
- 日志定期清理和logrotate ： https://cloud.tencent.com/developer/article/1419763
- 利用Linux自带的logrotate管理日志 : https://www.cnblogs.com/miaocbin/p/11540312.html

```conf
# /etc/logrotate.conf
# see "man logrotate" for details
# rotate log files weekly
weekly

# keep 4 weeks worth of backlogs
rotate 4

# create new (empty) log files after rotating old ones
create

# use date as a suffix of the rotated file
dateext

# uncomment this if you want your log files compressed
#compress

# RPM packages drop log rotation information into this directory
include /etc/logrotate.d

# no packages own wtmp and btmp -- we'll rotate them here
/var/log/wtmp {
    monthly
    create 0664 root utmp
        minsize 1M
    rotate 1
}

/var/log/btmp {
    missingok
    monthly
    create 0600 root utmp
    rotate 1
}

# system-specific logs may be also be configured here.
```