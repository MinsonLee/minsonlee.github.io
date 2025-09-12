---
layout: post
title: Laravel ORM 中的钩子方法和自定义Builder
date: 2022-08-30
tags: [PHP,Laravel]
---

# Laravel ORM 中的钩子方法和自定义Builder


> 文章最后修改于：2025-09-08。完善了 `boot` 实践案例，增加了命名思考

`Laravel` 中使用 `Eloquent`（一个 `ActiveRecord ORM` 脚手架） 让用户用面向对象可编程的方式跟数据库进行交互，从而：让用户专注于数据逻辑的编写，避免写繁琐的 SQL 语句和关注 SQL 注入安全等问题。

> [Why ORM ? 为什么不直接写 SQL？](https://blog.csdn.net/u012955829/article/details/142289384)、[Should I Or Should I Not Use ORM ? ](https://medium.com/@mithunsasidharan/should-i-or-should-i-not-use-orm-4c3742a639ce)
>
> *   解耦应用程序和特定数据库的依赖：直接编写`SQL`会使应用代码与特定的数据库系统紧密耦合，难以切换到其他数据库。但这个考虑...感觉是比较小概率的，因为大部分情况下我们的项目确定后是不会变动“数据库”的，而且变换之后，应用代码上依然存在少量变更
> *   安全性问题：直接拼接 SQL 容易导致 SQL 注入攻击，ORM 框架多采用 SQL 预编译的方式已经内置处理这些安全问题
> *   代码简洁性、可读性、可维护性：将数据库表抽离映射为模型，更加直观，开发人员不必依赖数据库的权限

## 模型中的钩子：`booting/boot/booted` 以及 内置全局钩子

`Laravel` 中 `ORM` 模型都继承 `\Illuminate\Database\Eloquent\Model` 类，而在构造方法中调用了一个 `bootIfNotBooted()` 方法，如下：

```php
<?php

namespace Illuminate\Database\Eloquent;

....

abstract class Model implements ArrayAccess, Arrayable, Jsonable, JsonSerializable, QueueableEntity, UrlRoutable
{
    // 组合复用 Trait
    use Concerns\HasAttributes,
            Concerns\HasEvents,
            Concerns\HasGlobalScopes,
            Concerns\HasRelationships,
            Concerns\HasTimestamps,
            Concerns\HidesAttributes,
            Concerns\GuardsAttributes,
            ForwardsCalls;
    
    ....
    
    public function __construct(array $attributes = [])
    {
        // 注册 boot 方法:一个模型类的 boot 方法只能被触发一次
        $this->bootIfNotBooted();
        // 对象级别的触发 bootTraits() 注册的全局钩子函数，即：每次新 new 对象都会被触发
        $this->initializeTraits();
        ...
    }

    protected function bootIfNotBooted()
    {
        if (! isset(static::$booted[static::class])) {
            static::$booted[static::class] = true;
            // 在模型 boot 方法执行前触发，适合放一些前置准备工作
            $this->fireModelEvent('booting', false);
            // 模型「类级别」第一次被加载时调用
            static::boot();
            // `boot()` 后指定，适合放一些「收尾逻辑，如：数据库新增/更新后促发缓存删除」
            $this->fireModelEvent('booted', false);
        }
    }
    
    protected static function boot()
    {
        // 可以去看看 Model.php 内的 bootTraits() 方法
        static::bootTraits();
    }
}
```
### 理解 `booting/boot/booted` 注册与触发

从 `bootIfNotBooted()` 方法内部可以看出：**`booting -> boot -> booted` 方法在自身模型生命周期内都只会被依次触发一次**。

但是，我们可以通过调用 `Model` 类中引入的 `Trait`（`\Illuminate\Database\Eloquent\Concerns\HasGlobalScopes`） 的 「**`self::addGlobalScope($scope, Closure $implementation = null)` 方法可以为当前生命周期内的模型注入一个全局作用域的方法，从而打破 `booting/boot/booted` 钩子方法只触发一次所带来的局限」**。

具体的流程，看下方结选的关键代码：

1、注册全局钩子：`\Illuminate\Database\Eloquent\Concerns\HasGlobalScopes` 中的 `addGlobalScope` 方法负责注册全局的 `Scope` 方法

```php
public static function addGlobalScope($scope, Closure $implementation = null)
{
    if (is_string($scope) && ! is_null($implementation)) {
        return static::$globalScopes[static::class][$scope] = $implementation;
    } elseif ($scope instanceof Closure) {
        return static::$globalScopes[static::class][spl_object_hash($scope)] = $scope;
    } elseif ($scope instanceof Scope) {
        return static::$globalScopes[static::class][get_class($scope)] = $scope;
    }

    throw new InvalidArgumentException('Global scope must be an instance of Closure or Scope.');
}
```

2、全局钩子触发：`Model.php` 中底层的 `newQuery()`在创建模型对象后，按注册顺序依次遍历触发自身模型的全局 `Scopes`

```
public function newQuery()
{
    $builder = $this->newQueryWithoutScopes();
    
    // 这里会从全局作用域的 `Scopes` 中获取当前模型的 `Scope`，然后一一触发
    foreach ($this->getGlobalScopes() as $identifier => $scope) {
        $builder->withGlobalScope($identifier, $scope);
    }

    return $builder;
}
```

通过 `booting->boot->booted` 是依次触发的来保证了最终的全局钩子的触发顺序。

### 理解内置钩子注册与触发

仔细看 `Model.php` 内部的 `boot()` 方法，看到它只是做了一个简单的 `self::bootTraits()` 调用，而 `Laravel ORM` 的内置钩子的注册就是在 `bootTraits()` 完成的。

深入代码细节，注意：`bootTraits` 中的 `foreach` 逻辑

```php
protected static function bootTraits()
{
    $class = static::class;

    $booted = [];

    static::$traitInitializers[$class] = [];
    
    foreach (class_uses_recursive($class) as $trait) {
        $method = 'boot'.class_basename($trait);
        // boot{Trait} 的钩子是静态调用触发的，而且同一模型的静态调用只会触发 1 次
        if (method_exists($class, $method) && ! in_array($method, $booted)) {
            forward_static_call([$class, $method]);

            $booted[] = $method;
        }

        // initialize{Trait} 钩子被注册到全局的 $traitInitializers 钩子中，是跟随 `initializeTraits` 方法对象级别触发的
        if (method_exists($class, $method = 'initialize'.class_basename($trait))) {
            static::$traitInitializers[$class][] = $method;

            static::$traitInitializers[$class] = array_unique(
                static::$traitInitializers[$class]
            );
        }
    }
}
```

在该函数的调用细节中，会发现框架自身其实已经在 `Model` 基类完成了以下两个动作：

1、**将`'boot'.class_basename($trait)` 钩子通过静态调用 `forward_static_call([$class, $method]);` 触发了**，且 `! in_array($method, $booted)` 保证了该静态调用只会触发一次
2、**将`'initialize'.class_basename($trait)` 方式命名的钩子方法注册到了全局 `static::$traitInitializers` 中**
3、在`Model`的构造方法中调用 `initializeTraits()`，实现对象级别的触发`static::$traitInitializers`

```php
protected function initializeTraits()
{
    // 依次遍历 Trait 钩子
    foreach (static::$traitInitializers[static::class] as $method) {
        $this->{$method}();
    }
}
```

> ⚠️注意：`boot{Trait}` 是静态调用，因此在重写 `boot{Trait}` 方法时要命名为 `static` 静态方法；而 `initialize{Trait}` 是对象实例来动态调用的。

## `booting/boot/booted` 实践

理解了上述涉及的模型钩子知识，我们在 `Laravel` 中就可以将自己想 `hook` 的功能来放到不同的命名钩子方法中进行处理，写出更加优雅的代码。

全局的 `traitInitializers` 钩子 和 `Trait Boot` 钩子，可以自行去尝试，下方实践着重 `booting/boot/booted` 注册全局钩子来解决问题。

`booting/boot/booted` 实际都只在第一个“类对象”创建时，静态调用触发一次，但结合 `addGlobalScope` 将钩子注册为全局的，则可以打破这一局限。

### `booting` 实践

**`booting()` 前置钩子**，适合做一些「前置准备工作」，通过一个具体的案例：对上层代码屏蔽数据库的动态分表问题。

详细看：[Laravel ORM 分表查询](https://minsonlee.github.io/2022/08/laravel-orm-with-sharding)

### `boot` 实践

**因为框架底层的 `Model` 源码本身的 `boot()` 方法是包含一定其他启动逻辑的，所以“通常不建议”在重写的 `boot()` 中加入过多复杂逻辑代码**。

详细案例实践：最近发现 `MySQL` 服务资源占用飙升，拉了一下慢查询日志。发现是有一条 `SQL` 导致的：

```sql
SELECT * FROM `order_tbl` where order_id = 1234567890 LIMIT 1;
```

此处 `order_id` 应该是字符串类型，但是传了 `integer` 类型，导致没有命中索引扫描了全表。如果使用 `boot` 拦截 `where`，然后将对应的参数绑定值强转为 `string` 类型，那么问题就能得到解决，且上层代码不需要做改动。

`boot` + `addGlobalScope` 的实现方式如下：

```php
<?php
namespace ERC\xxx\xxxDb;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class Order extends Model 
{
    // ...其它属性和其它代码逻辑
    
    public static function boot()
    {
        parent::boot();
        self::addGlobalScope('order_id_to_string', function (Builder $builder) {
            $whereBindingsIndex = 0;
            foreach ($builder->getQuery()->wheres as $where) {
                if (isset($where['column']) && $where['column'] === 'order_id') {
                    // 等值查询
                    if (isset($where['value'])) {
                        $builder->getQuery()->bindings['where'][$whereBindingsIndex] = (string)$where['value'];
                        $whereBindingsIndex++;
                    }
                    // in 查询、not in 查询拦截
                    if (isset($where['values'])) {
                        foreach ($where['values'] as $v) {
                            $builder->getQuery()->bindings['where'][$whereBindingsIndex] = (string)$v;
                            $whereBindingsIndex++;
                        }
                    }
                } else {
                    if (isset($where['value'])) {
                        $whereBindingsIndex++;
                    } elseif (isset($where['values'])) {
                        $whereBindingsIndex = $whereBindingsIndex + count($where['values']) - 1;
                    }
                }
            }
        });
    }
}
```

经过测试，这已经能拦截 `where order_id = 123` 或 `where order_id in (123, 456)` 这类条件查询。但对于 `where('xxx','xx', 'xxx')->orWhere(function ($query) {})` 复杂的 `where xxxx or (order_id xxx)` 的 `SQL` 条件拦截是失败的。


### `booted` 实践

案例代码来源于《[Using the booted Method in Laravel Eloquent Models for CRUD Event Listening and Cache Resetting - DEV Community](https://dev.to/junaidjaved248/using-the-booted-method-in-laravel-eloquent-models-for-crud-event-listening-and-cache-resetting-4519)》，实现了 `User` 表新增、更新表数据后，根据 `id` 删除对应的用户缓存：

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;

class User extends Model
{
    protected static function booted()
    {
        
        $forgetUserCache = function ($user) {
            Cache::forget('user_' . $user->id);
        };
        // 调用 `creating` 注册一个模型事件监听，事件触发为 $forgetUserCache
        static::creating($forgetUserCache);
        // 调用 `updating` 注册一个模型事件，事件触发为 $forgetUserCache
        static::updating($forgetUserCache);
    }
}
```

以上述代码中的 `static::creating($forgetUserCache)` 为例：

1. 调用 `static::creating($forgetUserCache)` 时候会触发 「**`registerModelEvent('creating', $callback)` 注册模型监听事件**」
2. 不管是 `Builder::create()`、`Builder::updateOrCreate`、`Builder::firstOrCreate` 都是调用会 `Model::save` 方法
3. 最后，在模型基类 `Model.php` 文件的 `save()` 方法中，则通过调用 `performUpdate($query)/performInsert($query)` 方法，最终通过 「**`fireModelEvent(xxx)` 触发模型事件执行**」完成整个事件的闭环

更多的内置模型事件，可以看 `Illuminate\Database\Eloquent\Concerns\HasEvents::getObservableEvents` 代码

```php
public function getObservableEvents()
{
    return array_merge(
        [
            'retrieved', 'creating', 'created', 'updating', 'updated',
            'saving', 'saved', 'restoring', 'restored', 'replicating',
            'deleting', 'deleted', 'forceDeleted',
        ],
        $this->observables
    );
}
```

- 内置事件命名规则：`eloquent.{$event,如：retrieved}: static::class`
- `retrieved` - 数据库完成连接，准备进行数据检索时触发
- `creating`  - 数据库执行 `insert` 操作前
- `created`   - 数据库执行 `insert` 操作后
- `updating`  - 数据库执行 `update` 操作前
- `updated`   - 数据库执行 `update` 操作后
- `saving`    - 模型的 `save` 方法调用前（即：数据库 `insert/update` 操作前都会调用）
- `saved`     - 模型的 `save` 方法调用后（即：数据库 `insert/update` 操作后都会调用）
- `restoring` - 恢复软删除一条数据之前被调用（即：数据库 `update` 软删除字段之前调用），调用的是 `save()` 方法
- `restored`  - 恢复软删除一条数据之后被调用（即：数据库 `update` 软删除字段之后调用），调用的是 `save()` 方法
- `deleting`  - 数据库执行 `delete` 操作前（调用模型的 `delete` 方法）
- `deleted`   - 数据库执行 `delete` 操作后（调用模型的 `delete` 方法）
- `forceDeleted` - 将软删除表中的数据强制删除，调用模型的 `delete` 方法后被调用
- `replicate` - 复制一个模型数据完成后被调用



当然，上述案例的回调只是非常简单的“删除用户缓存”，所以直接写在了 `booted` 中，但实际生产中的场景会更加复杂。

依然以「注册一个新用户」为例，注册完成后要操作的可能会涉及很多，如：自动发送欢迎邮件、自动初始化用户积分任务、自动发放新人优惠券...等等。如果将这些都写到 `booted` 中，那么用户模型则会堆满了复杂的宏代码

复杂的触发逻辑，则更推荐使用「事件模型」，如：给 `User` 模型注册一个事件观察器（`Observer`），将复杂的宏操作从 `boot` 中分离，这样代码的可维护性和可扩展性会更加好。

但是，底层都是 `Illuminate\Database\Eloquent\Concerns\HasEvents` 中的 `registerModelEvent` 和 `fireModelEvent` 函数。

## 自定义 `Builder`

在上面 `boot` 实践中，用了例子「拦截 `Order` 模型中对的 `order_id` 属性字段值的强转 `string` 类型」，但最终通过在 `boot` 中注入一个宏方法来拦截，这样的实现是拦截不全的，如下：

```php
DB::enableQueryLog();

Order::whereIn('order_id', [123, 456, 789])->orWhere(function ($query) {
    return $query->where('order_id', '=', 110);
})->get(['id', 'order_id']);

echo '<pre>';
var_export(DB::getQueryLog());
```

最终打印结果：

```php
array (
  0 => 
  array (
    'query' => 'select `id`, `order_id` from `xxx_db`.`order_tbl` where `order_id` in (?, ?, ?) or (`order_id` = ?)',
    'bindings' => 
    array (
      0 => '123',
      1 => '456',
      2 => '789',
      3 => 110,
    ),
    'time' => 89.45,
  ),
)
```

这样的实现方式缺点明显：

1.  可维护性差：代码逻辑复杂，若需要做其他的拦截操作，那么 `boot` 方法也会非常臃肿，代码变得难以维护
2.  代码复用性差：如果其他模型也需要对 `order_id` 拦截，那么代码不具备复用性
3.  代码逻辑复杂：上面问题已经暴露，不能做到全部拦截，若要完全拦截需要编写复杂的条件分支判断处理各类情况

想要全面拦截，那使用「**自定义`Builder`**」来实现是一个更好的方式。

从 `Model` 基类的源码会发现，`ORM` 模型的创建都会通过 `new Query()` 方法创建模型，而在 `new Query()` 的调用底层中又是通过 `newEloquentBuilder(\Illuminate\Database\Query\Builder $query)` 方法进行创建，并返回一个 `\Illuminate\Database\Query\Builder` 类的对象：

```
<?php
namespace Illuminate\Database\Eloquent;


/**
 * @mixin \Illuminate\Database\Eloquent\Builder
 * @mixin \Illuminate\Database\Query\Builder
 */
abstract class Model implements ArrayAccess, Arrayable, Jsonable, JsonSerializable, QueueableEntity, UrlRoutable
{
    /**
     * Create a new Eloquent query builder for the model.
     *
     * @param  \Illuminate\Database\Query\Builder  $query
     * @return \Illuminate\Database\Eloquent\Builder|static
     */
    public function newEloquentBuilder($query)
    {
        return new Builder($query);
    }
}
```

点进 `\Illuminate\Database\Query\Builder` 类就可以看到，日常调用的 `Where/WhereIn/first/get/crate/update/delete` 这些方法就是定义在这里面。

OK，了解到这里就清楚了：「**自定义`Builder`**」就是根据面向对象中**子类实例化父类「即：子类对象当作父类对象来使用」：定义一个子类继承相关父类，重写父类的方法从而达到“类的多态”的目的**。

那么针对我们想全局拦截 `order_id` 的`where` 条件问题，我们就可以：

1、自定义 `Builder` 子类 `OrderBuilder` 并重写 `where`、`whereIn` 方法，在重写的方法中拦截 `order_id` 字段

```php
class OrderBuilder extends \Illuminate\Database\Eloquent\Builder {
    public function where($column, $operator = null, $value = null, $boolean = 'and')
    {
        if ($column === 'order_id') {
            $value = (string)$value;
        }
        return parent::where($column, $operator, $value, $boolean);
    }

    public function whereIn($column, $values, $boolean = 'and', $not = false)
    {
        if ($column === 'order_id') {
            foreach ($values as $key => $value) {
                $values[$key] = (string)$value;
            }
        }
        return parent::whereIn($column, $values, $boolean, $not);
    }
}
```

2、定义 `BaseOrderModel` 模型类，并重写父类的 `newEloquentBuilder` 方法

```php
class BaseOrderModel extends \Illuminate\Database\Eloquent\Model
{
    public function newEloquentBuilder($query) 
    {
        return new OrderBuilder($query);
    }
}
```

3、更改继承关系 `class Order extends BaseOrderModel`

这样改造后，`Order` 模型的 `where/orWhere/whereIn/whereNotIn` 方法，只要带了 `order_id` 字段都可以被强转为 `string` 类型。

相比于「`boot` + `addGlobalScope`」的实现，自定义 `Builder` 方式优点明显：

1.  可读性：代码简洁易懂
2.  解耦：对应逻辑放在 `Builder`，而不是在 `boot()` 里写复杂宏
3.  可复用：其他订单模型也能继承该 `Builder`
4.  扩展性：可以继续扩展 `Builder` 类的方法，譬如：`byOrderId($id)` 统一控制 `order_id` 的查询，方法自动实现追加条件 `where('order_id', '=', (string)$id)`


## 关于初始函数的命名思考

我们经常会用 `boot/init/load/ready` 这类单词前缀或后缀来命名一些“初始”函数，根据这些单词最基础的语义来思考到底一个“初始功能”应该叫什么名字？

术语 | 核心语义 | 功能侧重 | 作用层级 | 比喻
-----|----------|----------|----------|------
`boot` | 从无到有的启动 | 建立最低运行环境基础 | 系统级、应用级、类级别 | 回到家打开电源开关总闸
`init` | 使...进入初始化状态 | 准备工作，达到一个标准状态 | 对象级、模块级 | 插上电源、找到遥控、开机
`load` | 从外部获取载入数据 | 读取数据，完成加载工作 | 数据级、资源级 | 找到要看的影视频道
`ready` | 准备完成的信号 | 通知外界一切就绪 | 事件级、状态级 | 按下播放键，宣布开始观看


### `boot` 或 `bootstrap` - 「引导」

在计算机行业中，`boot` 的引导更多是“引导程序”的意思，是一种「**自我启动**」程序的意义。

通常是作为「**方法命名前缀**」来定义一些「**系统级、应用级、类级别**」的方法，在**一个生命周期里通常只调用一次**。功能侧重如下：

- 设置最核心、全局性的环境（如环境变量、全局配置）
- 启动核心服务（如日志服务、全局错误处理、依赖注入容器）、加载并运行应用程序入口
- 加载并运行应用程序的入口点

### `initialize` 或 `init` - 「初始化」

`initialize` 或 `init` 最常见的意思就是：**使...进入初始状态**。

通常也是作为「**方法命名前缀**」来定义一些为具体「**对象级别**」方法，**`init` 比 `boot` 的粒度更细小，生命周期应该要跟构造函数是一致的**。功能侧重如下：

- 常用于为「对象、模块、组件」设置一个**稳定、可用、默认**的初始状态（如：设置实例成员变量的默认值、模块的局部变量、数据结构等）
- 绑定对象的内部事件...等等

### `load` - 「加载、载入」

`load` 的含义非常直白，就是「**装载、载入**」的意思。

通常也是作为「**方法命名前缀**」，来定义一些「**从外部获取数据或资源，并注入到当前对象/模块/组件中**」的功能方法。

`loadXXX` 方法的定义一般是「**数据级、资源级**」的，通常应该在 `initialize` 中或 `initialize` 之后被调用，因为我们通常都是需要初始化一个对象了，才能往对象里面“装载、载入”数据。功能侧重如下：

- 读取配置文件
- 从数据库或 API 接口获取数据
- 预加载数据资源，如：图片、音频、语言包等


### `ready` - 「就绪」

`ready` 是一个形容词，表示「**事物处于准备好**」的状态。

在计算机中，通常作为「**一个事件、回调函数名、状态标识**的**命名后缀**」出现。`ready` 更多是一个“就绪信号”，标志着某个（通常是“异步”的）事物的准备工作**已经全部完成**，可以安全地对其**进行其他操作**了。

因此，`xxxReady` 方法的定义一般是「**事件级、状态级**」的，通常是标识 `boot/init/load` 都完成了，准备通知做其他事情。功能侧重如下：

- 不是一个主动执行准备工作的函数，而是**准备工作完成后的通知机制**触发
- 常常用在**事件监听**中，如：`onReady`、`document.ready`
- 表示一个异步的 `boot/init/load` 已经结束
