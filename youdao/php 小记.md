# PHP性能小计
[TOC]

## 1.使用cURL 替代 file_get_contents()
> cURL 和 file_get_contents($url)都可以用以采集获取网页内容

### 功能区别

- cURL是PHP的一个libcurl库，用于与各种服务器使用各种类型协议进行 **`连接和通讯`**

**`cURL`所支持的协议及功能：**
1. `http`、`https`、`ftp`、`gopher`、`telnet`、`dict`、`file`和`ldap`协议;
2. libcurl同时也支持：`HTTPS认证`、`HTTP POST`、`HTTP PUT`、 `HTTP上传`、`FTP 上传`(这个也能通过PHP的FTP扩展完成)、`下载文件断点续传`、`上传文件断点续传`、`代理服务器`、`http代理服务器管道（ proxy tunneling）`、`IPv6， socks5代理服务器`、`cookies操作`、`kerberos认证`和`用户名+密码的认证` 等

- file_get_contents()是PHP的一个内置文件函数，用于 **`将文件读入一个字符串`**
【允许读取URL内容需要php.ini配置】

**`file_get_contents()`所支持的协议：**
```
file:// — 访问本地文件系统
http:// — 访问 HTTP(s) 网址
ftp:// — 访问 FTP(s) URLs
php:// — 访问各个输入/输出流（I/O streams）
zlib:// — 压缩流
data:// — 数据（RFC 2397）
glob:// — 查找匹配的文件路径模式
phar:// — PHP 归档
ssh2:// — Secure Shell 2
rar:// — RAR
ogg:// — 音频流
expect:// — 处理交互式的流
```

### 性能对比

> `cURL`的效率比`file_get_contents()`快30%

1. `fopen`/`file_get_contents` 每次请求都会重新`做DNS查询`，但是 **cURL会自动对DNS信息进行缓存**
2. `fopen/file_get_contents` 在请求HTTP时，使用的是`http_fopen_wrapper`，不会`keeplive`,而c  URL却可以。这样在多次请求多个链接时，cURL效率会好一些,并且cURL可以并发请求
3. `fopen/file_get_contents` 受到`php.ini`文件中`allow_url_open`选项配置的影响，如果该配置关闭了，则该函数也就失效了。而cURL不受该配置的影响
4. `fopen/file_get_contents`一般只能使用get方式获取数据，`cURL`可以模拟多种请求，如：POST,PUT等，用户可以按照自己的需求来定制请求。
5. 使用`fopen/file_get_contents`对URL进行请求,的稳定性比cURL差

### 负载对比
> `file_get_contents()` 是文件处理函数，对内存CPU的开销远大于cURL

1. 使用`file_get_contents('http://xxx.com') `远程操作URL，如果URL响应缓慢，该函数会一直卡死进程【使用`php-cgi(php-fpm)`执行，`max_execution_time`设置无效】

```
// php-cgi(php-fpm)的有效时间设置：php-fpm.conf
// 默认：0 代表永远执行
<value name="request_terminate_timeout">0s</value>  
```

2. 使用`file_get_contents('http://xxx.com') `远程操作URL，可以使用`stream_context_create()`设置超时时间，但使用该方法设置不稳定

```
$ctx = stream_context_create(array(  
   'http' => array(  
       'timeout' => 1 //设置一个超时时间，单位为秒  
       )  
   )  
);  
file_get_contents("http://example.com/", 0, $ctx);  
```



