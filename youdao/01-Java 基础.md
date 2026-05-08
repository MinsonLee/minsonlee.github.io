[TOC]

# 1、基础语法

> XML格式创造者之一的Tim Bray所说："我很肯定，你能够用PHP写出干净、易读、可维护的代码。但是显然，你稍一放松就做不到这一点了。"

没什么特殊的语法。。。

- [Java和Php比较 | Victor's Blog](https://victorfengming.gitee.io/comic/php-vs-java/)
- [java 与 php 区别或异同(整理、整合)-阿里云开发者社区](https://developer.aliyun.com/article/66251)
- [php和java对比_php与java的性能差距-CSDN博客](https://blog.csdn.net/arv002/article/details/134198680)
- [Difference Between Java and PHP - Javatpoint](https://www.javatpoint.com/java-vs-php)
- [PHP vs Java: A Practical Comparison](https://www.squash.io/php-vs-java-a-practical-comparison/)
- [The Java HotSpot Performance Engine Architecture](https://www.oracle.com/java/technologies/whitepaper.html)
- [HotSpot JVM 运行结构 图解_hotspot流程图-CSDN博客](https://blog.csdn.net/chenyao1994/article/details/123900537)


# 2、流程控制

- 条件分支语句：`if`、`if-else`、`if-else if-else`、`switch-case`
- 循环语句：`for`、`foreach`、`while`、`do-while`
- `break`、`continue`

# 3、数据类型及转化

`Java` 是纯面向对象的编程语言，除了 8 种基本数据类型外，其他的数据类型都是通过“对象”对外提供的，同时 `Java` 官方也提供了丰富的工具类（如 `java.util.Arrays`、`java.util.ArrayList`...）

## 基础数据类型

- 8 种基础数据类型（值类型）：`boolean`、（`char`、`short`、`byte`） --> `int` --> `long` --> `float` --> `double`（自动类型转换）
- 8 种基础类型有对应的包装类（Wrapper Types-不可变类型，引用类型）：`Boolean`、`Character`、`Short`、`Byte`、`Integer`、`Long`、`Float`、`Double`
    - 基础类型 --> 包装类（不可变类型）：自动装箱；
    - 包装类 --> 基础类型：自动拆箱


**包装类：使用 `OOP` 的思想，将基础类型封装为指定的类对象，同时在包装类中实现一些常见的操作方法，方便使用！！！**


## 其他常见数据类型

- 其他不可变类型：字符串-`String`、任意精度整数-`BigInteger`、任意精度浮点数-`BigDecimal`
- 符合复合类型-对象：Array、List、ArrayList、Collection-集合、枚举-Enum

附录：

- [Java基本数据类型缓存池剖析（IntegerCache）](https://javabetter.cn/basic-extra-meal/int-cache.html)
- [聊聊Java中的不可变对象](https://javabetter.cn/basic-extra-meal/immutable.html)
- [[Java]BigDecimal与Double的区别和使用场景 - knqiufan - 博客园](https://www.cnblogs.com/knqiufan/p/17724440.html)
- [【Java】不可变类(immutable)总结_java不可变量immutable-CSDN博客](https://blog.csdn.net/ican87/article/details/90643449)




## 数组-Arrays

- 在内存中开辟一个块固定连续的空间，对**指定个数**的**相同类型（可以是基础数据类型或引用类型）**的数据**按照一定顺序**进行存储
- 数组本身是一个**引用类型**（变量保存的是内存的首地址），数组长度指定之后**长度不能改变**
- 数组下标：表示的**当前元素在距离“首地址”的第 `N` 个单元格**的位置。
- 数组中存储的元素类型一样，因此单元格的长度也固定，因此第一个元素的下标是从 `0` 开始

数组声明/初始化/赋值格式：

- `String[] strArr;` // 声明数组：此时内存中还没有分配空间
- `strArr = new String[5];` // 动态初始化数组：在内存中开辟了空间-只确定数组长度，不进行赋值
- `strArr[0] = "a";` // 数组赋值：在开辟的空间中存储数据
- `String[] strArr1 = new String[]{"a", "b"};` // 声明 + 显示初始化 + 赋值 >>> 静态初始化：初始化的同时并赋值
- `String[] strArr2 = {"a", "b"};` // 声明 + 隐式初始化 + 赋值
- 语法正确，但不推荐：`String param[5];`
- 语法错误，静态初始化不需要指定长度，由 `JVM` 自行判断长度：`String[] param = new String[2]{"a", "b"}`


### 多维数组：

- 「`N`维数组」可以看作为多个 「`N-1`维数组」，最后递归为多个一维数组
- 「`N`维数组」的第 `N` 维的列数可以不一样

```java
public class ArrayTest {
    public static void main(String[] args) {
        int[] intTest1 = new int[1];
        intTest1[0] = 1;

        int[] intTest2;
        intTest2 = intTest1;
        intTest2[0] = 2;

        System.out.printf("%s %s\n", intTest1, Arrays.toString(intTest1));
        System.out.printf("%s %s\n\n", intTest2, Arrays.toString(intTest2));
        
        // 初始化分配地址空间
        int[] intTest3 = new int[1];
        int[] intTest4 = new int[1];
        System.out.printf("%s %s\n", intTest3, Arrays.toString(intTest1));
        System.out.printf("%s %s\n", intTest4, Arrays.toString(intTest2));
    }
}

// 控制台输出
[I@12edcd21 [2]
[I@12edcd21 [2]

[I@34c45dca [0]
[I@52cc8049 [0]
```

问题：

- 数组越界：`PHP` 中数组越界访问只会报 `Warning: Undefined array key xx`，`Java` 中会报致命错-`ArrayIndexOutOfBoundsException`
- 空指针异常：`PHP` 访问初始化未赋值的报 `Warning` 错误，`Java` 会报 `NullPointerException`

### 基础排序算法：冒泡、选择、插入、快排

![排序算法对比](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/comparison-of-sorting-algorithms.png)


- **时间复杂度：时间复杂度是评估算法性能的一种方式，主要衡量的是算法在运行时所需要的时间或者操作的次数，通过大O表示法描述。`O(1) < O(logn) < O(n) < O(nlogn) < O(n^2) < O(n^3) < O(2^n) < O(n!) < O(n^n)`**
- 空间复杂度：空间复杂度是另一个用于评估算法性能的概念，用于衡量算法在运行时所需“**额外空间**”的大小的一个大致估计，其并不能完全反映实际运行情况。
- 排序算法稳定性：指的是某排序算法**对于相同或相似输入是否产生相同或相似输出**的能力。以 `1、2、3(A)、3(B) 4` 为例，进行说明：
    - 相同输入：有两个 `3` 元素，其原始序列的相对位置是 `3(A)-3(B)`，如果通过某排序算法处理之后 `3` 这两个元素的相对位置始终都是 `3(A) ... 3(B)` 而不会出现 `3(B) ... 3(A)`，那么则说明该算法有较好稳定性
    - 相似输入：对于 `3(B)-4` 这个相对的顺序输入，在排序的任意过程中不会出现 `4-3(B)` 这种相对顺序变化，那么则说明该算法具有较好的稳定性


注意：

- 空间复杂度是一个相对概念，其与具体的实现细节、数据结构选择有很大的关系，而且目前计算机的空间比较廉价，因此对该复杂度的关注相对没有时间复杂度高。
- 算法的稳定性也是一个相对概念，它具体取决于算法的设计和实现方式，某些算法可能在不同的问题场景下表现出不同的稳定性。
- 对于只是简单的少量数据排序来说，排序算法的稳定性可以忽略不计。但对于海量复杂对象数据需要根据某个属性进行排序，那么稳定性不好的数据意味着需要花费更多的空间复杂度（更高的大O）和 更多的CPU或内存 消耗来进行数据对象的交换操作



附录：

- [十大经典排序算法（动图演示） - 一像素 - 博客园](https://www.cnblogs.com/onepixel/p/7674659.html)
- [通过动画可视化数据结构和算法 - VisuAlgo](https://visualgo.net/zh)
- [什么是排序算法的稳定性？-阿里云开发者社区](https://developer.aliyun.com/article/1247052?spm=5176.26934562.main.10.3d81438flewGEJ)


# 4、Java 面向对象（纯 OOP 语言）

精髓在于弄清楚“接口”、“面向对象”的使用场景
- 面向接口软件开发模式：可插拔/易扩展/解耦-业务抽象和代码实现分离
- 面向对象软件开发模式：主要是解决代码的抽象复用问题

## 什么是方法签名（Java Method Signature）？

在 `Java` 中类方法声明如下，与 `PHP` 大同小异：

```java
修饰符(public/private/default/protected) static final 返回值类型 方法名(形参类型 形参变量名称, ...) {
    //方法体
}
```

方法签名指的是：「方法名称」和「参数顺序及类型」组合成了在一个类中的唯一标识，这个标识就叫“方法签名”。即：`method_name(parameter_list_type)`

**注意：方法签名不包括方法的返回类型，不包括返回值和访问修饰符以及其他修饰符**

说一千道一万，不如实战看一看！

```java
/**
 * @description Java 方法签名测试
 * @author limingshuang
 */
public class MethodSignature {
    public static void main(String[] args) {
        System.out.println("Java Method Signature TEST");
    }

    // Method "test(java.lang.Integer, java.lang.String)"
    public static final void test(Integer a, String b) {}
    public static final void test(String a, Integer b) {}
}
```

方法1：通过 `IDEA`（提前安装 `Alibaba Java Coding Guidelines` 组件） 来查看，如下图

![show the java method signature by idea](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/java-method-signature.png)


方法2：通过 `javac` 编译源码，再通过 `javap` 类文件反汇编工具，结合其 `-s` 参数反解析 `*.class` 字节码文件（得到的是 `JVM` 内部使用的类描述文件），也可以推导分析得到方法签名： 

```cmd
PS D:\learn-java\src> javac .\MethodSignature.java -d D:\learn-java\out\test\learn-java
PS D:\learn-java\src> javap -s D:\learn-java\out\test\learn-java\MethodSignature.class
Compiled from "MethodSignature.java"
public class MethodSignature {
  public MethodSignature();
    descriptor: ()V

  public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V

  public static final void test(java.lang.Integer, java.lang.String);
    descriptor: (Ljava/lang/Integer;Ljava/lang/String;)V

  public static final void test(java.lang.String, java.lang.Integer);
    descriptor: (Ljava/lang/String;Ljava/lang/Integer;)V
}
```


## 方法重载与方法重写

- 重载（Overload）：**同一个类中方法名一样，形参列表不一样**。即，相同方法名，但方法签名不一样
- 重写（Override）：**子类对父类**的**非私有方法**的实现过程进行重新编写，其 **返回值和形参列表不变**。即：**子类中实现一个和父类中方法签名一样的方法（子类方法覆盖父类方法）**

## `Java/PHP` 中面向对象的区别

- “面向过程编程（POP-Protocol Oriented Programming）”：关注的焦点是过程
    - 过程即操作数据的步骤
    - 典型的语言：C 语言
    - 代码结构：以函数为组织单位。如果某个过程的实现代码重复出现，那么
就可以把这个过程抽取为一个 函数 。这样就可以大大简化冗余代码，便于维护。
- “面向对象面层（OOP-Object Oriented Programming）”
- “面向接口编程(OIP - Interface Oriented Programming:OIP)”

这些都是一种软件开发思维和模式，与具体的语言是无关的。

其中“面向对象（`OOP`） 软件开发模式”的主要特征表现在：封装、继承、多态、（抽象）。

在 `Java/PHP` 中对于封装、继承（单继承多接口实现）、（抽象）基本是一致无差别的，但在“多态”的表现上有些许不一样。

多态存在的三个必要条件：

- 继承（extends）：要实现多态必需要具备继承的能力
- 重写（Override）：父类与子类之间多态性的一种表现
- 父类引用指向子类对象，即：子类实例化父类-`Parent child = new Child()`。也是父类与子类之间多态性的一种表现

首先 `JAVA/PHP` 都是 `OOP` 语言，因此两者的多态特性必然都满足以上条件。

- `PHP` 实现面向对象的多态性基本符合必要条件，没有额外的扩展
- `Java` 实现面向对象的多态性除了满足上述基本条件外，**`Java` 的多态性还额外表现 「方法重载-`Overload`」上，`Overload` 是在同一个类中的多态表现**


附录：

- [什么叫方法签名](https://blog.csdn.net/qq_27093465/article/details/54907833)
- [封装、继承、多态和抽象 – OmegaXYZ](https://www.omegaxyz.com/2018/03/15/oop/)
- [面向接口编程优缺点](https://www.cnblogs.com/zhishan/archive/2013/05/13/3075158.html)
- [java - 为什么我们要面向接口编程？](https://segmentfault.com/a/1190000021928946)


## 5、常用 API


6.  Java 8 新特性/Java 17 新特性
7.  I/O 流
8.  日志
9. 多线程、并发
10. 网络通信
11. Java 反射、注解

*   B 站黑马 ： <https://www.bilibili.com/read/cv9965357>
*   2024最新Java学习路线 ： <https://www.bilibili.com/read/cv5216534/>
*   来吧，一文彻底搞懂Java中的Comparable和Comparator：<https://www.itwanger.com/java/2020/01/04/java-comparable-comparator.html>
*   Java基础系列-Collector和Collectors
*   <https://www.cnblogs.com/V1haoge/p/10748925.html>
*   unset：<https://blog.csdn.net/gong_yangyang/article/details/77941168>

[进程与线程的区别及联系 – OmegaXYZ](https://www.omegaxyz.com/2018/03/14/progressandthread/)