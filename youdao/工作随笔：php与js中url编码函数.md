# PHP与JS中URL编码函数
[TOC]

## 背景
历史代码中有一套对称的加/解密函数，如下：
```php
public static function encode($param)
{
    if (is_array($param)) {
        $data = json_encode($param);
    }
    $base64 = base64_encode(openssl_encrypt($data, self::$MODE, self::$KEY, PKCS7_TEXT, self::$IV));
    return urlencode($base64);
}

public static function decode($string)
{
    return json_decode(openssl_decrypt(base64_decode($string), self::$MODE, self::$KEY, PKCS7_TEXT, self::$IV), true);
}
```
用于对一些简单的数据进行加解密，今天在群里突然听到一个同事说因为`PHP`和`JavaScript`对URL的 encode 操作是有差异的，踩坑了...

![image](62A307A0A22A4FEEB9FFC694781C2733)

查阅了一下资料，发现这个问题还真是有点混乱...因此此处进行一番总结记录！
> 越是细微特殊场景的问题，越容易被忽略，且越难排查问题...

## 为什么需要进行 URL 编码？

一句话总结，就是：==URL 编码是为了更好、更安全的进行数据传输！==

## 什么是 RFC？
> 如何阅读RFC(译)：https://juejin.im/post/5bf1948ff265da61553a6c97

请求意见稿(Request for Comments，缩写：RFC) 是由互联网工程任务组（IETF）发布的一系列用来记录互联网规范、协议、过程等的标准文件.

关于 URL/URI 规范主要存在于：`RFC 1738 - Uniform Resource Locators (URL)`
和 `RFC 3986 - Uniform Resource Identifier (URI): Generic Syntax` 两个标准文件中。

2002年8月，RFC 3305指出，虽然术语“URL”仍被广泛地用于日常用语之中，但其本身已几乎被废弃。

2006年11月1日，W3C技术架构小组（W3C's Technical Architecture Group，TAG）公布了[《连接替代副本使查找和发布可行化》](http://www.w3.org/2001/tag/doc/alternatives-discovery.html)，一个对于发布给定资源的多个版本的权威URI和其最佳实践的指导。

这一举措意味着：现有的 URL 标准应当逐渐按照 URI 的标准文件进行规范使用。

由于上述历史原因，各个不同的编程语言、浏览器厂商...对 URL 的编码上也有一些不同。实际上，本文其实也是围绕这两个标准文件关于保留字(即：在URL/URI中使用不会被编码)的区别来展开核心讨论的：

**RFC 1738 - Uniform Resource Locators (URL)：Reserved**

> The characters ";", "/", "?", ":", "@", "=" and "&" are the characters which may be reserved for special meaning within a scheme.
>
>Thus, only alphanumerics, the special characters "$-_.+!*'(),", and reserved characters used for their reserved purposes may be used unencoded within a URL.

上述摘抄总结就是：
1. RFC 1738 规定 `;/?:@=` 这几个字符为保留字
2. **字母数字、特殊字符`$-_.+!*'(),`、保留字**可以在 URL 中不被编码的进行使用，其余字符都需要进行编码


**RFC 3986 - Uniform Resource Identifier (URI): Generic Syntax**

> URIs include components and subcomponents that are delimited by characters in the "reserved" set. 
>
> If data for a URI component would conflict with a reserved character's purpose as a delimiter, then the conflicting data must be percent-encoded before the URI is formed.
> 
> reserved = gen-delims / sub-delims
>
> gen-delims  = ":" / "/" / "?" / "#" / "[" / "]" / "@"
>
>sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
>
> The purpose of reserved characters is to provide a set of delimiting characters that are distinguishable from other data within a URI.

上述摘抄总结如下：
1. URIs 通过保留字对自身进行了划分，分为基层划分（将URI划分为多个组件）和子划分（将组件划分为多个子组件）
2. **如果URI组件中的数据与保留字符作为分隔符的目的相冲突，那么在形成URI之前，必须对冲突的URI组件数据进行百分比编码**
3. 基层组件分隔符号：`:/?#[]@`；子分隔符号：`!$&'()*+,;=`
4. **URIs 保留字的目的只有一个：分隔**

### RFC 1738 与 RFC 3986 的区别
1. RFC 1738 允许：**保留字在 URL 数据中不经过编码即可正常使用**
2. RFC 3986 不允许保留字作为数据部分在 URI 中使用，保留字只做分隔作用



## PHP 中的URL编码/解码函数

### PHP 编码函数：`urlencode`/`rawurlencode`

`urlencode ( string $str ) : string` 可以将给定的字符串(`$str`)进行 **URL 编码**，返回一个编码后的字符串。

**注意事项：**
- 此字符串中除了 `-_. ` 之外的所有非字母数字字符都将被替换成百分号（%）后跟两位十六进制数【Percent-Encoding】，**空格则编码为加号（+）**
- 此编码与 **WWW 表单 POST 数据的编码方式是一样的**，同时**与 application/x-www-form-urlencoded 的媒体类型编码方式一样**
- 由于历史原因，`urlencode` 编码在**将空格编码为加号（+）**方面与 `RFC3986` 编码协议不同


`rawurlencode ( string $str ) : string` 可以将给定的字符串(`$str`)根据 RFC 3986 版本协议进行 URL 编码，返回一个编码后的字符串。

