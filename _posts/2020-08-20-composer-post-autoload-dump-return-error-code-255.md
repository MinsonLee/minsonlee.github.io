---
layout: post
title: "composer post-autoload-dump error code 255"
date: 2020-08-20
tag: Composer
---

## 背景
最近迁移服务器，内网信息地址进行了更改，由于发布机仅作为拉取代码，打包作用，因此并未在发布机器上对RMQ、以及部分对内服务地址进行解析，导致`composer dump-autoload`的时候执行超时报错，返回了错误码 255。
![composer post-autoload-dump event returned with error code 255](/images/article/composer-post-autoload-dump-error-code-255.png)

```sh
Script @php artisan package:discover --ansi handling the post-autoload-dump event returned with error code 255
```

![php_error.log rabbitmq connect error](/images/article/composer-php-error-log-rabbitmq-connect-error.png)

## 触发的场景
1. 如`Laravel`的文档所说：`Laravel`升级版本到`6.x-7.x`，可能会导致该问题被触发！具体可以看[这里](https://laravel.com/docs/7.x/upgrade#symfony-5-related-upgrades)
> `Laravel 7.x` 依赖了 `Symfony 5.x` 的组件，在升级 `Laravel` 的时候需要同步升级一下`Symfony`的组件使用

2. 单独执行`php artisan package:discover --ansi`没有问题，但是一旦配合`composer`执行就触发，排查`php`的`error.log`寻找原因
>有一个脚本在析构函数中未经检查就尝试去获取RMQ的链接然后进行资源释放，由于发布机器没有绑定RMQ的内网地址，导致`composer autoload`的时候(该过程`composer`会自动的`new Class()`生成`autoload`文件，因此触发了析构函数的链接)超时执行失败

综上：
1. 代码里用了`vendor`里没有的类，此时可以检查一下执行`composer`的`php`版本是否不一致，从而导致加载的类库不同，导致类或函数调用丢失【例如：使用`php7.x`执行正常，切换至`php5.x`就不正常】
2. 查看一下对应时间节点的`php_error.log`，是否有报错【例如：文件读写权限受限、链接资源超时、扩展没开之类...】

## 解决步骤
1. 排除了执行`composer`时`php`的版本差异
2. 排除发布系统执行脚本超时断开链接导致：直接上发布机器跑一次`composer`命令
3. 排除`php artisan`的问题：`php artisan package:discover  --ansi                Rebuild the cached package manifest`手动执行一次，重新构建缓存扩展包，正常！
4. 排除`composer`版本问题：`composer -V` 对比了测试环境与发布机的版本，并执行`composer selfupdate`将`composer`升级到相同版本，问题依然存在！
5. 依次查看了`php`的日志信息，如：`php_error.log`、`php_slow.log`，查看相同时间节点日志信息，最终发现问题！
6. 解决问题：由于是废弃的脚步任务，直接删除了脚步上线！（断开资源的时候应当对资源进行检查再进行操作！）

## 总结
1. `composer` 在执行 `dump-autoload`生成`classMap`文件的时候，会自动的 `new class()`
![composer autoload function creatMap()](/images/article/composer-autoload-create-class-map-source-code.png)

![composer dump-autoload will new Class()](/images/article/composer-autoload-new-class-demo.png)

2. 可以在`composer.json`文件中配置[`composer`执行钩子事件](https://getcomposer.org/doc/articles/scripts.md#command-events)，如：`php artisan package:discover  --ansi` 会在`composer dump-autoload`执行后被触发！
![how to config composer event hook in composer.json](/images/article/composer-hook-envent-demo.png)

推荐阅读：https://segmentfault.com/a/1190000021476022