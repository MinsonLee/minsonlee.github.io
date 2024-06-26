# 001-如何学习《设计模式之美》专栏

[TOC]

1. KISS 原则：Keep It Simple and Stupid。

2. 编程，本质就是：人和计算机沟通的工作，各类编程范式、各类设计模式都是为了写出：可维护性高、可重用性高的代码。

3. 大多数设计模式、编码规范、重构等类型的书籍都偏重理论，举例简单但不切合工作，不能实际落地。

4. 看源码到底是看什么？看作者写代码的设计模式、看作者代码的设计思想，大部分情况下并非为了让你拿着源码去做什么改动优化。

5. 设计模式：前人的编程思想(经验)的总结，使用设计模式就是对“前人软件设计思想的重用”

6. 设计模式：**在某些场景下，代码的命名、封装、组装、设计思路的最佳实践**，因此要注意，如果设计模式的设计思路和使用场景没对，那么可能事倍功半

7. 设计模式不可以用来直接编程，但是熟练的掌握设计模式能够让你写出**可重用性高、灵活**的高质量代码。

8. ==实际上，大部分设计原则、设计思想、设计模式理解起来都不难，难的是如何将这些理论灵活恰当地应用到实际的开发中，而不是教条主义和盲目滥用。==

9. 学习设计模式的 `3W1H`

   - what：某一种设计模式原则、思想、模式 是什么？
   - why：为什么要有这种设计原则、思想、模式？
   - when：它能解决什么问题？有哪些应用场景？该如何权衡、恰当地在项目中应用？
   - How：怎么用，有哪些实现方式？写的时候该注意什么？

