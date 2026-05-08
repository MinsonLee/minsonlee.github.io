首先说下什么是 lib 库。lib 库就是一个提供特定功能的一个文件。可以把它看成是 PHP 的一个文件，这个文件提供一些函数方法。只是这个 lib 库是用 c 或者 c++ 写的。

使用 lib 库的场景。一些软件已经提供了 lib 库，我们就没必要再重复实现一次。如，原先的 mysql 扩展，就是使用 mysql 官方的 lib 库进行的封装。

在本文，我们将建立一个简单的 lib 库，并在扩展中进行封装调用。

基础代码
----

这个扩展，我们将在 say 扩展上增加 `call_lib_fun()`。say 扩展相关代码大家请看这篇博文。PHP7 扩展开发之 hello word 文中已经详细介绍了如何创建一个扩展和提供了源码下载。

代码实现
----

### 建立 lib 库

增加 hello.h 文件。代码如下：

```
#ifndef TEST_HEADER_FILE
#define TEST_HEADER_FILE
 
#include <stdlib.h>
#include <string.h>
 
char * show_site(); 
 
#endif
```

增加 `hello.c` 文件。代码如下：

```
#include "hello.h"
 
char * show_site()
{
    char *site = malloc(15 * sizeof(char));
    strcpy(site, "www.bo56.com");
    return site;
}
```

然后使用以下命令生成 lib 库（动态库）文件：

```
$ gcc -g -O0 -fPIC -shared -o hello.so ./hello.c
```

这样在当前目录下就会生成一个 `hello.so` 的动态库文件。不同操作系统动态库的扩展名可能不一样。如 `windows` 下是 `dll`，`mac` 下是 `dylib`，`linux` 下是 `so`。

然后把 `hello.so` 拷贝到 `/usr/local/lib/` 目录下, 命名为 `hello.so` 把 `hello.h` 拷贝到 `/usr/local/include/` 目录下。

### 修改 config.m4 文件

增加扩展对动态库的依赖。主要增加以下几行代码：

```
PHP_ADD_LIBRARY_WITH_PATH(hello, /usr/local/lib/, SAY_SHARED_LIBADD)
PHP_SUBST(SAY_SHARED_LIBADD)
```

### 编写扩展代码

增加 `hello.h` 的引用。

```
#include "php_say.h"
#include <stdio.h>

//下面这行是增加的
#include "hello.h"
```

增加 `show_site()` 方法。代码如下：

```
PHP_FUNCTION(show_site)
{
    char *site = show_site();
    RETVAL_STRING(site);
    free(site);
    return;
}
```

### php 调用结果

```php
<?php
$result = show_site();
var_dump($result);
?>
```

执行结果

```ssh
$ php ./test.php

string(12) "www.bo56.com"
```

代码解读
----

`PHP_ADD_LIBRARY_WITH_PATH` 是用于指定 `lib` 库的名字，地址等信息。第一个参数是名字，第二个参数是地址。

在 `say.c` 文件中增加 `lib` 库的头文件。使用 `#include "hello.h"`。

在扩展代码中就像调用其他内核提供的方法一样，去调用 `lib` 库中的方法。

原文链接：[PHP7 扩展开发之函数方式使用 lib 库](https://www.bo56.com/php7%e6%89%a9%e5%b1%95%e5%bc%80%e5%8f%91%e4%b9%8b%e5%87%bd%e6%95%b0%e6%96%b9%e5%bc%8f%e4%bd%bf%e7%94%a8lib%e5%ba%93/)，转载请注明来源！