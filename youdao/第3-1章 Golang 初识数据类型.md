# 第3章 Golang 基础语法
[TOC]

## 注释
> 注释是用来注解程序，提高代码的可阅读性！不要面面俱到也不要过于简略，写清楚主要功能、关键难理解的思路即可！

- 使用 `//` 行注释 
- 使用 `/*注释内容*/` 块注释
- 块注释中不允许嵌套块注释



## 编码规范
> Go设计者的思想：一个问题尽量只有一个解决方法

- Go官方推荐使用行注释来注释整个方法和语句，注释一般写在程序的语句上方
- 一行最长不超过 80 个字符，超过的请使用换行符展示，尽量保持格式优雅【可阅读性强】
- 运算符两边习惯性各加一个空格
- 正确缩进和空白：统一使用 `Tab` 进行缩进，或推荐使用 `gofmt -w <filename.go>` 进行格式化
    ![use gofmt formate the program](D5E7B6E54596455EA26BA88DB838872C)
    
> 如果使用 git 提交代码，可以考虑通过客户端 pre-commit hooks 在每次用户commit前进行格式化

```sh
#!/bin/sh
files=$(git diff --cached --name-only --diff-filter=ACM -- '*.go')
for file in $files
do
    gofmt -w $file
    git add $FILE
done
```



## 内置数据类型概述

### 变量
#### 什么是变量？

变量是程序的基本组成单位，相当于内存中一个数据存储空间的表示（一个房间的门牌号）。通过门牌号我们可以找到对应的房间，同理：通过变量名我们可以访问到变量(值)。

#### 变量的使用
1. 声明变量(定义变量)
2. 变量赋值(初始化变量)
3. 使用变量

#### Golang 中变量的使用
1. 变量表示内存中的一个存储区域（计算机中数据只有加载到内存中才能运行起来）
2. 该内存区域有自己的名称（变量名）和类型（数据类型）
3. Golang 中使用变量的几种方式
    - 声明变量：`var <name> <Type>` ==> 声明后若不赋值，该变量的值为该类型的默认值（如：int-0）
    - 类型推导：`var <name> = <value>` ==> 根据变量值自行判断推导出变量类型
    - 短声明：`<name> := <value>` ==>省略`var`关键字，通过 `:=`赋值声明符号根据值自行推导出变量的类型
4. Golang 支持一次性多变量声明，如：`var <name1>, <name2> [<Type>] [= <value1>, <value2>>]`；**在 go 中，函数外部定义变量就是全局变量【实际应该是包全局变量】**
5. 该内存区域的值(变量值)可以在**声明指定**的**同一类型**范围内不断变化 ==> 强类型，一个变量只有一个类型
6. 变量在同一作用域内不能重复声明定义
7. 变量三要素：变量=变量名+变量值+数据类型
8. Golang 的变量如果没有赋初值，编译器会使用默认值。比如：int 默认值 0；string 默认值为空字符串；浮点数默认0.0

#### 程序中 + 号的使用
- 当两边都是数值型时，则做加法运算
- 当左右两边都是字符串，则做字符串拼接
-----------



### 数据类型的基本介绍

![Golang 的数据类型](5EABB0265DD344B0AB2A10037979CFFE)

------------------

### 整数类型

#### 整数的各个类型及表数区间

| 类型 | 有无符号 | 占用存储空间 | 表数范围 | 备注 |
|------|----------|--------------|----------|------|
| int8 | 有       | 1字节        |-128 ~ 127| 首位用于表示 +/- |
| int16| 有       | 2字节        |-2^15 ~ 2^15-1| +/-0都表示0，将0列为正数|
| int32| 有       | 4字节        |-2^31 ~ 2^31-1|  |
| int64| 有       | 8字节        |-2^63 ~ 2^63-1|  |


| 类型 | 有无符号 | 占用存储空间 | 表数范围 | 备注 |
|------|----------|--------------|----------|------|
| uint8| 无       | 1字节        |0 ~ 255   | 首位不必用于表示 +/- 号，u-usigned |
|uint16| 无       | 2字节        |0 ~ 2^16-1|      |
|uint32| 无       | 4字节        |0 ~ 2^34-1|      |
|uint64| 无       | 8字节        |0 ~ 2^64-1|      |

| 类型 | 有无符号 | 占用存储空间 | 表数范围 | 备注 |
|------|----------|--------------|----------|------|
| int  | 有       | 4/8 字节     | int32/int64 | 取决当前是32/64位系统-**应当避免使用**|
| uint | 无       | 4/8 字节     | uint32/uint64 | 取决当前是32/64位系统-**应当避免使用**|
| rune | 有       | 4字节        |-2^31 ~ 2^31-1|  等价于int32，表示一个 Unicode 码,若存储的单字符表数范围超过了 byte 可选用 rune |
| byte | 无       | 1字节        | 0 ~ 255  | **与uint8等价，当要存储字符时选用 byte** |



