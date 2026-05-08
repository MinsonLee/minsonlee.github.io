https://wxnacy.com/2018/07/22/openresty-error-ngx-postgres/

https://www.cnblogs.com/Tanwheey/p/12689629.html

![image](8A801A33FB2F4B2990C2768F81D9F4E9)

## Nginx 

Nginx 的基本体系结构：master进程（读取配置并维护worker进程）+worker进程组成（处理实际请求）。其进程模型架构（多进程+I/O复用模型）图如下：

![image](9F2D62C4ABA046F399A6E82A3E3F0C39)

> - Nginx架构：https://juejin.cn/post/6844903846251085837
> - NGINX架构图：https://www.jianshu.com/p/867b62be938a


命令 | 描述 
-----| ----
`nginx -v` | 显示 Nginx 版本
`nginx -V` | 显示 Nginx 版本及安装编译参数（宝藏命令）
`nginx -c nginx.conf` | 设置配置文件
`nginx -t` | 检查配置文件是否有错误（如果 nginx.conf 不是默认位置，需要`-c`指定）
`nginx -T` | 功能与 `-t` 一致，同时还会将检测的配置文件打印出来
`nginx -s stop` | Nginx 服务管理：stop-立刻停止服务
`nginx -s quit` | Nginx 服务管理：quit-不再接收请求，等所有work进程处理完请求后再退出
`nginx -s reload` | Nginx 服务管理：热更新conf文件（热重启服务）
`nginx -s reopen` | Nginx 服务管理：重新打开日志文件句柄（做日志切割备份时需要用到）

1. [nginx -s reload 与 service nginx restart 的区别](http://roc.havemail.cn/archives/892.html)：
    - `nginx -s reload`不会影响服务，若配置有误则按照上一版本继续提供服务；
    - `service nginx restart`相当于自动执行`service nginx stop`随后立即执行`service nginx start`，不仅可能会产生片刻服务中断，若配置文件有错误还会出现服务重启失败。

2. 如何找到 nginx 默认的 html 访问目录？执行 `nginx -V`，查看 `--prefix`目录，在该目录下的 html 文件夹中

3. alpine 编译时，如何确定所需要的依赖包？
    - 通过 `uname -m` 找到自己系统的架构-`Architecture`（如：x86_64）
    - 在 `https://pkgs.alpinelinux.org/packages` 搜索对应的服务 packages（如：Nginx），然后找到自己的 `Architecture` ，查看 `Package details` 信息
    - 点击 `Build log` 查看具体的构建信息，即可查看构建所需要的依赖包
    ![Installing for build](024B7EEA443B4E6088D510722DC4A5A9)

4. 使用 alpine 构建镜像，如何缩减构建镜像的体积？
    - 方法1：使用 `ldd <binarry-path>` 查看服务需要的依赖包，然后将其余的依赖文件全部删除即可
    - 方法2（推荐）：通过 apk del 删除所有构建服务时的依赖库，然后通过 `apk add ---nocache $(scanelf --needed --nobanner --format '%n#p' $NGINX_SBIN_PATH $NGINX_MODULES_PATH/*.so | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }')` 安装运行时候依赖的库文件即可
 
 5. [nginx如何升级？](https://www.huaweicloud.com/articles/d23e3af8ab424b04a3636096559e3f2d.html) 通过将 `make install` 换成 `make upgrade` 
 
 6. [如何给 NGINX 安装 HTTP2.0 模块？](https://www.cnblogs.com/larry-luo/p/10131987.html)
 
 7. [NGINX 中所有支持的变量](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables)
 
8. [Nginx输出JSON格式日志](https://cloud.tencent.com/developer/article/1397738)

9. [使用nginx实现HTTP负载均衡](https://skyao.gitbooks.io/learning-nginx/content/documentation/HTTP_load_balancer.html)


## ldd 脚本

> https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/ldd.html

`ldd` 不是个可执行程式，而只是个 `shell` 脚本.

```sh
ldd 绝对路径 
```

![image](1487EB21408A43889487C22462916EA8)

- 第一列：程序需要依赖什么库
- 第二列: 系统提供的与程序需要的库所对应的库
- 第三列：库加载的开始地址

## openresty 最佳实践

- [《Openresty最佳实践》](https://wiki.jikexueyuan.com/project/openresty/)
- [跟我学OpenResty(Nginx+Lua)开发目录贴](https://www.iteye.com/blog/jinnianshilongnian-2190344)
- [Openresty开发系列](https://www.cnblogs.com/reblue520/category/1535368.html?page=2)