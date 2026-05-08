# 李三红·搞定Java开发基础

> https://time.geekbang.org/opencourse/videointro/100542901

[TOC]

## Java 虚拟机基础

> Java 虚拟机是 Java 的运行基石

### 01| 浅谈 Java 设计哲学：如何从软件一般实践原则理解 Java？

1、The Feel of Java - James Gosling 1997
- 1995 年发布
- 1997 年 Java 之父在 Computer 杂志发布：The Feel of Java
    - Java 是一门“蓝领语言”，是为了在工程中解决实际问题的
    - 并非用于做学术、研究的
- Java 创新比较慢
    - 向前兼容性

2、 对抗偶然复杂度（Accidental Complexity）- Java 中的「面向对象」& 「函数式编程」 是为了解决什么问题？

- Fred Brooks,1986 论文：《No Silver Bullet -- Essence and Accident in Software Engineering》 ==> 没有银弹
- 本质复杂度（Essential Complexity）：事情本身的复杂度（如需要处理 40w-50w/s 的请求状况）
- 偶然复杂度（Accident Complexity）：解决问题时可避免的复杂情况（如解决一个业务问题，用什么语言来实现？这是一个可选择的事情）
- 面向的编程范式，是对抗软件偶然复杂度的重要技术手段
    - Abstract Data Type（抽象数据类型）
    - Hierarchical types（等级类型）==>继承
- Mary Shaw 在其 Keynote 的演讲：软件工程的历史其实就是“抽象层次”不断提高的历史
- 书籍：
    - Design Patterns:Elements of Reusable Object-Oriented Software, 1994
    - 设计模式：大量的软件工程实践之后，从“面向对象”角度来对这些实践进行的经验总结（Fllow Best Practices -- 跟随最佳实践）
    - Agile Software Development, Principles, Patterns and Practices, 2002
    - 书中讲了很多面向设计对象的设计原则


面向对象的不足：
- OOP 不擅长的地方：sharedmutable state（有状态的编程）==> 无法保证语言本身幂等的操作
- 大量固定模式代码（Signal-to-noise ratio, boilerplate code） ==> 如：大量的 getter/setter，其实和逻辑本身是无关的；纯面向对象，导致其学习曲线比较陡峭


函数编程：（行为的映射或抽象，只要输入固定那么输出永远一样）
- 一定程度上解决了 Java 有状态编程的情况，Java 8 引入 stream API and Lambda Expressions





3、 软件工程实践 - 无所不在的 Tradeoffs（取舍）
- Progress Toward an Engineering Discipline of Software, Mary Shaw, 2016
- 软件工程实践的重要特征之一：Limited time,knowledge,and resources force decisions on tradeoffs.（所有的软件工程实现都是在有限的时间、知识、资源情况下做的一个取舍）
- 在解决方案和技术本身的取舍：各自的前提、假设是什么？

Java 在 Productivity/Performance 之间的取舍

- #1 Java 是 statically type 语言，但允许：
    - Dynamic class(type) lodaing
    - Dynammic method(code) modification(class/jar are essentially data, not code) ==> 面向对象中的类是数据的抽象，而非行为
    - Metaprogramming: Reflection(like RTTI in C++)/Annotation
- #2 Java 被认为是“safe, managed runtime”而设计，但留了很多“backdoors”:
    - Java Native Interface(JNI)
    - sun.misc.Unsafe
- #3 垃圾回收器
    - “infinite memory” & Stop-the-World
- #4 Just-in-Time 编译
    - Native performance speed & Time to warmup
- #5 弱分代假说（分代 GC）
- #6 Java Warmup 代价


“取舍”：理解问题的“前提、假设”，才能更好的理解问题的本质并选择出更好的技术方案。没有一个语言 或 技术方案是可以包打天下的...


4、内存安全与 Java

- 典型的 Memory Safety 问题
    - Buffer overflow
    - 内存泄漏
    - Use memory that has been freed
    - 使用未初始化的变量
- Secuity/Safety 是 Java 初始设计的动机之一，Java 也被称为 Memory-safe 的语言（屏蔽“指针”的概念）
    - Runtime error detection（例如：ArrayIndexOutOfBoundsException）
    - Pointer restrictions

Java 是一个“工程级”语言，为了解决工业界中的问题的编程工具。工业界中：安全至上，其次才是性能。

### 02｜Runtime & OpenJDK：如何从Java开发者视角理解OpenJDK基础？

> 掌握 Java 的生态系统基础，为架构选型、中间件选型...提供更好的角度

1、什么是 Language Runtime

2、OpenJDK 与 Java Ecosystem

3、OpenJDK 技术概览

### 03｜JVM调优（上）：如何理解GC、JIT原理并调优？



## 问题排查与性能调优

> 编程最终是掌握“解决问题”的能力：问题诊断、问题调优


## Java 并发原理与实践

> 多核、众核已经是现代计算机的发展现状和趋势，理解 Java 并发是趋势

## 大师访谈


- https://segmentfault.com/a/1190000016773324
- https://blog.csdn.net/w372426096/article/details/82216742
- https://tobebetterjavaer.com/basic-extra-meal/pass-by-value.html