**！！！需要根据表数范围选取合适的数据类型**

![数据范围溢出 overflows](6EB70705B56244F6B23EC22AD3D31B29)

#### 整型的使用细节
1. Golang 各整数类型分为：有符号和无符号，主要区别在表数范围不一样；int/uint 的大小和系统有关；
2. Golang 的整型默认声明为 int 型 ==> 整数的类型推导默认是 int 类型
3. 如何再程序中查看某个变量的字节大小和数据类型
    > - **字节大小**：unsafe 包中的 Sizeof() 函数：unsafe.Sizeof(<name>)
    > - 数据类型：fmt.Printf("%T", <name>)
4. Golang 程序中整型变量在使用时，遵守保小不保大的原则，即：在保证程序正确运行下，尽量使用占用空间小的数据类型(如：年龄-没有必要用int64来存储)
5. bit(位)：计算机中最小的存储单位；byte(字节):计算机中基本存储单元 ==> 1 byte = 8 bit

--------------------


### 小数类型/浮点型

**==任何语言中，浮点数都会存在精度丢失问题！！！==**

| 类型 | 占用存储空间 | 表数范围 | 备注|
|------|--------------|----------|-----|
| float32 | 4字节 | -3.403E38 ~ 3.403E38 | 单精度 |
| float64 | 8字节 | -1.798E308 ~ 1.798E308 | 双精度 |

**单精度和双精度占用空间不一致的主要区别在于：表数范围和表示精度不一样**

1. 浮点数在机器中存放形式的简单说明，**浮点数=符号位+指数位+尾数位**
    > - 符号位：证明浮点数都是有正负符号的
    > - 指数位：E38、E308
    > - 尾数位：3.403、1.798
2. 尾数部分可能丢失，造成精度损失
    > 如：-123.0000901，单精度会丢失掉01，而双精度不会 ==> 如果我们需要保存一个精度高的数，应选用 float64
3. 浮点型的存储分为三部分：**符号位+指数位+尾数位**，存储过程中**精度会丢失**

#### 浮点型的使用细节
1. Golang 浮点类型有固定的范围和字段长度，不受具体 OS(操作系统) 的影响，而int类型受 OS 位数影响
2. Golang 的浮点型默认声明为 float64 类型 ==> 浮点数的类型推导默认为 float64 类型
3. 浮点型常量有两种表示形式
    > - 十进制形式，如：5.12、.512（等价于：0.512==>小数点必须有）
    > - 科学计数法形式，如：5.1234E2 = 5.1234 * 10^2 、5.12E-2 = 5.12/(10^2)
4. 通常情况下，应该使用 float64, 因为它比 float32 更精确。(开发中推荐使用 float64)

```golang
num9 := 1129.6
fmt.Printf("精度丢失问题：1129.6 * 100 的值是：%v\n", num9 * 100)
//精度丢失问题：1129.6 * 100 的值是：112959.99999999999

m1 := 8.2
m2 := 3.8
fmt.Println(m1 - m2) // 4.3999999999999995
```

```javascript
console.log(8.2 - 3.8) // 4.3999999999999995
```

- http://bbs.itying.com/topic/5e92a8938da5b70118ded75d
- https://ld246.com/article/1632905225387
- https://dieselchen.work/archives/9359d6b3.html

------------------

### 复数

