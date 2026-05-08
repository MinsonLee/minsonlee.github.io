# 深入剖析 TP5 & TP6 源码
[TOC]
## 第1章：课程简介
> - 知其然还得知其所以然
> - 对 PHP 全局以及框架内科有质的飞跃
- 类的自动加载机制内核解刨
- 容器、依赖注入 控制反转 中间件 钩子以及行为解刨
- 设计模式（工厂、单例、注册树、门面等）
- 底层路由的深度分析
- 面向切面编程深度分析
- 反射机制深度分析
- 控制器、模型、视图等深度分析
- 异常处理、缓存等核心类库深度分析
- 框架层面面试技巧
- 个人成长经历分享

### 为什么需要学习框架源码？如何高效的学习呢？
> 框架的理念都是一致的，精一通百：原理是什么？为什么是要这样设计？什么情况下适用？如何实现？
1. 为啥选 TP5？
    - 免费开源
    - 简洁实用、中文社区支持强大
    - 市场占比高
2. 为啥要学习框架源码？
    - 写出优雅的代码
    - 深入理解 PHP
    - 面试装逼加分项
3. 如何高效的学习框架的源码呢？
    - 善用 IDE 工具：方便追踪、断点排查
    - 了解一下框架中的设计模式，尽可能的理解对应设计模式的场景
    - 知道了解文档中提及较多的概念：容器 Facade(门面) 依赖注入 AOP ...
    - 知道代码执行逻辑，通过小 DEMO 逐步追踪代码
