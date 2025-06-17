---
layout: post
title: "SEO：通过 IndexNow 向 Bing 推送站点链接"
date: 2025-06-17
tags: [seo]
---

# SEO：通过 IndexNow 向 Bing 推送站点链接

[TOC]

## 背景

最近在写 `Java`，其中 `MongoDB` 中存了某个文档数据，「**如果存在**」结构是如下这样：

```json
{
    "localtion":{
        "pickup":{
            "region":{
                "region_en":"China"
            }
        }
    }
}
```

现在需要判断如果 `region_en` 有值就拿出来，在 `PHP` 中用 `empty()` 函数处理即可：

```php
$regionEn = '';
if(!empty($carDetail['location']['pickup']['region']['rengion_en'])) {
    $regionEn = $carDetail['location']['pickup']['region']['rengion_en'];
}
```

由于刚开始写 `Java` 时没有留意，写 `carDetail.getLocation().getPickup().getRegion().getRegionEn()` 经常会报 `NullPointExceptions`（很多`Java`文章会称其为`NPE`）.

改为：

```java
String regionEn = "";
if(
    carDetail != null 
    && carDetail.getLocation() != null 
    && carDetail.getLocation().getPickup() != null 
    && carDetail.getLocation().getPickup().getRegion().getRegionEn() != null
) {
    regionEn = carDetail.getLocation().getPickup().getRegion().getRegionEn();
}
```

或者有其他逻辑需要处理那么可能是此类嵌套判断 `NPE` 的情况：

```java
String regionEn = "";
if(carDetail != null) {
    // 其他逻辑
    if(carDetail.getLocation() != null) {
        // 其他逻辑
        if(carDetail.getLocation().getPickup() != null) {
            // 其他逻辑
            regionEn = carDetail.getLocation().getPickup().getRegion().getRegionEn() != null 
                ? carDetail.getLocation().getPickup().getRegion().getRegionEn() 
                : "";
        }
    }
}
```

在 `Java8` 中引入 [`java.util.Optional` 工具类](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html) 可以相对简洁的处理这种因为微软是 `ChatGPT` 的大投资人，`AI` 搜索虽然还没有非常好的一个模式，但是是一个必然趋势。但站点在 `Bing` 上的收录数据在 [Bing Webmaster Tool](https://www.bing.com/webmasters/home) 看到不是很乐观。因此想通过 `IndexNow` 接口提交一次链接，触发 `Bing` 重新抓取一次，看看能否提高站点内容再 Bing 搜索或 ChatGPT AI 搜索结果中的可见性，从而提高流量。

## IndexNow

页面 [How to add IndexNow to your website | Bing Webmaster Tools](https://www.bing.com/indexnow/getstarted) 中提到推荐使用 `IndexNow` 来向其推送站点的链接。

[`IndexNow.org`](https://www.indexnow.org/index) 中提到 `IndexNow` 是一个面向搜索引擎的简单协议(`Simple ping`)，用于告知搜索引擎对应 `URL` 及其内容已被添加、更新或删除，从而帮助搜索引擎优先处理这些 `URL`，使对应搜索引擎能在其搜索结果中快速反映对应 URL 的结果。

因为如果不用 `IndexNow`，那么站点内容变更之后，就只能变更站点地图，然后去搜索引擎管理控制台删除重新提交一次站点地图。传统方式的弊端明显：「针对性不足、浪费抓取值」 - 搜索引擎只能被动全部爬取站点地图链接，及时 URL 对应的页面内容没有变化也会被重新的爬取检查...

理念确实是蛮好的，但是...发现只有 `Bing/Naver/Seznam.cz/Yandex/Yep` 寥寥几家搜索引擎组织接入了。`Naver` 是一个韩语搜索引擎（类似“百度”于中国而言），大头的搜索引擎就 `Bing` 一家，有些可惜。

对应搜索引擎的 `IndexNow` 接口地址，可以通过 [https://www.indexnow.org/searchengines.json](https://www.indexnow.org/searchengines.json) 地址获取。或查看文档：[Documentation for search engines | IndexNow.org](https://www.indexnow.org/searchengines)。更多使用上的 FAQ 可以查看官方文档：[FAQ | IndexNow.org](https://www.indexnow.org/faq)

## Bing IndexNow 接入

1. 去 `https://www.bing.com/indexnow/getstarted` 页面下载一个 `IndexNow` 密钥文件（随机的 32 位字符串），上传到站点项目根目录。验证 `https://www.example.com/xxx.txt` 能否访问
2. 向对应 `https://<searchengine>/indexnow` 接口提交 `URL`
    - `Get` 请求提交单条链接：`https://<searchengine>/indexnow?url=<url>&key=xxxxx&keyLocation=https://www.example.com/xxx.txt`
    - `POST` 请求批量提交如下：`https://<searchengine>/indexnow?key=xxxxx&keyLocation=https://www.example.com/xxx.txt`

```
POST /indexnow HTTP/1.1
Content-Type: application/json; charset=utf-8
Host: <searchengine>
{
  "host": "www.example.com",
  "key": "7b1f89baa1204612a933816dce46bcbf",
  "keyLocation": "https://www.example.com/myIndexNowKey63638.txt",
  "urlList": [
      "https://www.example.com/url1",
      "https://www.example.com/folder/url2",
      "https://www.example.com/url3"
      ]
}
```

### 注意事项

1. 首次请求的时候，可能会报 403 错误，跟你配置没有任何关系，等一段时间，重新请求即可

```json
{
    "code": "SiteVerificationNotCompleted",
    "message": "Site Verification is not completed. Please wait for some time for the verification to complete and try again.""
}
```

2. **如果提交成功，`indexnow` 接口是通过 `HTTP Code` 是否为 200 来判断的。没有任何响应 `body`**

```
HTTP/2 200
Cache-Control: no-cache
Pragma: no-cache
Expires: -1
X-AspNet-Version: 4.0.30319
X-Powered-By: ASP.NET
X-Cache: CONFIG_NOCACHE
Accept-CH: Sec-CH-UA-Arch, Sec-CH-UA-Bitness, Sec-CH-UA-Full-Version, Sec-CH-UA-Full-Version-List, Sec-CH-UA-Mobile, Sec-CH-UA-Model, Sec-CH-UA-Platform, Sec-CH-UA-Platform-Version
X-MSEdge-Ref: Ref A: D4365A3C600C4724A380EDCD7DF5DD4B Ref B: HKBEDGE0912 Ref C: 2025-06-17T06:07:42Z
Date: Tue, 17 Jun 2025 06:07:46 GMT
Content-Length: 0
```

3. 如何验证真的提交成功了呢？

提交后，等待一小会儿，登录 [`Bing Webmaster Tool`](https://www.bing.com/webmasters/indexnow?siteUrl=https://<yourHost>/)（如果已经登录，记得刷新一下页面），切换对应站点。点击菜单栏中 `IndexNow`  即可看见今天提交的链接：

![Bing IndexNow](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20250617153744.png)

## 抓取测试结果

提交结果之后大约 1 分钟左右，Bing 确实是来站点进行了抓取，但 `ChatGPT` 抓取频率没有什么显著变化

![IndexNow Submit Result](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20250617155827.png)