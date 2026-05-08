> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址:https://www.cnblogs.com/passzhang/p/9063455.html

> **作者：PassZhang**
> 
> **链接：**
**https://www.cnblogs.com/passzhang/p/9063455.html**

**1. cron 后台常驻程序 (daemon) 用于：**
- [ ] A. 负责文件在网络中的共享   
- [ ] B. 管理打印子系统  
- [ ] C. 跟踪管理系统信息和错误   
- [x] **D. 管理系统日常任务的调度**

**2. 在大多数 Linux 发行版本中，以下哪个属于块设备 (block devices) ？**
- [ ] A. 串行口  
- [x] **B. 硬盘 **
- [ ] C. 虚拟终端  
- [ ] D. 打印机  

**3. 下面哪个 Linux 命令可以一次显示一页内容？**
- [ ] A. pause   
- [ ] B. cat   
- [x] **C. more **
- [ ] D. grep   

**4. 怎样了解您在当前目录下还有多大空间？**
- [ ] A. Use df   
- [ ] B. Use du /   
- [x] **C. Use du . **
- [ ] D. Use df .   

**5. 怎样更改一个文件的权限设置？**
- [ ] A. attrib   
- [x] **B. chmod **
- [ ] C. change   
- [ ] D. file   

**6. 假如您需要找出 /etc/my.conf 文件属于哪个包 (package) ，您可以执行：**
- [ ] A. rpm -q /etc/my.conf   
- [ ] B. rpm -requires /etc/my.conf   
- [x] **C. rpm -qf /etc/my.conf **
- [ ] D. rpm -q | grep /etc/my.conf   

**7. 假如当前系统是在 level 3 运行，怎样不重启系统就可转换到 level 5 运行？**
- [ ] A. Set level = 5   
- [x] **B. telinit 5 **
- [ ] C. run 5   
- [ ] D. ALT-F7-5   

**8. 那个命令用于改变 IDE 硬盘的设置？**
- [ ] A. hdparam   
- [ ] B. ideconfig   
- [x] **C. hdparm **
- [ ] D. hddparm  

**9. 下面哪个命令可以列出定义在以后特定时间运行一次的所有任务？**
- [x] **A. atq**
- [ ] B. cron  
- [ ] C. batch  
- [ ] D. at  

**10. 下面命令的作用是：`set PS1="[\u\w\t]\$" ; export PS1`**
- [ ] A. 改变错误信息提示  
- [x] **B. 改变命令提示符**
- [ ] C. 改变一些终端参数  
- [ ] D. 改变辅助命令提示符  

