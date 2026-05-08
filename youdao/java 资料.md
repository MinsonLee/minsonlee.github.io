- [廖雪峰-Java 教程](https://www.liaoxuefeng.com/wiki/1252599548343744)
- [IDEA新手使用教程（详解）](https://juejin.cn/post/6844904020780253191)
- [Spring Boot 2.x基础教程](https://blog.didispace.com/spring-boot-learning-2x/)
- [Gradle 教程](https://www.w3cschool.cn/gradle/)
- [构建工具的进化：ant, maven, gradle](https://zhuanlan.zhihu.com/p/24429133)
- [springboot最新稳定版本、springcloud对应版本的选择](https://blog.csdn.net/Trouvailless/article/details/123880774)


- [阿里云课堂-Java技术图谱](https://developer.aliyun.com/graph/java)
- [阿里云课堂-Java编程](https://developer.aliyun.com/graph/java/point/41)
- [阿里云课堂-JVM实战](https://developer.aliyun.com/graph/java/point/64)
- [阿里云课堂-「大师课」搞定 Java 开发基础](https://developer.aliyun.com/learning/course/1256)
- [微服务+全栈在线教育实战项目演练（SpringCloud Alibaba+SpringBoot）](https://developer.aliyun.com/learning/course/667)


- [阿里巴巴 Java 编程规范](https://github.com/alibaba/p3c)
- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [Google Java 编程风格指南](https://hawstein.com/2014/01/20/google-java-style/)
- [Java Spring 项目开发最佳实践](https://github.com/lcomplete/TechShare/blob/master/docs/java/spring_best_practice.md)


- [进击的Java新人](https://zhuanlan.zhihu.com/p/24393775)
- [Java 充电社](http://www.itsoku.com/)
- [路人原创精华文章汇总](https://mp.weixin.qq.com/s/JIB5BAzMEiE7FljfBARarg)


- [ ] [SpringBoot 究竟是如何跑起来的?](https://zhuanlan.zhihu.com/p/54146400)
- [ ] [Netty 异步高性能通信框架](https://juejin.cn/post/6993602106355613709)
- [ ] [超详细Netty入门，看这篇就够了！](https://developer.aliyun.com/article/769587)
- [ ] [一篇文章让你彻底了解什么叫Netty](https://mp.weixin.qq.com/s/ad4ulymAxBGRbxjyOB6k3Q) 




- 异步、事件驱动、协程、并发、多线程
- [为什么 Java 坚持多线程不选择协程？](https://www.zhihu.com/question/332042250)
- [多线程学习怎样入门？](https://www.zhihu.com/question/19884663)
- [线程安全](https://baike.baidu.com/item/%E7%BA%BF%E7%A8%8B%E5%AE%89%E5%85%A8/9747724)
- [什么是线程安全，你真的了解吗？](https://zhuanlan.zhihu.com/p/42719755)
- [什么是线程安全？](https://www.cnblogs.com/lixinjie/p/a-answer-about-thread-safety-in-a-interview.html)
- 使用多进程、多线程、协程各自有什么优点？如何选择？
    - CPU 密集型：多进程
    - IO 密集型：多线程
    - CPU/IO 密集型：协程
- [https://cloud.tencent.com/developer/article/1416283](https://cloud.tencent.com/developer/article/1416283)
- [Swoole 从入门到实战教程](https://laravelacademy.org/books/swoole-tutorial)
- VO，BO，PO，DO，DTO的区别：[https://blog.csdn.net/weixin_45335305/article/details/126121307](https://blog.csdn.net/weixin_45335305/article/details/126121307)

## 调试技巧

1. 通过 `javap` 查看源码编译器编译后的代码。[javap 工具](https://www.geeksforgeeks.org/javap-tool-in-java-with-examples/)

## 问题

1、什么是 `@jdk.internal.ValueBased`

Java 通过 `@jdk.internal.ValueBased` 注解为属于 `Value-based` 的源码类进行

- [什么是 `Value-based Classes`](https://matthung0807.blogspot.com/2019/05/java-value-based-classes.html)
- [Value-based Classes](https://docs.oracle.com/javase/8/docs/api/java/lang/doc-files/ValueBased.html)
- [Java 8 新特性:6-Optional类](https://www.cnblogs.com/LeeScofiled/p/7673667.html)


2、Java 中的自动装箱和拆箱：基本类型<-->类包装器对象的相互转换，那么为什么要弄一个“包装器”来呢？

基本数据类型：`int-->Integer`、`byte-->Byte`、`short-->Short`、`long-->Long`、`float-->Float`、`double-->Double`、`char-->Character`、`boolean-->Boolean`

- [深入剖析Java中的装箱和拆箱](https://www.cnblogs.com/dolphin0520/p/3780005.html)
    - 自动装箱： 基本类型 --> 包装器对象（调用包装器的 ValueOf() 方法，将基本类型装维对象）
    - 自动拆箱： 包装器对象 --> 基础类型（调用包装器的 xxxValue() 方法，将对象转为基本类型）

基本数据类型

3、Java 中的 lambda 表达式：即匿名函数，为了简化代码，方便多处调用，使得Java可以实现其他支持函数式编程的语言特效。难道只是为了支持函数式编程吗？？？

在 Lambda 表达式出来之前，Java 要实现类似“函数式编程”的方法只能通过匿名内部类的方式来解决，而这大大的增加了代码的冗余程度。

- [Java8为什么要引入Lambda表达式吗？](https://binghe001.github.io/md/core/java/java8/2022-03-31-002-%E4%BD%A0%E7%9F%A5%E9%81%93Java8%E4%B8%BA%E4%BB%80%E4%B9%88%E5%BC%95%E5%85%A5Lambda%E8%A1%A8%E8%BE%BE%E5%BC%8F%E5%90%97.html)
- [Java 8 Stream API](https://www.runoob.com/java/java8-streams.html) 类似 PHP Laravel 框架中的 collection 对象，提供了一些封装好的方法，支持管道操作`stream of elements --> filter --> sorted --> map --> collect`

Stream API + Lambda 表达式真香！

4、Java 日志框架

- [x] [Java 日志框架解析：汇总及最佳实践](https://developer.aliyun.com/article/768396) ==> 简单来说：SLF4J + Logback 已经是目前Java日志的主流
- [x] [Java日志框架那些事儿](https://www.cnblogs.com/chanshuyi/p/something_about_java_log_framework.html) ==> 简单来说：SLF4J + Logback 已经是目前Java日志的主流
- [x] [Java日志框架、日志门面与日志实现](https://javamana.com/2022/01/202201110706311258.html) ==> 增加一个门面抽象层（SLF4J 或 JCL），使得客户端可以和各个日志类进行解耦
- [x] [Logback日志框架（一）：基础与周边配置](https://ffish.net/archives/logback1)
- [x] [Logback日志框架（二）：日志的级别与输出](https://ffish.net/archives/logback2)
- [x] [正确的打日志姿势](http://lrwinx.github.io/2018/01/25/%E6%AD%A3%E7%A1%AE%E7%9A%84%E6%89%93%E6%97%A5%E5%BF%97%E5%A7%BF%E5%8A%BF/)
- [x] [Logback Pattern 日志格式配置](https://www.cnblogs.com/chrischennx/p/6781574.html)
- [x] [[logback-user] How to use UTF-8?](http://mailman.qos.ch/pipermail/logback-user/2011-May/002326.html)
- [x] [logback 和 SLF4J（The Simple Logging Facade for Java） 中常用的类介绍](https://blog.csdn.net/cw_hello1/article/details/51969554)
- [x] [Logbak 帮助手册](https://logback.qos.ch/manual/index.html)

格式 | 备注
-----|----
%m | 代码中指定的 log 消息
%p | 日志优先级，如：DEBUG、INFO、WARM、ERROR、FATAL
%r | 自应用启动到输出该 log 信息耗费的**毫秒数**
%c | 所属的类目，通常即：所在类的全名
%t | 输出产生该日志的线程名
%n | 回车换行符
%d | 当前时间点的日期或时间，默认格式是 ISO8601（2022-07-01T17:30:08+08:00），也可以指定格式，</br>如： %d{yyyy MM dd HH:mm:ss,SSS} [Java 中 YYYY 跨年时的致命问题](https://blog.csdn.net/weixin_42619772/article/details/111053743)
%l | 日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数。举例：Testlog4.main(TestLog4.java:10)

- appender 日志附加器： `<appender name="XXX" class="ch.qos.logback.core.ConsoleAppender">` 
    - `name="xxx"` 用于 `<appender-ref ref="xxx">` 锚定日志配置
    - `ch.qos.logback.core.ConsoleAppender`：输出到控制台
    - `ch.qos.logback.core.FileAppender`：输出到文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- debug="true" 开启logbak内部状态，便于诊断日志系统的内部问题； -->
<!-- scan="true" scanPeriod="30 seconds" 每30秒自动扫描一次配置文件，如果文件有更新则使用新配置文件，若XML语法错误则回滚上一个无错版本配置 -->
<configuration debug="true" scan="true" scanPeriod="30 seconds">
    <!-- 关闭-->
    <!--<shutdownHook />-->
    <!-- 通过 property 标签定义变量，name="变量名" value="变量值" -->
    <property name="LOG_PATH" value="${LOG_PATH:-/data/logs/${APP_ID}}"/>
    <!-- 引入文件 common-default.xml，该文件需要是用 `<included></included>` 标签包裹的 XML 文件  -->
    <include resource="common-default.xml" />
    
    <!--通过 appender 设置日志附加器，自定义日志类型及格式等信息 -->
    <appender name="FILE" class="ch.qos.logback.core.FileAppender">
        <!-- 定义日志文件路径 -->
        <file>${LOG_PATH}/simple.log</file>
        <!-- 定义格式，通过 PatternLayoutEncoder 扩展类来定义（默认），LayoutWrappingEncoder 不怎么使用 -->
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <!-- 使用 UTF-8 编码 -->
            <charset>UTF-8</charset>
            <!-- 定义日志格式 -->
            <pattern>%date %-5level [%thread] %logger{10} [%file:%line] %msg%n</pattern>
            <!-- outputPatternAsHeader 是否在日志文件的开头打印 pattern 格式信息 -->
            <outputPatternAsHeader>true</outputPatternAsHeader>
        </encoder>
    </appender>
    
    <!-- net.ffish.demo.packageA 层级产生的所有日志只输出到文件，additivity="false" -->
    <!-- 若 additivity="true" 则会导致，net.ffish.demo.packageA 层级的目录即输出到文件又输出到控制台 -->
    <logger name="net.ffish.demo.packageA" level="ALL" additivity="false">
        <appender-ref ref="FILE" />
    </logger>
    
    <!-- 定义控制台日志格式信息 -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%date %-5level [%thread] %logger{10} [%file:%line] %msg%n</pattern>
        </encoder>
    </appender>
    
    <!-- root 为根目录层级，其下所有日志通过 CONSOLE 的格式进行打印-->
    <root level="ALL">
        <appender-ref ref="CONSOLE" />
    </root>
</configuration>
```

5、泛型

Java 5之前代码想要放开对类型的限制（泛型设计），是通过维护一个 Object 引用来实现的（利用OOP的多态特性：子类实例化父类，而 Object 是 Java 所有类对象的父类-类似PHP中的 stdClass 类），这样的设计致使在编译阶段是无法进行“类型检查”的，用户可以传递任何对象进来，从而产生安全隐患。

因此后来 Java5 引入泛型（“类型参数化”）的特性，使得代码在编译阶段可以进行：类型检查，编译完成之后再进行类型擦除，从而使得代码的安全系数得以提高。

- 什么是泛型？

不预先指定具体的类型，而在使用时再指定一种特性。==>泛型并不是为了让一个类或方法可以接收任意数据类型并进行任意类型的数据特性操作（不安全的），而是为了让类或参数“支持接收多种类型”，在使用时指定类型让使用者知道自己的操作是可行的（保留一定的主动权在用户手中）。

- 泛型如果实现？

即：参数化类型。Java中我们在调用一个方法时，需要指定参数的具体类型，而泛型则是支持我们在使用的时候动态的传递并指定形参的具体类型，而不是一开始就强制定义下来。

- 为什么说“泛型只在编译阶段有效”？

1、泛型类型在逻辑上可以看作是多个不同的类型，在编译时编译器会进行类型判断，如果类型不正确会编译报错

2、但通过 genericObj1.getClass()== genericObj2.getClass() 会返回 true，这说明：在编译过程中会进行“类型擦除”操作，即程序在运行时其类型是相同的

- [Java 泛型详解](https://blog.csdn.net/s10461/article/details/53941091)
- [Java泛型类型擦除以及类型擦除带来的问题](https://www.cnblogs.com/wuqinglong/p/9456193.html)
- [PHP 中的泛型：基础](https://learnku.com/php/t/66478)
- [PHP中的泛型：深入](https://learnku.com/php/t/66484)
- [为什么不能在PHP中使用泛型](https://learnku.com/php/t/66486)
- [php需要泛型吗](http://www.9ong.com/042021/php%E9%9C%80%E8%A6%81%E6%B3%9B%E5%9E%8B%E5%90%97.html)