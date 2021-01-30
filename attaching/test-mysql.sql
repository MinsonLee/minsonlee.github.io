SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;


-- ----------------------------
--  Table structure for `goods`
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
create table goods (
  goods_id mediumint(8) unsigned primary key auto_increment COMMENT '商品ID-自增主键',
  goods_name varchar(120) not null default ''  COMMENT '商品名称',
  cat_id smallint(5) unsigned not null default '0'  COMMENT '产品分类ID',
  brand_id smallint(5) unsigned not null default '0' COMMENT '产品品牌ID',
  goods_sn char(15) not null default '' COMMENT '商品序列号',
  goods_number smallint(5) unsigned not null default '0' COMMENT '商品数量',
  shop_price decimal(10,2) unsigned not null default '0.00' COMMENT '售价',
  market_price decimal(10,2) unsigned not null default '0.00'  COMMENT '市场均价',
  click_count int(10) unsigned not null default '0'  COMMENT '点击量'
) engine=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `goods`
-- ----------------------------
BEGIN;
insert into `goods` values (1,'kd876',4,8,'ecs000000',1,1388.00,1665.60,9),
(4,'诺基亚n85原装充电器',8,1,'ecs000004',17,58.00,69.60,0),
(3,'诺基亚原装5800耳机',8,1,'ecs000002',24,68.00,81.60,3),
(5,'索爱原装m2卡读卡器',11,7,'ecs000005',8,20.00,24.00,3),
(6,'胜创kingmax内存卡',11,0,'ecs000006',15,42.00,50.40,0),
(7,'诺基亚n85原装立体声耳机hs-82',8,1,'ecs000007',20,100.00,120.00,0),
(8,'飞利浦9@9v',3,4,'ecs000008',1,399.00,478.79,10),
(9,'诺基亚e66',3,1,'ecs000009',4,2298.00,2757.60,20),
(10,'索爱c702c',3,7,'ecs000010',7,1328.00,1593.60,11),
(11,'索爱c702c',3,7,'ecs000011',1,1300.00,0.00,0),
(12,'摩托罗拉a810',3,2,'ecs000012',8,983.00,1179.60,13),
(13,'诺基亚5320 xpressmusic',3,1,'ecs000013',8,1311.00,1573.20,13),
(14,'诺基亚5800xm',4,1,'ecs000014',1,2625.00,3150.00,6),
(15,'摩托罗拉a810',3,2,'ecs000015',3,788.00,945.60,8),
(16,'恒基伟业g101',2,11,'ecs000016',0,823.33,988.00,3),
(17,'夏新n7',3,5,'ecs000017',1,2300.00,2760.00,2),
(18,'夏新t5',4,5,'ecs000018',1,2878.00,3453.60,0),
(19,'三星sgh-f258',3,6,'ecs000019',12,858.00,1029.60,7),
(20,'三星bc01',3,6,'ecs000020',12,280.00,336.00,14),
(21,'金立 a30',3,10,'ecs000021',40,2000.00,2400.00,4),
(22,'多普达touch hd',3,3,'ecs000022',1,5999.00,7198.80,16),
(23,'诺基亚n96',5,1,'ecs000023',8,3700.00,4440.00,17),
(24,'p806',3,9,'ecs000024',100,2000.00,2400.00,35),
(25,'小灵通/固话50元充值卡',13,0,'ecs000025',2,48.00,57.59,0),
(26,'小灵通/固话20元充值卡',13,0,'ecs000026',2,19.00,22.80,0),
(27,'联通100元充值卡',15,0,'ecs000027',2,95.00,100.00,0),
(28,'联通50元充值卡',15,0,'ecs000028',0,45.00,50.00,0),
(29,'移动100元充值卡',14,0,'ecs000029',0,90.00,0.00,0),
(30,'移动20元充值卡',14,0,'ecs000030',9,18.00,21.00,1),
(31,'摩托罗拉e8 ',3,2,'ecs000031',1,1337.00,1604.39,5),
(32,'诺基亚n85',3,1,'ecs000032',4,3010.00,3612.00,9);
COMMIT;


-- ----------------------------
--  Table structure for `category`
-- ----------------------------
DROP TABLE IF EXISTS `category`;
create table category (
cat_id smallint unsigned auto_increment primary key COMMENT '产品分类ID-自增主键',
cat_name varchar(90) not null default '' COMMENT '产品分类名称',
parent_id smallint unsigned COMMENT '产品分类父级ID'
)engine=InnoDB  DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `category`
-- ----------------------------
BEGIN;
INSERT INTO `category` VALUES
(1,'手机类型',0),
(2,'CDMA手机',1),
(3,'GSM手机',1),
(4,'3G手机',1),
(5,'双模手机',1),
(6,'手机配件',0),
(7,'充电器',6),
(8,'耳机',6),
(9,'电池',6),
(11,'读卡器和内存卡',6),
(12,'充值卡',0),
(13,'小灵通/固话充值卡',12),
(14,'移动手机充值卡',12),
(15,'联通手机充值卡',12);
COMMIT;


