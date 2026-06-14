---
layout: post
title: "Go语言-常量和枚举的使用"
date: 2022-01-21
tags: [Go]
---


## 常量定义的注意事项

1. **使用 `const` 关键字来进行命名**
2. **变量名、函数名、常量名：采用驼峰法**
3. **同一命名空间下，函数和常量不能重复定义使用**
4. **常量的数据类型只能是：boolean、rune、integer、float、complex、string**
5. `Golang` 语言中常量的命名规范**并不像其他语言一样要求全部大写**
6. 若：变量名、函数名首字母大写，则可以被其他的包访问；如果首字母小写，则只能在本包中使用
    - 可以理解为：首字母大写是公开-public。如：const Version = "1.14.6"
    - 首字母小写时是本包中受保护的-protected。如：const version = "1.14.6"
    - 在 Golang 中没有 public protected private 等关键字
7. **常量的值必须是能够在编译时就能够确定的字面量或常量表达式**
    - 常量表达式：可在其赋值表达式中涉及计算，但所有用于计算的值必须在编译期间就能获得值
    - 常量表达式的返回值必须要符合常量的数据类型限制
    - 对常量的类型转换操作或以下函数调用都是返回常量结果的函数。如：len、cap、real、imag、complex 和 unsafe.Sizeof
8. 批量声明的常量，除了第一个外其它的常量右边的初始化表达式都可以省略

```golang
const (
    a = 1 
    b     // 此时，b 的初始值、类型都是跟 a 一模一样。但要注意，它们是两个不同的常量
    c = 2
    d
)

fmt.Println(a, b, c, d) // "1 1 2 2"
```

## iota 常量生成器 和 枚举的实现

`iota` 是 `Golang` 内置的一个预定义标识符，默认情况下，它代表的是一个下标由0开始的自增无类型整数序数（当然你也可以给一个表达式给）。在 `Golang SDK Path/go1.14.12/src/builtin/builtin.go` 可以看到这个预定义标识符。`iota` 常用于和枚举类型一起使用。

```golang
const (
    cpp = iota // iota 表示自增表达式，默认从 0 开始
    java // 1
    python // 2
    golang // 3
    _ // 匿名变量 被忽略的 4 
    php // 5
)

const (
    FlagNone = 1 << iota // 默认0，表示值都是 每次将上一次的值左移一位。则：FlagNone = 1 << 0 ==> 1
    FlagRed // 1 << 1 ==> 10 即：2
    FlagGreen // 1 << 2 ==> 100 即：4
    FlagBlue // 1 << 3 ==> 1000 即：8
)

fmt.Printf("%v %v %v %v\n", FlagNone, FlagRed, FlagGreen,FlagBlue) // 1 2 4 8
```

### 枚举的作用

