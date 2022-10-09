# 设计原则与思想：面向对象

[TOC]

## 当谈论面向对象的时候，我们到底在谈论什么？

- 面向对象分析（OOA）：搞清楚做什么？
- 面向对象设计（OOD）：搞清楚怎么做？
- 面向对象编程（OOP）：将分析和设计翻译为代码，让计算机按指令工作

## 什么是面向对象编程？面向对象编程的特性是什么？

- 面向对象编程：是一种编程范式，以“类”、“对象”为组织代码的最基本载体单元，运用封装、抽象、继承、多态的特性，对代码进行组织，从而提高代码的可复用性、扩展性
- 面向对象编程的特性：封装、抽象、继承、多态（也有说是三大特性：封装、继承、多态；也有文献说：类、继承、多态更准确一些）...知道各个特性解决的问题场景即可，不纠结到底有多少特性
- 面向编程的五大基本原则：单一职责原则（SRP）、开放封闭原则（OCP）、里氏替换原则（LSP）、依赖倒置原则（DIP）、接口隔离原则（ISP）

## 如何界定一门编程语言是“面向对象”编程语言？

- 严格来说：必须是以“类”、“对象”作为基本程序结构单位的程序设计语言，且语言支持：封装、继承、多态几个特性
- 粗略的讲：只要是能实现[面向对象的三大特性和五大原则](https://www.cnblogs.com/fzz9/p/8973315.html)，就可以算作面向对象 [Go 面试官问我如何实现面向对象？](https://mp.weixin.qq.com/s/2x4Sajv7HkAjWFPe4oD96g)

## 封装、继承、多态分别解决了编程中的哪些问题？

### 封装

也叫信息隐藏或数据访问保护（public/protected/private），类通过暴露**有限的**访问接口，授权外部仅能通过类提供的方法来访问或修改对象内部的信息数据。**将不必要的信息隐藏保护起来，不给外部任意访问，从而提高类的易用性、数据的安全性；同时仅提供有限接口，对外屏蔽了内部实现的复杂性，从而降低了外部调用方对内部实现的依赖、增强了代码的可读性、可维护性**。

> 易用性：如果将数据修改的权限提供给调用方，那么就意味着调用方必须要对业务足够的熟悉，否则的话修改就可能会导致有问题，而“封装”不仅仅是对数据提供了隐蔽，更是对调用方隐蔽复杂的业务

### 抽象

**封装主要讲如何隐藏信息、保护数据，而抽象讲的是如何隐藏方法的具体实现**，让调用者只需要关心方法提供了哪些可调用的方法，并不需要知道这些功能是如何实现的。在编程中，我们==**大多借助接口类、抽象类来实现“抽象”这一特性**==，但不是只有接口类、抽象类才能实现抽象这一特性，本身将代码放到方法、函数中进行隔离就是一种抽象特性的体现。

### 继承

用于表示类之间的**“Is-a”**关系。继承可以分为：单继承-Java/PHP/C#..；多继承-C++/Python/Perl 两种模式。

- 多继承：一个类可以有多个父类，如：猫既属于哺乳动物又属于爬行动物。但是==代码支持多继承容易造成类关系组织混乱、多父类之间的方法和属性命名相同导致的混乱、以及多继承所带来的著名的菱形问题（B/C继承A覆写了a方法，D多继承B/C没有实现a方法，那么D继承的a应该是B的还是C的呢？）...从而导致业务关系混乱，因此从“易学易用”的角度，很多编程语言放弃了“多继承”这种模式==。
- 单继承：一个类只允许继承一个父类，Only Is-a。解决了多继承所带来的的复杂问题，而多继承所需要的特性也可以借助“接口”来组合实现

- **继承最大的好处之一：代码复用，但继承的层级过深就会导致代码的可读性、可维护性变差**。

### 多态

通俗的来说就是在运行过程中，程序会根据传入的不同子类的方法签名，优先使用子类的方法。**多态特性能提高代码的“可扩展性”**

- 向上转型（up casting）：“子类实例化父类对象” ，不需要强转类型，但“向上转型”会丢失掉子类特有的方法

- “父类引用指向子类对象，但子类引用不能指向父类对象”，如果一定要这样做，那么就需要强制转换类型，转换出来的类型可能会产生调用错误

实现多态的方式和条件：

1. 面向对象：继承、重写、父类引用指向子类对象

```伪代码
类A
	方法a1
类B extends A
	方法a2
类C extends A
	方法a3

ObjExtendsA.a1() // ObjExtendsA 既可以代表类B，也可以代表类C，只要是 A 类的子类即可（is-a）
```

2. 利用接口语法，例如 [Golang | Go语言多态的实现与interface使用 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/165621566)

```伪代码
interface A:
	方法a1
类B implements A
	方法a1
类C implements A
	方法a1
ObjImplementsInterfaceA.方法a1() // ObjImplementsInterfaceA 既可以代表类B，也可以代表类 C，只要实现了A接口即可（has-a）
```

3. 动态语言利用 duck-typing 语法，例如：Python、JavaScript、PHP 的 trait语法组合使用，只要有调用的方法/属性即可，便不会报错

```伪代码
类A:
	方法c
类B:
	方法c
调用对象.c() // 只要调用对象存在方法c即可，调用对象之间可能完全没有任何关系
```

## 面向对象编程与面向过程编程(POP)的区别和联系？

1. 什么是面向过程编程与面向过程编程语言？

   面向过程编程（POP-Procedure Oriented Programming）是一种“以过程为中心”的编程思想。即：

   - 面向过程的方法/函数 和 数据(变量、属性) 的定义是相互独立开来的；而面向对象中类是对象属性和方法的集合体
   - 通过 方法 对 数据 进行流程操作，**通过拼接一组顺序执行的方法来操作数据，从而完成整个事件**。

2. 面向对象编程相比面向过程编程有哪些优势？

   从两者定义可以看出区别：==**面向过程注重“怎么做”，而面向对象注重“谁来做”**==，至于面向对象中的“谁”来怎么做的，由类/对象内部自行抽象/封装完成，只需对外提供一个可访问的方法告诉结果即可，中间涉及的流程对于面向对象来说是全然不关心的。

3. 为什么说面向对象编程语言比面向过程语言更高级？
   - **面向对象更加适合需要“分工合作”的复杂场景，而面向过程则更加适合“单兵作战，细化流程”的场景**
   - 在复杂的业务场景中，面向对象编程中的类、对象风格的代码更易复用、易扩展、易维护。

4. 在面向对象编程中，为什么容易写出面向过程风格的代码？

   面向对象是“面向人的思维方式”去思考、建模、设计、编写代码，但是最终落到计算机执行的时候，依然是要明确告诉计算机：具体怎么做！因此，在写一些单一流水线业务代码时，编程人员的抽象思维不足就容易写出这种“面向过程风格”的代码。

5. 面向过程编程和面向过程编程语言就真的无用武之地了吗？

   **对于所有编程语言最终目的是两种：提高硬件的运行效率和提高程序员的开发效率；所有的编程模式最终的目的都是：提高代码的复用性、可维护性、易扩展性。**面向过程编程更加倾向于“面向计算机”的思维进行组合、编程，因此一般来说面向过程编程的语言在**执行效率**上会稍微高一些。面向对象编程更加倾向于“面向人类”的思维进行设计编程，因此一般来说面向对象的语言在**编程效率**上会更加高一些。

   面向过程适合于不是那么复杂的脚本式代码，注重相对单一事件的“过程”。

6. 面向对象编程比面向过程编程，更加容易应对大规模复杂程序的开发。

   但像 Unix、Linux 这些复杂的系统，也都是基于 C 语言这种面向过程的编程语言开发的，你怎么看待这个现象？

   > 推荐阅读：[漫画 | 因为用了C语言，Linux内核代码一团糟？](https://mp.weixin.qq.com/s/I1iIbdyMkTbgBnZi_sJlmA)

![为什么*Nix操作系统使用C语言？](/images/pig/20220930234937.png)

7. [哪些代码设计看似是面向对象，实际是面向过程的？](https://time.geekbang.org/column/article/164907)

   - **滥用 getter/setter**：面向对象封装的定义是“通过访问权限控制，隐藏内部数据，外部仅能通过类提供的有限的接口访问、修改内部数据”，任意暴露不应该对外暴露的“getter/setter”会违反面向对象的封装性，失去对数据的访问控制权限，容易让面向对象的代码退化成面向过程。==暴露不该暴露的接口给外部，会增加了类使用过程中被误用的概率==。

     > **在设计实现类的时候，除非真的需要，否则，尽量不要给属性定义 setter 方法。除此之外，尽管 getter 方法相对 setter 方法要安全些，但是如果返回的是集合容器（比如例子中的 List 容器），也要防范集合内部数据被修改的危险。**

   - **滥用全局变量和全局方法**：全局变量（单例对象、静态成员变量、常量等）和全局方法（静态方法）并非要杜绝使用，而是要“避免”滥用。即便在面向对象编程中，我们也并不是完全排斥面向过程风格的代码。只要它能为我们写出好的代码贡献力量，我们就可以适度地去使用。

   - 定义数据和方法分离的类：类本身就是“行为+属性”的聚合体，过程才是将“数据”、“行为”剥离开来进行定义，在需要时进行顺序组合。
   
     > 以前的 MVC 三层架构分别是 Model层、View层、Controller层。不过在做了前后端分离，后端的三层架构变为了：Controller层（暴露接口给外部调用）、Service层（核心业务逻辑）、Repository层（负责数据访问、读写），每一层我们都会定义相应的 VO（Value Object-值对象）、BO（Business Object-业务对象）、Entity（实体）。一般来说 VO、BO、Entity只会定义数据，不会定义方法，这种开发模式叫作基于**贫血模型**的开发模式，也是我们现在非常常用的一种 Web 项目的开发模式。
   
     [问题：为什么这种贫血开发模式会流行并在当前普及呢？](https://time.geekbang.org/column/article/164907)
   
     - 实现简单：Object仅仅作为传递数据的媒介，不用考虑过多的设计方面，将核心业务逻辑放到service层，用Hibernate之类的框架一套，完美解决任务。
     - 上手快：使用贫血模式开发的web项目，新来的程序员看看代码就能“照猫画虎”干活了，不需要多高的技术水平。所以很多程序员干了几年，仅仅就会写CURD。
     - 一些技术鼓励使用贫血模型。例如J2EE Entity Beans，Hibernate等。
   
     总结：各种模型的好坏讨论一直不断，企业需要的是使用合适的技术把任务完成，从这个角度来说当下管用模型就是好模型。当然我们也要持开放的心态接受新的技术和思想，并结合业务的实际需要选择合适的技术。
   
     贫血模型（Anemic Domain Model由 MatinFowler提出）又称为失血模型，是指domain object仅有属性的getter/setter方法的纯数据类，将所有类的行为放到service层。原文他是这么说的“By pulling all the behavior out into services, however, you essentially end up with Transaction Scripts, and thus lose the advantages that the domain model can bring. ”他的原文我放上来了，英文好的同学可以看看：https://martinfowler.com/bliki/AnemicDomainModel.html 。 我觉得他有点学者气太重，这篇博客他都不知道为啥贫血模型会流行（I don't know why this anti-pattern is so common）。
   
     ![VO，BO，PO，DO，DTO的区别](https://img-blog.csdnimg.cn/img_convert/5636d191ba204f39f04a63fdea861837.png)
   
   - [漫画 | 为什么面向对象糟透了！](https://mp.weixin.qq.com/s/ohDpo3oIiok7GtmvjVf1Ng)
   
   - [漫画 | C语言哭了，过年回家，只有我还没对象](https://mp.weixin.qq.com/s/2G-ij_VBcLytBH_Unu_wSQ)

## 面向对象编程与面向切面编程(AOP)的联系？

1. 什么是面向切面编程？

   而面向过程编程是通过“过程（即：通过方法组合数据的流程）”做为构建代码的基石；面向对象编程是通过“类”、“对象”作为构建代码的基石，面向对象更加适合从“更为人性化”角度来定义“复杂的”场景。而不管是“面向对象”还是“面向过程”，其实都是描述业务的“纵向”关系，但一些**“没有从属继承关系”、“非必要”**的行为操作场景（即：横向关系），不管是面向过程或面向对象（尤其是“面向对象”）其实都是不好定义关系出来的。

   基于此，我们更加希望能将这种“非必要、公共行为”抽象出来，封装成一个可重复使用的模块，在需要用到的时候引入即可（即：**可插拔的使用场景**）。这种模块与业务流程往往没有什么关系，属于是系统的一个“横切面”关注点。

   面向切片编程（AOP-Aspect-Oriented Programming）就是这样一种新的编程思想，它是对面向对象编程的一种补充和完善。

   > 之前听人说 PHP 中的 trait 是面向切面编程的体现，觉得这是不合理的。因为 trait 是将行为抽离出来，然后镶嵌在类中作为其一部分，这是不符合面向切面编程思想的。

   [什么是面向切面编程? - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/421999882)

## 接口和抽象类的区别以及各自的应用场景？（抽象类-代码复用；接口-解耦）

接口和抽象类的使用在：面向对象四大特性、设计模式、设计思想、设计原则中是非常广泛的。如：利用抽象类实现面向对象的继承/多态/抽象特性、模板设计模式、基于接口而非实现的设计原则...。

- 接口和抽象类的区别是什么？
- 什么时候用接口？
- 什么时候用抽象类？
- 抽象类和接口存在的意义是什么？能解决哪些编程问题？

**抽象类是对在 is-a “纵向”纬度上对类从属类的抽象（包括：数据抽象+行为抽象，因此抽象类其实也是一种特殊的“类”），接口是对 has-a “横向”纬度的行为抽象（因此：==接口的另一个更加形象的叫法是“协议”==）**。**抽象其实就是对事物共性关系的剥离，“关系”其实也意味着“约束”**。当我们需要定义的关系（约束）是纵向时，就使用抽象类，需要定义的关系（约束）仅是横向的，就使用“接口”。

**==抽象类更多的是为了代码的可复用性；接口更多的是为了解耦，其将关系和实现相分离从而降低了代码的耦合性，增加了代码的可扩展性。==**

```java

// 抽象类
public abstract class Logger {
  private String name;
  private boolean enabled;
  private Level minPermittedLevel;

  public Logger(String name, boolean enabled, Level minPermittedLevel) {
    this.name = name;
    this.enabled = enabled;
    this.minPermittedLevel = minPermittedLevel;
  }
  
  public void log(Level level, String message) {
    boolean loggable = enabled && (minPermittedLevel.intValue() <= level.intValue());
    if (!loggable) return;
    doLog(level, message);
  }
  
  protected abstract void doLog(Level level, String message);
}
// 抽象类的子类：输出日志到文件
public class FileLogger extends Logger {
  private Writer fileWriter;

  public FileLogger(String name, boolean enabled,
    Level minPermittedLevel, String filepath) {
    super(name, enabled, minPermittedLevel);
    this.fileWriter = new FileWriter(filepath); 
  }
  
  @Override
  public void doLog(Level level, String mesage) {
    // 格式化level和message,输出到日志文件
    fileWriter.write(...);
  }
}
// 抽象类的子类: 输出日志到消息中间件(比如kafka)
public class MessageQueueLogger extends Logger {
  private MessageQueueClient msgQueueClient;
  
  public MessageQueueLogger(String name, boolean enabled,
    Level minPermittedLevel, MessageQueueClient msgQueueClient) {
    super(name, enabled, minPermittedLevel);
    this.msgQueueClient = msgQueueClient;
  }
  
  @Override
  protected void doLog(Level level, String mesage) {
    // 格式化level和message,输出到消息中间件
    msgQueueClient.send(...);
  }
}
```
**抽象类：是一种不能被实例化的特殊的类，但可以被继承；能包含属性、实体方法、抽象方法(无具体实现的方法)；子类继承抽象类必须要实现所有抽象方法**。


```java

// 接口
public interface Filter {
  void doFilter(RpcRequest req) throws RpcException;
}
// 接口实现类：鉴权过滤器
public class AuthencationFilter implements Filter {
  @Override
  public void doFilter(RpcRequest req) throws RpcException {
    //...鉴权逻辑..
  }
}
// 接口实现类：限流过滤器
public class RateLimitFilter implements Filter {
  @Override
  public void doFilter(RpcRequest req) throws RpcException {
    //...限流逻辑...
  }
}
// 过滤器使用Demo
public class Application {
  // filters.add(new AuthencationFilter());
  // filters.add(new RateLimitFilter());
  private List<Filter> filters = new ArrayList<>();
  
  public void handleRpcRequest(RpcRequest req) {
    try {
      for (Filter filter : filters) {
        filter.doFilter(req);
      }
    } catch(RpcException e) {
      // ...处理过滤结果...
    }
    // ...省略其他处理逻辑...
  }
}
```

**接口类：不能被实例化，只能被实现；接口中只能包含抽象方法，不能包含任何实体方法或实体属性；类实现接口时必须实现全部的接口类**。

## 基于接口而非实现编程的设计思想？

“基于接口而非实现编程-Program to an interface, not an implementation” 的设计原则，最早 1994 年在 GOF 的设计模式一书中被提到，实际这一原则的另一个表述可以说为：**”基于抽象而非实现编程“**，这样可能会更方便理解一些。

- ==“基于接口而非实现编程” 中的 **“接口”**指的是什么？==**接口就是一组“协议(或约定)”，是一组”功能提供列表“的集合，并非单指编程中的”接口类“，一般我们可以通过抽象类/接口类来实现”接口“的概念**。

- ==为什么会有"基于接口而非实现编程"这一设计原则？==在软件开发中，最大的挑战之一就是”需求不断变化“（这也是考验代码设计好坏的一个标准）。**越抽象、越顶层、越脱离具体某一实现的设计，越能提高代码的灵活性，越能应对未来的需求变化。好的代码设计，不仅能应对当下的需求，而且在将来需求发生变化的时候，仍然能够在不破坏原有代码设计的情况下灵活应对**。而抽象就是提高代码扩展性、灵活性、可维护性最有效的手段之一。

- 在编码过程中，如何践行“基于接口而非实现编程”这一设计原则？

  - **对外暴露的函数/变量，在命名上不能暴露任何实现细节**
  - **封装（即：屏蔽）具体的实现细节**：对外只提供一个可调用的方法，调用者对实现细节不可见也不应需要关心具体的实现细节
  - **为实现类定义抽象的接口**：具体的实现类都依赖统一的接口定义，使用者依赖接口，而不是依赖具体的实现类来进行编程。**接口的定义只表明做什么，而不是怎么做。**

- 是否需要为每个类都定义接口？

  “基于接口而非实现编程”设计原则的目的是为了：**降低耦合，提高可扩展性**。为了这一目的，我们的实现手段是：**封装不稳定的实现，暴露稳定的接口**。即：将接口与具体实现进行相分离，使得上游调用系统不依赖不稳定的实现细节，当实现发生变化时，上游代码不需改动。

  如果我们的某个功能业务场景只有一种实现方式，未来也不可能被其他实现方式替换，那我们就没必要为其设计接口，也没必要基于接口编程，直接使用实现类就可以了。

  **越是不稳定的系统，我们越是要在代码的扩展性、维护性上下功夫**。



## 为什么说**多用组合少用继承**的设计思想？如何决定该用组合还是继承？

- 为什么不推荐使用继承？（继承的优缺点）

  ①. “继承”在编程中，是面向对象编程中解决“代码可复用性”最常用、最有效手段之一。

  ②. 继承这种 “is-a” 的特性，随着继承深度过深、过复杂(多继承)，会使得代码的“可维护性、可读性”变得越来越差。

  ③. 继承 “is-a” 是纵向关系，但对于一些横向("has-a")关系，如果使用继承反而会暴露不该暴露的接口给外部，增加了类使用过程中被误用的概率。

  譬如：鸟类-不是所有的鸟类都有 fly 能力，那么如果继承解决就需要分裂出“会fly的鸟类”、“不会fly的鸟类”，随着这种差异性越多需要分裂出来的类就需要越多；如果不使用继承那么代码上又需要舍弃复用性...

- 组合相比继承有哪些优势？（组合的优缺点）

  如何能有效的解决“继承”所带来的痛点呢？我们一般采用：**组合+接口+委托** 三个技术手段来处理。

  - 接口定义行为约束，但是解决不了代码复用问题...

  - 定义不同的行为类，抽象行为类的代码，解决代码复用性，然后通过：组合+委托 的方式解决复用性的问题

    - 组合：将行为拆分为多个实现类，然后在业务类中自定义包含所需要的接口实现类
    - 委托：业务类实现对应的接口，在业务类实现接口方法时调用接口实现类中已经封装好的接口方法（即：将接口实现委托给接口实现类来完成）

    > 在 Java 1.8 之后的版本，接口类支持在定义接口方法时可以有对应的 default 方法体，所以在 Java 1.8 后的 Java 开发中，“接口+组合+委托” 其实只需要“接口+组合”即可。

  ```java
  public interface Flyable { // 接口
    void fly();
  }
  public class FlyAbility implements Flyable {
    @Override
    public void fly() { //... }
  }
  //省略Tweetable/TweetAbility/EggLayable/EggLayAbility
  
  public class Ostrich implements Tweetable, EggLayable {//鸵鸟
    private TweetAbility tweetAbility = new TweetAbility(); //组合
    private EggLayAbility eggLayAbility = new EggLayAbility(); //组合
    //... 省略其他属性和方法...
    @Override
    public void tweet() {
      tweetAbility.tweet(); // 委托
    }
    @Override
    public void layEgg() {
      eggLayAbility.layEgg(); // 委托
    }
  }
  ```

- 如何判断该使用组合还是继承？

  ==使用“组合”的方式就意味着要做“更细粒度的拆分”，意味着我们需要定义更多的类、接口出来，这无疑又会在一定程度牺牲代码的“可维护性”==。因此在实际开发中，我们需要根据业务需求本身的复杂程度来衡量“可维护性”到底是应该用“继承”还是“组合”？

  **如果类之间的继承结构稳定（不会轻易改变），继承层次比较浅（比如，最多有两层继承关系），继承关系不复杂，我们就可以大胆地使用继承。反之，系统越不稳定，继承层次很深，继承关系复杂，我们就尽量使用组合来替代继承**。

## 面向过程的贫血模型和面向对象的充血模型对比？

**领域驱动设计（Domain Driven Design，简称 DDD）主要是用来指导：==如何解耦业务系统，划分业务模块，定义业务领域模型及其交互==**。DDD 将领域模型分为四大类：失血模式、贫血模式、充血模式（较为备受推崇）、胀血模式。此处的 “血” 主要指的是 Domain Object 的 Domain 层（即：业务层）的区别。

> 做好领域驱动设计（DDD）的关键是，看你对自己所做业务的熟悉程度，而并不是对领域驱动设计这个概念本身的掌握程度。即便你对领域驱动搞得再清楚，但是对业务不熟悉，也并不一定能做出合理的领域设计。所以，**不要把领域驱动设计当银弹，不要花太多的时间去过度地研究它**。

- [失血模式](https://www.cnblogs.com/facker1/p/10613966.html)：模型中仅包含数据的定义和 getter/setter 方法，业务逻辑和应用逻辑都放到 Service 层中。
  - [EJB -  Enterprise Java Beans](https://baike.baidu.com/item/EJB)
  - 这种类在 Java中叫 **[POJO(Plain Ordinary Java Object-简单的 Java 对象)](https://blog.csdn.net/IndexMan/article/details/117870394)**
  - [VO，BO，PO，DO，DTO的区别](https://blog.csdn.net/weixin_45335305/article/details/126121307)
  - [Java各种对象（PO,BO,VO,DTO,POJO,DAO,Entity,JavaBean,JavaBeans）的区分_柯南二号的博客-CSDN博客](https://blog.csdn.net/qq_41688840/article/details/109738090)
  - [pojo、entity、bo、vo、po、dto、javabean如何区分_虾泥泥泥泥的博客-CSDN博客](https://blog.csdn.net/weixin_44179269/article/details/104086779)
  
- 贫血模式（Anemic Domain Model）：模型中包含了一些业务逻辑你，但不包含依赖[持久层](https://www.cnblogs.com/restlessheart/p/6872271.html)的业务逻辑，依赖于持久层的逻辑会放到 Service 层（即：将数据定义(Bo)和业务实现(Service)拆分开来）

```java
////////// Controller+VO(View Object) //////////
public class UserController {
  private UserService userService; //通过构造函数或者IOC框架注入
  
  public UserVo getUserById(Long userId) {
    UserBo userBo = userService.getUserById(userId);
    UserVo userVo = [...convert userBo to userVo...];
    return userVo;
  }
}

public class UserVo {//省略其他属性、get/set/construct方法
  private Long id;
  private String name;
  private String cellphone;
}

////////// Service+BO(Business Object) //////////
public class UserService {
  private UserRepository userRepository; //通过构造函数或者IOC框架注入
  
  public UserBo getUserById(Long userId) {
    UserEntity userEntity = userRepository.getUserById(userId);
    UserBo userBo = [...convert userEntity to userBo...];
    return userBo;
  }
}

public class UserBo {//省略其他属性、get/set/construct方法
  private Long id;
  private String name;
  private String cellphone;
}

////////// Repository+Entity //////////
public class UserRepository {
  public UserEntity getUserById(Long userId) { //... }
}

public class UserEntity {//省略其他属性、get/set/construct方法
  private Long id;
  private String name;
  private String cellphone;
}
```

MVC 中的失血模式：数据访问层（Entity + Repository） --> 业务逻辑层（BO + Service） --> 接口层（ VO + Controller 供外部访问）。

- 充血模式（Rich Domain Model）：模型中包含了所有的业务逻辑，包括依赖于持久层的业务逻辑（充血模式中业务逻辑层 =  Service 层 + Domain 层）。

> 充血模式和贫血模式一样，也是分为：接口层-Controller、逻辑层-Service、数据访问层-Repository 三层，两者的区别主要是在 “Service” 层。Domain 层相当于 BO 层，但 Domain 层既包含数据也包含业务逻辑。**总结一下的话就是，==基于贫血模型的传统的开发模式，重 Service 轻 BO；基于充血模型的 DDD 开发模式，轻 Service 重 Domain==**。

- 胀血模式：把和业务逻辑无关的其他应用逻辑（如：授权、事务等）都放到领域模型中。

1. 为什么说基于失血模式/贫血模型的传统开发模式违反 OOP ？数据定义 + 方法是分离的，这是典型的属于面向过程的写法

2. 基于贫血模型的传统开发模式既然违反 OOP（BO 仅负责定义数据，那么就意味着 setter 方法必须是 public 的，即：任意代码都可以随意修改数据），那又为什么如此流行？

   - 业务简单：大部分开发系统的业务都比较简单，不需要动脑子精心考虑业务的拆分（即：不需要去精心设计充血模型）
   - 贫血模式建模简单，充血模式设计复杂：贫血模式在BO中定义数据，所有逻辑都在Service中，而充血模式需要定义数据并考虑到针对哪些数据是不能暴露的，哪些数据是需要暴露的，这需要我们提前对业务有一定的了解
   - 定式思维：多年来的开发习惯，习以为常。好比“当你的代码以一种奇怪的方式运行起来了，千万不要再去动它了！“，以前就这样做，那么现在依然这样处理

3. 什么情况下我们应该考虑使用基于充血模型的 DDD 开发模式？

   - 业务简单的系统的开发，比较适合基于贫血模式的传统开发模式，使用充血模式的 DDD 开发模型有点大材小用，无法发挥作用

   - 业务复杂的系统适合基于DDD 的充血模式，需要前期对业务有足够了解，投入精力进行模型设计，能大大提高代码复用性和可维护性

   > 1. Entity 是 Respository 返回的， BO 是 service 返回的， VO 是 controller 返回的。
   >
   > 2. 贫血模式大部分是SQL 驱动的开放模式。 面对业务的时候首先根据具体情况定义表结构，然后看通过那些SQL 操作能满足业务。然后就是定义Entity BO VO 最后向Repository Service Controller类中添加相应的代码。 这种形式的编程，一个是代码的复用性太差，稍微不同一点的业务就需要新的接口，可能导致类似的SQL和接口太多。

## 领域驱动模型-DDD 是什么？设计思想是什么？

- [贫血，充血模型的解释以及一些经验_知识库_博客园 (cnblogs.com)](https://kb.cnblogs.com/page/520743/)
- [温故知新，遇见面向对象编程(OOP)，如何基于接口而非实现编程，谈抽象类(Abstract)、接口(Interface)的区别和使用场景 - TaylorShi - 博客园 (cnblogs.com)](https://www.cnblogs.com/taylorshi/p/16641471.html)
- [理解面向过程（OPP）、面向对象（OOP）、面向切面（AOP） - 狂奔的小马扎 - 博客园 (cnblogs.com)](https://www.cnblogs.com/minigrasshopper/p/10271758.html)
- [漫画 | 被TDD/BDD/DDD......“逼疯”的程序员](https://mp.weixin.qq.com/s/6TUPAdN-UtX8E1DFUw16Xg)
- [反面模式 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/反面模式)
- [DDD（领域驱动设计）系列主题：失血模型，贫血模型，充血模型和胀血模型详细解读和代码案例说明！](https://blog.csdn.net/u011537073/article/details/114267739)
- [软件设计之美 (geekbang.org)](https://time.geekbang.org/column/intro/100052601?tab=catalog)
- [DDD 实战课 (geekbang.org)](https://time.geekbang.org/column/intro/100037301)
- [阿里、京东基于DDD的架构设计与最佳实践-基于 DDD 的应用架构设计和实践 (geekbang.org)](https://u.geekbang.org/lesson/285?article=463741)