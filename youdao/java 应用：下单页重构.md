
1. 写了测试用例，运行测试类时，控制台报错：No tests found for given includes:'xxxx'

![No tests found for given includes:xxxx](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/gradle-test-error-no-tests-found.png)

- 解决办法：https://blog.csdn.net/fanbaodan/article/details/100541582

-----

2、WIN10 Terminal/CMD 输入java/javac出现乱码的解决方法

![Windows 命令行 java/javac 乱码](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/windows-terminal-javac-show-gibberish.png)

造成原因：编码不一致导致。如果先执行了 `chcp 936` 切换到 `GBK` 的编码发现就不会乱码。

- 解决办法：https://fabiochen.hashnode.dev/win10-terminalcmd-javajavac


----------

3、由 `OpenJDK` 引起的 `java.lang.StackOverflowError`（栈内存溢出）

![java.lang.StackOverflowError](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20230708121417.png)

项目是 `JDK 1.8` 版本的，最开始拉下来的时候用 `IDEA` 自己下载的 `JDK 14` 运行发现也没有问题，为了版本统一自己去 `OpenJDK` 官网下载了 `OpenJDK 1.8.43` 自行安装发现代码正常运行。

拉取了代码进行更新，自己也写了一段代码之后...突然发现报错 `java.lang.StackOverflowError`，查看了报错的日志发现可能是 `Lombok` 这个包引起的，试过了网上能找到的方法：
- `Lombok` 版本和 `JDK` 版本不对应：`Lombok` 的版本是 `1.18.16` 是支持 `JDK 1.8` 的
- 代码原因，存在递归/死循环/无限调用：切到了 `master` 分支，发现运行依然有问题
- 增加了 `-Xss` 参数

都没有用...而且同事运行代码是正常的。想到回滚了我写的所有代码，我最近的操作也就只有更换 `JDK` 版本这一个操作了...

通过 `IDEA` 重新下载了 `Amazon Cerreto JDK 1.8.0_372` 之后，重新运行...居然正确了。

![Download JDK By IDEA](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/download-jdk-by-idea.png)

------------------------

4、Java 代码测试覆盖率：

- https://www.cnblogs.com/df888/p/15708053.html
- https://www.eclemma.org/jacoco/



--------------------

5、设置 springboot 运行时环境变量

```console
org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'checkoutServiceImpl': Unsatisfied dependency expressed through field 'dealerService'; nested exception is org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'dealerServiceImpl' defined in URL [jar:file:/D:/javaDocs/car-rental-api/common/build/libs/common-1.6.3-RELEASE.jar!/com/qeeq/common/service/dealer/impl/DealerServiceImpl.class]: Unsatisfied dependency expressed through constructor parameter 0; nested exception is org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'dealerRepository' defined in URL [jar:file:/D:/javaDocs/car-rental-api/common/build/libs/common-1.6.3-RELEASE.jar!/com/qeeq/common/dao/world/DealerRepository.class]: Cannot resolve reference to bean 'worldDataSourceSqlSessionFactoryBean' while setting bean property 'sqlSessionFactory'; nested exception is org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'worldDataSourceSqlSessionFactoryBean' defined in class path resource [com/qeeq/front/config/MybatisConfig.class]: Unsatisfied dependency expressed through method 'worldDataSourceSqlSessionFactoryBean' parameter 0; nested exception is org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'worldDataSource' defined in class path resource [com/qeeq/front/config/DatabaseConfig$WorldDatasourceConfig.class]: Bean instantiation via factory method failed; nested exception is org.springframework.beans.BeanInstantiationException: Failed to instantiate [javax.sql.DataSource]: Factory method 'dataSource' threw exception; nested exception is java.lang.IllegalArgumentException: dataSource or dataSourceClassName or jdbcUrl is required.Disconnected from the target VM, address: 'localhost:57154', transport: 'socket'
```

发现有人删除程序启动文件的以下代码

```java
if (StringUtils.isBlank(System.getProperty("spring.profiles.active"))) {
    System.out.println("未配置环境变量spring.profiles.active, 默认使用development,swagger");
    System.getProperties().setProperty("spring.profiles.active", "development,swagger");
}
```