### 参考文献
1. [PHP使用curl替代file_get_contents](https://my.oschina.net/766/blog/210831)
2. [php下curl与file_get_contents性能对比](https://my.oschina.net/766/blog/211357)
3. [php中file_get_contents与curl性能比较分析](http://www.jb51.net/article/57238.htm)
4. [ PHP-CGI 进程 CPU 100% 与 file_get_contents 函数的关系](http://zyan.cc/file_get_contents/)
5. [fsockopen/curl/file_get_contents效率比较](http://www.nowamagic.net/academy/detail/12220248)
6. [PHP抓取网络数据的6种常见方法](http://www.nowamagic.net/academy/detail/12220245)


## PHP 核心特性 - Trait（行为集合）

- PHP 核心特性 - Trait ：https://learnku.com/articles/35908
- PHP 类与对象 ☞ Trait：https://www.php.net/manual/zh/language.oop5.traits.php

在软件开发中，我们通常使用“继承”、“组合”两种方式来提高代码的复用性，而在设计模式中又有一个原则：“多用组合，少用继承”。
PHP 是一个既支持面向过程编程范式，又支持面向对象编程范式的高级编程语言，提供了一种新的特性 `trait` 来作为对“组合”、“多继承”的支持！

- 继承：强调的是“父类与子类”的隶属（`is-a`）关系，但继承的缺点有以下几点：
    - 父类的内部细节对子类是可见的（破坏了封装性）
    - 子类从父类继承的方法在编译时就确定下来了，无法在运行时改变父类继承方法的行为（缺乏灵活性，不支持动态拓展）
    - 父类方法做了修改，子类的方法必须做出相应的调整（缺乏独立性-子类和父类高度耦合）
    - ==！！！继承层次过深、继承关系过于复杂会影响到代码的可读性和可维护性==


- 组合：强调的是“整体与局部”的有无（`has-a`）关系。组合的优/缺点如下：
    - 优点：当前对象只能通过所包含的那个对象去调用其方法，所以所包含的对象的内部细节对当前对象时不可见的
    - 优点：当前对象与包含的对象是一个低耦合关系，如果修改包含对象的类中代码不需要修改当前对象类的代码
    - 优点：当前对象可以在运行时动态的绑定所包含的对象。可以通过set方法给所包含对象赋值
    - 缺点：组合容易产生过多的对象，当维护的对象越来越多时，容易牵一发而动全身
    - 缺点：为了能组合多个对象，必须仔细对接口进行定义

> 组合的思想就是：设计类的时候把要组合的类的对象加入到该类中作为自己的成员变量。

组合、继承并不应该是“非黑即白”的对立场面，组合比继承更具灵活性和稳定性，在设计时应该优先的使用组合。但在以下场景时也应考虑使用继承：
1. 子类是一种特殊的类型(is type of)，而不是父类的一个角色(has some rule)
2. 子类的实例不需要变成另一个类的对象
3. 子类扩展，而不是覆盖或使父类的功能失效

对于“深度继承”的问题，我们一般采用：组合、接口、委托 的方式来解决。
- 组合：解决了继承深度的问题，解耦了父-子类的高度耦合
- 委托：解决了使用组合情况下，代码复用的问题
- 接口：为组合、委托提供了好的实现方式

**Trait 的使用方式**

```php
trait <traitName> {
    function <funName1> {xxx};
    function <funName2> {xxx};
}

class <className> {
    use traitName;
    // 此时 类中 就可以直接使用 trait 的方法
}
```

**Trait 的优先级**

> 可以将 Trait 看作为一个全部方法为 public 的行为组合集合类-当然可以设置 trait 为 private

```php
class father {
    public function A() { echo 'FA'; }
    public function A() { echo 'FB'; }
}

trait traitTest() {
    function A() { echo 'TA';}
    function B() { echo 'TB';}
}

class son {
    use traitTest;
    funciton B() { echo 'SB'; }
}

(new son())->A(); // TA
(new son())->B(); // SB
```

> 优先级：子类 》 trait 》 父类

**Trait 注意事项**

> PSR-12 对于 `Trait` 的使用规范：https://www.php-fig.org/psr/psr-12/#42-using-traits

- 命名规范：Symfony 编码规范建议在每个 Trait 命名应当 `xxxTrait`
- Trait 中可以定义：静态变量、静态方法和静态属性、普通属性、抽象方法
- trait 的访问权限：在 PHP8.0 之前 trait 仅支持 public、protected，8.0 后支持定义 private

> 注意：自PHP8.1起弃用静态方法、静态属性的定义和访问，trait 应当尽量保持是 function 的集合，不耦合过多的属性信息。

- 多个 trait：可以通过逗号分隔，在 use 声明列出多个 trait，可以都插入到一个类中。==【PSR-12 建议多个 use，每个 Trait 一行】==
- trait 嵌套：可以在 trait 中通过 use 来使用其他的 trait
- 冲突的解决：多个多个 trait 都插入一个同名的方法，会产生一个致命错误。可以使用 `insteadof` 操作符来明确指定使用哪一个。

```php
<?php
trait A {
    public function smallTalk() {
        echo 'a';
    }
    public function bigTalk() {
        echo 'A';
    }
}

trait B {
    public function smallTalk() {
        echo 'b';
    }
    public function bigTalk() {
        echo 'B';
    }
}

class Talker {
    use A, B {
        B::smallTalk insteadof A; // 当 smallTalk 冲突时，使用 B::smallTalk()
        A::bigTalk insteadof B; // 当 bigTalk 冲突时，使用 A::bigTalk()
        B::bigTalk as private talk; // 给 B::bigTalk 定义方法别名 talk，指定 talk 方法为Talker类的私有方法
    }
}
```

## 迭代生成器 - `yield` 关键字

1、 迭代 与 递归 的区别？

百度百科对 `迭代` 的解释：

> 迭代是重复反馈过程的活动，其目的通常是为了逼近所需目标或结果。每一次对过程的重复称为一次“迭代”，而每一次迭代得到的结果会作为下一次迭代的初始值。

从计算机科学的角度来说，即：重复执行程序中的**循环**，直到满足某条件为止。

递归，则是计算机科学的一个名词，是指：程序调用**自身**的编程技巧称为递归（ recursion）。其中心思想：将问题拆解为**多个相似的小问题**，不断的下潜解决最简单的问题，然后将结果返回给上层，最终得到最上层的结果。

两者的区别与关系：

- 迭代：不断回到**同一个场景**并优化解决（按顺序访问结构中的每一项）
- 递归：不断下潜至底层并解决
- 任何一个迭代的例子都有它的递归表示法

**递归的优/劣势**：

- 递归具有更好的**可读性**
- **递归容易产生"栈溢出"错误（stack overflow）**
- 效率方面，递归可能存在冗余计算

> - 循环、迭代、递归：https://www.cnblogs.com/MinPage/p/13992040.html
> - 请问编程里迭代和循环有什么区别？https://segmentfault.com/q/1010000000199577/a-1020000000199630

迭代表达：

```php
for($i = 1; $i < 9; $i++) {
    for($j = 1; $j <= $i; $j++) {
        echo $i . ' x ' . $j . ' = ' . ($i*$j) . '\t';
    }
    echo '<br/>';
}
```


递归表达：

```php
function testRecursion($num) {
    if ($num > 9) {
        return;
    }

    for ($i = 1; $i <= $num; $i++) {
        echo $i . ' x ' . $num . ' = ' . ($i*$num);
    }
    echo "<br/>";
    
    $num++;
    testRecursion($num);
}
```


- [yield 与 协程 的区别？](http://static.kancloud.cn/redgo/swoole_doc/891220)

PHP 中使用 `Yield/Generator` 来实现半自动的协程。在实际使用中，开发者需要在涉及协程逻辑的函数调用前增加`yield`关键字。
`Yield/Generator` 代码风格与传统的同步风格代码存在冲突，无法复用已有代码。（开发者显示申明）

Swoole 的协程是全自动化协程，开发者无需添加任何关键字，底层自动实现协程的切换和调度。（开发者无感知）



- yield 是什么？注意点是什么？
- yield 到底怎么用？



- 生成器：https://www.php.net/manual/en/language.generators.syntax.php
- 什么是协程？https://juejin.cn/post/6844903921471717389
- 什么是协程？https://zhuanlan.zhihu.com/p/172471249
- 协程（coroutine）简介：https://yearn.xyz/posts/techs/%E5%8D%8F%E7%A8%8B/
- 【带着问题学】协程到底是什么?https://juejin.cn/post/6973650934664527885
- PHP 使用yield处理大数据：https://juejin.cn/post/6844903902953881614
- PHP5.5或将引入Generators：https://www.laruence.com/2012/08/30/2738.html
- 在PHP中使用协程实现多任务调度：https://www.laruence.com/2015/05/28/3038.html
- PHP异步编程: 手把手教你实现co与Koa ：https://www.bookstack.cn/read/php-co-koa/README.md
- What does yield mean in PHP? https://stackoverflow.com/questions/17483806/what-does-yield-mean-in-php
- PHP yield 协程 生成器用法探究：https://learnku.com/articles/45033
- PHP中的yield与协程
    - https://mp.weixin.qq.com/s/tBTQWfoLK8shyHn4FBVHDw
    - https://mp.weixin.qq.com/s/sRb2WHOQv4j3LJn5aDYh-g
    - https://mp.weixin.qq.com/s/cMZ4CIQDekX7rep6nLNWHg
- 一篇文章讲清楚迭代器和生成器：https://www.cnblogs.com/goldsunshine/p/15590671.html
- 迭代器与生成器的区别：https://www.cnblogs.com/songshutai/p/15668864.html
- https://www.zhihu.com/question/20278387
- swoole 从入门到入土：https://www.cnblogs.com/ddcoder/category/758225.html?page=2


## 如何利用原生的 PHP 实现“异步任务”？

“异步” 即：在执行 A 的过程中，可以开启执行 B 但这个开启不影响 A 任务本身。

“异步任务”的思路：在执行任务 A 时，想办法触发一下B任务然后就退出不等待B，让B任务挂在后台执行。在 B 任务执行完毕再通过回调的方式通知任务 A。

一般情况下，我们都是通过 [Nginx/PHP-FPM](https://www.kancloud.cn/sphynx/swoft/1250021) 方式来开发 web 应用的，这种模式不是常驻内存的，因此：要达到上述思路，需要解决2个问题！

1. 任务不能因为客户端的断开而终止任务的执行

- `ignore_user_abort(true)` 设置客户端断开，仍然执行脚本
- `set_time_limit()` 设置脚本执行不超时，建议不要设置为 `set_time_limit(0)` 而是设置一个具体的值，避免进程僵尸一直挂在后台

2. 任务执行完毕后，要能自动执行对应的回调。

- `register_shutdown_function()` 脚本退出执行时，触发注册的执行函数
- [`call_user_func()`](https://www.php.net/manual/zh/function.call-user-func.php) 函数也可以实现参数回调的方式

如何做到触发任务，立刻断开？

- 通过 [`fsockopen()`](https://www.php.cn/php-weizijiaocheng-445141.html) 模拟生成 HTTP 链接，通过设置 timeout 然后 close 掉链接句柄，配合 `ignore_user_abort()` 即可.

对于任务脚本，可以看看 [laravel artisan 命令调度](https://learnku.com/docs/laravel/9.x/scheduling/12238)

- [风雪之隅:使用fscok实现异步调用PHP](https://www.laruence.com/2008/04/16/98.html)
- [fsockopen](https://www.php.net/manual/zh/function.fsockopen)

## PHP进程管理

- 进程控制扩展：https://www.php.net/manual/zh/refs.fileprocess.process.php
- 如何做到进程间数据通讯？
- 如何做到进程间数据共享？


## PHP 版本升级

当前 `PHP Version:5.6.4`，准备升级到 `PHP7.4.24`。

为什么要升级？升级目标？

1. PHP8 已经出了，PHP7.4 是最新的稳定版，贸然升级到 PHP8 有些激进，但持续停在 PHP5.6 在技术上已经落后
2. 网上已有大量 benchmark 证明 PHP7.4 性能比 PHP5.6 有显著提升（执行效率、内存占用），目前业务流量预估在不久后性能上会受限
3. 由于业务瓶颈，准备将搜索服务迁到 Swoole，使用[Hyper 框架](https://hyperf.wiki/2.2/#/zh-cn/quick-start/install)，框架要求 `PHP >= 7.4 and <= 8.0`
4. 微软的服务器即将到期，会将服务迁移到阿里云，而阿里云的 PolarDB MySQL 引擎8.0 要求最低 PHP 版本为 PHP7.4+
5. Java 人员支持不到位，因此没有往迁移Java 考虑，通过此次迁移也将搜搜业务进行梳理，为后期迁到 Java 做准备
6. 升级目标：搜索服务目标提升多少倍？？？如何定这个性能提升指标的？？


> 参考：[从 PHP 5.6.x 移植到 PHP 7.0.x](https://www.php.net/manual/zh/appendices.php)

升级计划：
1. 让运维新开一台机器，按照目前 PHP5.6 的配置，安装编译配置好 PHP7.4 版本
2. 开发介入验收，验证 PHP 版本、扩展、配置等信息
3. 通过工具检测旧代码，修复版本升级带来的问题后部署到新机器上，初步让项目跑起来
4. 将开发的本地开发 Docker 环境升级到 PHP7.4 版本，需要保证代码能在 PHP5.6.4/PHP7.4 都能正常运行
5. 预发布切换到 PHP7.4 版本
6. 线上新开机器升级到 PHP7.4，内部流量同时验证 PHP5.6.4 和 PHP7.4，测试验收通过灰度切流量到 PHP7.4 的机器

### 压测工具

- Webbench : https://developer.aliyun.com/article/545258
- Siege : http://xstarcd.github.io/wiki/shell/siege.html

选择了 Siege，支持从文件中随机访问 URL 的特性，更加贴合实际情况。可以从 ES 拉 7 天的访问数据，然后持续加压测试。

### 审计检测工具选择

- php5.x 升级到 php7.0，推荐 [php7cc](https://github.com/sstalle/php7cc)，方便快捷，无用的信息较少。可以看：[使用教程](https://learnku.com/articles/6534/code-compatibility-detection-for-old-project-upgrade-summary)
- https://github.com/squizlabs/PHP_CodeSniffer （检测PHP、CSS和JS编码标准的工具）
- https://vfac.fr/projects/php7compatibility ([php7compatibility](https://blog.csdn.net/culh2177/article/details/108338397))
- https://github.com/phan/phan
- https://github.com/phpstan/phpstan （PHP 静态代码分析工具）

最终选择了：`PHP_CodeSniffer + php7Compatibility` 生成代码规范和版本兼容报告

`phpcs --ignore-annotations --ignore=*.js,*.html,*.htm,*.css  --extensions=php --standard=PHPCompatibility /path/to/project`

> [PHP CodeSniffer vs PHPStan](https://stackshare.io/stackups/php-codesniffer-vs-phpstan)，综合对比，推荐试试 phpstan.

### PHP5.6 升级到 PHP7.4 问题

- ASE 加密-`mcrypt_decrypt`函数废弃兼容
```php
// 修复 mcrypt_decrypt 函数在 PHP7.2 之后废弃带来的问题
if(!version_compare(PHP_VERSION, '7.2.0', '>=')) {
    $encrypt_str =  mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $screct_key, $str, MCRYPT_MODE_CBC, $iv);
} else {
    $encrypt_str =  openssl_decrypt($str, 'aes-128-cbc', $screct_key, OPENSSL_RAW_DATA|OPENSSL_ZERO_PADDING, $iv);
}
```
- 老旧代码使用拼接 SQL 方式操作数据库，通过 `mysql_escape_string` 转义 PHP7 废弃了该函数，改为 `addslashes` 转义，引入 ORM 组件逐步迁移
- [MongoDB 扩展版本](https://www.php.net/manual/zh/mongodb.requirements.php)需要更新，改用官方新版扩展。参考 [alcaeus/mongo-php-adapter](https://github.com/alcaeus/mongo-php-adapter) 实现无感替换原有 NoSQL 操作类
- 引入 tideways 进行代码性能分析，tideways 会引入 alcaeus/mongo-php-adapter 包会报重复定义 MongoId 类
- 升级 PHP 版本后，调整错误日志告警级别，导致 notice 日志大量产生，后台功能变的异常缓慢

## 无限级分类浅析
- 通过 `id-parentId` 的形式
- 通过 `左右值` 的形式
- 毗邻目录的形式


- https://blog.csdn.net/qq_43349566/article/details/89452160
- https://developer.aliyun.com/article/380753
- https://learnku.com/articles/55174
- https://cloud.tencent.com/developer/beta/article/1464513
- https://blog.bfw.wiki/user6/16249674164961840043.html
- https://developer.aliyun.com/article/42501
- https://www.cnblogs.com/sonicit/archive/2013/05/21/3090518.html
- https://www.jjjchat.com/article/1631489046465220608
- 数组引用？预排序遍历树（左右值）？毗邻目录模式？


## 判断参数变量是否为匿名函数

```php
if ($f instanceof Closure) {
}
```

PHP:
- CSRF和XSS 攻击分别是什么
- 抽象类和接口分别是什么
- 谈谈对设计模式的了解
- 谈谈对微服务的理解
- 说说垃圾回收机制
- 高并发的解决方案
- 如何防范SQL注入
- 什么是时序攻击
- 魔术方法有哪些

Laravel:
- 依赖注入实现原理
- 常用集合方法
- 常用辅助函数
- 常用中间件
- 生命周期

Swoole:
- 谈谈对协程的理解
- 和php-fjpm的区别


MySQL:
- MyISAM和InnoDB区别
- 索引结构(解释B+树)
- 悲观锁和乐观锁
- select执行过程
- 事务隔离级别
- 索引回表
- 索引失效
- 分库分表
- 读写分离

Redis:
- 数据类型
- 淘汰策略
- 事务机制
- 缓存击穿
- 分布式锁
- 集群

Vue :
- 双向数据绑定原理
- 组件通信
- 生命周期

其他:
- ElasticSearch
- MeiliSearch
- RabbitMQ
- MongoDB
- Kafka
- https://blog.csdn.net/qq_35642036/article/details/82767070
