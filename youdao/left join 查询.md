## 数据背景
- 用户表：user_tbl；数据量 60 万左右
- 订单表：order_tbl；数据量 65 万左右；
- 用户积分表：points_user_counter；数据量 60 万左右

## 需求
查询出所有下过单的用户邮箱(排重)，若用户为平台注册用户同时查询出用户的昵称、头像、激活状态及其积分总数

直接查询连接超时断开
```sql
SELECT o.email,u.display_name,u.id as user_id,u.pic,u.`status`,p.points_total FROM order_tbl as o left join erc_user_db.user_tbl as u on o.email = u.email left join erc_user_db.points_user_counter as p on tmp.user_id = p.user_id GROUP BY o.email 
```

查询出结果
```sql
SELECT tmp.*,p.points_total FROM (SELECT o.email,u.display_name,u.id as user_id,u.pic,u.`status` FROM order_tbl as o left join erc_user_db.user_tbl as u on o.email = u.email WHERE u.`status` = 1 GROUP BY o.email) as tmp left join erc_user_db.points_user_counter as p on tmp.user_id = p.user_id 
```