10. 如何学习[《设计模式之美》](https://time.geekbang.org/column/intro/100039001)专栏？

    - 建立完善的知识体系：面想对象、设计原则、设计思想、编码规范、重构技巧、设计模式，先建立完整的知识框架，再慢慢深入逐个攻破
    - 建立代码质量意识：即，建立正确的技术认知和技术观，刻意练习（扩展性、可读性、可维护性、可测试性）
    - 主动学习而非被动学习：主动学习、主动思考、主动查资料、沟通交流、**主动总结**
    - 多读几遍专栏内容：知识体系是一个不断打磨、熬出来的，做个长一点的学习计划，多学习一些基础性底层的东西
    - 学会把代码写到极致：写100段烂代码的收获不如打磨出一段好代码


## 学习目标

- 专栏共113讲：每天精心的研读1讲需要3-4个月，介于部分文章比可能较简单
- 计划用时：90-100天
- 立flag时间：`2022-09-21 01:19`
- 完成时间：`2022-12-20` ☞ `2022-12-30` 期间

## 专栏目录
- [x] 开篇词 (1讲)
    - [x] `2022-09-21` 开篇词 | 一对一的设计与编码集训，让你告别没有成长的烂代码！ (Time@13:13)
------------------

- [x] 设计模式学习导读 (3讲)
    - [x] `2022-09-24` 01 | 为什么说每个程序员都要尽早地学习并掌握设计模式相关知识？ (Time@13:20)
    - [x] `2022-09-25` 02 | 从哪些维度评判代码质量的好坏？如何具备写出高质量代码的能力？ (Time@18:31)
    - [x] `2022-09-25` 03 | 面向对象、设计原则、设计模式、编程规范、重构，这五者有何关系？ (Time@11:12)
------------------

- [ ] 设计原则与思想：面向对象 (11讲)
    - [ ] `2022-Month-Day` 04 | 理论一：当谈论面向对象的时候，我们到底在谈论什么？ (Time@14:39)
    - [ ] `2022-Month-Day` 05 | 理论二：封装、抽象、继承、多态分别可以解决哪些编程问题？ (Time@21:42)
    - [ ] `2022-Month-Day` 06 | 理论三：面向对象相比面向过程有哪些优势？面向过程真的过时了吗？ (Time@17:55)
    - [ ] `2022-Month-Day` 07 | 理论四：哪些代码设计看似是面向对象，实际是面向过程的？ (Time@22:46)
    - [ ] `2022-Month-Day` 08 | 理论五：接口vs抽象类的区别？如何用普通的类模拟抽象类和接口？ (Time@15:09)
    - [ ] `2022-Month-Day` 09 | 理论六：为什么基于接口而非实现编程？有必要为每个类都定义接口吗？ (Time@12:30)
    - [ ] `2022-Month-Day` 10 | 理论七：为何说要多用组合少用继承？如何决定该用组合还是继承？ (Time@10:52)
    - [ ] `2022-Month-Day` 11 | 实战一（上）：业务开发常用的基于贫血模型的MVC架构违背OOP吗？ (Time@15:53)
    - [ ] `2022-Month-Day` 12 | 实战一（下）：如何利用基于充血模型的DDD开发一个虚拟钱包系统？ (Time@14:15)
    - [ ] `2022-Month-Day` 13 | 实战二（上）：如何对接口鉴权这样一个功能开发做面向对象分析？ (Time@14:07)
    - [ ] `2022-Month-Day` 14 | 实战二（下）：如何利用面向对象设计和编程开发接口鉴权功能？ (Time@17:02)
------------------

- [ ] 设计原则与思想：设计原则 (12讲)
    - [ ] `2022-Month-Day` 15 | 理论一：对于单一职责原则，如何判定某个类的职责是否够“单一”？ (Time@13:50)
    - [ ] `2022-Month-Day` 16 | 理论二：如何做到“对扩展开放、修改关闭”？扩展和修改各指什么？ (Time@18:55)
    - [ ] `2022-Month-Day` 17 | 理论三：里式替换（LSP）跟多态有何区别？哪些代码违背了LSP？ (Time@09:46)
    - [ ] `2022-Month-Day` 18 | 理论四：接口隔离原则有哪三种应用？原则中的“接口”该如何理解？ (Time@13:57)
    - [ ] `2022-Month-Day` 19 | 理论五：控制反转、依赖反转、依赖注入，这三者有何区别和联系？ (Time@10:40)
    - [ ] `2022-Month-Day` 20 | 理论六：我为何说KISS、YAGNI原则看似简单，却经常被用错？ (Time@11:54)
    - [ ] `2022-Month-Day` 21 | 理论七：重复的代码就一定违背DRY吗？如何提高代码的复用性？ (Time@17:14)
    - [ ] `2022-Month-Day` 22 | 理论八：如何用迪米特法则（LOD）实现“高内聚、松耦合”？ (Time@15:33)
    - [ ] `2022-Month-Day` 23 | 实战一（上）：针对业务系统的开发，如何做需求分析和设计？ (Time@14:33)
    - [ ] `2022-Month-Day` 24 | 实战一（下）：如何实现一个遵从设计原则的积分兑换系统？ (Time@19:17)
    - [ ] `2022-Month-Day` 25 | 实战二（上）：针对非业务的通用框架开发，如何做需求分析和设计？ (Time@11:58)
    - [ ] `2022-Month-Day` 26 | 实战二（下）：如何实现一个支持各种统计规则的性能计数器？ (Time@13:30)
------------------

- [ ] 设计原则与思想：规范与重构 (11讲)
    - [ ] `2022-Month-Day` 27 | 理论一：什么情况下要重构？到底重构什么？又该如何重构？ (Time@12:51)
    - [ ] `2022-Month-Day` 28 | 理论二：为了保证重构不出错，有哪些非常能落地的技术手段？ (Time@19:24)
    - [ ] `2022-Month-Day` 29 | 理论三：什么是代码的可测试性？如何写出可测试性好的代码？ (Time@18:23)
    - [ ] `2022-Month-Day` 30 | 理论四：如何通过封装、抽象、模块化、中间层等解耦代码？ (Time@12:52)
    - [ ] `2022-Month-Day` 31 | 理论五：让你最快速地改善代码质量的20条编程规范（上） (Time@13:26)
    - [ ] `2022-Month-Day` 32 | 理论五：让你最快速地改善代码质量的20条编程规范（中） (Time@09:53)
    - [ ] `2022-Month-Day` 33 | 理论五：让你最快速地改善代码质量的20条编程规范（下） (Time@10:01)
    - [ ] `2022-Month-Day` 34 | 实战一（上）：通过一段ID生成器代码，学习如何发现代码质量问题 (Time@13:44)
    - [ ] `2022-Month-Day` 35 | 实战一（下）：手把手带你将ID生成器代码从“能用”重构为“好用” (Time@16:20)
    - [ ] `2022-Month-Day` 36 | 实战二（上）：程序出错该返回啥？NULL、异常、错误码、空对象？ (Time@15:45)
    - [ ] `2022-Month-Day` 37 | 实战二（下）：重构ID生成器项目中各函数的异常处理代码 (Time@10:50)
------------------

- [ ] 设计原则与思想：总结课 (3讲)
    - [ ] `2022-Month-Day` 38 | 总结回顾面向对象、设计原则、编程规范、重构技巧等知识点 (Time@34:07)
    - [ ] `2022-Month-Day` 39 | 运用学过的设计原则和思想完善之前讲的性能计数器项目（上） (Time@12:29)
    - [ ] `2022-Month-Day` 40 | 运用学过的设计原则和思想完善之前讲的性能计数器项目（下） (Time@15:17)
------------------

- [ ] 设计模式与范式：创建型 (7讲)
    - [ ] `2022-Month-Day` 41 | 单例模式（上）：为什么说支持懒加载的双重检测不比饿汉式更优？ (Time@14:16)
    - [ ] `2022-Month-Day` 42 | 单例模式（中）：我为什么不推荐使用单例模式？又有何替代方案？ (Time@11:44)
    - [ ] `2022-Month-Day` 43 | 单例模式（下）：如何设计实现一个集群环境下的分布式单例模式？ (Time@10:21)
    - [ ] `2022-Month-Day` 44 | 工厂模式（上）：我为什么说没事不要随便用工厂模式创建对象？ (Time@12:57)
    - [ ] `2022-Month-Day` 45 | 工厂模式（下）：如何设计实现一个Dependency Injection框架？ (Time@11:10)
    - [ ] `2022-Month-Day` 46 | 建造者模式：详解构造函数、set方法、建造者模式三种对象创建方式 (Time@10:32)
    - [ ] `2022-Month-Day` 47 | 原型模式：如何最快速地clone一个HashMap散列表？ (Time@12:09)
------------------

- [ ] 设计模式与范式：结构型 (8讲)
    - [ ] `2022-Month-Day` 48 | 代理模式：代理在RPC、缓存、监控等场景中的应用 (Time@10:41)
    - [ ] `2022-Month-Day` 49 | 桥接模式：如何实现支持不同类型和渠道的消息推送系统？ (Time@09:18)
    - [ ] `2022-Month-Day` 50 | 装饰器模式：通过剖析Java IO类库源码学习装饰器模式 (Time@08:18)
    - [ ] `2022-Month-Day` 51 | 适配器模式：代理、适配器、桥接、装饰，这四个模式有何区别？ (Time@13:04)
    - [ ] `2022-Month-Day` 52 | 门面模式：如何设计合理的接口粒度以兼顾接口的易用性和通用性？ (Time@09:10)
    - [ ] `2022-Month-Day` 53 | 组合模式：如何设计实现支持递归遍历的文件系统目录树结构？ (Time@06:30)
    - [ ] `2022-Month-Day` 54 | 享元模式（上）：如何利用享元模式优化文本编辑器的内存占用？ (Time@11:09)
    - [ ] `2022-Month-Day` 55 | 享元模式（下）：剖析享元模式在Java Integer、String中的应用 (Time@10:32)
------------------

- [ ] 设计模式与范式：行为型 (18讲)
    - [ ] `2022-Month-Day` 56 | 观察者模式（上）：详解各种应用场景下观察者模式的不同实现方式 (Time@11:43)
    - [ ] `2022-Month-Day` 57 | 观察者模式（下）：如何实现一个异步非阻塞的EventBus框架？ (Time@11:55)
    - [ ] `2022-Month-Day` 58 | 模板模式（上）：剖析模板模式在JDK、Servlet、JUnit等中的应用 (Time@08:41)
    - [ ] `2022-Month-Day` 59 | 模板模式（下）：模板模式与Callback回调函数有何区别和联系？ (Time@11:08)
    - [ ] `2022-Month-Day` 60 | 策略模式（上）：如何避免冗长的if-else/switch分支判断代码？ (Time@07:37)
    - [ ] `2022-Month-Day` 61 | 策略模式（下）：如何实现一个支持给不同大小文件排序的小程序？ (Time@09:00)
    - [ ] `2022-Month-Day` 62 | 职责链模式（上）：如何实现可灵活扩展算法的敏感信息过滤框架？ (Time@09:24)
    - [ ] `2022-Month-Day` 63 | 职责链模式（下）：框架中常用的过滤器、拦截器是如何实现的？ (Time@08:25)
    - [ ] `2022-Month-Day` 64 | 状态模式：游戏、工作流引擎中常用的状态机是如何实现的？ (Time@10:14)
    - [ ] `2022-Month-Day` 65 | 迭代器模式（上）：相比直接遍历集合数据，使用迭代器有哪些优势？ (Time@10:43)
    - [ ] `2022-Month-Day` 66 | 迭代器模式（中）：遍历集合的同时，为什么不能增删集合元素？ (Time@11:15)
    - [ ] `2022-Month-Day` 67 | 迭代器模式（下）：如何设计实现一个支持“快照”功能的iterator？ (Time@09:22)
    - [ ] `2022-Month-Day` 68 | 访问者模式（上）：手把手带你还原访问者模式诞生的思维过程 (Time@09:11)
    - [ ] `2022-Month-Day` 69 | 访问者模式（下）：为什么支持双分派的语言不需要访问者模式？ (Time@09:02)
    - [ ] `2022-Month-Day` 70 | 备忘录模式：对于大对象的备份和恢复，如何优化内存和时间的消耗？ (Time@08:32)
    - [ ] `2022-Month-Day` 71 | 命令模式：如何利用命令模式实现一个手游后端架构？ (Time@09:18)
    - [ ] `2022-Month-Day` 72 | 解释器模式：如何设计实现一个自定义接口告警规则功能？ (Time@10:01)
    - [ ] `2022-Month-Day` 73 | 中介模式：什么时候用中介模式？什么时候用观察者模式？ (Time@07:44)
------------------

- [ ] 设计模式与范式：总结课 (2讲)
    - [ ] `2022-Month-Day` 74 | 总结回顾23种经典设计模式的原理、背后的思想、应用场景等 (Time@31:03)
    - [ ] `2022-Month-Day` 75 | 在实际的项目开发中，如何避免过度设计？又如何避免设计不足？ (Time@13:06)
------------------

- [ ] 开源与项目实战：开源实战 (14讲)
    - [ ] `2022-Month-Day` 76 | 开源实战一（上）：通过剖析Java JDK源码学习灵活应用设计模式 (Time@10:58)
    - [ ] `2022-Month-Day` 77 | 开源实战一（下）：通过剖析Java JDK源码学习灵活应用设计模式 (Time@11:25)
    - [ ] `2022-Month-Day` 78 | 开源实战二（上）：从Unix开源开发学习应对大型复杂项目开发 (Time@12:02)
    - [ ] `2022-Month-Day` 79 | 开源实战二（中）：从Unix开源开发学习应对大型复杂项目开发 (Time@09:29)
    - [ ] `2022-Month-Day` 80 | 开源实战二（下）：从Unix开源开发学习应对大型复杂项目开发 (Time@13:39)
    - [ ] `2022-Month-Day` 81 | 开源实战三（上）：借Google Guava学习发现和开发通用功能模块 (Time@11:37)
    - [ ] `2022-Month-Day` 82 | 开源实战三（中）：剖析Google Guava中用到的几种设计模式 (Time@11:09)
    - [ ] `2022-Month-Day` 83 | 开源实战三（下）：借Google Guava学习三大编程范式中的函数式编程 (Time@13:11)
    - [ ] `2022-Month-Day` 84 | 开源实战四（上）：剖析Spring框架中蕴含的经典设计思想或原则 (Time@14:05)
    - [ ] `2022-Month-Day` 85 | 开源实战四（中）：剖析Spring框架中用来支持扩展的两种设计模式 (Time@10:45)
    - [ ] `2022-Month-Day` 86 | 开源实战四（下）：总结Spring框架用到的11种设计模式 (Time@12:52)
    - [ ] `2022-Month-Day` 87 | 开源实战五（上）：MyBatis如何权衡易用性、性能和灵活性？ (Time@09:18)
    - [ ] `2022-Month-Day` 88 | 开源实战五（中）：如何利用职责链与代理模式实现MyBatis Plugin？ (Time@10:58)
    - [ ] `2022-Month-Day` 89 | 开源实战五（下）：总结MyBatis框架中用到的10种设计模式 (Time@14:47)
------------------

- [ ] 开源与项目实战：项目实战 (9讲)
    - [ ] `2022-Month-Day` 90 | 项目实战一：设计实现一个支持各种算法的限流框架（分析） (Time@12:18)
    - [ ] `2022-Month-Day` 91 | 项目实战一：设计实现一个支持各种算法的限流框架（设计） (Time@12:14)
    - [ ] `2022-Month-Day` 92 | 项目实战一：设计实现一个支持各种算法的限流框架（实现） (Time@12:44)
    - [ ] `2022-Month-Day` 93 | 项目实战二：设计实现一个通用的接口幂等框架（分析） (Time@11:18)
    - [ ] `2022-Month-Day` 94 | 项目实战二：设计实现一个通用的接口幂等框架（设计） (Time@10:04)
    - [ ] `2022-Month-Day` 95 | 项目实战二：设计实现一个通用的接口幂等框架（实现） (Time@11:48)
    - [ ] `2022-Month-Day` 96 | 项目实战三：设计实现一个支持自定义规则的灰度发布组件（分析） (Time@10:32)
    - [ ] `2022-Month-Day` 97 | 项目实战三：设计实现一个支持自定义规则的灰度发布组件（设计） (Time@10:10)
    - [ ] `2022-Month-Day` 98 | 项目实战三：设计实现一个支持自定义规则的灰度发布组件（实现） (Time@08:43)
------------------

- [ ] 开源与项目实战：总结课 (2讲)
    - [ ] `2022-Month-Day` 99 | 总结回顾：在实际软件开发中常用的设计思想、原则和模式 (Time@10:53)
    - [ ] `2022-Month-Day` 100 | 如何将设计思想、原则、模式等理论知识应用到项目中？ (Time@08:52)
------------------

- [x] 不定期加餐 (11讲)
    - [x] `2022-Month-Day` 加餐一 | 用一篇文章带你了解专栏中用到的所有Java语法 (Time@03:17)
    - [x] `2022-Month-Day` 加餐二 | 设计模式、重构、编程规范等相关书籍推荐 (Time@07:36)
    - [x] `2022-09-21` 春节特别加餐 | 王争：如何学习《设计模式之美》专栏？ (Time@10:43)
    - [x] `2022-09-22` 加餐三 | 聊一聊Google是如何做Code Review的 (Time@09:36)
    - [x] `2022-09-22` 加餐四 | 聊一聊Google那些让我快速成长的地方 (Time@07:09)
    - [x] `2022-09-22` 加餐五 | 听一听小争哥对Google工程师文化的解读 (Time@07:11)
    - [x] `2022-09-22` 加餐六 | 什么才是所谓的编程能力？如何考察一个人的编程能力？ (Time@07:33)
    - [x] `2022-09-23` 加餐七 | 基础学科的知识如何转化成实际的技术生产力？ (Time@06:42)
    - [x] `2022-09-23` 加餐八 | 程序员怎么才能让自己走得更高、更远？ (Time@08:47)
    - [x] `2022-09-23` 加餐九 | 作为面试官或候选人，如何面试或回答设计模式问题？ (Time@06:56)
    - [x] `2022-09-23` 加餐十 | 如何接手一坨烂业务代码？如何在烂业务代码中成长？ (Time@06:37)
------------------

- [ ] 结束语 (1讲)
    - [ ] `2022-Month-Day`结束语 | 聊一聊机遇、方向、能力、努力！ (Time@07:58)



时光不语，静等花开。从默默无闻到崭露头角，一般只需一瞬间，看似一瞬间，可能要等十几年。年轻人一定不要心急，不要焦虑，要耐得住性子。当你的能力撑不起你的野心的时候，当你感到怀才不遇的时候，当你迷茫找不着方向的时候，你只需要努力、坚持，再努力、再坚持，慢慢地，你就会变得越来越强大，方向就会变得越来越清晰，机会就会越来越青睐你。