-- ----------------------------
--  Table structure for `result`
-- ----------------------------
DROP TABLE IF EXISTS `result`;
CREATE TABLE `result` (
  `name` varchar(20) DEFAULT NULL COMMENT '考生姓名',
  `subject` varchar(20) DEFAULT NULL COMMENT '考试科目',
  `score` tinyint(4) DEFAULT NULL COMMENT '考试成绩'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `result`
-- ----------------------------
BEGIN;
insert into result values 
  ('张三','数学',90), 
  ('张三','语文',50), 
  ('张三','地理',40), 
  ('李四','语文',55), 
  ('李四','政治',45), 
  ('王五','政治',30)
COMMIT;

-- ----------------------------
--  Table structure for `a`
-- ----------------------------
DROP TABLE IF EXISTS `a`;
create table a (
  id char(1),
  num int
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- ----------------------------
--  Records of `a`
-- ----------------------------
BEGIN;
insert into a values ('a',5),('b',10),('c',15),('d',10);
COMMIT;

-- ----------------------------
--  Table structure for `goods`
-- ----------------------------
DROP TABLE IF EXISTS `b`;
create table b (
  id char(1),
  num int
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- ----------------------------
--  Records of `b`
-- ----------------------------
BEGIN;
insert into b values ('b',5),('c',15),('d',20),('e',99);
COMMIT;


-- ----------------------------
--  Table structure for `m`
-- ----------------------------
DROP TABLE IF EXISTS `m`;
create table m(
     mid int,
     hid int,
     gid int,
     mres varchar(10),
     matime date
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- ----------------------------
--  Records of `m`
-- ----------------------------
BEGIN;
insert into m values (1,1,2,'2:0','2006-05-21'), (2,2,3,'1:2','2006-06-21'), (3,3,1,'2:5','2006-06-25'), (4,2,1,'3:2','2006-07-21'); 
COMMIT;



-- ----------------------------
--  Table structure for `t`
-- ----------------------------
DROP TABLE IF EXISTS `t`;
create table t (
     tid int,
     tname varchar(20)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- ----------------------------
--  Records of `t`
-- ----------------------------
BEGIN;
insert into t values (1,'国安'), (2,'申花'), (3,'布尔联队'); 
COMMIT;



-- ----------------------------
--  Table structure for `mian`
-- ----------------------------
DROP TABLE IF EXISTS `mian`;
create table mian ( num int) ENGINE=InnoDB;
-- ----------------------------
--  Records of `mian`
-- ----------------------------
BEGIN;
insert into mian values (3), (12), (15), (25), (23), (29), (34), (37), (32);
COMMIT;


-- ----------------------------
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
create table user (
      uid int primary key auto_increment,
      name varchar(20) not null default '',
      age smallint unsigned not null default 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ----------------------------
--  Table structure for `boy`
-- ----------------------------
DROP TABLE IF EXISTS `boy`;
create table boy (
    hid char(1),
    bname varchar(20)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- ----------------------------
--  Records of `boy`
-- ----------------------------
BEGIN;
insert into boy (bname,hid) values ('屌丝','A'), ('杨过','B'), ('陈冠希','C');
COMMIT;


-- ----------------------------
--  Table structure for `girl`
-- ----------------------------
DROP TABLE IF EXISTS `girl`;
create table girl (
    hid char(1),
    gname varchar(20)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- ----------------------------
--  Records of `girl`
-- ----------------------------
BEGIN;
insert into girl(gname,hid) values ('小龙女','B'), ('张柏芝','C'), ('死宅女','D');
COMMIT;

-- ----------------------------
--  Table structure for `websites`
-- ----------------------------
DROP TABLE IF EXISTS `websites`;
CREATE TABLE `websites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(20) NOT NULL DEFAULT '' COMMENT '站点名称',
  `url` varchar(255) NOT NULL DEFAULT '',
  `alexa` int(11) NOT NULL DEFAULT '0' COMMENT 'Alexa 排名',
  `country` char(10) NOT NULL DEFAULT '' COMMENT '国家',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `websites`
-- ----------------------------
BEGIN;
INSERT INTO `websites` VALUES ('1', 'Google', 'https://www.google.cm/', '1', 'USA'), ('2', '淘宝', 'https://www.taobao.com/', '13', 'CN'), ('3', '菜鸟教程', 'http://www.runoob.com/', '4689', 'CN'), ('4', '微博', 'http://weibo.com/', '20', 'CN'), ('5', 'Facebook', 'https://www.facebook.com/', '3', 'USA');
COMMIT;

-- ----------------------------
--  Table structure for `access_log`
-- ----------------------------
DROP TABLE IF EXISTS `access_log`;
CREATE TABLE `access_log` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT '0' COMMENT '网站id',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '访问次数',
  `date` date NOT NULL,
  PRIMARY KEY (`aid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `access_log`
-- ----------------------------
BEGIN;
INSERT INTO `access_log` VALUES ('1', '1', '45', '2016-05-10'), ('2', '3', '100', '2016-05-13'), ('3', '1', '230', '2016-05-14'), ('4', '2', '10', '2016-05-14'), ('5', '5', '205', '2016-05-14'), ('6', '4', '13', '2016-05-15'), ('7', '3', '220', '2016-05-15'), ('8', '5', '545', '2016-05-16'), ('9', '3', '201', '2016-05-17');
COMMIT;

-- ----------------------------
--  Table structure for `apps`
-- ----------------------------
DROP TABLE IF EXISTS `apps`;
CREATE TABLE `apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_name` char(20) NOT NULL DEFAULT '' COMMENT '站点名称',
  `url` varchar(255) NOT NULL DEFAULT '',
  `country` char(10) NOT NULL DEFAULT '' COMMENT '国家',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `apps`
-- ----------------------------
BEGIN;
INSERT INTO `apps` VALUES ('1', 'QQ APP', 'http://im.qq.com/', 'CN'), ('2', '微博 APP', 'http://weibo.com/', 'CN'), ('3', '淘宝 APP', 'https://www.taobao.com/', 'CN');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;