- [复数：实数 + 虚数](https://www.shuxuele.com/numbers/complex-numbers.html)
    - 实数：差不多所有日常遇到的数都是实数！如：1、2、128.34、√2(根号2)
    - 虚数：若某一个个值的平方是负数，则该数为虚数。虚数通常不会发生（正数的平方是正数，负数的平方也是正数），但你需要想象虚数存在。如：√-1 的平方就是 -1
    - 所有的实数和虚数都是复数

| 类型 | 占用存储空间 | 零值 |
|------|--------------|----------|
| complex64 | 8 字节 | 0+0i |
| complex128 | 16 字节 | 0+0i |

```golang
# src/math/const.go

const (
	MaxFloat32             = 3.40282346638528859811704183484516925440e+38  // 2**127 * (2**24 - 1) / 2**23
	SmallestNonzeroFloat32 = 1.401298464324817070923729583289916131280e-45 // 1 / 2**(127 - 1 + 23)

	MaxFloat64             = 1.797693134862315708145274237317043567981e+308 // 2**1023 * (2**53 - 1) / 2**52
	SmallestNonzeroFloat64 = 4.940656458412465441765687928682213723651e-324 // 1 / 2**(1023 - 1 + 52)
)

var (
	num6 = complex(math.SmallestNonzeroFloat32, math.SmallestNonzeroFloat32)
	num7 = complex(math.MaxFloat64, math.MaxFloat64)
)
fmt.Printf("num6 最小值：%[1]T %[1]v 占用字节数：%d\n", num6, unsafe.Sizeof(num6))
// num6 最小值：complex128 (1.401298464324817e-45+1.401298464324817e-45i) 占用字节数：16

fmt.Printf("num7 最大值：%[1]T %[1]v 占用字节数：%d\n", num7, unsafe.Sizeof(num7))
// num7 最大值：complex128 (1.7976931348623157e+308+1.7976931348623157e+308i) 占用字节数：16

num8 := 3 + 4i
fmt.Printf("num8 类型：%[1]T 值：%[1]v 复数结果的绝对值：%v 占用字节数：%d\n", num8, cmplx.Abs(num8), unsafe.Sizeof(num8))
// num8 类型：complex128 值：(3+4i) 复数结果的绝对值：5 占用字节数：16
```

-------------------


### 字符类型
> - Golang 中没有专门的字符类型，如果要存储单个字符(字母)，一般使用 byte 来保存
> - **字符串就是一串固定长度的字符连接起来的字符序列**。Go 的字符串是由单个**字节**链接起来的。即：对于传统的字符串是由字符组成的，而**Go的字符串不同，它是由字节组成的。**
> - Golang 官方将 string 归属到基本数据类型：https://tour.golang.org/basics/11

```golang
package main

import "fmt"

func main() {
    var c1 byte = 'a'
    var c2 byte = '0' // 字符0-与数字0不同
    
    // 当直接输出 byte 类的值，就是输出对应的字符的码值
    fmt.Println("c1=", c1) // 97 ==> a 的 Unicode 码值(ASCII表对应的十进制数)
    fmt.Println("c2=", c2) // 48 ==> '0'的 Unicode 码值(ASCII表对应的十进制数)
    // 若需要输出对应的字符，需要使用格式化函数输出
    fmt.Printf("c1=%c c2=%c\n", c1, c2)
    
    // var c3 byte = '北' // 报错：overflow溢出，一个函数3个字节，已经超出了255的范围
    var c3 int = '北'
    fmt.Printf("c3=%c c3对应码值=%d", c3, c3) // c3=北 c3对应码值=21271
}

```
1. 如果变量保存的字符在 ASCII 表的，比如：0-9a-zA-Z...，直接可以保存到 byte
2. 如果保存的字符对应码值大于 255，及超过了1个字节，这时可以考虑使用 int 类型保存 ==> 字符本质也是一个数字
3. 如果需要按照字符的方式输出，需要使用格式化函数输出，即：`fmt.Printf("%c", <name>)`

#### 字符类型的使用细节
1. **字符常量(字面量)是用单引号(`'<char>'`)括起来**的单个字符，如：`var c1 byte = 'a'` `var c2 int = '中'`
2. Go 中允许使用转移字符 `\` 来将其后的字符转变为特殊字符常量，如：var c byte = '\n'
3. Go 语言中字符使用 UTF-8 字符集编码（UTF-8 编码兼容了 ASCII 编码）==>英文字母-1个字节；汉字-3个字节
4. **在 Go 中，字符的本质是一个整数**，直接输出时，是该字符对应的 UTF-8 编码的码值
5. 可以直接给某个变量赋一个数字，然后格式化输出时用 `%c` 会输出对应数字对应的 Unicode 字符
6. **字符类型是可以运算** ==> 字符相当于一个整数，字符都有对应的 Unicode 码


#### 字符类型本质探讨
1. 字符型存储到计算机中，需要将字符对应的码值(整数)找出来
    > - 存储：字符 ---> 对应码值 ---> 二进制 ---> 存储
    > - 读取：二进制 ---> 码值 ---> 字符 ---> 读取
2. 字符和码值的对应关系是通过字符集编码表决定的(固定规定好的)
3. Golang 的编码统一使用 `UTF-8`，因此 Golang 中没有编码乱码的困扰，做到了国际化统一

------------------------


### 布尔类型
1. 布尔类型也叫 `bool` 类型，在 Golang 中bool 类型数据**只允许**取值:`true` 和 `false`
2. bool 类型占用 1 个字节
3. bool 类型一般适用于**逻辑运算**，一般用于程序的流程控制，如：if 条件控制语句；for 循环控制语句...

-------------------------


### string 类型
- `字符串`就是一串**固定长度的字符**连接起来的**字符序列**,在 Golang 的字符串中是由**单个字节连接起来的** ==> 即：可以通过 `str[0]` 这样的方式访问获取字符串中的某个字符
- Golang 中字符串的字节是使用 `UTF-8` 编码标识 `Unicode`文本


#### string 类型使用注意事项和细节
1. Golang 中字符串的字节使用 UTF-8 编码标识 Unicode 文本，这样 Golang 统一使用 UTF-8 编码，中文乱码问题将不再困扰程序员
2. 字符串一旦赋值，字符串就不能更改了，即：Golang 中字符串是不可变的
    > 如：Golang 中不可以像 PHP 中一样 `str[0] = x`动态的改变某个字符的值
3. 字符串的两种表示形式
    - 双引号`"xxx"`：会识别转移字符
    - 反引号`` `xxx` ``:以字符串原生形式输出，包括换行和特殊字符，可以实现防止攻击、输出源代码等效果
4. 字符串的拼接方式：使用 `+` 号
5. 当一行字符串太长需要使用多行字符串时候，可以分行写，但是要注意**将 `+` 保留在上一行**

-------------------------


### 基本数据类型的默认值
在 Golang 中，数据类型都有一个默认值（又叫：零值），当变量声明之后没有被赋值时，就会保留默认值。

 ![Golang 数据类型及各个类型的零值](2AFA4CE1E489423DB413FB8398A549AB)

----------------------

### 基本数据类型的相互转换
数据类型的转换是在所赋值的数值类型和被变量接收的数据类型不一致时发生的，它需要从一种数据类型转换成另一种数据类型。**数据类型的转换可以分为隐式转换（自动类型转换）和显式转换（强制类型转换）两种。**

Golang 和 Java/C 不同，Java/C 在变量符合自动转换的条件下可隐式转换，Golang 中不同类型的变量之间赋值时**只能显示转换(强制转换)**。

#### 数据类型转换的使用
**表达式：** `T(v)` 将变量 v 转换为类型 T
- T:数据类型，如：int32、int64、float32 等
- v:需要转换的变量的值
```golang
package main
import "fmt"
func main() {
    var float float64 = 100.00001
    var integer int64 = int64(float)
    
    fmt.Println("integer=", integer) // 输出 100
}
```

#### 数据类型转换的注意事项
1. Golang 中数据类型转换可以从 `表示范围小-->表示范围大`，也可以`表示范围大-->表示范围小`
2. 被转换的是变量存储的数据(变量的值)，变量本身的数据类型并没有变化
    > 如，上述案例：变量 float 的值被转为 int64 类型赋值给了 integer 变量，但 float 本身仍然是 float64 类型的 
3. 在`表示范围大-->表示范围小`转换中，编译时不会报错，只是转换的结果是**按溢出处理**，因此在转换时，需要考虑范围
```golang
package main
import "fmt"

func main() {
    var integer16 int16  = 129
	var integer8 int8 = int8(integer16) // int8 表数范围：-128 ~ 127
	fmt.Println(integer8) // 输出：-127
}
```
----------------------

#### 基础数据类型转 string

**1. 方式1：fmt.Sprintf("%参数", 表达式)**
> https://studygolang.com/static/pkgdoc/pkg/fmt.htm#Sprintf

```golang
var integer int64 = 1000
str := fmt.Sprintf("%d", integer)
fmt.Printf("str 的类型是：%T, 值是：%q \n", str, str) // str 的类型是：string, 值是："1000"
```

**2. 方式2：使用 `strconv` 包中的函数**
- FormatBool(b bool)：https://studygolang.com/static/pkgdoc/pkg/strconv.htm#FormatBool
- FormatInt(i int64, base int)：https://studygolang.com/static/pkgdoc/pkg/strconv.htm#FormatInt
- Itoa(i int)：https://studygolang.com/static/pkgdoc/pkg/strconv.htm#Itoa （相当于：FormatInt(i,10) ）
- FormatUint(i uint64, base int)：https://studygolang.com/static/pkgdoc/pkg/strconv.htm#FormatUint
- FormatFloat(f float64, fmt byte, prec, bitSize int)：https://studygolang.com/static/pkgdoc/pkg/strconv.htm#FormatFloat

##### 基础数据类型转 string 细节

1. **使用 `fmt.Sprintf("%参数", 表达式)` 方式转换时，需要注意 `%参数` 的选取**
```golang
// 浮点数会有精度丢失问题，这是众所周知的
var float32Num float32 = 10.0000901
var float64Num float64 = 10.0000901
fmt.Printf("%g %g \n", float32Num,float64Num) //  10.00009 10.0000901

float32ToStr := fmt.Sprintf("%f", float32Num) // 10.00009
float64ToStr := fmt.Sprintf("%g", floatNum) // 若使用 `%f`，此处转换时也会造成精度丢失
fmt.Printf("float32ToStr 的类型是：%T, 值是：%q \n", float32ToStr, float32ToStr)
fmt.Printf("float64ToStr 的类型是：%T, 值是：%q \n", float64ToStr, float64ToStr)
```


2. 类型 `byte` `rune` 的存储的是对应字符的 Unicode 码值，而并不是字符，因此不能使用 `%s`
```golang
var byteVal byte  = 'a'
byte2Str := fmt.Sprintf("%c", byteVal)
fmt.Printf("byte2Str 的类型是：%T, 值是：%q \n", byte2Str, byte2Str)

var runeVal rune  = '中'
rune2Str := fmt.Sprintf("%c", runeVal)
fmt.Printf("rune2Str 的类型是：%T, 值是：%q \n", rune2Str, rune2Str)
```


3. `%参数`的常用类型
    - %T	值的类型的Go语法表示
    - %d	表示为十进制
    - %c	该值对应的unicode码值
    - %t	单词true或false
    - %f	有小数部分但无指数部分，如123.456
    - %g	根据实际情况采用%e或%f格式（以获得更简洁、准确的输出）
    - %q	该值对应的双引号括起来的go语法字符串字面值，必要时会采用安全的转义表示


4. 使用 `strconv` 包中的类型转换函数需要**注意传递参数值的类型**
    - `strconv.FormatUint(uint64 i, bitSize int)` // 参数1:必须是uint64类型的数值；参数2:输入数字的进制表示
    - `strconv.FormatInt(int64 i,  bitSize int)`  // 参数1:必须是int64类型的数值；参数2:输入数字的进制表示
    - `strconv.Itoa(int i)` // 参数1：必须是int类型的数值，该函数在64位系统中等价于：`FormatInt(int64 i, 10)`


5. `strconv` 包中的类型转换函数转换 `byte` `rune` 类型的值，得到的是对应的码值的字符串，而不能得到用户赋值的字符
```golang
var byteStr rune  = 'a'
byte2str := strconv.FormatUint(uint64(byteStr), 10)
fmt.Printf("byte2str 的类型是：%T，值是：%q \n", byte2str, byte2str) // byte2str 的类型是：string，值是："97"

var runeStr rune  = '中'
rune2Str := strconv.FormatInt(int64(runeStr), 10)
fmt.Printf("rune2Str 的类型是：%T，值是：%q \n", rune2Str, rune2Str) // rune2Str 的类型是：string，值是："20013"
```
> **推荐使用 `fmt.Sprintf()` 进行类型转换，会更加灵活**

****

#### string 转基础数据类型

使用 `strconv` 包的函数
- `ParseBool(str string) (value bool, err error)`：https://studygolang.com/static/pkgdoc/pkg/strconv.htm#ParseBool
```golang
var booleanStr string = "false"
	str2bool, _ := strconv.ParseBool(booleanStr)
	fmt.Printf("str2bool 的类型是：%T，值是：%t \n", str2bool, str2bool)
```

- `ParseInt(s string, base int, bitSize int) (i int64, err error)`：https://studygolang.com/static/pkgdoc/pkg/strconv.htm#ParseInt
- `ParseUint((s string, base int, bitSize int) (i int64, err error)`：https://studygolang.com/static/pkgdoc/pkg/strconv.htm#ParseUint
> `ParseUint`类似`ParseInt`但不接受正负号，用于无符号整型
```golang
var intStr string = "999999999999"
// 参数1：整数字符串；参数2：传入整数当前是用N进制进行表示的；参数3：转换后的数值使用 intN 进行存储
// 若参数3填写的数据类型导致转换后的存储不够，编译时不会报错，但数据会溢出，最终得不到预期的数值
str2int, _ := strconv.ParseInt(intStr, 10, 64) 
fmt.Printf("str2int 的类型是：%T，值是：%b \n", str2int, str2int)
```

- `ParseFloat(s string, bitSize int) (f float64, err error)`：https://golang.org/pkg/strconv/#ParseFloat
```golang
// 参数1：浮点数字符串；参数2：表示转换结果的精度（困惑：实际填写了32,返回值类型也是float64？）
// 返回的浮点数值是 float64 存储的
var floatStr string = "123.0000901"
str2float, _ := strconv.ParseFloat(floatStr, 32) 
fmt.Printf("str2float 的类型是：%T，值是：%g \n", str2float, str2float)
```

##### string 转基础数据类型使用细节
在将 string 类型转成基本数据类型时，要**确保 string 类型能够转成有效的数据类型**。如： 可以把"123"转成一个整数，但不能将 "hello" 转成一个整数。如果这样做， Golang 会直接**将其转成为对应基本数据类型的零值**

## 初识指针

### 指针简介
> - 参考阅读：[5个维度来看C语言指针](https://www.runoob.com/w3cnote/c-language-pointer-from-five-dimensions.html)
> - 参考阅读：[以下程序的结果是什么？](https://www.nowcoder.com/questionTerminal/7cfb321b01834e80b6301bff9a4eeada?toCommentId=79541)

1. 基本数据类型，变量存的是“值”，也就值类型
2. 获取变量的地址，用 `&`，如：`var num int`，获取变量 num 的内存地址可通过 `&num`

3. 指针内心，指针变量的值存的就是一个内存地址，这个地址指向内存空间存的才是值，如：`var ptr *int = &num`
4. 获取指针类型所指向的值，使用`*`,如：`var ptr *int`，使用 `*ptr` 获取变量 ptr 存放的内存地址所指向的内存空间的值

![盒子模块-值传递与引用传递图解]()

变量的内存空间什么时候被计算机回收？
    - 程序运行完毕，由语言编译器自主决定是否需要主动回收。如：PHP、Golang-程序运行完毕自动回收；Java-程序运行结束不会自动回收
    - 用户显示回收

------------------------------

### 指针案例
1. 写一个程序，获取一个 int 变量 num 的地址，并显示到终端
2. 将 num 的地址赋值给指针 ptr,并通过 ptr 去修改 num 的值
```go
package main
import "fmt"

func main() {
    var num int = 10
	fmt.Printf("num的值是：%v 地址是：%v\n", num, &num)
	
	var ptr *int
	ptr = &num
	*ptr = 20
	fmt.Printf("num的值是：%v 地址是：%v\n", num, &num)
	fmt.Printf("ptr的值是：%v 地址是：%v ptr所指向的内存空间的值是：%v\n", ptr, &ptr, *ptr)
}
```

3. 以下程序输出结果是什么？
```golang
package main
import "fmt"

func main() {
    var a int = 300
	var b int = 400

	var ptr *int = &a
	*ptr = 100

	ptr = &b
	*ptr = 200

	fmt.Printf("a=%d, b=%d, *ptr=%d\n", a, b, *ptr) // 100 200 200
}
```

--------------------------------------------------

### 指针使用陷阱
1. 指针变量的值必须接受一个地址
```golang
func main() {
    var a int = 300
    var ptr *int = a // 错误，只能接收int类型变量的地址：&a
}
```
2. 指针变量声明时要指定数据类型且一但类型声明不可更改
```golang
func main() {
    var a int = 300
    var ptr *float32 = &a // 错误，类型不匹配
}
```

--------------------------------

### 值类型和引用类型
1. ==**值类型都是有对应的指针类型**==，形式为：==**`*数据类型`**==，如： int 类型对应指针为：`*int`，float32 对应的指针类型为：`*float32`
2. 值类型包括：基本数据类型、数组、结构体
3. 引用类型包括：指针-ptr、切片-slice、字典-map、管道-chan、函数-func、接口-interface

![Golang中值类型和引用类型](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/Golang中值类型和引用类型.png)

******

![值类型存储示意图](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/值类型&引用类型存储示意图.png)

#### 值类型

- **值类型变量直接存储值**
- 值类型内存**通常在栈中分配** 


#### 引用类型

- 引用类型变量存储的是一个地址，这个地址对应的内存空间才真正的存储数据(值)
- 引用类型变量的内存**通常**在堆区中进行分配
- 当没有任何变量引用这个地址时，该内存地址的数据空间就成为一个垃圾，由 GC 来回收

#### 值类型和引用类型的使用特点

> - 栈区、堆区只是一个逻辑概念
> - 在Golang编译器中由于逃逸分析，导致值类型有可能在堆区或引用类型在栈区中 ==> 根据变量使用生命周期决定到底放在什么地方
> - 参考阅读：https://blog.csdn.net/guaiguaihenguai/article/details/81173249

![栈内存、堆内存示意图](A42412E626E844B6AFA977F34F631E1F)


## 数组

数组：由**固定长度**的**相同**的**特定类型**元素组成的序列，一个数组可以由零个或多个元素组成。

### 定义数组的几种方法

1. 声明数组：var name [num]Type【零值：Type 数据类型所对应的零值组成的一维数组】
2. 声明并赋值定义： name := [num]Type{value, value1,...,valueN}
3. 由编译器决定长度： name := [...]Type{value, value1,...,valueN}
4. 定义二(多)维数组: var name [num1][num2]Type
    * 多维数组只是由多个嵌套的一维数组组装而成罢了（本质也是一个一维数组）
    * 多维数组（N维）元素的基本类型就变成了 N-1 维数组
    * 访问：`mulitArr[x][y][z]`

### 数组遍历

1. for循环：`for i:=0; i < len(arr); i++ { ... }`
2. 【推荐】for...rang：`for key,value := range arr { ... }`


**注意：**

1. **数组是值类型而不是引用类型。即：调用`func f(arr [10]int)` 会拷贝整个数组**
2. **`[10]int` 和 `[20]int` 虽然都是数组，但是不同的数据类型**
3. **因为数组的长度是固定的，所以在Go语言中很少直接使用数组，更多使用切片**

## Slice（切片）

- [Go Slices: usage and internals](https://go.dev/blog/slices-intro)

切片-Slice：与数组一样由"相同"的"特定类型"元素组成的序列==>与数组不同的是，切片类型是不固定的长度的。

Golang 源码中 slice 的结构定义如下：

```go
// runtime/slice.go
type slice struct {
    array unsafe.Pointer // 元素指针 ==> 指针类型
    len   int // 长度 ==> 切片当前的长度
    cap   int // 容量 ==> 
}
```

由源码可得出以下几个结论：

1. **切片是对数组的一个连续片段的引用，所以切片是一个"引用类型"(默认值是nil)**
2. **这个片段可以是整个数组，也可以是由起始和终止索引标识的一些项的"子集"**
3. **切片的索引标识是一个"左闭右开的半闭合区间"==> 终止索引标识的项不包括在切片内**【事实左闭右开应该是大部分语言中函数的共识】


### 定义切片的几种方法

1. 声明空切片：var name []Type【**nil切片的零值：emptySlice == nil 为 true**】
2. 声明并赋值定义： name := []Type{value, value1,...,valueN}
3. 通过 make 方式： make([]Type, size, cap)【**空切片：长度和容量都是0，但是空切片是已经初始化操作了，因此和 nil 比较为 false**】

### 切片的操作

- 查-访问切片： slice[num]
- 改-修改切片： slice[num] = value
- 增-添加元素： append(slice, value1, value2,...,valuen) or  append(slice, newArrOrSlice...)【`...`表示解包，将数组或切片中的元素一个个输出】
- 删-删除元素
    - 头部元素： slice[1:]
    - 尾部元素： slice[:len(slice)]
    - 中间元素： append(slice[:n], slice[n+1:]...)
- 复制-复制切片：copy(newSlice, oldSlice) **注意：newSlice 的 len 一定要比 oldSlice 大，否则会丢失元素**

### FAQ


- **Q：既然切片是数组的一段引用，如果我改变切片一定会同步更改到原数组吗？？？**
    - A：不一定，如果切片发生了扩容行为，此时切片的底层所指向的是一个新数组。那么此时再更改切片的值是不会影响到原数组的。

切片扩容：runtime/slice.go:groupslice()

```txt
// growslice handles slice growth during append.
// It is passed the slice element type, the old slice, and the desired new minimum capacity,
// and it returns a new slice with at least that capacity, with the old data
// copied into it.
// The new slice's length is set to the old slice's length,
// NOT to the new requested capacity.
// This is for codegen convenience. The old slice's length is used immediately
// to calculate where to write new values during an append.
// TODO: When the old backend is gone, reconsider this decision.
// The SSA backend might prefer the new length or to return only ptr/cap and save stack space.
```

```golang
arrTest := [4]int{1,2,3,4}
fmt.Printf("arrTest %v\n", arrTest) // arrTest [1 2 3 4]
sliceTest := arrTest[:]
fmt.Printf("sliceTest %v\n", sliceTest) // sliceTest [1 2 3 4]

sliceTest[0] = 10
fmt.Printf("arrTest is : %v cap: %d len:%d \n", arrTest,cap(arrTest),len(arrTest)) // arrTest is : [10 2 3 4] cap: 4 len:4 
fmt.Printf("sliceTest : %v, cap: %d len:%d\n", sliceTest, cap(sliceTest), len(sliceTest)) // sliceTest : [10 2 3 4], cap: 4 len:4

sliceTest = append(sliceTest, 5) // sliceTest 切片扩容
fmt.Printf("arrTest is : %v cap: %d len:%d \n", arrTest,cap(arrTest),len(arrTest)) // arrTest is : [10 2 3 4] cap: 4 len:4 
fmt.Printf("sliceTest is : %v, cap: %d len:%d\n", sliceTest, cap(sliceTest), len(sliceTest))  // sliceTest : [10 2 3 4 5], cap: 8 len:5

sliceTest[0] = 1
fmt.Printf("arrTest is : %v cap: %d len:%d \n", arrTest,cap(arrTest),len(arrTest)) // arrTest is : [10 2 3 4] cap: 4 len:4 
fmt.Printf("sliceTest is: %v, cap: %d len:%d\n", sliceTest, cap(sliceTest), len(sliceTest)) // sliceTest is: [1 2 3 4 5], cap: 8 len:5  
```

- **Q：下列程序是否会报错？**

```golang
arr := [...]int{0, 1, 2, 3, 4, 5, 6} // len(arr)=7 cap(arr)=7
s1 := arr[2:6] // [2,3,4,5] len(s1)=4 cap(s1)=5
s2 := s1[2:5] // [4,5,6] len(s2)=3 cap(s2)=3
```

不会报错：切片对于底层数组来说，可以向后扩展读取，但是不能向前扩展读取。s[i] 不可以超过 len(s)，向后扩展不可以超过底层数组的 cap(s)。【即：s2 := s1[2:5] 正确，但是 s2 := s1[2,6] 就会报错】

## Map-字典/哈希表

字典-map:由若干个“key:value”的键值对映射组合在一起的数据结构，字典由key和value组成，它们各自有各自的类型。

其底层是一个哈希表的一个实现，类似 PHP 中的索引数组。

注意：

- Golang 中 **Map 类型是一种引用类型，其零值是 nil**。
- Golang 中 map 的 key 类型必须是可哈希的类型（即：不能是引用类型slice、map或函数-function）
- map 遍历时，key 是无序的，和你什么时候加入到 map 是无关的

### 声明定义字典

- 声明 : var <name> map[KEY_TYPE]VALUE_TYPE 【**此时 name 未初始化，其零值是 nil ，不能直接赋值**】
- 声明并初始化 : var <name> = make(map[KEY_TYPE]VALUE_TYPE) 【**此时 name 是一个 empty map，而并非 nil**】
- 短声明 : var scores = map[string]uint8{"chinese":80,"math":90,"english":100}
- 短声明 : scores := map[string]uint8{"chinese": 80,"math":90,"english":100}
- 定义多维字典 : map[K_TYPE]map[VK_TYPE]VALUE_TYPE

### 字典的操作

- 增: name[KEY] = VALUE
- 查: name[KEY] 【**读取字典的值时会返回两个值，第二个返回值表示对应的 key 是否存在，若存在为true，若不存在为false**】
- 改: name[KEY] = NEW_VALUE
- 删: delete(<map>, "key") 【若 key 不存在，delete()函数会静默处理，不会报错】
- 遍历: `for key[, value] := range <map> {...}`
- 获取 map 长度 : len(map)

```golang
scores := map[string]uint8{"chinese": 80,"math":90,"english":100}
// 添加元素
scores["science"] = 95
// 更新元素：若key存在则更新
scores["science"] = 100
// 读取元素，若key不在返回VALUE_TYPE的默认值
fmt.Printf("生物成绩是：%d\n", scores["biology"])
// 删除元素-几何学成绩，若key不存在，delete()函数会静默处理，不会报错
delete(scores,"geometry")
	
// 判断字典 scores 中是否存在 algebra 这个key
if algebra,exist := scores["algebra"]; exist {
	fmt.Printf("代数成绩是：%d\n", algebra)
} else {
	fmt.Print("我还是个孩子，没有代数这门学科~~\r\n")
}

// 遍历：不保证遍历顺序
for subject,score := range scores  {
	fmt.Printf("学科：%s，成绩：%d \n", subject,score)
}

// 获取长度
fmt.Println("scores 的长度：", len(scores))
```


### FAQ-**Q:什么叫可哈希的？**

简单来说，一个不可变对象，都可以用一个哈希值来唯一表示，这样的不可变对象，比如字符串类型的对象（可以说除了切片、 字典，函数之外的其他内建类型都算）.


### 寻找最长不含有重复字符的字串
- [3. Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters)
- [剑指 Offer 48. 最长不含重复字符的子字符串](https://leetcode-cn.com/problems/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof/)



## 参考文档
- Golang 官网：https://golang.org/
- Golang 官方编程指南：https://tour.golang.org/welcome/1
- Golang 包手册：https://golang.org/pkg/(中文版：https://studygolang.com/pkgdoc)
- [Go Documentation](https://go.dev/doc/)
- [The Go Blog](https://go.dev/blog/)
- [Effective Go](https://go.dev/doc/effective_go)