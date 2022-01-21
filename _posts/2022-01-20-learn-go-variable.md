---
layout: post
title: "Go语言-变量"
date: 2022-01-20
tags: [Go]
---

## Go 语言编程需知
**！！！！Go设计者的思想：一个问题尽量只有一个解决方法**

1. 【错误】`package main` 声明文件所属包的时候，包名`main`是不需要用双引号括起来的，括起来会报错
2. 【错误】`Golang` 中**字符串需要使用双引号括起来**而不能使用单引号(**单引号括起来的是单字符**)
3. 【错误】`Golang` 中花括弧 `{` 是不能单独成行的，且花括弧需要成对存在
4. 【警告】`Golang` 中不需要在语句后方加分号`;`进行显示标注该语句结束
5. 【错误】`Go` 语言中定义的变量或 `import` 的包在程序中没有使用过，编译时就会报错
6. 【错误】`Go` 是静态编译、强类型语言，严格区分大小写

## 变量的创建

**变量的创建：`var <varName> [<varType>] [= <defaultValue>]`**

1. 正常方式声明 `var <varName>,...,<varName1> <varType>`。若采用该方式，则多个变量的**类型必须要统一，默认值为数据类型零值**
2. 编译器类型推导：`var <varName>,...,<varName1> = <defaultValue>, ..., <defaultValue1>`。多个变量的**类型可以不统一**
3. 短申明方式：`<varName>,...,<varName1> := <defaultValue>, ... , <defaultValue1>`。多个变量的**类型可以不统一，类型由编译器自行推导**
4. 批量声明 `var (<varName> <varType> = <defaultValue>, <varName1> <varType1> = <defaultValue1>)`
5. 在 `Go` 中，函数外部定义变量就是全局变量【实际应该是包全局变量】（定义包全局变量只能用1、2、4三种方式）。即：**短申明方式不能用于定义包全局变量**。
6. **短申明方式只能在函数内定义变量使用**

### FAQ

**1、Go设计者的思想是“一个问题尽量只有一个解决方法”，那么为啥会有两种申明变量的方式？到底用哪种？有什么区别？**

> [为什么 Go 有两种声明变量的方式，有什么区别，哪种好？](https://mp.weixin.qq.com/s/ADwEhSA1kFOFqzIyWvAqsA)

一共其实两种：标准变量申明-使用`var`进行申明；短变量申明-使用`:=`申明。区别在于：

- **短变量：**
    - 必须要给变量一个默认值
    - 只能用于函数内部变量定义
    - 在局部变量申明赋值中有明确优势
    - 使用短变量在多变量同时申明时若**有新变量时**，可以对变量进行重新申明

```golang
if idx, value := range array {
    // 直接使用 idx，value
}

temp := 22
//temp := 2 单独对tmep重新申明定义会报错
temp,temp1 := 2, 1 // 但多变量申明定义中有新变量时，则不会报错
fmt.Println(temp1)
fmt.Println(temp)

// 重新申明的特性常常用于 err 的处理
if err := recover(); err != nil {
    fmt.Println(err)
}
if err := recover();err != nil {
    fmt.Println(err)
}

// 注意：此处 fi 和 data 在同一个作用域下，因此此处不能重新定义申明 fi, err := xxx
var filename = 'xxx.txt'
fi, err := os.Stat(filename)
fmt.Printf("%v", fi)

data, err := ioutil.ReadFile(filename) 
if err != nil {
    log.Fatal(err)
}
fmt.Printf("%v", data)

// 注意：作用域改变了，因此可以重新申明定义
var nameTest = "xxxx.txt"
fi, err := os.Stat(nameTest)
fmt.Printf("%v", fi, err)
if fi, err := ioutil.ReadFile(nameTest); err != nil {
    log.Fatal(err)
    fmt.Printf("%v", fi)
}
```

- **标准申明变量**
    - 函数之外，必须使用标准申明。
    - 预定义变量（即：只申明不赋值），必须使用标准申明