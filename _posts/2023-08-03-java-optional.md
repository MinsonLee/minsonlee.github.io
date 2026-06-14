---
layout: post
title: "Java 中如何告别面条式的 null 判断”"
date: 2023-08-03
tags: [java]
---

# Java 中如何告别面条式的 null 判断

[TOC]

## 背景

最近在写 `Java`，其中 `MongoDB` 中存了某个文档数据，「**如果存在**」结构是如下这样：

```json
{
    "localtion":{
        "pickup":{
            "region":{
                "region_en":"China"
            }
        }
    }
}
```

现在需要判断如果 `region_en` 有值就拿出来，在 `PHP` 中用 `empty()` 函数处理即可：

```php
$regionEn = '';
if(!empty($carDetail['location']['pickup']['region']['rengion_en'])) {
    $regionEn = $carDetail['location']['pickup']['region']['rengion_en'];
}
```

由于刚开始写 `Java` 时没有留意，写 `carDetail.getLocation().getPickup().getRegion().getRegionEn()` 经常会报 `NullPointExceptions`（很多`Java`文章会称其为`NPE`）.

改为：

```java
String regionEn = "";
if(
    carDetail != null 
    && carDetail.getLocation() != null 
    && carDetail.getLocation().getPickup() != null 
    && carDetail.getLocation().getPickup().getRegion().getRegionEn() != null
) {
    regionEn = carDetail.getLocation().getPickup().getRegion().getRegionEn();
}
```

或者有其他逻辑需要处理那么可能是此类嵌套判断 `NPE` 的情况：

```java
String regionEn = "";
if(carDetail != null) {
    // 其他逻辑
    if(carDetail.getLocation() != null) {
        // 其他逻辑
        if(carDetail.getLocation().getPickup() != null) {
            // 其他逻辑
            regionEn = carDetail.getLocation().getPickup().getRegion().getRegionEn() != null 
                ? carDetail.getLocation().getPickup().getRegion().getRegionEn() 
                : "";
        }
    }
}
```

在 `Java8` 中引入 [`java.util.Optional` 工具类](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html) 可以相对简洁的处理这种「面条式“if-else if”」的 `null` 判断代码。

```java
String regionEn = Optional.ofNullable(carDetail)
    .map(c -> c.getLocation())
    .map(l -> l.getPickup())
    .map(p -> p.getRegionEn())
    .orElse("else");
```




## `Optional` 类源码简读