**注意事项：**
- 在 PHP 5.3.0 之前，rawurlencode 根据 RFC 1738 来编码波浪线（~），现已更正
- 返回值中的字符串中除了 `-_. ` 之外的所有非字母数字字符都将被替换成百分号（%）后跟两位十六进制数（**包括空格**）
> 为了保护原义字符以免其被解释为特殊的 URL 定界符，同时保护 URL 格式以免其被传输媒体（像一些邮件系统）使用字符转换时弄乱。
> 如：ftp、email协议中使用对+会产生不 


### `urlencode`与`rawurlencode`该如何选择？
1. `urlencode`与`rawurlencode` 都是使用百分比编码方式进行编码加密
2. `urlencode`与`rawurlencode` 唯一的区别在于对空格的编码方式上，urlencode 编码为加号(+)，而 rawurlencode 编码为`%20`
3. `urlencode` 编码的可读性比较好，适用于：对 URL 的参数部分进行编码
4. `rawurlencode`更加通用，不仅是参数部分，因此：**一般情况下应当优先使用**

```php
<?php
echo urlencode('Kevin van Zonneveld!'); // Kevin+van+Zonneveld%21
echo rawurlencode('Kevin van Zonneveld!'); // Kevin%20van%20Zonneveld%21
```

## JavaScript中的URL编码/解码函数
### `encodeURI`/`decodeURI`
### `encodeURIComponent`/`decodeURIComponent`
### `escape`/`unescape`
### `encodeURI`、`encodeURIComponent`、`escape`三者的区别

## 表单提交时如何处理该差异？
1. PHP 层面自行处理对 **URL 的参数部分**进行编码实现 JavaScript 的 `encodeURIComponent`效果
```php
# https://www.php.net/manual/en/function.urlencode.php#97969
# `urlencode` 和 `rawurlencode` 绝大部分都是基于 `RFC 1738 - Uniform Resource Locators (URL)` 协议规定进行编码的。
# 然而，从 2005 年起，RFC 规定 URIs 标准协议为 `RFC 3986 - Uniform Resource Identifier (URI): Generic Syntax`
# 此处是根据 RFC 3986 协议进行编码 URLs

function myUrlEncode($string) {
    $entities = array('%21', '%2A', '%27', '%28', '%29', '%3B', '%3A', '%40', '%26', '%3D', '%2B', '%24', '%2C', '%2F', '%3F', '%25', '%23', '%5B', '%5D');
    $replacements = array('!', '*', "'", "(", ")", ";", ":", "@", "&", "=", "+", "$", ",", "/", "?", "%", "#", "[", "]");
    
    return str_replace($entities, $replacements, urlencode($string));
}
```

2. JS 提交表单时，进行处理：


## 总结与感悟

**总结**：PHP 在进行 URL 编码时候，应当总是优先考虑使用`rawurlencode()`。


## 参考阅读
- RFC 1738 - Uniform Resource Locators (URL)：http://www.faqs.org/rfcs/rfc1738.html
- RFC 3986 - Uniform Resource Identifier (URI): Generic Syntax：http://www.faqs.org/rfcs/rfc3986.html
- PHP官方手册-urlencode函数：https://www.php.net/manual/zh/function.urlencode.php
- w3schools手册-escape函数：https://www.w3schools.com/jsref/jsref_escape.asp
- PHP's urlencode in JavaScript：https://locutus.io/php/url/urlencode/
- JS对url进行编码和解码：https://segmentfault.com/a/1190000013236956
- PHP: urlencode() vs. rawurlencode()：https://www.gyrocode.com/articles/php-urlencode-vs-rawurlencode/
- [淺談-http-url-規範-善用-javascript-encodeuricomponent-與-php-rawurlencode-來進行-url-編碼](https://blog.toright.com/posts/2937/%E6%B7%BA%E8%AB%87-http-url-%E8%A6%8F%E7%AF%84-%E5%96%84%E7%94%A8-javascript-encodeuricomponent-%E8%88%87-php-rawurlencode-%E4%BE%86%E9%80%B2%E8%A1%8C-url-%E7%B7%A8%E7%A2%BC.html)
- 关于URL编码：https://www.ruanyifeng.com/blog/2010/02/url_encoding.html
- URL编码/解码：https://www.dute.org/url-encode
- 【基础进阶】URL详解与URL编码：https://www.cnblogs.com/coco1s/p/5038412.html
- 你真的了解URL encode吗？：https://www.cnblogs.com/hushuai-ios/p/5500162.html


**拓展阅读：form表单提交数据方式**
- 四种常见的 POST 提交数据方式：https://imququ.com/post/four-ways-to-post-data-in-http.html
- POST提交数据之---Content-Type的理解：https://www.cnblogs.com/tugenhua0707/p/8975121.html
- HTTP请求中 request payload 和 formData  区别？：https://www.cnblogs.com/tugenhua0707/p/8975615.html
- Form content types：https://www.w3.org/TR/html401/interact/forms.html#h-17.13.4
- 表单提交中 Content-Type 该选什么？：https://blog.windrunner.me/programming/form-content-type.html
- postman中form-data、x-www-form-urlencoded、raw、binary的区别：https://juejin.im/post/5cba8f99e51d45789024d7ca



```javascript
encodeURI("Kevin van Zonneveld!"); // "Kevin%20van%20Zonneveld!"
encodeURIComponent("Kevin van Zonneveld!"); // "Kevin%20van%20Zonneveld!"
// JavaScript 1.5 中一开始被弃用
escape("Kevin van Zonneveld!"); // "Kevin%20van%20Zonneveld%21"
```