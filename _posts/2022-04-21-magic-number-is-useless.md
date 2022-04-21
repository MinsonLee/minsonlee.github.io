---
layout: post
title: "对解耦、抽离的思考：代码毒瘤-“魔术数字”"
date: 2022-04-21
tags: [Thinking,Work,编程]
---

> 记录于 2022-04-21 与同事交流学习的思考

在工作环境中，我们经常会用到数字（1、2、3...）来作为某一种代码状态的标识。如：性别（0-男性、1-女性）、订单状态（0-未支付、1-已完成...）等等这类情况。

但是如果我们在后台统计时要将变性也细分出来，那么 `sex` 字段就可能有：0-男性、1-女性、2-女变性为男、3-男变性为女 四种情况，而于用户而言其实依然只有：男、女 两种。

当然上述情况我们可以拆分为两个字段，但如果将这种情况类别到电商系统的订单状态来说，这种情况就会复杂很多，如果有一些分歧就加字段可能需要加很多辅助字段一并进行存储，工作中我们往往不会这样处理，而是将这些变化都用 订单状态-`status_no` 来存。

如我司数据库订单表的订单状态 `status_no` 目前就发现定义了 19 种状态之多，但如果只是基于用户角度来看订单状态的话，往往只有几种：未支付、待确认、已确认、取消中、已取消。

至于到底是由于支付风控导致的订单 “待确认” ？还是请求第三方供应商订单失败或无车而得到的“待确认”？用户是不需要知道的，而系统内部是必须要感知的，因此可能就出现了：**待确认 `status_no` = [1, 2, 3, 4, 5, 6...]** 的情况。

如果此时后端提供一个接口，接口中需要返回订单状态做展示。那么直接返回一个 `6`，于前端接口而言这是极其不友好的，因为：相比直接返回接口直接返回 `6` 而言，直接返回 `to_be_confirm` 这样见文识意的字符串会更加友好，不然前端还需要在自己代码中维护一套 `6-待确认` 这样的映射关系...这是极不可取的，特别对 APP 来说更改一次就需要发一次包，成本极大。

这类订单状态的变更往往会相对比较少，因此更容易被人忽视。故而，在现在的代码中随处可见 `in_array(status_no, [....])` 这样的方式进行判断从而作出相应处理，乍一看好像问题也不大。

但是订单的流程发生一点改变，那么数据库的订单字段。譬如：新增加一个支付渠道，而该新增渠道的支付回调结果需要等待一定时间之后才能知道最终支付结果，我们将此类状态也归类到了 **待确认** 的情况。

那么问题来了，面对产品需求中的“所有待确认状态相关的旧逻辑都要加上该状态”...怎么破？如果你已经在职很久对业务流程和代码都已经烂熟于心那么问题不大，但是如果这是一个新人或对订单模块不那么熟悉的人来改。那么结果就是灾难性的了，提测质量可想而知。即使上线了，估计也胆颤心惊，不知道隐藏在代码中的哪一个 `in_array()` 会漏加、多加一个状态码上去。

因此：**不管是对接口调用方而言，还是后续代码维护者而言，“魔术数字”的泛滥都是灾难性的。**

特别随着 `status_no` 的不断增加，当业务产品所了解的：未支付、待确认、已确认、取消中、已取消 与实际 `status_no` 映射关系不对等，而 `in_array(status_no, [....])` 这种代码又已经不断扩散在代码中时，代码的可维护性难度将呈指数级增加。

1. 于 代码维护者 而言，我们在写代码的时候应当尽量定义一些见文识意的常量来代替这类魔术数字。如： `if( status_no = STATUS_NO_CONFIRM)` 代替这类 `if( status_no = 1)` 或 `if( in_array(status_no, [1,3,5,7]) )` 的写法


2. 当我们需要多处使用 `if( status_no = ORDER_FINISHED)` 或 `if( in_array(status_no, [ORDER_FINISHED, STATUS_COMPLETED...])` 时，就应当思考：是否可以将这一层进行进一步抽离呢？让用户的传入值尽量的保证的稳定、不变

节选自同事的一段代码（增加了注释），如下：

