供应商的问题：

- 一个用户请求（api/supplier/search）需要分裂为 X 个供应商请求；
- 1 个供应商请求又会分裂为 Y 个门店（api/common_vehicle_search.php）请求；
- 1个门店请求又会分裂为 Z 个套餐（api/common_vehicle_search_real.php）请求


- http://master-demo.supplier.api.int.qeeq.cn/api/supplier/search?service_code=7013784170&erc_code=erca.649155b687b639.32069816&start=a1&search_method=default&user_ip=8.8.8.8&ipv6=&lang=en&from_date_0=2023-08-10&from_date_1=10%3A00&to_date_0=2023-08-11&to_date_1=10%3A00&user_id=0&is_mh=0&driver_age=35&is_m=0&async_queue=1&citizen_country_code=AU&user_currency=USD&source_region_id=10008&source_state_id=6&only_site=&exclude_site=&pickup_city=1209&dropoff_city=1209&pickup_landmark=98620&dropoff_landmark=98620&wadmin=limingshuang&_p=1


- http://master-demo.supplier.api.int.qeeq.cn/api/common_vehicle_search.php?clid=880417&push=a1&search_task_start_time=1688626066&inner_call=1&timeout=20&userip=8.8.8.8&real_ip=&lang=en&pickup_time=1691632800&dropoff_time=1691719200&driver_age=35&new_method=1&is_m=0&is_mh=0&user_level=&mongodb=1&wadmin=limingshuang&citizen_country_code=AU&user_currency=USD&real_citizen_country_code=AU&async_queue=1&log_pickup_region=DE&log_pickup_city=Frankfurt&log_pickup_landmark=98620&log_dropoff_region=DE&log_dropoff_city=Frankfurt&log_dropoff_landmark=98620&max_radius=&pickup_radius=3&dropoff_radius=3&site=budget&pickup_store_id_supplier=FRA&dropoff_store_id_supplier=FRA&pickup_zzc_id=16532&dropoff_zzc_id=16532&_debug=1

- http://master-demo.supplier.api.int.qeeq.cn/api/common_vehicle_search_real.php?pickup_timestamp=1691632800&dropoff_timestamp=1691719200&driver_age=35&days=1&clid=880417&push=a1&search_task_start_time=1688626066&inner_call=1&timeout=20&userip=8.8.8.8&real_ip=&lang=en&pickup_time=1691632800&dropoff_time=1691719200&new_method=1&is_m=0&is_mh=0&user_level=&mongodb=1&wadmin=limingshuang&citizen_country_code=AU&user_currency=USD&real_citizen_country_code=AU&async_queue=1&log_pickup_region=DE&log_pickup_city=Frankfurt&log_pickup_landmark=98620&log_dropoff_region=DE&log_dropoff_city=Frankfurt&log_dropoff_landmark=98620&max_radius=&pickup_radius=3&dropoff_radius=3&site=budget&pickup_store_id_supplier=FRA&dropoff_store_id_supplier=FRA&pickup_zzc_id=16532&dropoff_zzc_id=16532&_debug=1&output_request_url=1&pickup_time_bj=1691654400&dropoff_time_bj=1691740800&rate_qualifier=BEST&rate_id=8737&ann=0040445E&awd=

问题：

1. 请求太多，主要时间消耗在网络 I/O 上的等待，PHP 原生不支持并发编程
2. PHP 官方的多线程库不稳定，一直没维护，官方不推荐到使用到生产
3. 采用 PHP-FPM 多进程的方式消费请求，但这样会面临：同一个供应商分裂出来的请求，其基础数据不能共享


1. PHP CURL 扩展库 curl_multi_init 并发请求有一个最致命的问题：函数在最慢的哪一个请求成功之后才会返回句柄
2. 引入了消息队列，PHP-FPM 多进程的方式来消费队列。每产生一个请求就丢到队列，然后 supplier 自身又消费回对应的请求，这样解决了 curl 的等待问题和 数据处理 问题。但是随着接入的供应商越来越多，用户流量越来越大...产生的请求也越来越多。 
3. 单台服务器 PHP-FPM 的进程数由 50 加至 150，此时单台服务器的负载已经达到了峰值，再加进程也已经无济于事，只能横向扩展机器
4. 弹性机横向扩展设置了低峰 3 台，高峰 7 台，而流量最大的时候曾经开过到 30 台
5. 供应商的项目典型的属于 I/O 密集型应用，用并发编程处理是比较合适的：Java 的 NIO 并发编程、Go 的协程 都是解决的好办法
6. Go 招人相对难，问题比较迫切...公司有 Java 的人，通过测试发现两者偏差并非很大，对于业务团队而言，固有的 Java 团队不想再引入一个语言栈（维护问题）
7. 最终决定：使用 Java 重构，而非 Go

- 20220406 supplier-netty重构计划 WIKI ：http://wiki.int.zuzuche.info/pages/viewpage.action?pageId=438418857