**11. 作为一个管理员，你希望在每一个新用户的目录下放一个文件 .bashrc ，那么你应该在哪个目录下放这个文件，以便于新用户创建主目录时自动将这个文件复制到自己的目录下。**
- [x] **A. /etc/skel/**
- [ ] B. /etc/default/  
- [ ] C. /etc/defaults/  
- [ ] D. /etc/profile.d/  

**12. 在 bash 中，export 命令的作用是：**
- [ ] A. 在子 shell 中运行命令  
- [ ] B. 使在子 shell 中可以使用命令历史记录  
- [x] **C. 为其它应用程序设置环境变量**
- [ ] D. 提供 NFS 分区给网络中的其它系统使用  

**13. 在使用了 shadow 口令的系统中，/etc/passwd 和 / etc/shadow 两个文件的权限正确的是：**
- [ ] A. -rw-r----- , -r--------  
- [ ] B. -rw-r--r-- , -r--r--r--  
- [x] **C. -rw-r--r-- , -r--------**
- [ ] D. -rw-r--rw- , -r-----r--  

**14．下面哪个参数可以删除一个用户并同时删除用户的主目录？**
- [ ] A. rmuser -r  
- [ ] B. deluser -r  
- [x] **C. userdel -r**
- [ ] D. usermgr -r  

**15．有一个备份程序 mybackup，需要在周一至周五下午 1 点和晚上 8 点各运行一次，下面哪条 crontab 的项可以完成这项工作？**
- [ ] A. 0 13,20 * * 1,5 mybackup  
- [x] **B. 0 13,20 * * 1,2,3,4,5 mybackup**
- [ ] C. * 13,20 * * 1,2,3,4,5 mybackup  
- [ ] D. 0 13,20 1,5 * *  mybackup  

**16．如何从当前系统中卸载一个已装载的文件系统**
- [x] **A. umount**
- [ ] B. dismount  
- [ ] C. mount -u  
- [ ] D. 从 /etc/fstab 中删除这个文件系统项  

**17．如果你的 umask 设置为 022，缺省的你创建的文件的权限为：**
- [ ] A. ----w--w-  
- [ ] B. -w--w----  
- [ ] C. r-xr-x---  
- [x] **D. rw-r--r--**

**18．在一条命令中如何查找一个二进制命令 Xconfigurator 的路径？**
- [ ] A. apropos Xconfigurator   
- [ ] B. find Xconfigurator  
- [ ] C. where Xconfigurator  
- [x] **D. which Xconfigurator**

**19．哪一条命令用来装载所有在 /etc/fstab 中定义的文件系统？**
- [ ] A. amount  
- [x] **B. mount -a**
- [ ] C. fmount  
- [ ] D. mount -f  

**20．运行一个脚本，用户不需要什么样的权限？**
- [ ] A. read  
- [x] **B. write**
- [ ] C. execute  
- [ ] D. browse on the directory  

**21．在 Linux 中，如何标识接在 IDE0 上的 slave 硬盘的第 2 个扩展分区？**
- [ ] A. /dev/hdb2  
- [ ] B. /dev/hd1b2  
- [x] **C. /dev/hdb6**
- [ ] D. /dev/hd1b6  

**22．在应用程序起动时，如何设置进程的优先级？**
- [ ] A. priority  
- [x] **B. nice**
- [ ] C. renice  
- [ ] D. setpri  

**23．在 bash 中, 在一条命令后加入 "1>&2" 意味着：**
- [ ] A. 标准错误输出重定向到标准输入  
- [ ] B. 标准输入重定向到标准错误输出  
- [x] **C. 标准输出重定向到标准错误输出**
- [ ] D. 标准输出重定向到标准输入  

**24．下面哪条命令可以把 f1.txt 复制为 f2.txt?**
- [ ] A. cp f1.txt | f2.txt  
- [ ] B. cat f1.txt | f2.txt  
- [x] **C. cat f1.txt > f2.txt**
- [ ] D. copy f1.txt | f2.txt  

**25．显示一个文件最后几行的命令是：**
- [ ] A. tac  
- [x] **B. tail**
- [ ] C. rear  
- [ ] D. last

**26. 如何快速切换到用户 John 的主目录下？**
- [ ] A. cd @John  
- [ ] B. cd #John  
- [ ] C. cd &John  
- [x] **D. cd ~John**
　

**27. 把一个流中所有字符转换成大写字符，可以使用下面哪个命令？**
- [x] **A. tr a-z A-Z**
- [ ] B. tac a-z A-Z   
- [ ] C.sed /a-z/A-Z  
- [ ] D. sed --toupper  

**28. 使用什么命令可以查看 Linux 的启动信息？**
- [ ] A. mesg -d  
- [x] **B. dmesg**
- [ ] C. cat /etc/mesg  
- [ ] D. cat /var/mesg

**29. 运行级定义在：**
- [ ] A. in the kernel  
- [x] **B. in /etc/inittab**
- [ ] C. in /etc/runlevels  
- [ ] D. using the rl command

**30. 如何装载 (mount) 上在 /etc/fstab 文件中定义的所有文件系统？**
- [x] **A. mount -a**
- [ ] B. mount /mnt/*  
- [ ] C. mount   
- [ ] D. mount /etc/fstab

**31. 使用 ln 命令将生成了一个指向文件 old 的符号链接 new，如果你将文件 old 删除，是否还能够访问文件中的数据？**
- [x] **A. 不可能再访问**
- [ ] B. 仍然可以访问  
- [ ] C. 能否访问取决于文件的所有者  
- [ ] D. 能否访问取决于文件的权限

**32.xt2fs 文件系统中，缺省的为 root 用户保留多大的空间？**
- [ ] A. 3%  
- [ ] B. 5%  
- [x] **C. 10%**
- [ ] D. 15%

**33. 哪个命令用来显示系统中各个分区中 inode 的使用情况？**
- [x] **A. df -i**
- [ ] B. df -H  
- [ ] C. free -b  
- [ ] D. du -a -c /  

**34. 多数 Linux 发行版本中，图形方式的运行级定义为？**
- [ ] A. 1  
- [ ] B. 2  
- [ ] C. 3  
- [x] **D. 5**

**35. 在系统文档中找到关于 print 这个单词的所有说明？**
- [ ] A. man print  
- [ ] B. which print  
- [ ] C. locate print  
- [x] **D. apropos print**

**36.man 5 passwd 含义是？**
- [ ] A. 显示 passwd 命令的使用方法  
- [x] **B. 显示 passwd 文件的结构**
- [ ] C. 显示 passwd 命令的说明的前五行  
- [ ] D. 显示关于 passwd 的前五处说明文档。

> man的级别：
>- 1：查看命令的帮助
>- 2：查看可被内核调用的函数的帮助
>- 3：查看函数和函数库的帮助
>- 4：查看特殊文件的帮助（主要是/dev目录下的文件）
>- 5：查看配置文件的帮助
>- 6：查看游戏的帮助
>- 7：查看其它杂项的帮助
>- 8：查看系统管理员可用命令的帮助
>
> man -f 【命令】– 可以查看这个命令有哪些级别
>
> man 5 passwd // 在入口为文件系统去查询passwd的帮助文档(截图红框中是文档的描述)
>   ![image](F3E5949CEC424E00B005E2959792A50A)

**37. 如何在文件中查找显示所有以 "*" 打头的行？**
- [ ] A. find \* file  
- [ ] B. wc -l * < file  
- [ ] C. grep -n * file  
- [x] **D. grep ‘^\*’ file**

**38. 在 ps 命令中什么参数是用来显示所有用户的进程的？**
- [x] **A. a**
- [ ] B. b  
- [ ] C. u  
- [ ] D. x

**39. 显示二进制文件的命令是？**
- [x] **A. od**
- [ ] B. vil  
- [ ] C. view  
- [ ] D. binview

**40. 如何显示 Linux 系统中注册的用户数（包含系统用户）？**
- [ ] A. account -l  
- [ ] B. nl /etc/passwd |head  
- [ ] C. wc --users /etc/passwd  
- [x] **D. wc --lines /etc/passwd**

**41. 在一行结束位置加上什么符号，表示未结束，下一行继续？**
- [ ] A. /  
- [x] **B. \**
- [ ] C. ;  
- [ ] D. |

**42. 命令 kill 9 的含义是：**
- [ ] A. kills the process whose PID is 9.  
- [ ] B. kills all processes belonging to UID 9.  
- [ ] C. sends SIGKILL to the process whose PID is 9.  
- [x] **D. sends SIGTERM to the process whose PID IS 9**.

**43. 如何删除一个非空子目录 / tmp？**
- [ ] A. del /tmp/*  
- [x] **B. rm -rf /tmp**
- [ ] C. rm -Ra /tmp/*  
- [ ] D. rm -rf /tmp/*

**44. 使用什么命令可以在今天午夜运行命令 cmd1 ？**
- [ ] A. at midnight cmd1  
- [ ] B. cron -at "00:00" cmd1  
- [ ] C. batch -t "00:00" < cmd1  
- [x] **D. echo "cmd1" | at midnight**

**45. 你的系统使用增量备份策略，当需要恢复系统时，你需要按什么顺序恢复备份数据？**
- [ ] A. 最后一次全备份，然后从最早到最近的增量备份  
- [x] **B. 最后一次全备份，然后从最近到最早的增量备份**
- [ ] C. 最早到最近的增量备份，然后最后一次全备份  
- [ ] D. 最近到最早的增量备份，然后最后一次全备份

**46. 对所有用户的变量设置，应当放在哪个文件下？**
- [ ] A. /etc/bashrc  
- [x] **B. /etc/profile**
- [ ] C. ~/.bash_profile  
- [ ] D. /etc/skel/.bashrc

**47.Linux 系统中，一般把命令 ls 定义为 ls --color 的别名，以便以不同颜色来标识不同类型的文件。**
**但是，如何能够使用原先的 ls 命令？**
- [x] **A. \ls**
- [ ] B. ;ls  
- [ ] C. ls $$  
- [ ] D. ls --noalias

**48. 在 Linux 系统中的脚本文件一般以什么开头？**
- [ ] A. $/bin/sh  
- [x] **B. #!/bin/sh**
- [ ] C. use /bin/sh  
- [ ] D. set shell=/bin/sh

**49. 下面哪种写法表示如果 cmd1 成功执行，则执行 cmd2 命令？**
- [x] **A. cmd1&&cmd2**
- [ ] B. cmd1|cmd2  
- [ ] C. cmd1;cmd2  
- [ ] D. cmd1||cmd2

**50. 在哪个文件中定义网卡的 I/O 地址？**
- [ ] A. cat /proc/modules  
- [ ] B. cat /proc/devices  
- [x] **C. cat /proc/ioports**
- [ ] D. cat /io/dma

**51.Linux 中，提供 TCP/IP 包过滤功能的软件叫什么？**
- [ ] A. rarp  
- [ ] B. route  
- [x] **C. iptables**
- [ ] D. filter

**52. 如何暂停一个打印队列？**
- [ ] A. lpr  
- [ ] B. lpq  
- [x] **C. lpc**
- [ ] D. lpd

**53. 在 vi 中退出不保存的命令是？**
- [ ] A. :q  
- [ ] B. :w  
- [ ] C. :wq  
- [x] **D. :q!**

**54. 在 XFree86 3.x 中, 缺省的字体服务器为：**
- [x] **A. xfs**
- [ ] B. xfserv  
- [ ] C. fonts  
- [ ] D. xfstt

**55. 使用什么命令检测基本网络连接？**
- [x] **A. ping**
- [ ] B. route  
- [ ] C. netstat  
- [ ] D. ifconfig

**56. 下面哪个协议使用了二个以上的端口？**
- [ ] A. telnet  
- [x] **B. FTP**
- [ ] C. rsh  
- [ ] D. HTTP

**57. 在 PPP 协议中，哪个认证协议不以明文传递密码？**
- [ ] A. PAM  
- [ ] B. PAP  
- [ ] C. PGP  
- [x] **D. CHAP**

**58. 下面哪个文件系统应该分配最大的空间？**
- [x] **A. /usr**
- [ ] B. /lib  
- [ ] C. /root  
- [ ] D. /bin

**59. 如何在 Debian 系统中安装 rpm 包？**
- [ ] A. alien pkgname.rpm  
- [ ] B. dpkg --rpm pkgname.rpm  
- [ ] C. dpkg --alien pkgname.rpm  
- [x] **D. alien pkganme.rpm ; dpkg -i pkganme.deb**
　

**60. 在安装软件时下面哪一步需要 root 权限？**
- [ ] A. make  
- [ ] B. make deps  
- [ ] C. make config  
- [x] **D. make install**

**61. 什么命令用来只更新已经安装过的 rpm 软件包？**
- [ ] A. rpm -U *.rpm  
- [x] **B. rpm -F \*.rpm**
- [ ] C. rpm -e *.rpm  
- [ ] D. rpm -q *.rpm

**62. 在 windows 与 Linux 双起动的系统中，如果要让 LILO 管理引导，则 LILO 应该放在：**
- [ ] A. MBR  
- [ ] B. /  
- [ ] C. root 分区的首扇区
- [x] **D. /LILO**

**63.ldconfig 的配置文件是**
- [ ] A. /lib/ld.so  
- [x] **B. /etc/ld.so.conf**
- [ ] C. /etc/ld.so.cache  
- [ ] D. /etc/modules.conf

**64. 下面哪个命令可以压缩部分文件：**
- [ ] A. tar -dzvf filename.tgz *  
- [ ] B. tar -tzvf filename.tgz *  
- [x] **C. tar -czvf filename.tgz \***
- [ ] D. tar -xzvf filename.tgz *

**65. 网络服务的 daemon 是：**
- [ ] A. lpd  
- [ ] B. netd  
- [ ] C. httpd  
- [x] **D. inetd**

**66.Linux 与 windows 的网上领居互联，需要提供什么 daemon?**
- [ ] A. bind  
- [x] **B. smbd**
- [ ] C. nmbd  
- [ ] D. shard

**67. 对于 Apache 服务器，提供的子进程的缺省的用户是：**
- [ ] A. root  
- [ ] B. apached  
- [ ] C. httpd  
- [x] **D. nobody**

**68.sendmail 中缺省的未发出信件的存放位置是：**
- [ ] A. /var/mail/  
- [ ] B. /var/spool/mail/  
- [x] **C. /var/spool/mqueue/**
- [ ] D. /var/mail/deliver/

**69.apache 的主配置文件是：**
- [x] **A. httpd.conf**
- [ ] B. httpd.cfg  
- [ ] C. access.cfg  
- [ ] D. apache.conf

**70. 关于可装载的模块，装载时的参数，如 I/O 地址等的存放位置是：**
- [x] **A. /etc/conf.modules**
- [ ] B. /etc/lilo.conf  
- [ ] C. /boot/System.map  
- [ ] D. /etc/sysconfig

**71. 在 Linux 中，如何关闭邮件提示？**
- [x] **A. biff n**
- [ ] B. mesg n
- [ ] C. notify off
- [ ] D. set notify=off

**72. 在 bash shell 环境下，当一命令正在执行时，按下 control-Z 会：**
- [ ] A. 中止前台任务
- [ ] B. 给当前文件加上 EOF.
- [x] **C. 将前台任务转入后台**
- [ ] D. 注销当前用户

**73. 定义 bash 环境的用户文件是：**
- [ ] A. bash & .bashrc  
- [ ] B. bashrc & .bash_conf  
- [ ] C. bashrc & bash_profile  
- [x] **D. .bashrc & .bash_profile**

**74. 下面哪条命令用来显示一个程序所使用的库文件？**
- [x] **A. ldd**
- [ ] B. ld so  
- [ ] C. modprobe  
- [ ] D. ldconfig

**75. 如何查看一个 RPM 软件的配置文件的存放位置？**
- [x] **A. rpm -qc rpm1**
- [ ] B. rpm -Vc rpm1  
- [ ] C. rpm --config rpm1  
- [ ] D. rpm -qa --config rpm1

**76. 如何查看一个 RPM 软件的修改记录？**
- [ ] A. rpm -Vc postfix  
- [ ] B. rpm -qpil postfix  
- [ ] C. rpm --changelog postfix  
- [x] **D. rpm -q --changelog postfix**

**77. 通过 Makefile 来安装已编译过的代码的命令是：**
- [ ] A. make   
- [ ] B. install  
- [ ] C. make depend  
- [x] **D. make install**

**78. 什么命令解压缩 tar 文件？**
- [ ] A. tar -czvf filename.tgz  
- [x] **B. tar -xzvf filename.tgz**
- [ ] C. tar -tzvf filename.tgz  
- [ ] D. tar -dzvf filename.tgz

**79. 在 XF86Config 配置文件中，哪个段用来设置字体文件？**
- [ ] A. The Fonts section.  
- [x] **B. The Files section.**
- [ ] C. The xfsCodes section.  
- [ ] D. The Graphics section.

**80.8 bit color 指的是：**
- [ ] A. 64K colors  
- [ ] B. 16K colors  
- [x] **C. 256 colors**
- [ ] D. 16M colors

**81. 下面哪个文件用来设置 X window 的显示分辨率？**
- [ ] A. xinit  
- [ ] B. xinitrc  
- [ ] C. XF86Setup  
- [x] **D. XF86Config**

**82. 哪个变量用来指定一个远程 X 应用程序将输出放到哪个 X server 上？**
- [x] **A. DISPLAY**
- [ ] B. TERM  
- [ ] C. ECHO  
- [ ] D. OUTPUT

**83. 在 xdm 的配置目录中，哪个文件用来设置在用户通过 xdm 登录后自动起动的应用程序？**
- [ ] A. The Xsession file  
- [x] **B. The Xsetup_0 file**
- [ ] C. The Xstart_up file  
- [ ] D. The GiveConsole file

**84. 命令 netstat -a 停了很长时间没有响应，这可能是哪里的问题？**
- [ ] A. NFS.  
- [x] **B. DNS.**
- [ ] C. NIS.  
- [ ] D. routing.

**85.ping 使用的协议是：**
- [ ] A. TCP  
- [ ] B. UDP  
- [ ] C. SMB  
- [x] **D. ICMP**

**86. 下面哪个命令不是用来查看网络故障的？**
- [ ] A. ping   
- [x] **B. init**
- [ ] C. telnet   
- [ ] D. netstat

**87. 拨号上网使用的协议通常是：**
- [x] **A. PPP**
- [ ] B. UUCP  
- [ ] C. SLIP  
- [ ] D. Ethernet

**88.TCP/IP 中，哪个协议是用来进行 IP 自动分配的？**
- [ ] A. ARP  
- [ ] B. NFS  
- [x] **C. DHCP**
- [ ] D. DNS

**89. 下面哪个文件定义了网络服务的端口？**
- [ ] A. /etc/netport  
- [x] **B. /etc/services**
- [ ] C. /etc/server  
- [ ] D. /etc/netconf

**90. 下面哪个功能用来生成一个文件的校验码？**
- [x] **A. md5**
- [ ] B. tar  
- [ ] C. crypt  
- [ ] D. md5sum

**91. 缺省的，用户邮件放在：**
- [ ] A. ~/mail/  
- [ ] B. /var/mail/  
- [ ] C. /var/mail/spool/  
- [x] **D. /var/spool/mail/**

**92. 下面哪个文件包含了供 NFS daemon 使用的目录列表？**
- [ ] A. /etc/nfs  
- [ ] B. /etc/nfs.conf  
- [x] **C. /etc/exports**
- [ ] D. /etc/netdir

**93. 如何停止一台机器的 telnet 服务？**
- [ ] A. Put NONE in /etc/telnet.allow  
- [ ] B. Put a line 'ALL:ALL' in /etc/hosts.deny  
- [ ] C. Comment the telnet entry in /etc/inittab  
- [x] **D. Comment the telnet entry in /etc/xinetd.conf**

**94. 在哪个文件中保存了 sendmail 的别名？**
- [x] **A. /etc/aliases**
- [ ] B. /etc/mailaliases  
- [ ] C. /etc/sendmail.aliases  
- [ ] D. /etc/sendmail/aliases  

**95.smbd and nmbddaemons 的配置文件是：**
- [ ] A. /etc/exports  
- [x] **B. /etc/smb.conf**
- [ ] C. /etc/samba/config  
- [ ] D. /usr/local/samba.cfg

**96. 下面哪个命令用来卸载一个内核模块？**
- [x] **A. rmmod**
- [ ] B. unmod  
- [ ] C. delmod  
- [ ] D. modprobe

**97. 什么情况下必须运行 lilo**
- [ ] A. once a day from cron
- [ ] B. once a week from cron
- [x] **C. after installing a new kernel**
- [ ] D. after installing a new module

**98. 什么命令显示所有装载的模块？**
- [x] **A. lsmod**
- [ ] B. dirmod  
- [ ] C. modules  
- [ ] D. modlist

**99. 下面哪个命令刷新打印机队列？**
- [ ] A. lpflush  
- [x] **B. lprm -**
- [ ] C. lpclear  
- [ ] D. lprm all

**100. 下面哪个命令可以查看网卡的中断？**
- [ ] A. cat /proc/ioports  
- [x] **B. cat /proc/interrupts**
- [ ] C. cat /proc/memoryinfo  
- [ ] D. which interrupts

> 拓展：46个Linux面试常见问题送给你
：https://www.cnblogs.com/passzhang/p/8552757.html