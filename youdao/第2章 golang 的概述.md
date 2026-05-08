# 第2章 Golang 的概述
[TOC]

## 什么是程序?
> 程序：为了**让计算机执行某些操作或解决某个问题**而编写的一系列**有序指令集合**
![image](5B0A7D91F7B9494AA5678B0B87439589)


## Go语言的诞生
> 2009年11月10日，Google 将 Golang 以开放源码的方式向全球发布 

### Google 为什么要创造Go语言
> https://talks.golang.org/2012/splash.article

Go语言设计的初衷是满足Google的需求:
1. 计算机硬件技术更新频繁，性能提高很快，但主流的编程语言发展明显落后于硬件，不能合理利用多核多CPU的优势提升软件系统性能
2. 缺乏一个足够简洁高效的编程语言
    - 现有编程语言风格不统一【如Go要求`{`不能换行】
    - 计算能力不够;
    - 处理大并发不够好
3. 企业运行很多C/C++项目，C/C++程序运行速度虽然快，但编译速度慢，同时还存在内存泄漏的一系列的困扰需要解决
    > 希望能拥有静态编译语言的安全和性能，又能拥有动态脚本语言的开发速度


### Golang 的主要设计者
- Ken Thompson（肯.汤普森）：
    - 与Dennis Ritchie是Unix的设计者；
    - 创造了B语言-C语言的前身；
    - C语言的主要发明人
    - 参与正则表达式及UTF-8编码的设计；
    - 贝尔实验室成员；
    - Go语言设计者
- Rob Pike（罗布.派克）
    - Go语言总负责人
    - 贝尔实验室Unix团队成员
    - 参与UTF-8编码设计
    - 开发设计了分布式多用户操作系统：Plan 9、Inferno 操作系统和 Limbo 编程语言
    - 《Unix编程环境》 作者
    - 1980奥运会射箭银牌
    - 天文学家，设计了珈玛射线望远镜
- Robert Griesemer（罗伯特·格瑞史莫）
    - 参与 Java HotSpot虚拟机
    - 负责 Chrome 浏览器和 Node.js 使用的 Google V8 JavaScript 引擎的代码生成部分
> Golang 的logo是 Rob Pike 的妻子设计的，名为金花鼠




## Go 语言的特点
> http://guanzhou.pub/0000/02/01/The-Way-To-Go-1/

Go语言在现有编程语言特点间达到了最佳平衡：快速编译、高效执行、易于开发！

Go语言是一种静态类型、编译型、并发型并具有垃圾回收功能的语言

它保证了既能到达**静态编译语言**的安全和性能,又达到了**动态语言开发维护的高效率**

![早期编程语言对Go语言发展的影响](23DE8364CC7041D7BE78A01221B358A2)

1. 继承了 C 语言很多理念，如：表达式语法、控制结构、基础数据类型、调用参数传值、指针等；同时也保留了 C 语言一样的编译执行方式及弱化的指针
2. 引入**包**的概念，用于组织程序结构：Go语言的每一个文件都要归属于一个包，而不能单独存在
3. 垃圾回收机制，内存自动回收，不需要开发人员管理，更加关注业务逻辑
4. **天然并发**：
    - 从语言设计层面支持并发：设计的理念就是为了适应多核多CPU的计算机
    - `gorountine`-协程:轻量级线程,可**实现大并发处理，高效利用多核**
    - 基于 CPS 并发模型(Communicating Sequential Processes)实现
5. 吸收了管道通信机制，形成了Go语言特有的管道 channel
    > - 通过管道 channel,可以实现不同的goroutine之间的相互通信
    > - `不要通过共享内存来通信，要通过通信来共享内存`【遇到并发问题应始终优先使用管道】
6. 函数可以有多个返回值
7. 新的创新，比如：切片-slice（动态数组）、延时执行-defer等





