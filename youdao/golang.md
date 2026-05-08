[TOC]

1. Go语言有哪些优势？
2. Golang 的开发环境搭建
    - GOROOT
    - GOPATH
        - src
        - pkg
        - bin
    - GOBIN
    - GOPROXY
3. Goland 的安装与破解
4. Go 的第一个程序：Hello World（go build、go test），了解 golang 的基本运行
5. Go语言的构成和编码规范
    - 简单结构：声明包、main()函数、less is more
    - 变量命名规范
    - 通过大小写区分是否能被外部包调用

- [为 PHP 转 Go 的朋友们推荐一款神器](https://learnku.com/articles/50321)
- [Go for Java Programmers](https://go.dev/talks/2015/go-for-java-programmers.slide#1)
- https://www.php2golang.com/
- https://hao.studygolang.com/
- https://kps.hashnode.dev/learn-go-the-complete-course
- [全部课程_Go 语言学习资源库_阿里云培训中心-阿里云](https://edu.aliyun.com/explore/?q=Go%E8%AF%AD%E8%A8%80&categories=EDU_COURSE)

## 基本语法

1. 变量

变量是计算机语言中存储数据的基本单元。变量的功能是存储数据。

![image](10D3640B7DA14080A1E9C360E64CFD54)

变量的本质是计算机分配一个小块内存，专门用于存放指定数据，在程序运行过程中该数值可以发生改变；变量的存储往往具有瞬时性(临时存储)，程序运行结束，存放该数据的内存就会释放，该变量就会随着内存的释放而消失。

2. 如何声明？如何赋值？Go语言的多重赋值
3. 数据类型，每个类型的默认值是什么？（变量是盒子模型的话，那么数据类型就是选择什么盒子来装东西的过程）？
4. 数据类型：基本数据类型（原生数据类型）+复合数据类型（派生数据类型）-复合类型是一种自定义类型，用于扩展基本数据类型。

> Go语言将数据类型分为四类：基础类型、复合类型、引用类型和接口类型。
> - 基础类型，包括：数字、字符串和布尔型
> - 复合数据类型——数组（array）和结构体（struct）——是通过组合简单基本类型，来表达更加复杂的数据结构
> - 引用类型包括：指针（§2.3.2）、切片（§4.2)）、字典（§4.3）、函数（§5）、通道（§8），虽然数据种类很多，但它们都是对程序中一个变量或状态的间接引用。这意味着对任一引用类型数据的修改都会影响所有该引用的拷贝
> - 接口类型：接口-interface

==**但要记住：严格来说，Golang 中是没有引用类型的**==
- https://sanyuesha.com/2017/08/10/go-no-reference-type/
- https://www.tapirgames.com/blog/golang-has-no-reference-values
- https://zhuanlan.zhihu.com/p/84580859
- https://ityet.com/?p=10003768


5. 数据类型转换？
4. 匿名变量`_`：既不占用命名空间，也不分配内存。优缺点是什么？使用场景是什么？
5. 引用赋值还是值传递赋值
6. golang 中的 nil
7. 常量

Q：usafe.Sizeof(string)、len(string)、



2、运算符
1. 算术运算符
2. 关系运算符
3. 逻辑运算符
4. 位运算符
5. 赋值运算符
6. 其他运算符
7. 运算符的优先级

## 流程控制
1. 条件判断语句
    - if
    - if...else
    - if...else if...else
2. 条件分支语句
    - switch
    - select
3. 循环语句
    - for 循环
4. 循环控制语句
    - break
    - continue
    - goto

## 函数和指针


### 函数基础

1、函数的声明

2、变量分局部变量（生命周期与函数一样）、全局变量（生命周期与main函数一样）==>作用域不同（作用域是变量、常量、类型、函数的作用范围）
- 局部变量：只能在声明的函数体内使用
- 可以在整个项目中被使用（当前包、外部包）、在任何函数中使用
- 局部变量可以与全局变量同名，在函数内会优先使用当前作用域的局部变量

3、在Go语言中，可以使用 type 自定义数据类型，可以将函数定义为一种自定义类型，然后将符合该类型的函数作为一个参数进行调用【类似于接口中，只定义函数名，由各个实现接口的类自行实现】
- 函数参数完全相同：参数个数、参数类型相同
- 返回值完全相同：返回值个数、返回值类型相同

4、匿名函数
```golang
func (参数列表) (返回值列表) {
    // 函数体
}
```

匿名函数经常被用左与：回调函数、闭包等

1. 在定义时调用匿名函数
```golang
func (data int) {
    fmt.Println("hello")
}(100)
```

2. 将匿名函数赋值给变量
```golang
f := func(data string) {
    fmt.Println(data)
}
f("hello")
```

3. 匿名函数作为回调

```golang
package main
import "strings"
func main() {
    arr := []{"hello", "golang"}
    test(arr, func() {
        strings.ToUpper()
    })
}
// 定义函数类型参数f
func test(list []string, f func(string)) {
    for _, value := range list {
        f(value)
    }
}
```

### 闭包

4. 词法闭包（简称：闭包）
- 由函数和与其相关的引用环境组合而成的实体。在实现**深约束**时，需要创建一个**能显示表示引用环境**的东西，并将**它与相关的子程序捆绑在一起**，这样捆绑起来的整体称为闭包
- 闭包 = “函数” + 引用环境
- 闭包只是形式和表现上像函数，但实际上并不是函数！
    - 函数是一堆可执行代码的集合，在被定义后就确定了，不会在执行时发生变化，所以一个函数只有一个实例
    - 闭包运行时可以有多个实例，不同的引用环境和相同的函数组合可以产生不同的实例（在某些编程中闭包又叫Lambda表达式）
    - 函数本身不存储任何信息，只有域引用环境结合形成的闭包才具有“记忆性”
    - 函数是编译器静态的概念，而闭包是运行期动态的概念
- 闭包的意义：能够读取其他函数内部变量的函数（如何从外部读取函数内部的局部变量）
- 为什么需要闭包？
    - 加强模块化：闭包有益于模块化编程，便于以简单的方式开发较小的模块，从而提高开发速度和程序的可复用性
    - 抽象：闭包是数据和行为的组合，这使得闭包具有较好的抽象能力（类是对象属性和行为的组合）
    - 简化代码。一个语言需要以下特性来支持闭包
        - 函数是一阶值（First-class value，一等公民），即：**函数可作为另一个函数的返回值或参数**，还**可作为一个变量的值**
        - 函数可以嵌套定义，即：可以在一个函数内部定义另一个函数
        - 允许定义匿名函数（由此可以看出：闭包是匿名函数的一种使用方法）
        - 可以捕获引用环境，并将引用环境和函数代码组成一个可调用的实体
    - “惰性求值”：因为闭包只有在被调用时才执行操作，所以它可以被用来定义控制结构
- 如何既可以长久的保存变量又不会造成全局污染？
    - 由于闭包会使得函数中的变量都被保存在内存中，内存消耗很大，所以不能滥用闭包，否则会造成网页的性能问题，在IE中可能导致内存泄露。解决方法是，在退出函数之前，将不使用的局部变量全部删除。 
    - 闭包会在父函数外部，改变父函数内部变量的值。所以，如果你把父函数当作对象（object）使用，把闭包当作它的公用方法（Public Method），把内部变量当作它的私有属性（private value），这时一定要小心，不要随便改变父函数内部变量的值。
    - 我们搜索闭包，必不可少都会看到和 JS 相关。因为 JS和Shell中的变量默认都是全局变量，有“作用域链”的概念。但，由于 Shell 是不支持在函数内部再次因此


```golang
package main

import "fmt"

func main()  {
    for i := 0; i < 10; i++ {
        fmt.Printf("i = %d\t", i)
        fmt.Println(add2(i))
    }
}

func add2(x int) int {
    sum := 0
    sum += x

    return sum
}
```

```golang
package main

import "fmt"

func main() {
    pos := adder()
    for i := 0; i < 10; i++ {
        fmt.Printf("i = %d\t", i)
        fmt.Println(pos(i))
    }

    fmt.Println("-----------------")

    for i := 0; i < 10; i++ {
        fmt.Printf("i = %d\t", i)
        fmt.Println(pos(i))
    }
}

func adder() func(int) int {
    sum := 0
    return func(x int) int {
        fmt.Printf("sum1 = %d\t", sum)
        sum += x
        fmt.Printf("sum2 = %d\t", sum)

	return sum
    }
}
```

```golang
package main

import (
	"fmt"
	"reflect"
)

func main() {
	myFunc := Counter()
	fmt.Println("myFunc", myFunc)

	/* 调用 myfunc 函数，i 变量自增 1 并返回*/
	fmt.Println(myFunc())
	fmt.Println(myFunc())
	fmt.Println(myFunc())

	/* 创建新的函数 nextNumber1，并查看结果*/
	myFunc1 := Counter()
	fmt.Println("myFun1", myFunc1)
	fmt.Println(myFunc1())
	fmt.Println(myFunc1())

	fmt.Printf("myFunc == myFunc1 ? %t \n", reflect.DeepEqual(myFunc1,myFunc))
}

// Counter 计数器，闭包函数
func Counter () func() int{
	i := 0
	res := func() int {
		i += 1
		return i
	}

	fmt.Printf("Counter 中的内部函数的i：%d\n", i)
	res()
	fmt.Printf("Counter 中的内部函数的i：%d\n", i)
	fmt.Println("Counter 中的内部函数：", res)

	return res
}
```

```php
<?php
$a = 0;
function Counter(){
    $i = 0;
    
    $res = function () use (&$i) {
        $i += 1;
        
        return $i;
    };
    echo 'i的值' . $i . "\r\n"; 
    $res();
    echo 'i的值' . $i .  "\r\n";
    
    return $res;
}

$myFunc = Counter();
var_dump($myFunc);
var_dump($myFunc());
var_dump($myFunc());
var_dump($myFunc());

$myFunc1 = Counter();
var_dump($myFunc1);
var_dump($myFunc1());
var_dump($myFunc1());
var_dump($myFunc1());

var_dump($myFunc == $myFunc1);
```

- https://www.bilibili.com/video/BV1kT4y1E7XK?from=search&seid=9084713182768752209
- https://www.bilibili.com/video/BV1sK411F7Jo?from=search&seid=13901280632520219153
- https://www.bilibili.com/video/BV1jK4y1H7hP?from=search&seid=15028811673721851652
- https://www.bilibili.com/video/BV1ma4y1e7R5?from=search&seid=408230272287357583
- https://lotabout.me/2016/thoughts-of-closure
- http://www.ruanyifeng.com/blog/2009/08/learning_javascript_closures.html
- https://www.zhihu.com/question/283708101
- https://laravelacademy.org/post/4341.html
- https://segmentfault.com/a/1190000039306686
- https://learnku.com/articles/5304/graphical-javascript-closure
- https://learnku.com/articles/5388/closures-and-anonymous-functions-of-php-new-features
- https://www.php.net/manual/zh/functions.anonymous.php
- https://blog.csdn.net/wuxing26jiayou/article/details/51067190
- https://blog.csdn.net/qq_27718961/article/details/91043221
- https://www.cnblogs.com/f-ck-need-u/archive/2018/10/01/9735955.html

### 可变参数和递归

5、可变参数

```golang
func 函数名(参数名...类型) [(返回值列表)] {
    // code
}
```

如果一个函数的参数，**类型一致**，但个数不一定，可以使用函数的可变参数

- 个数不一定的参数，其类型一定是一致的
- 可变参数在参数列表中需要放在最后一个
- 一个函数的参数列表中，只能有一个可变参数
- 可变参数列表是一个切片类型

```golang
 package main

import "fmt"

func main() {
    name, sum, avg, count := GetScore("zhangsan", 90, 82.5, 73, 64.8)
    fmt.Printf("%s 共有 %d 门成绩，总分为：%.2f, 平均分：%.2f\n", name, count, sum, avg)
}

func GetScore(name string, scores ...float64) (student string, sum, avg float64, count int) {
    fmt.Printf("scores的类型是:%T\n", scores)
    student = name
    for _,score := range scores {
        sum += score
        count++
    }

    avg = sum / float64(count)

    return
}
```

6、递归函数：在函数内部调用其自己

- 每一次调用自己，理论上都需要更加接近于解（递归问题一般用于解决将大问题拆成无数个相同的小问题）
- 必须有一个终止处理或计算的准则
- 递归函数的优点：定义简单，逻辑清晰。理论上，所有的递归函数都可以用循环的方式实现，但循环的逻辑不如递归清晰
- 使用递归函数要注意防止栈溢出。
    - 在计算机中，函数的调用是通过栈(stack)这种数据结构实现的，每当进入一个函数调用，栈就会增加一层，每当函数返回，栈就会减少一层。
    - 由于栈的大小不是无限的，所以递归调用的次数过多，会导致栈溢出
    - 因此在使用递归解决问题时要考虑：**递归的层数是否会过多-过多那么就需要考虑使用循环或其他的方式来进行拆分？自己写的递归函数调用代码是否添加了终止条件？**

```golang
package main

import "fmt"

func main() {
    
}

// 通过递归实现阶乘
func factorial (n int) int {
    if n == 0 {
        return 1
    }
    
    return n * factorial(n-1)
}

// 通过循环
func getMultiple(num int) (result int) {
    result := 1
    for i := 1; i <= num; i++ {
        result *= i
    }
    
    return
}
```

### 指针

7、指针：存储另一个变量的内存地址的变量（盒子模型）
- 计算机是不认识“变量名”的，编译后的程序是没有变量名存在的。变量只是一种使用方便的占位符，变量都指向计算机的内存地址。
- 指针是存储另一个变量的内存地址的变量
- 声明指针变量：var 指针变量名 *指针类型
- 根据变量指向的值是否是内存地址，变量可以分类为：
	- 普通变量：存储数据本身
	- 指针变量：存值的内存地址
- 获取变量的指针：&<name>-从一个普通变量中获取内存地址
- 获取指针变量所指向的变量的值：*<指针变量>-读取一个指针所指向的变量、 *&<name>

Go语言指针的特点：
- Go 语言指针的最大特点是：指针不能运算（与C语言不同）
- Go 语言如果对指针进行运算会报错`nvalid operation: p++ (non-numeric type *int)`

- 为什么会有指针这种类型？
- 指针和引用变量的区别？
- 指针有什么好处？


- 空指针：当一个指针变量定义后没有被分配到任何变量时，它的值就是 nil（Go 语言中的 nil 相当于其他语言中的 null NULL None，指代空值）
```
prt == nil // 空指针
```

- 指针数组：元素是指针类型的数组，如：`var prt [3]*string`。元素个数相同、**将数组中每个元素的值赋值给该指针数组**，这样才是将一个指针数组与数组完全对应起来

- 指针的指针：一个指针变量存放的是另一个指针变量的地址，那么称该变量为指向指针的指针变量 `var ptr **int`

- 通过指针、引用来阐述一下为什么函数内部改变了变量的值外部实际是没有变更的？
    - 使用指针直接修改变量的值
    - 使用指针作为函数的参数（指针作为函数参数只是复制了一个指针，指针指向的内存地址没有发生改变）

### 函数的参数传递

8、函数使用的参数，该参数变量称为：形参。即：定义在函数内部的局部变量
- 形参-值传递：调用函数时将实际参数**复制**一份传递到函数中
    - 这样函数内部如果对参数进行修改将不会影响到原始内容数据
    - **默认情况下，Go语言使用的都是值传递**
    - **==Go語言中不支持形参带默认值==**（Go语言追求显式的表达，避免隐含）
- 形参-引用传递：调用函数时将实际参数的地址传递到函数中
    - 那么在函数中对参数所进行的修改，将影响到原内容的数据：**使得多个函数可以操作同一个对象**
    - **严格来说，Go语言只有值传递这一种传参方式，是没有引用传递的**
    - 但 Go 可以借助指针来实现引用传递的效果
    - 函数参数使用指针参数，传参的时候其实是复制一份变量地址（虽然也是按照值传递的方式进行了复制，但仅仅只是**复制了一个指针-即：一个 8 bytes 的内存地址**，这样就不用担心造成内存浪费、时间开销、性能降低）
    - 当传递一些大的**非指针类型变量（如：int、string、bool、float、array、struct-结构体）时**，就不用担心花费较多的系统开销
    - **指针型数据类型：切片-slice、集合-map、管道-chan、指针-pointer**，实现机制都类似指针，所以可以直接传递而不是传递一个指针

**注意：修改形参是否可以修改实参内容数据与传值、传引用是没有必然关系的。**
1. 传引用和指针类型是两个概念：Go中只有传值一种方式，但是可以通过传指针类型来达到与传引用一样的效果
2. C++中传引用肯定是可以修改原数据内容的


Golang 中形参的传递是否利用了 COW（Copy-On-Write）呢？
- https://groups.google.com/g/golang-nuts/c/8EaHWaZEZ5M?pli=1
- https://codingnote.cc/p/41226/
- https://blog.csdn.net/qq_16059847/article/details/116176979
- PHP中的写时复制：https://www.kancloud.cn/kancloud/php-internals/42801

## Go语言的内置容器

### 数组

9、数组：**相同类型**的一组数据构成的**长度固定**的序列。
- 与PHP 不同，Go 语言中的元素是没有名字的，key 只能是数字（下标索引从0开始）
- 只能通过索引下标进行访问，且数组**长度必须是大于0的正整数**
- **==数组在内存中是一段连续的存储区域，所以数组的检索速度非常快==**
- 数组的缺陷：长度不可变
- **未初始化的数组不是nil，即：没有空数组一说法。譬如：[3]int 那么默认是 [0 0 0]，不存在空数组**

10、声明数组
- 只声明不初始化：`var param [len]Type`
- 声明并且初始化：`var param = [len]Type{value0[ , ... , valueN]}`【注意：N-1 <= len】
- 不设置长度数组：`var param = [...]Type{value0[ , ... , valueN]}`【Go编译器会根据元素个数来自动计算设置数组的长度】

11、数组的长度-len()函数获取【**数组的长度是数组的一个内置常量，长度亦是其类型的一部分。因此：[4]int 和 [5]int 是不同的两个数组类型**】

12、遍历数组的几种方式
- 循环遍历：`for i:=0; i < len(arr); i++ {}`
- for-rang：`for key,value := range arr {}`

13、多维数组（var mulitArr [x][y][z]Type）
- **多维数组的本质也是一个一维数组，只是由多个嵌套的一维数组组装而成罢了**
- 多维数组（N维）元素的基本类型就变成了 N-1 维数组
- 访问：mulitArr[x][y][z]

14、数组指针：**长度亦是数组类型的一部分，因此一个 [2]int 的数组，其指针是 `*[2]int`（此处和C语言中不同-`[2]*int`）**

```golang
package main

import "fmt"

func main(){
        arr := [2]int{1,2}
        fmt.Printf("%p %v\n", &arr, arr);
        var point *[2]int = &arr
        point[0] = 2
        fmt.Printf("%p %v %v\n", point, *point, arr);
}
```


### 切片

15、切片：**相同类型**的一组数据构成的**可变长度**的序列

> 数组：**相同类型**的一组数据构成的**长度固定**的序列。

在很多场景中，初始化定义数组时，数组的长度并不可知，这样的序列集合无法满足需求。所以，切片使用的相对更多。

16、声明切片
- **声明一个nil切片**：`var sliceParamName []type`：声明一个未指定长度的数组方式，**切片不需要说明长度**
- **通过make函数的方式声明并初始化切片**：`var sliceParamName []type = make([]type, len)` 其等价于 `sliceParamName := make([]type, len, cap)`
- **通过字面量的方式，截取数组获得切片**：`sliceParamName := arr[start:end]`【截取的数组是其底层数组`arr` start-(end-1) 的下标元素，start默认是0，end默认是len(arr)】==>**左闭右开区间**
    - 对于底层数组-arr的容量是k，那么 `slice := arr[i:j]`，slice 的长度为 `j-i`，容量是 `k-i`
- **通过字面量的方式，截取数组并限制容量获得切片**：`sliceParamName := arr[start:end:cap]`
    - 截取数组 start 至 end-1 的元素
    - 长度为：end-start
    - 容量为 cap-start
- **通过字面量声明并初始化切片**：`slice := []int{0,1,2,3}`
- **通过字面量指定切片的大小和容量**：`slice := []int{9:10}` 
    - **在这种情况下，容量和长度是相等的**
    - **其第10个元素被初始化赋值为 10**

17、关于 nil 切片、空切片、nil

对于一个**只声明未初始化**的切片称为“nil切片”-不存在的切片。

对一个只有空集（即：已经声明并初始化，只是分配的存储空间长度是0）的切片叫空切片。

- **nil切片默认为 nil，长度为 0，容量为0**，有且仅有一种方式声明 nil 切片：`var nilSlice []int`
- **空切片默认为空集`[]`，长度为 0，容量为0**。空切片表示声明并初始化了一个空集，例如：`slice := []int{}`、`slice := make([]int, 0, 0)`、`slice := arr[:0]`
- **注意make([]type, len, cap) 已经对切片进行了初始化，其不等于 nil**
- slice can only be compared to nil。即：**切片只能和 nil 进行比较，切片不能和切片进行比较**

```golang
var nilSlice []int

// nil切片的值：[] 长度：0 容量：0 类型：[]int 是否等于nil：true
fmt.Printf("nil切片的值：%v 长度：%d 容量：%d 类型：%T 是否等于nil：%t\n",nilSlice,len(nilSlice), cap(nilSlice),nilSlice, nilSlice == nil)

var numEmptyList = []int{}
// nil切片的值：[] 长度：0 容量：0 类型：[]int 是否等于nil：false
fmt.Printf("空切片的值：%v 长度：%d 容量：%d 类型：%T 是否等于nil：%t\n",numEmptyList,len(numEmptyList), cap(numEmptyList),numEmptyList, numEmptyList == nil)
```

[面试题：nil切片和空切片有什么不一样？](https://mp.weixin.qq.com/s/myGJ4TrEoVGqLAN3tbZHMw)

18、切片深度分析

```go
// runtime/slice.go
type slice struct {
	array unsafe.Pointer // 数组指针
	len   int // 当前切片的长度（可见元素）
	cap   int // 当前切片的容量（当前开辟的空间一共能装多少元素）
}
```

从切片的源码（`runtime/slice.go`）来看，**切片的底层也是一个指针数组对象，切片是引用类型，而数组是值类型**。

- 扩容前：此时其底层都是同一个数组指针对象，所以修改其中一个元素，新切片、旧切片、切片对应的数组都会受到影响
- 扩容后：
    - **当且仅当`cap -len = 0` 时切片又被追加元素，切片会进行扩容操作**
    - **如果切片的底层数组没有足够的容量时，就会==新建一个底层数组==，把原来数组的值复制到新底层数组里，再追加新值，这时候就不会影响原来的底层数组了**
- 切片的底层是一个数组指针对象，因此：**==切片在内存中也是一段连续的存储区域，所以切片的检索速度非常快==**

**所以：`unsafe.Sizeof(slice)`可以得到在64位系统中，该值恒定为 24 字节。所以当切片作为参数传递的时候，几乎没有性能开销，因为只是传递了：底层数组指针、长度、容量**

18、切片的长度和容量

- len：表示当前切片中所对应的底层数组`array`可访问的元素有多少个。譬如：`make([]int, 5, 10)` 现在其底层数组是一个长度为 10，默认值为0（int类型默认值为0）的数组，但是 `make` 函数只是进行了声明，初始化却只初始化了`0-4` 号位的元素，表示`0-4`号位的元素可被访问，`5-9`号位的元素是不能被访问的
- cap：分片的容量是底层数组中的元素数，**分片的容量从分片的第一个元素开始计算**。


19、切片操作-增删查改、复制、遍历

```golang
var slices []int

// 增-append(目标切片变量, 元素[,...,元素])

// 尾部添加元素
slices = append(slices, 1) // []int{1} 添加一个元素
slices = append(slices, 2,3,4) // []int{1,2,3,4} 添加一个元素

// 头部添加元素
// ... 是 Go 中的一个语法糖，在函数中表示接受多个不确定数量的参数
// ... 在切片语法中表示被打散进行传递
slices = append([]int{-2,0}, slices...) // []int{-2 0 1 2 3 4}

// 中间添加元素-由于没有扩容前其底层是同一个数组，中间插入元素比较麻烦

// 为何下方这个表达式，不能在元素1位置插入-1元素，而是改变了下标1的元素呢？操作过程中，没有扩容，所以其底层是同一个数组
// slices = append(append(slices[:1], -1), slices[1:]...)

sliceTemp := make([]int, len(arr)) // 1. 先声明并初始化一个临时独立新切片
copy(sliceTemp, slices) // 2. 将slices复制到新的独立切片sliceTemp中
slices = append(slices[:1], -1) // 3. []int{-2,-1} 但是其底层数组仍然是同一个，因此容量为 6
slices = append(slices, sliceTemp[1:]...) // 4. 将临时切片底层数组中[1:len(sliceTemp)]追加到切片slices中

index := 2
slice2 := slices[:index:index]
slices = append(append(slice2, -3, -2), slices[index:]...)


// 删-slice[i:j]
fmt.Println("======切片删除测试：slice[i:x]========")
slice := []int{-5,-4,-3,-2,-1,0, 1, 2, 3, 4}
// 源切片：[-5 -4 -3 -2 -1 0 1 2 3 4] len:10 cap:10 ptr:0xc0000a2000 slice[1]:0xc0000a2008
fmt.Printf("源切片：%v len:%d cap:%d ptr:%p slice[1]:%p\n", slice, len(slice), cap(slice), slice, &slice[1])

fmt.Println("==========删除尾部元素================")
slice = slice[:len(slice)-1]
// 删除尾部：[-5 -4 -3 -2 -1 0 1 2 3] len:9 cap:10 ptr:0xc0000a2000 slice[1]:0xc0000a2008
fmt.Printf("删除尾部：%v len:%d cap:%d ptr:%p slice[1]:%p\n", slice, len(slice), cap(slice), slice, &slice[1])

fmt.Println("==========删除头部元素================")
slice = slice[1:]
slice1 := slice
// 删除头部：[-4 -3 -2 -1 0 1 2 3] len:8 cap:9 ptr:0xc0000a2008
// 为什么 cap() 的容量会变？https://stackoverflow.com/questions/47817849/behaviour-of-pointer-in-slice
fmt.Printf("删除头部：%v len:%d cap:%d ptr:%p\n", slice, len(slice), cap(slice), slice) // 

fmt.Println("==========删除中间元素================")
center := int(len(slice)/2)
slice = append(slice[:center], slice[center+1:]...)
// 删除中间：[-4 -3 -2 -1 1 2 3] len:7 cap:9 ptr:0xc0000a2008
fmt.Printf("删除中间：%v len:%d cap:%d ptr:%p\n", slice, len(slice), cap(slice), slice)
// slice1：[-4 -3 -2 -1 1 2 3 3] len:8 cap:9 ptr:0xc0000a2008
// 为什么 slice1 会是 [... 3 3] ？？：删除中间元素的操作对于底层数组来说是后续元素往前复制移动了1位，但最后一位元素没有被改变
fmt.Printf("slice1：%v len:%d cap:%d ptr:%p\n", slice1, len(slice1), cap(slice1), slice1)


// 查：和访问数组一样 slice[index] 方式访问


// 复制：将源切片-slices复制到目标切片-slices2中，两个切片不存在联系
// 复制元素个数 := copy(目标切片，源切片)
var slices2 []int
slice2 := []int{0,1,2,3,4}
fmt.Printf("slice2：%v len:%d cap:%d ptr:%p\n", slice2, len(slice2), cap(slice2), slice2)
// 通过 copy 复制出一个独立无关联的切片
slice3 := make([]int, len(slice2))
count := copy(slice3, slice2)
fmt.Printf("slice3：%v len:%d cap:%d ptr:%p\n", slice3, len(slice3), cap(slice3), slice3)
fmt.Printf("slice2-->slice3 复制了：%d 个元素\n", count)

// 通过字面量方式声明赋值得到一个切片（记住：切片是引用类型，其数据结构是：数组指针对象+len+cap）
slice4 := slice2
fmt.Printf("slice4：%v len:%d cap:%d ptr:%p\n", slice4, len(slice4), cap(slice4), slice4)

slice4[0] = 4 // 通过赋值方式得到的新切片，其底层仍然是同一个数组指针对象，所以 slice2[0] 也会受到改变
slice3[0] = 3 // 通过copy方式得到的新切片，其底层是一个独立、崭新的数组指针对象，所以 slice2[0] 不会受到改变
fmt.Printf("slice2：%v len:%d cap:%d ptr:%p\n", slice2, len(slice2), cap(slice2), slice2)
fmt.Printf("slice3：%v len:%d cap:%d ptr:%p\n", slice3, len(slice3), cap(slice3), slice3)
fmt.Printf("slice4：%v len:%d cap:%d ptr:%p\n", slice4, len(slice4), cap(slice4), slice4)


// 遍历-for、for-range
fmt.Println("==========for遍历切片================")
for i:=0; i < len(slice); i++ {
    fmt.Printf("第%d位元素：%v\t", i, slice[i])
}

// index 和 value 的地址始终是不变的
// 它们始终是同一个变量，只是变量引用地址的内容发生了变化，只是切片元素的副本
fmt.Println("\n=========for-range遍历切片===========")
for index, value := range slice {
    fmt.Printf("第%d位元素：%v\t", index, value)
}
fmt.Println("\n")
```

- https://mp.weixin.qq.com/s/Hl6qExD0PSA29ZoaD4WitA
- https://juejin.cn/post/6844903812331732999
- 关于切片扩容问题：https://blog.golang.org/slices-intro （为什么需要容量？扩容后的切片还是一段连续的内存地址吗？）
- 那种初始化切片的方式效率更高？？
- golang 接口、反射和指针：https://juejin.cn/post/6844904049406377991
- 我应该声明切面的容量吗？https://dev.to/jonathanlawhh/golang-slice-vs-array-and-should-i-declare-my-slice-size-4kng
- Go 开发中的十大常见陷阱[译]：https://tomotoes.com/blog/the-top-10-most-common-mistakes-ive-seen-in-go-projects/
- https://www.huaweicloud.com/articles/b1e7ea747d477e06e51bf3303fc30bd7.html
- https://stackoverflow.com/questions/47817849/behaviour-of-pointer-in-slice
- https://tour.golang.org/moretypes/11
- https://ispycode.com/Blog/golang/2016-10/Difference-between-Length-and-Capacity
- 切片(slice)性能及陷阱：https://geektutu.com/post/hpg-slice.html
 
### map-字典

字典是一种 “Key=>Value” 键值对映射关系的数据集合（其它语言中叫地图、映射或字典），是Hash表的一种实现。

- **map 是无序的，每次打印出来的 map 都会不一样，必须通过 key 获取，无法通过 index 获取**
- **map 的长度是不固定的，和切片一样可以扩展**
- **map 可以通过 len() 获取键值对数量，但无法通过 cap() 函数计算容量** ==> 是因为其底层是散列哈希表存储，地址不是连续的导致的吗？
- **同一个 map 中 key 必须是唯一的**
- **map 中的 key 的数据类型必须是可参与运算（支持 ==、!=操作）的类型，如：布尔类型、整型、浮点型、字符串、数组**
- **map 中的 key 数据类型有限定，但 value 的类型可以是任意数据类型**
- **map 是引用类型**

20、map 语法

- 通过 var 关键字定义 map （默认值为 nil）：`var 变量名 map[key数据类型]value数据类型`，如：`var country map[string][string]`
- 通过字面量方式定义并初始化：：`country := map[string][string]{"PHP":"web", "Go":"云原生"}`
- 通过 make 函数定并初始化：`变量名 := make(map[key类型]value类型)`

**注意：未初始化的map默认值是nil，nil map 是不能直接赋值的**。即：必须在声明时初始化，或使用 make() 函数进行初始化进行分配空间，否则会报错 `panic: assignment to entry in nil map`

**注意：通过字面量定义并初始化 map 时候，如果 } 单独成一行前一行结尾需要加逗号 ,**

```
// 正确
country := map[string][string]{
    "PHP":"web", 
    "Go":"云原生",
}

错误
country := map[string][string]{
    "PHP":"web", 
    "Go":"云原生"
}
```

会报错：**`syntax error: unexpected newline, expecting comma or }`**

```Golang
if myMap == nil {
    fmt.Print("未初始化的map零值是 nil ，不能直接赋值!需要使用 make() 函数进行初始化\n")
    myMap = make(map[string]uint8)
}
```

```golang
var nilMap map[string]string
// map len:0 pointer：0xc0000b8020 map:map[] equal nil:true
fmt.Printf("map len:%d pointer：%p map:%v equal nil:%t\n", len(nilMap), &nilMap, nilMap, nilMap == nil)

mapTest1 := map[string]string{}
// map len:0 pointer：0xc00000e038 map:map[] equal nil:false
fmt.Printf("map len:%d pointer：%p map:%v equal nil:%t\n", len(mapTest1), &mapTest1, mapTest1, mapTest1 == nil)
```

21、map 的遍历：因为 map 是无序的，多通过 for-range 方式遍历 `map`。
```golang
mapTest2 := make(map[string]string)
mapTest2["hello"] = "Golang"
mapTest2["hello1"] = "PHP"
mapTest2["hello2"] = "HTML"
mapTest2["hello3"] = "CSS"
for key, value := range mapTest2 {
    fmt.Printf("key: %s \t value:%s\n", key, value)
}

mapTest3 := map[int]string{1:"hello", 2:"abc", 3:"hhh"}
for i := 1; i <= len(mapTest3); i++ {
    fmt.Printf("key: %d \t value:%s\n", i, mapTest3[i])
}
```

22、map 操作

- 查询元素：`mapParam[key]`。
    - **注意：当 key 不存在时候，会得到该 value 数据类型的默认值**
    - `mapParam[key]` 其实会返回两个值： `value, exist := mapParam[key]`，第二个值 exist 是布尔型，表示该键值对是否存在
- 更新元素：`mapParam[key] = value`
- 删除元素：delete() 函数，用法 `delete(mapParam, key)`。**delete() 函数没有任何返回值**
- 如何copy一个map出来呢（copy函数只能用于切片）？？？只能`for-range`的方式进行遍历赋值

23、map 是引用类型，因此注意通过 newMap := oldMap 方式得到的字典，修改其值是相互影响的。

25、map 的特点是什么？使用的时候应当注意什么？？ 
- Golang 中的 map 扩容成本大，所以建议提前预设容量
- map 中及时全部元素被删除，其容量空间也不会被自动被 GC，要留意

