---
- layout: post
- title: "重学编程-PHP”"
- date: 2022-11-26
- tags: [PHP]
---

[TOC]

# WSL2 Debian 编译安装 PHP 8.2 (LNMP)

- [PHP 底层](https://yangxikun.com/tags.html#PHP%E5%BA%95%E5%B1%82-ref)


性能追踪&&分析的一些文章：

- PHP 性能分析工具-Xhprof：https://www.wkwkk.com/articles/77160c24ad336f58.html
- php7如何使用xhprof测试php性能？https://www.php.cn/topic/php7/455354.html
- Tideways、xhprof 和 xhgui 打造 PHP 非侵入式监控平台：https://learnku.com/articles/29967
- 安装Tideways和Toolkit对PHP代码进行性能分析：https://qq52o.me/2680.html
- 性能调优利器：火焰图：https://www.infoq.cn/article/a8kmnxdhbwmzxzsytlga
- 如何读懂火焰图：https://www.ruanyifeng.com/blog/2017/09/flame-graph.html

高并发的一些文章：

- 关于 PHP 高并发：https://www.v2ex.com/t/855361


- [PHP 后端成长路线图](https://learnku.com/laravel/t/66831)
![php roadmap](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/2ma4v7424vdtxfb9b8wr.jpg)

## 推荐
- [高质量 PHP 社区：The League of Extraordinary Packages](https://thephpleague.com/)
- [PHP 学习笔记](http://static.kancloud.cn/a173512/php_note/1708928)
- [PHP 之道（PHP The Right Way 中文版）](https://learnku.com/docs/php-the-right-way/PHP8.0)
- [PHP 设计模式全集](https://learnku.com/docs/php-design-patterns/2018)
- [PHP 内核与原生扩展开发](https://learnku.com/docs/php-internals/php7)
- [Elasticsearch-PHP 中文文档](https://learnku.com/docs/elasticsearch-php/6.0)
- [Popular Packages](https://packagist.org/explore/popular)
- [PHP 包管理演进之路](https://phil.tech/2012/packages-the-way-forward-for-php/)
- [Swagger-PHP](https://github.com/zircote/swagger-php)
- [Laravel 之道](https://learnku.com/docs/the-laravel-way/5.6)
- [laravel容器container 阅读记录](https://www.cnblogs.com/yxzamy/p/7591968.html)
- [laravel application 容器app](https://www.cnblogs.com/yxzamy/p/7612531.html)
- [Laravel框架 – 容器、绑定与依赖注入](https://www.hawu.me/coding/1108)
- [php使用register_tick_function来定位执行慢的代码](https://developer.aliyun.com/article/1085732)
- [PHP的ticks机制](https://php7.shujuwajue.com/fu-5f55-php-de-ticks-ji-zhi)

## 一些知识

### √ PHP 能做什么？


PHP 是一门**解释型、服务端、动态、弱类型编程语言**，理论上所有的编程语言都是一样：“可以做任何事情”。考虑到实现成本上 PHP 脚本主要多用于三个领域：

- **做 Web 服务端脚本**：这个是 PHP 最传统，也是最主要的目标领域。
- 命令行脚本：通过 CLI 模式调用执行 PHP 脚本，一般针对本身已经是 PHP 架构的公司才会选择，单纯 CLI 脚本可能更多会选择 Shell、Python、Perl 等更多小巧的语言。
- 桌面应用程序：PHP-GTK 可以实现，不过...为什么不用 C#.Net 呢？这么想不开用 PHP 来写桌面干嘛...

因此基本关注：**Web 服务端脚本**、**命令行脚本**

### √ PHP 是动态、解释型、弱类型编程语言

> [动态类型、静态类型和强类型、弱类型的区别](https://blog.csdn.net/is_Javaer/article/details/82024900)

- 解释型：一边执行一边转换，需要哪些源代码就转换哪些源代码，不会生成可执行程序，通过“解释器”完成这个步骤。
- 编译型：必须提前将**所有源代码一次性转换成二进制指令**，即：生成一个可执行二进制程序，通过“编译器”完成这个步骤。

![编译型vs解释型](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20221223121254.png)


**强类型和弱类型指的是编程语言的类型系统的严格程度，并且强制转换并没有改变变量类型，其改变的是变量的值的类型，以便进行赋值，而没有改变变量的类型。**

- 强类型：变量的类型必须明确指定，一旦声明确定那么在其整个生命周期中任何时刻对于该变量来说其类型都是不能改变的，因此不能将一种类型的值赋给另一种类型的变量，一旦这样做就会发生致命错误。
- 弱类型：变量的类型可以在运行时动态更改，并且可以将不同类型的值赋给同一个变量，在一个变量生命周期中其类型在不同的时刻可能是不同的。


**静态语言和动态语言指的是编程语言的类型检查的时机**


静态语言是指**类型检查通常在编译时进行**。在编译时就已经确定了所有变量的类型，并且在运行时无法改变变量的类型。因此，在编译时，编译器会检查代码中的所有类型错误，并在发现错误时报告错误。这使得**静态语言在编写代码时更加安全和可靠，因为它们更难出现运行时错误**。

动态语言是指**类型检查通常在运行时进行**。程序一般无需编译可直接运行，在运行时才能确定变量的类型，并且可以在运行时改变变量的类型。因此，**在编译时不会检查类型错误，而是在运行时发现并报告错误（即：报错的时候代码可能已经运行了一半了）**。这使得**动态语言更灵活，但也更容易出现运行时错误**。

### √ PHP8 新特性 - JIT

[`PHP8` 新特性](https://php.watch/versions/8.0)中比较让人感兴趣的是： **[`JIT (Just-in-time compilation)`](https://php.watch/versions/8.0/JIT)、[注解](https://www.php.net/manual/zh/language.attributes.php)** 的支持。

> In PHP 8.0, JIT is enabled by default, but turned off. 在 PHP 8.0中，JIT 在默认情况下是启用的，但是关闭的。即：安装不需要通过 `--enable-jit` 来指定开启，但是使用需要用户自行开启。

常见的编译方式，如果从编译时机来区分可粗略的划分为：

- 静态编译（Static Compilation）：指的是“程序需要提前编译，生成对应的字节码/汇编/机器代码”，静态编译也叫“事前编译（Ahead-Of-Time Compilation，简称 AOT）”。
- 动态编译（Dynamic Compilation）：指的是“在程序运行的时候才进行编译”，即：动态生成汇编或其它中间代码，我们称这类动态编译的编程语言为“解释型语言”，其编译器成为你“解释器”。


注意：“编译方式” 和 语言是 “强类型、弱类型” 、“静态语言、动态语言” 没有直接关系。

动态编译比较灵活，因此根据实现技术的不同也分化出了一些特殊概念，如：JIT、自适应编译...

**自适应动态编译（Adaptive Dynamic Compilation）是一种预编译技术**，它 也是一种动态编译方式，它会在程序开始执行之前，将程序的一部分或全部代码预先编译为本地机器码。

但它需要在程序开始执行后一段时间才会激活，因为它需要先收集运行时信息，才能根据信息进行优化。

即：先让程序“以某种式”先运行起来，收集一些信息之后再在程序运行的过程进行动态编译，这样的编译可以更加优化。

**[即时编译-JIT（Just-In-Time）](https://www.cnblogs.com/dzhou/p/9549839.html)是一种用于加速程序执行的技术**，狭义上来说它属于“动态编译”过程中的一个特殊技术。

 `JIT` 编译器最初是在 `Java` 中实现的，但 `JIT` 编译器的概念最初是由在 1960 年代开发的 `Lisp` 语言中提出的。当时，`Lisp` 语言的解释器会**在运行时将 `Lisp` 代码转换为本地机器码**并执行，这就是 `JIT` 编译器的原型。 后来 `JIT` 编译器的概念也被应用到了其他语言中，例如 `Smalltalk`、`Java`、`C#`、`Python`、`PHP`。

传统的编译器会将程序从源代码编译为本地机器码，并将其保存在硬盘上，然后在需要执行程序时加载和执行本地机器码。

`Java` 的编译器则是将源代码编译为 `*.class` 字节码，然后在运行时再由 `JVM` 中的字节码解释器解释运行字节码，将字节码转为机器代码，从而实现“跨平台执行”的特性。

但当虚拟机发现某个方法或代码块的运行特别频繁时，就会把这些代码认定为“热点代码”。为了提高热点代码的执行效率，**在运行时虚拟机将会把这些代码编译成与本地平台相关的机器码，并进行各种层次的优化**，完成这个任务的编译器称为即时编译器（`Just In Time Compiler`，简称：`JIT` 编译器），这个技术就叫 `JIT` - 即时编译技术。

`Java` 虚拟机（`JVM`）内置了 `JIT` 编译器，因此在运行 `Java` 程序时会自动使用 `JIT `编译器。通常情况下，`Java JIT` 编译器会在程序的某些特定代码段被多次执行时才会被激活，以便将这些代码转换为本地机器码。这种做法的好处在于，**只有经常使用的代码才会被编译（对于只执行1次的代码来说，JIT 反而是更慢了）**，这可以避免浪费资源来编译不常使用的代码。

[`PHP JIT (Just-in-time compilation)`](https://php.watch/versions/8.0/JIT) 是 `PHP 8.0` 中引入的一项新功能，它可以将 `PHP` 代码在 `Opcache` 优化的基础之上，结合运行时动态编译为本地机器码并执行。

![PHP JIT](https://minsonlee.github.io/images/pig/php-jit.png)

`PHP JIT` 编译器和 `Java JIT` 编译器之间也有一些区别。

首先，`PHP` 是一种动态语言，而 `Java` 是一种静态语言。这意味着 `PHP` 程序在运行时可以改变变量的类型，并且可以动态地调用函数，而 `Java` 则不具备这些能力。因此，`PHP JIT` 编译器需要解决的问题更复杂，例如如何处理类型转换和动态调用。

其次，`Java JIT` 编译器是内置在 `Java` 虚拟机（`JVM`）中的，并且默认情况下会自动激活。而 `PHP JIT` 编译器需要手动启用，并且在 `PHP` 脚本中需要添加特定的标记来指示哪些代码应该被 `JIT` 编译器优化。

```ini
[JIT]
opcache.jit = 1235;

; 1: 为热函数(经常调用的函数)启用 JIT
; 2: 为循环热路径启用 JIT (频繁的循环迭代)
; 3: 为返回类型预测启用 JIT
; 4：启用 JIT 进行交换机调度
; 5: 为间接调用启用 JIT
```

我觉得鸟哥的 [《PHP 8新特性之JIT简介》](https://www.laruence.com/2020/06/27/5963.html) 文章中的图，更能直观清晰的解释 `PHP-JIT` 的作用，如下图：

![php-jit-from-laruence.com](https://www.laruence.com/medias/2020/06/Screen-Shot-2020-06-28-at-18.31.57.png)



- [PHP 8新特性之JIT简介](https://www.laruence.com/2020/06/27/5963.html)
- [Java技术专区-彻底你明白什么是JIT编译器（Just In Time编译器）](https://blog.51cto.com/alex4dream/3244002)

### PHP 新特性 - 注解

> - [注解概览 ¶](https://www.php.net/manual/zh/language.attributes.overview.php)
> - [理解 PHP 8 中的 Attributes (注解)](https://learnku.com/articles/45766)
> - [PHP 8新特性之Attributes(注解)](https://www.laruence.com/2020/06/12/5902.html)

### √ PHP SAPI

PHP 的运行模式也基本如下：

![PHP ](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/php-arch.png)


- [PHP/Zend Engine](https://gywbd.github.io/posts/2016/2/zend-execution-engine.html)： Zend Engine 最主要的特性就是把 PHP 的边解释边执行的运行方式改为先进行预编译(Compile)，然后再执行(Execute)，类似于 JAVA 的 JVM。

> Zend 引擎是目前 PHP 最主流的解释器（例如：Facebook 的 HHVM 虚拟机，它是将 PHP 转为 C++ 然后再通过 g++ 进行编译执行），Zend Engine 是 C 语言实现。

- ZendAPI：是对 Zend Engine 的 C 接口用 C++11 进行了面向对象封装，从而屏蔽底层 Zend 引擎的接口复杂性。
- [SAPI：Sever Application Programming Interface](https://pigfly88.github.io/php/2018/05/28/php-sapi-cgi-cli-fastcgi-fpm.html) 服务端应用编程接口，是 PHP 提供给应用程序的一组接口。通过这组接口，将 “PHP 编译”、“PHP 代码”进行了解耦
    - mod_phpX：是 PHP 为 Apache 服务器提供的扩展接口模块，作为 Apache 的一个模块嵌入到其内部进行执行调用。
    - ISAPI：是 PHP 为 IIS 服务器提供的扩展接口。
    - PHP-CGI：PHP 官方自带的 FastCGI 协议具体实现，弊端在于修改配置后无法平滑过度、后台进程挂了无法自动重启。
    - [PHP-FPM](https://my.oschina.net/python8/blog/4278400)：也是 PHP 对 FastCGI 协议的非官方（扩展）具体实现，是 **PHP-CGI 进程管理器**，可以实现修改配置后平滑过度。启动一个 master 进程然后再 fork 新的 worker 进程，旧的 worker 进程在执行完毕后会退出不再接收新流量。【**因此在写 CLI 脚本时，最好不要 set_time_limit(0)，遇到脚本超时僵死会导致旧 worker 进程一直存在！！！**】
    - [内置 Web Server](https://www.php.net/manual/zh/features.commandline.webserver.php)

> CGI-Common Gateway Interface 通用网关接口，它是一种规定 Web Server 传递数据标准格式的协议，类似于 HTTP 协议一般。CGI 协议所规定的工作方式在遇到解释型动态程序时，其工作流程如下：Web Server 每收到一个请求，就会 fork 一个 CGI 进程来处理，CGI处理返回结果，然后结束进程，每一个请求都会有进程的启动和销毁会造成很大的开销。

> FastCGI：是 CGI 协议的一个升级协议，具有可伸缩性。它会启动一个常驻的 master 进程预先加载好 CGI 进程的 配置并执行好初始化工作，然后再启动多个 worker 来处理具体的请求，请求处理完之后其 worker 进程也不会退出，而是静候下一次连接。因此避免了“加载配置”、“初始化”的重复工作、避免了进程不断创建、销毁的过程。

CGI 则是采用 多进程方式，FastCGI 采用的则是长连接+进程池的处理方式，，因此：FastCGI 更比 CGI 更好的支持高并发场景，提高性能。

### √ MP or NP or NAP ？

`NP-Nginx+PHP` 模式：`Nginx` 只支持静态资源的加载解析，外部程序不能直接调用或解析，即：所有的外部程序（如 `PHP/Python/Java`）必须通过 `FastCGI 接口/WSGI接口/Tomcat` 等外部协议来调用执行程序脚本，然后这些外部程序脚本再将结果返回给 `Nginx`，经由 `Nginx` 返回给客户端返回。

1. 按需加载转发：只有需要的时候才会将请求转到对应的 `CGI` 进程上进行处理
2. `FastCGI` 协议通过 `TCP/Socket` 方式进行通信，因此可以将 `PHP`、`Nginx` 分别装在不同的服务器上
3. 修改了 `php.ini` 配置之后，只需要重启 `php-fpm` 即可，无需重启 `Nginx`，使得 `Web Server` 和 `CGI` 程序之间解耦

`AP-Apache+PHP` 模式： `PHP` 在编译的时候通过 `--with-apxs2=/path/to/apache2/bin/apxs` 生成 `libphp.so` 模块文件，`Apache` 在配置文件中通过 `LoadModule php_module modules/libphp.so` 将其加载到内存中，后续的 `PHP` 脚本都会通过 `libphp.so` 进行解析。

1. 稳定、高效：`mod_php` 作为一个子模块嵌入到 `Apache` 中一并加载到内存执行，那么主动权在 `Apache` 手上，不会产生额外的通信，因此更加的稳定、高效
2. 每次修改了 `php.ini` 配置之后，需要重启 `Apache`；`Apache` 重新编译之后可能会导致 `PHP` 也需要重新编译
3. 耗费内存：如上述，那么不管请求是否是 PHP 程序（如：CSS/JS等静态资源），Apache 都会一并加载 mod_php 到内存，这是完全没必要的

`NAP-Nginx+Apach+PHP` 模式： `Nginx` 负责静态资源处理，通过 **反向代理** 将 `PHP` 程序转发给 `Apache` 处理，这是最高效的处理方式。但是在没有特别大的高并发场景下，这样做并不能体现很大的优势。

目前大部分都是使用 `Nginx+PHP`，如果静态资源请求较少且比较注重稳定性那么可以选择 `Apache+PHP`，不嫌麻烦也不缺钱那么可以折腾 `Nginx+Apach+PHP`.

###  √ 线程安全和非线程安全版本的区别？

[PHP 线程安全与非线程安全版本的区别深入解析](https://www.php.cn/php-notebook-197286.html)

2000 年 10 月 20 日，`Windows` 发布的第一个 PHP3.0.17 开始就是线程安全的，虽然 `Windows` 在 2020 年宣称不再支持 `PHP8.0` 及其以上的版本，但截止（2023/2/25）依然可以看到在 [PHP For Windows](https://windows.php.net/download/) 提供最新版本的 `PHP8.2.3` 代码支持。

`Linux/Unix` 系统采用多进程的工作方式，而 `Windows` 系统的 `IIS` 服务器是采用多线程的工作方式。如果在 `IIS` 服务器下以 `CGI` 方式运行 `PHP` 会非常的慢，因为：**CGI（PHP-CGI）模式是基于多进程运行，而非多线程**。

因此，如果是使用 `IIS` 来运行 `PHP` 就必须使用 `ISAPI` 的方式来运行（但是好像在 `Windows` 下大部分也是用 `WAMP` 来运行，而不使用 `IIS` 服务），`ISAPI` 是多线程的方式，这样就能快很多。

但由于很多 `PHP` 扩展都是以 `Linux/Unix` 的多进程思想来开发的，这些扩展在 `ISAPI` 的方式运行时就会出错，从而导致 `IIS` 服务器崩溃。

但在 `PHP` 可谓炽手可热的那个年代，`IIS` 想要不被抛弃就必须要解决这个问题。为了兼顾 `IIS` 下 `PHP` 的效率和安全，微软给出了 `FastCGI` 的解决方案：`FastCGI` 可以让 `PHP` 的进程重复利用而不是每一个新的请求就重开一个进程，同时 `FastCGI` 也可以允许几个进程同时执行。

`ISAPI`执行方式是以`DLL`动态库的形式使用，可以在被用户请求后执行，在处理完一个用户请求后不会马上消失，所以需要进行线程安全检查，这样来提高程序的执行效率，所以如果是以`ISAPI`来执行`PHP`，建议选择`Thread Safe`版本；

而`FastCGI`执行方式是以多进程单线程来执行操作，所以不需要进行线程的安全检查，除去线程安全检查的防护反而可以提高执行效率，所以，如果是以`FastCGI`来执行PHP，建议选择`Non Thread Safe`版本。

对于apache服务器来说一般选择isapi方式，而对于nginx服务器则选择FastCGI方式。

### √ LNMP 架构下，NGINX 与 PHP-FPM 通信应该是 Unix Domain Socket 还是 TCP ？

- [nginx和php-fpm通信, unix socket还是tcp?](https://www.awaimai.com/2685.html)

`Nginx` 通过在 `conf.d/*.conf` 文件中使用 `fastcgi_pass <address>` 参数来设置 `Nginx` 和 `FastCGI` 客户端的具体通讯地址。

`Nginx` 和 `FastCGI`（`PHP-FPM` 是 `PHP` 对 `FastCGI` 协议的非官方扩展具体实现）协议通讯有两种方式：
- `TCP` 方式：即 `IP:port`，如：`127.0.0.0:9000`
- `Unix Domain Socket` 方式：即 `Unix` 网络套接字，如：`/dev/shm/xxx.sock`

> 很多在用 socket 方式配置时使用路径 `/tmp`，其实 `/dev/shm/` 是个 `tmpfs`，速度要比读写磁盘文件快得多。

在服务器压力不大的情况下，`TCP/Socket` 两种配置方式的区别并不大，但在单机服务器压力较大时候用 `Socket` 方式效果确实比较好。

因此在单机 `LNMP` 架构中，通常建议使用 `Unix Domain Socket`（也称为 `IPC Socket`）来实现 `NGINX` 和 `PHP-FPM` 之间的通信，而不是 `TCP/IP` 网络套接字。

这是因为 `Unix Domain Socket` 在本地机器上进行通信，不需要像 `TCP` 协议一样需要进行网络层的数据包封装和解封装，因此 `Unix Domain Socket` 比 `TCP/IP` 更快，更可靠，更安全，更易于管理。

#### √ Unix Domain Socket

`Unix Domain Socket` 是 `*nix` 系统进程通信（`IPC`）的一种机制（因此又叫 `IPC Socket`），以文件（一般是 `*.sock` 格式文件）作为 `Socket` 的唯一标识（描述符），需要通信的两个进程引用同一个 `socket` 描述符文件就可以建立通道进行通信了。

`Unix Domain Socket` 是一种基于 BS 模型的全双工通信方式，可以在同一个进程的不同线程之间、不同进程之间 进行数据的传输（管道是半双工的，只能单向数据传输，只能在同一个进程的不同线程间通信）。

`Unix Domain Socket` 的优点：

- 速度更快：基于本地机器的文件系统实现，无需经过网络协议栈，通信速度更快
- 安全更高：因为 `Unix Socket` 仅允许本地访问，因此不会受到来自网络的攻击和恶意访问
- 管理方便：`Unix Socket` 可以在文件系统中直接创建和删除，不需要进行网络配置和管理

```php-fpm.conf
[www]
user = www
group = www
listen = /dev/shm/php8.2.0-fcgi.sock
listen.owner = www
listen.group = www
```

```vhost.conf
location ~ .*\.(php|php5)?$ {
        fastcgi_pass  unix:/dev/shm/php8.2.0-fcgi.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $request_filename;
        include  fastcgi_params;
}
```

注意 `PHP` 的 `listen` 路径需要与 `NGINX` 配置文件中设置的路径一致.

`Unix Domain Socket` 的缺点：

- 仅能用于本地通讯，无法跨越网络：这意味着如果需要将应用部署在多台机器上，或需要将不同应用程序之间进行通信，需要使用 `TCP/IP` 协议
- 需要更高的权限：依赖于文件系统，因此运行用户需要更高的权限来创建和删除 `Socket` 文件
- 无法负载均衡：由于只能本地通信，因此无法进行负载均衡，这意味着在高并发情况下 `Unix Domain Socket` 可能会成为瓶颈，导致系统性能下降
- 不支持 `Windows`：`Unix Socket` 是基于 `Unix` 系统的文件系统实现的，因此无法在 `Windows` 系统上使用

#### √ TCP

`TCP` 方式的优点：

- 可以跨越网络边界：`TCP` 是一种面向网络的协议，可以跨越不同的网络通讯，因此可以支持跨网络的负载均衡
- 更好的扩展性：使用 `TCP` 方式更容易实现负载均衡的扩展
- 支持更多的语言和框架：与 `Unix Domain Socket` 相比，`TCP` 协议具有更加通用的支持性

`TCP` 方式的缺点：

- 配置负载：使用 `TCP` 方式配置还需要额外设置 IP 白名单地址和端口号开放
- 性能较差：因为 `TCP` 要经过网络栈进行传输数据，需要进行数据包装和解包
- 安全性差：由于 `TCP` 端口对外开放，容易遭受攻击，因此在使用 `TCP` 时需要加强安全措施，如 防火墙和加密通信 等


```conf
# https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream
http {
    upstream backend {
        # 默认采用 round-robin/轮询 机制：按时间顺序逐一分配到不同的应用服务器，如果服务器 down 掉能自动剔除
        # weight/比重机制：将访问按照一定的比率进行分配，用于后端服务器性能不均的情况（ps: server 192.168.0.14 weight=3; # 30% 比率访问到 14 机器上）
        # least_conn/最少连接：下一个请求将被分派到活动连接数量最少的服务器
        # ip_hash/IP哈希：基于客户端 IP 地址使用 hash 算法来决定下一个请求要选择哪个服务器
        # ip_hash 可以保证从同一个客户端发起的请求总是定向到同一台服务器，可以解决 session 的问题，除非服务器不可用
        server 192.168.1.1:8080;
        server 192.168.1.2:8080;
    }
 
    server {
        listen 80;
        location / {
            proxy_pass http://backend;
        }
    }
}
```

## PHP 环境搭建

### √ 安装 PHP

- [PHP的几种运行模式cli、fpm、apache、zts比较](https://tongfu.net/home/35/blog/513287.html)
- [docker for php](https://github.com/docker-library/php)

1. 前置准备

```shell
sudo apt update
sudo apt upgrade
```

安装依赖

```shell
sudo apt-get install -y \
 autoconf build-essential curl libtool \
 libssl-dev libcurl4-openssl-dev libsqlite3-dev \
 libxml2-dev libreadline8 libreadline-dev \
 libzip-dev libonig-dev libzip4 openssl \
 pkg-config zlib1g-dev libpng-dev libjpeg-dev \
 libfreetype-dev libsodium-dev libgmp-dev 
```

新增用户

```shell
sudo groupadd -g 500 www # 创建 www 用户组，指定用户组的 groupId 为 500
sudo useradd -u 500 -r -g www -d /home/www www # 创建 www 用户，Id 为 500
passwd www # 设置 www 密码
```

2. 下载安装 `PHP8.2.0`
```shell
sudo mkdir -p /apps/php82 /data/logs/php
cd /appsls
wget https://www.php.net/distributions/php-8.2.0.tar.gz
tar -xf php-8.2.0.tar.gz && rm -f php-8.2.0.tar.gz
```

编译安装 `PHP8.2.0`，可以通过 `./configure -h` 查看支持的编译参数

> [configure 这些选项](https://www.php.net/manual/zh/configure.about.php)只用在编译的时候。如果想要修改 PHP 的运行时配置，请阅读 [运行时配置](https://www.php.net/manual/zh/configuration.php)

```shell
$ cd /apps/php-8.2.0
$ ./configure --prefix=/apps/php82 \
    --with-config-file-path=/apps/php82/etc \
    --with-fpm-user=www \
    --with-fpm-group=www \
    --with-freetype=/usr \
    --with-jpeg=/usr \
    --with-libzip=/usr/lib/x86_64-linux-gnu \
    --with-curl \
    --with-openssl \
    --with-pdo-mysql \
    --with-mysqli \
    --with-pdo-mysql=mysqlnd \
    --with-gmp \
    --with-zlib \
    --with-pear \
    --with-readline \
    --with-sodium \
    --with-zip \
    --with-iconv \
    --enable-mysqlnd \
    --enable-gd \
    --enable-bcmath \
    --enable-fpm \
    --enable-mbstring \
    --enable-opcache \
    --enable-mbstring \
    --enable-phpdbg \
    --enable-shmop \
    --enable-sockets \
    --enable-soap \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-pcntl 

$ make -j # 查看编译结果
$ make && make install
```

3. 配置信息
```shell
cp /apps/source/php-8.2.0/php.ini-* /apps/php82/etc/
cd /apps/php82/etc
cp php.ini-development php.ini
cp php-fpm.conf.default php-fpm.conf
cp php-fpm.d/www.conf.default www.conf
touch php-fpm.d/env.conf
```

`php.ini` 配置信息，见 [`php.ini`核心配置选项说明](https://www.php.net/manual/zh/ini.core.php)

[FastCGI 进程管理器（FPM）配置文件](https://www.php.net/manual/zh/install.fpm.configuration.php) `php-fpm.conf` 全局配置（可以通过 `/path/to/php-fpm -t` 来检查 `php-fpm.conf` 配置文件是否配置正确）

```conf
[global]
pid = run/php-fpm.pid
error_log = /data/logs/php/php-fpm.log
syslog.facility = daemon
syslog.ident = php-fpm
log_level = notice
process.priority = -19
daemonize = yes
events.mechanism = epoll

include=/apps/php82/etc/php-fpm.d/*.conf
```

`php-fpm.d/www.conf` 配置 web 配置

```conf
[www]
user = www
group = www
listen = /dev/shm/php8.2.0-fcgi.sock
listen.owner = www
listen.group = www

pm = static
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 2
pm.max_requests = 500
pm.status_path = /status_php_82

slowlog = /data/logs/php/$pool.log.slow
request_slowlog_timeout = 5

rlimit_files = 1024

catch_workers_output = yes
```

`php-fpm.d/env.conf` 配置环境变量

```conf
[www]
env[CURRENT_ENV] = test
env[IS_NEW_TEST_ENV] = 1

;env[MYSQL_HOST] = xxx
;env[MYSQL_USERNAME]= xxx
;env[MYSQL_PASSWORD]= xxx
```

4. 设置软连

```shell
sudo ln -s /apps/php82/bin/php /usr/local/bin/php
```


### √ PHP 内置 Web Server

> https://www.php.net/manual/zh/features.commandline.webserver.php

`PHP CLI SAPI` 提供了一个内置的 `Web Server` 服务器，没什么太大的实际作用，但可以用于本地开发调试使用，不可用于线上环境。

1. 在 `WSL` 的 `/etc/hosts` 文件中新增域名
```sh
# 我为 WSL 配置了一个虚拟网卡，IP 地址是 192.168.33.10，如果你没有配置那么直接使用 127.0.0.1
$ sudo cat /etc/hosts | grep localserver

192.168.33.10   localserver
```

添加完毕后，还需要在宿主机的 `hosts` 文件中添加上：`192.168.33.10   localserver`。
`Windows` 下推荐使用 [`SwitchHosts`](https://gitcode.net/mirrors/oldj/switchhosts/-/releases) 来配置。

2. 启动 `Web Server`，详细步骤如下图：
```sh
#1 查看 80 端口是否被占用
root in WSL/php/default via 🐘 v8.2.0
⬢ [Systemd] ❯ lsof -i:80
COMMAND PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
nginx   141 root   11u  IPv4  20149      0t0  TCP *:http (LISTEN)
nginx   142  www   11u  IPv4  20149      0t0  TCP *:http (LISTEN)
nginx   143  www   11u  IPv4  20149      0t0  TCP *:http (LISTEN)
nginx   144  www   11u  IPv4  20149      0t0  TCP *:http (LISTEN)
nginx   145  www   11u  IPv4  20149      0t0  TCP *:http (LISTEN)

#2 进入项目目录
root in WSL/php/default via 🐘 v8.2.0
⬢ [Systemd] ❯ pwd && ls && cat `pwd`/*
/mnt/d/WSL/php/default
index.php
<?php

phpinfo();

#3 启动 WebServer（由于 80 端口被占用了，因此我将程序服务启动在 800 端口）
root in WSL/php/default via 🐘 v8.2.0
⬢ [Systemd] ❯ php -S localserver:800 -t /mnt/d/WSL/php/default
[Wed Apr  5 02:55:52 2023] PHP 8.2.0 Development Server (http://localserver:800) started
```

此时在宿主机访问 `http://localserver:800/` 就可以查看信息了，默认访问顺序 `index.php > index.html`，如果两个文件都不在则报 404。

### √ PHP配置文件php.ini的放在哪个位置？

方法1：通过 php-config 获取 PHP 配置信息

```
/php-bin-path/php-config --ini-path
```

方法2：通过 `phpinfo()` 探针信息
```php
<?php
    phpinfo();
```
可以在探针信息中查看到 "Loaded Configuration File"

方法3：CLI 模式通过 `php -i` 查找
```sh
$ php -i | grep "Loaded Configuration File"
```

![php -i](https://minsonlee.github.io/images/pig/where-is-php-config.png)

![php --ini](https://minsonlee.github.io/images/pig/where-is-php-config-php-ini.png)

PHP-FPM 启动时指定加载 `php.ini` 可以通过 `php/sbin/php-fpm -y php/etc/php-fpm.conf -c php/etc/php.ini` 指定，如果没有 `-c` 参数则从编译时指定的 `--with-config-file-path=xxx` 位置加载。

可以通过编辑 `/lib/systemd/system/php-fpm.service` 或 `/etc/init.d/php-fpm` 中 PHP-FPM 启动命令

方法4：通过 PHP 内置函数 [`php_ini_loaded_file()`](https://www.php.net/manual/zh/function.php-ini-loaded-file.php) 得到当前加载配置文件的路径，如果没有加载则返回 false

**！！！可以通过 `/path/to/php-fpm -t|--test` 来检查 `php-fpm.conf` 配置文件是否配置正确**

###  √ IDEA 中设置 PHP 相关信息

![WSL for PHP](https://minsonlee.github.io/images/pig/idea-config-php-wsl.png)

###  √ 将 PHP-FPM 注册为 System/init.d 服务

System 管理脚本可以查看：[php-fpm.service.in](https://github.com/php/php-src/blob/master/sapi/fpm/php-fpm.service.in)，Init 管理脚本可以查看：[init.d.php-fpm.in](https://github.com/php/php-src/blob/master/sapi/fpm/init.d.php-fpm.in)。参考：[官方文档：Init script setup](https://www.php.net/manual/zh/install.fpm.php#101366) 进行相应修改。

```shell
# 下载示例文件
sudo wget -O /etc/init.d/php-fpm "https://raw.githubusercontent.com/php/php-src/master/sapi/fpm/init.d.php-fpm.in"
```

更改文件 `vi /etc/init.d/php-fpm` 中对应配置信息即可。

```sh
prefix=
exec_prefix=

php_fpm_BIN=/apps/php82/sbin/php-fpm
php_fpm_CONF=/apps/php82/etc/php-fpm.conf
php_fpm_PID=/apps/php82/var/run/php-fpm.pid
```


Centos7 开机启动
```sh
# 开机启动
$ systemctl enable php-fpm.service
```

```sh
# 开机不启动：
$ systemctl disable php-fpm.service
```

Centos6 开机启动

```sh
# 加入 chkconfig 管理：
$ chkconfig --add php-fpm

#开机启动：
$ chkconfig --level 345 php-fpm on

# 开机不启动：
$ chkconfig php-fpm off

#查看开机是否启动
$ chkconfig --list php-fpm
```

### 如何查看 PHP 编译时用到的参数？

当我们编译php的时候可能用到了很多的参数，但是时间一长，自己也不记得当时使用了哪些参数，此时可以通过下面这一行命令，就可以直接在服务器上看到，当前php编译时用到了哪些参数。

```php
php -r "phpinfo();" | grep configure
```

或者 

```sh
php -i | grep configure
```


## PHP 扩展

###  √ PHP 扩展安装

- 获取或者 Browse Packages ： https://pecl.php.net/packages.php
- 在 `php.ini` 中开启扩展 `extension=memcache`
- 配置： 可以查看 [PHP: 其它服务 - Manual](https://www.php.net/manual/zh/refs.remote.other.php)

```shell
# 安装 memcache
wget http://pecl.php.net/get/memcache && tar -zxvf memcache && cd memcache-*/ && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make && make install
```

```shell
# 安装 memcached
sudo apt install -y libmemcached-dev
wget https://pecl.php.net/get/memcached && tar -zxvf memcached && cd memcached-*/ && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make && make install
```

```shell
# 安装 Gearman
sudo apt install -y libgearman-dev
wget https://pecl.php.net/get/gearman && tar -zxvf gearman && cd gearman-*/ && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make && make install
```

```shell
# 安装 amqp 扩展
sudo apt install -y librabbitmq-dev
wget https://pecl.php.net/get/amqp && tar -zxvf amqp && cd amqp-* && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make && make install
```

```shell
# 安装 redis 扩展
wget https://pecl.php.net/get/redis && tar -zxvf redis && cd redis-* && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make && make install
```

```shell
# 安装 mongodb 扩展
wget https://pecl.php.net/get/mongodb && tar -zxvf mongodb && cd mongodb-* && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make && make install
```

```shell
# 安装 mcrypt 扩展
sudo apt install -y libmcrypt-dev
wget https://pecl.php.net/get/mcrypt && tar -zxvf mcrypt && cd mcrypt-* && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make && make install
```

```shell
# 安装 timezonedb 扩展
wget https://pecl.php.net/get/timezonedb && tar -zxvf timezonedb && cd timezonedb-* && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make && make install
```

```shell
# 安装 swoole 扩展
sudo apt install -y librabbitmq-dev
wget https://pecl.php.net/get/swoole && tar -zxvf swoole && cd swoole-* && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make && make install

## php --ri swoole #可以查看 swoole 版本信息
```

```shell
# 安装 gRPC 扩展
sudo apt install -y librabbitmq-dev
wget https://pecl.php.net/get/gRPC && tar -zxvf gRPC && cd grpc-* && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make && make install
```

```shell
# 安装 xdebug 扩展
wget "https://xdebug.org/files/xdebug-3.2.0.tgz" &&  tar -zxvf xdebug-3.2.0.tgz && cd xdebug-*/ && /apps/php82/bin/phpize
./configure --with-php-config=/apps/php82/bin/php-config
make -j2

cp modules/xdebug.so /apps/php82/lib/php/extensions/no-debug-non-zts-20220829
```

`php.ini` 开启配置

```
zend_extension = "opcache.so"
extension = "memcache.so"
extension = "memcached.so"
extension = "gearman.so"
extension = "mongodb.so"
extension = "redis.so"
extension = "timezonedb.so"
extension = "swoole.so"
extension = "amqp.so"
extension = "mcrypt.so"
extension = "grpc.so"
extension = "yaml.so"
zend_extension = "xdebug"

[xdebug]
xdebug.idekey="PHPSTORM"
xdebug.mode=debug
xdebug.start_with_request=trigger
xdebug.client_host="192.168.33.1"
xdebug.client_discover_header=""
xdebug.discover_client_host=true
xdebug.client_port=9003
xdebug.remote_handler="dbgp"
xdebug.log="/tmp/xdebug.log"
```



###  √ PHP 编译支持 yaml 扩展

**1、什么是 yaml**

> 以下内容来自-维基百科：https://zh.wikipedia.org/wiki/YAML

`YAML`（/ˈjæməl/，尾音类似 camel ) 是 **`YAML Ain't Markup Language` - YAML不是一种标记语言** 的外语缩写；但为了强调这种语言以数据做为中心，而不是以置标语言为重点，而用返璞词重新命名。它是一种直观的能够被电脑识别的数据序列化格式，是一个**可读性高**并且**容易被人类阅读，容易和脚本语言交互**，用来**表达信息序列**的编程语言。

它是类似于标准通用标记语言的子集XML的数据描述语言，**语法比XML简单**很多。

- 大小写敏感
- 使用空格缩进表示层级关系（左侧空格缩进对齐，表示同一层级）
- 支持数据结构简单：对象、数组、纯量（即单独不可分割的值）

```yaml
# 对象 key: value（注意冒号后有一个空格）
animal: pets
animals: { type: pets, nameCn: 宠物 }

# 数组：一组连词线开头的行，构成一个数组
animals:
  - dog
  - cat
  
# 纯量
name: test
- 字符串
    - a
    - aa
- 布尔值
    - true
    - false
- 整数: 1
- 浮点数: 3.1415926
- 时间: 2001-12-14t21:59:43.10-05:00 
- 日期: 1976-07-31
- Null: ~
```
> 具体语法可参阅：[¶：阮一峰的博客 - YAML 语言教程](http://www.ruanyifeng.com/blog/2016/07/yaml.html)


---


**2、安装步骤**

> 查看当前版本 PHP 是否安装了 `yaml` 扩展，执行：`/apps/php82/bin/php -m | grep yaml`，若没有返回信息则没有安装

1. 下载源码包：`cd /apps/source/ && sudo wget -O yaml.tgz "https://pecl.php.net/get/yaml-2.2.2.tgz"`
2. 解压源码包：`mkdir /apps/source/yaml && tar -xvzf yaml.tgz -C /apps/source/yaml`
3. 利用 phpize 编译扩展库：`cd yaml/yaml-* && /apps/php82/bin/phpize`
4. 指定扩展安装的 PHP 版本：`./configure --with-php-config=/apps/php82/bin/php-config`
5. 编译扩展：`make -j2` 当见到如下截图返回信息，证明编译成功！
    <br/>![make test](https://minsonlee.github.io/images/pig/make-test-for-php.png)
6. 安装编译扩展：`make install`，当见到如下截图返回信息，证明安装成功！
    <br/>![make install](https://minsonlee.github.io/images/pig/make-install.png)
7. 在 `php.ini` 中引入 `yaml` 扩展：
    ```ini
    [Yaml]
    extension = "yaml.so"    
    ```
8. 重启 `php-fpm` && `nginx`
    - `sevice php-fpm restart`
    - `sevice nginx restart`

---

**3、踩过的坑**

1. 多版本 PHP 导致编译报错：`configure: error: Cannot find php-config.`

```ssh
[root@vagrant-centos610 yaml-2.0.4]# ./configure
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for a sed that does not truncate output... /bin/sed
checking for cc... cc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables... 
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether cc accepts -g... yes
checking for cc option to accept ISO C89... none needed
checking how to run the C preprocessor... cc -E
checking for icc... no
checking for suncc... no
checking whether cc understands -c and -o together... yes
checking for system library directory... lib
checking if compiler supports -R... no
checking if compiler supports -Wl,-rpath,... yes
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
checking target system type... x86_64-unknown-linux-gnu
configure: error: Cannot find php-config. Please use --with-php-config=PATH
```

**解决：多版本 PHP 导致编译报错**

> 为 `./configure` 指定 `php-config` 位置： `./configure --with-php-config=/apps/php82/bin/php-config`


2. 编译报错：linux libyaml 库丢失  `configure: error: Please install libyaml`

```ssh
[root@vagrant-centos610 yaml-2.0.4]# ./configure --with-php-config=/apps/php82/bin/php-config 
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for a sed that does not truncate output... /bin/sed
checking for cc... cc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables... 
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether cc accepts -g... yes
checking for cc option to accept ISO C89... none needed
checking how to run the C preprocessor... cc -E
checking for icc... no
checking for suncc... no
checking whether cc understands -c and -o together... yes
checking for system library directory... lib
checking if compiler supports -R... no
checking if compiler supports -Wl,-rpath,... yes
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
checking target system type... x86_64-unknown-linux-gnu
checking for PHP prefix... /apps/php72
checking for PHP includes... -I/apps/php72/include/php -I/apps/php72/include/php/main -I/apps/php72/include/php/TSRM -I/apps/php72/include/php/Zend -I/apps/php72/include/php/ext -I/apps/php72/include/php/ext/date/lib
checking for PHP extension directory... /apps/php72/lib/php/extensions/no-debug-zts-20170718
checking for PHP installed headers prefix... /apps/php72/include/php
checking if debug is enabled... no
checking if zts is enabled... yes
checking for re2c... no
configure: WARNING: You will need re2c 0.13.4 or later if you want to regenerate PHP parsers.
checking for gawk... gawk
checking whether to enable LibYAML suppot... yes, shared
checking for yaml headers... not found
configure: error: Please install libyaml
```

**解决：linux 系统 libyaml 库丢失编译报错**

1. 查看当前系统是否已经安装了 libyaml 相关类库： `yum list installed | grep yaml`
    <br/>![yum list installed | grep yaml](https://minsonlee.github.io/images/pig/yum-list-installed-for-yaml.png)
2. 查找 yum 支持的 libyaml 类库：`yum search libyaml`
    <br/>![yum search libyaml](https://minsonlee.github.io/images/pig/yum-search-libyaml.png)
3. 安装 `libyaml-devel.x86_64` 库：`yum -y install libyaml-devel.x86_64`
    <br/>![yum -y install libyaml-devel.x86_64](https://minsonlee.github.io/images/pig/yum-install-libyaml.png)
4. 重新编译，即可会生成 makefile
    <br/>![makefile](https://minsonlee.github.io/images/pig/gen-makefile.png)


---

**4、拓展阅读**

- [¶：YAML 语言教程](http://www.ruanyifeng.com/blog/2016/07/yaml.html)
- [¶：PECL 扩展库安装](https://www.php.net/manual/zh/install.pecl.php)
- [¶：configure-error-please-install-libyaml](https://superuser.com/questions/807248/configure-error-please-install-libyaml)

###  √ PHP 使用 Protobuf

[ProtoBuf （Google Protocol Buffer）](https://github.com/protocolbuffers/protobuf/tree/main/php)是 Google 用于数据交换的序列结构化数据格式，具**有跨平台、跨语言、可扩展**特性，类型不同于常用的 XML 及 JSON，但具有**更小的传输体积、更高的编码、解码能力**，特别适合于**数据存储、网络数据传输**等对存储体积、实时性要求高的领域，以 `*.proto` 为文件后缀。

简单来说：通过 `*.proto` 描述文件来定义数据结构，然后 `protoc` 命令生成对应的代码类（如：`/path/for/protobuf/bin/protoc --php_out=/data/output/path xxx.proto`），然后**通过生成的类来完成对 `*.proto` 描述文件中定义的数据结构进行 getter/setter/序列化/反序列化 操作**。序列化的格式支持 二进制（默认）/压缩后的JSON 因此数据大小比传统的 JSON/XML 要小很多。

更多关于如何使用 ProtoBuf 可以查看：[ProtoBuf3 Google 官方 使用指南](https://developers.google.com/protocol-buffers/docs/proto3)。关于 [ProtoBuf 安装及 PHP 如何使用 ProtoBuf](https://github.com/protocolbuffers/protobuf/tree/main/php)，可以看 GitHub Readme 信息。


#### √ 安装 ProtoBuf 系统库

Ubuntu `apt-get install -y php-pear php-dev libtool make gcc`、 CentOS `yum install -y php-pear php-dev libtool make gcc-c++` 需要提前安装依赖。

```shell
# 下载 Protocol Buffers： https://github.com/protocolbuffers/protobuf/releases
cd /apps/source &&  wget "https://github.com/protocolbuffers/protobuf/releases/download/v21.11/protobuf-php-3.21.11.tar.gz"

# 解压
tar -zxvf protobuf-php-3.21.11.tar.gz

# 编译安装
sudo mkdir /apps/protobuf
cd protobuf-3.21.11/
./configure --prefix=/apps/protobuf
make -j2 && make install
```

#### √ Protobuf for PHP

![protobuf for php](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/protobuf-for-php.png)

来看一个官方给的实例：

1. 定义 `person.proto` 描述数据结构

```protobuf
syntax="proto3" // 表示使用 proto3 格式，默认是 proto2
package test; // 定义包名，生成类的时候会产生一个 test 目录
message Person{ // 定义一个消息类型
    string name=1; // 姓名
    int32 age=2; // 年龄
    bool sex=0;// 性别：0-位置；1-男；2-女
}
```

`message` 的格式：数据类型 变量名=在二进制数据中的位置(需要唯一)

2. 根据描述文件生成对应语言（PS：PHP）的类库（我的 protobuf 安装在 /apps 目录下）

```sh
# 利用系统安装的 protoc 生成 PHP 类库
/apps/protobuf/bin/protoc --php_out=/data/htdocs/person person.proto
```

当然每次调用之前都先这样操作一次也挺烦人，那么可以使用 `/path/for/php/bin/pecl install protobuf` 安装 `PHP` 扩展，然后通过 `PHP` 来操作 `*.proto` 生成对应类.

执行后会在 `/data/htdocs/person` 生成 `GPBMetadata/Person.php` 和 `Test/Person.php` 两个文件

3. 在 PHP 中使用 ProtoBuf 

在项目文件执行 `composer require google/protobuf` 引入扩展包。

`index.php` 序列化示例代码

```php
<?php
include 'vendor/autoload.php';
include 'GPBMetadata/Person.php';
include 'Test/Person.php';

$person = new Test\Person();
$person->setName('limingshuang');
$person->setAge(28);
$person->setSex(true);

$data = $person->serializeToString();

file_put_contents('data.bin', $data); // 生成压缩二进制文件
file_put_contents('data.json', $person->serializeToJsonString()); // 生成 json 格式文件
```

![ProtoBuf 生成数据](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/protobuf-bin-and-json.png)

从图片中可以看二进制的 `data.bin` 具有更小的体积，而且序列化速度也非常快。

`test.php` 发序列化示例代码

```php
<?php
include 'vendor/autoload.php';
include 'GPBMetadata/Person.php';
include 'Test/Person.php';

$binData = file_get_contents('data.bin');
$person = new Test\Person();
$person->mergeFromString($binData);
echo $person->getName();

$jsonData = file_get_contents('data.json');
$person1 = new Test\Person();
$person1->mergeFromJsonString($jsonData);
echo $person->getAge();
```

ProtoBuf for PHP 中常用

- 序列化函数：
    1. `serializeToString` 序列化成二进制字符串 
    2. `serializeToJsonString` 序列化成JSON字符串
- 反序列化函数
    1. `mergeFromString` 二进制字符串反序列化
    2. `mergeFromJsonString` Json 字符串反序列化


将 Protobuf 二进制存储到数据库时需要注意以下几点：

1、数据类型：在数据库中存储 Protobuf 二进制时，需要将其存储为 BLOB（二进制大对象）类型。BLOB 数据类型是一种用于存储二进制数据的特殊类型，通常用于存储图像、音频、视频、文档等二进制数据。

2、序列化和反序列化：在将 Protobuf 对象存储到数据库中之前，需要将其序列化为二进制格式。在从数据库中读取数据时，需要将二进制数据反序列化为 Protobuf 对象。在进行序列化和反序列化操作时，需要使用 Protobuf 提供的相应函数，确保数据的正确性。

3、数据存储的大小限制：在将 Protobuf 二进制存储到数据库中时，需要考虑数据存储的大小限制。不同的数据库对数据存储的大小有不同的限制，需要根据实际情况进行调整。如果数据存储的大小超过了数据库的限制，可能会导致数据丢失或损坏。

4、数据索引和查询：如果需要对存储的 Protobuf 数据进行查询或索引，需要在数据库中创建相应的索引，以便更快地进行数据查询和检索。在创建索引时，需要考虑数据的大小和数据类型等因素。

5、数据一致性：在将 Protobuf 数据存储到数据库中时，需要考虑数据的一致性问题。如果多个客户端同时对同一份数据进行修改，可能会导致数据不一致。为了确保数据的一致性，需要使用数据库事务和锁等机制。

综上所述，将 Protobuf 二进制存储到数据库时需要考虑数据类型、序列化和反序列化、数据存储的大小限制、数据索引和查询以及数据一致性等因素。通过合理的数据存储方案，可以确保数据的安全性、可靠性和一致性。


如果你想使用 PHP 动态索引数组作为 Protobuf 消息类型中的字段类型，可以使用 repeated 字段类型和 map 字段类型。

repeated 字段类型将映射到 PHP 数组类型，而 map 字段类型将映射到 PHP 关联数组类型。下面是一个示例，演示如何在 Protobuf 消息类型中使用这两种类型来实现动态索引数组。

例如，以下是一个示例 proto 文件，其中包含两个消息类型：MyMessage 和 MyMapMessage。

```proto
syntax = "proto3";

message MyMessage {
  repeated int32 my_array = 1;
}

message MyMapMessage {
  map<int32, string> my_map = 1;
}
```

然后，你可以使用 Protobuf-PHP 库将该 proto 文件编译为 PHP 类，并使用 PHP 数组或关联数组来访问该消息类型中的字段：

```php
<?php
// 编译 proto 文件并生成 PHP 类
$protoFilePath = "path/to/my_proto.proto";
$protoc = new \Protobuf\Compiler\Protoc();
$protoc->generate($protoFilePath);

// 创建 MyMessage 实例
$message = new \MyNamespace\MyMessage();

// 设置动态索引数组字段
$message->setMyArray([1, 2, 3]);

// 添加元素到动态索引数组字段
$message->appendMyArray(4);

// 获取动态索引数组字段
$array = $message->getMyArray();

// 遍历动态索引数组字段
foreach ($array as $value) {
  echo $value . "\n";
}

// 创建 MyMapMessage 实例
$mapMessage = new \MyNamespace\MyMapMessage();

// 设置动态关联数组字段
$mapMessage->setMyMap([1 => "one", 2 => "two", 3 => "three"]);

// 添加元素到动态关联数组字段
$mapMessage->putMyMap(4, "four");

// 获取动态关联数组字段
$map = $mapMessage->getMyMap();

// 遍历动态关联数组字段
foreach ($map as $key => $value) {
  echo $key . " => " . $value . "\n";
}
```

在上面的示例中，repeated 字段类型被映射为 PHP 数组类型，而 map 字段类型被映射为 PHP 关联数组类型，因此可以使用 PHP 数组或关联数组操作来访问和修改动态索引数组字段。setMyArray() 和 setMyMap() 方法用于设置整个数组或关联数组，appendMyArray() 方法用于向数组中添加元素，putMyMap() 方法用于向关联数组中添加元素，getMyArray() 和 getMyMap() 方法用于获取整个数组或关联数组。

#### √ 扩展阅读：Apache Thrift vs Protobuf

- [Apache Thrift vs Protobuf](https://stackshare.io/stackups/apache-thrift-vs-protobuf)
- [Apache Thrift PHP Tutorial](https://thrift.apache.org/tutorial/php.html)
- [比较跨语言通讯框架：thrift 和 Protobuf](http://chengxu.org/p/440.html)
- [Apache Thrift系列详解(一) - 概述与入门](https://zhuanlan.zhihu.com/p/45194118)

Apache Thrift 是一个可扩展的跨语言服务开发的**软件框架**。它结合了一个软件堆栈和代码生成引擎，可以构建在C++、Java、Python、PHP、Ruby、Erlang、Perl、Haskell、C#、Cocoa、JavaScript、Node.js、Smalltalk、OCaml和Delphi等多种语言之间高效无缝工作的服务。

Protobuf 是谷歌开源的**数据交换格式协议**，是一种语言中立、平台中立、可扩展的机制，用于**序列化结构化数据**。类比XML，但Protobuf更小、更快、更简单。

 - | Protobuf | Apache Thrift
---| ---- | --- 
社区 | √ Google 开源，文档更加丰富 | 2007 年 Facebook 开发，08 年由 Apache 基金会支持维护，文档相对支持弱
功能 | 设计更加简单，仅支持一些基本数据类型 | √ 复杂的数据类型和 RPC（Remote Procedure Call）机制，提供了丰富的代码生成工具，能够自动生成各种语言的客户端和服务端代码
学习 | √ 只能使用简单的消息定义语言来定义消息类型，在 API 调用上也更加简单，使用静态方法调用消息类型 | 使用 IDL（Interface Description Language）中间语言来定义数据结构、异常、服务接口等，API 设计上类似 Java 和 C++ 的面向对象设计风格，将服务接口定义为类，并在类中定义方法，学习具有一定的曲线
语言 | 2023/02/21 支持 10 大主流语言 | √ 支持 18 种语言
格式 | 使用可变长度编码（Variable-Length Encoding，VLE），数据更小 |  √ 支持的编码格式更多，更复杂也更灵活
传输 | √ **通常**比 Thrift 更快，因为其序列化/反序列化的数据更小，所以能更快的进行传输和处理。 | 如果是大数据传输场景，Thrift 又会略胜一筹
内存 | √ 占用更小 | 占用比 Protobuf 要大
兼容 | √ 因为其简单，所以在跨语言兼容性、数据版本的向前向后兼容都要更好 | 有一定的限制
可读 | Protobuf 的消息定义语言则更加简单，可能会比 Apache Thrift 更难读懂，但也更为紧凑，适合在网络传输中使用 | √ 在数据结构定义方面，Apache Thrift 的 IDL 更加易读易懂，支持更多的注释和描述，更适合阅读和维护
序列化<br/>/<br/>反序列化 | √ 设计简单，数据更加紧凑 | 实现复杂，使用了可扩展类型和动态类型的概念
安全 | 安全性相对较弱，因为它主要关注数据序列化而不是安全，支持 SSL/TLS 加密来提高安全性 | √ 支持 SSL/TLS 加密，供了许多安全特性，例如传输层安全、身份验证和访问控制，使得 Apache Thrift非常适合在保密和敏感应用程序中使用
运行性能 | √ 因为其编码更加简单，Protobuf 通常比 Apache Thrift 更快 | 支持更多的数据结构、更加灵活，适应更多的场景
跨平台 | Linux、Windows、MacOS、Android 和 iOS | √ Protobuf 支持的都支持，此外还支持 Solaris、FreeBSD 和 HP-UX 
集成 | 差别不大，因为都需要在客户端和服务器端之间部署相同版本的消息定义 |  - 
扩展 | 低，Protobuf 只支持基本数据类型 | √ Apache Thrift 的扩展性更强，因为它支持多种类型的数据结构，包括枚举和异常


在同样语言支持之下，可以优先考虑选择 `gRPC + Protobuf`，如果需要支持更加复杂和更加灵活的应用场景则可以考虑 `Apache Thrift`.

- [Protobuf终极教程-Go语言版](https://colobu.com/2019/10/03/protobuf-ultimate-tutorial-in-go/)
- [Protocol Buffers：PHP Generated Code](https://developers.google.com/protocol-buffers/docs/reference/php-generated)
- [Github 仓库： protocolbuffers/protobuf](https://github.com/protocolbuffers/protobuf)
- [使用Protobuf实现跨语言序列化和反序列化，Java&Python实例](https://tonyjiangwj.github.io/2019/11/01/%E4%BD%BF%E7%94%A8Protobuf%E5%AE%9E%E7%8E%B0%E8%B7%A8%E8%AF%AD%E8%A8%80%E5%BA%8F%E5%88%97%E5%8C%96%E5%92%8C%E5%8F%8D%E5%BA%8F%E5%88%97%E5%8C%96%EF%BC%8CJava-Python%E5%AE%9E%E4%BE%8B/)

### √ `XML`、`JSON`、`YAML`、`Protobuf` 格式小结

`XML` 适用于复杂的数据结构，`JSON` 适用于轻量级的数据交换，`YAML` 适用于易读易写的配置文件，`Protobuf` 适用于对数据大小和解析速度有较高要求的场景.

#### 扩展：XML - 扩展标记语言（Extensible Markup Language）

`XML` 跟 `HTLM` 类似，语法都遵循[「文档类型声明符 `Document Type Definition`，简称：`DTD`」](https://www.w3cschool.cn/dtd/)的标准。`HTML` 是用来描述 `Web` 页面，而 `XML` 主要用来描述信息。

`HTML` 不适合用来作为文档和数据的管理语言，主要是因为：

- 把结构和显示（CSS）部分混在了一起
- 给浏览器太大的解释灵活性，导致其不规范也依然可以被正常解析展示出来
- 不适合打印机等其他的显示介质，过长出现滚动条而不能自动转为“下一页”
- 在数据处理中用处不大，`XML` 中可以使用自定义的标签且其将内容和变现形式区分了开来

综上：用 `XML` 来做数据呈现比 `HTLM` **条理更加清晰可见、数据表示上更加灵活**。

优点：

- 可扩展性好，适用于复杂数据结构
- **支持命名空间和 DTD 验证，可以保证数据的正确性和有效性**
- 支持跨平台和跨语言


缺点：

- 冗余标记较多，文件体积较大
- **解析速度相比其他格式较慢**

`PHP` 有很多内置 `XML` 处理类，如：[`DOM — Document Object Model`、`libxml`扩展函数、`SimpleXML`、`XMLParser`、`XMLReader/XMLWriter`](https://www.php.net/manual/zh/refs.xml.php)

#### 扩展：JSON - JavaScript 对象表示法（JavaScript Object Notation）

[`JSON`](https://www.json.org/json-zh.html) 是一种**轻量级**的数据交换格式。在 `Web 2.0` 时代浏览器 `Ajax` 技术盛行，通过 `JS` 代码与服务端进行异步请求并交换数据动态更新页面。

传统的 `XML` 格式有一些缺点：数据冗长、繁琐、数据体积大、解析速度慢等等，致使人们需要寻找一种更加轻量级、又易于读写解析的数据格式。于是 `JSON` 便作为一种新的数据格式出现了，`JSON` 与 `XML` 相比，其：简单易读、容易解析、数据更加紧凑，具有更高的解析速度。发展至今 `JSON` 已经被广泛应用于 `RESTful API`、`NoSQL` 等领域。

优点：

- 简洁、轻量级、易于阅读和编写
- 支持跨平台和跨语言
- 解析速度快

缺点：

- 不支持命名空间和 DTD 验证，无法保证数据的正确性和有效性
- 不支持注释（`XML` 中用 `<! --注释内容-->` 表示注释内容）

虽然在当下 `Web` 时代下 `XML` 可能在大部分场景中已经被 `JSON` 所替代，但由于 `XML` **支持命名空间和 DTD 验证，可以保证数据的正确性和有效性** 的优点使得它还在一些场景下保留一席之地，如：

1、Web 服务中用来定义 Web 服务的接口、协议、消息，如：SOAP（简单对象访问协议）、WSDL（Web 服务描述语言）等，因为它们需要支持命名空间、DTD 验证、XSD（XML Schema Definition）等

2、复杂的文档数据结构传输和存储，这些数据通常需要支持：结构化、可扩展、可验证等特性

3、在某些场景下，需要数据以一种通用的格式来进行存储和管理，如：数据仓库、信息管理系统

4、在一些工业标准中已经被广泛使用至今，如：SVG、XHTML等，需要支持：结构化、可扩展、可验证等特性

`JSON` 在解决 `XML` 痛点的时候是牺牲了一些：可读性（如：没有注释）来达到的。

#### 扩展：YAML - YAML Ain't Markup Language

优点：

- 易读写，**具有更高的可读性**
- 文件体积较小
- **支持注释**（通过 `# 需要注释的内容` 进行注释，不支持多行注释）

缺点：

- 不支持命名空间和 DTD 验证，无法保证数据的正确性和有效性
- 不支持多行字符串（虽然看到很多工具可以通过解析 `|` 来达到多行文本换行问题，但这并非官方所允许的）
- 不支持跨语言的数据转换

**为什么将 JSON 用于人类可编辑的配置文件是一个坏主意？**

1. JSON 是一种计算机语言，它与人类语言不同。因此，让普通人去编辑 JSON 文件可能会很困难，特别是对于那些不熟悉计算机语言的人来说。
2. JSON 文件不支持注释。注释是编写配置文件的常用方式，它可以帮助人们理解代码和设置。由于 JSON 文件不支持注释，因此配置文件可能会变得模糊不清，难以理解。
3. JSON 文件中的数据必须严格遵守格式要求。如果文件中的某个数据项不符合 JSON 格式的要求，那么整个文件都可能无法解析。这对于人类编辑的配置文件来说不太现实，因为人们很难保证每一个数据项都严格遵守 JSON 格式的要求。
 

**[YAML](https://yaml.org/) 是一种优秀的配置文件格式，但它并不是完美的**（参阅：[¶：YAML：可能并不是那么完美](https://linux.cn/article-10423-1.html)）

1. YAML 在处理复杂的数据结构时会变得非常冗长。例如，如果需要在配置文件中存储一个多层嵌套的数据结构，那么 YAML 文件就会变得非常长，且难以维护。
2. YAML 的语法规则比较复杂，有时难以理解。例如，YAML 中的缩进和空格敏感，如果不注意缩进和空格的使用，可能会导致文件无法解析。
3. YAML 对于类型信息的支持不够好。例如，YAML 可能无法区分数字和字符串类型，导致在处理数据时出现问题。


#### 扩展：Protobuf - Protocol Buffers

尽管有 `XML/JSON/Yaml` 这些优秀的数据交换格式，但在大数据时代之下它们在网络中传输和处理的速度仍然不够高。于是 Google 便开发研究了 **更加轻量级、高效、可扩展的数据序列化格式**。

优点：

- 序列化后的数据体积更小、解析速度快（Protobuf 使用二进制数据更加紧凑，占用存储空间更小，传输数据量更少）
- 支持向后和向前的兼容，可扩展性好
- 支持跨平台和跨语言

缺点：

- 不易读，可读性差
- 需要通过 `*.proto` 文件来预先定义数据结构，不支持动态修改协议，不够灵活

随着时间推移，`Protobuf` 逐渐被应用于越来越多的领域，如：分布式系统、消息传递、数据存储等。

### √ 自定义 PHP 扩展

#### √ 自定义扩展安装步骤

想要 「自定义开发扩展」需要提前安装好 `PHP` 环境，下载了 `PHP` 源码包。

> 假定 `PHP` 源码包解压后的路径为：`/apps/source/php`，`PHP` 的安装目录为 `/apps/php`，现在生成一个 `hello.so` 的扩展进行安装

1. 生成扩展开发的基本框架：`cd /apps/source/php/ext/ext_skel.php --ext hello`，这个操作会生成一个 `/apps/source/php/ext/hello` 的目录
2. 编译扩展：按照以下步骤操作在 `/apps/source/php/ext/hello/modules` 生成 `hello.so` 二进制扩展文件
    - `cd /apps/source/php/ext/hello`
    - `/apps/php/phpize`
    - `./configure --with-php-config=/apps/php/bin/php-config`
    - `make`

![为 php-8.1.13 编译自定义 hello.so 扩展](https://minsonlee.github.io/images/pig/make-php-ext-success-demo.png)

由于我本机装了两个版本的 PHP，上图是以 `PHP8.1.13` 提供的示例，因此上图截图看到信息是 `/apps/source/php-8.1.13/ext/hello/modules/hello.so`，如果你是按照上图进行操作，那么你的扩展二进制文件 `hello.so` 应该是在 `/apps/source/php/ext/hello/modules/hello.so` 下

3. 安装扩展
    - 查看 `PHP` 扩展安装目录路径： `php81 -i | grep extension_dir`，一般是在 `/apps/php/lib/php/extensions/xxx/*.so` 下
    - 复制 `hello.so` 到扩展安装目录：`cp /apps/source/php/ext/hello/modules/hello.so /apps/php/lib/php/extensions/no-debug-*/`
    - 启用扩展：在 `php.ini` 配置文件末尾加上 `extension = "hello.so"` 
    - 验证安装： `php -m | grep hello` 如果有信息显示表示已经安装

4. 如果是通过 `php-fpm` 运行的 `php` 进程，那么还需要重启 `php-fpm` 服务：`service php-fpm restart`

#### √ 详细信息自定义扩展

现在 `hello.so` 扩展已经安装成功了，那么...`hello.so` 扩展到底包含了哪些方法？

通过 `php --help` 查看 `help` 信息时发现了以下一段参数信息

```sh
php --help

...

  --rf <name>      Show information about function <name>.
  --rc <name>      Show information about class <name>.
  --re <name>      Show information about extension <name>.
  --rz <name>      Show information about Zend extension <name>.
  --ri <name>      Show configuration for extension <name>.
```

通过 `/apps/php81/bin/php --ri hello` 可以查看扩展是否安装并开启，通过 `php --re hello` 可以查看扩展的具体信息：

```sh
$ php --ri hello

hello

hello support => enabled

$ php --re hello

Extension [ <persistent> extension #57 hello version 0.1.0 ] {

  - Functions {
    Function [ <internal:hello> function test1 ] {

      - Parameters [0] {
      }
      - Return [ void ]
    }
    Function [ <internal:hello> function test2 ] {

      - Parameters [1] {
        Parameter #0 [ <optional> string $str = "" ]
      }
      - Return [ string ]
    }
  }
}
```

当然除了以上方法，还可以去看 `/apps/source/php/ext/hello/hello.c` 的源码（源码之下无秘密）...可以看到这样两段定义方法的代码：`test1` - 直接答应一句话；`test2` - 返回一个字符串

```c
/* {{{ void test1() */
PHP_FUNCTION(test1)
{
        ZEND_PARSE_PARAMETERS_NONE();

        php_printf("The extension %s is loaded and working!\r\n", "hello");
}
/* }}} */

/* {{{ string test2( [ string $var ] ) */
PHP_FUNCTION(test2)
{
        char *var = "World";
        size_t var_len = sizeof("World") - 1;
        zend_string *retval;

        ZEND_PARSE_PARAMETERS_START(0, 1)
                Z_PARAM_OPTIONAL
                Z_PARAM_STRING(var, var_len)
        ZEND_PARSE_PARAMETERS_END();

        retval = strpprintf(0, "Hello %s", var);

        RETURN_STR(retval);
}
/* }}}*/
```

`hello.c` 中的声明函数例子如下，你可以自行根据程序编写一个简单的示例，然后重新按照上述方式进行编译安装：

```txt
/* {{{ 注释中写函数原型，包括函数名、参数、返回值
*/
PHP_FUNCTION(函数名)
{
    // 1. 定义变量类型
    // 2. 定义参数类型
    // 3. 实际处理逻辑
    // 4. 返回值(如果有)
}
/*}}}*/
```

编写测试 demo 如下，然后 `php demo.php` 运行可以看到执行结果：

```php
<?php
test1();

echo PHP_EOL;

echo test2();
```

> 如果你本地安装了多个版本的 PHP，那么注意 `php demo.php` 运行 demo 时一定要用安装了 `hello.so` 扩展的 `php` 二进制程序进行执行。

#### √ 为什么要了解「自定义开发 PHP 扩展」

记得刚出学校进行实习的时候，面试了一个做教育行业的 PHP 公司，当时的技术面试人问过我：「你有用 C 写过 PHP 的底层扩展吗？」

我当时心里很翻滚，还在想：我要是写 C ，还跑来面啥 PHP？而且我不是只是找一个实习而已吗，怎么问我这种东西？？还追着问了一堆不懂的 PHP 底层源码实现...

现在想来，应该是对刚出学校的我进行的压力面试，以及考核一下我对 PHP 的了解深度和广度吧。

出来工作后也一直以为这个东西是一个非常底层的东西，平常的 PHP 程序员应该是不需要处理的，事实...我工作到目前为止也真的没遇到过需要自己实现扩展的。

当然如果代码大量使用了自定义的扩展，一旦项目迁移或新开机器的时候都需要确保到自定义的扩展必须是已经被安装了的，并且对自定义的扩展的维护也是一个额外工作量，这些其实都是一些潜在的风险。

比较长一段时间我其实都没弄明白：「为什么要自定义开发 PHP 扩展」呢？后来看了鸟哥的一篇文章：[用C/C++扩展你的PHP](https://www.laruence.com/2009/04/28/719.html) 其中提到两个原因：

> **第一个理由是：PHP需要支持一项她还未支持的技术**。
>
> 这通常包括包裹一些现成的C函数库，以便提供PHP接口。例如，如果一个叫FooBase的数据库已推出市场，你需要建立一个PHP扩展帮助你从PHP里调用FooBase的C函数库。这个工作可能仅由一个人完成，然后被整个PHP社区共享（如果你愿意的话）。
> 
> **第二个不是很普遍的理由是：你需要从性能或功能的原因考虑来编写一些商业逻辑**。

毕竟 「PHP 扩展」是需要编译集成到 PHP 源码中的，自定义的扩展代码不开源，对于商业逻辑来说安全性较高，且底层是 C 语言实现，速度比较快。

![PHP扩展开发导图](https://minsonlee.github.io/images/pig/php_extension.png)

- [Rust开发PHP扩展Liunx版](https://blog.csdn.net/weixin_47723549/article/details/126578667)
- [使用纯Rust开发PHP扩展](https://www.jmjoy.top/posts/%E4%BD%BF%E7%94%A8%E7%BA%AFrust%E5%BC%80%E5%8F%91php%E6%89%A9%E5%B1%95/)
- [用C/C++扩展你的PHP](https://www.laruence.com/2009/04/28/719.html)
- [PHP扩展开发](https://www.maoyingdong.com/categories/PHP/PHP%E6%89%A9%E5%B1%95%E5%BC%80%E5%8F%91/)
- [『自闭 PHP 内核』 vol1. 来写一个 PHP 扩展吧](https://github.red/php-core-1-php-extension/)


##  PHP 代码调试的手段

### 如何去排查-->调试/解决 Bug 

软件中的 `bug`（飞虫）、`Debugging`（调试） 这两个单词被普遍的认为是美国海军准将及电脑科学家 - `Grace Hopper`（格蕾丝·赫柏 - 世界最早一批程序员，也是最早的女性程序员之一）在哈佛大学为美国海军开发一套计算机工作时候，由于一只飞蛾卡在继电器中，导致计算机崩溃，从而提出来的。

不管是在初学编程还是在深入编程的过程中，漏洞和错误在软件开发中经常发生的。
对于初学计算机，`Bug` 经常是我们学习路上的拦路虎，会打击我们的自信心，逐渐消磨我们的耐心；对于深入编程来说更加不用说，`Bug` 更是我们需要经常面对又需要经常避免的一个东西。

因此，我个人认为学习一门编程的第一步最重要的其实就是：「学会如何排查和解决 Bug？」

一般来说，Bug 分为两类：**编码错误、逻辑错误**

- 编码错误：相对好发现和解决，基本运行就会报错并清晰的知道什么位置出了什么样的问题
- 逻辑错误：相对难发现并解决，需细心捋清逻辑并逐步调试才能发现，并需针对场景加以解决

**如何去排查-->调试/解决 Bug 呢？**

**1. 克服心里障碍，静下心来阅读一下报错的信息！**

我记得最开始学校学习 Java 的时候，一遇到 Bug 就头大，感觉什么乱七八糟的信息都给打出来了，老师基本也不会提打印出来这些是什么？如何去看？如何去发现问题？最开始学的时候...一度被吓得连报错日志都没多细看就直接拿着第一句报错信息在互联网上直接搜索信息，查询了半天有时没答案...积极性就大受打击了。

但是现在工作中偶尔需要维护一些 Java 项目，遇到其报错的时候不得不耐心地去看，才发现其实 Java 的错误信息还是挺清晰明了的，打出来的那一堆东西是整个进程的调用堆栈信息。

但对于初学编程者来说，`PHP` 的报错就简洁清晰很多了，至少不至于被劝退。

**2. 学会从错误信息中找关键字。如：`fatal`、`error`、自己写的一些类/文件/函数的名字、注意看数字（即：行数），核心思想就是：缩小问题范围，猜错误的原因**

一般内置或比较多人用的类库都不那么容易出 `Bug`，更多是因为自己写的程序实现有问题。

因此学会从报错信息中去找常见的表示错误的单词（如：`fatal`、`error`、`warning`、`exception`），是相对准确的能迅速定位具体的错误信息的一种方法。

也可以找一下：**自己写的一些类/文件/函数的名字**、**注意一些数字（特别是某某文件的行数，想一下自己写的代码中那里调用到了）**，这个也是相对准确的能迅速定位具体的错误信息的一种方法。

**3. 学会借助错误日志**

看日志这个是一个需要慢慢积累的能力。譬如：`PHP` 属于解释型语言，其架构现在一般是 `LNMP`，那么这个过程就涉及：`Linux`、`Nginx`、`MySQL`、`PHP` 这几方的日志信息了。

如：
- `php.ini` 中的 `error_log` 记录 `PHP` 进程的运行时错误日志（[How to collect, customize, and analyze PHP logs](https://www.datadoghq.com/blog/php-logging-guide/)）
- `php-fpm.conf` 中配置的 `error_log`、[`php-fpm.d/*.conf` 下的 `slowlog`](https://www.getpagespeed.com/server-setup/how-to-log-and-fix-slow-php-requests) 记录 `PHP-FPM` 进程的相关错误/慢日志信息，具体配置项可查看[官网手册](https://www.php.net/manual/zh/install.fpm.configuration.php)
- `Nginx` 中的 [访问日志-`access_log`](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log)、[错误日志-`error_log`](https://nginx.org/en/docs/ngx_core_module.html#error_log)【[【Nginx】如何配置Nginx日志](https://www.cnblogs.com/binghe001/p/13303325.html)】
- MySQL 的话一般查看慢日志比较多，目前这个一般是 DBA 导出来给开发看的，操作不是很熟，具体可以看：[[玩转MySQL之八]MySQL日志分类及简介](https://zhuanlan.zhihu.com/p/58011817) 了解一下
- Linux 日志一般都是在 `/var/logs/` 目录下，[How to View & Read Linux Log Files](https://phoenixnap.com/kb/how-to-view-read-linux-log-files)

至于详细的使用和查看自行上网查阅就可以了。


**4. 小黄鸭调试法**

逻辑错误一般是比较难发现的，因为逻辑错误往往不是什么固定套路的错误，需要细心的排查代码的数据变化、借助工具、借助业务日志等诸多手段来排查并针对不同的场景来解决。

“编程”其实是一个比较抽象的工作，对于一些简单的逻辑错误，其实：**逐行阅读代码，一边阅读一边跟自己解释这行代码的目的、功能、实现是否正确？** 这是一个不错的方法，这个方法称为「小黄鸭调试法」。特别对于写一些比较绕的逻辑又出了 Bug 的时候，这个是最简单也最需要耐心的一种方法。

这能让你暂时跳出第一视角，从第三者的角度来看待分析你自己写的东西。因为往往很多时候，真的就是「不识庐山真面目，只缘身在此山中」！

![小黄鸭调试法](https://minsonlee.github.io/images/pig/20230410011359.png)

**5. 结合断点调试工具，进行排查调优**

如：[XDebug - 调试工具](https://xdebug.org/docs/)、[Tideways - 性能分析工具](https://jie-chuang.medium.com/php7-%E7%9A%84%E6%95%88%E8%83%BD%E5%88%86%E6%9E%90%E5%B7%A5%E5%85%B7-tideways-e371467ae1a0)

这些工具能更好的作为一只“小黄鸭”，帮你呈现出整个运行过程，从而帮助你发现问题。

![断点调试](https://minsonlee.github.io/images/pig/20230413005809.png)

- `Continue` 按钮继续运行程序，只在用户定义的断点上停止
- `Step Over` 将直接执行函数调用并返回结果，并不进入函数内部的行进行调试
- `Step Into` 会逐行进入函数，直到它返回，然后你会回到函数调用后的下一行
- `Step Out` 如果你已经踏入了一个函数，你可以跳过该函数的剩余执行部分，直接进入返回值。
- `Restart` 从头开始重新运行调试器
- `Stop` 退出调试器

**6. 借助打点业务日志，辅助排查「偶发」问题**

对于一些偶发、无法立刻必现的问题，则需要借助开发对数据进行业务日志埋点，来进一步的辅助排查问题。

以上 6 种方法，算是在 PHP 编程中常使用的一些技巧方法，也经常会被用到故障分析排查中。**总之：耐心和日志对于排查问题，很重要！**

在职涯中，曾有人跟我说这么一段关于排查问题的话：

> 排查问题要由上至下，冷静面对。首先要分清到底是「人为」还是「非人为」，如：看网卡流量情况或者访问日志，确定是不是人为导致，例如网络攻击或被人突然剧增了调用？如果确定不是人为，那就要搞清楚整个调用链条，先定位服务，然后细查 bug 原因，这样才能比较正确快速的应对解决。

但...害，说了，不等于我就掌握了。

而调试/解决 Bug 的方法其实就几个：

- **1. 有空常翻阅一下 PHP 官方的手册**。PHP 中很多看似简单的函数都隐藏了很多细节，往往容易被人忽视，而忽视的结果就是出 Bug
- **2. 善用搜索引擎：谷歌 》 必应 》 GitHub 》 技术社区/博客园 》 技术社群 》 某度/CSDN**。遇到的大部分问题，前人都遇到过，因此学会先用搜索引擎解决问题是程序员必备的技能，而学习常用的 SEO 技能能更好的帮助你：[SEO-你需要知道的搜索小技巧](https://minsonlee.github.io/2020/05/search-skills)。
- **3. 休息一下，想想别的事情**：换一下心情再回来看问题，可能会豁然开朗
- **4. 请教厉害的人**，问别人问题之前，理清楚自己的表达不要挤牙膏一样...问题是什么？自行严重过了哪些方法？现在想请教的是思路还是具体的解决方案？

如何避免写出有 Bug 的代码呢？

- `DRY-Don't Repeat Yourself` ： 尽量避免写重复的代码，要学会抽象封装
- `KISS-Keep It Simple and Stupid` ： 尽量写易于阅读和理解、将复杂任务代码拆分为简洁的代码
- `SOLID` 原则
    - `S` - 一个类应该有一个，而且只有一个工作
    - `O` - 开闭原则，应该能够扩展一个类的行为，而不用修改它
    - `L` - 里式替换原则，派生类必须可以替代其基类
    - `I` - 接口隔离原则，不应该强迫客户实现它不使用的接口，也不应该强迫客户依赖他们不使用的方法
    - `D` - 依赖反转原则，高层模块不能依赖低层模块，但它们应该依赖抽象物



- [x] [什么是调试——如何调试代码？](https://www.freecodecamp.org/chinese/news/what-is-debugging-how-to-debug-code/)
- [ ] [How to collect, customize, and analyze PHP logs](https://www.datadoghq.com/blog/php-logging-guide/)
- [ ] [How to log and fix slow PHP requests](https://www.getpagespeed.com/server-setup/how-to-log-and-fix-slow-php-requests)
- [ ] [How to View & Read Linux Log Files](https://phoenixnap.com/kb/how-to-view-read-linux-log-files)
- [x] [使用 PHPStrom 进行调试：配置 Xdebug](https://phpstorm.org/configuring-xdebug.html)
- [x] [可能是全网最详细的PhpStorm+xdebug远程调试php代码的教程](https://www.xiebruce.top/1191.html)
- [ ] [利用Xdebug分析PHP程序，找出性能瓶颈](http://zyan.cc/post/257/)
- [ ] [使用xdebug对php做性能分析调优](https://blog.51cto.com/u_15715098/5710951)
- [ ] [xdebug性能分析](https://segmentfault.com/a/1190000016408200)
- [ ] [PHP 性能分析平台搭建 (tideways + xhgui+ nginx + PHP7)](https://learnku.com/articles/30375)
[Tideways - 性能分析工具](https://jie-chuang.medium.com/php7-%E7%9A%84%E6%95%88%E8%83%BD%E5%88%86%E6%9E%90%E5%B7%A5%E5%85%B7-tideways-e371467ae1a0)
- [ ] [PHP 性能分析：Xhprof](https://www.wkwkk.com/articles/77160c24ad336f58.html)
- [ ] [性能分析与调优的原理](https://www.cnblogs.com/qmfsun/p/4829981.html)
- [ ] [Python 性能分析与优化](https://www.ituring.com.cn/book/tupubarticle/10101)
- [ ] [PHP调试技术手册发布.pdf-php-debug-manual-public.pdf](https://www.aliyundrive.com/s/ez92riyBneG)
- [ ] [PHPUnit袖珍手册](https://github.com/pengjeck/books)
- [ ] [502 bad gateway 可能的错误原因](https://www.cnblogs.com/siqi/p/3658771.html)


### √ PHP Xdebug 调试工具

有哪些调试方法？如何更便捷调试？对于学好一门编程语言是非常重要的一步。正所谓：“工欲善其事，必先利其器”。

将 `php -i` 信息复制到 [`https://xdebug.org/wizard`](https://xdebug.org/wizard) 中，然后点击 `Analyse my phpinfo() output`，按照分析结果傻瓜式操作即可！

如何在 `PHPStrome` 中配置 Xdebug，可点击这里：[可能是全网最详细的PhpStorm+xdebug远程调试php代码的教程](https://www.xiebruce.top/1191.html) 查看，配置好 `Xdebug` 可查看 [xdebug的实际运用](https://segmentfault.com/a/1190000016239854) 简单了解使用信息。

更加详细的配置、使用可以看 [官方使用文档](https://xdebug.org/docs/) 查看详细使用操作。

推荐浏览器需要安装一个 [Xdebug helper](https://chrome.google.com/extensions/detail/eadndfjplgieldjbigjakmdgkmoaaaoc) 扩展，实际上这一步并非必须！不管什么方式最终都是通过设置一个 `$_COOKIE["XDEBUG_SESSION"]` cookie 在请求时带到给 PHP 从而开启 Xdebug 功能而已，如果不安装该插件，那么你就需要每次自行通过 GET/POST/COOKIE 方式携带信息给 Xdebug，让 Xdebug 给你种一个 Cookie 信息。

**第一种：静态绑定客户端 host**

![xdebug 调试原理](https://minsonlee.github.io/images/pig/WZ8PZTpI79.gif)

- PHP 服务器 IP 是 10.0.1.2，监听端口为 80
- IDE 客户端 IP 是 10.0.1.42，监听端口为 9000
- IDE 客户端对 PHP 服务器发起 HTTP 请求，被 Xdebug 拦截
- Xdebug 与 IDE 通过 DBGP 协议建立关联，并进行断点交互
- 运行调试, xdebug 所在的服务器提供 HTTP 响应

**第二种：动态获取客户端 IP**

![xdebug 调试原理](https://minsonlee.github.io/images/pig/9AXPuV1r97.gif)

- PHP 服务器 IP 是 10.0.1.2，监听端口为 80
- IDE 客户端对 PHP 服务器发起 HTTP 请求，被 Xdebug 拦截，PHP 服务器通过 Request Header 中的 `HTTP_X_FORWARDED_FOR,REMOTE_ADDR` 获取客户端 IP
- Xdebug 与 IDE 通过 DBGP 协议建立关联，并进行断点交互
- 运行调试, xdebug 所在的服务器提供 HTTP 响应

实际 Xdebug 不仅可以用来 Web 调试代码，根据官方文档的介绍还可以 CLI 方式调试代码、排查错误、函数追踪、[性能分析](https://segmentfault.com/a/1190000016408200)【稍作了解即可，一般我们会使用 Tideways/Xhprof 进行分析】。

需要注意的是，PHP7.4 之后的 Xdebug-3 配置名称和参数值和 Xdebug-2 有比较大变化，详细可以看：[Upgrading from Xdebug 2 to 3](https://xdebug.org/docs/upgrade_guide)

### PHP 性能调优工具：Tideways

- 性能有哪些指标？
- 如何判断性能差？
- 火焰图如何看？

### PHP 性能优化：OPcache

- [使用 opcache 优化生产环境 PHP](https://blog.51cto.com/lxw1844912514/2941570)
- [通过 PHP OPcache 让你的 Laravel 应用运行速度飞起来](https://laravelacademy.org/post/7326)
- [PHP Opcache 配置优化实战](https://segmentfault.com/a/1190000023648948)
- [PHP优化加速之Opcache使用总结](https://blog.csdn.net/why_2012_gogo/article/details/51134674)
- [Opcache缓存刷新](https://www.magentomaster.cn/articles/ways-to-flush-opcache)
- [关于 PHP Opcache 缓存刷新、代码重载](https://segmentfault.com/a/1190000023731765)
- [OPcache 函数：opcache_reset](https://www.php.net/manual/zh/function.opcache-reset)
- [PHP7 opcache缓存清理问题](https://www.11meigui.com/2020/php7-opcache.html)
- [PHP7 opcache缓存清理问题](https://blog.51cto.com/liuqunying/1950277)
- [CacheTool - Manage cache in the CLI](https://github.com/gordalina/cachetool)

`opcache_reset` 并不能很好的清理 `OPcache`，即使通过 `http` 访问，偶尔会出现清理不干净的情况（目前的解决办法是多清理几次）

```pliant
It should be mentioned that opcache_reset() does not reset cache when executed via cli.
So `php -r "var_dump(opcache_reset());"` outputs "true" but doesn't clean cache. Make file, access it via http - and cache is clean.
```


## `composer` - PHP 包依赖管理器

`Composer` 不是一个包管理器，而是 `PHP` 的一个依赖管理工具。它允许你通过 `composer.json` 文件申明当前项目所依赖的代码库，然后它会在你的项目中为你安装他们。详细可以阅读：[`Composer` 中文文档](https://docs.phpcomposer.com/) 或 [`Composer-A Dependency Manager for PHP` 英文官方文档](https://getcomposer.org/) 进行了解。

[`Packagist`](https://packagist.org/) 是 `Composer` 的主要仓库，它汇集了可在 `Composer` 中安装的公共 `PHP` 包，但是它的服务在国外，一般我们会设置国内镜像源来达到访问加速的目的。

`Packagist` 和 `Composer` 的关系有点类似于 `GitHub` 与 `Git` 的关系，如果我们在 `composer.json` 中没有指定依赖的具体地址，那么 `Composer` 就会到默认的 `Repository - Packagist` 去寻找依赖并为我们下载安装。

### √ [安装 `Composer`](https://getcomposer.org/download/)

```php
php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo ln -s /apps/php-composer/composer.phar /usr/local/bin/composer
```

`composer 2` 增加了缓存功能、优化 curl 支持、优化任务执行支持并行执行、只对有变更的扩展包进行更新...这些优化使得 `Composer2.x` 比 `composer 1.x` 更加节省内存、更加高效。【强烈建议换成 `composer 2`，能节省很多生命成本，详细见：[Composer 2.0 is now available!](https://blog.packagist.com/composer-2-0-is-now-available/)】

### √ 更新 `Composer` 到最新版本

```sh
COMPOSER_DISABLE_NETWORK=1 # 允许在 composer 离线模式运行
sudo composer self-update --stable --profile # 升级到最新的稳定版本
```

### √ [设置镜像源](https://pkg.xyz/)

```sh
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ # 设置阿里云镜像（不推荐使用 packagist.phpcomposer.com ，经常报找不到稳定版本）
# http://admin:admin@10.4.133.206:8081/repository/erc-composer

composer config -g --unset repos.packagist # 删除自定义的镜像源，走默认 Packagist
```

`composer` 执行时报错 `curl: (35) OpenSSL SSL_connect: SSL_ERROR_SYSCALL in connection to repo.packagist.org:443`.

可以通过下列命令关闭 `SSL` 验证

```sh
composer config --global disable-tls true
composer config --global secure-http false
```


如果需要频繁切换镜像源的，可以考虑通过 [CRM - Composer源管理工具](https://github.com/slince/composer-registry-manager/blob/master/README-zh_CN.md) 来管理：`composer global require slince/composer-registry-manager`。

### √ Composer 常用命令

如果时间足够，快速的浏览一遍 [`Composer` 文档](https://learnku.com/docs/composer/2018) 就最好了，文档很全也包含一些常见的 FAQ，如： [`composer.lock` 文件应该被提交到版本控制中吗？](https://docs.phpcomposer.com/01-basic-usage.html#composer.lock-The-Lock-File) 等比较好的实践推荐。

#### √ 扩展包

- 包名称 - `<package>` ：
    - 由两部分：供应商名称和其项目名称构成。 
    - 通常容易产生相同的项目名称，而供应商名称的存在则很好的解决了命名冲突的问题。
    - 对于一个具有唯一名称的项目，官方推荐供应商名称与项目的名称相同


- 包版本

名称 | 实例 | 描述
---|---|---
确切版本号 | 1.0.2 | 明确指定只要 1.0.2 版本的扩展包
通配符 | 1.0.* | 任何从 1.0 开始的开发分支，如：1.0.2、1.0.3 或 1.0.20
范围 | `>=1.0` `>=1.0,<2.0` `>=1.0,<1.1|>=1.2` | 通过`>`、`<`、`>=`、`<=`、`!=`指定范围，通过 逻辑与运算符`,`、逻辑或运算符-`|` 进行组合指定
赋值运算符 | `~1.2` `~1.2.3`| 相当于 `>=1.2,<2.0` `>=1.2.3,<1.3`，对于遵循 [语义化版本号 ](https://semver.org/) 的项目，这类指定是最好的。但...现在很多扩展包都不遵守这一准则


#### √ 常用命令

- 环境变量：`COMPOSER_MEMORY_LIMIT=-1` 设置 `composer` 不受内存限制
- 环境变量：`COMPOSER_DISABLE_NETWORK=1` 设置 `composer` 可离线模式使用
- `composer config --global --list` 查看 `composer` 的配置 
- 搜索扩展包：`composer search <package>`，详细信息可以上 [`Packagist`](https://packagist.org/) 查看版本
- [`composer.json` 文件初始化](https://docs.phpcomposer.com/04-schema.html#minimum-stability)

```json
{
    "name": "your-vendor-name/package-name",
    "description": "A short description of what your package does",
    "require": {
        "php": ">=8.2",
        "another-vendor/package": "1.*"
    }
}
```
- 检查 `composer.json` 文件是否正确： `composer validate`
- 查看已安装扩展包详情： 进入 `composer.json` 所在目录，执行 `composer show <package>`
- 基于 `composer.json` 安装扩展包： `composer install`
- 安装扩展包： `composer require <package> [:version[@tag-for-stable]]`
- 更新扩展包：`composer update <package>` [正确的 Composer 扩展包安装方法](https://learnku.com/php/t/1901/correct-method-for-installing-composer-expansion-pack)
- 添加了新文件之后，需要更新 `autoload` 文件：`composer dump-autoload`（测试）、`composer dump-autoload --optimize(or -o) --no-dev --classmap-authoritative`（生产）

一般来说：`composer install`、`composer require <package>`、`composer update <package>`、`composer dump-autoload` 使用的最多。

#### √ 使用场景一：创建一个新项目（本地搭建）

两种方式：

1. 通过 `composer create-project laravel/laravel example-app` 这种方式来安装
2. 可以自己 `git clone <framework>` 创建初始化项目，修改 `composer.json` 文件，执行 `composer install` 进行项目的初始化安装

两种方式都可以，看个人喜爱。两种方式执行完之后，都会生成 `composer.lock` 文件，此时将 `composer.lock`、`composer.json`、除了 `vendor` 目录外的其他项目提交到版本仓库中即可。

#### √ 使用场景二：安装现有项目（测试、生产环境部署）

执行 `composer install` 命令，`Composer` 会先看当前目录中是否有 `composer.lock` 文件，如果存在则根据 `composer.lock` 文件进行安装指定的包和指定的版本；如果不存在 `composer.lock` 文件则会根据 `composer.json` 中指定的包及其版本规则去 `Packagist` 中拉取符合版本规则的最新版本的包下来，并根据拉取的版本生成 `composer.lock` 文件。


#### √ 使用场景三：新增扩展包（开发环境）

使用 `composer require <package>[:version[@tag]]` 命令添加新的依赖包。该命令大致操作顺序如下：

1. 首先会检查是否已经安装了指定的依赖包即对应版本，如果已经安装则会更新指定的版本
2. 如果没有安装则会自动将新的依赖包进行下载并安装
3. 更新 `composer.json` 和 `composer.lock` 文件

最后提交 `composer.json` 和 `composer.lock` 文件到版本控制中即可。

#### √ 使用场景四：更新扩展包（开发环境）

使用 `composer update <package>[:version[@tag]]` 更新指定的扩展包，该命令其实上述 `require` 的更新操作是一致的。

事实上，直接使用 `composer require <package>[:version[@tag]]` 来执行更新操作，好像也挺不错...

==**不要直接使用 `composer update`，这个命令会更新所有的依赖包的版本，如果依赖包作者没有严格遵循 语义化版本规范，那么这个操作可能使得你的项目挂掉。**==

**`composer install` 和 `composer update` 的区别？**

- 执行 `composer update` 的时候，`composer` 会去读取 `composer.json` 中指定的依赖，去分析他们，然后拉取符合条件有变动的最新版本的依赖，并将所拉取到的依赖放入 `vendor` 目录下，把所有拉取的依赖的精确版本号写入 `composer.lock` 文件中。
- 执行 `composer install` 的时候，`composer` 会先读取 `composer.lock` 文件，并根据 `composer.lock` 中的文件拉取符合条件有变动的最新版本的依赖，并将所拉取到的依赖放入 `vendor` 目录下。如果执行 `composer install` 时没有发现有 `composer.lock` 文件，那么该操作和 `composer update` 的操作结果是没什么区别的。

### √ Composer 原理

#### √ [再一次, 不要使用(include/require)_once](https://www.laruence.com/2012/09/12/2765.html)

**做好代码规划尽量使用`include`、`require` 而不是 `include_once`、`require_once`。**

1、`include_once/require_once` 需要查询一遍已加载的文件列表, 确认是否存在, 然后再加载.

> 1. 尝试解析文件的绝对路径, 如果能解析成功, 则检查EG(included_files), 存在则返回, 不存在继续
> 2. 打开文件, 得到文件的打开路径(opened path)
> 3. 拿opened path去EG(included_files)查找, 是否存在, 如果存在则返回, 不存在则会报错 `Fatal error:can't find xxxx`
> 4. 编译文件(compile_file)

2、当启用了 PHP 的 APC 本地缓存扩展时，使用 `include_once` 可能会带来 bug

APC 是劫持了 `compile_file` 这个编译文件的指针，从而直接从 cache（本地内存） 中得到编译结果，进而避免对实际文件再一次执行 open 系统调用操作。

`apc.include_once_override` 的实现有问题连续调用时可能会报错 `Fatal error - include() : Cannot redeclare class xxx`，这个问题已经被 [鸟哥 2012年 buglist#63070](https://bugs.php.net/bug.php?id=63070) 中修复。

同时，当启用缓存时，代码文件位置移动但没有刷新缓存，也可能会造成报错，可以看：[php的include和include_once引发的一次故障.md](https://github.com/xurenlu/phplearn/blob/master/php%E7%9A%84include%E5%92%8Cinclude_once%E5%BC%95%E5%8F%91%E7%9A%84%E4%B8%80%E6%AC%A1%E6%95%85%E9%9A%9C.md)

正如鸟哥在文章中写道：**“排除这些技术因素, 我也一直认为, 我们应该使用`include`, 而不是`include_once`, 因为我们完全能做到自己规划, 一个文件只被加载一次. 还可以借助自动加载, 来做到这一点.你使用`include_once`, 只能证明, 你对自己的代码没信心.”**

在 `include` 和 `require` 中尽量使用绝对路径，如果包含相对路径，PHP 会在 `include_path` 里面遍历查找文件。

#### √ Composer 自动加载原理
目前使用 PHP 基本应该都是用 `Composer` 进行扩展包/扩展类来进行对应的管理和加载了。

PHP 是弱类型解释脚本语言（即：任何的执行逻辑都需要在最终的编译脚本中能找到），通过 `require/require_once/include/include_once` 来将包含其他脚本文件包含进同一个脚本内。

[命名空间](https://www.php.net/manual/zh/language.namespaces.rationale.php) 只是为了给同名的 类/变量/函数 等提供一个路径分类标识，便于在程序调用冲突时可以根据这个路径找到唯一的类/变量/函数。
本质上，命名空间跟脚本加载没有任何关系，而在实际开发过程中，我们通过定义 **命名空间-目录路径 的加载关系**，用 [`__autoload()`](https://www.php.net/manual/zh/function.autoload.php)/[`spl_autoload_register()`](https://www.php.net/manual/zh/function.spl-autoload-register.php) 结合 `require/include` 来实现加载逻辑。

而且通过 `__autoload/spl_autoload_register` 实现自动加载相较于直接使用 `require/include` 的好处就是：**`Lazy Loading`**!!!即：实际调用时才会通过 autoload 加载文件。

`Composer` 的底层加载原理也不例外，只是其通过 `composer.json` 来呈现管理这些加载关系。

通过在入口文件加入下述代码即可

```php
// 引入自动加载程序
require_once __DIR__ . '/vendor/autoload.php';
// 其实 require __DIR__ . '/vendor/autoload.php'; 是不是也可以了
```

追踪一下代码就会发现，就是 `vendor/composer/ClassLoader.php::loadClass()` 方法，即下面这段逻辑，详细的逻辑是： `findFile()` 从 classMap/指定路径 中找到文件，然后 `include` 进来

```php
/**
 * Loads the given class or interface.
 *
 * @param  string    $class The name of the class
 * @return true|null True if loaded, null otherwise
 */
public function loadClass($class)
{
    if ($file = $this->findFile($class)) {
        includeFile($file);

        return true;
    }

    return null;
}
```

**可以通过 `spl_autoload_functions` 查看当前注册了多少个 `autoloader`.**

#### Composer.json 文件架构简介

[`composer.json` 的文件架构](https://docs.phpcomposer.com/04-schema.html) 如下，可以通过 `php composer.phar validate` 校验 `composer.json` 文件是否有效。 

```composer.json
{
    "name": "供应商名称/项目名称,ps:symfony/console",
    "description": "项目描述",
    "prefer-stable": "true/false，当此选项被激活时，Composer 将优先使用更稳定的包版本。稳定顺序：dev < alpha < beta < RC < stable",
    "minimum-stability": "stable|RC|beta|alpha|dev 对每个包的所有版本都会进行稳定性检查，而低于 minimum-stability 所设定的最低稳定性的版本，将在解决依赖关系时被忽略。对于个别包的特殊稳定性要求，可以在 require 或 require-dev 中设定",
    "license": "包的授权许可协议，格式可以是字符串或数组。如果是闭源协议必须使用 proprietary . 可选，但建议加上！",
    "require": {
        "供应商名称/项目名称": "require 表示执行 install/update 命令时必须要引入的包，接：包版本表达式；dev-branch[#commitId]"
    },
    "require-dev": {
        "供应商名称/项目名称": "require-dev 表示引入因开发或测试等目的需要的包。可以通过 install/update --no-dev 跳过安装"
    },
    "autoload": {
        "files": [
            "每次请求时都要载入某些文件",
            "通常作为函数库的载入方式（而非类库）"
        ],
        "classmap" : [
            "生成支持自定义加载的不遵循 PSR-0/4 规范的类库",
            "可以是路径",
            "可以是具体的类文件",
            "在 install/update 过程中生成映射关系，并存储到 vendor/composer/autoload_classmap.php 文件中"
        ],
        "psr-4": {
            "命名空间": "相对 Root 包所在路径"
        },
        "psr-0": {
            "命名空间": "相对 Root 包所在路径。目前 PSR-0 自动加载规范已经弃用，使用 PSR-4 规范就好: https://learnku.com/docs/psr"
        }
    },
    "autoload-dev": {
        "files": ["相对 Root 包所在路径, autoload-dev 是为了开发或测试等目的而需要自动引入的扩展"],
        "classmap": ["dump-autoload 命令时可通过--no-dev 来忽略 autoload-dev 指定的命名空间"],
        "psr-4": {
            "命名空间": "通常将单元测试放在一个特定的路径，并将其添加到 autoload-dev 部分，是一个好主意。"
        }
    },
    "repositories": [
        {
            "type": "type 可选：composer/vcs/pear/package",
            "url": "composer 默认只使用 packagist 作为包的资源库，可以通过 repositories 自定义资源地址。顺序是非常重要的，当 Composer 查找资源包时，它会按照顺序进行。默认情况下 Packagist 是最后加入的，因此自定义设置将可以覆盖 Packagist 上的包。",
            "options": {
                "ssl": {
                    "verify_peer": "true"
                }
            }
        },
        {
            "type": "vcs",
            "url": "git@github.com:company/project.git"
        },
        {
            "type": "pear",
            "url": "http://pear2.php.net"
        },
        {
            "type": "package",
            "package": {
                "name": "smarty/smarty",
                "version": "3.1.7",
                "dist": {
                    "url": "http://www.smarty.net/files/Smarty-3.1.7.zip",
                    "type": "zip"
                },
                "source": {
                    "url": "http://smarty-php.googlecode.com/svn/",
                    "type": "svn",
                    "reference": "tags/Smarty_3_1_7/distribution/"
                }
            }
        }
    ],
    
    "config": {
        "process-timeout": "默认 300，处理进程结束时间",
        "preferred-install": "默认为 auto, 它的值可以是 source-用于开发的源码仓库、dist-打包后的分发稳定版本 或 auto。",
        "use-include-path": "默认为 false。如果为 true，Composer autoloader 还将在 PHP include path 中继续查找类文件。建议关闭并弃用",
        
    },
    "scripts": {
        "事件名称": "允许你在安装过程中的各个阶段挂接脚本，可以是一个 PHP 回调（定义为静态方法）或任何命令行可执行的命令。详细见：https://docs.phpcomposer.com/articles/scripts.html",
    },
    
    "keywords": ["可选属性","关键词组", "便于搜索"],
    "homepage": "项目网站的 URL 地址，可选",
    "time": "版本发布时间：必须符合 YYYY-MM-DD 或 YYYY-MM-DD HH:MM:SS 格式.可选",
    "authors": [
        {
            "name": "authors 属性项目包作者，是一个数组对象。作者的姓名",
            "email": "作者的邮箱",
            "homepage": "作者的个人主页",
            "role": "该作者在此项目中担任的角色（例：开发人员 或 翻译）"
        }
    ],
    "support": {
        "email": "获取项目支持的相关信息对象的邮箱，ps:support@example.org",
        "irc": "IRC 聊天频道地址，类似于 irc://server/channel",
        "issues": "跟踪问题的 URL 地址，ps: https://github.com/composer/composer/issues",
        "forum": "论坛地址",
        "wiki": "Wiki 地址",
        "source": "网址浏览或下载源"
    },
    
    "version": "应该符合 'X.Y.Z' 或者 'vX.Y.Z' 的形式。！！！官方建议忽略",
    "type": "当前 Root 包类型：①.library 表示当前是一个第三方依赖库；②.project 表示当前是一个项目；③. metapackage；④. composer-plugin。官方建议忽略这个属性",
    
    "include_path": [
        "建议弃用，但 Composer 保留了这一过时的做法", 
        "https://www.php.net/manual/zh/ini.core.php#ini.include-path"
    ],
    "target-dir": "定义当前包安装的目标文件夹. 弃用：这仅用于支持传统的 PSR-0 样式自动加载，并且所有新代码最好是没有使用 target-dir 的 PSR-4"
}
```

- [3.2. 自动加载器优化](https://learnku.com/docs/composer/2018/autoloader-optimization/2090) 即：为 `composer update/dump-autoload` 命令指定 `-o` 参数，生成对应的 `classMap` 缓存文件。
- [4.1. 如何为我的框架自定义一个扩展包安装目录？](https://learnku.com/docs/composer/2018/how-do-i-install-a-package-to-a-custom-path-for-my-framework/2099) 即：通过 `extra.installer-paths` 属性设置对应扩展包的安装路径
- [4.4. 我应该将 vendor 目录加入版本控制吗？](https://learnku.com/docs/composer/2018/should-i-commit-the-dependencies-in-my-vendor-directory/2102) 如非必要，请不要这样操作。
- [`composer.lock` 文件应该被提交到版本控制中吗？](https://docs.phpcomposer.com/01-basic-usage.html#composer.lock-The-Lock-File)  请将 `composer.lock/composer.json` 一并通过 VCS 进行提交管理



## PHP 性能优化

### 性能分析

- [xhprof](https://www.php.net/manual/zh/book.xhprof.php)

```shell
# 安装 
```

### Opcache 缓存加速

- [PHP四大加速缓存器opcache，apc，xcache，eAccelerator与php解析的初步理解](https://blog.csdn.net/Fa_Ker/article/details/79769873)
- [php静态缓存和纯静态有哪些区别？](https://segmentfault.com/q/1010000000143949/a-1020000000158432?utm_source=sf-backlinks)
- [哪种php加速器最靠谱APC，XCache，eAccelerator](https://segmentfault.com/q/1010000000119592)
- [Difference between APC, APCu and Opcache?](https://stackoverflow.com/questions/29187601/difference-between-apc-apcu-and-opcache)
- [What Are The Best PHP Accelerators?](https://wp-rocket.me/blog/best-php-accelerators/)


## PHP Pillars Static Analysis（PHP 静态分析）

利用 composer 安装 PHP 静态代码分析三大支柱工具：[The Three Pillars of Static Analysis in PHP](https://phpstan.org/blog/three-pillars-of-static-analysis-in-php)。

PHP 本身是动态-解释型语言，使用静态分析工具（在代码执行之前对其进行分析）可以让我们的 PHP 代码更加的规范、健壮、安全。


### √ PHP-Parallel-Lint - 语法检查工具

PHP 语法检测工具：确保你可以写出编译通过的代码。PHP 原生支持使用 `php -l <file>` 对单 PHP 文件语法检测，不使用于复杂的项目场景。我们可以借助 PHP 语法检测工具 - [PHP-Parallel-Lint](https://github.com/php-parallel-lint/PHP-Parallel-Lint) 支持批量检测。

安装检查工具：`composer require --dev php-parallel-lint/php-parallel-lint`；安装控制台输出彩色支持：`composer require --dev php-parallel-lint/php-console-highlighter`.

### √ PHP 代码规范

开发者在写代码的时候都U需要尽可能的保证代码符合：**可重用性、可维护性、可扩展性**。一门开发语言代码规范标准的建立对于提高该语言代码的**可维护性**有着至关重要的地位和作用。

#### √ PHP PSR 标准规范

[`PSR` 是 `PHP Standard Recommendation`（PHP 标准推荐）](https://learnku.com/docs/psr)) 的缩写，它是由 `PHP` 社区（[`PHP FIG - PHP Framework Iteroperability Group` 组织，即：PHP 框架可互用性小组](https://www.php-fig.org/psr/)）创建的一套准则和建议，用于建立 `PHP` 编码风格、代码结构、包/扩展/应用开发的标准化。

`PSR` 的目的通过标准化的接口、命名规则和设计模式来促进 PHP 框架、库和组件之间的“互通性/互操作性”，从而提高 `PHP` 代码的质量和一致性。简单来说：**通过定义一整套绝大部分人都认可的标准，让 PHP 开发人员可以确保他们的代码是一致的，并遵守最佳实践，使其更容易与其他开发人员合作，并整合第三方软件包和库。**

一般 `PHP` 开发人员至少需要了解的有：`PSR-1`: 基本编码标准、`PSR-12`: 扩展编码风格指南。

如果想了解更多框架、组件的源码可以增加阅读其他 `PSR` 规范：
- `PSR-3`：日志接口规范，定义了日志库的通用接口（如：`Monolog` 日志库的源码）
- `PSR-4`：自动加载规范，定义了一个自动加载 PHP 类的标准（如 `Symfony Console` 的源码）
- `PSR-7`：HTTP 消息接口规范，定义了HTTP消息（请求和响应）的接口（如：`Guzzle` 的源码）
- `PSR-18`： HTTP 客户端接口规范（如：`Guzzle` 的源码）
- `PSR-11`：容器接口，定义了依赖性注入容器的通用接口（如：`Guzzle` 的源码）

#### √ 编码规范 - [**PSR-1:基础编码规范**](https://learnku.com/docs/psr/basic-coding-standard/1605)、[**PSR-12：编码规范扩充**](https://learnku.com/docs/psr/psr-12-extended-coding-style-guide/5789)

编码规范的目的：**减少不同人在阅读代码时认知冲突**。下方是 `PSR-1`、`PSR-12` 的一个示范说明

```php
<?php

/**
 * This file contains an example of coding styles. // 文件级文档说明
 */

declare(strict_types=1); // 声明语句：https://www.php.net/manual/zh/control-structures.declare.php  declare 对包含它的父文件不起作用

namespace 命名空间声明; // https://www.php.net/manual/zh/language.namespaces.php

use Vendor\Package\{Class A as A, ClassB}; // 使用命令空间引用类

use Vendor\Package\OneTrait;
use Vendor\Package\TwoTrait;

use function Vendor\Package\{functionA, functionB, functionC};  // 使用命令空间引用方法

use const Vendor\Package\{CONSTANT_A, CONSTANT_B, CONSTANT_C}; // 使用命令空间引用常量

/**
 * Test is an example class. // 类-级别文档说明
 */
class Test extends ParentsClass implements
    InterfaceA,
    InterfaceB,
    InterfaceC
{
    use OneTrait;
    use TwoTrait;
    
    public const CONST_A = 'A';
    protected const CONST_B = 'B';
    private const CONST_C = 'C';
    
    public $foo = null;
    public static int $bar = 0; // static 声明必须在可见性声明（private、protected、public）后面
    
    // `abstract` 和 `final` 必须先于可见性声明之前声明
    // `static` 必须在可见性声明之后
    // abstract protected static function zim(); 
    
    public function testFunA(int $a, string $b, $c) 
    {
        // 方法体： `(` 和方法名及参数列表间不能有空格，、`)` 的左右不能有空格 
    }
    
    public function testFunB(
        int $a, 
        string $b, 
        $c
    ) {
        // 方法体：参数列表多行的时候参数必须在新行并缩进 1 次，且每行只能有 1 个参数； `(` 和 `{` 必须在同一行
    }
    
    public function testFunC(
        int $a, 
        string $b, 
        $c
    ): string {
        // 方法体：有返回类型声明时 `)` 和 `:` 不能有空格；`:` 和类型之间必须有空格；返回类型 和 `{` 必须有空格
        return 'string';
    }
    
    final public static function testFun(
        ?int $a, 
        string $b, 
        &$c,
        ...$parts
    ): ?string {
        // 方法体
        // 可空类型声明 `?` 和 类型声明 之间不能有空格：可空类型 https://www.php.net/manual/zh/migration71.new-features.php
        // `&`引用运算符后不能有空格：https://www.php.net/manual/zh/functions.arguments.php#functions.arguments.by-reference
        // 可变长参数的 `···` 和参数名之间不能有空格 https://www.php.net/manual/zh/functions.arguments.php#functions.variable-arg-list
        return 'string'; 
    }
    
    // 流程控制
    public function control() 
    {
        if ($expr1) {
            // if body
        } elseif ($expr2) {
            // elseif body
        } elseif (
            $expr3
            && $expr4
        ) {
            
        } else {
            // else body;
        }
    }
}
```

**文件、代码行、缩进、关键词和类型**

- 必须以 `<?php` 或 `<?=` 标签开始（个人建议：**必须** 以 `<?php `开始，因为短标签和自定义标签在 swoole 和 其他框架中部分是不支持的）
- 在仅含 PHP 代码的文件中，**必须** 省略 `?>` 标记
- PHP 代码文件 **必须** 以「不带 BOM 的 UTF-8 编码」保存
- **必须** 以非空行且行尾使用 `Unix LF`（换行符）结尾
- Files **SHOULD** either declare symbols (classes, functions, constants, etc.) or cause side-effects (e.g. generate output, change .ini settings, etc.) but SHOULD NOT do both.（感觉现在的翻译都不太准确，所以直接引用了原文。关于：[什么是 `side-effects `](https://medium.com/thinkster-io/code-smell-side-effects-caf799df2151) 可以阅读一下）
- 行数不得有限制，行宽必须在 120 字符内
- 代码一行长度不应该超过 80 字符，若超过该长度应拆分为多个长度不超 80 字符的后续行，行位 **必须不能** 有空格
- 可以添加空行已提高代码可读性，除非明确禁止
- 每行不能有多个语句
- 代码必须使用 4 个空格进行缩进，不能使用 缩进标签-`Tab` 键
- PHP 中所有的关键字和保留关键字都 **必须** 使用小写，未来 PHP 中新加的关键字和保留关键字也 **必须** 使用小写
- 类型关键字 **必须** 使用缩写，如：使用 `bool` 而非 `boolean`，使用 `int` 而非 `integer`


**声明、命名空间以及导入**

- 命名空间以及类 **必须** 符合 `PSR-4` 的自动加载规范

**类、属性和方法**

这里的「类」指的是所有的类（普通类/抽象类）、接口类以及 [`trait`](https://www.php.net/manual/zh/language.oop5.traits.php)

- 任何注释和语句 **不得** 跟右花括号同一行.（即： `} // 注释` 是错误的，只能是 `{ // 注释`）
- 实例化一个类时，后面的 `()` **必须** 显示的加上
- 关键字 `extens` 和 `implements` **必须** 和 `class` 同一行申明
- 类的左花括号 `{`、右花括号 `}` **必须** 单独成一行
- `{` 的上一行或下一行不得存在空行，`}` 的上一行不得存在空行
- 如果 `implements` 和 接口类换行，那么每行必须只能写一个接口类名，且每行需要缩进 1 次
- `use xxxTrait` 必须在 `{` 下一行申明，且每个 `trait` 都必须用 `use` 单独一行导入
- **类的命名 必须 遵循大驼峰命名规范（帕斯卡命名法）；方法名称/类属性名称 必须 遵循小驼峰命名规范（驼峰命名法）；类（类、接口、可复用代码块-traits）的常量所有字母 必须 大写** 
- 方法和函数名称中，方法/函数名后面 **一定不可** 使用空格
- 参数列表 **可以** 分为多行，每行参数缩进一次。当这么做时，第一个参数 **必须** 放在下一行，且每行 **必须** 只能有一个参数，右圆括号 `)` 和 左花括号 `{` **必须** 放在同一行且单独成行，两者之间存在一个空格。
- `abstract` 和 `final` **必须** 先于可见性声明之前声明，`static` **必须** 在可见性声明之后

**方法、函数的调用**

- 方法名或函数名与左括号 `(` 之间不能出现空格
- 在右括号 `)` 之后也不能出现空格，并且在右括号之前也不能有空格
- 在参数列表中，每个逗号前面不能有空格，每个逗号后面必须有一个空格
- 参数列表 **可以** 分为多行，每行后面缩进一次，此时列表中的第一项 **必须** 位于下一行，并且每一行 **必须** 只有一个参数
- 跨多个行拆分单个参数 (就像匿名函数或者数组那样) 并不构成拆分参数列表本身

```php
$foo->bar(
    $longArgument,
    $longerArgument,
    $muchLongerArgument
);

// 数组作为参数，跨多行
somefunction($foo, $bar, [
  // ...
], $baz);

// 匿名函数做参数，跨多行
$app->get('/hello/{name}', function ($name) use ($app) {
    return 'Hello ' . $app->escape($name);
});
```

**流程控制**

- 流程控制关键词之后 **必须** 有一个空格；左括号 `(` 后面不能有空格；右括号 `)` 前面不能有空格
- 右括号 `)` 和 左大括号 `{` 之间 **必须** 有一个空格，且在同一行 `) {`
- 流程主体 **必须** 在左大括号 `{` 之后另起一行，右大括号 `}` **必须** 在流程主体之后另起一行，且主体 **必须** 缩进一次
- **应该** 使用关键词 `elseif` 替换 `else if` 的写法
- 括号中的表达式可能会被分开为多行，第一个条件 必须 在新的一行且每一行至少缩进一次
- 流程控制语句 `( )` 中间的布尔控制符 **必须** 在每一行的开头或者结尾，但要保持规则一致，不要混在一起使用
- `switch-case` 流程控制中 **必须** 要有一行 `// no break` 这样的注释在不为空且不需要中断的 `case` 主体中

**阅读：**

- [Code Smell: Side Effects](https://medium.com/thinkster-io/code-smell-side-effects-caf799df2151)
- [函数式编程中如何处理副作用？](https://www.cnblogs.com/fs0196/p/12967756.html)
- [阮一峰：函数式编程入门教程](https://ruanyifeng.com/blog/2017/02/fp-tutorial.html)



#### √ PHP_CodeSniffer - 代码规范检查工具

[`PHP_CodeSniffer`](https://github.com/squizlabs/PHP_CodeSniffer) 是一款**自动化的 PHP 代码规范检查工具包**，能帮助开发者写出符合规范的代码。其内置了两个工具：**`phpcs` 用来检查代码规范，`phpcbf` 用来纠正代码规范。**

但 `phpcbf` 的修复功能比较弱，如果你需要更加强大的代码风格修复工具可以使用 [`PHP-CS-Fixer/PHP-CS-Fixer`](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer)

详细的使用方法可以看：[PHP_CodeSniffer/wiki/Usage](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Usage)。同时你可以 [在 PHPStrom 中集成 Code Sniffer](https://learnku.com/articles/5646/php-series-code-sniffer-for-code-specification) 工具。


### √ PHPStan - PHP 代码静态分析工具

[`PHPStan`](https://github.com/phpstan/phpstan) 是一款 PHP 代码静态分析工具，能分析出代码的健壮性并给出对应建议，帮助开发者写出更加健壮的代码。详细可以阅读 [英文文档：PHPStan Getting Started](https://phpstan.org/user-guide/getting-started)，简单使用也可以阅读：[PHPStan 中文文档](https://learnku.com/docs/phpstan/2022)。

```shell
# 设置 composer global bin 目录
mkdir -p /apps/composer-bin
composer global config bin-dir /apps/composer-bin

# 安装 php-parallel-lint 语法分析工具：https://github.com/php-parallel-lint/PHP-Parallel-Lint
composer global require --dev "php-parallel-lint/php-parallel-lint=*"

# 安装 php_codesniffer 编码规范分析工具：https://github.com/squizlabs/PHP_CodeSniffer
composer global require "squizlabs/php_codesniffer=*"

# 安装 phpstan 静态代码分析：https://github.com/phpstan/phpstan
composer global require --dev phpstan/phpstan
```

### √ 将 PHP 静态分析集成到 Git Commit 中

- [git commit时进行PHP代码的语法和风格检查工具](https://blog.csdn.net/hfut_wowo/article/details/86304342)
- [PHP code check](https://github.com/wowo-zZ/php-cc)

1. 项目场景分为：公司、个人，公司项目需要进制在保护分支（master/dev/feature-20xxxxxx）上直接提交代码
2. 使用 `gofmt` 进行格式化提交的 `*.go` 文件
3. 使用 `parallel-lint` 进行 `*.php` 文件检查语法（不通过，退出）
4. 使用 `phpcs` 进行 `*.php` 文件检查代码规范（公司项目通过，予以警告；个人项目不通过）
5. 使用 `phpstan` 进行 `*.php` 文件进行静态分析（公司项目通过，予以警告；个人项目不通过）


```sh
#!/bin/sh
# 检查当前推送的远程环境是否为公司仓库项目地址
strict=$(git remote get-url --push `git remote` | grep -c qeeq.cn)

# 定义受保护的分支的表达式
protected_branch='master|dev|main'
# 获取当前分支名
current_branch=$(git rev-parse --symbolic --abbrev-ref HEAD)
#当前项目绝对路径
current_dir=$(git rev-parse --show-toplevel)
cd $current_dir

# 严谨模式-禁止在保护分支直接 commit 信息
if [ "$strict" = "1" ] && [ $(echo "$current_branch" | grep -Ec "$protected_branch") = "1" ]; then
    echo ".git/hooks: Do not commit to protected branch:$current_branch"
    exit 1
fi

# 使用 gofmt 进行格式化提交的 *.go 文件再提交
golang_files=$(git diff --cached --name-only --diff-filter=ACM -- '*.go')
# 判断 commit 文件列表中是否有 *.go 文件
if [ ! -z "$golang_files" ]; then
    # 检测是否安装 gofmt
    command -v gofmt >/dev/null 2>&1 && {
        # 获取暂存区中待 commit 的 *.go 文件
        golang_files=$(git diff --cached --name-only --diff-filter=ACM -- '*.go')
        for FILE in $golang_files
        do
            gofmt -w $FILE
            echo "格式化："$FILE
            git add $FILE
        done
    } || echo "Warning: gofmt: command not found!\n"
fi

# 判断 *.php 文件列表
php_files=$(git diff --cached --name-only --diff-filter=ACM -- '*.php')
appendFiles=$(git diff --cached --name-only --diff-filter=A -- '*.php')
updateFiles=$(git diff --cached --name-only --diff-filter=CM -- '*.php')

composer_bin_dir=$(composer global config bin-dir -q --absolute)
phplint_path=$composer_bin_dir"/parallel-lint"
phpcs_path=$composer_bin_dir"/phpcs"
phpcbf_path=$composer_bin_dir"/phpcbf"
phpstan_path=$composer_bin_dir"/phpstan"

# 判断 commit 文件列表中是否有 *.php 文件
if [ ! -z "$php_files" ];then
  command -v $phplint_path >/dev/null 2>&1 && {
    phplint_res=$($phplint_path $php_files) && test $? -eq 0  && {
      echo "Parse OK!"
      echo "-------------------------------phplint-------------------------------\n"
    } || {
      echo "$phplint_res"; exit 1; # Parse error
    }
  } || echo "Warning: phplint: command not found!(#$phplint_path)"
  
  command -v $phpcs_path >/dev/null 2>&1 && command -v $phpcbf_path >/dev/null 2>&1 && phpcsInstalled=1 || phpcsInstalled=0
  if [ "$phpcsInstalled" = "1" ]; then
    # 如果是新增文件：使用 phpcs 检查规范,并使用 phpcbf 进行统一格式化
    if [ ! -z "$appendFiles" ]; then
      for append_file in $appendFiles
      do
        $phpcs_path --standard=PSR12 $append_file || {
          $phpcbf_path --standard=PSR12 $append_file
          echo "[phpcbf] $append_file"
        }
      done
    fi

    # 如果不是新增文件：非严格模式下，使用 phpcs 检查规范,并使用 phpcbf 进行统一格式化；严格模式下跳过检测
    if [ "$strict" != "1" ] && [ ! -z "$appendFiles" ]; then
      for append_file in $appendFiles
      do
        $phpcs_path --standard=PSR12 $append_file || {
          $phpcbf_path --standard=PSR12 $append_file
          echo "[phpcbf] $append_file"
        }
      done
    fi
    echo "---------------------------PHP_CodeSniffer---------------------------\n"
  else
    echo "Warning: phpcs/phpcbf: command not found!(#$phpcs_path $phpcbf_path)\n"
  fi

  command -v $phpstan_path >/dev/null 2>&1 && phpstanInstalled=1 || phpstanInstalled=0
  if [ "$phpstanInstalled" = 1 ];then
    if [ "$strict" != 1 ];then 
      # 非严格模式下，使用 phpstan 最高等级分析检查所有文件；
      $phpstan_path analyse --level=9 $php_files
    elif [ ! -z "$appendFiles" ]; then
      # 严格模式下，使用 phpstan 最高等级分析检查新增的文件；
      $phpstan_path analyse --level=9 $appendFiles
    fi
    echo "-------------------------------phpstan-------------------------------\n"
  else 
    echo "Warning: phpstan: command not found!(#$phpstan_path)\n"
  fi
fi

# 最后至关重要！！！
# 防止上述命令有非成功推出，shell脚本默认返回 $?
# return 只能用于 function 中
exit 0
```



## PHP 中遇到的一些坑

**`devil is in the details` - 魔鬼藏在細節裡**！ 有时候文档中的一个小细节，可能会：出其不意攻其不备，让你出 bug ...

### √ `http_build_query` 的坑

#### √ `http_build_query` 删除 `NULL` 值
结论：[Params with null value do not present in result string.](https://www.php.net/manual/en/function.http-build-query.php#60523)（参数值为 null 的参数会被删除）。

```php
<?php
$arr = array('test' => null, 'test2' => 1);
echo http_build_query($arr);

// test2=1
```

通过 HTTP 进行服务间调用，接口需要进行安全校验，通过公用函数对参数生成一个 `sign` 值，然后再使用 `http_build_query` 对请求参数进行 URL-encoded，突然收到业务告警遇到某个订单调用保险购买服务失败。

查询了日志发现是报：sign 校验失败。而且就这么一个个例，最后排查发现是 `http_duild_query` 将值为 `null` 的参数删除，导致保险业务接收到的参数丢失，从而引起的 sign 值前后不一致导致。

解决办法：
1. 在生成 sign 之前将值为 `null` 的参数先 unset 掉再生成 sign
2. 给参数一个默认类型，譬如：使用空字符串代替 null

禁忌在底层生成验签的函数进行修改，这样可能会导致已经生成的 sign 大量的报错。

####  √ `http_build_query` - 生成 `URL-encode` 之后的请求字符串

处理一个 URL 的小需求，发现了下面两段逻辑一样的代码被 `Ctrl-c-v` 到了 5-6 处地方...

```php
// 写法1
$param = '';
if (xxx) {
    $param  .= 'xxx=xxx&'
} elseif (xxx) {
     $param  .= 'xxx=xxx&'
}
...
$params = trim($params, '&');
$url = 'xxx?' . $params;

// 写法2
foreach ($search_params as $k=>$v) {
    if ($v === null || $v === '') {
        continue;
    }
    $params .= '&' . $k . '=' . $v;
}
$params = trim($params, '&');
$url = 'xxx?' . $params;
```

于是将代码抽离到了公共函数库，然后将其他地方所有调用都改为调用公共函数库，大致伪代码如下：

```php
$param = [
    'x' => 'x',
    'xx' => 'xx',
];
$addParam = function($key) use (&$param, $data) {
    if (!empty($data[$key])) {
        $param[$key] = $data[$key];
    }
    
    return $param
};
$addParam('xxxx');
$addParam('xxxxxx');
...

return 'xxx?' . http_build_query($param);
```

以为抽离的函数和上述结果是等同，使用本地 Mock 数据测试了一下也没什么问题，结果还是忽略了 `PHP` 文档中关于 `http_build_query` 函数的细节：返回一个 **URL-encode** 之后的请求字符串。

结果一提交到测试环境给测试，哟嚯...出现问题了，点击接口返回的重搜链接显示搜索报错了，排查发现是因为 `from_date_1=10:00&to_date_1=10:00` 被转义为 `from_date_1=10%3A00&to_date_1=10%3A00`。

立刻意识到问题，修复代码，将：`return 'xxx?' . http_build_query($param);` 改为 `return 'xxx?' . urldecode(http_build_query($param));`

### √ PHP JSON 使用的一些注意点

**！！！注意：虽然像：JSON、HTTP协议、URL编码、序列化...这些都是有明文协议进行规范的，但涉及到：跨语言数据交互、提供对外接口...等情景，需要特别注意：**
1. **当前使用语言对这些协议的实现是否有多套不同的实现？**
2. **不同实现区别在哪里？应当如何权衡选择调用？**

这些不同实现方式返回的结果往往在绝大多数情况下是一致的，只在一些细微的处理上有差异，有差异但并不一定就是说哪一个就一定是错误的，可能是语言的差异导致的，也可能是协议不同版本规范导致的，但**返回的结果仍然是符合协议规定的**！以下也同步列举了 PHP 中使用函数的一些其他坑，如：

1. PHP 中 `json_decode` 默认会将 `{}` 反解析为一个空数组,当再次`json_encode`时，结果变成了：`[]`...但返回结果依然还是符合 `JSON` 格式规范的
> 特别使用 `JSON` 格式和强类型语言（JAVA、ObjectC、Swift）进行对接时，这堪称一个世纪大坑...

2. PHP 中 `json_encode`/`json_decode` 会对数值类型进行转换;大数值类型、浮点数类型可能会发生数据溢出或精度丢失。如 `{"a":500.00}` 默认情况下会被转换为 `['a' => 500]` 
> 可以协定传递数值时候**使用字符串类型进行数据交互**，各业务方自行进行数据类型的转换使用


3. PHP 序列化函数同样存在：默认会将空对象`{}`序列化为`[]`
4. 中文在 `json_encode` 的时候会被 Unicode 编码，记录的日志含中文会看不懂，可以添加：`JSON_UNESCAPED_UNICODE` 常量

以上情况可以看看 [JSON 常量](https://www.php.net/manual/zh/json.constants.php)。


### √ PHP 脚本执行超时时间

在 `Stack Exchange Network` 上看到一个关于 PHP 脚本超时的问题：[PHP-FPM workers timeout times exceeding configuration limits](https://serverfault.com/questions/1060996/php-fpm-workers-timeout-times-exceeding-configuration-limits). 遂有此文，以示记录学习。

`LNMP` 架构中，设置 PHP 脚本超时的配置如下：

`php.ini` 配置

```php.ini
max_execution_time = 60 # 最大执行时间
max_input_time = 60 # 最大等待输入时间
```

`php-fpm.conf` 配置

```php-fpm.conf
pm = static
pm.max_children = 300
pm.max_requests = 5000
request_terminate_timeout = 300
```

`Nginx VirtualHost` 配置
```conf
location ~ \.php$ {
  ...
  fastcgi_connect_timeout 300s;
  fastcgi_read_timeout 300s;
  fastcgi_send_timeout 300s;
  fastcgi_keep_conn on;
  ...
}
```


### √ PHP 压缩文件操作小记

最近在虚拟主机上使用 `WordPress` 帮人搞了一个快速建站，其中有一步 “将 `WordPress.zip` 上传到主机然后解压”。细想一下，貌似之前没有这样操作过，遂有此文。

有哪些方法呢？？

1、`php` 判断压缩包的格式，然后通过 `exec()` 函数执行 `Linux` 的 [`tar/unzip/bz2` 等命令](https://www.runoob.com/w3cnote/linux-tar-gz.html) 进行解压/压缩操作

2、`php` 内部应该也有对应的扩展类或函数，通过 `PHP C API` 来操作这些系统接口（主要是记录这个）。

- [压缩与归档扩展：https://www.php.net/manual/zh/refs.compression.php](https://www.php.net/manual/zh/refs.compression.php)

1. `Gzip` 和 `Zlib` 算法：`Gzip` 和 `Zlib` 算法是快速的压缩算法，适合对大量数据进行快速压缩和解压缩。它们的**压缩比较低，但是速度非常快**。
2. `Bzip2` 算法：`Bzip2` 算法比 `Gzip` 和 `Zlib` 算法慢，但它具有更高的压缩比。因此，它适用于**对较小的数据进行高效压缩**。
3. `Rar` 算法：`Rar` 算法与 `Bzip2` 算法类似，但**速度更慢，压缩比更高**。因此，它**适用于对较小的数据进行高效压缩**。
4. **`PHP` 中的 `ZipArchive` 类和 `Phar` 类是基于 `Zlib` 算法**的，因此它们的速度和压缩比与 `Gzip` 和 `Zlib` 相似。
5. 但是，**Phar 类在处理大量小文件时可能比 ZipArchive 更高效**，因为它使用了一些**内存优化技巧**。

在选择压缩和解压缩方法时，最好根据具体情况进行测试和评估:

1. 使用大型数据集（不同类型和大小的文件），测试“**压缩和解压缩速度**”
2. 使用一些标准数据文件，并记录压缩后文件的大小，测试“**压缩比**”
3. 测试在不同的**硬件配置和负载条件**下的性能。如果你的应用程序在高负载情况下运行，那么在高负载情况下测试性能是很重要的。测试的环境应该与生产环境尽可能相似
4. **内存使用**：测试不同方法在压缩和解压缩数据时所需的内存使用量
5. **代码实现难度**：评估不同方法的代码实现难度和复杂性，以确定哪种方法最适合你的应用程序



#### √ PHP 压缩字符串

最近有个需求要将搜索报价数据存放起来，便于静态报价分析和 SEO 展示。响应报文的 JSON 字符串大约有 120K 左右，想着使用统一的封装函数压缩一下 `base64_encode(gzcompress($data))`，使用时 `gzuncompress(base64_decode($data))` 即可。

但是在 `gzuncompress` 时候总是报错 `data error`，一开始以为是 bug，后来发现是因为数据库设置的字段短了，导致部分数据会丢失一点，导致这些数据解压时报错。

```php
// $data 是原字符串
echo strlen($data); // 144891
echo strlen(gzcompress($data, 9)); // 7622，压缩比例大概在 1/2
echo strlen(base64_encode(gzcompress($data, 9))); // 10164，base64会增长大概 1/3 体积


echo strlen(gzencode($data, 9)); // 7634
echo strlen(gzdeflate($data, 9)); // 7616
```

压缩比例：`gzdeflate`（采用 `DEFLATE` 压缩方式） > `gzcompress` （采用 `zlib` 压缩方式） > `gzencode`（采用 `gzip` 压缩方式）

结合网友给的压缩效率： `gzcompress` > `gzdeflate` > `gzencode`

- [php gzuncompress data error问题解决](https://blog.csdn.net/lihb018/article/details/78207196)
- [php几种编码与序列化(rawurlencode, igbinary,json_encode)的区别](https://blog.csdn.net/William0318/article/details/100058192)
- [igbinary 扩展](https://github.com/igbinary/igbinary/)

## PHP 小记

### √ PHP: Arrays vs Objects

- https://beamtic.com/arrays-vs-objects-php
- [PHP 中的数据结构 - `SplFixedArray`](https://www.php.net/manual/zh/class.splfixedarray.php)
- [PHP 中的 `Array` 数组](https://www.php.net/manual/zh/language.types.array.php)
- [PHP 中的类与对象](https://www.php.net/manual/zh/language.oop5.php)

从性能角度：

1. 内存占用：由于**对象需要更多的内存来存储它的属性和方法**，所以在内存使用方面，对象会比数组更占用内存。在大量数据传递时，这可能会影响性能（注意：[`SplFixedArray`](https://www.php.net/manual/zh/class.splfixedarray.php)是 PHP 中提供的固定长度数组数据结构，而 `array in php` 的底层是 `HashMap` 数据结构，可能会比对象更加耗内存）
2. 访问速度：在访问单个元素时，**数组通常比对象更快**。这是因为数组元素是通过数字索引来访问的，而对象属性需要进行解析和查找。
3. 迭代：在遍历整个数据集时，数组和对象的性能差异可能不那么明显，因为它们都需要进行遍历。

从**可读性、可维护性**角度：

1. 需要强类型：对象可以强制属性具有特定的数据类型，并确保在使用时不会出现类型错误
2. **可读性和可维护性：对象可以提供更好的封装和抽象，使代码更易于阅读和维护**
3. 代码复用：对象可以封装一些常用的方法，从而可以在多个地方重复使用
4. 代码扩展：对象可以很容易地添加新的属性和方法，而不会对现有代码造成太多的影响
5. 使用面向对象编程范式时，对象是必不可少的一部分

```php
/**
 * 将对象的属性转换为数组
 * @return array
 */
public function toArray() {
    return get_object_vars($this);
}

/**
 * 通过魔术方法实现 getter/setter 方法
 * @param string $method
 * @param array $args
 * @return null
 */
public function __call($method, $args) {
    $act = substr($method, 0, 3);
    $property = lcfirst(substr($method, 3));
    if($act === 'get') {
        return $this->{$property};
    }
    if($act === 'set') {
        if(empty($property) || !property_exists($this, $property)){
            trigger_error('Call to undefined method '.__CLASS__.'::'.$method.'()', E_USER_ERROR);
        }
        if(!empty($args)) {
            $this->{$property} = reset($args);
        }
    }
}
```

**如果需要实现复杂的逻辑或者需要将代码进行分层和封装，使用对象进行传递数据是更好的选择，如果需要简单地传递数据或进行简单的计算，使用数组就足够了。**

### PHP 服务注册时，获取本机 IP

```php
/************************************
* ©著作权归作者所有：来自51CTO博客作者hgditren的原创作品，侵删
* php获取当前服务器的IP
* https://blog.51cto.com/phpme/5093221
************************************/
function get_local_ip()
{
    $result = gethostbynamel(gethostname());
    if ($result === false) {
        throw new \Exception('无法解析出IP');
    }

    $filterIP = '127.0.0.1';
    $result = array_filter($result, function ($item) use ($filterIP) {
        return $item != $filterIP;
    });

    if (empty($result)) {
        throw new \Exception('无法获取IP');
    }
    $result = array_values($result);

    return $result[0];
}
```


### √ PHP 优化

> - PHP 优化：https://www.awaimai.com/1050.html

1. **尽量使用PHP内部函数**，因为它们都是 C 语言实现且经过 PHP 官方优化的，效率更高。
2. **能用[PHP内部字符串操作函数](https://www.php.net/manual/zh/ref.strings.php)的情况下，尽量用他们**，不要用正则表达式， 因为其效率高于正则。
3. 先用 `strpos` 确定需要进行替换操作，再调用 `strtr/str_replace` 进行替换，这样效率更高也更加节省内存
4. 对于大的字符串数据存储，尽量使用 `gzcompress/gzdeflate` 进行压缩再进行存取操作，可以减少IO、网络带宽、内存，但压缩和解压会对 CPU 有消耗。可以考虑使用 `protobuf` 进行压缩和解压，据说更加高效
6. `echo` 使用 `,` 逗号而不是 `.` 点号作为连接符，逗号隔开的多个字符串当作“函数”参数传入，所以速度会更快。
7. 字符串尽量使用单引号，而不是双引号，使用双引号的字符串 PHP 引擎读取字符串内容后，会先查找其中的变量，并改为变量对应的值。
8. 【不赞同】使用`isset`代替 `strlen`，`strlen` 是函数，多多少少会有些慢，因为函数调用会经过诸多步骤，如字母小写化、哈希查找，会跟随被调用的函数一起执行。但相差不大，使用 `strlen/mb_strlen` 会更加的见名知意，且对于多字节字符串，使用 `isset($str[index])` 会判断错误，除非在符合某些特定要求且极端的情况下，否则我不认为这是一个好的措施。**`strlen()` 返回的是字符串的字节数，而不是其中字符的数量；`mb_strlen()` 返回的是字符串通过码点进行计算的字符长度；**
9. 输出字符串 `echo` 效率比 `print` 高，输出大字符串的时候，可以将 `ob_start` 开启将内容放到缓冲区改善性能
10. 最好不用错误抑制符 `@`（尤其是在循环中），实在是有需要可以先 `error_reporting(0)` 关闭错误再开启
11. 【废弃】不要滥用`__autoload`、设计不好的自动装载函数会导致函数大量判断文件是否存在需要磁盘I/O操作，而磁盘I/O是很低效的。**在系统设计时，需要定义一套清晰的、将类名与实际磁盘文件映射的机制，规则越简单越明确，`__autoload()` 机制的效率就越高。**`__autoload()` 在 `PHP7.2`起启用，`PHP8.0` 正式移除，可以使用 `spl_autoload_register()` 进行类的自动加载。
12. 不要在循环中用函数，如：`for($x=0; $x < count($array); $x++) {}` 每次都需要 `coutn($array)` 大大降低效率
13. 在**简单的判断语句中**，三元运算符`?:`更简洁高效！避免三元运算符嵌套使用，代码是写给人看的，更多时间是在维护上，因此要考虑后期维护成本。
14. 使用 `error_reporting()` 函数来预防潜在的敏感信息显示给用户，譬如：屏蔽 `warning`、`notice` 报错显示给前端用户。
15. `switch-case` 好于使用多个 `if-elseif` 语句，并且代码更加容易阅读和维护。如果条件分支的代码片段比较大，那么应该考虑：是否可以封装为独立的函数，然后结合 `switch-case` 一并使用。
16. 不使用短标签 `<?` 而是应该使用 `<?php`，譬如：`Hyperf` 框架就必须要求关闭短标签的配置才能运行
17. 如果文件内容是纯 PHP 代码，最好在文件末尾删除 PHP 结束标记 `?>`。这个[官方的解释：避免在 PHP 结束标记之后万一意外加入了空格或者换行符，会导致 PHP 开始输出这些空白，而脚本中此时并无输出的意图](https://www.php.net/manual/en/language.basic-syntax.phptags.php)。
18. 函数快于类方法；基类里面只放能重用的方法，其他功能尽量放在子类中实现，子类里方法的性能优于在基类中；类的性能和其方法数量没有关系。
19. 【不赞同】在可以用`file_get_contents()`替代`file()`、`fopen()`、`feof()`、`fgets()`等系列方法的情况下，尽量用`file_get_contents()`。
    - 没找到 `file_get_contents()` 更加高效的证据，只是在使用上更加简单而已...
    - 一般如果只是简单读写小文件用 `file_get_contents()`，该函数将文件读取返回一个字符串
    - `fopen` 则是返回一个资源句柄，一般需要结合 `fgets/fclose` 来一并使用，对于大文件、复杂读写情况会更加适用
    - 如果是用来做`HTTP`请求，那么不用争论选择 `curl_xx`：[PHP fopen/file_get_contents与curl性能比较](https://www.php.cn/php-weizijiaocheng-425311.html)
20. 【有待商榷】通过参数地址引用的方式，实现函数多个返回值，这比按值传递效率高，但是“引用用不好，bug 少不了”。PS：[PHP 引用是个坑，请慎用](https://zhuanlan.zhihu.com/p/35107602)
21. 方法不要细分得过多，仔细想想你真正打算重用的是哪些代码？
22. 【有待商榷】如果一个方法能被静态，那就声明它为静态的，速度可提高1/4，作者测试的时候，这个提高了近三倍，当然这个测试方法需要在十万级以上次执行，效果才明显。
    - 静态方法在程序开始时生成内存，而实例方法（非静态方法）在程序运行时才生成内存，因此调用快，但会耗费更多内存
    - 静态内存是连续的，因为是在程序开始时就生成了，而实例方法申请的是离散的空间，所以当然没有静态方法快
    - 静态方法始终调用同一块内存，其缺点就是不能自动进行销毁，而实例化可以销毁
    - 但...真到了这个层级，那么考虑：swoole 不是更好吗？
23. 如果在代码中存在大量耗时的函数，可以考虑用 C 扩展的方式实现它们。
24. 及时销毁变量，**数组、对象、GLOBAL变量**在 PHP 中特别占内存，这主要是由 Zend 引擎引起的，一般 PHP 数组的内存利用率只有 10%，即：C 语言里 100M 内存的数组到 PHP 中大约需要 1G
25. 获取脚本执行时间，使用 `$_SERVER['REQUEST_TIME']` 优于 `time()`
26. 局部变量比全局变量快，由于**局部变量是存在栈中**的，当一个函数占用的栈空间不是很大的时候，这部分内存很有可能全部命中cache，CPU访问的效率是很高的；相反，如果一个函数同时使用全局变量和局部变量，当这两段地址相差较大时，`cpu cache` 需要来回切换，效率会下降。
27. 提前声明局部变量，当使用一个没有提前声明初始化的变量时，PHP 解释器会自动创建一个变量，但依靠这个特性来编程并不是一个好主意。
28. 谨慎声明全局变量：声明一个未被任何一个函数使用过的全局变量，也会使性能降低，PHP 可能去检查这个全局变量是否存在。
29. 不要随便复制变量：有时候为了使 PHP 代码更加整洁，一些 PHPer 会把预定义好的变量，复制到一个名字更简短的变量中，这样做会增加了一倍的内存消耗，只会使程序更加慢。PS：`$description = $_POST['description'];echo $description` 其实可以直接 `echo $_POST['description'];`。
30. 【有待商榷】循环内部不要声明变量，尤其是大变量（所有语言都需要注意）。
    ```php
    // 方法 A：
    Widget w;
    for (int i = 0; i < n; ++i) {
        w = 取决于 i 的某个值；
    }
    
    // 方法 B：
    for (int i = 0; i < n; ++i) {
        Widget w(取决于 i 的某个值);
    }
    ```
    - 循环内部不要声明变量的主要原因是避免重复分配内存，导致效率缓慢，目前大部分编译器都会自动处理好这一点
    - 循环内部声明变量，遵循就近声明变量的原则，即：A高效，B清晰，工程协作中清晰是关键
31. 关于类中的变量
    - 类方法里建立局部变量速度最快，几乎和在方法里调用局部变量一样快
    - 建立一个对象属性（类里面的变量，例如：`$this->prop++`）比局部变量要慢 3 倍
    - 建立一个未声明的局部变量，要比建立一个已经定义过的局部变量慢 9-10 倍
32. 使用 `++i` 递增比 `$i++` 快
    - 后置递增实际上会产生一个临时变量，这个临时变量随后被递增，而前置递增直接在原值上递增
    - `++$i` 更快是因为它只需要3条指令(opcodes)，`$i++` 则需要4条指令
    - 这种差异是PHP特有的，并不适用于其他语言。
33. 如果一个函数既能接受数组，又能接受简单字符做为参数，那么尽量用字符作为参数
34. 【弃用】数组元素加引号，PS：`$row['id']` 比 `$row[id]` 速度快7倍
35. 多维数组尽量不要循环嵌套赋值
36. 尽量用 `foreach` 代替 `while` 和 `for` 循环，效率更高
37. 在`php.ini`中开启`gzip`压缩
    - 几乎所有的浏览器都支持`Gzip`的压缩方式，`gzip` 可以降低 `80%` 的 I/O 带宽输出付出的代价是增加 `10%` 的 CPU 计算量
    - `zlib` 扩展需要编译时 `--with-zlib=[DIR]` 进行安装，目前 PHP 是不自动开启的
    ```ini
    zlib.output_compression = On;
    zlib.output_compression_level = 6; # 支持 1-9 的配置 
    ```
38. `Apache/Nginx` 解析一个`PHP`脚本的时间，要比解析一个静态`HTML`页面慢 2-10 倍，所以尽量使页面静态化，或使用静态 `HTML` 页面
39. 将`PHP`升级到最新版，从而获取官方的最新优化
40. 多利用 `PHP` 扩展、可用库、PHP缓存（如：APC-Alternative PHP Cache，可选PHP缓存；OPCode-操作码缓存技术）
41. 使用`NoSQL`缓存，如：`Memchached` 或者 `Redis` 这些高性能的分布式内存对象缓存系统，能提高动态网络应用程序性能，减轻数据库的负担。


### √ PHP 的一些坑

- [十个你需要在 PHP 7 中避免的坑](https://learnku.com/laravel/t/9334/ten-pits-that-you-need-to-avoid-in-php-7)

1. 不要使用 `mysql_` 类函数，自 `PHP 5.5.0` 起已废弃，并在自 `PHP 7.0.0` 被移除。可以使用功能更强的 `mysqli_` 类或更加灵活的 `PDO - PHP Data Object` 类（提供数据访问抽象层，即：不管使用哪种数据库，都可以用相同的函数来操作数据）。[PDO Win - PDO vs. MySQLi: The Battle of PHP Database APIs](https://websitebeaver.com/php-pdo-vs-mysqli)
2. 不要写无用的代码，应该确保按需加载脚本，可能时再组合，编写高效的数据库查询语句，如果可能的话使用缓存。【[初学者加速优化指南](https://kinsta.com/learn/page-speed/)、[使用缓存](https://kinsta.com/blog/wordpress-cache/)】
3. 不要在文件末尾使用 PHP 闭合标签
4. 如非必须不要引用传参，多数情况下它会使得代码难以理解，难以预测结果【[Do not use PHP references](http://schlueters.de/blog/archives/125-Do-not-use-PHP-references.html)】
5. 不要在循环里使用查询，可以通过分成两个查询来构造一个数组的方式解决，然后循环数组而非循环查询。
6. 不要在 SQL 查询中使用 `*` ： 明确指定你需要的字段，并且只检索这些字段，有助于节省内存，保护数组
7. 不要信任用户的输入：把用户输入当作心肠歹毒的傻白甜行为
8. 不要自作聪明：你的目标是写出能清晰的表达你的意愿的优雅代码，可能你通过缩短变量名，使用多层级三目逻辑运算和其他小聪明让每个页面节约了 0.01 秒的加载时间，但是和因此种下你和你的团队头疼不已难以维护的恶果相比，得不偿失。
9. 不要重复造轮子：PHP 已经存在很长时间了，无论你做过啥，前人肯定已经做过，多使用开源。
10. 不要忽视其他语言，多增加自己知识的广度。

- [那些年，我们踩过的PHP的](https://zhuanlan.zhihu.com/p/28490854)
- [PHP: a fractal of bad design](https://eev.ee/blog/2012/04/09/php-a-fractal-of-bad-design/)

这是两篇很有意思的文章，值得看看并动手试试，一些问题在 PHP8 中已经被解决，但 PHP7 目前还存在的，给记录一下！

1. PHP 是弱类型语言，`==` 是只比较值不比较类型，`===` 是全等比较需要值、类型都一样才为 true，但这个坑可能不止如此...且 `PHP 7.4.24` 版本仍然存在。

```php
function translate($keyword)
{
    $trMap = [ 
        'baidu' => '百度',
        'sougou' => '搜狗',
        '360' => '360',
        'google' => '谷歌'
    ];  
    foreach ($trMap as $key => $value) {
        if (strpos($keyword, $key) !== false) {
            return $value;
        }
    }   
    return '其他';
}

echo translate("baidu") . "\n";
echo translate("360") . "\n";
```

正常情况应该：

```txt
百度
360
```

但结果却是：

```
百度
其他
```

这是因为 PHP 将你的索引数组下标 `"360"` 处理为了 `360` ，如下图：

```php
array:4 [▼
  "baidu" => "百度"
  "sougou" => "搜狗"
  360 => "360"
  "google" => "谷歌"
]
```

且 [`strpos(string $haystack, string $needle, int $offset = 0): int|false`](https://www.php.net/manual/zh/function.strpos) 函数对 `$needle` 做了如下处理：

> Prior to PHP 8.0.0, if needle is not a string, it is converted to an integer and applied as the ordinal value of a character. This behavior is deprecated as of PHP 7.3.0, and relying on it is highly discouraged. Depending on the intended behavior, the needle should either be explicitly cast to string, or an explicit call to chr() should be performed.
>
> 在 PHP 8.0.0 之前，如果 needle 不是字符串，会被转换为整数并作为字符的序数值应用。从 PHP 7.3.0 开始，这种行为已被弃用，我们不鼓励依赖这种行为。根据预期的行为，应该明确地将 needle 转换成字符串，或者明确地调用 chr()。

修改很简单：

```php
strpos($keyword, $key) //改为 strpos($keyword, (string) $key)
```

如作者所言，其可怕之处在于：

1. **自以为用了===就安全了，忽视了弱类型无处不在这个隐患**
2. 你可能并没有仔细看每一个函数的说明，没有逐个核对每个参数的类型
3. **引发的`bug`不一定能重现，也有可能平时不会触发，但是留下了安全漏洞**

如果想要 100% 避免弱类型的坑？只能换强类型语言，毕竟这个是语言设计层面的缺陷。
如果不能换呢？通过以下准则，虽然做不到100%避免，但是做到99.99%是有希望的。

1. 能用 `===/!==` 的地方，绝不用 `==/!=`，知道类型的情况下，先强转再用 `===` 比较
2. 调用函数的时候，如果你知道参数类型，在调用时强制转换一下，不能嫌麻烦.

虽然 PHP 是动态、弱类型语言，但在书写代码的时候，尽量在成本不大的情况按照静态、强类型的方式来书写，这样能让你的 PHP 脚本更加健壮。譬如：获取数组中的元素前用 `isset` 判断，或先用 `empty` 判空等小细节！！！

2. PHP 中的 `jsson_encode` 函数不区分 `map-{}` 、`list-[]`
3. 健忘的 `FPM`

`Fast Common Gateway Interface／FastCGI`（中文：快速通用网关接口）是一种让**交互程序与 Web 服务器通信**的协议.

`PHP-FPM` 是 `PHP-CGI` 经常管理器的非官方实现（`PHP-CGI` 是 `FastCGI` 协议的 PHP 实现），但它很优秀，成功的替代了官方扩展的位置。使用 `FPM` 的缺点很明显，每个请求结束的时候，你在PHP代码里创建的对象都被清理了，你执行过的代码，就跟没执行过一样，不留痕迹。

即：进程不能常驻，因此数据不能常驻！所以每一次的请求都需要执行重复的业务流程数据。如：框架从`init`开始，到读取配置文件，到初始化各个组件，这种工作在每个请求到来的时候，都要重复的做一次，如果你需要读一个 100M 的元数据，那么每个HTTP请求来时，你都要读一次并解析一次，当你HTTP请求结束返回时，你解析过的100M元数据，又被销毁了，下一个请求来时，你依然要重复做。

**本来PHP 5.6已经可以吊打Python 3.6的性能了，PHP 7.1都不屑于跟Python比性能了，快几倍了。但是一旦引入同体量的框架，比如PHP用Laravel，Python用Django，剧情就反转了，Django竟然可以吊打PHP7加持的Laravel了。**

有兴趣的你可以去 [Techempower](https://www.techempower.com/benchmarks/#section=data-r21) 上看看性能压测排名，你会发现 PHP 的性能其实...并不差，甚至可以进入第一梯队。但比较受欢迎的 `Laravel` 框架性能就很拉跨： [Laravel Benchmark 图片#2022-12-23](https://www.lucinda-framework.com/benchmarks). 

![Laravel Benchmark](https://minsonlee.github.io/images/pig/benchmark-for-laravel.png)

我想 Laravel 受欢迎的原因可能是作者将 `Spring` 那一套搬了过来，使得 PHP 可以通过 Laravel 进行工程构建。Spring 的性能也比较差，但...想把 Java 写的很烂其实是比较难的，但想把 PHP 写的很烂其实很简单。

要解决这个问题，那么可以使用 `Swoole`.

4. PHP 本身是有多线程扩展（[pthreads -仅 PHP7.2 ](https://www.php.net/manual/zh/intro.pthreads.php)）支持的，但目前已经停止维护，官方建议使用：[parallel](https://www.php.net/manual/zh/book.parallel.php)。
5. 在 32 位平台下，没有 8 字节的 `long` 类型。`int` 类型与平台相关，32 位平台下是 4 字节，64 位平台下是 8 字节，在代码的健壮性和可移植性有一定的缺陷。
6. 数组函数设计的太差，使用不便，提供了一大堆`array_xxxx`函数，却没有把这些函数作为数组类自身的方法。这一点，作者不提...其实我倒是没什么感觉，不过一对比 Java 的 Lambda 语法糖，又确实 `Lambda` 更方便。
7. PHP 官方函数命名风格太过不一致，有的用简写有的又是一长串。如何命名看来大佬们也有同样的困惑...


- [那些踩过的 PHP 坑之 Array_merge 函数](https://thinkerou.com/post/php-array-merge/)

额...感觉是作者自己没看函数的说明文档导致，并不算是一个坑，简单记录！但 PHP 的数组确实是有坑...

1. PHP 弱类型导致若使用字符串的数字作为数组索引下标会自动被转换为数字.

`array('3' => 3, '2'=>2, '5'=>5)` 打印出来会发现变为了 `array(3 => 3, 2 => 2, 5 => 5)`

2. [`array_merge(array ...$arrays): array`](https://www.php.net/manual/zh/function.array-merge) 用于合并**一个**或多个数组，即：一个数组中的值附加在前一个数组的后面。

> 如果输入的数组中有相同的字符串键名，则该键名后面的值将覆盖前一个值。然而，如果数组包含数字键名，后面的值将 不会 覆盖原来的值，而是附加到后面。
>
> 如果输入的数组存在以数字作为索引的内容，则这项内容的键名会以**连续**方式**重新索引**。

3. 可以用 `+` 运算符对两个数组进行追加操作，该操作会保留数组的原始下标，如果索引下标有冲突则保留第一个出现的索引下标的值。在索引冲突时，保留规则和 `array_merge()` 相反。

- [PHP中那些你不知道的坑，PHP的坑，PHP漏洞](https://cloud.tencent.com/developer/article/1909960)

1. 函数返回参数之坑【这一点确实如此，深感赞同】

**函数返回的数据类型应该都是固定的**，但是 `PHP` 中部分函数传递不同参数会返回不同的数值类型。如 `json_decode($jsonStr, true|false)` 会返回 `Array|Object|Null` 三种情况

2. `json` 函数之坑，存在 hash 碰撞：[PHP数组的Hash冲突实例](https://www.laruence.com/2011/12/30/2435.html)
3. PHP 数组底层都是 `Hash Table` 实现，更多高级的数据结构需要使用：[SPL Data Struct](https://www.php.net/manual/zh/spl.datastructures.php) 或更加优秀的 [Data Structures ](https://www.php.net/manual/zh/intro.ds.php) 扩展

- [PHP 引用是个坑，请慎用](https://zhuanlan.zhihu.com/p/35107602)

PHP 的引用就是同一个变量的别名，想要正确的使用它们可能很难。详细可以阅读：[PHP 的垃圾回收机制](https://www.php.net/manual/zh/features.gc.php)。


### 聊聊 PHP ob_start() 在开发中的应用

https://github.red/php-ob_start/

### PHP 垃圾回收机制

- [PHP 的垃圾回收机制](https://www.php.net/manual/zh/features.gc.php)
- [PHP中Session函数底层原理以及session的垃圾回收机制 ](https://blog.51cto.com/u_15293910/3062068)
- [深入理解PHP内存管理之谁动了我的内存](https://www.laruence.com/2011/03/04/1894.html)
- [PHP Manul:unset](https://www.php.net/manual/zh/function.unset)
- [记一次PHP与自动释放池的内存释放的坑](https://www.jianshu.com/p/38231c5ac73d)
- [从foreach方法引出的PHP内存分析](https://www.fanhaobai.com/2017/07/array-reference.html)
- [深入理解 PHP7 unset 真的会释放内存吗？](https://www.infoq.cn/article/oneb0vzum5uthfffjcic)
- [php大数组循环嵌套的性能优化](https://blog.csdn.net/LJFPHP/article/details/90346134)

### PHP 数组内存占用分析

- [PHP数组内存利用率低和弱类型的示例分析](https://www.yisu.com/zixun/342090.html)
- [一个PHP数组能占多大内存](https://www.cnblogs.com/sailrancho/p/3892291.html)
- [PHP数组实际占用内存大小的分析](https://cloud.tencent.com/developer/article/1804334)
- [How big are PHP arrays (and values) really? (Hint: BIG!)](https://www.npopov.com/2011/12/12/How-big-are-PHP-arrays-really-Hint-BIG.html)
- [PHP 7 performance improvements (1/5): Packed arrays](https://blog.blackfire.io/php-7-performance-improvements-packed-arrays.html)



- [GeoIP2-php](https://github.com/maxmind/GeoIP2-php)
- [PHP实现通过geoip获取IP地理信息](https://juejin.cn/post/6844903872410943501)
- https://github.com/Torann/laravel-geoip
- https://github.com/maxmind/MaxMind-DB-Reader-php
- https://learnku.com/laravel/t/2530/the-highest-amount-of-downloads-of-the-100-laravel-extensions-recommended
- https://learnku.com/articles/5099/why-dont-i-want-to-use-laravel
- [Laravel 框架深入核心系列教程](https://laravelacademy.org/post/9781)
- [PHP内核探索：一次请求生命周期 - PHP的启动与关闭](https://blog.51cto.com/u_13400164/5655570)
- [PHP-CGI 进程 CPU 100% 与 file_get_contents 函数的关系](https://mp.weixin.qq.com/s/JGL8IHOtrWIoQPWaJJ8ORQ)
- [收藏了8年的PHP优秀资源，都给你整理好了](https://segmentfault.com/a/1190000018071558?utm_source=weekly&utm_medium=email&utm_campaign=email_weekly)
- [【缓存穿透】redis缓存穿透及解决方案](https://blog.51cto.com/u_15127689/4689065?articleABtest=0#%E7%BC%93%E5%AD%98%E5%B9%B6%E5%8F%91)


### √ PHP 内存溢出小记

内部系统有个接口需要聚合搜索数据提供给外部调用，内部会生成一个巨大的数组并对其进行操作，需要查询大量的供应商数据、货币信息转换、可用优惠券等信息，然后再进行计价逻辑。

接口经常会在计价的时候报错 `Allowed memory size of x bytes exhausted (tried to allocate y bytes)`，也已经通过 `ini_set('memory_limit','512M');` 将程序内存限制临时修改为 `512M` 但也没减缓很多这个情况。

感觉业务流程上是需要有一定的小优化，但是更多应该是代码上要做优化，还没细致看过代码，查阅了一下资料，先小计一下。

#### 为什么 PHP 数组会很占内存？

1、 **底层采用 Hash Table 来实现**

采用是哈希表（hash table，也称为关联数组 associative array）。哈希表是一种通过哈希函数将键映射到索引的数据结构，具有快速的查找和插入操作，但由于需要较为有效的**避免哈希冲突**，因此需要占用大量的内存。

哈希表的内存消耗与数组的大小和负载因子有关。[负载因子](https://blog.csdn.net/Jormungand_V/article/details/119972763)是指哈希表中已存储元素数量与哈希表大小的比值，通常取值在 0.7-0.8 左右。

当哈希表负载因子较高时，会导致哈希冲突的概率增加，哈希表需要进行更多的操作来解决冲突，从而导致性能下降和内存占用增加。

2、**PHP 数组有额外开销**

PHP 数组是已 “Key => Value” 的键值对方式进行存储的，而且 `key/value` 支持各种类型的键和值，包括字符串、整数、对象等。这种存储方式**需要额外的内存来存储键和值之间的映射关系**，所以可能会占用更多的内存

除了上面提到的还有一些额外的内存开销，例如：**存储数组长度、标记数组是否为引用**等。

3、**动态分配内存**

`PHP` 数组是可变长度的，采用**动态分配内存**的方式来处理实现。即：在运行时它可以根据需要自动增加或减少内存。这个特性可以让数组的使用更加方便，但也会导致一些内存的浪费。

`PHP` 数组生命周期简单步骤如下：

1. 初始化数组：创建一个新数组时，`PHP` 会为该数组分配一些初始内存，用于保存数组的头部信息（如数组的长度、哈希表的大小等）。
2. 添加元素：向数组中添加一个新元素时，`PHP` 会根据元素的类型和值，计算出该元素所需的内存大小，并在内存池中分配这些内存。如果数组的长度超过了预分配的内存（譬如：预先分配了 16 的长度，负载因子为 0.7，当长度达到 16*0.7 约 12 ），则会动态扩展数组的内存空间，以容纳更多的元素。
3. 内存管理：`PHP` 采用了一种称为 `refcount` 的内存管理机制来管理内存的分配和释放。即：每个变量都有一个引用计数器，当变量的引用计数为 `0` 时，`PHP` 会自动回收该变量占用的内存。
4. 释放内存：当一个数组变量不再使用时，`PHP` 会通过 `refcount` 机制自动减少该变量的引用计数器，并在计数器为 0 时，释放该变量占用的内存。在释放内存时，PHP 会尝试将内存返回给内存池，以便后续的分配请求使用。

`PHP` 数组的内存分配和释放过程（`refcount` 机制）是由 `PHP` 的内存管理系统自动处理的，开发者无需显式地管理内存。这是一个相对不是很高效但比较简单的 `GC` 处理机制。

在 `PHP` 中，当一个数组**需要扩容**时，它会**申请一块新的连续内存空间**，然后将原有数组中的元素**复制**到新的内存空间中。在复制元素的过程中，`PHP` 会使用一种称为 **"拷贝-写入" 的技术**，即在新的内存空间中为元素分配新的内存，然后将**原有数组中元素的指针指向新的内存空间**，这样就避免了对原有内存空间的修改，从而保证了数组元素的**连续存储结构**，扩容的数组还要建立**重建索引**的操作，这也是一个耗费内存的操作。

不过并没有在源码中找到：扩容后对原数组进行空间释放的代码。我猜想可能依然是遵循原有逻辑，当原数组的引用计数器为 0 后，由 `PHP` 自身进行 `GC` 操作。

`PHP` 新增元素的时候并非都是扩容的，而是使用 **"渐进式"扩容策略**，即在数组长度达到一定**阈值**时才进行扩容，以**避免在数组长度较小时频繁地进行内存分配和复制操作，从而降低了内存分配和复制的开销**。

- [PHP 数组底层实现](https://www.0php.net/posts/PHP-%E6%95%B0%E7%BB%84%E5%BA%95%E5%B1%82%E5%AE%9E%E7%8E%B0.html)

4、**PHP 数组操作导致的内存占用升高**

`PHP` 之所以被称为 “写业务最快的后端语言”，与其提供了丰富的内置函数或内置类有一定的关系。`PHP` 也提供了丰富的数组操作函数和语法，但这些丰富的操作背后带给程序员的是对底层的屏蔽，让我们的程序经常会陷入内存消耗而不自知。

- 数组操作的开销：如 `array_push`、`array_pop`、`array_merge` 等，这些操作可能会导致内存的**频繁分配和释放**，从而增加内存的消耗。
- 数组拷贝的开销：在 PHP 中，**数组通常是按值传递的（即：当数组作为参数传递给函数或赋值给其他变量时，会发生数组的拷贝）**。这种按值传递所带来的拷贝操作会占用额外的内存，尤其是当数组较大时，拷贝的开销会更加显著。
- 内存碎片的问题：由于 PHP 数组的动态分配方式，当数组增长或缩小时，可能会**产生内存碎片**，而内存碎片会使得内存的分配效率降低，从而增加内存的消耗。

> 内存碎片是由于删除元素后，内存中存在一些小块空闲区域，但它们的大小又不足以满足新的内存分配请求，从而导致内存浪费。

为了减少 `PHP` 数组的内存消耗，应该**尽可能避免频繁的数组操作和拷贝，使用适当的数据结构来代替数组，或者使用其他编程语言来处理大规模数据。同时，应该注意内存管理的问题，避免产生内存碎片和其他内存泄漏问题**。

- [PHP SPL 数据结构](https://www.php.net/manual/zh/spl.datastructures.php)：`SPL` 数据结构（标准的数据结构）的类 与 `PHP` 自带的数组数据类型（实际是有序列表）在底层实现上有很大的不同，更加严格也更加高效，能一定程度上减少 PHP 数组的扩容、内存碎片问题
- 使用 `Memcached/Redis` 等缓存中间件，它们拥有更丰富的数据结构以及存在与之对应的高效的处理方法
- 使用 `unset()` 或者将变量赋值为 `null` 可以手动触发垃圾回收，从而释放一些不再使用的内存块，但 GC 问题并不能有效的避免内存碎片的问题。


#### 循环结构中如何释放数组对内存的占用？

```php
foreach ($large_array as $key => $value) {
    // 处理 $value
    unset($large_array[$key]);
}
$large_array = null; // 将变量设置为 null，确保释放内存
```

1. 在 PHP 中使用引用变量（&$value）并不能减少内存使用，因为引用变量本身会占用额外的内存，相反，这会导致更多的内存使用。
2. 如果使用了 `($large_array as $key => &$value)` 引用变量，我们在循环最后使用 `unset($value)` 来释放当前元素占用的内存是正确的，但数组本身是没有受影响的，因此是没有起到释放数组本身的作用


```php
foreach ($large_array as $key => &$value) {
    // 处理 $value，操作修改值
    unset($large_array[$key]);
}
// print_r($large_array); // 数组的元素有被改变，但却没有被释放变为 null
$large_array = null; // 将变量设置为 null，确保释放内存
```

1、为什么操作引用变量 `$value` 可以改变数组的值？

在 `PHP` 中，使用引用遍历数组时，`$value` 变量实际上是一个指向原数组元素的引用（即：`$value` 和原数组中对应的元素实际上是同一个内存空间）。因此，当你通过 `$value` 来修改数组元素时，实际上是在修改原数组中的对应元素，这也是为什么你操作 `$value` 赋值可以改变原数组的值。

2、为什么 `unset($value)` 销毁引用变量却不能释放内存？

而对于 `unset($value)`，它实际上是对 $value 变量进行了 unset 操作，而不是对原数组中对应的元素进行 unset 操作。这个操作会使得 $value 变量指向 null，从而导致 $value 变量的引用计数减少，原数组元素的引用计数不会受到影响，因此 unset($value) 不会对原数组元素本身造成影响。

#### 使用迭代器减少内存占用

```php
function array_generator($large_array) {
    foreach ($large_array as $value) {
        yield $value;
    }
}

foreach (array_generator($large_array) as $value) {
    // 处理 $value
}
```

使用生成器可以减少内存占用，因为它只在需要数据时才会从生成器中获取它，而不是一次性将整个数组加载到内存中。

### 利用 `static` 实现 PHP 静态调用绑定（late static binding）

将方法调用连接到方法体称为方法绑定。有两种类型的绑定：

- 前期绑定：对象类型在编译时候确定（如 Java 中的静态绑定、PHP 中的 `self::` 调用绑定）
- 后期绑定：对象的类型在运行时确定（如 Java 中的动态绑定、PHP 中的静态绑定）

`self`、`parent`、`static`、`this` 关键字

- `self` 指代当前代码所在类自身，不会因为任何继承关系而发生变更
- `parent` 指代当前代码所在类的父类自身，也不会因为多次继承而发生变更
- `static` 指当前调用运行的类，只在实际运行的第一次进行赋值（可以通过 `get_called_class()` 获取调用类名字）
- `this` 指当前对象

`PHP` 静态调用绑定 + OOP 的继承 常用于 Active Record(活动记录)设计模式 的实现。

```php
<?php

class Model 
{
    public static funtion create(array $attributes = []) 
    {
        $model = new static($attibutes);
        $model->save();
        
        return $model;
    }
}

class Task extends Model 
{
}


Task::create([
    'title' => 'Task',
    'author' => 'limingshuang'
]);
```

调用 `Task::create` 的时候，因为 `class Task extends Model` 所以调用的是 `Model` 里的 `create` 方法，由于 `$model = new static($attibutes);` 使用了 `static` 关键字，所以实例化对象的时候实际等同于 `$model = new Task($attibutes);` 又将结果或过程作用回了自己身上。

#### 为什么随着公司规模大了之后，越来越多公司丢弃 PHP 而选择 Java 呢？

##### PHP 语言本身的性能差？

很多人对 PHP 的印象就是：开发快、语法简单灵活，便于快速试错和迭代而。对于从语言 **性能** 角度来说好像都比较少和 PHP 本身相关，可能相关的就是 `Swoole for PHP` 吧。

很多人会拿一些 benchmark 来说事，但是...`benchmark` 本身写的好不好其实也影响测评结果。例如你测一段数组的代码，Java 的数组消耗和速度那么应该是要比 PHP Array 数组好些的，但是如果你的 PHP Benchmark 用的是 `SPLFixedArray`- PHP固定长度数组 来实现的，那么到底谁好谁坏可能还真不一定... 

而且随着今年来 PHP8 的推出，其性能更是直线上飚。虽然可惜的是很多时候人的偏见一旦形成就很难扭转，但相比整个项目迁移换语言，那么将你的 PHP5/PHP7 程序迁移到 PHP8 可能会更加方便吧。

所以如果单纯的从语言性能来考虑将 PHP 换为 Java、Go ... 我觉得绝大部分的公司应该都没有到这个量级。

##### PHP 很容易写烂代码？

代码写的烂是和人有很大关系，如果一个程序员稍微懂些代码但代码素质本身就差...确实用 PHP 写的代码可以比 Java 写的要烂，因为 PHP 灵活，这个既是它的优点也是容易造成是它缺点的地方。

而一个稍微懂些代码但代码素质本身就差的 Java 程序员写出来的 Java 程序，其实也不会好到哪里去（我司就有这样的案例，你会发现...能复制的还是在复制，没有抽离/封装）。

只要框架搭好，懂得照猫画虎...那么写出来的代码基本也就那样，具体的好坏还是和人有关，与语言毫无关系。

因此要说因为「烂代码」的原因换语言...可能换人更加合适。

##### PHP 换 Java 的原因可能是啥？

语言的生态、招人。

公司最开始想的是将项目转去 `Go`，因为 `Go` 语言好像也很多，但是用 `Go` 来做 `Web` 开发的话...好像还没什么特别好的框架选择而且要招人也没怎么招到满意的。当时公司就「搜索、解析搜索报文」功能分别用 Go/Java 来写了 Demo，和 PHP 对比后发现... Java 和 Go 并没有相差很多。

但随着公司规模越来越大，项目越来越复杂，我们就需要面临「并发编程支持-线程、协程的支持」、「大数据处理」、「微服务」、「各类中间件」、「项目工程化-代码组织、构建、测试、部署、监控...」相比之下，Java 在这方便的生态比新生的 Go 要成熟很多。虽然上面的这些技术（大部分都是用 Java 做的）也会提供对应的 PHP SDK，但是较于转一层之后给 PHP 使用 和 直接用 Java 对接，那无疑后者更好一些。

也有很多人说，那么为啥不换 `Swoole` 呢？因为懂 `Swoole` 并用好它的 PHP 程序员凤毛麟角，可能不同城市的 PHPer 素养不一样，但是在广州我司的招聘过程来说确实就是如此...而且 `Swoole` 走商业化之后对于免费开源的支持也少了一些，回复和处理 `Merge Request` 的速度也慢了很多。

考虑到继续耗着等大家学习 `Swoole` 然后再继续代码革命，那么换一个更加成熟的语言貌似又是一个比较好的选择。

也有杠精可能会反驳到：为什么不去改变 PHP 生态呢？？那么...你见过有多少这样的伟人？你为 PHP 生态做了什么呢？大家都 TM 求生存的时候你来跟我扯情怀...老板愿意拿着公司业务时间来一起陪你试试就逝世吗？

至于...招人，多得现在各大培训机构的长期支持，加上本身 Java 已经在这个行业沉淀了许久，现在 Java 应该是最好招人的一门语言。


### 依赖注入（Dependency Injection）

- 方法依赖（memethod injection）
- 构造方法依赖注入（constructor injection）


## PHP 数据结构与算法

- https://www.zyblog.com.cn/t/%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84
- PHP 算法：https://github.com/TheAlgorithms/PHP
- PHP 算法：https://github.com/m9rco/algorithm-php


## PHP 网络编程

- https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzU4MjgzNzk5MA==&action=getalbum&album_id=1555216066405023744&scene=173&from_msgid=2247484679&from_itemidx=1&count=3&nolastread=1&devicetype=iOS16.1&version=18001f37&lang=zh_CN&nettype=WIFI&ascene=78&fontScale=94
- https://docs.guzzlephp.org/en/stable/
- https://www.chengxiaobai.com/php/guzzle-source-code-analysis

## PHP 框架

- [Propel2: A fast ORM for modern PHP](https://github.com/propelorm/Propel2) 扫描了一下感觉有点像 MyBatis，但是目前 Laravel 中使用的 [`Eloquent ORM`](https://github.com/illuminate/database) 在 GitHub 的 Star 上相差较大。

### Laravel

- [源码阅读分析-PHP-laravel](https://juejin.cn/post/7077608857505103902)
- [[踩了个坑] Laravel 访问https网址，url('/')竟然只返回 http？](https://learnku.com/articles/67283)
- [Lararvel](https://www.zyblog.com.cn/t/Laravel)
- https://laravelacademy.org/books/laravel-docs-10
- https://laravel.com/docs/10.x
- https://learnku.com/docs/laravel/9.x
- [深入浅出 Laravel Macroable](https://learnku.com/articles/35970)


### Swoole

#### PHP 与 Swoole 是什么关系？

`Swoole` 是 `PHP` 的一个扩展，基于


- https://www.zyblog.com.cn/t/Swoole
- https://learnku.com/articles/73933
- [Swoole项目思维转换](https://developer.aliyun.com/article/44248)
- [PHP-FPM vs Swoole](https://learnku.com/articles/9450/php-fpm-vs-swoole)
- https://learnku.com/articles/75483

### PHP 实现 OAuth2.0 服务

- https://cloud.tencent.com/developer/article/1335787
- https://blog.csdn.net/zjwlgr/article/details/122622923
- https://github.com/thephpleague/oauth2-server
- https://github.com/thephpleague/oauth2-client

### √ 开源框架/组件推荐

PHP 社区中有很多优秀的开源框架和库，以下是一些代码量比较小但是又比较优秀、值得深入学习源码的框架或开源库：

[Slim：Slim](https://github.com/slimphp/Slim) 是一个简单、轻量级的 PHP 微型框架，它可以用来构建 RESTful API 或者简单的 Web 应用程序。Slim 的核心代码量很小，但是它提供了很多有用的功能，如路由、中间件、错误处理、请求和响应处理等
- `src/Application.php`: 这个文件包含了 Slim 应用程序的主要实现逻辑，例如路由解析和中间件栈
- `src/Routing/Route.php`: 这个文件包含了路由的主要实现逻辑，包括路由的解析和匹配，以及路由的处理器和中间件栈
- `src/Handlers/Strategies/RequestResponse.php`: 这个文件包含了处理请求和响应的策略接口和默认实现
- `src/Middleware.php`: 这个文件包含了中间件的主要实现逻辑，包括中间件的堆栈和调用
- `src/Http/Request.php`: 这个文件包含了 HTTP 请求的主要实现逻辑，包括解析请求头和解析请求体
- `src/Http/Response.php`: 这个文件包含了 HTTP 响应的主要实现逻辑，包括设置响应头和响应内容

[Guzzle：Guzzle](https://github.com/guzzle/guzzle) 是一个强大的 PHP HTTP 客户端，它可以用来发送 HTTP 请求和处理 HTTP 响应。Guzzle 的代码量虽然不算小，但是它的设计非常优秀，结构清晰，使用方便，是学习 PHP 网络编程的好选择。
- `src/Client.php`：这个文件包含了 Guzzle 的主要 API 和实现逻辑
- `src/HandlerStack.php`：这个文件包含了 Guzzle 的请求和响应处理器的主要实现逻辑
- `src/MessageTrait.php`：这个文件包含了请求和响应消息的主要实现逻辑


[Monolog：Monolog](https://github.com/Seldaek/monolog) 是一个流行的 PHP 日志库，它可以用来记录应用程序的日志信息。Monolog 的代码量不大，但是它提供了丰富的日志处理方式，如文件日志、数据库日志、邮件日志等。
- `src/Monolog/Logger.php`：这个文件包含了 Monolog 的主要 API 和实现逻辑
- `src/Monolog/Handler/StreamHandler.php`：这个文件包含了将日志写入文件的处理器的主要实现逻辑
- `src/Monolog/Formatter/LineFormatter.php`：这个文件包含了日志行格式化器的主要实现逻辑


[Carbon：Carbon](https://github.com/briannesbitt/carbon) 是一个 PHP 的日期和时间处理库，它可以帮助你方便地处理日期和时间相关的操作。Carbon 的代码量不大，但是它的使用非常方便，支持多种日期和时间格式
- `src/Carbon/Carbon.php`: 这个文件包含了 Carbon 的主要 API 和实现逻辑。这个类实现了 PHP 的 DateTime 类，但增加了许多额外的功能和便利性方法
- `src/Carbon/Traits/Creator.php`: 这个文件包含了 Carbon 创建实例的逻辑。这个特质定义了许多静态方法，例如 Carbon::now() 和 Carbon::parse()，这些方法用于创建 Carbon 对象
- `src/Carbon/Traits/Macro.php`: 这个文件包含了 Carbon 的宏定义逻辑。这个特质定义了许多方法，例如 Carbon::macro() 和 Carbon::hasMacro()，这些方法用于在 Carbon 对象上定义新的自定义方法。
- `src/Carbon/Lang/*.php`: 这个目录包含了许多语言翻译文件，用于将 Carbon 对象的日期和时间格式本地化为不同的语言


[PHP-CS-Fixer](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer): PHP-CS-Fixer 是一个用于代码风格修正的库，它符合 `PSR-1` 和 `PSR-12` 标准，可以自动修复您的代码中的风格问题，使其符合 PSR 标准，可以从 `src/Fixer.php` 文件开始阅读，这个文件包含了代码风格修复器的主要逻辑。


[Laminas EventManager](https://github.com/laminas/laminas-eventmanager): Laminas EventManager 是一个用于事件管理的库，它符合 `PSR-14` 标准，只用一个文件 `src/EventManager.php` 包含了整个事件管理器的主要实现逻辑。同时提供了很多常用事件功能，可以增加阅读对应的源代码


[FastRoute](https://github.com/nikic/FastRoute): `FastRoute` 是一个用于路由请求的库，它使用了快速的正则表达式匹配方式。它非常轻量级，直吹的功能比较简单却非常高效，只有一个 PHP 文件，且符合 `PSR-1`、`PSR-2` 和 `PSR-4` 标准，可以从 `src/Dispatcher.php` 文件开始阅读，这个文件包含了整个路由分发的主要逻辑。


[PHP-DI](https://github.com/PHP-DI/PHP-DI): `PHP-DI` 是一个轻量级的依赖注入容器，它符合 `PSR-11` 标准。它的代码库很小，而且它的依赖关系很少，可以从 `src/DI/Container.php` 文件开始阅读，这个文件包含了依赖注入容器的主要实现逻辑。