![IDEA Set SpringBoot Active Profiles](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/set-spring-boot-active-profiles.png)

------------

6、注解：@Data与@EqualsAndHashCode 的用法 https://juejin.cn/post/7055571573050179620

---------------------

7、类型转换

- 数组与字符串互转：https://www.cnblogs.com/ooo0/p/9169311.html


--------------------

8、打印 Spring 所有的 Bean 对象，调试 `@Qualifier` 注解

接口类 `ExtraServiceService` 有 3 个具体的实现类：`PCPServiceImpl`、`CTPServiceImpl`、`PAIServiceImpl`，希望使用不同的属性进行承载，了解到了 `@Qualifier` 注解可以实现，但是说第一个字母需要小写

最开始代码

```java
@Autowired @Qualifier("pAIServiceImpl")
ExtraInsuranceService paiService;

@Autowired @Qualifier("cTPServiceImpl")
ExtraInsuranceService ctpService;

@Autowired @Qualifier("pCPServiceImpl")
ExtraServiceService pcpService;

```

调试的时候发现报了“空指针异常”，于是看到 `paiService`、`ctpService`、`pcpService` 是 `NULL`，也就是说 `SpringBoot` 的自动注入到对应属性的时候没有成功...

Java 是常驻，Spring 中的类类似于单例一样被加载进内存中...那么能否全部打印出来？看看我需要的 Beans 到底是什么，然后更正 `@Qualifier` 的信息

```java
@Autowired
ApplicationContext applicationContext;
// 下方更正后的
@Autowired
CarDetailService carDetailService;
@Autowired
@Qualifier("PAIServiceImpl")
ExtraInsuranceService paiService;
@Autowired
@Qualifier("CTPServiceImpl")
ExtraInsuranceService ctpService;
@Autowired
@Qualifier("PCPServiceImpl")
ExtraServiceService pcpService;

@Test
public void testPCP() {
    System.out.println(new Gson().toJson(applicationContext.getBeanDefinitionNames()));
}
```

搜索一下 `ctp`、`PCP`、`PAI` 的关键字信息更正即可。


- https://blog.csdn.net/loongshawn/article/details/106259754
- https://blog.chean.cc/2022/04/29/springboot-%E5%A6%82%E4%BD%95%E6%9F%A5%E7%9C%8Bspring-boot%E5%BA%94%E7%94%A8%E4%B8%AD%E6%89%80%E6%9C%89%E7%9A%84bean%EF%BC%9F
- https://www.cnblogs.com/emanlee/p/15758454.html
- https://blog.csdn.net/sayyy/article/details/108074597
- https://www.cnblogs.com/libin6505/p/13223744.html

-------------------------

9、Jackson 忽略不存在的字段：https://blog.csdn.net/rogerxue12345/article/details/104966691
- Java 中 POJO 和 json 互转时 忽略隐藏字段： https://blog.51cto.com/u_14622073/2617878


------------------------

10、BigDecimal 相等问题
- https://blog.csdn.net/xiuxiuzhuanshu/article/details/84958014
- https://www.cnblogs.com/hollischuang/p/13703909.html
- https://juejin.cn/post/6844903919089352718


--------------------------

11、字符串处理

- StringUtils类中isEmpty与isBlank的区别：https://www.cnblogs.com/dennisit/p/3705374.html
- 高效字符串拼接问题

-----------

12、集合


- new HashMap()和Maps.newHashMap()的区别以及 newHashMapWithExpectedSize() ： https://juejin.cn/post/6844903897719390216
    - Java 原生 API : `Map<String, Object> result = new HashMap<String,Object>();`
    - Google Guava.jar 提供的方法： `Map<String, Object> result = Maps.newHashMap()` 简化写法，并没有性能方面的提升
- Map 的更新
    - https://www.delftstack.com/zh/howto/java/update-value-in-hashmap-java/
    - https://javarevisited.blogspot.com/2022/12/how-to-update-value-for-key-hashmap.html

---------------

13、https://beginnersbook.com/java-tutorial-for-beginners-with-examples/

-----------

