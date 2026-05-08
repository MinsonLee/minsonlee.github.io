# Shell实战-文本处理-sed

[TOC]

## 去除字符串空格

```shell
# sed 默认用 / 做分隔符，但其实是支持指定任意分隔符的，若替换的问题中含有 / 则可以指定其他字符做分隔符（如：#|,）
cat changes_link.md | sed 's, ,,g'
```

- sed -i "s/xxx/ss/g" 替换并更改源文件
- sed -e "s/xxxx/xxx/g' 替换输出

## 替换换行符

- [sed 命令替换换行符](https://my.oschina.net/shelllife/blog/118337)

`sed ':label;N;s/\n/,/;t label' filename` 或 `sed ':label;N;s/\n/,/;b label' filename`

- `:label` 设置标签，用来实现跳转处理，名字可以随便取不一定非要叫 `label`
- `N` 是 `sed` 的一个处理命令，追加文本流中的下一行到模式空间进行合并处理，即：换行符可见
- `s/\n/,/` : `s` 是替换命令，将换行符替换为逗号
- `b label` 或 `t label` 中，`b/t` 表示跳转到指定的标签