- [Java 8 `java.util.Optional` 工具类文档](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html)
- [Java 20 `java.util.Optional` 工具类文档](https://docs.oracle.com/en/java/javase/20/docs/api/java.base/java/util/Optional.html)
- [源码：src/java.base/share/classes/java/util/Optional.java](https://github.com/openjdk/jdk/blob/d60352e26fd8b7e51eeaf299e3f88783b739b02a/src/java.base/share/classes/java/util/Optional.java)
- [Java 8新特性（三）：Optional类](https://lw900925.github.io/java/java8-optional.html)
- [Optional类与使用==判断null有什么区别？使用Optional类有什么优势？](https://www.cnblogs.com/datamining-bio/p/13831000.html)



`Optional` 主要是用于避免空指针异常（`NullPointerException`）的一个工具类（可看做是类似一种“语法糖”），可以通过链式调用的方式进行管道处理数据。

通过 IDEA 简单的浏览一下源码的 `Structure`，该类比较简单：

1. `@jdk.internal.ValueBased` 标注了这是一个[ `value-based` 类，即：基于值的类](https://docs.oracle.com/javase/8/docs/api/java/lang/doc-files/ValueBased.html)
    - 什么是基于值的？只要“值”相同，这两个对象就应该被视为完全相同的对象
    - 注意事项是什么？不应该使用引用相等（如：`==` 操作符）去判断基于值的对象是否相等，而是使用 `equals()` 方法
    - https://matthung0807.blogspot.com/2019/05/java-value-based-classes.html
2. 该类有两个私有属性
    - 空 Optinal 类对象：`private static final Optional<?> EMPTY = new Optional<>(null)`
    - 泛型 T 的 value 对象：`private final T value`
3. 该类构造方法是私有的，不能直接实例化
4. **注意：`Optional` 并非解决繁杂的 `if-else if`，而是为了避免用 `if-else if` 的进行 `null` 空指针异常判断而诞生的！！！**




### 1、获取 `Optional` 对象

1. 获取一定不为空的 `Optional<T>` 对象：`Optional.of(T value)`，表示 `value` 一定为非空的，如果为 `null` 会抛出 `NullPointerException` 异常
2. 获取空的 `Optional<T>` 对象：`Optional.empty()`，返回 `(Optional<T>) new Optional<>()` 对象**「这个空 Optional 对象的意义是什么呢？？」**
3. 获取可能不为空的 `Optional<T>` 对象：`Optional.ofNullable(T value)`，其实就是 `return value == null ? Optional.empty() : Optional.of(value)`

### 2、过滤、转换数据的方法

```伪代码
if (value != null) {
	// true 处理逻辑
} else {
	// false 处理逻辑
}
```

- `filter(Predicate<? super T> predicate)` : 如果 `value!=null` 或者 `predicate.test(value)` 结果为 true 返回自身，否则返回 `Optional.empty`
- `ifPresent(Consumer<? super T> consumer)`：基于值 `null != null` 的情况执行`if` 逻辑
- `ifPresentOrElse(Consumer<? super T> consumer)` : Java 9 新增方法，基于值的 `null` 情况，处理 `if-else` 的情况
- `map(Function<? super T, ? extends U> mapper)` : 如果**当前对象的 value 值**存在则将 `mapper.apply()` 方法的结果包装为一个 `Optional` 对象返回，即：「Optional<Optional<U\>>」 对象
- `flatMap(Function<? super T, Optional<U>> mapper)` 当 `value != null` 时返回 `mapper.apply()` 结果「Optional<U\>」对象。否则返回 `Optional.empty()`
- `or(Supplier<? extends Optional<? extends T>> supplier)` ： Java 9 新增方法，如果 `value` 为 `null` 则返回 `(Optional<T>) supplier.get()`
- `stream()`：Java 9 新增方法，返回一个 `Stream<T>` 流对象

**！！！注意：**

1. `Predicate`、`Consumer`、`Consumer`、`Function` 都是函数式接口，其中只有 1 个方法，因此可以用 `Lambda` 表达式来匿名实现
2. **这些过滤、转换方法，传入参数是 `@FunctionalInterface` 的匿名函数式接口实现，如果传 `null` 都会报异常**
3. **map、flatMap 两个方法是有差异的**


### 3、获取 `Optional` 的值

- `get()` : 获取 `value` 值，如果 `value` 为 `null` 则抛出 `NoSuchElementException` 异常，因此使用的时候需要确定对象的 `value` 是否确实有值
- `orElse(T other)` : 如果 `value` 不为 `null` 则返回 `value`，否则返回 `other`「PHP 中的三元运算符 `a ?: b`，若 a true 则返回 a，否则返回 b」
- `orElseGet(Supplier<? extends T> other)` : 如果 `value` 为 `null` 则调用实现了 `Supplier Interface`  的 `other.get()` 方法返回的默认内容
- `orElseThrow(Supplier<? extends X> exceptionSupplier)` : 如果值为 `null` 则 `throw exceptionSupplier.get()`  （自定义异常的 Message 信息）
- `toString()` : 适合记录 log 的时候，返回字符串`String.format("Optional[%s]", value)` 或 字符串 `Optional.empty`
- `hashCode()` : 返回 `value` 值的 `HashCode`，如果值为 `null` 则返回 `0`
- `orElseThrow()` : `Java 10` 新增的方法，如果值为 `null` 抛出 ` NoSuchElementException("No value present")` 异常（难道官方发现大家都抛出类似的信息，为了方便所以直接加了一个这样的方法？？）

### 4、`value` 判断方法

- `isPresent()` : 判断 `value != null` 则返回 `true`
- `equals()` : 判断两个`Optional`对象的值是否相等
- `isEmpty()` : `Java 11` 添加的方法，用于判断 `Value` 是否为 `null`

## 疑问

### 1、为什么要有 `Optional.empty()` 返回一个空 Optional 对象??

看到很多示例对 `Optional.empty()` 的解释都是一笔带过，因为理论上我们应该不需要主动的获取一个空对象呀...很纳闷为啥要有这么一个空对象呢？什么场景会用到呢？

`Optional.empty()` 生成一个没有包含任何值的 `Optional` 对象，当期望某个方法可能不会返回结果时，你可以返回 `Optional.empty()`，而不是返回 `null`。这样的话，调用者可以使用 `Optional` 的方法（如 `isPresent()` 或 `ifPresent()`）来处理可能的空值，而不必进行显式的 `null` 检查。

例如，考虑一个方法，可能找不到期望的数据并返回 `null`：

```java
public User findUserByName(String name) {
    // 如果找不到用户，返回 null
}
```

现在改用 `Optional`：

```java
public Optional<User> findUserByName(String name) {
    // 如果找不到用户，返回 Optional.empty()
}
```

对于调用者来说，处理方法如下：

```java
Optional<User> optionalUser = findUserByName("test");
if (optionalUser.isPresent()) {
    User user = optionalUser.get();
    // 执行其他操作
} else {
    // 用户不存在的情况下的处理
}
```

但是这种方法和直接使用 `if( user != null) {} else {}` 没有什么区别呀...

但如果配上 `ifPresent()` 更简洁的方式：

```java
findUserByName("test").ifPresent(user -> {
    // 执行其他操作
});
```

似乎稍微有一些看头，让代码段可以更加集中于“逻辑的提现”，而避免了很多面条式的 `if-else` 堆积。

但上面的代码，`else` 的逻辑会丢失。因此在 `Java 9` 中新增了 `ifPresentOrElse()` 方法：

```java
findUserByName("test").ifPresentOrElse(
    user -> {
        // 执行存在用户时的操作
    },
    () -> {
        // 执行用户不存在时的操作，else 的逻辑
    }
);
```

### 2、`map()` 和 `flatMap()` 的区别？

由于刚开始接触 Java，对泛型了解不多，因此被我忽略的点在于：`map(Function<? super T, ? extends U> mapper)` 和 `flatMap(Function<? super T, Optional<U>> mapper)` 的参数 `mapper` 的类型。

两个函数的源码如下：

```java
public<U> Optional<U> map(Function<? super T, ? extends U> mapper) {
    Objects.requireNonNull(mapper);
    if (!isPresent())
        return empty();
    else {
        // 此处对 mapper.apply(value) 的结果再次进行了 Optional.ofNullable 的包装
        return Optional.ofNullable(mapper.apply(value));
    }
}

public<U> Optional<U> flatMap(Function<? super T, Optional<U>> mapper) {
    Objects.requireNonNull(mapper);
    if (!isPresent())
        return empty();
    else {
        // 直接返回了 mapper.apply(value) 的结果，只要结果不是 null 即可，否则会抛 NPE
        return Objects.requireNonNull(mapper.apply(value));
    }
}
```

- `Function<? super T, ? extends U> mapper` 表示 `mapper` 对象必须处理 T 类型，但接口是返回 U 类型
- `Function<? super T, Optional<U> mapper` 表示 `mapper` 对象必须处理 T 类型，但接口是返回 `Optional<U>` 类型
- `map()` 和 `flatMap()` 都是要接收一个「实现了 `Fuction` 函数式接口的对象」的形参


依然通过 `CarDetail` 写一个 `Demo`：

```java
package optional;
import java.util.Optional;
public class DemoOptional {
    public static void main(String[] args) {
        CarDetail carDetail = null;
        String regionEn = Optional.ofNullable(carDetail)
            .flatMap(CarDetail::getLocation) // 此处用的是：flatMap()，`CarDetail.location` 是 `Optional<T>`
            // .map(x -> x.orElse(new Location()).getPickup()) // 如果 flatMap() 想用 map() 代替
            .map(Location::getPickup) // 此处用的是：`map()`，`Location.pickup` 是一个 `Region` 实体
            .map(Region::getRegionEn)
            .orElse("else");
        System.out.println(regionEn);
    }

    public static class CarDetail {
        private Optional<Location> location;
        public Optional<Location> getLocation() {return location;}
        public CarDetail setLocation(Location location) {this.location = Optional.ofNullable(location); return this;}
    }

    public static class Location {
        private Region pickup;
        public Region getPickup() {return pickup;}
        public Location setPickup(Region pickup) {this.pickup = pickup;return this;}
    }

    public static class Region {
        private String regionEn;
        Region(String regionEn) {this.regionEn = regionEn;}
        public String getRegionEn() {return regionEn;}
    }
}
```

1. `Optional.ofNullable(carDetail)` 得到了一个 `Optional<CarDetail>` 的对象
2. 由于 `CarDetail.location` 本身已经是一个 `Optional<Location>` 对象
3. 因此 `Optional.ofNullable(carDetail).map(CarDetail::getLocation)` 得到的将是一个 `Optional.ofNullable(CarDetail::getLocation)` 的对象
3. 而 `Optional.ofNullable(carDetail).flapMap(CarDetail::getLocation)` 得到的将是一个 `CarDetail::getLocation` 对象 


`Java` 是希望对开发者屏蔽 「**指针**」这个复杂概念的，但是偏偏返回了 `null`...这是一个「空指针」，因此出现 `Optional` 类希望能用 `Optional.empty()` 来屏蔽返回真正 `null` 的情况。

所以当我们选择 `map() or flipMap()` 的时候，即：面临 **「“对象”嵌套“对象”」** 情况下的要看 **内部嵌套的这个对象是一个 `Optional<T>` 还是一个其他的实体对象？**


- [java中Optional的应用，以及map和flatMap的区别](https://blog.csdn.net/qq_35634181/article/details/101109300)
- [Optionalの应用 && flatMap和map的区别](https://segmentfault.com/a/1190000040491970)
- [告别丑陋判空，一个Optional类搞定](https://juejin.cn/post/7149345919077449764#heading-4)