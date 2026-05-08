1. http://www.webkaka.com/tutorial/zhanzhang/
2. https://support.google.com/webmasters/answer/70897?hl=zh-Hans
3. SEO-URL规范：http://www.muziwl.com/news/seo/159.html
4. 谷歌搜索引擎优化初学者指南：https://pan.baidu.com/s/1nv3Igqd
5. SEO-URL规范：https://zhuanlan.zhihu.com/p/27689264
6. Ahrefs博客：https://ahrefs.com/blog/zh/
7. 网站地图 Sitemap：https://park.mobayke.com/tools/for-sitemap.html
8. 搜尋引擎最佳化 (SEO) 入門指南：https://support.google.com/webmasters/answer/7451184?hl=zh-Hant
9. GOOGLE 提示 "已发现 - 尚未编入索引" 怎么办：http://www.zhidaow.com/post/google-discovered-but-currently-not-indexed
10. 未来的SEO：移动优先索引：https://www.seozac.com/mobile-seo/mobile-first-index/
11. 我以前在阿里巴巴的流量方法论：https://mp.weixin.qq.com/s?__biz=MzU2Mjc2NTEyMQ==&mid=2247483782&idx=1&sn=e8599720672b82ebccfab66278c52829&chksm=fc65cda8cb1244befaab93744d6f9165aad11f0ced128c6f060b0a91896a69cd5cca6933d16c&mpshare=1&scene=1&srcid=1120ijhcMe2PlSBaMOQLfc2t&sharer_sharetime=1574239777585&sharer_shareid=cfcd208495d565ef66e7dff9f98764da#rd
12. [Technical SEO Archives - SEO分解茶](https://www.seo-tea.com/technical-seo/)
13. [SEO每天一贴 - 最古老的SEO优化技术博客](https://www.seozac.com/)
14. [蝙蝠侠IT - 专注SEO与网络营销推广的自媒体博客](https://www.batmanit.com/)
15. [关于改进 SEO 的文档 | Google 搜索中心  |  Google for Developers](https://developers.google.com/search/docs?hl=zh-cn)
16. [SEO|ASO|ORM - 搜索营销与策略](https://seoasoorm.com/zh/)


------------

1. 如果是分页 `SEO` 的 `title/description` 要加上分页数据，避免多个页面 `title/description` 重复

`TDK` 是网页 `SEO` 的重要信息（`Keyword` 现在主键被废弃）

Title | Description
------|------------
Car Rental Customer Reviews - Page {页码} \| QeeQ.com | Page {页码}： customer reviews with photos on car rental companies, including ratings in terms of vehicle codition, customer service, pickup/drop-off efficiency, and overall driving experiences.


2. `PC`端所有页面都要添加`canonical`标记指向自己

```html
<link rel="canonical" href="https://www.easyrentcars.com/locations/airports/car-rental-tampa-airport">
```

3. 前端图片被隐藏

- 前端避免图片被隐藏在 CSS 样式中没有办法全部被蜘蛛读取到（在蜘蛛看来，图片是完全展开出来没有被折叠的），直接写 `<img>` 标签，而不通过 `css` 的 `background` 属性来处理图片
- 为了内容能被多种浏览器蜘蛛识别爬取，元素尽量用 `div/span` 这些原生`html`标签，少用 `html5` 的新标签

4. 分页代码

- [Google 分页最佳做法 | Google 搜索中心  |  文档  |  Google for Developers](https://developers.google.com/search/docs/specialty/ecommerce/pagination-and-incremental-page-loading?hl=zh-cn)
- 有翻页功能的页面需要添加 `pagination` 代码，否则非常容易给蜘蛛造成困惑，影响页面收录。

> 过去，Google 使用 <link rel="next" href="..."> 和 <link rel="prev" href="..."> 识别下一页和上一页的关系。Google 已不再使用这些标记，但其他搜索引擎可能仍在使用这些链接。

```html
// 例如：page1 页面
<link rel="next" href="...">

// 例如：page2 页面
<link rel="next" href="...">
<link rel="prev" href="...">
 
// 例如：最后1页
<link rel="prev" href="...">
```

5. 内链要闭环
6. 数据量要多

------------

## Hreflang 标签
- [Hreflang：初学者的简易指南](https://ahrefs.com/blog/zh/hreflang-tags/)

## 抓取-入编-索引-收录问题


- [如何修复 "已发现 - 尚未编入索引"](https://ahrefs.com/blog/zh/discovered-currently-not-indexed/)
- [大量已发现 尚未编入索引的页面 - Google 搜索中心社群](https://support.google.com/webmasters/thread/167516263/%E5%A4%A7%E9%87%8F%E5%B7%B2%E5%8F%91%E7%8E%B0-%E5%B0%9A%E6%9C%AA%E7%BC%96%E5%85%A5%E7%B4%A2%E5%BC%95%E7%9A%84%E9%A1%B5%E9%9D%A2?hl=zh-hans)
- [如何分析与解决Google 中的“已抓取– 尚未编入索引”](https://seoasoorm.com/zh/crawled-not-currently-indexed/)