在编程领域中，枚举是用来表示只包含有限数量的固定值的类型，在开发中一般用于标识错误码或者状态机（即：一个物体或事件，在其有限的呈现状态中当前是什么状态。[详见](https://zhuanlan.zhihu.com/p/47434856)）。

截至如今最新的 1.18 版本 Go 语言中依然是没有 enum 关键字，因此 Go 语言中的“枚举”只是一个“类枚举”的实现而并非是一个内置数据类型。


### 为什么需要枚举？？

**1、使用见名知意的常量字符串代替无意义的魔术数字** 

用 HTTP 协议和 Linux 系统来说：对于 HTTP 状态来说 200 表示成功；对于 Linux Shell 脚本来说 0 表示成功，其余标识各类失败（成功只有一种，而错误原因总是成千上万）。如果你在程序中普遍的使用 `status == 200` 或 `status == 0` 的这种写法，一旦需要将 200 改为 0 或将 0 改为 200，那么可想而知的头大。

若你事先对定义了 `SUCCESS = 200` `ERROR_A = 1` 的常量或枚举类型值，那么上述的情况就会变成判断 `status == SUCCESS` 即可，若需要将 200 改为 0 情况，只需要变更 `SUCCESS = 0`  就能更加方便、快速对代码进行调整。

再譬如，最常见的是在数据库中使用数字标识性别，因为一个数字要占用的资源肯定是比一个字符串更加小、更加稳定的。

如下的代码，如果没有注释的情况那么请问 0、1 到底代表的是什么意思呢？？？除了写代码的人，估计其他人都很难一眼就看出来。因此可以说这种“魔术数字”

```golang
var sex rune // 定义性别
if sex == 0 {
    // 逻辑
} elseif == 1 {
    // 逻辑
} else {
    // 逻辑
}
```

**2、参数类型的强制校验**

对于上面说的第 1 点，其实使用普通的常量即可。如下（示例代码 2-1）：

```golang
const men uint8   = 0;
const women uint8 = 1;

func test(sex uint8) string {
    if sex == men {
        // 逻辑
    } elseif sex == women {
        // 逻辑
    } else {
        // 逻辑
    }
}
```

咋一看，似乎没有什么问题。但仔细考虑一个问题：正常来说，性别确实只有 2 种，那么意味着`test()` 随便传递一个 uint8 类型的值这样是不对的，更应该要在编译的时候就报错告知，显然才是更合理的。

而“枚举”需要能做到这样的类型校验。Go 语言中的实现如下（示例代码 2-2）：

```golang
type gender uint8
const (
    men gender = iota
    women
)

func test(sex gender) string {
    if sex == men {
        // 逻辑
    } elseif sex == women {
        // 逻辑
    } else {
        // 逻辑
    }
}
```

FAQ：基于以上代码，在调用时我是困惑的，如下：

```golang
func main() {
    // var sex uint8 = 3 // 这样会编译不通过，因为 test 只接收 gender 类型的参数
    var sex gender = 3 // 但实际这样就可以运行了。
    test(sex)
}
```

既然 `var sex gender = 3` 也是可以传递，那么示例代码 2-1 和 2-2 有什么意义呢？

理论上我们申明了常量，那么实际工作中就会使用 `var sex uint8 = men` 或 `var sex gender = men` 这样的方式，并不会使用 `var sex gender = 3` 这样的垃圾代码。那么对于 Golang 实现的枚举中“类型校验”有什么区别呢？？

其实，这是灯下黑把自己给弄迷糊了。如果 gender 不使用 uint8 这个类型要改为 string 呢？？若不自定义一个数据类型，可想而知修改的麻烦度依然不小。若自定义类型，则可以通过 `go-fmt -r "old" -> "new"`的方式来全局替换。


### 枚举值 与 字符串互转

```golang
package main

import "fmt"

// 定义一个自定义全局类型。
// 注意：一旦自定义了 Weekday 类型，虽然 Weekday 类型的底层依然是 int 类型，但是 Weekday 类型和 int 类型确实不同的两个类型
type Weekday int
const (
    Sunday Weekday = iota
    Monday
    Tuesday
    Wednesday
    Thursday
    Friday
    Saturday
)

// 为 type Weekday 重写了 String() 接口方法 C:/Users/Minso/sdk/go1.14.12/src/reflect/type.go:94
// 类似其他语言中的 xxx.ToString() 方法，当需要将 Weekday 类型转为 string 类型的时候就会被调用
// https://github.com/zhangxiang958/Blog/issues/53
func (day Weekday) String() string  {
    switch day {
    case Sunday:
        return "Sunday"
    case Monday:
        return "Monday"
    case Tuesday:
        return "Tuesday"
    case Wednesday:
        return "Wednesday"
    case Thursday:
        return "Thursday"
    case Friday:
        return "Friday"
    case Saturday:
        return "Saturday"
    }
    return "N/A"
}

func main() {
    // 打印
    fmt.Printf("%[1]s：%[1]d\n" +"%[2]s：%[2]d\n" +"%[3]s：%[3]d\n" +"%[4]s：%[4]d\n" +
        "%[5]s：%[5]d\n" +"%[6]s：%[6]d\n" +"%[7]s：%[7]d\n",
        Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday,
    )
    
//Sunday：0
//Monday：1
//Tuesday：2
//Wednesday：3
//Thursday：4
//Friday：5
//Saturday：6
}

// 利用反射打印 Sunday 类型
fmt.Printf("%T %v\n", reflect.TypeOf(Sunday).String(), reflect.TypeOf(Sunday).String()) // string main.Weekday 
```

## 为什么不建议返回值用枚举？

由于之前一直做 PHP 也是没有枚举类型，截至 `PHP 8 >= 8.1.0` 才出 `Enum` 类型。但在看了 《阿里巴巴JAVA开发手册》 中发现有一条强制的规定：**「5.【强制】二方库里可以定义==枚举==类型，参数可以使用==枚举==类型，但是接口返回值不允许使用==枚举==类型或者包含枚举类型的POJO对象。」**。

一直以来对于为什么「参数可以使用枚举类型」的原因是理解的。但始终不明白为什么「返回值不允许使用」？如果不用那么应该怎么去解决这个问题呢？其实也是忽略强类型中「枚举」的一个特性那就是：**类型的强制校验**。
我错误的将「返回枚举中某一个值」（譬如上述的 `Weekday Sunday`）和「返回字符串`"Sunday"`或数值`0`」这两种情况等同了，但实际两种情况的数据类型是不同的，其数据类型的特性也是不同的。

### 「参数可以使用枚举类型」

参数是站在接口提供者的角度考虑，这样的好处就是**安全、可控**。

- 因为决定权是在提供者手里的，提供者告诉你，我只接受什么，那么你就必须要给我什么
- 否则你将得不到你要的答案

### 「返回值不允许使用枚举类型」

返回值是从使用者的角度考虑的，如果接口返回的是枚举类型（枚举：将所有已知情况都罗列清楚），一旦服务端的枚举类型更新而客户端未及时更新，客户端是就要面临未知风险（如果客户端是强类型语言的，程序就会直接崩溃）。我想大概是基于此，所以《阿里巴巴JAVA开发手册》规定「返回值不允许使用枚举类型」。

那么我们应该怎么返回呢？应当返回枚举类型底层的数据类型。譬如：返回值确实是 `type Weekday int` 中的其中一种情况，那么接口就返回 `int` 类型，而不是返回 `Weekday` 这种自定义的枚举类型。



**推荐阅读：**

- [Go 语言里怎么正确实现枚举？答案藏着官方的源码里](https://mp.weixin.qq.com/s/CB1TBcxMf2XSvTqsslM_-A)
- [Go 需要枚举没？如何实现？](https://mp.weixin.qq.com/s/FQpkvjb7UxfXLWvmRbYXQw)
- [为什么不建议返回值用枚举？](https://blog.csdn.net/qq_37217713/article/details/103917811)
- [Java枚举什么不好，《阿里巴巴JAVA开发手册》对于枚举规定的考量是什么？](https://www.zhihu.com/question/52760637)