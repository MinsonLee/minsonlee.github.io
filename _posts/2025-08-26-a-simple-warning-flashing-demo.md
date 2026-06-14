---
layout: post
title: 简单的告警闪烁效果
date: 2025-08-26
tags: [HTML]
---

后台一些功能，经常一些选项发生变更之后其联动数据需要产品二次确认。然后...没有确认，导致错误添加一些翻译任务数据，又来找开发进行手动数据处理。为防止这种“老花眼”现象...做了一个简单的告警闪烁。

效果如下：

![warning flashing](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/warning-demo.gif)

后台非常老旧...所以用原生的 `JS` 进行了简单实现，记录一下：

```javascript
// 闪烁函数
function flash(id, count, originalColor) {
    if (count <= 0) return; // 闪烁3次后停止
    console.log(count);

    document.getElementById(id).style.backgroundColor = '#ff0000';
    setTimeout(() => {
        // 恢复原始颜色
        document.getElementById(id).style.backgroundColor = originalColor;
        setTimeout(() => {
            flash(id, count-1, originalColor); // 递归调用
        }, 500); // 原始颜色持续500ms
    }, 500); // 红色持续500ms
}

// 调用案例：闪烁 3 次
flash("lang_str", 3, document.getElementById('lang_str').style.backgroundColor);
```