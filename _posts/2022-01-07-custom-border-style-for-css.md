---
layout: post
title: CSS 定义 border 样式
date: 2022-01-07
tags: [前端,CSS]
---

一条波浪线，难倒一个后端汉。今天要写一点前端样式，结果发现 HTML 的 `border-style` 只能订制：`node` - 无边框 、 `solid` - 实线、 `double` - 双实线、 `dotted` - 点虚线 、 `dashed` - 虚线。如何实现一个双虚线、波浪线的边框呢？查找研究了一番，记录一下。


## 双虚线

双虚线的样式比较好实现，样式代码如下：

```css
/*双虚线*/
.border-double-dashed {
  border-top:2px dashed #000;
  border-bottom:2px dashed #000;
  height:5px;
  width: 100%;
}
```

展示效果：

<div style="border-top:2px dashed #000;border-bottom:2px dashed #000; height:5px; width: 100%;"></div>

## 波浪线

波浪线的样式确实是搞死了我，整了近一个小时才弄出来。本来想通过`border-image`的方式弄个波浪线，奈何没有设计支持。最终实现如下：通过两条交叉线只展示一半达到该效果。

即：

<div style="width: 100%;height: 16px;background-size: 16px 16px;background-repeat: repeat-x;background-image: linear-gradient(135deg, transparent 45%, black 55%, transparent 60%), linear-gradient(45deg, transparent 45%, black 55%, transparent 60%);"></div>

修改为：

<div style="width: 100%;height: 8px;background-size: 16px 16px;background-repeat: repeat-x;background-image: linear-gradient(135deg, transparent 45%, black 55%, transparent 60%), linear-gradient(45deg, transparent 45%, black 55%, transparent 60%);"></div>

```css
/*波浪线：利用两条*/
.border-wave {
  width: 100%;
  height: 5px;
  background-size: 10px 10px;
  background-repeat: repeat-x;
  background-image: linear-gradient(135deg, transparent 45%, black 55%, transparent 60%),
  linear-gradient(45deg, transparent 45%, black 55%, transparent 60%);
}
```