```php
/*订单状态（数据表字段：status_no ）*/
const STATUS_UNPAID = 0;    //未支付
const STATUS_COMPLETED = 1;    //已确认 航意险
const STATUS_CLOSED_UNPAID = 4;    //关闭
const STATUS_CLOSED_SYSTEM = 41;    //系统原因关闭
const STATUS_CLOSED_USER = 43;  // 用户前台取消
const STATUS_PAID = 40;    //已支付未发货
const STATUS_PAID_RISK = 16;    //已支付未发货-风控中
const STATUS_DELIVERSED = 42;    //已发货
const STATUS_FINISHED = 6;    //已完成 交易成功
const STATUS_DELIVERSED_REFUSE = 19;    //拒付-拒付时已发货
const STATUS_FINISHED_REFUSE = 20;    //拒付-拒付时已交易成功
const STATUS_CLOSED_REFUSE = 18;    //拒付-拒付时未发货，执行系统取消

/*订单状态：对调用者而言-稳定、不变*/
const ORDER_UNKNOW_STATUS = 'unknow';//未知状态
const ORDER_UNPAID = 'unpaid';//未支付
const ORDER_PAID = 'paid';//已支付
const ORDER_DELIVERSED = 'deliversed';//已发货
const ORDER_FINISHED = 'finished';//交易成功
const ORDER_CLOSED = 'closed';//交易关闭
const ORDER_IN_RISK = 'in_risk';    // 风控中

// 上层传入数据库的 STATUS_XXX 值，进行映射
// 对外暴露的都是：ORDER_XXX 的常量值
// 后续代码业务判断都基于 ORDER_XXX 的常量值进行处理
public static function getOrderStatusLabel($status) {
    static $mappingList = []; //保存status字段 => 订单状态关系
    if(empty($mappingList)) {
        $_mappingList = [
            self::ORDER_UNPAID => [//未支付
                self::STATUS_UNPAID
            ],
            self::ORDER_PAID => [//已支付
                self::STATUS_PAID,
            ],
            self::ORDER_DELIVERSED => [//已发货
                self::STATUS_DELIVERSED,
                self::STATUS_DELIVERSED_REFUSE
            ],
            self::ORDER_FINISHED => [//已完成
                self::STATUS_COMPLETED,
                self::STATUS_FINISHED,
                self::STATUS_FINISHED_REFUSE
            ],
            self::ORDER_CLOSED => [//已关闭
                self::STATUS_CLOSED_UNPAID,
                self::STATUS_CLOSED_SYSTEM,
                self::STATUS_CLOSED_REFUSE,
                self::STATUS_CLOSED_USER,
            ],
            self::ORDER_IN_RISK => [    // 风控中
                self::STATUS_PAID_RISK,
            ],
        ];
        foreach($_mappingList as $orderStatus => &$value) {
            foreach($value as &$_status) {
                $mappingList[$_status] = $orderStatus;
            }
        }
        unset($_mappingList, $orderStatus, $value, $_status);
    }
    return isset($mappingList[$status])?$mappingList[$status]:self::ORDER_UNKNOW_STATUS;
}
```

当我们提供一个外部接口、内部调用方法时，我们应当思考：随着我们内部逻辑的变更，外部使用者的入参是否会面临频繁改动呢？

当我们内部写代码的时候，也应当思考：如果下次这个逻辑要改，我们能只尽可能的少改动吗？甚至能否只改动一个地方就可以了呢？

如果答案是：否！那么就该思考是否可以抽离成配置或方法来将这种复杂的变化关系内聚，降低与外部的耦合呢？


---------

前段时间在公众号评论抽书，中了一本 《代码的艺术》，很喜欢百度章淼老师的一句话，大致意思为：培养一名回写代码的程序员只需要几个月，而培养一名合格的工程师往往是需要 7-8 年时间的。

回想自己工作的这些时间写文章、在有道上写笔记总结也写了挺多，但关于工作上的总结都是比较零散稀碎的。细想其实还是有很多东西值得去思考和总结，可能对于深耕编程的人来说这些都是垃圾，但是其实这就是所谓的“经验”吧。

譬如：技术角度如何快速的提高自己公司站点的收录呢？写代码时应当如何思考和设计呢？如何理解“职责单一”这种问题呢？你的设计是否会过度设计呢？ 这些问题在工作中也会经常和现在的同事交流并思考，但都没有形成自己的总结，避免随着时间的推移这些问题在自己身上重犯，觉得有空就慢慢写一下吧。