`func main()`是程序的入口。所有 Go 函数以关键字 func 开头，每一个可执行程序都必须包含 main() 函数，通常是程序启动后第一个执行的函数，如果有 init() 函数泽辉先执行 init() 函数

1. init() 和 main() 的执行顺序？

```golang
package main

import "fmt"

func main() {
    fmt.Println("hello, main")
}


func init() {
    fmt.Println("hello, init")
}
```

![go init](B551437418CB4B28B30F033E729B9D2C)

2. init() 函数中可以调 main() 函数吗？

![go init call main](EC9CF83CF90C42D8A54248307D9926C4)

3. main() 函数可以调用 main() 函数吗？

![go main call init](E5C703EC1927403BAF70C3EB9792290D)

4. init() 函数的作用？


5. main() 函数的作用是什么？
