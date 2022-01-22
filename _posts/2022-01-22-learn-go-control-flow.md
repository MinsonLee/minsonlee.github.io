---
layout: post
title: "Go语言-程序流程控制"
date: 2022-01-22
tags: [Go]
---

程序流程控制又叫做程序执行顺序。编程思想的体现就是程序流程控制的使用体现。所有的编程语言都主要有三大流程控制语句：
- 顺序控制
- 分支/条件控制
- 循环控制语句

且各个控制流程之间可相互嵌套。

事先需要注意以下几点：

1. 流程控制语句：Go 编译器对 `{` 的位置有严格的要求。
    - 单分支条件判断语句：`if <condition> { //body }`，`{` 必须跟 `<condition>` 同一行
    - 多分支条件判断语句：`if <condition> {} elseif <condition> {} else {}` 中
        - `{` 必须跟 `<condition>` 同一行
        - 但是 `else` 后面没有 `<condition>` 可以不再同一行（建议还是写在同一行会好些）
2. 条件判断语句的短路作用：if-else、switch-case ==> 若条件判断需要满足多个条件可以使用 “&&” 或 “||” ==> 多条件判断有短路作用
3. 延迟执行的 `defer` 是一样关键字

## 顺序控制语句

顺序控制即：程序至上而下，逐行执行，中间**没有任何的判断和跳转**，那么该段程序就是顺序控制。顺序控制语句，也是程序默认的执行顺序。其流程图如下：

![流程控制-顺序控制](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/control-flow-basic.png)

### 注意事项 

1. 顺序控制程序中，定义和使用变量时，采用合法的前向引用。即：使用变量时，总是使用同一层级或上一层级中，前方最靠近的哪一个变量。

```go
package main

function main() {
    // 正确的引用
    var num1 int = 1
    var num2 int = num1 + 1
    // 错误的引用
    var num4 int = num3 + 1
    var num3 int = 3
}
```

## 分支控制

分支控制（又称为条件控制）即：依指定变量或表达式的结果，决定后续运行的程序。

### 单分支控制结构

单分支控制语句的流程图如下：

![流程控制-条件控制语句 if](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/control-flow-if.png)

基本语法如下：

```golang
if 条件表达式 {
    执行代码块
}
```

### 双分支控制结构

双分支控制语句的流程图如下：

![流程控制-条件控制语句 if-else](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/control-flow-if-else.png)

基本语法如下：

```golang
if 条件表达式 {
    执行代码块A
} else { // 注意 Golang 中 } { 是不能换行的
    执行代码块B
}
```

如下代码示例：

```golang
// 条件判断语句
func judgeCondition(age uint8)  {
    /*
    * 单分支条件判断语句：if <condition> { //body }
    * !!! “{” 必须跟 <condition> 同一行
     */
    if age >= 12 &&
        age <= 18 {
        fmt.Println("青少年")
    }
    /*
    * 多分支判断语句
    * !!! { 和 } 花括号必须在 else（else if）必须在同一行
    */
    if age > 18 {
        fmt.Println("已经成年了")
    } else {
        fmt.Println("还未成年")
    }

    if age < 1 {
        fmt.Println("婴儿")
    } else if age < 7 {
        fmt.Println("幼儿")
    } else {
        fmt.Println("你已经不是个孩子了")
    }

    /*
    * if 高级语法：在 if 里允许先运行一个表达式，取得变量后，再对其进行判断，比如第一个例子里代码也可以写成这样
    */
    if myAge := 20; myAge > 18 {
        fmt.Println("已经成年了")
    }
}
```

### 多分支控制语句

多分支控制语句`if...elseif...else`的流程图如下：

![流程控制-条件控制语句 if-elseif-else](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/control-flow-if-elseif-else.png)

基本语法如下：

```golang
if 条件表达式 {
    执行代码块A
} elseif 条件表达式 { 
    执行代码块B
} elseif 条件表达式 {
    执行代码块C
} else {
    执行代码块D
}
```

多分支控制语句`switch...case`，先执行表达式`expr`，得到值，然后和 `case` 表达式进行**<font style="background:yellow;">相等比较</font>**，如果匹配则执行对应语句块，然后退出。

