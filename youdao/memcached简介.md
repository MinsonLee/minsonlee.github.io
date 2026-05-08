> 来自: loveis715 - 博客园
> - 链接：http://www.cnblogs.com/loveis715/p/4681643.html
> - 链接：https://www.runoob.com/memcached/memcached-tutorial.html
> - 链接：https://www.cnblogs.com/52php/p/5675297.html

- Memcached与Memcache区别：https://bbs.huaweicloud.com/blogs/340096 、 https://cloud.tencent.com/developer/article/1152040

- Memcached 利用 `increment` 实现简单并发锁
```php
// https://www.php.net/manual/zh/memcache.increment.php
function concurrent_lock($mark, $expire = 1, $type = 'lock') {
    if(!class_exists('mso_cache_class')) {
        include(G_MSO_COMMON_PATH.'include/mso_memcache_class.inc.php');
    }
    $mso_cache_obj = new mso_cache_class();
    $cache_key = 'lock_'.md5($mark);//令牌键值
    if($type === 'unlock') {//解锁
        return (bool)($mso_cache_obj->delete_cache($cache_key));
    }
    //加锁
    if((int)($mso_cache_obj->increment($cache_key, 1, $expire)) === 1) {
        return true;
    }
    return false;
}
```

```php
<?php

$memcached = new Memcached();
$memcached->addServer('localhost', 11211);

$lock_key = 'my_lock';
$max_wait_time = 10; // 最大等待时间，单位：秒

// 获取锁
while (true) {
    // 尝试加锁
    $result = $memcached->increment($lock_key);
    if ($result === false) {
        // 加锁失败，休眠一段时间后重试
        usleep(rand(100, 1000));
    } elseif ($result == 1) {
        // 加锁成功
        break;
    } elseif ($result > 1 && $result <= $max_wait_time) {
        // 等待其他进程释放锁
        sleep(1);
    } else {
        // 等待超时，放弃加锁
        throw new Exception('Failed to acquire lock');
    }
}

// 执行需要加锁的代码

// 释放锁
$memcached->decrement($lock_key);
```

```php
<?php

// 初始化 Memcached 客户端
$memcached = new Memcached();
$memcached->addServer('localhost', 11211);

// 获取锁
function acquireLock($key) {
    global $memcached;
    
    // 使用 add 方法尝试向 Memcached 中添加指定 key，如果返回 false 表示已经存在
    // 这里将锁的有效期设置为 30 秒，可以根据实际情况调整
    return $memcached->add($key, true, 30);
}

// 释放锁
function releaseLock($key) {
    global $memcached;
    
    // 使用 delete 方法从 Memcached 中删除指定 key
    return $memcached->delete($key);
}

// 示例代码
$key = 'my_lock_key';
if (acquireLock($key)) {
    // 成功获取锁，进行业务处理
    echo 'Lock acquired successfully.';

    // 模拟业务处理时间
    sleep(5);

    // 释放锁
    releaseLock($key);
} else {
    // 获取锁失败，进行相应处理
    echo 'Failed to acquire lock.';
}
```

使用 add 而不是 increment 的原因是因为在高并发情况下，多个客户端可能同时调用 increment 函数，导致计数器的值不一致，从而破坏锁的正确性。而使用 add 函数则可以避免这个问题。如果一个客户端调用 add 函数成功了，那么它就获得了这个锁，而其他客户端在调用 add 函数时会失败，从而无法获得锁。

另外，使用 add 还有一个好处，即可以设置锁的超时时间，避免某个客户端持有锁的时间过长，导致其他客户端无法获取锁。可以在 add 函数中设置一个过期时间，如果锁没有在指定的时间内被释放，那么它会自动过期。