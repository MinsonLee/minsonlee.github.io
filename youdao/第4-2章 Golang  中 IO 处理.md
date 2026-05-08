#  fmt 中的 I/O 交互函数
[TOC]

## `fmt`包介绍
> 手册链接：https://golang.org/pkg/fmt

`fmt` 包中的函数在 Golang 中用于格式化 I/O。核心功能包含两个方面：打印输出、扫描输入；
正如手册介绍的一样，`fmt`整个包中的函数就是实现了类似 C 语言函数中的 `print` 和 `scanf` 两个函数。
格式化参数形式沿袭了 C 语言的风格（如: `%d`表示十进制整数占位），但比 C 语言要简单。
> Package fmt implements formatted I/O with functions analogous to C's printf and scanf. The format 'verbs' are derived from C's but are simpler.

## `O-Output` 输出
> 将内存中的信息打印到终端设备上

### 标准输出：`Print` 函数
`func Print(a ...interface{}) (n int, err error)` 
- 作用：写入标准输出：可接收多个参数，参数间通过`,`隔开，将参数值写入到标准输出时。
- 返回：写入标准输出的字节数；遇到的任何错误
- 注意：==若输出的两个相邻的参数都不是字符串，会在它们的输出之间添加空格==
```golang
package main
import (
    "fmt"
)

func main() {
    const name, age = "Kim", 22
    fmt.Print(name, " is ", age, " years old.\n") // Kim is 22 years old.
    
    // 若输出的两个相邻的参数都不是字符串，会在它们的输出之间添加空格
    fmt.Print(name, name) // KimKim
    fmt.Print(age, age) // 22 22
}
```

### 标准输出：`Println` 函数
`func Println(a ...interface{}) (n int, err error)` 
- 作用：写入标准输出：可接收多个参数，参数间通过`,`隔开，将参数值写入到标准输出时。
- 返回：写入标准输出的字节数；遇到的任何错误
- 注意：==①.与`Print()`不同的是，该函数总是会在输出的两个相邻的参数输出之间添加空格;②.输出结束后添加换行符==
```golang
package main
import (
    "fmt"
)

func main() {
    const name, age = "Kim", 22
    fmt.Println(name, "is", age, "years old.\n") // Kim is 22 years old.
}
```

### 格式化标准输出：`Printf` 函数
`func Printf(format string, a ...interface{}) (n int, err error)` 
- 作用：根据`format`定义的格式进行格式化字符串并写入到标准输出
- 返回：写入标准输出的字节数；遇到的任何错误
```golang
package main
import (
    "fmt"
)

// 定义一个结构体，用于存储个人资料
type Profile struct {
   name string
   age int
   gender uint8 // 0-保密；1-男；2-女
}

func main() {
    const name, age = "Kim", 22
    fmt.Printf("%s is %d years old.\n", name, age) // Kim is 22 years old.
    
    XiaoMing := Profile{name:"小明",age:20, gender:1}
    fmt.Printf("%#v\n", XiaoMing) // main.Profile{name:"小明", age:20, gender:0x1}
    fmt.Printf("%+v\n", XiaoMing) // {name:小明 age:20 gender:1}
    fmt.Printf("%v\n", XiaoMing) // {小明 20 1}
}
```

## `I-Input` 输入
> 从终端设备接收信息，输入到内存中

### 标准输入：`Scan` 函数-空格分隔
`func Scan(a ...interface{}) (n int, err error)` 
- 作用：Scan从标准输入扫描文本，==将连续的以空格分隔的值存储到连续的参数中==
- 返回：成功扫描的条目个数和遇到的任何错误
- 注意：换行符在扫描标准输入时候会被视为空白分隔符处理。==即：输入可以通过空白分隔符写在同一行，也可以多行进行输入==
```golang
package main
import (
    "fmt"
)

func main() {
    var (
        name string
        age int
        married bool
    )
    fmt.Println("请输入：姓名 年龄 是否婚配，并以空格进行分隔输入")
    fmt.Scan(&name,&age,&married)
    fmt.Printf("扫描结果 name:%s age:%d married:%t\t",name,age,married)
}
```

假定上述go代码文件为：`hello.go`

```sh
$ go run hello.go
请输入：姓名 年龄 是否婚配，并以空格进行分隔输入
LMS 22 false
扫描结果 name:LMS age:22 married:false
```

### 标准输入：`Scanln` 函数-换行符输入
2. `func Scanln(a ...interface{}) (n int, err error)` 
- 作用：类似Scan，但==遇到换行符会停止**当次扫描**==(调用一次，扫描一次)
- 返回：写入标准输出的字节数；遇到的任何错误
- 注意：最后一个条目后必须有换行或者到达结束位置
```golang
package main
import (
    "fmt"
)

func main() {
    var (
        name string
        age int
        married bool
    )
    fmt.Println("请输入姓名")
    fmt.Scanln(&name)
    fmt.Println("请输入年龄")
    fmt.Scanln(&age)
    fmt.Println("请输入是否婚配")
    fmt.Scanln(&married)
    
    fmt.Printf("扫描结果 name:%s age:%d married:%t\t",name,age,married)
}
```

假定上述go代码文件为：`hello.go`

```sh
$ go run hello.go
请输入：姓名 年龄 是否婚配，并以空格进行分隔输入
小王子
22 
false
扫描结果 name:小王子 age:22 married:false
```

### 格式化标准输入：`Sscanf` 函数
`func Sscanf(str string, format string, a ...interface{}) (n int, err error)` 
- 作用：从字符串str扫描文本，根据 format 指定的格式将成功读取的空白分隔的值保存并成功传递给本函数的参数
- 返回：写入标准输出的字节数；遇到的任何错误
```golang
package main
import (
    "fmt"
)

func main() {
    var (
        name string
        age int
        married bool
    )
    fmt.Scanf("1:%s 2:%d 3:%t",&name, &age, &married)
    fmt.Printf("扫描结果 name:%s age:%d married:%t\t",name,age,married)
}
```

假定上述go代码文件为：`hello.go`

```sh
$ go run hello.go
请输入：姓名 年龄 是否婚配，并以空格进行分隔输入
1:小王子 2:23 3:false
扫描结果 name:小王子 age:22 married:false
```

## `format` 操作有那些？
![image](5754B076E2A04ABB8D17DF242B31B78F)



## 拓展阅读
- [什么是标准输入，标准输出(stdin,stdout)？](https://segmentfault.com/a/1190000018650023)
- [linux重定向标准输入后，再重新打开标准输入为什么会失效？](https://segmentfault.com/a/1190000018650276)
- [I/O复用函数select,poll,epoll到底啥区别？](https://segmentfault.com/a/1190000018634619)
- [golang之fmt.Scan获取标准输入](http://www.361way.com/golang-fmt-scan/6240.html)
- [How to flush Stdin after fmt.Scanf() in Go?](https://stackoverrun.com/cn/q/3962523)
- [在Golang中刷新stdin缓冲区？](https://mlog.club/article/294299)
