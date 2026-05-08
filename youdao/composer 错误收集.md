# Composer 错误集锦

[TOC]


## 深入了解 Composer out of memory errors
### 背景
本地仓库依赖了很多`composer`包，执行`composer update`更新本地的包版本时遇到报错，信息如下：

```sh
$ composer update

Do not run Composer as root/super user! See https://getcomposer.org/root for details
Loading composer repositories with package information                              Warning: Accessing 172.16.5.244 over http which is an insecure protocol.
Updating dependencies (including require-dev)

Fatal error: Allowed memory size of 1610612736 bytes exhausted (tried to allocate 72 bytes) in phar:///usr/local/bin/composer/src/Composer/DependencyResolver/RuleSetGenerator.php on line 61

Check https://getcomposer.org/doc/articles/troubleshooting.md#memory-limit-errors for more info on how to handle out of memory errors.
```

原型是`composer`拉取更新包的体积过大，超出了`php.ini`中设置的最大内存空间，导致内存溢出！

### 解决方案
先查看一下当前`php.ini`文件中设置的`memorry_limit`的设置值
```sh
$ php -r "echo ini_get('memorry_limit').PHP_EOL;"
# 一般来说没有特殊设置，该值应该为 128M
128M
```

解决方案很简单：想办法将`memorry_limit`的值增大！

值得注意的是：==**若`php.ini`中的`memorry_limit`太小时，`composer`会将该值重置为`1.5G`**==
> composer源码地址：https://github.com/composer/composer/blob/master/bin/composer

```php
$memoryLimit = trim(ini_get('memory_limit'));
// Increase memory_limit if it is lower than 1.5GB
if ($memoryLimit != -1 && $memoryInBytes($memoryLimit) < 1024 * 1024 * 1536) {
    @ini_set('memory_limit', '1536M');
}
// Set user defined memory limit
if ($memoryLimit = getenv('COMPOSER_MEMORY_LIMIT')) {
    @ini_set('memory_limit', $memoryLimit);
}
```

#### （不推荐）通过修改 `php.ini` 配置文件
1. 查看当前 `php-cli` 读取的 `php.ini` 文件路径
```sh
$ php --ini
```
2. 修改步骤 1 中打印出来的`php.ini`文件
- `memorry_limit=2G`：增大配置值
- `memorry_limit=-1`：屏蔽对脚本内存上限的检查，即：无限制使用内存

> 该方式是最不推荐的，因为一般来说：==开发不会轻易的更改配置文件。==
>
> 通常大部分场景来说，脚本占用的内存都不应该超过 `memorry_limit` 的值，因此设置一个合理的 `memorry_limit` 对系统整体来说是一个保障。
>
> 如果特殊脚本需要增大，那么使用`ini_set()`函数临时设置当前脚本的内存上限即可。
>
> 而且`composer`报这个报错来说，一般都是临时的，不会经常出现。


#### （推荐）通过`php-cli`的`-d`参数指定内存上限
```sh
php -r <code> # php --run <code> 使用该参数可以在命令行内运行单行 PHP 代码。无需加上 PHP 的起始和结束标识符（<?php 和 ?>），否则将会导致语法解析错误。

php -d <key>[=<value>] # php --define <key>[=<value>] 该参数可以自行设置任何可以在 php.ini 文件中设置的配置选项的值，若<value>的值没有指定则为`1`
```
> PHP手册：https://www.php.net/manual/zh/features.commandline.php


```shell
$ php -d memory_limit=-1 /usr/local/bin/composer update
```

注意：该方式要知道`composer`的安装路径，才可以
> Linux 下可以使用`whereis composer`查找可执行程序的所在路径

#### （推荐）设置环境变量 `COMPOSER_MEMORY_LIMIT`
如果你执行`composer`报`out of memory`是经常发生的事，那么就推荐使用设置环境变量`COMPOSER_MEMORY_LIMIT`的方式。

该方式既不会影响到`php.ini`文件的正常配置和限制，从而保证`php`脚本的安全，又可以达到解决`composer out of memorry`错误的目的。

#### windows 下设置环境变量
![image](14D83887CC094A0C81EC12DC29551DFA)

##### Linux 下设置环境变量
如果对`Linux`配置文件不熟悉，直接编辑 `/etc/profile` 吧
> 一般情况下，其实也是不会编辑此文件，而是`/etc/profile.d/`目录下的文件

```sh
COMPOSER_MEMORY_LIMIT=-1
```

刷新当前进程的配置
```sh
source /etc/profile
```

![image](99FEAD5290DF469CBC9F88475151AA2E)

### 拓展：`composer` 和 `composer.phar` 的区别
> composer安装：https://getcomposer.org/doc/00-intro.md#globally

![image](23710FB1DA6C4B82AA6633FF04E292A2)
`composer.phar`是可执行文件，`composer`是`composer.phar`的软连！




## composer 更新 vendor 提示本地有变更 The package has modified files

### 背景
需要在测试环境维护一个稳定版本的全量项目包。写了一个脚部定时拉取最新的 `master` 分支代码，并自动更新对应的子模块。由于前期的 `.gitignore` 文件规范没处理好，因此导致了 `composer` 自动更新 `vendor` 的问题一直卡住，导致了 `vendor` 一直处于原始版本。

由于长期没有更新 `vendor` 目录，导致通过 `composer update` 的时候，不断有项目仓库跳出下述交互信息 `The package has modified files`，这对于通过脚部自动更新是极为不便的。 

