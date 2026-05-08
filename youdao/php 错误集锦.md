
1. Laravel 报错：PHP Fatal error: Uncaught ReflectionException: Class request does not exist

通过软链接，导致挂载到 Docker 内部子模块目录为空了，因此在支持 composer update 时，在最后的 `php artisan` 步骤报错：`Fatal error: Uncaught ReflectionException: Class request does not exist`。结合 Summer 大佬的一篇文章得以解决。

- https://learnku.com/laravel/t/31178

2. `http_build_query` 函数的 bug：会自动将值为 `NULL` 的参数去掉
- https://www.php.net/manual/en/function.http-build-query.php#60523

且 PHP 官方不承认这是 http_build_query 的问题，因此建议在可以的情况下将 null 改为空字符进行传递


3. PHP 中 `json_encode()` 函数默认会对中文进行 unicode 转码，导致中文看起来像乱码一样，让信息很困惑

```php
json_encode( $arr, JSON_UNESCAPED_UNICODE);
```

4. PHP 中的 `json_decode` 对于 bigint 转换也会有问题，对于 bigint 如果没有使用引号括起来，在 decode 的时候可能造成类型溢出从而得到一个错误的数字

```php
json_decode($json, true , 512 , JSON_BIGINT_AS_STRING)
```


- https://segmentfault.com/a/1190000040084826
- https://juejin.cn/post/6844903619259547662
- https://cloud.tencent.com/developer/news/326478
- https://www.ucloud.cn/yun/25687.html

5. PHP8 之前缺乏枚举类

- https://learnku.com/laravel/t/7479/how-do-you-deal-with-the-enumerated-type-enum-in-the-php-code


6. 使用了 `date_default_timezone_set` 要记得将时区设置回原来的时区，且使用 `date_default_timezone_get()` 获取原来的默认时区，而不是走自行配置。

```php
$defaultTimezone = date_default_timezone_get();
date_default_timezone_set('PRC');

// 处理业务逻辑

date_default_timezone_set($defaultTimezone);
```

7. 如果我下次要改，现在的代码是否是易扩展的？改动能否足够的小？是否是可测试且容易测试的？变量或函数的命名是否是没有歧义的？