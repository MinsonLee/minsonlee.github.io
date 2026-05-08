- 主流缓存框架调研 - Guava/Caffeine/EhCache/JetCache ： https://www.cnblogs.com/imyjy/p/15695160.html
- JetCache 缓存框架的使用以及源码分析 https://www.cnblogs.com/lifullmoon/p/13854158.html
- JetCache 缓存开源组件设计精要 https://xie.infoq.cn/article/cac316dcf2db8cc3d029c1065
- 阿里巴巴Jetcache配置详解 https://blog.csdn.net/HXNLYW/article/details/88025350
- 架构之高并发：缓存 https://pdai.tech/md/arch/arch-y-cache.html
- Redisson基本用法 https://www.cnblogs.com/cjsblog/p/11273205.html
- https://juejin.cn/post/7064496903513178143
- https://ifeve.com/jetcache-quickstart/
- https://zhuanlan.zhihu.com/p/48515808
- https://www.cnblogs.com/lwh147/p/15176574.html
- 官方文档 ： https://github.com/alibaba/jetcache/tree/master/docs/CN
- [Jetcache踩坑合集_private void processcachemessage-CSDN博客](https://blog.csdn.net/baofeidyz/article/details/129810511)
- [JetCache 缓存框架的使用以及源码分析 - 月圆吖 - 博客园](https://www.cnblogs.com/lifullmoon/p/13854158.html)
- [缓存那些事 - 美团技术团队](https://tech.meituan.com/2017/03/17/cache-about.html)

-------


## 踩坑集合

### 1、2024-02-21jetcache 缓存设置了本地缓存或 BOTH，修改对象后导致本地缓存被覆盖

**背景：**

测试反馈测试环境车名一会儿日语，一会儿英语；线上是正常的。经过验证，复现步骤：访问英语站，车名文案正常，切换日语站之后，车名显示日语正常，当从日语站切换回到英语站...车名依然是日语，但过一段时间后刷新又恢复回了英文。

**排查：**

从表现上来看，很大概率应该是跟“数据缓存”有些关系...确定一下最后接口返回之前 setCarName 源代码进行追溯看看有没有地方加了缓存。

1. 锁定改动定然是测试环境代码变动导致，定位在了：同事使用 jetcache 缓存了获取车名的结果
2. 暂时去除了添加的缓存配置，发现问题得到了解决，那么可以肯定就是加了 jetcache 的原因导致

代码背景：有两个重载的方法 getCarNames，缓存是加在其中 1 个方法上的，另外一个方法实际是没有加。但是现在缓存中的值被覆盖了....


```java
@Override
@Cached(name = "CarDetailNames", expire = 1800, cacheType = CacheType.BOTH, key = "#stdCarName + '_' + #carName + '_' + #stdId")
public Map<String,String> getCarNames(String stdCarName, String carName, Integer stdId) {
    Map <String,String> names = new HashMap<>();
    names.put("car_name_en_fp","");
    names.put("car_name_fp",StringUtils.isNotEmpty(stdCarName) ? stdCarName : carName);

    //xxx
    
    return names;
}


@Override
public Map<String, String> getCarNames(String stdCarName, String carName, Integer stdId, String language) {
    Map<String, String> carNames = self.getCarNames(stdCarName, carName, stdId);
    if ("jp".equals(language) && StringUtils.isNotEmpty(carNames.get("car_name_fp"))) {
        carNames.put("car_name_fp", mls.getMultiLanguageContentByI18nKey(carNames.get("car_name_fp")));
    }
    return carNames;
}
```

- 猜测1：jetcache 的 bug：难道 jetcache 并不是用 [Java方法签名](https://cloud.tencent.com/developer/article/1787542) 来标识写缓存，而是单纯用方法名？？这个猜想想来不会这么低级...那谁敢用。而且，如果真是这样，那么当有了缓存后应该进不来没走缓存的那个方法，那么 99% 可能都要废弃掉这个想法的了
- 猜测2：jetcache 配置错误了（想来这个概率不应该呀，因为其他的地方都是这样配置）？？

先验证比较好确定的猜测 1：直接通过 Redis 捞出了对应的 key，发现此时 redis 里面的值其实是没有问题的。那么就是本地缓存有问题了。

那么大概率可以确定是：猜测 2 - `@Cached` 配置的不正确。唯一比较容易出问题就是 `cacheType` 的值上（`CacheType.LOCAL` 、 `CacheType.BOTH` 、 `CacheType.REMOTE`）

大概率猜测：本地缓存应该是将对象的引用地址存在内存中，需要使用本地缓存的时候直接获取。因此，当重新 `carNames.put("car_name_fp", mls.getMultiLanguageContentByI18nKey(carNames.get("car_name_fp")));` 的时候原来英文值被覆盖了。。。

**解决方案**

1. 业务上考虑：这个缓存是不是一定要加，能否去掉？？一定需要，单独调用没有问题，但是遇到列表页，当有上千个报价，会有较多车名重复，此时没有缓存会拖慢速度
2. 技术上考虑：
    1. 将 `cacheType` 设置为 `CacheType.REMOTE`：能解决问题，但是...列表页很多报价的时候，岂不总是要连 `Redis` 去查，过多的链接也会徒增消耗，属于下策
    2. 将 `getCarNames(String stdCarName, String carName, Integer stdId, String language)` 中的翻译逻辑放到上层去处理，这个理论上是更加合理的。但是该方法调用有点多，改动不是很方便
    3. 复写的时候，新建一个 Map 对象进行返回修改，而不是针对原对象进行操作...改动和测试成本是最小的

```java
@Override
public Map<String, String> getCarNames(String stdCarName, String carName, Integer stdId, String language) {
    Map<String, String> carNames = self.getCarNames(stdCarName, carName, stdId);
    // 新增 returnMap
    Map<String, String> returnMap = new HashMap<>(carNames);
    if ("jp".equals(language) && StringUtils.isNotEmpty(carNames.get("car_name_fp"))) {
        // 对 returnMap 进行修改
        returnMap.put("car_name_fp", mls.getMultiLanguageContentByI18nKey(carNames.get("car_name_fp")));
    }
    return returnMap;
}
```