
```sh
# Ubuntu 环境变量配置

/etc/profile
/etc/profile.d/
/etc/bash.bashrc
/etc/bash_completion
/etc/bash_completion.d/
~/.profile
~/.bashrc
~/.bash_history
~/.bash_logout # 普通用户有，root没有。

```

- profile，配置文件。
- bashrc，打开shell程序之前才会读取执行的配置文件。
- /etc/目录下的配置文件为全局配置。
- ~/目录下的配置文件为本用户的私人配置。一般为以.开头的隐藏文件。`ls -a` 可以查看


![一般加载](https://img-blog.csdn.net/20171117142454885?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvWm9lWWVuXw==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
- [Linux配置文件加载顺序-Linux profile bash_profile bashrc-嗨客网](https://haicoder.net/linux/linux-profile-bashrc.html)