# Java for PHP Developer：06 - Java 8 新特性

[TOC]


- https://www.runoob.com/java/java8-new-features.html
- https://pdai.tech/md/java/java8up/java17.html

语法糖(`syntactic sugar`) 这一概念由英国计算机科学家 Peter.J.Landin 发明的一个术语。
- 含义：用更加简练的语法方式表达复杂的含义
- 目的：更加方便程序员书写代码，通过简单的代码可以代替复杂的代码编写

使用一些 “语法糖” 的时候需要注意两点：

- 语法糖对语言的功能并没有影响，编译器会将这些“语法糖”转为正常的代码，因此在所谓的“功能”、“运行性能”上基本不会有什么影响
- 语法糖其实牺牲了一部分代码逻辑上的可读性，但**当大众已经广泛已经熟悉接受的情况下，可以提升写代码、交流的效率**

## Java 8 新特性：Lambda 表达式

面向对象编程注重是对数据进行抽象，而函数式编程是对行为进行抽象。`Java` 是一个纯面向对象（行为+属性）的编程语言，不支持函数式编程（行为），而 `PHP` 是一个支持 面向对象/函数式编程 的语言。

以下是一段 `PHP` 实现闭包函数/匿名函数的示例代码：

```php
<?php
// 闭包例子（突破作用域，将内部局部变量返回给外部）
function test() {
	$a = 10;
	function inert($parm) {
		return $parm;
	}
	return inert($a);
}

$b = test();
var_dump($b); // 输出：int(10)

# 匿名函数的例子（一般是局部执行，为了偷懒所以不写方法名）
(function() {
	var_dump('hello,world!');	
})(); // 输出：string(12) "hello,world!"

// 匿名函数实现闭包
$test = (function() {
	$name = 'lms';
	return function() use($name) {
		var_dump('hello,' . $name . '!');	
	};
})();
$test(); // 输出：string(10) "hello,lms!"
```

函数式编程在某些情况下确实给开发者带来很大的方便，而在 `Java 8` 之前我们想要实现类似其它语言中的 “函数式编程” 几乎都需要借助繁琐的“内部类”的方式来实现，如下：

> 以下代码段 copy 于文章：[Java 8 Lambdas - Syntactic Sugar for Interfaces](https://www.developersoapbox.com/java-8-lambdas-syntactic-sugar-for-interfaces/)

```java
public class Main {

	// 定义一个接口 NamePrinter，接口中有且只有 1 个方法 printName
	interface NamePrinter{
		void printName(String name);
	}
	
	public static void main(String args[]){
		// 通过将一个匿名内部类对象赋值给 namePrinter 变量，并重写 printName 方法
		NamePrinter namePrinter = new NamePrinter(){
			@Override
			public void printName(String name) {
				System.out.println(name);
			}
		};
		
		// 运行
		namePrinter.printName("Renan");
	}
}
```

对于以上代码（**接口中有且只有 1 个方法**）的情况，有用的其实只有重写的 `printName(String name)` 的方法体。可能写 `Java` 的人呼吁太多，于是 `Java 8` 就加了 `Lambda` 表达式这一语法糖，方便简答的写类似的代码，如下：

```java
public class Main {

	interface NamePrinter{
		void printName(String name);
	}
	
	public static void main(String args[]){
		NamePrinter namePrinter = (name) -> System.out.println(name);

		namePrinter.printName("Renan");
	}
}
```

- [Java 8 - 函数编程(lambda表达式)](https://pdai.tech/md/java/java8/java8-stream.html)

## Java 8 新特性：Stream

自然也就没有接触过 `Stream` 这一特性了，咋一听名字还以为是 [Java I/O Stream](https://www.runoob.com/java/java-files-io.html)，即：[Java 字节流：Java IO 的基石](https://tobebetterjavaer.com/io/stream.html)。


### 什么是 Stream？




## 附录-学习资料

- [Java8 Stream 编码实战](https://mp.weixin.qq.com/s/N3RtXM45bLAqsWRkMElSiw)；公众号：CodeerBuf 作者：Okevin
- [全面吃透JAVA Stream流操作，让代码更加的优雅](https://mp.weixin.qq.com/s/bkMPvugJlS1jyUwUnFu1HQ)
- [Java 8 Stream流：掌握流式编程的精髓](https://www.runoob.com/java/java8-streams.html)
- [Java 8 新特性：Stream](https://www.runoob.com/java/java8-streams.html)
- [Java基础系列-Collector和Collectors ](https://www.cnblogs.com/V1haoge/p/10748925.html)