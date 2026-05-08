1、error 接口：Go语言通过内置的错误类型接口提供了非常简单的错误处理机制

```golang
// buildin.go error
// The error built-in interface type is the conventional interface for
// representing an error condition, with the nil value representing no error.
type error interface {
	Error() string
}
```

Go 语言的函数/方法支持**多返回值**，如果一个函数/方法需要返回一个 error 错误值，一般来说：**error 错误值必须作为最后一个返回值**。例如：
`func getError() (int, error){}` 这是推荐的，但 `func getError() (error, int){}` 这在一些较老的版本（譬如：`1.10.x`及以前）中是不支持的。

Go语言中处理错误的方式通常是**将返回的错误和 nil 进行比较**。
- nil 值表示没有错误
- 非 nil 值需要打印输出错误

```go
package main

import (
    "errors"
    "fmt"
)

func getError1() (int, error) {
    return 1, errors.New("错误1")
}

func main() {
    error1,error1_msg := getError1()
    // 1 错误1 int *errors.errorString
    fmt.Printf("%v %v %T %T \n", error1, error1_msg, error1, error1_msg)
}
```

2、深入 errors 包内部代码：errors.go的核心代码非常简单，如下

```go
package errors

func New(text string) error {
	return &errorString{text}
}

type errorString struct {
	s string
}

func (e *errorString) Error() string {
	return e.s
}
```

所以当返回 `errors.New("错误1")` 的时候其类型是`*errors.errorString`。同样，使用`fmt.Errorf()` 其底层也是使用`errors.New()`进行处理。

```go
package main

import (
    "fmt"
    "errors"
)

func main() {
    error4 := errors.New("错误") // 返回的是一个 error 指针对象
    // 错误 错误  *errors.errorString string
    fmt.Printf("%v %v %T %T\n", error4, error4.Error(), error4, error4.Error())
}
```

3、error 接口的实践：自定义错误
1. 定义一个结构体，表示自定义错误的类型
2. 让自定义错误类型的结构体实现 error 接口：`Error() string`
3. 定义一个返回 error 的函数。根据程序实际功能而定

例如：自定义一个错误类型，实现打印“错误时间+自定错误信息”

```go
package main

import (
    "fmt"
    "time"
)

// 1. 定义一个结构体，表示自定义错误的类型
type MyError struct {
    When time.Time
    What string
}
// 2. 让自定义错误类型的结构体实现 error 接口：`Error() string`
func (e MyError) Error() string {
    return fmt.Sprintf("%v\n%v\n\n", e.When, e.What)
}

// 3. 定义一个返回 error 的函数。根据程序实际功能而定
func Test01() (int, error) {
    errorInfo := fmt.Sprintf("自定义错误信息")
    
    retun 0, MyError{time.Now(), errorInfo}
}

func main() {
    res, err := Test01()
    if err != nil {
        // 2021-07-13 16:40:02.668518189 +0000 UTC m=+0.000287319
        // 自定义错误信息
        fmt.Printf(err.Error())
    } else {
        fmt.Printf("res：%v", res)
    }
}
```

4、defer 关键字：用于延迟一个函数或方法(或当前所创建的匿名函数)的执行（**defer 语句只能出现在函数/方法内部**）

- https://zhuanlan.zhihu.com/p/56557423
- Go1.14将内联defer提高性能：https://www.pengrl.com/p/20023/

![defer调用顺序原理](CF667E0FEC55415097A402466BEF5BA7)

在函数/方法中可以添加多个defer语句，当有多个defer被调用时，主函数执行完毕之后会按照逆序执行（即：使用一个栈来存储这些 defer 调用，主函数执行完毕后根据栈的特征 “先进后出” 的顺序进行执行）

5、defer 使用场景：==常用于处理成对操作==。如：打开-关闭文件、连接-断开连接数据库、加锁-释放锁。特别是在执行打开资源时，遇到错误需要提前返回，在返回前需要关闭相应资源，不然容易造成资源泄漏等问题。

```golang
package main

import "fmt"

func main() {
    s := []int{300, 200, 500, 600,100}
    getMaxValue(s)
}

func finished() {
    fmt.Println("结束")
}
func getMaxValue(v []int) {
    defer finished()
    fmt.Println("开始寻找最大数....")
    max := v[0]
    index := 0
    for key, value := range v {
        if value > max {
            max = value
            index = key + 1
        }
    }
    fmt.Printf("%v 中最大的数字是：%v (第%d位)\n", v, max, index)
}

// 开始寻找最大数....
// [300 200 500 600 100] 中最大的数字是：600 (第4位)
// 结束
```

**注意：defer 延迟函数的参数是在执行延迟语句时被执行，而不是实际执行顺序时被调用（即：入栈时刻参数值的状态是什么，那么最后执行时也是该状态）**

```golang
package main

import "fmt"

func main() {
    a := 1
    test := func(a int) {
        fmt.Printf("当前a的值是：%d\n", a)
    }
    defer test(a)
    a = 2
    fmt.Printf("当前a的值是：%d\n", a)
}
```

虽然延迟匿名函数 `test(a)` 是在 `a = 2` 之后才被真正执行，但在 `defer test(a)` 入栈时 `a := 1` 的状态就已经被一并保存，因此，上述输出是：

```sh
当前a的值是：2
当前a的值是：1
```

**注意：defer 延迟函数可以读取并分配函数的返回值**

```golang
func c() (i int) {
    defer func() {
        i++
    }()

    return 1
}

func main() {
    res := c()
    fmt.Println(res) // 2
}
```

6、异常机制：panic和recover

- Go 中没有像 Java或PHP 一样的 `try...catch...finally` 的错误异常机制，Go 设计时认为：[将异常与控制结构耦合，如try-catch-finally的习惯做法，会导致代码的复杂化](https://golang.org/doc/faq#exceptions)，因此使用 [`panic/recover`](https://blog.golang.org/error-handling-and-go)函数来分开处理。
- 普通错误：指的是程序运行过程中用户抛出的提示性信息；异常：指的是运行过程中需要被中断的操作，属于致命错误


- `panic(v interface{})`：停止当前`goroutine`的正常执行（**中断之前的defer函数在中断后会被正常执行**）
- `recover() interface{}`：管理接收程序的恐慌行为（即：panic goroutine），使得程序可以重新获得流程控制权力（recover()得到的是一个  或 nil-没有任何异常）

- 官方博文：https://blog.golang.org/defer-panic-and-recover

总而言之：Go 语言中依赖 defer 提供了一种异常强大的控制流机制，结合 panic 和 recover 可以将异常处理和逻辑控制代码进行分离。


https://blog.golang.org/errors-are-values

https://ld246.com/article/1584599072906

https://chai2010.cn/advanced-go-programming-book/ch1-basic/ch1-07-error-and-panic.html

https://juejin.cn/post/6954739585691680804

https://alphagao.com/2020/08/12/error-handling-with-micro-service-on-go/

https://xuanwo.io/2020/05-go-error-handling/

https://medium.com/@dche423/golang-error-handling-best-practice-cn-42982bd72672