14、Bean 注入方式：https://blog.csdn.net/h176nhx7/article/details/120029675

-----------


----------------


16、函数式编程支持：Function/BitFunction 接口

- Java8_Function和BiFunction ： https://www.jianshu.com/p/8dc46a2dc21d
- Java8新特性Function、BiFunction使用 https://www.cnblogs.com/jimmyshan-study/p/10970970.html 
- Java 8 之Function<T, R>和BiFunction<T,U,R>接口 ： https://juejin.cn/post/6958684346014236679
- 使用Java 8的二元函数BiFunction,采用函数式编程思维实现List元素的自定义排序功能 https://blog.51cto.com/jerrywangsap/5205922


------------

17、关于返回给前端的 “空”，到底是 `NULL` 还是 `{}`、`[]`、`""` 呢？

- 设计模式：空对象（null object） in java https://www.shenyanchao.cn/blog/2012/11/02/null-object-in-java/

---------------------

18、类型转换（Object -> List<String>）告警错误 https://blog.csdn.net/lydms/article/details/103934166


----------------------

19、
- https://blog.csdn.net/weixin_41605945/article/details/104460780
- https://zhuanlan.zhihu.com/p/560319663
- https://mp.weixin.qq.com/s/f7rxzCM1U14fpp7TWWWM5A
- https://mp.weixin.qq.com/s/yUtBgfFA_D6UlV4iXQ3O3g
- https://mp.weixin.qq.com/s/U4lgOgD7h1_uPcsQ-R00Qg

------------------------------------

20、关于各种O，DO/BO/DTO/VO/AO/PO

- https://zhuanlan.zhihu.com/p/105390453
- 阿里巴巴 Java 开发手册 https://blog.51cto.com/u_12497420/3357855

分层领域模型规约：

- DO（ Data Object）：与数据库表结构一一对应，通过DAO层向上传输数据源对象。
- DTO（ Data Transfer Object）：数据传输对象，Service或Manager向外传输的对象。
- BO（ Business Object）：业务对象。 由Service层输出的封装业务逻辑的对象。
- AO（ Application Object）：应用对象。 在Web层与Service层之间抽象的复用对象模型，极为贴近展示层，复用度不高。
- VO（ View Object）：显示层对象，通常是Web向模板渲染引擎层传输的对象。
- POJO（ Plain Ordinary Java Object）：在本手册中， POJO专指只有setter/getter/toString的简单类，包括DO/DTO/BO/VO等。
- Query：数据查询对象，各层接收上层的查询请求。 注意超过2个参数的查询封装，禁止使用Map类来传输。

领域模型命名规约：

- 数据对象：xxxDO，xxx即为数据表名。
- 数据传输对象：xxxDTO，xxx为业务领域相关的名称。
- 展示对象：xxxVO，xxx一般为网页名称。
- POJO是DO/DTO/BO/VO的统称，禁止命名成xxxPOJO。

-------------------------------

21、查询 `MongoDB` 的时候报错：`Failed to instantiate java.util.List using constructor NO_CONSTRUCTOR with arguments` 

原因：某个字段的属性在 DO 中定义为 List 类型，但是 MongoDB 实际的数据不是

如何排查：

1. 快速查询一下 `List` 属性的字段，注释掉一个个看
2. 断点 MongoDB 映射的代码，对比排查字段类型 
    - 代码：`org.springframework.data.mongodb.core.convert.MappingMongoConverter#readProperties`
    - `evaluator.source` 可以查看源数据

-----------------------

22、Gopube 部署

- https://zhuanlan.zhihu.com/p/59796137
- 通过 Apollo 配置 yaml 进行拉取部署

-----------------

23、类型转换(Jackson)

- https://www.appsdeveloperblog.com/unrecognized-field-not-marked-as-ignorable-java-jackson/
- 如果利用泛型来实现，传递类型，从而自动进行类型转换？

---------------------

24、Java 的数学计算
- https://bingochou.gitbooks.io/java-se/content/chapter11.html
- https://www.jianshu.com/p/695893e97f19
- https://learn.microsoft.com/zh-cn/dotnet/api/java.math.bigdecimal.divide?view=xamarin-android-sdk-13
- https://juejin.cn/post/7025607161883394079

