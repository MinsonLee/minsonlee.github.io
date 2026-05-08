

文章参考于：《SQL queries don't start with SELECT》<sup style="box-sizing: border-box; visibility: visible;" data-darkmode-color-16258223575834="rgb(255, 53, 2)" data-darkmode-original-color-16258223575834="#fff|rgb(63, 63, 63)|rgb(255, 53, 2)">[1]</sup> 

图片来自 Twitter 的一位博主 @Julia Evans <sup style="box-sizing: border-box; visibility: visible;" data-darkmode-color-16258223575834="rgb(255, 53, 2)" data-darkmode-original-color-16258223575834="#fff|rgb(63, 63, 63)|rgb(255, 53, 2)">[2]</sup> 

![image](DF92929860734724A43084ADE38F366D)


```sql
 CREATE TABLE `periods` (
 `start_day` int NOT NUL
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
insert into periods(`start_day`) values(1), (32), (59), (110);


CREATE TABLE `order_tab` (
  `order_id` int NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `user_no` int(3) unsigned zerofill NOT NULL COMMENT '用户id',
  `amount` int NOT NULL COMMENT '价格',
  `create_date` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '下单时间',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `test`.`order_tab`(`order_id`, `user_no`, `amount`, `create_date`) VALUES (1, 001, 100, '2021-07-01 00:00:00'),(2, 001, 300, '2021-07-02 00:00:00'),(3, 001, 500, '2021-07-02 00:00:00'),(4, 001, 800, '2021-07-03 00:00:00'),(5, 001, 900, '2021-07-04 00:00:00'),(6, 002, 500, '2021-07-05 00:00:00'),(7, 002, 600, '2021-07-06 00:00:00'),(8, 002, 300, '2021-07-07 00:00:00'),(9, 002, 800, '2021-07-08 00:00:00'),(10, 002, 800, '2021-07-09 00:00:00');

```


## References

[1] https://jvns.ca/blog/2019/10/03/sql-queries-don-t-start-with-select/ <br/>
[2] https://twitter.com/b0rk/status/1179419244808851462 <br/>
[3] https://zhuanlan.zhihu.com/p/237292843 <br/>
[4] https://www.begtut.com/mysql/mysql-window-functions.html <br/>
[5] https://dbaplus.cn/news-11-2258-1.html <br/>