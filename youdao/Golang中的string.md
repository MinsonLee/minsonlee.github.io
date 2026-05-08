1、golang 的字符串是一个字节数组

```golang
// string is the set of all strings of 8-bit bytes, conventionally but not
// necessarily representing UTF-8-encoded text. A string may be empty, but
// not nil. Values of string type are immutable.
type string string
```

string 是所有8位字节的字符串的集合，习惯上但不一定代表UTF-8编码的文本。一个字符串可以是空的，但不能为 nil。字符串类型的值是不可改变的（只读数组）。

```golang
package main

import (
        "fmt"
        "unsafe"
)

func main() {
    a := "hello"
    for _, letter := range a {
        fmt.Printf("%v %T %v\n", letter, letter, unsafe.Sizeof(letter) )
    }
    fmt.Printf("%v\n", unsafe.Sizeof(a))
}

```

```shell
/home/src/go-test # go run string.go
104 int32 4
101 int32 4
108 int32 4
108 int32 4
111 int32 4
16
```


2、为什么 unsafe.Sizeof(string) 总是输出 16？


- https://blog.csdn.net/li_101357/article/details/80240453
- https://gocn.vip/topics/628
- https://blog.thinkeridea.com/201902/go/string_ye_shi_yin_yong_lei_xing.html
- https://draveness.me/golang/docs/part2-foundation/ch03-datastructure/golang-string/
- https://chai2010.gitbooks.io/advanced-go-programming-book/content/ch1-basic/ch1-03-array-string-and-slice.html
- https://studygolang.com/articles/30982
- https://blog.golang.org/strings
- https://studygolang.com/articles/27592
- https://blog.csdn.net/skh2015java/article/details/53258249
- https://blog.haohtml.com/archives/18473
- 