------------------

25、关于 null 判断

- `x != null` 和 `ObjectUtils.isEmpty()` 有什么区别？
- `str != null` 和 `StringUtils.isEmpty()/StringUtils.isBlank()` 的区别？
- https://www.jb51.net/article/239117.htm

---------------

26、如何实现 `_no_cache` 参数绕过缓存

- SpEL 表达式： http://www.itsoku.com/article/121
- https://blog.csdn.net/weixin_43041241/article/details/90108109

-------------------

27、`K8s` 查看日志

1). `kubectl` 命令使用 `Tab` 键就报错 `bash: _get_comp_words_by_ref: command not found`

![kubectl error bash: _get_comp_words_by_ref: command not found](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/kubectl-tab-error-command-not-found.png)

- https://blog.csdn.net/qq_29974229/article/details/102890267

自动补全没有安装好，重新安装即可！

2). kubectl logs 查用命令

- https://blog.csdn.net/972301/article/details/106166403
> 一个 pod 中多个容器时，需要用 -c 指定查看日志的容器
- 查看 Pod 中的容器： https://www.shellhacks.com/kubectl-get-pod-containers/
- https://juejin.cn/s/kubectl%20logs%E5%91%BD%E4%BB%A4

3). 如何查看一个 deployment 下的所有的 pod 的日志？

要查看一个 Pod 属于哪个 Deployment，您可以使用 kubectl 命令的不同选项来获取有关 Pod 的信息。以下是两种方法：

1. 使用 kubectl get pods 命令：
    - 运行 kubectl get pods 命令，将列出所有正在运行的 Pod。在输出结果中，您可以查看 NAME 列和 NAMESPACE 列来获取 Pod 的名称和所属命名空间。
    - 要查看一个特定 Pod 属于哪个 Deployment，可以使用 kubectl describe pod <pod-name> -n <namespace> 命令，并查找输出中的 "Controlled By" 字段。该字段将显示 Pod 的控制器，它通常是该 Pod 所属的 Deployment 或 ReplicaSet 的名称。
2. 使用 kubectl get pods -o wide 命令：
    - 运行 kubectl get pods -o wide 命令，将列出所有正在运行的 Pod，并显示更多的列，包括 CONTROLLER 列。在该列中，您可以看到 Pod 所属的 Deployment 或 ReplicaSet 的名称。

要查看 Pod 的标签，您可以使用 kubectl get pods <pod-name> -n <namespace> -o json 命令，并查找输出中的 "labels" 字段。该字段将显示 Pod 的标签键值对。

例如，假设您有一个 Pod 名为 "my-pod"，位于 "default" 命名空间中。您可以使用以下命令来查看该 Pod 所属的 Deployment（或 ReplicaSet）的名称和标签：

```shell
kubectl get pods my-pod -n default
kubectl describe pod my-pod -n default
kubectl get pods my-pod -n default -o wide
kubectl get pods my-pod -n default -o json
```

要将同一个 Deployment 下的所有 Pod 日志都打印出来，可以通过使用 kubectl logs 命令结合选择标签的方式实现。以下是具体步骤：

1. 首先，确保您已经在控制台或终端中登录到 Kubernetes 集群，并拥有适当的权限。
2. 使用 kubectl get pods 命令获取属于特定 Deployment 的所有 Pod 的名称。可以使用 -l 或 --selector 参数来选择特定的标签，以筛选属于 Deployment 的 Pod。例如，如果 Deployment 的标签是 app=my-app，则可以使用以下命令获取所有相关的 Pod：`kubectl get pods -l app=my-app`
3. 一旦获取了所有相关的 Pod 的名称，可以通过循环来逐个获取每个 Pod 的日志并打印出来。使用 kubectl logs 命令，并将每个 Pod 的名称作为参数传递给该命令。例如：
```shell
for pod in $(kubectl get pods -l app=my-app -o jsonpath='{.items[*].metadata.name}'); do
  echo "Logs for Pod: $pod"
  kubectl logs $pod
done
```

