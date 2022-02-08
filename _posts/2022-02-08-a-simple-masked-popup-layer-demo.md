---
layout: post
title: 简易遮罩弹窗层+JSON美化
date: 2022-02-08
tags: [HTML, JSON]
---

一些后台系统，需要后端人员兼职前端进行一些简易的实现，年后回来针对年前 JSON 字符串的展示做了小小改动，效果如下：

![show json pretty](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20250716161423.png)

由于类似效果已多次使用，特此记录作为备份。

样式文件 `test.css` 如下：

```css
/*定义表格边框*/
table,tr,th, td {
    border: 1px solid;
}
thead th {
    background-color: green;
}
/*遮罩层样式*/
.shadow{
    position:fixed;
    z-index:998;/*定义层级*/
    width:100%;
    height:100%;
    left:0;
    top:0;
    background-color:#000;
    opacity:0.6; /*设置不透明度*/
    display:none;
}

/*定义弹窗*/
.insurance_request_box{
    /*
     * 定义绝对固定定位：https://developer.mozilla.org/zh-CN/docs/Web/CSS/position；
     * absolute 相对整个文本流进行绝对定位；
     * fixed 相对窗口进行绝对定位
     */
    position:fixed;
    z-index:999; /*定义层级，注意：要比遮罩高*/
    width:50%;
    max-height:70%;
    overflow-y: auto;
    margin:5% auto;
    left:25%;
    top:5%;
    padding:28px;
    border:1px #111 solid;
    background-color: #fff;
    display:none;            /* 默认对话框隐藏 */
}
/*定义弹窗关闭按钮*/
.insurance_request_box .x{ 
    font-size:18px; 
    text-align:right; 
    display:block;
}
/*定义 pre 标签格式化展示样式*/
.insurance_request_box pre{
    width:80%; 
    font-size:18px; 
    margin-top:18px;
}
```

JavaScript 文件 `test.js` 如下：

```javascript
function msgbox(obj,n){
    /*关闭弹窗时，置空弹窗中的内容*/
    var title = document.getElementById('insurance_request_title');
    var content = document.getElementById('insurance_request');
    if(n == 0) {
        title.innerText = content.innerText = "";
        document.getElementsByClassName("insurance_request_box")[0].style.display = 'none';
        document.getElementsByClassName("shadow")[0].style.display = 'none';
        return false;
    }

    /*没有报文*/
    var order_id = obj["dataset"]["id"];
    var request_data = obj["dataset"]["text"];
    if(request_data == '') {
        request_data = "订单 "+ order_id + " 未向xxx发起请求，暂无报文！";
        alert(request_data); // 控制台：[Violation]'click' handler took xxxxms https://segmentfault.com/q/1010000038411154
        return false;
    }
    
    /*存在报文*/
    document.getElementsByClassName("insurance_request_box")[0].style.display = 'block';
    document.getElementsByClassName("shadow")[0].style.display = 'block';
    title.innerText = order_id + " 报文如下："
    content.innerText = JSON.stringify(JSON.parse(request_data), null, 4);
    /*window.scrollTo(0, document.documentElement.clientHeight);*/ // 自动滑到页面底部，显示报文
    return true;
}
```

HTML 文件如下：

```html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="./test.css">
<title>简易遮罩弹窗层+JSON美化</title>
<style></style>
</head>
<body>
<!-- 测试数据 -->
<table>
    <thead>
        <tr>
            <th>序号</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1</td>
            <!-- https://stackoverflow.com/questions/7755088/what-does-href-expression-a-href-javascript-a-do -->
            <td align="center"><a href="javascript:;" onclick="msgbox(this,1);" data-text='{"errcode":"suc","errmsg":"ok","guid":"test","run_time":2.68,"data":{"quotations":{"trans_id":"test","serial_number":"ste"},"policy":{"policy_no":"test","currency":"6","total_premium":"8.00","status":"1","policy_file":"","batch":[{"trans_id":"test","batch_no":"test","premium":"8.00"}]}}}' data-id="test_order_1_axa_insurance">查看报文</a></td>
        </tr>
        <tr>
            <td>2</td>
            <td align="center"><a href="javascript:;" onclick="msgbox(this,1);" data-text='' data-id="test_order_2_axa_insurance">查看报文</a></td>
        </tr>
    </tbody>
</table>

<!-- 定义遮罩弹窗 -->
<div class="shadow" onclick="msgbox(null,0)"></div>
<div class='insurance_request_box'>
    <a class='x' onclick="msgbox(null,0)">关闭</a>
    <span id="insurance_request_title"></span>
    <!-- 注意：此处要用 pre 标签来展示，如果用 div 或 p 标签展示格式化后的 JSON 空格是会被缩减的 -->
    <pre id="insurance_request"></pre>
</div>
</body>
<script type="text/javascript" src="./test.js"></script>
</html>
```

## 扩展阅读的问题

**1. `position:fixed` 和 `position:absolute` 有什么区别？**

`position:fixed` 和 `position:absolute` 都是用于元素绝对定位的属性，使用它们会导致元素会被移出正常文档流，并不为元素预留空间。

- `absolute` 通过指定元素相对于最近的非 static 定位祖先元素的偏移，来确定元素位置。
- `fixed` 通过指定元素相对于屏幕视口（viewport）的位置来指定元素位置，元素的位置在屏幕滚动时不会改变。

**即：在没有滚动条的情况下两者其实没有差异，但是在有滚动条后，fixed始终会在定好的位置不动，而absolute会随参照对象元素的宽高变化为移动。**

**2. JavaScript 的 onclick 事件报：`[Violation]'click' handler took xxxms`**

无意间发现了这个报错信息，一开始以为是在 onclick 事件中用了什么导致，后来直接 `onclick="alert(111);"` 发现也有这个问题，查了一些网上信息得到了原因：alert 阻塞了 click 事件的执行，导致事件渲染事件过长，浏览器自身的机制觉得当前的 click 事件耗时太长，所以给个警告，当我们把 alert 换成 console.log 或 alter 事件触发后立即迅速点击 Enter 键，该警告信息就不会出现了。

**3. a 标签中的 href="javascript:somefunc(this);" 是无法传递 this 对象的，href 希望的是用户将其传递一个链接信息。详细可阅读：[`What does href expression <a href="javascript:;"></a> do?`](https://stackoverflow.com/questions/7755088/what-does-href-expression-a-href-javascript-a-do)**

**4. HTML 显示 JSON 字符串并且进行格式化**
    - HTML 要用 `pre` 标签进行展示，如果用 div 或 p 标签展示格式化后的 JSON 空格是会被缩减的
	- 转换JSON字符串，要先用 JSON.parse() 转换为 JSON 对象，然后再使用 JSON.stringify() 进行格式化
