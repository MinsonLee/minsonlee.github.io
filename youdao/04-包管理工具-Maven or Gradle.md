# Java for PHP Developer：04-包管理工具-Maven or Gradle

 `Stack Overflow` 上一名 `PHPer2Javaer` 问了一个问题：[Composer Equivalent in JAVA? - Java 中等效于 Composer 的工具是什么？](https://stackoverflow.com/questions/23844103/composer-equivalent-in-java)
 
 
 PHP Composer
 
 - https://blog.51cto.com/lxw1844912514/2941786
 - https://blog.p2hp.com/archives/3053
 - 疑问：能否只通过一个 composer.json 文件构建出自己的 PHP 的项目，这样每次拉项目就只需要拉取一份 composer.json 而不需要拉取整个完整的项目
 - https://zhuanlan.zhihu.com/p/270585517
 - https://blog.csdn.net/ITfooter/article/details/78970702
 - https://www.cnblogs.com/imzhi/p/create-php-composer.html

Java 的包管理工具：Maven or Gradle

- [深入了解gradle和maven的区别](https://segmentfault.com/a/1190000039202747)
- [超级详细的Maven教程（一）Maven介绍及环境搭建](https://developer.aliyun.com/article/795778)
- [超级详细的Maven教程（二）创建第一个Maven项目hellomaven](https://developer.aliyun.com/article/798908)
- [超级详细的Maven教程（三）Maven的坐标和仓库](https://developer.aliyun.com/article/799128)
- [超级详细的Maven教程（四）Maven核心配置文件：pom.xml详解](https://developer.aliyun.com/article/799936)
- [超级详细的Maven教程（五）依赖管理](https://developer.aliyun.com/article/801725)
- http://www.mvnbook.com/gradle-introduction.html
- https://mp.weixin.qq.com/s/Bg0KI4-mPz6AL5vOtj4JaQ
- https://mp.weixin.qq.com/s/gvximjyeaEcROwjf2WUhfQ


动力节点：Maven

- [Maven 入门](https://www.bilibili.com/video/BV1dp4y1Q7Hf/)
- [Maven 进阶](https://www.bilibili.com/video/BV1kg4y187td/)

尚硅谷Maven新版视频教程

- B站直达：https://b23.tv/99CT7nX
-百度网盘：https://pan.baidu.com/s/1A3zjyBFJR5COcI59mXvTBQ  提取码：yyds
- 阿里云盘：https://www.aliyundrive.com/s/mwZQ4oVMuuL（教程配套资料请从百度网盘下载）

尚硅谷Gradle视频教程

- B站直达：https://www.bilibili.com/video/BV1yT41137Y7
- 百度网盘：https://pan.baidu.com/s/1Hx9FuaQfOQu89SgwJTW2xQ?pwd=yyds 提取码：yyds
- 阿里云盘：https://www.aliyundrive.com/s/dCG7D3MsyG2（教程配套资料请从百度网盘下载）

-----------

Java 的包管理工具主要是 Maven 和 Gradle。

1. Maven：Maven 是 Java 领域最常用的构建和依赖管理工具之一。它使用基于 XML 的配置文件（pom.xml）来定义项目的依赖关系、构建配置和插件。Maven 的主要功能包括依赖管理、构建、测试、打包、部署等。Maven 使用中央仓库来存储和获取依赖包，它提供了一种声明式的方式来管理项目的依赖关系，可以自动下载和解析依赖，并处理传递性依赖。

2. Gradle：Gradle 是一种基于 Groovy 和 Kotlin DSL 的构建工具，也可以用于依赖管理。它提供了灵活且可扩展的构建脚本，允许开发者以声明式和程序化的方式定义构建逻辑。Gradle 支持多种构建任务、多项目构建和增量构建，可以自动解决依赖关系并自动下载和缓存依赖包。

在功能上，Composer 和 Maven/Gradle 都是用于管理项目依赖的工具，但有一些区别：

- 语言：Composer 是 PHP 语言的包管理工具，而 Maven 和 Gradle 是针对 Java 的包管理工具。它们针对各自语言的特性和约定进行了设计和实现。
- 配置文件：Composer 使用基于 JSON 的配置文件（composer.json），而 Maven 使用基于 XML 的配置文件（pom.xml），Gradle 使用 Groovy 或 Kotlin DSL。
- 依赖解析：Composer 和 Maven/Gradle 都支持自动解析和下载依赖，但它们的依赖描述方式略有不同。Composer 使用语义化版本约束来管理依赖关系，而 Maven 使用坐标和版本范围来表示依赖，Gradle 使用类似于 Maven 的方式，但提供了更灵活的语法。
- 生态系统：Composer 面向 PHP 社区，有专门的 Packagist 中央仓库，其中包含了大量的 PHP 包供开发者使用。Maven 和 Gradle 面向 Java 社区，有 Maven 中央仓库和其他私有仓库，提供了广泛的 Java 包。

总的来说，Composer 和 Maven/Gradle 都是功能强大的包管理工具，它们为各自的语言生态系统提供了便捷的依赖管理和构建能力，但在配置文件格式、依赖描述和生态系统方面存在一些差异。