期望：阅读文章做一些摘抄时，希望将文章的标题、链接复制为 `markdown` 结构

```html
<button class="btn-for-copy-markdown" onclick="javascript:copyContent()">Copy with markdown!</button>
```

```css
.btn-for-copy-markdown {
  background: #eb94d0;
  /* 创建渐变 */
  background-image: -webkit-linear-gradient(top, #eb94d0, #2079b0);
  background-image: -moz-linear-gradient(top, #eb94d0, #2079b0);
  background-image: -ms-linear-gradient(top, #eb94d0, #2079b0);
  background-image: -o-linear-gradient(top, #eb94d0, #2079b0);
  background-image: linear-gradient(to bottom, #eb94d0, #2079b0);
  /* 给按钮添加圆角 */
  -webkit-border-radius: 28;
  -moz-border-radius: 28;
  border: 0px;
  border-radius: 28px;
  text-shadow: 3px 2px 1px #9daef5;
  -webkit-box-shadow: 6px 5px 24px #666666;
  -moz-box-shadow: 6px 5px 24px #666666;
  box-shadow: 6px 5px 24px #666666;
  font-family: Arial;
  color: #fafafa;
  font-size: 16px;
  padding: 5px;
  text-decoration: none;
  z-index: 9999;
  position: fixed;
}
/* 悬停样式 */
.btn-for-copy-markdown:hover {
  background: #2079b0;
  background-image: -webkit-linear-gradient(top, #2079b0, #eb94d0);
  background-image: -moz-linear-gradient(top, #2079b0, #eb94d0);
  background-image: -ms-linear-gradient(top, #2079b0, #eb94d0);
  background-image: -o-linear-gradient(top, #2079b0, #eb94d0);
  background-image: linear-gradient(to bottom, #2079b0, #eb94d0);
  text-decoration: none;
}
```

完整  `JavaScript` 代码如下：

```javascript
// 添加自定义 CSS 样式
function addNewStyle(newStyle) {
    var styleElement = document.getElementById('styles_js');
    if (!styleElement) {
        styleElement = document.createElement('style');
        styleElement.type = 'text/css';
        styleElement.id = 'styles_js';
        document.getElementsByTagName('head')[0].appendChild(styleElement);
    }
    styleElement.appendChild(document.createTextNode(newStyle));
};

// 复制文本
function copyContentForMarkdown() {
    var text = "- [" + document.title + "](" + window.location.href + ")";
    // navigator clipboard 需要 https 或 本地访问 等安全上下文才可使用
    if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(text).then(function() {
            alert('Text successfully copied to clipboard');
        }).catch(function(err) {
            alert('error!');
        });
    } 
    // http 非安全上下文，使用 document.execCommand
    else {
        let textArea = document.createElement("textarea");
        textArea.value = text;
        textArea.style.position = "absolute";
        textArea.style.opacity = 0;
        textArea.style.left = "-999999px";
        textArea.style.top = "-999999px";
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        return new Promise((res, rej) => {
            document.execCommand('copy') ? alert('Text successfully copied to clipboard') : alert('error!');
            textArea.remove();
        });
    }
};

// 添加 button 元素
function createCopyBtn() {
    var button = document.createElement("button");
    button.innerText = "Copy with markdown!";
    button.className = "btn-for-copy-markdown";
    button.id = "btn-for-copy-markdown";
    document.getElementsByTagName("body")[0].prepend(button);
    document.getElementById("btn-for-copy-markdown").setAttribute("onclick", "javascript:copyContentForMarkdown()");
};

// 调用
document.onload = function() {
    var btn = document.getElementById("btn-for-copy-markdown");
    if (!btn) {
        var css = '.btn-for-copy-markdown {background: #eb94d0; background-image: -webkit-linear-gradient(top, #eb94d0, #2079b0); background-image: -moz-linear-gradient(top, #eb94d0, #2079b0); background-image: -ms-linear-gradient(top, #eb94d0, #2079b0); background-image: -o-linear-gradient(top, #eb94d0, #2079b0); background-image: linear-gradient(to bottom, #eb94d0, #2079b0); -webkit-border-radius: 28; -moz-border-radius: 28; border: 0px; border-radius: 28px; text-shadow: 3px 2px 1px #9daef5; -webkit-box-shadow: 6px 5px 24px #666666; -moz-box-shadow: 6px 5px 24px #666666; box-shadow: 6px 5px 24px #666666; font-family: Arial; color: #fafafa; font-size: 16px; padding: 5px; text-decoration: none; z-index: 9999; position: fixed; } .btn-for-copy-markdown:hover {background: #2079b0; background-image: -webkit-linear-gradient(top, #2079b0, #eb94d0); background-image: -moz-linear-gradient(top, #2079b0, #eb94d0); background-image: -ms-linear-gradient(top, #2079b0, #eb94d0); background-image: -o-linear-gradient(top, #2079b0, #eb94d0); background-image: linear-gradient(to bottom, #2079b0, #eb94d0); text-decoration: none; }';
        addNewStyle(css);
        createCopyBtn();
    } else {
        btn.style.display == "none" ? btn.style.display = "block": btn.style.display = "none";
    }
}();
```

- [剪贴板操作 Clipboard API 教程 - 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2021/01/clipboard-api.html)


--------

一开始使用 `navigator.clipboard` 的时候，必须要创建一个元素，然后通过点击才可以调用，否则会报错 `DOMException: Document is not focused.`

发现调用 `document.execCommand("copy")` 可以直接跳过这一设置，代码简化如下：

```javascript
document.onload = function() {
    var text = "- [" + document.title + "](" + window.location.href + ")";
    let textArea = document.createElement("textarea");
    textArea.value = text;
    textArea.style.position = "absolute";
    textArea.style.opacity = 0;
    textArea.style.left = "-999999px";
    textArea.style.top = "-999999px";
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    return new Promise((res, rej) => {
        document.execCommand('copy') ? alert('Text successfully copied to clipboard') : alert('error!');
        textArea.remove();
    });
}();
```