> 如何获取代码：TP5.1 及后续版本在 TP 中文社区都没有更新，需要到 [Github 地址](https://github.com/top-think/think)去下载

## 第2章：类自动加载初始
> - 什么是框架？https://www.zhihu.com/question/19558524
> - 框架和类库的区别？https://www.cnblogs.com/wbqsln/archive/2012/07/02/2573713.html
> - 为什么要使用框架？https://www.cnblogs.com/relucent/p/3718579.html
> - 使用框架的优缺点？https://blog.csdn.net/a787031584/article/details/55517375
> - 写一个框架会遇到什么问题？https://www.cnblogs.com/qingfj/p/5738742.html
>   - ①定位好你写的框架的目标是什么？
>   - ②如何实现繁杂的各种类库间的管理及简单快捷的调用？

> - PHP 类的自动加载-spl_autoload_register()：https://www.php.net/manual/zh/language.oop5.autoload.php
> - PHP 自动加载-__autoload()：https://www.php.net/manual/zh/function.autoload.php
> - 命名空间：https://www.php.net/manual/zh/language.namespaces.php


> - PHP基础学习之SPL Autoload机制:https://www.jellythink.com/archives/152
> - PHP基础学习之autoload机制:https://www.jellythink.com/archives/150
> - PHP中的自动加载:https://www.zybuluo.com/phper/note/66447
> - PHP 自动加载功能原理解析
:https://learnku.com/articles/4681/analysis-of-the-principle-of-php-automatic-loading-function

> - 流程控制语句☞文件包含-include：https://www.php.net/manual/zh/function.include.php
> - 流程控制语句☞文件包含-require：https://www.php.net/manual/zh/function.require.php
> - 流程控制语句☞文件包含-include_once：https://www.php.net/manual/zh/function.include-once.php
> - 流程控制语句☞文件包含-require_once：https://www.php.net/manual/zh/function.require-once.php

**拓展阅读**
> [PSR 规范： https://learnku.com/docs/psr](https://learnku.com/docs/psr)

### 1. 如何解决繁杂的各种类库间的自动引入及管理是框架的灵魂(调用原理)

**ThinkPHP 5.1**
> Thinkphp 自定义封装了自动加载机制：通过一个函数来加载各个命名空间层的类、vendor 中通过 composer 安装的类
![image](056D7731A16048D9A7E1EF6348CB5AD2)

**Yii 2.0**
> Yii 则是通过两个文件：Yii.php 加载框架自己的类；通过 composer 的 autoload 自动加载 vendor 目录
![image](F90BB2BCCE5743F98275FDE5ACCA2112)

```sh
# 生成 runtime 下的 classmap.php 文件(类库映射文件)，可以提高加载性能！【若类库文件不存在可使用下述命令生成】
/apps/php72/bin/php think optimize:autoload
```
> 拓展阅读：
> - [tp5 提升性能的几个方法:https://www.cnblogs.com/wqy415/p/7792564.html](https://www.cnblogs.com/wqy415/p/7792564.html)
>
> 课后疑问：
> - 如果修改源码可以使得 TP 自动加载用户自己创建的目录下的类？【假设：框架目录在 
/data/htdocs/thinkphp5.1/ 下，现引入自定义的目录 /data/htdocs/thinkphp5.1/lms 】
>   - 使得用户自己的创建的类在 PSR 下能找到对应的路径？==> 根据 PSR 规范
>   - 使用 spl_autoload_register 自己注册一个自动加载的方法，使得能找到对应的路径？


**实战练习** 

1. 在框架目录(/data/htdocs/thinkphp5.1/)下，现引入自定义的目录 /data/htdocs/thinkphp5.1/lms，如何使得 TP 可以自动加载 lms 目录下的所有类？
    - 使用 spl_autoload_register 自己注册一个自动加载的方法，使得能找到对应的路径？
    ``` php
    public static function lms($class){
        $rootPath = self::getRootPath();
        $file = strtr($class, '\\', DIRECTORY_SEPARATOR) . '.php';
        $file = $rootPath. $file;
        if (is_file($file)) {
            __include_file($file);
        }
        return true;
    }
    ```
    然后在 register 函数中自动注册上述的自动加载方法，如下截图：
    ![image](D37A5851A01F4714B54CC8A69C25E0AD)
    
    - 使用 TP 框架自身实现自动加载目录 `self::addAutoLoadDir();`
    
    ![image](1AB4E64D68D84820A6F92568E746388E)
    
2. 在框架目录(/data/htdocs/thinkphp5.1/)下，现引入一个第三方插件目录到 library 下( /data/htdocs/thinkphp5.1/thinkphp/library/lms)，如何使得 TP 可以自动加载 lms 目录下的所有类？
    - 将新增的目录注册到系统命名空间中
    
    ![image](D79068EC29CE43D0904E5B2178F604F9)

3. 如何在不使用 composer update 的情况下将其他项目 composer 安装的类库在 vendor 目录下引入并正常使用？ ==> 对 composer autoload 的理解，即：更新 `autoload_static.php`下命名空间与类的映射关系
    1. 将类库目录复制到 vendor 目录下
    2. 添加 composer 自动加载命名空间的目录映射
    ![image](5932DB2453854263AEA7456E44CDDC60)


**课后疑问**
- [x]  **1. 为什么 extend 目录下的类，可以不需要命名空间？**
- 在 ThinkPHP `5.0` 及以上版本框架中， 如果你需要调用 PHP 内置的类库，或者第三方没有使用命名空间的类库，记得在实例化类库的时候加上 `\`
- 在 ThinkPHP `5.0` 中，只需要给类库正确定义所在的命名空间，并且命名空间的路径与类库文件的目录一致,那么就可以实现类的自动加载，从而实现真正的惰性加载.
- 在注册 extend 目录时候，注册路径已经是 `$rootPath . 'extend'`，因此 extend 下的类不能含有命名空间，若 extend 目录下还有子目录且子目录下有对应的类，那么这些类需要有命名空间，且命名空间命名为子目录名称
    ![image](3E744D556DD248D98C8CA034735D0CB4)


- [ ] **2. 用户的自动加载函数先于框架自动加载函数注册，但是为啥自动加载类的时候却没有先尝试使用用户自己注册的自动加载方法，再使用框架的自动加载方法呢？**
![image](07EE31A027834F1D8D24E330D731D54E)
![image](6B544DBC9809426AB76D3E701A515C8E)






## 第3章：解读配置文件
### 配置文件种类
1. 惯例配置
    - 核心框架内置的配置文件 `thinkphp/convention.php`,不建议更改

 
2. 应用配置
    -  每个应用的全局配置文件，在项目根目录下(与 `application` 同级)的 `config` 目录下的文件
    > - `config` 下的目录配置文件命名 `xxx.php` 对应着 `thinkphp/convention.php` 配置中的每一个 key 名。
    > - 这样处理的原因是：在实际开发中，配置项通常有很多（如：缓存配置、session配置、cookie配置、模板配置等），若集中在一个配置文件中，会导致配置文件过大，不易后期维护，拆分成多个文件以便于各个配置模块的维护和更新
    > - 如果不希望配置文件放到应用目录下面，可以在入口文件中定义独立的配置目录，添加CONF_PATH常量定义即可.
    > ```php
    > // 定义配置文件目录和应用目录同级
    > define('CONF_PATH', __DIR__.'/../config/');
    > ```


3. 模块配置：根据每个模块的设置特定的配置目录，命名和 `config` 目录下一样，如：`app.php` `cache.php` ......
    - ①. 在 `config>模块名称`目录下设置
    - ②. 在 `application>模块名称>config`目录下
    - 优先级：② > ①


4. 动态配置
    - 在业务流程代码中调用 `Config::set()` 动态覆盖更改配置
    > 1. 动态配置只有当次请求有效 


### 加载顺序
1. 惯例配置(convention.php) App::class->initialize()


2. 应用配置 App::class->initialize()->init();
    >**优先级**：rootPath/app/config/configExt/xxx.xxx >> rootPath/config/configExt/xxx.xxx


3. 模块配置 Module::class()->app->init($module);
    > **优先级**：rootPath/app/module/config/configExt/xxx.xxx >> rootPath/config/configExt/module/xxx.xxx


4. 动态配置 Config::set($key, $value);


**注意点**
- 加载顺序：框架会根据优先级从低到高的加载(`惯例配置` ==> `动态配置`)，然后按照优先级从高到低的合并覆盖
- 优先级：`rootPath/application` 目录下的优先级都会比 `config` 目录下的优先级高，一旦 `rootPath/application` 下对应的配置被加载后 `config` 目录下的配置就不会再加载



### 使用场景
- 惯例配置：
    - 框架默认配置是框架层面、通用、默认的设置
    - 一般来说，是不会直接在框架的核心配置文件上做修改的
    - 防止后期项目更新、维护、框架升级受到影响


- 应用配置：
    - 针对是 `整个应用/项目层面` 公共配置抽离，若要针对不同项目做不同配置，应该配置在此处
    - 如：有一个 web 应用和一个小程序应用，都使用 Thinkphp5.0 来开发，但是针对两个应用的实际业务场景有各自的缓存配置，应当在各自项目的application目录同级的 config 目录下修改 cache.php 配置


- 模块配置：
    - 针对是**同一个项目**下**不同模块**配置的抽离，若要针对不同模块做不同配置(如对同一个项目的前台/后台模块做不同配置)，应该使用此类配置方式加载


- 动态配置：
    - 只有特定的业务场景、行为中才需要更改对应的配置应当使用动态配置
    - 这种方式应当尽量少使用，且若使用的话，建议将此类设置归类在同一个动态配置文件中，方便后续统一管理


### Yaconf - 配置管理拓展
> - http://www.laruence.com/2015/06/12/3051.html
> - https://www.cnblogs.com/tinywan/p/9528200.html

- Yaconf 是一个常驻进程，能高效的管理加载配置，提高性能

**Yaconf 安装**
> 用 phpize 编译共享 PECL 扩展库 ¶: https://www.php.net/manual/zh/install.pecl.phpize.php

1. 克隆下载源码包：https://github.com/laruence/yaconf
2. 利用 PHP 安装目录下的 `php-path/bin/phpize` 编译生成 `configure` 文件
3. 指定扩展安装的 PHP 版本：`./configure --with-php-config=/usr/local/php/bin/php-config`
    > 需要将 `/usr/local/php/bin/php-config` 替换为你自己 php-config 的安装目录
4. 安装：`make -j && make install` ==> 拓展文件安装成功
    ![image](2821DE379D0545E19D066D85B6805006)
5. 在 `php.ini` 文件中引入 `yaconf.so`
    > 快速找到 php.ini 所在位置： php -i | grep php.ini
```ini
[Yaconf]
# 引用扩展
extension = "yaconf.so"

# 指定 conf 文件所在目录，该值不能通过 ini_set 动态设置，因为该值必须在 PHP 启动的时候就确定且常驻内存中
yaconf.directory=/data/conf/php/web 

# 心跳检查时间，若为0则不检查，但如果有修改，需重启PHP
yaconf.check_delay=100 # 100 秒检测一次配置文件是否有变动
```
6. 检测 Yaconf 是否安装成功： `php -m | grep yaconf`


### Yaml 格式配置文件
> 检查当前 PHP 版本是否安装了 yaml 扩展：`php -m | grep yaml`

#### yaml 扩展包安装
1. 通过源码包的方式安装：源码编译：`yaml 扩展.md`
2. 通过 pecl 安装 `/apps/php72/bin/pecl install yaml`


### Config 类实战解析

#### 1. 抽离改写 `\think\Config::loadFile` 方法，使得调用代码更加优雅
**背景**
<br/>![image](EDB7AFFE719D4D4C8F29575449899E08)

**分析**
- 目的：`\think\Config::loadFile` 不管`php` `yaml` 或其他文件格式类型的配置都可以直接调用 `return $this->parse($file, $type, $name);` ==> 下层(服务层)应该要对上层(调用层)屏蔽掉差异
- 调用情况如下截图：
    ![image](22465CC7D85340999B83EE0E9B3D16FF)
    由调用链得知，配置文件类型必须实现 `parse()` 方法并返回配置数组或配置字符串的结果

**解决**
- 抽离抽象类 `\think\config\driver\Config::class`，定义抽象方法 `parse()`
- 配置文件类型必须实现 `parse()` 方法返回 `config` 数组或单个值


#### 2. 各种配置文件格式：php、ini、xml、json、yaml 如何抉择？
**.php 配置文件**
- 优点：对 PHP 项目支持好，不需要额外的其他转换
- 缺点: 只支持 PHP 项目，配置文件无法跨语言的实现通用

**.ini 配置文件** 
- 优点:
- 缺点:

**.xml 配置文件**
- 优点:
- 缺点:

**.json 配置文件**
- 优点:
- 缺点:

**.yaml 配置文件**
> `Yaml` 的适应场景？如何巧用？
- 优点:
- 缺点:

**选择建议**


#### 3. 改写 Config 类使配置文件按 `config_ext` 归类读取
> 如：若 `.env` 中设置了配置文件类型为 `yaml` (`config_ext=".yaml"`)，则配置访问目录为：`config\yaml` `config\yaml\module` 或 `application\config\yaml`

**分析&&解决**
- 获取 `config_ext` 类型的操作需要在自动加载`所有配置文件`的前方(tp5.0 版本在是有这个问题 bug 的)
    <br/> ![image](952F3547D25C48FC80D0D4FA6F7D5C85)
    <br/> ![image](7C7BFF24959246389922CF26DFB7E885)
- 惯例配置是框架底层层面级别的配置文件，需要按照类型读取，框架源码内部的 `convention.php` 不动，其他格式类型的 `convention.xxx` 文件存放路径及格式 `rootPath/confing/convention.xxx`
    <br/> ![image](ED3D7CD72CFB4824A4571CA79B692CB8)
- 加载应用、模块配置文件时候需要加上 `config_ext` 层级
    <br/> ![image](B1D6FAF6BDFC4972B5D1BAFE1BB4C2A1)



#### 4. Yaconf 的思考
- 使用 `Yaconf` 能够做到什么？实际应用场景？如何巧用？
- 在 `Vagrant` 中，修改了 `php.ini` 的 `yaconf.check_delay=10`，重启了 nginx 和 php-fpm 服务之后仍然没有生效，必须要 `vagrant reload`？

#### 5. 将 Thinkphp 框架中的配置读取全局换成 Yaconf 方式


### 预定义接口 - ArrayAcess
> - **作用：提供像访问数组一样访问对象的能力的接口**
> - https://php.net/manual/en/class.arrayaccess.php
> - https://www.php.net/manual/zh/reserved.interfaces.php



### Env 类解析



## 第4章：依赖注入(DI)与控制反转(IOC)、容器与门面模式Facade
### 单例模式
#### 1. 什么是单例模式？

#### 2. 为什么要用单例？
> - 减少在同一进程中重复实例化类对象所带来的堆内存资源占用：[PHP对象在内存堆栈中的分配](https://juejin.im/post/5aa7be4a6fb9a028d3751553)


#### 3. 怎么实现单例模式？

**要点**
> 如何在项目中创建唯一的对象实例！！！
- 构造方法设置为 private，禁止外部随意 new 构造一个对象
- 提供一个全局的 static 静态变量来存储当前的对象
- 提供一个全局的 static function 来获取和自动实例当前类的操作


##### 懒汉单例模式
##### 恶汉单例模式


#### 4. 什么时候应该使用单例模式？使用单例模式的优缺点？


-----------
### 注册树模式

#### 1. 什么是注册树模式？

#### 2. 为什么要用注册树模式？

#### 3. 怎么实现注册树模式？

**要点**
> 统一对象的实例化，方便管理！！！例如：对于框架的底层基础类库，在“很多”的业务层、模块使用到类库，若在不同的地方都各自去实例化，对于使用到的类会非常“零乱”
- 通过将对象实例注册到一颗全局的对象树上
- 需要的时候从对象树上直接采摘下来使用


#### 4. 什么时候应该使用注册树模式？使用注册树模式的优缺点？


-----------

### 依赖注入与控制反转

**依赖注入-demo：**
- 理解依赖注入与控制反转 ：https://learnku.com/laravel/t/2104/understanding-dependency-injection-and-inversion-of-control
- 依赖注入、控制反转、反射各个概念的理解和使用：https://xueyuanjun.com/post/9782.html
- 依赖注入、控制反转：https://blog.csdn.net/bestone0213/article/details/47424255
- PHP进阶学习之依赖注入与Ioc容器详解:https://www.jb51.net/article/163391.htm
    > **依赖注入-demo：**
    > - https://github.com/doctrine/cache
    > - https://github.com/doctrine/orm

**什么是依赖注入？**


**为什么使用依赖注入？**
- 减少代码之间的耦合
- 有效分离对象和它所需的外部资源


**如何实现依赖注入？**
- 构造方法注入
- set 属性注入
- 静态工厂方法注入

**什么时候应该使用依赖注入？**




### PHP 反射机制
> 在 PHP 5.0 及以上版本引入的，提供了强大的 API 方便在 PHP 运行环境中使用 **“类”** 的属性、方法、参数、注释等信息，常用于：自动加载插件、自动生成文档等功能


### Container 容器类剖析
- Container 容器类
- 助手函数：helper\app
 


## 第5章：框架执行流程以及路由解读