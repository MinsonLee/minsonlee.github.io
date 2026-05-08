# Java for PHP Developer：02-Java 编辑器 IDEA

- 尚硅谷IDEA使用全攻略教程
- B站直达：https://www.bilibili.com/video/BV1CK411d7aA
- 经典版：https://www.bilibili.com/video/BV1PW411X75p/
- 百度网盘：https://pan.baidu.com/s/1Gbavx34OfF29LZqJ8dc85g?pwd=yyds 提取码: yyds 
- 阿里云盘：https://www.aliyundrive.com/s/Rca9Urqhgfz（教程配套资料请从百度网盘下载）
- 笔记在：https://www.aliyundrive.com/s/XNS9aC4iyjJ （提取码： 1t2s）



- IntelliJ IDEA如何设置头注释，自定义author和date：https://blog.csdn.net/Connie1451/article/details/79877228
- Idea配置Javadoc ：https://www.jianshu.com/p/2092b0ea2fd4
- https://www.evget.com/doclib/s/120/14618







-----------------------


4、插件

- IntelliJ IDEA常用插件推荐:https://developer.aliyun.com/article/803464
- 精品 IDEA 插件大汇总！值得收藏:https://xie.infoq.cn/article/80e44910cd6fcb697b942d353
- [IDEA 使用技巧](https://blog.csdn.net/gyaog/category_11215030.html)
- GenerateAllSetter ： https://finolo.gy/2021/06/IDEA%E8%87%AA%E5%8A%A8%E7%94%9F%E6%88%90%E5%AF%B9%E8%B1%A1%E8%B5%8B%E5%80%BC%E7%9A%84%E6%89%80%E6%9C%89set%E6%96%B9%E6%B3%95/
- AceJump
- Easy Code
- EasyYapi
- EnumGenerator
- GenerateO2O
- GenerateSerialVersionUID
- Git Commit Template
- GitToolBox
- Grep Console
- GsonFormatPlus
- Maven Helper
- Maven Search
- PlantUML Integration
- PlantUML2DDL
- Step Builder Generator
- Translation
- Auto filling Java call arguments
- Tabnine


已安装并使用

- JRebel 自动热重启项目： https://www.cnblogs.com/sansui6/p/17043448.html
    - https://blog.csdn.net/u012615705/article/details/115325301
- IdeaVim + IdeaVIMExtension： 将 IDEA 切换成 VIM（VIM）
- JSON 生成 Java 结构：`GsonFormatPlus`（快捷键 `Alt + S`）
- 快速生成实体对象的所有 Getter/Setter：`GenerateAllSetter`（快捷键 `Alt + Enter`）
- 快速转换各种命名规则（驼峰、下划线、中划线...）：`String Manipulation`（快捷键：`Alt + M` > `4-Swich Case` ）
- 有用的 Java 工具包：[`Lombok` 插件](https://hezhiqiang8909.gitbook.io/java/docs/javalib/lombok) - 通过提供一些注解来简化代码，在编译的时候又自动的将代码加到编译后的代码中
    - [Java开发神器Lombok使用详解](https://blog.csdn.net/wo541075754/article/details/103867617)
    - [Lombok安装Lombok原理Lombok使用教程](https://www.bilibili.com/video/BV1qJ411G7Dv/)
- AceJump 释放光标，快速跳转到指定位置（快捷键：`Ctrl + Shift + ;`）
- [Custom Postfix Templates](https://github.com/xylo/intellij-postfix-templates) 定义了很多语言的一些常用代码段，用快捷缩写的方式自动补全代码
- Maven Helper： Maven 包依赖分析工具，可以帮你分析出当前用的 Maven 包的导入情况（依赖冲突、查看所用所有依赖...）非常棒
    - [maven helper插件安装使用（分析maven依赖关系的工具，方便解决jar包冲突问题）](https://blog.csdn.net/weixin_44056920/article/details/107869171) 
    - [IDEA Maven Helper插件（详细使用教程）](https://blog.csdn.net/GyaoG/article/details/120599475)
- Gradle 依赖分析：
    - [IDEA中使用Gradle查看jar依赖关系](https://blog.csdn.net/u014653854/article/details/86136052)
    - [Generate Gradle dependencies](https://www.jetbrains.com/help/idea/work-with-gradle-dependency-diagram.html#gradle_diagram)
- `CodeGlance` 可以在代码编辑区的右侧生成一个竖向可拖动的代码缩略区，快速定位代码的同时，并且提供放大镜功能，效率工具



--------------------

5、模板

- IDEA类和方法注释模板设置：https://blog.csdn.net/xiaoliulang0324/article/details/79030752

---------------

6、快捷键（Keymap）

![How to search or set a map in IDEA?](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/idea-search-keymap.png)

- 快速打开设置（`File --> Settings`）：`Ctrl + Shift + S`
- 跳到接口实现类的方法：Go to Implementation(s) `Ctrl + Alt + B`
- 跳到父类方法：Go to Supper Method `Ctrl + U`
- 函数点击跳转：`Ctrl + B`
- 切换大小写：Toggle Case `Ctrl + Shift + U`
- 打开侧边栏 Project 选项卡：`Alt + 1`
- 自动末尾加分号：`Ctrl + Shift + Enter`
- [自定义快速切换 project 快捷键](https://blog.csdn.net/qq_43600166/article/details/124216130)：`Alt + P`


---------------------

- IDEA 如何快速实现override的方法 : https://blog.csdn.net/lingyiwin/article/details/89712950
- 什么是override注解作用？ https://www.feiniaomy.com/post/27918.html


-----------

使用小技巧

- Debug 模式下，右键 `Evaluate Expression` 可以局部修改代码进行调试，不用每次都重新 build 代码
![](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/idea-tips-evaluate-expression.png)
- 调试场景插件：https://github.com/lgp547/any-door
- 快捷键： `Ctrl + Alt + H`，查看方法的调用函数