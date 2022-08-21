---
layout: post
title: "Laravel ORM 分表查询"
date: 2022-08-21
tags: [PHP,Laravel]
---

## 背景

新接手一个“改造”酒店项目，需要3个月内和现有业务打通且完成前台的改造并上线。由于只是“试水”业务且唯一的要求就是“快”。所以就得尽量少改动，为了维持后台及各种配置的可用，表设计也不能更改。前台业务除了对接供应商搜索获取报价的部分代码可用，其余基本都要推倒，使用的是 PHP 开发，经过团队商议决定使用最新的 `Laravel 9.x` 版本进行前台 API 的开发。

在使用 Laravel 过程中我比较喜欢 ORM 中的 `with` 关联模型查询数据 ，而现有表结构中 `product` 表和 `product_img` 表呈现一对多的关系，**`product_img` 通过对 `product_id` 进行哈希取值进行了分表** 。

`分表` 意味着：1、用户使用 `in(xxx,xxx)` 查询时不能做到无感知；2、模型关联查询 `Product::with(['img'])->get()`、数据更新 `ProductImg::where('product_id', '=', xxx)->update([xxx])`  都需要动态的变更表而不能做到无感知。

**分库分表** 是一个很常规的操作，通常都是需要先通过 `setTable()` 的方式变更了对象的表名，才能继续进行操作。但是 `with()` 操作怎么自动根据结果进行变更呢？网上搜了一些 `Laravel 单库分表` 的案例，结果都不能实际使用，因此只能去翻一翻 Laravel 的文档和源码，此文是对 `Laravel ORM 单库分表查询` 的总结。

> 由于不涉及分库操作，没有进行这部分的改造，但 `Laravel` 官方文档说可以通过 `connection` 属性变更单表的连接对象，而且可以通过给 `$table` 属性设置前缀（即：库名），那么思路上应该是一致的，可自行操作一波试试。



我希望 `ProductImg`  的分表对于普遍简单的 `CURD` 操作来说是无感知的，即：开发可以正常的使用  `ProductImg::where('product_id', '=', $productId)->get();`、`Product::with('img')->where('product_id', '=', $productId)->get();` 而不用去理会底层的分表算法逻辑。



## 思路

不管是 `with()` 关联模型查询操作、还是普通的 `get()/first()` 查询、亦或是 `update()/save()/delete()` 操作，`Laravel ORM` 都需要基于`Illuminate\Database\Eloquent\Builder` 对象进行查询构建，因此我的思路是：在构建 `ProductImg Builder` 对象的时候在最开始能有一个拦截器，可以自动捕获 `where` 条件的属性，如果识别到 `where` 条件中 `product_id`字段，那么就自动的帮我修改设置 `table` 属性，然后再返回 `Builder` 对象。

翻看 ORM 章节的文档和源码，最终我找到两个关键点：


1. **[`查询作用域`](https://learnku.com/docs/laravel/9.x/eloquent/12251#858495)**：为模型的所有查询添加约束规则，这个约束规则就是一段代码，那么这段代码如果实现了修改 `$table` 属性就可以了。
2. `booting()`方法：在`laravel/framework/src/Illuminate/Database/Eloquent/Model.php`中提供了 `booting()/booted()`方法，可以在模型启动之前/启动之后分别执行相关操作。


那么组合在一起就是：在模型启动之前，执行一段代自动识别 where 条件中是否含 `product_id` 属性，然后自动修改即将启动的 `$table`属性，那么就能得到一个表名正确的对应分表模型。



## 代码案例

1、定义 `Product` 模型，并定义和 `ProductImg` 的关系映射

```php
<?php
/**
 * 酒店模型
 */
namespace App\Models\Hotel;

use App\Models\BaseModel;

class Product extends BaseModel
{
    /**
     * 酒店表
     * @var string
     */
    protected $table = 'mydb.product';

    /**
     * 主键
     * @var string
     */
    protected $primaryKey = 'product_id';
    protected $keyType = 'int'; // 主键属性
    public $incrementing = true; // 是否自增

     /**
     * 关联 ProductImg 模型
     * @return void
     */
    public function img() {
        return $this->hasMany(ProductImg::class, 'product_id', 'product_id');
    }
}
```



2、定义 `ProductImg` 模型

```php
<?php

namespace App\Models\Hotel;

use App\Models\BaseModel;
use Illuminate\Database\Eloquent\Builder;

class ProductImg extends BaseModel
{
    /**
     * 图片分表 mydb.product_img_xx_tbl
     * @var string
     */
    protected $table = 'mydb.product_img_00_tbl';
    private static $defaultTable = 'mydb.product_img_00_tbl';
    private static $tableTemplate = 'mydb.product_img_%02d_tbl';
    
    /**
     * 根据 productId 获取正确的分表名称
     * @param $productId
     * @return string
     */
    private static function getTableByProductId($productId) {
        $sharding = 0;
        if (!empty($productId) && is_numeric($productId)) {
            // 分表算法逻辑，此处使用最简单的 取模算法 做示范
            $sharding = ($productId % 10);
        }
        
        return sprintf(self::$tableTemplate, $sharding);
    }
    
    /**
     * @override
     * 模型的 booting 方法
     * 如果通过 where product_id = xxx 或 where product_id in ( 单独某一个product_id值 )，则拦截查询器自动处理分表问题
     * @return void
     */
    protected static function booting()
    {
        static::addGlobalScope('sharding', function (Builder $builder) {
            // 判断该字段是否需要拦截处理
             $isInterceptColumn = function ($string, $column) {
                 $columnWithTable = self::$defaultTable . '.' . $column;
                 return $string === $column || $string === $columnWithTable;
             };

            foreach ($builder->getQuery()->wheres as &$where) {
                // 判断有根据 product_id 对 in、= 两种方式查询进行拦截，设置分表
                if (isset($where['column']) && $isInterceptColumn($where['column'], 'product_id')) {
                    $productId = null;
                    
                    // 等值查询
                    if (isset($where['operator']) && $where['operator'] === '=') {
                        $productId = $where['value'];
                    }
                    
                    // in 查询
                    elseif (
                        isset($where['type']) && 
                        ($where['type'] === 'InRaw' || $where['type'] === 'In') && 
                        isset($where['values']) && count($where['values']) === 1
                    ) {
                        $productId = $where['values'][0];
                    }
					//dd([$where, $productId]);
                    // 设置分表信息
                    if (!is_null($productId)) {
                        $table = self::getTableByProductId($productId);
                        $builder->from($table);
                        $productIdWithTable = self::$defaultTable . '.product_id';
                        if ($where['column'] === $productIdWithTable) {
                            $where['column'] = $table . '.product_id';
                        }
                    }
                }
            }
        });
    }

}
```

3、测试 demo

```php
DB::enableQueryLog();
// 查询
$res = ProductImg::select(['product_id', 'url'])->where('product_id', '=', 48234)->limit(1)->first();
$res2 = ProductImg::select(['product_id', 'url'])->whereIn('product_id', [48234])->limit(1)->get();

//with 管理模型查询
$res3 = Product::with(['img' => function($query) {
    return $query->select(['product_id', 'url'])->limit(2);
}])->where('product_id', '=', 10912)->get(['product_id', 'name']);

// update 查询
$res4 = ProductImg::where('product_id', '=', 414656)->where('id', '=', 835092)->update(['category_id' => 4]);

dd([
    $res->toArray(),
    $res2->toArray(),
    $res3->toArray(),
    $res4
], DB::getQueryLog());
```

![laravel-orm-with-sharding-query-demo1](/images/pig/laravel-orm-with-sharding-demo1.png)