这个命令会循环遍历所有符合选择标签条件的 Pod，然后使用 kubectl logs 命令分别获取每个 Pod 的日志并打印出来。

请注意，这种方法假设所有属于同一个 Deployment 的 Pod 都有相同的选择标签。如果 Pod 有其他不同的选择标签，或者您只想查看特定状态的 Pod 日志（如 Running 状态的 Pod），可以进一步修改选择标签的条件来满足您的需求。


```shell
# 显示标签
kubectl get pods --show-labels
```

-------------------

28、适配器模式

- https://mp.weixin.qq.com/s/SmjAKecUmzaDYLPJui9X4A

-------------

29、两层循环

```php
foreach ($list as $carTypeId => $define)
{
    if (is_array($define['group'])) {
        foreach ($define['group'] as $group) {
            $reverseList[$group['group_id_1']][$group['group_id_2']] = $carTypeId;
        }
    }
}
```

- Java HashMap computeIfAbsent() 方法 ： https://www.runoob.com/java/java-hashmap-computeifabsent.html
- https://www.cnblogs.com/codelogs/p/16883736.html


------------

30、Arrays.asList() 和 Collections.singletonList() 

- https://cloud.tencent.com/developer/article/1327743
- https://blog.csdn.net/u010525970/article/details/52381730
- https://www.cnblogs.com/xingzc/p/9144375.html
- Arrays.asList() vs Collections.singletonList() https://stackoverflow.com/questions/26027396/arrays-aslist-vs-collections-singletonlist
- 谨慎使用 Arrays.asList() 和 Collections.singletonList() https://www.jianshu.com/p/fe9c3c3f7256

--------------

31、Java 的“值传递”

- https://www.cnblogs.com/dolphin0520/p/10693891.html
- https://juejin.cn/post/7221730647043244090
- https://www.flysnow.org/2018/02/24/golang-function-parameters-passed-by-value


因为 Integer 是包装类对象，属于不可变对象，因此：
1. Java 中都是值传递，但是变量是区分“值类型”、“引用类型”两种的
2. 数组、对象作为形参传递，都是属于引用类型，传递的是“指针地址的值”
3. 对象作为形参的时候，传递的对象如果是不可变对象（如 String、包装类型），那么会重新创建新的变量进行操作

---------------

32、`start.equals("00:00")` 和 `"00:00".equals(start)` 的区别？

发现 `IDEA` 总是将类似 `start.equals("00:00")` 的代码标黄色下划线并提示 ：「'"00:00"' 应该作为方法 "equals()"的调用方，而不是参数」，很好奇这是为啥呢？？难道这是一个什么编码规范习惯？？

先说结论：**从代码的健壮性来说，`"00:00".equals(start)` 比 `start.equals("00:00")` 要好**！

`start` 是一个变量，如果 `start` 是 `null`，那么 `start.equals("00:00")` 可能导致空指针异常，除非我们能百分之百确定 `start` 一定不会为 `null`。

但是 `"00:00".equals(start)` 本身就可以避免这个问题，即使 `start` 是 `null`，也返回 `false`。因为 `"00:00"` 是一个写死的 `100%` 不为 `null` 的不可变 `String` 对象，一定可以调用其 `equals()` 方法。

-----------

33、`if( var == null )` 和 `if( null == var )` 的区别？

由 「问题：`start.equals("00:00")` 和 `"00:00".equals(start)` 的区别？」 衍生出了该问题。

在某些编程风格中认为 `if (null == var)` 更好，因为它可以防止不小心使用赋值等号（`=`） 代替比较等号（`==`），从而导致意外的赋值错误。

例如 `PHP` 中 ：

如下方代码，变量 `$a` 会被错误的赋值为 `null`，也不会报错，且编辑器也不会有错误提示：

```php
<?php

$a = "aaa";
if(!($a = null)) {
	// a 不为 null 时的操作
	var_dump($a); // 变量 a 反而被错误赋值了 null
}
```

但是如下代码，如果将 `null` 写在前方，运行时会报致命错误 `Parse error: syntax error, unexpected token "=" `，而且编辑器也会报错：

