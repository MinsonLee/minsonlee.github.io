---
layout: post
title: "Laravel ORM 中的链式操作"
date: 2020-05-20
tag: 编程基础
---
## 背景
爆了一条`2w+`字符长度的 SQL，其`WHERE`条件和`ORDER BY`排序数据被一直重复，格式如下：
```SQL
select xxx from yyy where and `id` > 0 and `id` > 11954 ... and `id` > 511050 and `id` > 511128 and `id` > 511229 and `id` > 511300 order by `id` asc, ... `id` asc limit 50;
```

```php
<?php
class a {
    public $a = '';
    public function test()
    {
        $this->a .= 'abc';
        return $this;
    }
    
    public function get(){
        return $this->a;
    }
}

$query = new a();

$b = null;
for( $i=0; $i < 3; $i++) {
    $b = $query->test();
}
$b = $b->get();
echo $b; // 输出：abcabc
```