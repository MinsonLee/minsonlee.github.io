《Java核心技术·卷Ⅰ》：针对 Java SE  9、10、11系统讲解了Java语言核心概念、语法、重要特性和开发方法


## 与 PHP 不一样，特别容易让人忽视的点：

1. PHP 和 Java 的数据类型有较大差异；
2. PHP 变量要用 $ 打头，而 Java 只讲究命名规范；
3. Java 是完全面向对象操作的，而 PHP 除了支持面向对象、面向过程、函数式编程等多种编程模式；
4. 针对 private/protected/public 这些面向对象（封装/继承/多态）设计概念在 Java/PHP 中是一致的【**继承会将私有属性也一并继承，只是子类无法直接访问private属性，但是子类通过反射是可以得到父类的私有属性和方法的**】
5. PHP 对象通过`$obj->funcName()/$obj->param` 访问方法；而Java 通过 `obj.funcName()/obj.param` 访问。（静态方法，PHP通过`Class::name()`访问，但是Java中是通过 `Class.name()` 看的出来 Java 对于方法的调用符是不区分类方法/对象方法的）
6. **PHP 是弱类型，而 Java 是强类型，不要将 PHP 忽略返回值类型判断的“陋习”带到 Java 中来 ==> 在 PHP 中也要尽可能的养成：严格的对返回值进行类型判断、数组越界、null 调用等 warning 情况的避免，因为在 Java 中这些警告是致命的错误**。
7. Java 中一个方法到底是不是内联(inline)方法（即：getter/setter方法）由 JVM 自动处理；而 PHP 没有所谓的内联方法（即：getter/setter方法都需要用 $this，而不能缺省）。
```java
class A {
    private name;
    
    // 等同于 public function getName() { return this.name};
    public function getName() { return name};
}
```

```php
class A {
    private name;
    
    // 不能写为：public function getName() { return $name};
    public function getName() { return $this->name}; 
}
```


## 第一次阅读：快速通读==>弄清全书脉络，重点是什么？

- Date: 2022/06/14
- Times: 第1次阅读
- 目标：
    - 弄清楚全书脉络
    - 掌握目前 Java 8 的语法和基础语法特性
    - 会写简单 Demo
- 回答：
    - 卷1 主要讲解 Java 的基础数据类型及其语法、常用 API 的使用，可跳读后续几章讲了 GUI 的编程
    - 对于有其他编程经验，但初学 Java 的用户来说，非常建议阅读书内的“警告”、“注释”信息，能较好的掌握 Java 的一些编程规范建议，写出优雅的代码
    - 可重点阅读章节：
        - 第4章-对象与类：Java 是完全面向对象设计的语言，对比学习能较好的让你快速大致掌握 Java 面向对象的一些特点和概念
    - 对实战项目、JavaWeb 编程帮助较小，估计在卷2内容


## 第二次阅读：细读 ==>弄懂疑问、有哪些值得吸收的

1. Java 语法中的基本数据结构有哪些？
2. String 和其他语言中的 String 有什么区别？
    - Java 中的 String 是一个预定义类，一个字符串应该是一个 String 类对象
    - Java String 对象又称为：不可变对象，其不支持修改字符串中的某一个字符。只能通过 substring 截取重新拼接重新赋值给对象
        - 为什么呢？设计者认为字符串是比较少需要更改某个字符的，因此Java String 在编译器中是可共享的，相比单字符修改设计者认为：共享字符串带来的效率更高
    - Java 通过 String 类中内置提供了很多预定义方法来操作 String
    - C 中沒有字符串这种数据类型，而是一个字符数组，char[]
    - PHP/Go 中 String 属于基本数据类型，要操作字符串需要使用特定的字符串函数
3. [String 类常见操作](https://www.runoob.com/manual/jdk11api/java.base/java/lang/String.html)
    - 截取：s.substring(from,to)
    - 重复：s.repeat(int count)
    - 长度：s.length()
    - 拼接：+、String.join("分隔符", char....)
    - 相等：s.equals(t)、s.equalsIgnoreCase(t)-不区分大小写；s.compareTo(t)，将字符串按ASCII码顺序进行比较，0-相等，负数-s小于t，正数-s大于t
    - ==：通过`==`比较，只能判断两个比较的字符串是不是存放在同一位置上（编译器共享字符串）
    - 空串： s.equal("")、s.length() == 0 ==> `if(s != null && s.length() == 0)` ==> **先要保证对象不为 Null**
    - Null串: `s == null`，表示什么都没有

-------------