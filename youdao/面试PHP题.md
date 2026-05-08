1. `运算符` 下面代码将打印出什么结果？
```php
<?php
$a = true && false;
$b = true and false;

var_dump($a); // false
var_dump($b); // true
```
> 考运算符优先级：http://www.laruence.com/2010/07/26/1668.html

2. PHP 中 ?? 和 ?: 的区别？
- ?? 是 PHP7 中新加的一个三元运算符.
```php
$c = $a ?? $b
```
表示 
```php
if(isset($a)) {
    $c = $a;
} else {
    $c = $b;
}
```
> 考察对 PHP7 的了解：https://www.php.net/manual/en/migration70.new-features.php#migration70.new-features.null-coalesce-op
