1. 什么是协议？
2. HTTP协议是什么？什么时候出现？为什么会有HTTP协议？如何使用HTTP协议？浅谈网络5层/7层协议是什么【上层协议的使用都是要基于下层协议来提供服务的】？各层职责？HTTP与TCP的关系（三次握手）？

科来 TCP/IP 七层协议图

![TCP/IP七层协议图](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/osi-open-system-interconnection.png)

科来网络故障诊断图

![科来网络故障诊断图](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/network-troubleshooting.png)



4. 域名、DNS、URL、URI、URN分别是什么？
3. HTTP的发展历史：各个版本的改进点？ 
    - https://blog.csdn.net/qq_31393401/article/details/81199831
    - https://blog.51cto.com/13570193/2108347?tdsourcetag=s_pctim_aiomsg
    - 一文读懂HTTP/2 及 HTTP/3特性：https://segmentfault.com/a/1190000018401534
    - HTTP 的前世今生：https://segmentfault.com/a/1190000016996541
3. 为什么要学习HTTP协议（前端、后台、测试）？生活中经常用到的HTTP协议有哪些？HTTP协议是如何实现的？
4. HTTP协议请求报文/响应格式？
4. HTTP客户端工具介绍：浏览器(如何使用浏览器抓取请求信息)、telnet(如何使用telnet发送http请求，设置telnet回写)、curl工具（如何使用curl发送http请求）
5. 使用NodeJS搭建一个最简单的Web服务
6. HTTP方法有哪些？区别是啥？有啥作用？应用场景是啥？
7. HTTP code ？ 
    - https://en.wikipedia.org/wiki/List_of_HTTP_status_codes 
    - https://www.w3cschool.cn/http/g9prxfmx.html
8. HTTP 消息报头
    - 普通报头
    - 请求报头
    - 响应报头
    - 实体报头
9. 浏览器同源策略-跨域
    - CORS浏览器跨域请求的限制与解决：
        - CORS的限制是针对浏览器存在的；
        - access-control-allow-origin
        - jsonp的原理：link/img标签中的href属性、script标签中的src属性允许跨域
10. HTTP 常用报头：
    - 缓存：cache-control、last-modified、Etag
        - 浏览器静态资源刷新浏览器缓存：hash命名静态资源名
    - 会话：cookie
        - cookie 和 session
            - cookie 和 session的区别？联系？会话的原理是啥？
            - session 必须要依赖于 cookie吗？
            - cookie 和 session 的默认生命周期？如何设置它们的生命周期？https://18810098265.iteye.com/blog/2002428
            - https://juejin.im/post/5aede266f265da0ba266e0ef
            - https://juejin.im/post/5aa783b76fb9a028d663d70a
            - https://blog.csdn.net/guoweimelon/article/details/50886092
            - https://segmentfault.com/q/1010000007715137
            - https://blog.csdn.net/hanziang1996/article/details/78969044
            - https://www.jianshu.com/p/25239108b66d
            - http://php.net/manual/zh/features.session.security.management.php
            - https://segmentfault.com/a/1190000011268345
            - token与cookie、session的区别？优势？
    - 数据协商-Accept：Accept、Accept-encoding、accept-language、user-agent
    - 数据协商-Content：Content-type、Content-Encoding、Content-language
11. Nginx 代理
    - Nginx 安装和基本代理配置
    - Nginx代理配置和代理缓存的用处
    - HTTPS 解析
    - 使用 Nginx 部署 HTTP 服务
    - HTTP2 的优势和 Nginx 配置 HTTP2 的简单使用

---

扩展阅读：
- Mozilla HTTP协议：https://developer.mozilla.org/zh-CN/docs/Web/HTTP
- https://blog.csdn.net/whb20081815/article/details/67640804
- 前端必读：浏览器内部工作原理：https://www.html5rocks.com/zh/tutorials/internals/howbrowserswork/#Introduction
- 深入理解浏览器工作原理：https://www.cnblogs.com/xiaohuochai/p/9174471.html
- HTTP 是基于 TCP 还是 UDP 的？ https://www.zhihu.com/question/20085992
- http://blog.jobbole.com/104886/

“HTTP communication usually takes place over TCP/IP connections. The default port is TCP 80 , but other ports can be used. This does  not preclude HTTP from being implemented on top of any other protocol  on the Internet, or on other networks. HTTP only presumes a reliable  transport; any protocol that provides such guarantees can be used;  the mapping of the HTTP/1.1 request and response structures onto the  transport data units of the protocol in question is outside the scope    of this specification.”——RFC2616由此可见默认情况下HTTP使用TCP，但是也可以基于以后存在的其他可靠传输协议。由于UDP无法提供可靠传输，所以不会使用UDP。

- 深入研究：HTTP2 的真正性能到底如何：https://segmentfault.com/a/1190000007219256
- 掌握 HTTP2.0：http://jartto.wang/2018/03/30/grasp-http2-0/
- 前端安全之XSS：https://www.cnblogs.com/unclekeith/p/7750681.html
- 前端安全之CSRF攻击：https://www.cnblogs.com/unclekeith/p/7788057.html
- Web安全之CSRF攻击：https://www.cnblogs.com/lovesong/p/5233195.html
- CC攻击原理及防范方法：https://www.cnblogs.com/wpjamer/p/9030259.html
- 
- 阮一峰博客：http://www.ruanyifeng.com/blog/computer/
- http://www.ruanyifeng.com/blog/2016/08/http.html
- 
- rfc1945-http/1.0 https://tools.ietf.org/html/rfc1945
- rfc1945-http/1.1 https://tools.ietf.org/html/rfc2616【https://tools.ietf.org/pdf/rfc2616.pdf】
- rfc1945-http/2.0 https://tools.ietf.org/html/rfc7540【https://tools.ietf.org/html/rfc7541】