```shell
- Updating erc_code/erc-core (v2.0.2 => 3.2.2):     
The package has modified files:
    M .gitignore
    M README.md
    M composer.json
    M src/Controller/MgController.php
    M src/Core/App.php
    M src/Core/DbModel.php
    M src/Core/HttpController.php
    M src/Core/Input.php
    M src/Core/Router.php
    M src/Exceptions/BadMethodCallException.php
    12 more files modified, choose "v" to view the full list
    Discard changes [y,n,v,d,s,?]
```

![image](B547EE5F4B9741BA90A3E98D9979B89A)

### 解决方案
出现上述情况的原因：由于本地的`vendor`目录中存在了被修改或冲突的提交，导致了`composer`更新包时出现冲突错误。

最初`composer`遇到该情况是直接提示更新失败，后续`composer`作者`Seldaek`更新了这一[特性](https://github.com/composer/composer/pull/1188)，使得开发者可以自行选择处理方式。
#### 设置`composer`变更配置
- `composer config --global discard-changes true` 直接忽略本地的变更，覆盖安装更新
- `composer config --global discard-changes stash` 将本地变更暂存`stash`到本地然后再更新

![image](F00BC665066D4CEC8D55542910F95556)

#### 屏蔽`composer update`交互信息
`composer update` 的时候添加 `-n` 参数，可以屏蔽弹出的交互信息

![image](27CAF773AA9E4F4A8EC18CE03B8C7853)



## composer post-autoload-dump error code 255

[TOC]

### 背景
最近迁移服务器，内网信息地址进行了更改，由于发布机仅作为拉取代码，打包作用，因此并未在发布机器上对RMQ、以及部分对内服务地址进行解析，导致`composer dump-autoload`的时候执行超时报错，返回了错误码 255。
![image](7776E676C2234F6482015BBD8317BB9E)

```sh
Script @php artisan package:discover --ansi handling the post-autoload-dump event returned with error code 255
```
![php-error-log-rabbitmq-connect-error](FC542D56AFA24A01B83458860820E650)

### 触发的场景
1. 如laravel的文档所说：laravel升级版本到6.x-7.x，可能会导致该问题被触发！具体可以看[这里](https://laravel.com/docs/7.x/upgrade#symfony-5-related-upgrades)
> Laravel 7.x 依赖了 Symfony 5.x 的组件，在升级 laravel 的时候需要同步升级一下Symfony的组件使用

2. 单独执行`php artisan package:discover --ansi`没有问题，但是一旦配合`composer`执行就触发，排查`php`的`error.log`寻找原因
>有一个脚本在析构函数中未经检查就尝试去获取RMQ的链接然后进行资源释放，由于发布机器没有绑定RMQ的内网地址，导致`composer autoload`的时候(该过程`composer`会自动的`new Class()`生成`autoload`文件，因此触发了析构函数的链接)超时执行失败

综上：
1. 代码里用了`vendor`里没有的类，此时可以检查一下执行`composer`的`php`版本是否不一致，从而导致加载的类库不同，导致类或函数调用丢失【例如：使用`php7.x`执行正常，切换至`php5.x`就不正常】
2. 查看一下对应时间节点的`php_error.log`，是否有报错【例如：文件读写权限受限、链接资源超时、扩展没开之类...】

### 解决步骤
1. 排除了执行`composer`时`php`的版本差异
2. 排除发布系统执行脚本超时断开链接导致：直接上发布机器跑一次`composer`命令
3. 排除`php artisan`的问题：`php artisan package:discover  --ansi                Rebuild the cached package manifest`手动执行一次，重新构建缓存扩展包，正常！
4. 排除`composer`版本问题：`composer -V` 对比了测试环境与发布机的版本，并执行`composer selfupdate`将`composer`升级到相同版本，问题依然存在！
5. 依次查看了`php`的日志信息，如：`php_error.log`、`php_slow.log`，查看相同时间节点日志信息，最终发现问题！
6. 解决问题：由于是废弃的脚步任务，直接删除了脚步上线！（断开资源的时候应当对资源进行检查再进行操作！）

### 总结
1. `composer` 在执行 `dump-autoload`生成`classMap`文件的时候，会自动的 `new class()`
![image](E637F77B4C484873B20CF42998F852F5)
![image](A37341F632F44B7B93E03EA1980A5F61)
2. 可以在`composer.json`文件中配置[`composer`执行钩子事件](https://getcomposer.org/doc/articles/scripts.md#command-events)，如：`php artisan package:discover  --ansi` 会在`composer dump-autoload`执行后被触发！
![image](AA747AD568C84B2A9EFDA64B99F5A79D)
> 推荐阅读：https://segmentfault.com/a/1190000021476022


## SSL/TLS protection disabled

运行 `composer` 命令的时候出现 `You are running Composer with SSL/TLS protection disabled.` 告警提示信息。

```sh
composer config -g -- disable-tls false
```


## Accessing xxx over http which is an insecure protocol

运行 `composer` 出现 `Warning: Accessing 10.4.133.206 over http which is an insecure protocol.` 告警

```sh
composer config -g secure-http false
```

## `composer install` 报错：Failed to decode response : zlib_decode

报错场景：
执行composer install 提示解码失败。报错信息如下:

```
Failed to decode response : zlib_decode() : data error
Retrying with degraded mode, check https://getcomposer.org/doc/articles/trouhooting.md#degraded-mode for more info
```


解决方案：
1. 执行 composer diagnose   -- composer自我诊断，如果全部都OK执行2
2. composer install -vvv   -- composer debug 安装

Composer API链接：http://docs.phpcomposer.com/03-cli.html#install-Options