```php
$b = "bbbb";
if (!(null = $b)) { # 异常
	var_dump($b);
}
```

虽然在 `Java/C` 此类编译型语言中，这类书写习惯在编译时候就会报错，但是将 `null == var` 替换 `var == null` 确实是一种更好的编程习惯风格。

------

Java 中 `==` 比较的是两个对象的引用（内存地址）是否一样，如果不一样则认为两个对象是不相等的，而 `equals()` 方法大部分比较的是两个对象的 “值” 是否相同。

如果你想检查一个变量是否为 `null`，使用 `==` 是更加合适的，因为你关心的是引用是否为 `null`，而不是内容。

如果你尝试使用 `equals()` 方法来判断检查 `null`，如 `var.equals(null)`，那么当 `var` 为 `null` 的时候可能会触发 `NPE`。如果一定要用，那么需要写为 `var !=null && var.equals(null)`。。。但这又合并多此一举呢？


-----------------

34、Spring 接收参数

- [请求头Content-Type:application/json,java后端如何接收数据_content-type':'application/json-CSDN博客](https://blog.csdn.net/zylwoaini/article/details/121215404)
- [5.SpringMVC系列第5篇：@RequestBody接收Json格式数据-Java充电社【公众号：Java充电社】](http://www.itsoku.com/article/216)

-------

35、List remove 的坑

- [java ArrayList.remove()的三种错误用法以及六种正确用法_java arraylist remove-CSDN博客](https://blog.csdn.net/king0406/article/details/103789459)
- [List中remove()方法的陷阱，被坑惨了！-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1888730)

------------

36、Spring 中 getBean 的几种方式

- [ApplicationContextAware接口的作用-CSDN博客](https://blog.csdn.net/bailinbbc/article/details/76446594)
- [Spring容器获取Bean的九种方式-spring获取bean的几种方式](https://www.51cto.com/article/744723.html)

--------------------
99、SpringBoot 启动流程、配置、缓存

- SpringBoot 结合 Spring Cache 操作 Redis 实现数据缓存：https://javawu.com/archives/2406
- https://www.cnblogs.com/niujifei/p/15580423.html
- https://www.cnblogs.com/newAndHui/category/1390287.html?page=2
- https://spring.hhui.top/spring-blog/2022/01/17/220117-SpringBoot%E7%B3%BB%E5%88%97%E4%B9%8BWeb%E5%A6%82%E4%BD%95%E6%94%AF%E6%8C%81%E4%B8%8B%E5%88%92%E7%BA%BF%E9%A9%BC%E5%B3%B0%E4%BA%92%E8%BD%AC%E7%9A%84%E4%BC%A0%E5%8F%82%E4%B8%8E%E8%BF%94%E5%9B%9E/
- [SpringBoot 深入理解配置文件加载顺序和自定义修改默认的加载顺序](https://blog.csdn.net/qq_35634181/article/details/115543960)


-------------

本地线程共享变量

- [FastThreadLocal 是什么鬼？吊打 ThreadLocal 的存在！！-阿里云开发者社区](https://developer.aliyun.com/article/835728)
- [本地线程变量（四）：FastThreadLocal - 不懂技术的小菜鸟~ - 博客园](https://www.cnblogs.com/acmaner/p/13889864.html)
- [吊打 ThreadLocal，谈谈FastThreadLocal为啥能这么快？ - 掘金](https://juejin.cn/post/7023921712467017741)


---------

拦截器

- [处理器拦截器（HandlerInterceptor）详解(转) - kosamino - 博客园](https://www.cnblogs.com/jing99/p/11147152.html)
- [HandlerInterceptor：SpringBoot拦截器的基本使用（详解）_实现handlerinterceptor获取response响应体-CSDN博客](https://blog.csdn.net/weixin_44259720/article/details/104615086)
- [interceptor 配合Threadlocal全局处理请求基本信息 - 掘金](https://juejin.cn/post/6844903710183653383)
- [SpringBoot（HandlerInterceptor）+ThreadLocal实现登录拦截_handlerinterceptor threadlocal-CSDN博客](https://blog.csdn.net/qq_50652600/article/details/124872456)