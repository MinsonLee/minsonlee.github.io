上一篇文章，我们使用的是函数方式调用 `lib` 库。这篇文章我们将使用对象的方式调用 `lib` 库。调用代码如下：

```php
<?php
$hello = new hello();
$result = $hello->get();
var_dump($result);
?>
```

我们将在扩展中实现 `hello` 类。`hello` 类中将依赖 `lib` 库。

基础代码
----

这个扩展，我们将在 `say` 扩展上增加相关代码。`say` 扩展相关代码大家请看这篇博文。`PHP7` 扩展开发之 `hello word` 文中已经详细介绍了如何创建一个扩展和提供了源码下载。

代码实现
----

### 建立 lib 库

增加 `hello.h` 文件。代码如下：

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

然后使用以下命令生成 `lib` 库（动态库）文件：

```sh
$ gcc -g -O0 -fPIC -shared -o hello.so ./hello.c
```

这样在当前目录下就会生成一个 `hello.so` 的动态库文件。不同操作系统动态库的扩展名可能不一样。如 `windows` 下是 `dll`，`mac` 下是 `dylib`，`linux` 下是 `so`。

然后把 `hello.so` 拷贝到 `/usr/local/lib/` 目录下, 命名为 `hello.so`  
把 `hello.h` 拷贝到 `/usr/local/include/` 目录下。

#### 修改 config.m4 文件

增加扩展对动态库的依赖。主要增加以下几行代码：

```
PHP_ADD_LIBRARY_WITH_PATH(hello, /usr/local/lib/, SAY_SHARED_LIBADD)
PHP_SUBST(SAY_SHARED_LIBADD)
```

### 编写扩展代码

修改 `say.c` 文件  
增加 `hello.h` 的引用。

```
#include "php_say.h"
#include <stdio.h>

//下面这行是增加的
#include "hello.h"
```

声明一个指针变量，用于存储类的地址。  
在 `static int le_say;` 行下面增加如下代码：

```
zend_class_entry *hello_ce;
```

声明一个变量，用于存储类的处理函数。增加如下代码：

```
zend_object_handlers hello_object_handlers;
```

定义一个结构体类型，用于存储类的一些信息。如 lib 库信息。

```
typedef struct _hello_object {
    char * hello_ptr;
    zend_object std;
} hello_object;
```

注意，`zend_object std` 一定要放在最后一行。

定义一个函数，用于从标准的 `zend_object` 转换获取 `hello_object` 地址。

```
static inline hello_object *hello_fetch_object(zend_object *obj)  
{
        return (hello_object *)((char*)(obj) - XtOffsetOf(hello_object, std));
}
```

定义一个函数，用户创建类对象。代码如下：

```
static zend_object * hello_object_create(zend_class_entry *type TSRMLS_DC)
{
    hello_object *obj = (hello_object *)ecalloc(1, sizeof(hello_object) + zend_object_properties_size(type));
    zend_object_std_init(&obj->std, type);
    object_properties_init(&obj->std, type);
    obj->std.handlers = &hello_object_handlers;
    return &obj->std;
}
```

定义函数，用户销毁类对象。代码如下：

```
void hello_object_free_storage(zend_object *object)
{
    hello_object *intern = hello_fetch_object(object);
    zend_object_std_dtor(&intern->std);
}
```

声明类都有哪些方法。增加如下代码：

```
PHP_METHOD(hello, __construct);
PHP_METHOD(hello, __destruct);
PHP_METHOD(hello, get);
const zend_function_entry hello_methods[] = 
{
    PHP_ME(hello, __construct, NULL, ZEND_ACC_PUBLIC|ZEND_ACC_CTOR)
    PHP_ME(hello, __destruct, NULL, ZEND_ACC_PUBLIC|ZEND_ACC_DTOR)
    PHP_ME(hello, get, NULL, ZEND_ACC_PUBLIC)
    {NULL, NULL, NULL}  /* Must be the last line in hello_methods[] */
};
```

把上面声明和定义的函数结合起来。  
在 `PHP_MINIT_FUNCTION` 方法中增加如下代码：

```c
zend_class_entry ce;

INIT_CLASS_ENTRY(ce, "hello", hello_methods);

hello_ce = zend_register_internal_class(&ce);
hello_ce->create_object = hello_object_create;

memcpy(&hello_object_handlers, zend_get_std_object_handlers(), sizeof(zend_object_handlers));

hello_object_handlers.clone_obj = NULL;
hello_object_handlers.offset = XtOffsetOf(hello_object, std);
hello_object_handlers.free_obj = hello_object_free_storage;
```

实现在 `hello_methods` 中指定的类的方法：

```
PHP_METHOD(hello, __construct)
{
    zval  *self = getThis();
    hello_object *obj = hello_fetch_object(Z_OBJ_P((self)));
    obj->hello_ptr = show_site();
    RETURN_TRUE;
}
 
PHP_METHOD(hello, __destruct)
{
    zval  *self = getThis();
    hello_object *obj = hello_fetch_object(Z_OBJ_P((self)));
    free(obj->hello_ptr);
    RETURN_TRUE;
}
 
PHP_METHOD(hello, get)
{
    zval  *self = getThis();
    hello_object *obj = hello_fetch_object(Z_OBJ_P((self)));
    RETURN_STRING(obj->hello_ptr);
}
```

### php 调用结果

执行结果

```
$ php ./test.php

string(12) "www.bo56.com"
```

### 代码解读

类的创建，之前有一篇文章专门讲述过流程。调用 lib 创建对象和普通创建对象不同之处：

* 需要一个结构体来保存对象与 lib 库资源之间的关系。如上面的`hello_object`。  
* 需要定义一些方法。如创建对象，消耗对象，对象转换的方法。  
* 需要在`PHP_MINIT_FUNCTION`中把定义的方法和类绑定起来。

源码下载
----

[tar.gz 格式下载](http://www.bo56.com/download/php7_ext/say_show_site.tar.gz)  
[zip 格式下载](http://www.bo56.com/download/php7_ext/say_show_site.zip)


原文链接：[PHP7 扩展开发之对象方式使用 lib 库](https://www.bo56.com/php7%e6%89%a9%e5%b1%95%e5%bc%80%e5%8f%91%e4%b9%8b%e5%af%b9%e8%b1%a1%e6%96%b9%e5%bc%8f%e4%bd%bf%e7%94%a8lib%e5%ba%93/)，转载请注明来源！