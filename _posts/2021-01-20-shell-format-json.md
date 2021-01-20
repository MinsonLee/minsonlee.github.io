---
layout: post
title: Linux JSON 格式化工具 - `jq`
date: 2021-01-20
tags: [Tools,json,jq]
---

`JSON-JavaScript Object Notation` 是一种轻量级的数据交换格式。由于其简单、便于阅读、便于编写的特性，逐渐替代了一部分`xml`的职责在数据交换领域占有一定地位，绝大部分的语言也都提供了对`JSON`文本的解析，详细可阅读：[什么是`JSON`](https://www.json.cn/wiki.html)、[各主流语言的`JSON`解析代码](https://www.json.cn/code.html)。

`Linux` 平台上处理文本的工具堪称是经典，例如：`sed`、`awk`、`grep`、`find`...，但如果返回结果是 `JSON` 格式，使用上述提到的文本处理工具也可以获取到对应的值，但成本稍微复杂一点（并且还有可能不准确），如下：

![jq-use-awk-to-get-json-value.png](/images/article/jq-use-awk-to-get-json-value.png)

在桌面系统中，我们可以通过一些网站提供的工具（如：[http://json.cn/](http://json.cn/)）或浏览器插件（[`FeHelper`](https://www.baidufe.com/fehelper/index/index.html)）可以很方便的解析 `JSON` 数据并快速得到我们想要的结果。

但是在 `Shell` 编程中，就需要自己通过`grep`、`awk`、`sed`等工具组合进行“曲线救国”了，非常麻烦且匹配出来的结果有时还不太准确！后来在网上一搜...好家伙，原来`jq`这个工具从 `2013` 年就出来了，真是孤陋寡闻了！

正如 [`jq` 的官网](https://stedolan.github.io/jq/)所说：`jq`是一个用 `C` 语言编写的独立没有任何依赖的开源工具，你可以使用 `jq` 来切割、过滤、映射和转换 `JSON` 结构化数据，而可以用 `sed`、`awk`、`grep`更加轻松、专注、友好的处理文本。

- `jq` 的官网：https://stedolan.github.io/jq/
- `jq` 的指南：https://stedolan.github.io/jq/tutorial/
- `jq` 的手册：https://stedolan.github.io/jq/manual/
- `jq` 的安装：https://stedolan.github.io/jq/download/ 【安装完毕后可以通过 `jq -V` 验证是否安装成功】


## 使用

1. **在 `jq` 中英文状态下的点号-`.`表示整个`JSON`结构**（还可以通过管道将父级节点）
2. **获取对象的值：`.key`**
3. **获取数组的值：`.key[0]`**

### 格式化 `json` 文本

`JSON` 实际只是一种特殊格式的字符串，有些情况下服务器返回的数据虽然是 `JSON` 的，但是如果响应头中的 `Content-Type` 不是 `application/json`，那么客服端是不会进行美化打印的。可以通过管道将 `JSON` 格式的文本传给 `jq` 进行格式化打印输出。

```sh
echo '{"text":"这是一个json格式的文本"}' | jq .
```

![jq-format-json.png](/images/article/jq-format-json.png)

### 获取对象的值

![jq-get-object-json.png](/images/article/jq-get-object-json.png)

### 获取数组的值

```sh
# 获取数组下所有的 `name` 属性值
echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' | jq '.[].name'

# 获取数组下所有的 `name` 属性值 ==> 利用管道将父节点作为 `JSON` 整个节点
echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' | jq '.[] | .name'

# 获取指定数组下`name`属性
echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' | jq '.[0].name'
```

![jq-get-array-json.png](/images/article/jq-get-array-json.png)

### 自定义输出数组

```sh
curl -s http://httpbin.org/anything | jq '. | {"方法": .method, "链接": .url}'
```

![jq-customer-output-json.png](/images/article/jq-customer-output-json.png)

### 压缩 `JSON` 为字符串

```sh
curl -s http://httpbin.org/anything | jq -c
```

![jq-zip-json-to-string.png](/images/article/jq-zip-json-to-string.png)