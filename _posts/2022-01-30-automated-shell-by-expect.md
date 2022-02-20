---
layout: post
title: Expect 实现SSH自动化登录
date: 2022-01-30
tags: [Shell,Expect,Tcl,SSH]
---

## Expect 能做什么？
Expect 是由 Don Libes 基于 [Tcl(Tool Command Language) 脚本语言]((https://wizardforcel.gitbooks.io/tutorialspoint-programming/content/tcl/271.html))编写的一个扩展，常被用来处理程序的自动交互。如：SSH 的自动登录、FTP 登录下载、passwd 修改密码...等类似需要人机交互的场景，都可以用 Expect 来实现自动化处理。详情可阅读 [Expect - Wikipedia](https://en.wikipedia.org/wiki/Expect) 和 [Expect - Linux man page](https://linux.die.net/man/1/expect)。

Tcl(Tool Command Language) 作为一个可跨平台的胶水脚本语言，它可以像 Shell 一样，但功能又比 Shell 要强大一些，我们可以在 Expect 脚本中使用 Tcl 语法实现一些复杂的操作。详细的教程在这里不做赘述，可在文章末尾的 [阅读参考](#阅读参考) 中获取相应资料进行学习，非常的简单。

## Expect 基础

在 Expect 脚本中，最常用到的几个命令：`spawn`、`expect`、`send`、`interact`。

Command | Description
--- | ---
spawn | 启动一个进程
expect | 接收进程的标准输出
send | 向进程标准输入信息
interact | 将控制权交给用户进行交互
puts | 用于向执行当前 Expect 的进程输出信息


### 设置变量及访问变量

可以通过 `set <VARIABLE> <VALUE>` 的方式进行设置变量及其变量值。

若你是通过命令行执行 Expect 脚本（`*.exp`），在执行时候可通过命令行传入参数，在 Expect 脚本中可以通过 `set <VARIABLE> [lindex $argv 0/1/2...]` 的方式接收。

注意：**`Expect` 脚本和 `Shell` 脚本都是通过 $0...$n 的方式来接收命令参数，但是在 `Shell` 中 $0 标识脚本自身，而在 `Expect` 中则表示第一个参数。**

## Demo 

### 方式1：自动输入密码登录

```shell
#!/usr/bin/bash

USER="login user"
HOST="my host or ip"
PORT="port"
PWD="login password"

# 判断 ssh、expect 命令是否存在
command -v ssh > /dev/null 2>&1 && {
    command -v expect > /dev/null 2>&1 && {
        # 通过 expect 自动执行命令
        expect -c "
            set timeout 15;
            puts \"[lindex $argv 1]\n\"
            spawn ssh -l $USER $HOST -p $PORT;
            expect {
                \"*yes/no*\" { send \"yes\r\"; exp_continue; }
                \"*password:*\" { send \"$PWD\r\"; }
            };
            interact
        "
    } || {
        echo "Command 'expect' not found. Try: 'sudo apt-get install expect' or 'sudo yum install expect' to install it.\n"
    }
} || {
        echo "Command 'ssh' not found!\n"
}
```

保存上述脚本，然后在 `~/.bashrc` 或 `~/.bash_aliases` 中添加命令别名

```shell
# 将 expect 脚本存放目录添加到环境变量中
export EXPECT_PATH="/usr/local/bin/expect"
export PATH="$PATH;$EXPECT_PATH"

# 设置命令别名
alias _ssh_erc_jumpserver="/$EXPECT_PATH/_ssh_erc_jumpserver
```

### 方式2：通过 expect 脚本实现

确保本机已经安装了 expect 扩展，然后将以下脚本保存到 `/usr/local/bin/_ssh` 中，并通过 `chmod +x /usr/local/bin/_ssh` 赋予可执行权限。后续就可以通过 `_ssh dev_web`、`_ssh dev_mysql` 自动登录了。

```shell
#!/usr/bin/expect -f

log_user 0; # 屏蔽脚本的输出，缺省值为 1
set timeout 15; # 设置超时时间
set SERVER_TYPE [lindex $argv 0]; # 接收参数并将第一个参数赋值给 SERVER_TYPE

# 自定义函数-成功回调
proc expect_success { SERVER } {
    switch $SERVER {
        dev_web {
            # 测试环境 web 机
            set USER "login user"
            set HOST "server host or ip"
            set PORT "port"
            set PWD "password"
        }
        dev_mysql {
            # # 测试环境 MySQL
            set USER "login user"
            set HOST "server host or ip"
            set PORT "port"
            set PWD "password"
        }
        dev_mc {
            # 测试环境缓存机器
            set USER "login user"
            set HOST "server host or ip"
            set PORT "port"
            set PWD "password"
        }
        dev_proxy {
            # 测试机 Nginx 入口机
            set USER "login user"
            set HOST "server host or ip"
            set PORT "port"
            set PWD "password"
        }
        erc_jumpserver {
            # JumpServer 机器
            set USER "login user"
            set HOST "server host or ip"
            set PORT "port"
            set PWD "password"
        }
        default {
            puts "Unknown Server!"
            exit
        }
    }

    # 启动进程执行 ssh 连接到服务器
    spawn ssh -l $USER $HOST -p $PORT;
    expect {
        "*yes/no*" { send "yes\r"; exp_continue; }
        "*password:*" { send "$PWD\r"; }
    }
    # 将控制权交还给用户进行交互
    interact
}

# 终止函数
proc exit_expect { } {
    puts "Command 'ssh' not found! \nTry: 'sudo apt-get install openssh' or 'sudo yum –y install openssh-server openssh-clients' to install it."
    exit
}

# 校验是否安装 ssh 服务
spawn bash -c "command -v ssh > /dev/null 2>&1 && echo $? || echo $?"

expect {
    1 {
        exit_expect
    }
    0 {
        expect_success $SERVER_TYPE
#        expect_success $erc_web
    }
}
```

**如何确定一个环境变量是在哪个脚本中设置的？？**

大部分发行版的 Linux 启动后环境变量加载的顺序为：`etc/profile` → `/etc/profile.d/*.sh` → `~/.bash_profile` → `~/.bashrc` → [`/etc/bashrc`]。

部分发行版的系统可能会不一致，例如：WSL Ubuntu 就是先加载了 `/etc/bash.bashrc` 再加载 `/etc/profile.d/*.sh`，但不管如何都一定是从 `etc/profile` 开始。

暂时没有很好的办法进行一步到位的确定，只能挨个找。

## 阅读参考

- [Expect - Wikipedia](https://en.wikipedia.org/wiki/Expect)
- [Expect - Linux man page](https://linux.die.net/man/1/expect)
- [Expect command and how to automate shell scripts like magic](https://likegeeks.com/expect-command/)
- [expect - 自动交互脚本](http://xstarcd.github.io/wiki/shell/expect.html)
- [expect教程中文版](http://xstarcd.github.io/wiki/shell/expect_handbook.html)
- [EXPECT Manual](https://www.tcl.tk/man/expect5.31/expect.1.html)
- [Linux新建用户配置文件 /etc/login.defs 详解](https://www.linuxidc.com/Linux/2019-05/158732.htm)
- [How to Install / Enable OpenSSH on CentOS 7](https://phoenixnap.com/kb/how-to-enable-ssh-centos-7)
- [Tcl Developer Xchange](https://www.tcl.tk/)
- [学习一下 Tcl/Tk](https://ahuigo.github.io/b/c/ops-tcl#/)
- [Tcl 教程](https://wizardforcel.gitbooks.io/tutorialspoint-programming/content/tcl/271.html)
- [一个expect程序的功能实现描述和注释](https://bobkey.wordpress.com/2007/09/18/%E4%B8%80%E4%B8%AAexpect%E7%A8%8B%E5%BA%8F%E7%9A%84%E5%8A%9F%E8%83%BD%E5%AE%9E%E7%8E%B0%E6%8F%8F%E8%BF%B0%E5%92%8C%E6%B3%A8%E9%87%8A/)