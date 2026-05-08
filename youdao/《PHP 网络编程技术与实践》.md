1. `apachectl configtest` 或 `apache -t`  检查配置文件中的错误，而无须启动 `Apache` 服务器
2. PHP 中的数组实际上是一个有序图（有序映射/有序字典）
    - [如何保证有序性的？](https://www.php.cn/php-weizijiaocheng-303937.html)
    - [【PHP7源码学习】剖析PHP数组的有序性](https://blog.csdn.net/marina_1/article/details/108122283)
    - [PHP: Array 数组- Manual](https://www.php.net/manual/zh/language.types.array.php)
    - [深入理解PHP数组底层实现](https://blog.csdn.net/weixin_41882200/article/details/117460105)
    - 遍历 `$a = [ 500 => 500, 'a' => 'a', 'b' => 'b', 501]` 顺序是怎么样的？
3. `Cookie` 会话机制是 **Web 服务中服务端发送给浏览器客户端的字符串**。[`$_COOKIE`](https://www.php.net/manual/zh/reserved.variables.cookies) 和 `$_SERVER['HTTP_COOKIE']` 的区别是什么？
> https://stackoverflow.com/questions/33449916/difference-between-serverhttp-cookie-and-cookie

当 Cookie 中存了数组时，调用 `Guzzle` 的 `CookieJar` 时，将 `$_COOKIE` 传入是会异常的。

```php
// 其中 1 个项目在根域中设置了如下 Cookie
$hash_str = $this->get_hash_str($project_code);
$cookie_name = "_cpa[{$encrypte_project_code}]";
setcookie($cookie_name,$hash_str,time()+7200,'/','.' . ROOT_DOMAIN, false ,true);

// 低版本 Guzzle 中在调用 CookieJar::fromArray 时可能会报错
$cookieJar = CookieJar::fromArray($_COOKIE,'.'.$rootDomain);
new \GuzzleHttp\Client([
    'cookie' => true,
    'cookies' => $cookieJar,
    'debug' => false,
    'http_errors' => false,
    'verify' => false,
]);

// 使用 $_SERVER['HTTP_COOKIE'] 替代 $_COOKIE
function get_request_cookie_arr(){
    static $cache;
    if (!is_null($cache)) {
        return $cache;
    }

    $array = isset($_SERVER['HTTP_COOKIE']) ? explode(";",$_SERVER['HTTP_COOKIE']) : [];

    $ret = [];
    foreach($array as $item){
        $item_array = explode("=",trim($item));
        $it_key = trim(reset($item_array));
        $it_value = trim(end($item_array));
        if (get_current_business_sys() === BUSINESS_SYS_HOTEL && ($it_key == '_language' || $it_key == 'i18n')) {
            $it_value = 'en';
        }
        $ret[$it_key] = $it_value;
    }
    $cache = $ret;

    return $ret;
}
```