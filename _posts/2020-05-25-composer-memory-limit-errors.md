---
layout: post
title: "Composer错误：out of memory errors"
date: 2020-05-25
tag: Composer
---
## 背景
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

## 解决方案
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

### （不推荐）通过修改 `php.ini` 配置文件
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


### （推荐）通过`php-cli`的`-d`参数指定内存上限
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

### （推荐）设置环境变量 `COMPOSER_MEMORY_LIMIT`
如果你执行`composer`报`out of memory`是经常发生的事，那么就推荐使用设置环境变量`COMPOSER_MEMORY_LIMIT`的方式。

该方式既不会影响到`php.ini`文件的正常配置和限制，从而保证`php`脚本的安全，又可以达到解决`composer out of memorry`错误的目的。

#### windows 下设置环境变量
![how-to-set-environment-variable-on-windows-os](/images/article/windows/how-to-set-environment-variable.png)

#### Linux 下设置环境变量
如果对`Linux`配置文件不熟悉，直接编辑 `/etc/profile` 吧
> 一般情况下，其实也是不会编辑此文件，而是`/etc/profile.d/`目录下的文件

```sh
COMPOSER_MEMORY_LIMIT=-1
```

刷新当前进程的配置
```sh
source /etc/profile
```

![how-to-set-environment-variable-on-linux-os](/images/article/composer-demo-how-to-set-environment-variable.png)

## 拓展：`composer` 和 `composer.phar` 的区别
> composer安装：https://getcomposer.org/doc/00-intro.md#globally

![what-is-the-deference-between-composer-and-composer.phar](/images/article/composer-what-is-the-deference-between-composer-and-composer.phar.png)
`composer.phar`是可执行文件，`composer`是`composer.phar`的软连！