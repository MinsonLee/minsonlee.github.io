---
layout: post
title: "SEO-你需要知道的搜索小技巧"
date: 2020-05-08
tag: SEO
---

## 背景
一直以来，特别是做 IT 的人都在强调一个问题：提问的智慧。无非就是在强调：描述清楚你的问题背景，简单说清楚你的了解过程和碰到的问题，问清楚你到底想搞懂的点是什么。但是其实在现如今这个发达的网络环境中，你遇到的 80% 问题应该都是有人遇到过一样或类似问题，并在网上发布了答案的。所以很大程度上，你困惑的问题应该都是能通过搜索找到对应的答案才是。因此，比起提问的智慧，我觉得通过网络搜索寻找答案的能力可能更加的重要。

机缘巧合之下，从19年9月中开始接手 `SEO` 的相关工作，持续到20年1月底，打了一场硬仗，苦不堪言...但我也顺利的将公司 `SEO` 监测报告上的原有的 5K 多个错误和每日累增 200+ 的不规范报错给消灭了，其次将站点收录从 2K+ 提升到了 9.8w+。

从觉得 `SEO` 也就是做做关键词和内容展示而已，到了解搜索引擎的原理知识（分词索引），到梳理 `SEO规范`，再到构建 `SEO` 需要的数据中心，到构建海量差异页面和站点地图...等等。

尤其对一个 `SEO` 小白来说，这个过程真是非常漫长而痛苦，而学到的东西无疑是丰富的，期间更是期间将《SEO 实战密码》这本书啃了一大半。尤其是关于搜索技巧这一块，我觉得更是非常实用、通用、值得用的。本文的内容基本也是对看这本书的搜索技巧一块的总结记录。

## 搜索引擎工作原理
搜索引擎的工作过程大致的分为下述三个阶段，而对平常使用搜索的人来说：了解阶段二、通过相关搜索指令辅助应用好阶段三，可以让搜素引擎为我们提供最大可能需要的内容。

三个阶段大致如下：
1. 收集：从站长提供的站点地图、网络上的各种内外链接去持续追踪链接，广度/深度的爬行抓取页面 `HTML` 代码并存储起来

> 此处 SEO 应当关注的是如何吸引和曝光自己的链接


2. 清洗：对抓取回来的内容进行预处理，如：文字提取、**分词**、去重、正向&&倒排索引、权重计算和质量判断...等。此时，搜素引擎就已经具备了可以随时根据用户搜索，准备数据的能力

> 此处 SEO 能关注的是：内容的明确性、丰富性和差异性；用户的友好体验等...尽最大的努力让自己的内容可以被搜索引擎系统“索引”。因为：<font style="background:yellow;">页面“被索引”是页面“被收录”的前提</font>

3. 排名：对用户输入的搜索词进行处理，得到<font style="background:yellow;">以**词**为基础的**关键词集合**</font>，将索引库中所有含有关键词的文件匹配出来，通过热度、相关性等计算得到<font style="background:yellow;">前 N 条记录</font>

> 通常搜索引擎是不会将所有的内容都进行处理返回。因此 SEO 内容的明确性、差异性是尤为重要的，做好了才能展示出来给用户看到。==只有被用户看到的流量才是具备价值的流量，而只有最终能带来赢利的流量才是目标流量==

阶段二和阶段三中都特意加粗了重点 **词**：因为不管是对站点内容，还是用户输入的搜索信息，搜索引擎都会进行的操作就是：对信息进行提取关键词，然后进行分词，最后将匹配度高的展示给你。

而适当的搜索技巧和搜索指令可以让搜索引擎更加明白我们的搜索目的。


## 搜索技巧

### 技巧1：使用“搜词”代替“搜句子”，获得更丰富的答案
搜索引擎的背后是机器在工作而不是人，机器的理解能力天生是比人差的。因此搜索的时候：直接告诉机器你要的关键词是什么，绝大部分情况下是比让机器去理解你要什么再返回这种情况，速度上是要快些，答案会更丰富些的。

例如，你输入：“最近流行的黑人抬棺是什么梗”，可能其实提取出来就是：`黑人抬棺` `梗`
> 因为类似“最近”、“流行”、“是”、“什么” 这类词可能完全没有意义，这类词统称为“停止词”。

![demo-搜索“黑人抬棺”.png](/images/article/seo-demo-keyword.png)

那么与其让搜索引擎在哪瞎猜然后进行关键词提取，倒不如你直接告诉它。