1. **Golang 中 `case` 语句默认是可以省略 `break` 语句，因为编译器会自动添加上**
2. **若 case 使用了关键词 `fallthrough` 开启穿透能力时，会直接执行下一个case的内容（不管与下一个case匹配结果如何，执行完都会退出，不会往后续的case进行判断）**

其流程图如下：

![流程控制-条件控制语句 switch-case](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/control-flow-switch-case.png)

基本语法如下：

```golang
switch 表达式 { // { 必须和 表达式 同一行
    case 表达式1,表达式2,...: // 多个条件之间是 或(||) 的关系，用逗号相隔
        语句块1
    case 表达式3,表达式4,...: // 当 case 后接的是字面量常量时，该常量只能出现一次。如：case "man","man": 编译是会报错的 ==> duplicate case "man" in switch
        语句2
    ... ... // 可多个 case 语句
    default:
        语句块
}
```

### 注意事项

1. 即使执行代码块只有一行语句，<font style="background:yellow;">`{}`也是必须有</font>。如：Java/PHP 中，若`if`语句后只有一行代码，花括号是可以省略的。
2. 分支控制流程中，<font style="background:yellow;">只会有其中一个代码块会被执行</font>
3. 官方建议：分支控制语句中<font style="background:yellow;">条件表达式不需要括号</font>
4. **条件表达式<font style="background:yellow;">不能是赋值语句</font>，其结果必须为布尔类型**
5. `switch/case` 后是一个表达式（即：常量值、变量、一个有返回值的函数等都可以）
6. `case` 后各个表达式的值的数据类型必须和 `switch` 表达式的值的**数据类型一致**
7. `case` 后可接多个表达式，使用逗号间隔即可
8. 若 `case` 后接的是一个常量值(字面量)，则要求不能重复（编译不通过）
9. **`switch...case`语句中，<font style="background:yellow;">不需要 `break`语句</font>**，`default` 语句不是必须的
10. `switch` 后也可以不带表达式，类似 `if..elseif...else`来执行

```go
var score int = 90;
switch {
    case score > 90:
        fmt.Println("优秀")
    case score >= 70:
        fmt.Println("良好")
    case score >= 60:
        fmt.Println("合格")
    default:
        fmt.Println("不及格")
}
// 优秀

var str string
str = "hello"
switch {
case str == "hello":
    fmt.Println("hello")
    fallthrough // 穿透，下一个 case 就默认变为了 true
case str == "xxxx":
    fmt.Println("xxxx")
    break // 手动写上 break 也不会报错，但是没必要。不推荐
case str != "world":
    fmt.Println("world")
default:
    fmt.Println("worldsssss")
}
// hello
// xxxx
```

11. 【不推荐】分支控制语句的条件表达式中可以定义**局部变量**，其作用域只局限于当前控制流程的可执行代码块

```go
if age:20; age > 18 {
    fmt.Println("成年了！", age); // age 只能在该作用域内使用
}

switch score := 90 {
    case score > 90:
        fmt.Println("优秀")
    case score >= 70:
        fmt.Println("良好")
    case score >= 60:
        fmt.Println("合格")
    default:
        fmt.Println("不及格")
}
```



## 循环结构

让一段代码块循环的执行，直到循环判断条件为 `false` 时，退出循环。

### `for`循环语句

语法如下：

```golang
for 循环变量初始化; 循环条件; 循环变量迭代 {
    // 循环体
    // 1. 循环变量初始化，在整个循环生命周期中只执行一次 ==> 该变量作用域只在循环体内
    // 2. 当循环条件返回 true 继续循环，返回 false 结束循环
    // 3. 每次“循环完”自动执行一次
}

或

// 循环变量初始化
for 循环条件 {
    // 循环体
    // 循环变量迭代
}

// 无限循环
for ｛
    // 循环体
｝
```

流程图如下：

![流程控制-循环语句 for](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/control-flow-loop-for.png)

#### 注意事项：

1. 循环条件是返回一个 **布尔值** 的表达式
2. 上述两种`for`循环的循环变量初始化方式不同，其作用域也不同
3. 无限循环：`for {}` 等价于 `for ; ; {}`，通常需要配合 `break` 语句
4. 对于遍历数组/切片/字符串，可使用：`for key,value := range var {}`，类似 PHP 中的 `foreach(var as key => value) {}`、 JQuery 中的 `each()` 进行遍历

