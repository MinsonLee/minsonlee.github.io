---
layout: post
title: "程序运行过程中操作系统对内存的划分"
date: 2020-05-20
tag: 编程基础
---
> 图片内容整理自：https://blog.csdn.net/Evankaka/article/details/44457765

![操作系统对程序的逻辑分区](/images/article/os-memory-space-partition.png)

**！！！注意：此处的划分只是逻辑上的划分，并非物理机上真是的分区状况**

## `PHP`作用域案例探讨
```php
<?php
function a()
{
    global $c; // 声明使用全局变量 $c
    global $d; // 声明使用全局变量 $d(若外部没有定义则被初始化定义)
    $d = 222;  // 为全局变量 $d 赋值
    var_dump($c);
}

function b()
{
    var_dump($c);
    var_dump($d)
}

$c = 111;
// 打印 int(111)
a(); 

// 打印 null 
//     int(222)
b();
```

## `JavaScript`作用域案例探讨
```javascript
function a() {
    console.log(b);
}
b = 111;
a(); // 此处输出 111，而不是 undefined
```

> 看着图能理解，但是案例的图解画出来不满意，感觉看不懂！欠着