## Golang 开发工具介绍
> - 推荐阅读：http://golang.iswbm.com/en/latest/c01/c01_01.html
> - 推荐工具：学习推荐sublime text 或 vim 类的文本编辑器（培养代码感），开发推荐-Goland（高效）
> - Golang 中国：https://www.golangtc.com/
> - GOROOT：go编译器所在的安装位置
> - GOPATH：go项目代码所存放的位置




## Go 编程快速入门
> 一起来写个`Hello, World!`程序

### 项目目录结构建议
- src 存放go文件源码
- pkg 存放各类第三方包
- bin 存放go编译生成的可执行二进制文件

### go 源码文件的简单构成
```go
# hello.go 文件
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

- go 源码程序文件的后缀是`.go`
- `package main` Go语言的每一个文件都要归属于一个包，此处表示该文件属于 `main` 包
- `import "fmt"` 引入一个包，包名为 `fmt`，引入包后即可调用包内的函数或常量等,如：`fmt.Println()`
- `func main() {}` 主函数即程序的总入口，`func` 是一个关键字用于声明函数，`main`是函数名（主函数名是`main`与`Java/C`一样）
- `fmt.Println("Hello, World!")` 表示调用`fmt`包的函数 `Println` 输出`Hello, World!`

运行 go 代码有两种方式
1. `go build <filename.go>`方式
```sh
# 编译源码
go build hello.go
# 运行编译后的代码
./hello.exe
```
2. `go run <filename>` 方式
```sh
# 直接执行源码
go run hello.go
```




## Golang 执行流程分析


### 编译运行go源码

![image](842508CBE22141FE996A8D3A2A62D0B6)

使用 `go build <filename.go>` 编译程序
```sh
$ go build hello.go 
```
执行完上述命令后，会对 `hello.go` 文件进行编译，生成一个与当前文件名一样的可执行的二进制文件
> - Windows 下为:`hello.exe`;
> - Linux 下为`hello`;
> - MacOX 下为`hello`;

运行编译后的可执行二进制文件
- Windows 下：`hello.exe` 直接运行或直接双击即可运行
- Linux 下：`./hello` 方式执行
- Mac 下：`./hello` 方式执行
 > Linux下一切皆文件，由于`hello`这个命令没有加入环境变量因此运行的时候需要指定路径。Mac OX 其实是类unix系统，因此与Linux编译执行方式一致

> 以上都是先将源码编译为可执行二进制文件，然后再执行的方式运行，
> 同时也可以直接执行`go run <filename.go>`的方式来直接执行源码


#### `go build` 和 `go run` 的区别

![image](08D3F98B4FD046078C5C3C065196D15D)

> 最后一步，同时准备好两条命令`go run hello.go` 和 `go bulid hello.go && ./hello.exe` 然后快速切换窗口执行.
> 可以看出 `go run`的执行时长基本等于`go build`编译时长+自动执行可执行二进制文件时长

![image](CEAE972590134B7F864362F4B9D73978)

区别如下：
- `go build` 会将源码进行编译生成可执行二进制文件，而`go run`则不会生成生成二进制文件
- `go build` 预编译源码时会将程序运行所依赖的库文件包含在生成的可执行二进制文件中，因此生成的可执行文件体积会变大很多
- `go build`生成的可执行文件对 go 开发环境没有依赖，即：将`hello.exe`文件拷贝到没有 go 开发环境的机器上，仍然可以运行
- `go run` 可以直接运行源码，而`go build`则需要多一步手动执行操作
- `go run` 明显是要比直接执行二进制文件要慢的多，因为多了编译器隐式编译自动执行的步骤
- `go run` 直接执行源码的方式对 go 开发环境存在依赖，否则无法执行

为了方便调试，在开发的时候我们可以直接使用 `go run` 的方式进行调试，但在服务器上我们仍然需要使用 `go build` 方式 先将源码进行静态编译为可执行二进制文件，直接运行！



## Go 开发注意事项
1. `package main` 声明文件所属包的时候，包名`main`是不需要用双引号括起来的，括起来会报错，如下图：
    
    ![image](4DAE71AA555E4F9B8329EB73D0B9861A)

2. golang 中字符串需要使用双引号(字符串)括起来而不能使用单引号(单引号括起来的是单字符)

    ![image](6C9677A38C3A4491BAC1F388C7C5D513)

3. golang 中花括弧`{`是不能单独成行的，且花括弧需要成对存在

    ![image](A5A50A7FFC21406E9E3877D726E0DDDF)

4. golang 中**不需要**在语句后方加分号`;`进行显示标注该语句结束
    - go 编译器在编译的时候会自动加上，因此不需添蛇画足，体现了 Golang 的简洁性
    - 由于 golang 是通过换行进行表示语句结束，因此不能将多个语句写在同一行
        ![image](21BF3B7E1FCE4A358E8F1CC1BB0E8AF2)
    - 若出于某些原因不得不这么做，用户可以可以自行显示使用`;`进行标注语句结束，从而达到多条语句写在同一行的目的(我内心是极不推荐的，因为...你干嘛要这么骚非逆天而行呢？)
5. **Go 语言中定义的变量或 import 的包在程序中没有使用过，编译时就会报错**【这简直是强迫症开发患者的福音】
    ![image](26E8FB08A5D44E99AE68A60EC677EA8E)
6. Go 是静态编译、强类型语言，严格区分大小写
7. 拼写错误：由于电脑字体的显示问题很多字体对于：数字-1和小写字母-l、数字-0和大写字母-O等比较难区分！推荐 `Fire Code` 字体进行编程
    > 前不久有同事将返回字段中 percent 的单词写错为了 precent 返回提供给我调用，导致我程序中计算百分比时一直获取失败...排查出结果的时候真是让人后悔少壮不努力啊
    > 越是低级的错误，越是要注意，排查时反而越是容易被忽视，记录共勉！
8. 也是你不是刚开始学习 Golang，运行编译代码时候会遇到：`go: cannot find main module; see 'go help modules'`
    - 方法1：关闭 `GO111MODULE` 
        
    ![image](969225BC545C4804A0DF6E031F80C741)
    
    - 方法2：

## Golang 的转移字符(escape char)
> 转移字符又称“数据传送换码字符”，是用于通信时对数据起控制作用(如排版Tab、回车、换行等等)。一般的开发编程语言中使用反斜线 `\` 标识某一字符是转义字符，URL 中使用百分号 `%` 进行标识

1. `\t` 表示制表符，通常用于排版
2. `\n` 表示一个换行，另起一行
3. `\r` 表示一个回车，即：将输出序列回到当前行行首
4. `\\` 表示反斜线本身
5. `\"` 表示双引号
6. `\'` 表示单引号

注意：回车和换行是不同的两个概念(详细可阅读下方参考阅读：[回车和换行](https://www.ruanyifeng.com/blog/2006/04/post_213.html))，就会明白为什么下方程序会输出如截图结果？为什么 Win7 自带文本编辑器打开 Linux/MacOX 上的文本会有时会全部变成一行？为何Windows的文本在Linux打开每行后方会多一个`^M`的乱码字样？
![image](16EE1234074344EAA63BB7F760D68C0F)


```go
package main
import "fmt"
func main() {
    fmt.Println("回车\r覆盖")
    fmt.Println("换行\n覆盖")
}
```
![image](0E1E56E4C06A4C0C8212F412C7C04A38)

**参考阅读：**
> - 维基百科：https://zh.wikipedia.org/wiki/%E8%BD%AC%E4%B9%89%E5%AD%97%E7%AC%A6
> - 回车和换行：https://www.ruanyifeng.com/blog/2006/04/post_213.html
> - http传输字符编码与转义：https://blog.csdn.net/xcymorningsun/article/details/78420752