```golang
package main
import "fmt"
function main() {
    // 遍历数组
    var arr = [3]int{1,2,3}
    for index, value := range arr {
        fmt.Printf("index = %d; value=%d \n",index, value)
    }
    // 遍历切片
    var numList  = []int{1,2}
    for index, value := range numList{
        fmt.Printf("index = %d; value=%d \n",index, value)
    }
    // 遍历字符串
    var str string = "hello,中国！"
    for i:=0; i < len(str); i++ {
        fmt.Printf("%c", str[i]) // 中文乱码
    }
    fmt.Print("\n")
    for _,value := range str {
        fmt.Printf("%c", value)
    }
}
```

5. 对于字符串的遍历，若使用传统的`for`循环是按照**字节来遍历**，若字符串中含有中文(一个汉字对应的utf8编码是3个字节)，则会出现乱码错误！而`for...range`是按照字符方式进行遍历，因此有中文也不会乱码。

如果想使用传统方式 `for` 循环，需要对含有中文的字符串进行遍历，需要先将字符串转换为切片，就不会乱码

```golang
var str string = "hello,中国！"
str2 := []rune(str)
for i:=0; i < len(str2); i++ {
    fmt.Printf("%c", str2[i])
}
```

6. **<font style="background:yellow;">Go 语言中没有 `while` 和 `do...while` 循环语句，如果需要用到，那么请使用 `for`循环进行实现！</font>**【Go设计者的思想：一个问题尽量只有一个解决方法】

#### 嵌套循环注意事项

1. <font style="background:yellow;">一般不要使用嵌套循环，最多不要超过3层</font>
2. 外层循环次数为 m 次，内层循环次数为 n 次，整个循环的时间复杂度为 O(m*n) 

#### 练习

1. 打印空心金字塔

```golang
// 首/底层全打印，其余2个*；行首空格：总层数-当前层数，内行空格：(2*n-1)-当前层*数
/*
   *
  * *
 *   *
*******
*/
bufio.NewReader(os.Stdin)
var level int;
fmt.Printf("输入金字塔层数：")
fmt.Scanln(&level)
for i := 1; i <= level; i++ {
    // 打印行首空格
    for j := 1; j <= (level - i); j++ {
        fmt.Printf(" ")
    }

    // 打印 *
    for k := 1; k <= 2*i - 1; k++ {
        if k == 1 || k ==  2 * i - 1 || i == level{
            fmt.Printf("*")
        } else {
            fmt.Printf(" ")
        }
    }
    fmt.Println()
}
```

2. 打印空心菱形

```golang
package main
import (
    "fmt"
    "bufio"
    "os"
)
function main() {
    bufio.NewReader(os.Stdin)
    var level int
    for {
        fmt.Printf("请输入一个奇数：")
        _, _ = fmt.Scanln(&level)
        if level % 2 == 1 {
            break
        }
    }
    middle := (level / 2) + 1 // 中位数
    for i :=  1; i <= level; i++ {
        temp := i
        if i > middle {
            temp = 2 * middle - i
        }
        // 打印行首空格
        for j :=  1; j <= middle - temp; j++ {
            fmt.Printf(" ")
        }
        // 打印 *
        for k :=  1; k <= 2 * temp -1; k++ {
            if k == 1 || k ==  2 * temp -1{
                fmt.Printf("*")
            } else {
                fmt.Printf(" ")
            }
        }
        fmt.Println()
    }
}
```

### 跳转控制语句

#### `break` 语句

1. `break` 语句用于**终止某个语句块**的执行，用于中断**循环控制语句**和 **多分支控制-`switch`语句**
2. 循环结构中 `break` 语句默认会跳出最近的一层循环体
3. 在 `golang`的循环结构中，`break` 语句不能像 PHP 中一样指定跳出的循环体层数，只能通过标签方式进行跳转

```golang
label2:
for i := 1; i <= 9; i++ {
    for j := 1; j <= i; j++ {
        fmt.Printf("%d * %d = %d \t",j, i, i*j)
        // break 2 // 错误：不能指定跳出层级
        break label2
    }
    fmt.Println("\n")
}
```

#### `continue` 语句

1. `continue` 语句用于**循环结构**中，表示**结束本次循环，继续进行下一次循环**
2. 在 `golang`的循环结构中，`continue` 语句不能像 PHP 中一样指定跳转的循环体层数，只能通过标签方式进行跳转

