```js
$('div[id^="ad-"]') // 匹配id属性以"ad-"开头的div元素
```
[属性名称] 匹配包含给定属性的元素
- [att=value] 匹配包含给定属性的元素 (大小写区分)
- [att*=value] 模糊匹配包含有 value 的原色
- [att!=value] 不能是这个值
- [att^=value] 以 value 开头的所有元素
- [att$=value] 以 value 结尾的所有元素
- [att1][att2][att3]… 匹配多个属性条件中的一个