### 技巧2：巧用停止词，过滤语言
早些有相关的权威机构针对搜索浏览习惯，做了一个对比调查。调查显示：英文用户在 Google 上平均 8~10 秒可以找到答案，中文用户在 Google 上则需要 30 秒，在百度上要花 50 秒。

从这一差异可能推断出：
1. 中文搜索比起英文搜索的准确度要低
2. 英文单词之间有空格分隔，比起中文连在一起更利于搜索引擎进行关键词提取和理解

因此我从进入 IT 这行开始就有人跟我说：能用 Google 进行搜索不要用 B 度；能用英文进行搜索尽量用英文...可是，奈何用英文搜的话出来的答案很多都是我看不懂呀。

例如，搜索 IT 行业里面的 `Sphinx`（中文：斯芬克斯）
1. 明显使用英文关键词搜索答案会更准确
2. 通过加一个停止词`的`，过滤一下排序将中文的搜索排在前面
![demo-sphinx中英文搜索结果对比.png](/images/article/seo-demo-keyword-sphinx.png)

### 技巧3：巧用搜索引擎提供的过滤器
很多时候安装了个正版的软件或系统，但是为了去除广告或者无限期试用，我们都会在网上搜素一个可用的破解码或激活码，但是你能想到这么做别人肯定也是这么做...而一个激活码/破解码一般只能用有限次，要是出来旧答案基本都是无效的了...这可咋搞？

利用搜索引擎提供的“设置/setting”可以对答案的收录时间进行过滤。如，搜索一个可用的 `Windows` 激活码，当然是越晚被收录，越晚曝光出来的信息越有价值！

![利用搜索引擎过滤收录时间.gif](/images/article/seo-setting-time-filter.gif)

百度提供的工具栏功能会相对丰富（但在其他搜索引擎中是可以通过高级搜索指令进行过滤的）
![百度搜索工具栏.png](/images/article/seo-setting-filter-baidu.png)

## 高级搜索指令

### 关键词过滤：双引号-完全匹配
前面说到，搜索结果是根据相关度展示的，如果用户输入2个关键词`Windows` `神Key`。那么可以通过**英文状态下的双引号**包起来，那么结果一定就会包含所有的关键词。
和其它搜索技巧要是配合得当，做精准搜索简直如有神助。

![双引号-完全匹配关键词.png](/images/article/seo-filter-double-quotes.png)

### 关键词过滤：减号-屏蔽搜索
例如，我想搜索“父亲”这个关键词，并且我明确的想屏蔽"父亲"这首歌的信息，那么就可以使用该技巧！

![减号-关键词屏蔽.png](/images/article/seo-filter-jianhao.png)

**！！！注意：减号前面必须是空格，减号后面没有空格且紧跟屏蔽词**

### 关键词指定：`intitle:`-标题筛选
一般来说搜索结果会根据文章整篇内容提取的关键词进行匹配。`title` 更应该是一篇文章最核心的体现，因此 SEO 中 Title 也是页面优化的重要因素。

我们可以通过 `intitle:` 指令指定，结果标题中必须包含的字段

![限制关键词在标题中出现.png](/images/article/seo-filter-intitle.png)

若希望标题中含有多个关键词，还可以使用`allintitle:`指令，指令后面跟多组关键词即可，关键词之间使用空格分隔

### 文件类型指定：`filetype:`-搜索特定的文件格式
可以通过`filetype:`对搜索结果的文件格式进行过滤，这一指令用来搜索文档/书籍类资料非常有用！

可以看到 `filetype:pdf` 出来的全部都是 `PDF` 的资料。
百度只支持：`pdf`、`doc`、`xls`、`ppt`、`rtf`、`all`(即：百度所有支持的文件类型，也是默认值)这几种主流的文档类型，而谷歌则支持基本所有能索引的文件格式，如还有：`mobi`，`AZW3`，`EPUB`，`TXT`...等

![搜索结果文件指定.png](/images/article/seo-filter-filetype.png)

### 站点指定：`site:`-搜索指定网站下的内容
利用`site:`可以对搜索结果进行域名指定。

如，想要看一下“搜索引擎”相关的博文，而且已经知道 `博客园-cnblog` 是比较出名的博客优秀博客平台，那么可以就可以通过这个指令进行过滤。

![搜索结果域名限定.png](/images/article/seo-filter-site.png)

但是这个指令只能过滤一个站点出来，却没有像`intitle:`-`allintitle:`这样可以过滤多个站点，实属遗憾，是吧？