```golang
here:
for i := 0; i < 2; i++ {
    for j := 1; j < 4; j++ {
        if j == 2 {
            // continue 2 // 错误：不能指定跳出层级
            continue here
        }
        fmt.Println("i=",i," j=",j)
    }
}
```

#### `goto` 语句（不推荐使用）

1. `goto`语句可以**无条件地跳转到程序中指定标签处**
2. `goto` 语句通常与条件语句配合使用，用于实现条件转移，跳出循环体等功能
3. 在 Go 程序设计中，**一般不主张使用 `goto` 语句**，避免造成程序的混乱，使得理解和调试程序产生阻碍
4. 在循环控制中使用 `goto label` 跳出（程序无条件的执行转移位置）和：`continue label`及 `break label`跳出（针对循环体进行跳出）有很大区别

推荐阅读：[Go To Statement Considered Harmful:A Retrospective](http://david.tribble.com/text/goto.html) [中文版](https://www.emon100.com/goto-translation/)

```golang
here:
// fmt.Println("hhhhh") // 对于 break 和 continue 标签跳出，标签后除了循环体不能跟任何语句
for i := 0; i < 2; i++ {
    for j := 1; j < 4; j++ {
        if j == 2 {
            break here //continue here // 跳出后 i 的值仍然会保留(仍然是在循环体中)
        }
        fmt.Println("i=",i," j=",j)
    }
}

label:
fmt.Println("hhhhh") // 此处可以接非当前循环体语句
for i := 0; i < 2; i++ {
    for j := 1; j < 4; j++ {
        if j == 2 {
            goto label // i 会被重新初始化，已经完全被转移
        }
        fmt.Println("i=",i," j=",j)
    }
}
```

#### `return` 语句

1. `return` 语句用于**终止跳出当前的方法或函数**
2. `return` 后的语句不再执行，如果 `return` 是在 `main` 函数中，表示终止程序

```golang
func 函数名(形参列表) (返回值列表) {
    // 语句块
    return
}
```

## 延迟调用-defer

- defer 是关键词
- 延迟调用：defer functionName()
    - defer 所在的当前函数执行完之后再执行 functionName() 函数
    - 若有多个 defer ，程序采用栈结构存储。即**LIFO：后进先执行**
    - 类似：析构函数--脚本执行完毕后自动调用
    - 延迟调用是当前函数被执行完(包括 return )再进行调用
- 变量快照：defer 只是延时调用函数，但此时传递给函数里的变量（上下文环境）是不会受到后续程序的影响

**<font style="background:yellow;">defer 的作用和 析构函数 的作用类似，常用于释放当前函数(对象)可能在其生命期间获得的资源</font>**

如下示例代码：

```golang
// 案例1：defer 延迟执行，多个 defer 使用栈存储（LIFO）
func delayOne() {
    // 延迟调用
    defer delayD()
    fmt.Println("A")
    defer fmt.Println("C")
    fmt.Println("B")
}
func delayD()  {
    fmt.Println("D")
}
// A B C D


// 案例2：变量快照
var language = "go" // 声明一个全局变量-Go
func delayVar()  {
    // 变量快照
    name := "go"
    defer fmt.Println("defer 中的 name："name) // 打印发生在 name="python" 后，但此时的 name 是前文环境中的快照 "go"

    name = "python"
    fmt.Println("打印在 name = python 后：" + name)
}
// 打印在 name = python 后： python
// defer 中的 name：go


// 案例3：defer 发生在 return 语句之后
func delay() {
    // defer 和 return 的执行顺序: defer 在 return 后调用执行
    myLan := myDelay()
    fmt.Printf("delay 函数里的 language 变量：%s\n", language)
    fmt.Printf("delay 函数里的 return 值：%s\n", myLan)
}


func myDelay() string {
    defer func() {
        language = "python" // 此处改变了全局变量的值，但被延迟执行了
        fmt.Printf("myDelay 函数里 defer 的 language 变量：%s\n", language)
    }()

    fmt.Printf("myDelay 函数里的 language 变量：%s\n", language)
    language = "PHP"
    return language
}
// myDelay 函数里的 language 变量：go
// myDelay 函数里 defer 的 language 变量：python ==> return 发生后立即被触发
// delay 函数里的 language 变量：python ==> language 已经在 myDelay 中的 defer 所更改
// delay 函数里的 return 值：PHP
```