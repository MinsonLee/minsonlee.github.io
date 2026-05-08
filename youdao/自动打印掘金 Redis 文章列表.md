掘金 Redis 文章

```javascript
var elements = document.getElementsByClassName("title");
var length = elements.length;
var tagArr = [];
var markdown = [];
for (let i = 0; i < length; i++) {
    if (elements[i].tagName === "A") {
        tagArr[tagArr.length] = elements[i];
        if (elements[i].innerText.search("Redis") != -1) {
            var tempText = "- [" + elements[i].innerText + "](" + elements[i].href + ")";
            console.log(tempText);
            markdown[markdown.length] = tempText;
        }
    }
}
console.dir(markdown);
```