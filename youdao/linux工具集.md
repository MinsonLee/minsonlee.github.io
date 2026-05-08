# Linux 工具

[Linux工具快速教程](https://linuxtools-rst.readthedocs.io/zh_CN/latest/index.html)
,[Github 地址](https://github.com/me115/linuxtools_rst)

[TOC]

## wkhtmltopdf、wkhtmltoimage

`Wkhtmltopdf` 和 `wkhtmltoimage` 是两个开源(基于 LGPLv3 开源协议)命令行工具，其工作原理是通过 Qt WebKit 浏览器引擎对 HTML 进行渲染，然后将渲染的页面转为 PDF 和各种图像格式。

- [wkhtmltopdf 下载地址](https://wkhtmltopdf.org/downloads.html)
```shell
# 下载 deb 
wget "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb"
# 安装工具
sudo apt install -f ./wkhtmltox_0.12.6-1.focal_amd64.deb

# pdf 工具
# /usr/local/bin/wkhtmltopdf

# 图片工具
# /usr/local/bin/wkhtmltoimage
```

- [WebKit 是什么？](https://www.infoq.cn/article/webkit-for-developers)
- [Chromium内核和Webkit的关系到底是什么？](https://chenlungang.com/index.php/2021/08/16/chromium%E5%86%85%E6%A0%B8%E5%92%8Cwebkit%E7%9A%84%E5%85%B3%E7%B3%BB%E5%88%B0%E5%BA%95%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F/)

## curl 和 wget 的使用和区别

### 简介

`cURL` 是一个开源项目，主要的产品有 `curl` 和 `libcurl`： `curl` 是一个跨平台的 `URL` 命令行工具，`libcurl` 是一个 `C语言`的网络协议扩展库。两者都是**基于多种互联网通用协议**对指定 `URL` 的资源进行**数据传输**。更多的信息可以阅读电子书：[《Everything curl》](https://ec.haxx.se/)

`GUN Wget` 也是一个免费的开源项目，用于从 `web` 上下载文件。

### `wget` 使用

通过软件管理包安装非常简单，可参考：[《How to Install Wget in Linux》](https://www.tecmint.com/install-wget-in-linux/)

```sh
## Ubuntu/Debian
apt-get install wget

## RHEL/CentOS/Fedora
yum install wget

## OpenSUSE
zypper install wget

## ArchLinux
pacman -Sy wget
```
 
安装完毕之后，可以使用 `wget --version` 或 `wget -V` 验证工具是否安装成功！

#### 可以做什么？

- 通过`HTTP`、`HTTPS`、`FTP`、`FTPS`协议递归下载文件
- 支持自动断点续传文件【`-c`参数，旧版本可能存在问题，详情见：[Linux 环境下使用 wget 命令下载 Blob 文件断点续传问题](https://docs.azure.cn/zh-cn/articles/azure-operations-guide/storage/aog-storage-blob-wget-download-offset)】
- 支持通配符批量下载文件
- 支持将下载的文档中的绝对链接转换为相对链接，以便下载的文档可以在本地彼此链接（--convert-links）
- 支持：HTTP 代理、COOKIE设置、HTTP 持久化连接

#### 常用参数

更多参数，查看[`GNU Wget Manual`](https://www.gnu.org/software/wget/manual/wget.html)，详细使用用法自行谷歌！

##### 下载参数

| 选项/参数 | 作用  |
| ------- | ---  |
| -b, –-background | 启动后转入后台执行【可以通过 `tail -f wget.log` 查看下载进度】 |
| –progress=TYPE | 设置进程标记【通过 `-b` 后台作业进行下载时】 |
| -e, –-execute=COMMAND | 启动下载进程之前执行命令【如：设置临时环境变量...】 |
| -c, –-continue | 接着下载没下载完的文件【即：断点续传】
| -S, –-server-response | 打印服务器的回应 |
| -nc, –-no-clobber | 不要覆盖存在的文件或使用.#前缀【若本地已有同名文件，拒绝下载-在多次重复下载同一个站点时或者存在站点多个网页引用同一个资源时常用】 |
| -N, –-timestamping | 不要重新下载文件除非比本地文件新【只是单纯的对比下载时间，并不会理会本地文件是否下载完整】 |
| -t, –-tries=NUMBER | 设定最大尝试链接次数(`0` 表示无限制).【当由于网络的原因下载失败，`wget`会不断的尝试，直到整个文件下载完毕，可以设置最大尝试连接次数】
| -T, –-timeout=SECONDS | 设定响应超时的秒数 |
| -w, –-wait=SECONDS | 指定两次重试之间间隔秒数 |
| –waitretry=SECONDS | 在重新链接之间等待的秒数 |
| –random-wait | 在下载之间等待 0-2 秒 |
| -Y, –-proxy=on/off | 打开或关闭代理【更推荐：https://www.cnblogs.com/frankyou/p/6693256.html 文中方法3】
| -Q, –-quota=NUMBER | 设置下载的容量限制【注意：这个参数对单个文件下载不起作用，只能递归下载时才有效。如：`-Q=5m`】 |
| -–limit-rate=RATE | 限定下载速率【即：限制下载带宽，如：`--limit-rate=50k`】 |
| –-bind-address=ADDRESS | 指定本地使用地址(主机名或`IP`，当本地有多个`IP`或名字时使用) |
| –-spider | 不下载任何东西【当需要调试打印 `HTTP` 响应信息时会使用该参数跳过下载步骤】 |

##### 下载路径设置

|选项/参数 | 作用  |
| ------- | ---  |
| -O FILE, –-output-document=FILE | 把文档写到文件中【即：自定义下载路径】 |
| -nd, –-no-directories | 不创建目录（缺省参数） |
| -x, –-force-directories | 强制创建目录【如：下载 `www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4` 会层层创建目录】 |
| -nH, –-no-host-directories | 不创建主机目录【当 `-x` 参数存在时才可用】 |
| -P, –-directory-prefix=PREFIX | 将文件保存到目录 `PREFIX/…` |

##### 输入/记录日志输出

|选项/参数 | 作用  |
| ------- | ---  |
| -i, –-input-file=FILE | 下载指定文件中出现的`URLs` |
| -F, –-force-html | 把输入文件当作`HTML`格式文件对待 |
| -B, –-base=URL | 将`URL`作为在`-F -i`参数指定的文件中出现的相对链接的前缀 |
| -d, –-debug | 打印调试输出 |
| -q, –-quiet | 安静模式(没有输出，下载完成直接退出) |
| -v, –-verbose | 冗长模式(这是缺省设置) |
| -nv, –-non-verbose | 关掉冗长模式，但不是安静模式【相比安静模式，该模式下若下载完成会输出下载完成信息】 |
| -o, –-output-file=FILE | 把记录写到文件中 |
| -a, –-append-output=FILE | 把记录追加到文件中 |
| --show-progress | 强制 wget 在非 nv 模式下显示进度条 |


##### HTTP 选项参数

|选项/参数 | 作用  |
| ------- | ---  |
| –-no-cache |允许/不允许服务器端的数据缓存 (一般情况下允许) |
| -–no-http-keep-alive | 关闭 `HTTP` 活动链接 (持久链接) |
| -–http-user=USER | 设定`HTTP`用户名 |
| -–http-passwd=PASS | 设定`HTTP`密码 |
| -–proxy-user=USER | 设定代理的用户名 |
| -–proxy-passwd=PASS | 设定代理的密码 |
| -U, –-user-agent=AGENT | 设定代理的名称为`AGENT`（默认为：`Wget/VERSION` |
| -–header=STRING | 在`headers`中插入字符串 `STRING` |
| –-load-cookies=FILE | 在开始会话前从文件中加载`cookie` |
| -–save-cookies=FILE | 在会话结束后将 `cookies` 保存到文件中 |
| -–referer=URL | 在`HTTP`请求中包含 `Referer: URL`头 |

##### FTP 选项参数

```sh
wget -v --ftp-user=demo --ftp-password=password "ftp://test.rebex.net/readme.txt"
```

##### 递归下载

|选项/参数 | 作用  |
| ------- | ---  |
| -r, -–recursive | 递归下载－－慎用! |
| -l, -–level=NUMBER | 最大递归深度 (`inf` 或 `0 ` 代表无穷) |
| -k, –-convert-links | 转换非相对链接为相对链接 |
| -K, –-backup-converted | 在转换文件`X`之前，将之备份为`X.orig` |
| -m, –-mirror | 等价于 `-r -N -l inf -nr`【对网站做镜像下载】 |
| -L, –-relative | 仅仅跟踪相对链接 |
| -np, –-no-parent | 不要追溯到父目录 |
| -A, –-accept=LIST | 分号分隔的被接受扩展名的列表 |
| -E, --adjust-extension | 以合适的扩展名保存 HTML/CSS 文档 |
| -H, --span-hosts | 递归下载时，允许递归检索第三方外链域名【慎用！！！】 |
| -R, –-reject=LIST | 分号分隔的不被接受的扩展名的列表 |
| -D, –-domains=LIST | 分号分隔的被接受域的列表 |
| –-exclude-domains=LIST | 分号分隔的不被接受的域的列表 |
| –-follow-ftp | 跟踪HTML文档中的`FTP`链接 |
| –-follow-tags=LIST | 分号分隔的被跟踪的`HTML`标签的列表 |
| -I, –-include-directories=LIST | 允许目录的列表 |
| -X, –-exclude-directories=LIST | 不被包含目录的列表 |

#### 案例：使用`wget`下载网站下所有的图片

##### 图片命名有规则

对于命名有规则的图片，下载非常简单：使用[通配符](http://www.ruanyifeng.com/blog/2018/09/bash-wildcards.html)（*-任意长度的任意字符、?-任意一个字符、[]-括号中的任意一个字符、{..}-表示一个序列）下载即可
```
wget -b http://aliimg.changba.com/cache/photo/{260929610-260939610}_640_640.jpg
```

##### 图片命名无规则

一共 22 页，图片全部在 `CDN：img1.446677.xyz`上，图片命名是非规则的！
- 遍历当前页面的 `img.446677.xyz` 域名，下载资源
- 遍历 22 分页：`https://www.kanxiaojiejie.com/page/{1..22}`

```sh
wget -b -c -r -H -D "img1.446677.xyz" -R "www.kanxiaojiejie.com" -nc https://www.kanxiaojiejie.com/page/{1..22}
```

### axel 多线程下载

`axel` 是 Linux 下一个不错的 HTTP/ftp 多线程下载工具。`axel` 同样也支持断点续传，且相比 `wget` 和 `curl` 它可以从一个或多个地址的多个连接来下载同一个文件，最突出的当然是其支持多线程并行下载，因此：`axel` 非常适合网速不给力时用于提高下载速度。

当然，相较于 `wget`，`axel` 的缺点也是明显的：功能不够丰富。不过就下载而言，高速下载是最让人欣喜的优点。

#### 安装

```sh
# Debian/Ubuntu安装Axel
apt-get install axel

# alpin 安装
apk add axel
```

#### 选项

由于其功能单一，因此 `axel` 的选项参数也非常的少

```
--max-speed=x , -s x         # 设置最高速度，单位字节（1M = 1024 000）
--num-connections=x , -n x   # 设置连接数
--output=f , -o f            # 自定义下载路径
--search[=x] , -S [x]        # 搜索镜像
--header=x , -H x            # 指定 HTTP header
--user-agent=x , -U x        # 指定 HTTP user agent
--no-proxy ， -N             # 不使用代理服务器
--quiet ， -q                # 静默模式
--verbose ，-v               # 更多状态信息
--alternate ， -a            # 修改进度条显示（简短显示）
--help ，-h                  # 帮助
--version ，-V               # 版本信息
```

#### 案例：axel VS wget

我分别针对体积在 100M+、900M+、5.86G 的三个文件进行了下载测试

![axel download](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/axel-download-demo.png)

![wget download demo](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/wget-download-demo.png)

![axel vs wget](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/axel-vs-wget.png)

- axel 默认支持断点续传，而 wget 需要 -c 参数进行指定
- axel 在网速正常时，对于小型文件相较于 wget 似乎并没有什么优势，反而还要慢一些
- axel 更加使用与下载大文件或慢网情况下设置并行下载

### `curl` 使用

`cURL`你想要了解的`curl`的知识基本都在：[《Everything curl》]( https://ec.haxx.se/)里面。关于安装，请查看[GET cURL](https://ec.haxx.se/get-curl)。

#### 可以做什么？

`curl` 的定位是在网络中“传输数据”，相比于`wget`的只能下载资源就显得`curl`的功能要强大太多了，而且其支持协议也比`wget`要多的多。`curl` 可以用来发送邮件、批量请求、下载文件、模拟表单提交、分析网站请求耗时...`wget`能做的，`curl`都能做！

#### 常用选项参数

##### 标准错误输出

|选项/参数 | 作用  |
| ------- | ---  |
| -V, --version | 显示版本号并退出 |
| -v, --verbose | 展示资源传输详细信息 |
| --trace <file> | 将调试跟踪信息写入到文件中 |
| --trace-ascii <file> | 类似于 --trace，但没有十六进制输出 |
| -s, --silent | 静音模式-不显示任何**标准错误**信息（注意：不影响结果输出到`stdout`） |
| -I, --head | 只显示响应头信息 |
| -D, --dump-header <文件名> | 将响应头文件写入指定文件 |
| -i, --include | 在输出中包含协议响应头：`Response Header` + `Body` |
| -w, --write-out <format\|@format-file> | 完成后使用输出格式 |

##### 标准输出

|选项/参数 | 作用  |
| ------- | ---  |
| -o, --output <file> | 将输出写入文件（注意需要绝对路径）而不是`stdout` |
| -O, --remote-name | 将输出写入与远程文件同名的文件中，如：`curl -O xxx/a.html` 写入本地 `a.html`中 |
| -J, --remote-header-name | 使用头提供的文件名。如：`Content-Disposition: attachement; filename=rustup-setup.exe` |

> ！！！注意：`curl -O https://www.baidu.com` 请求只有域名部分或结尾以`/`结尾，请求是会报错的！这正是`-o`和`-O`的不同之处

##### 输入

|选项/参数 | 作用  |
| ------- | ---  |
| --limit-rate <speed> | 限制传输速度，模拟慢网络 |
| --cert <pem_file> | 携带客户端的`SSL`证书进行请求 |
| -k, --insecure | 使用`SSL`时允许不安全的服务器连接（忽略`SSL`验证失败） |
| -L, --location | 遵循重定向，自动处理重定向跳转 |
| -C, --continue-at <offset>| 指定断点续传的便宜量【！！！注意：要自动续传的话要使用 `-C -`，否则要自行指定】 |
| -m, --max-time <秒> | 允许传输的最长时间 |
| --connect-timeout <秒> | 允许连接的最长时间 |
| -x <switch> | 使用代理 |

##### 请求

|选项/参数 | 作用  |
| ------- | ---  |
| -0, --http1.0 | 使用 HTTP 1.0 版本协议 |
| --http1.1  | 使用HTTP 1.1 |
| --http2 | 使用HTTP 2 |
| --http2-prior-knowledge | 使用HTTP 2而不使用HTTP/1.1升级。 |
| --http3 | 使用HTTP v3 |
| -X, --request <命令，如：POST/GET/PUT...> | 指定要使用的请求命令 |
| -G, --get | 将数据放入`URL` 中，并使用`GET`发送请求 |
| -d, --data <data> | HTTP 要传输的数据，默认是`POST` |
| --data-urlencode <data> | 将`HTTP`请求数据进行`URL`编码 |
| -F, --form <key-name=content> | 指定多部分`MIME`数据、数据类型。如：模拟`POST`表单上传二进制文件 |
| -T, --upload-file <file> | 使用`PUT`方式传输本地文件到服务器-一般`FTP`上传文件 |
| -H, --header <header/@file> | 将自定义头传给服务器 |
| -A, --user-agent <name> | 发送`User-Agent: <name>`到请求头中 |
| -e, --referer <URL> | 设置`Referer: <url>`到请求头中 |
| -b, --cookie <data\|filename> | 从字符串/文件发送`cookie` |
| -c, --cookie-jar <filename> | 操作后将`cookie`写入文件名 |
| -u, --user <user:password> | 服务器用户和密码 |

#### 使用`curl`变量格式化输出

##### 重定向输出

- **%\{stderr\}** - 使用`-w`参数格式化结果时，将该变量后的结果作为 `标准错误-stderr` 输出
- **%\{stdout\}** - 使用`-w`参数格式化结果时，将该变量后的结果作为 `标准输出-stdout` 输出

##### 获取请求信息

- **%\{local_ip\}** 本地客户端IP地址（支持`IPv4`或`IPv6`）
- **%\{local_port\}** 本地客户端请求端口

##### 获取响应信息

- **%\{content_type\}** 获取 `HTTP` 响应头中的 `Content-Type`
- **%\{method\}** 最终一次 `HTTP` 请求方法
- **%\{http_version\}** 最终一次 `HTTP` 请求的协议版本
- **%\{scheme\}** 获取最终`URL`的通信协议方式（若使用了`-L`参数，发生了重定向跳转最终获得的值可能和你预想的`URL`协议不一致）
- **%\{response_code\}** 最后一次传输返回的数字响应码（如：`HTTP CODE`-旧版本获取响应码`%{http_code}`）
- **%\{url_effective\}** 获取最终重定向后的`URL`地址（`-L` 参数设置 `URL` 自动重定向跳转，而不是直接返回 301/302 信息）
- **%\{num_redirects\}** 重定向次数（只有使用了 `-L` 选项且确实发生了重定向该值才为非0）
- **%\{redirect_url\}** 重定向之后的`URL`（当没有设置 `-L` 参数时才有值）
- **%\{remote_ip\}** 远程IP地址（支持`IPv4`或`IPv6`）
- **%\{remote_port\}** 远程响应端口
- **%\{ssl_verify_result\}** SSL 证书验证结果：0-成功
- **%\{filename_effective\}** `curl`写入的最终文件名。只有当使用了 `--remote-name` 或 `--output` 选项时这个选项才有意义。它与 `--remote-header-name` 选项结合使用时最有用
- **%\{ftp_entry_path\}** 登录到远程FTP服务器时，`curl`的初始路径
- **%\{num_connects\}** 最近一次请求传输建立的TCP连接数

##### 传输速率

- **%\{size_download\}** 下载内容的总字节数（即：`Body`总字节数-`Content-Length`）
- **%\{size_header\}** `HTTP` 响应头 `headers` 的总字节数（不包含 `Body` 体）
- **%\{size_request\}** `HTTP` 请求中发送的总字节数
- **%\{size_upload\}** 上传的总字节数
- **%\{speed_download\}** `curl`的平均下载速度，单位：字节/秒【B/s】
- **%\{speed_upload\}** `curl`的平均上传速度，单位：字节/秒【B/s】

##### 请求时间

- **%\{time_appconnect\}** 从“发起请求-->完成SSL/SSH 等上层协议”所耗费的时间，单位-秒
- **%\{time_connect\}** 从“发起请求-->完成TCP三次握手”所耗费的时间，单位-秒
- **%\{time_namelookup\}** 域名解析完成所耗费的时间，单位-秒（测试 `DNS` 服务器的寻址能力）
- **%\{time_pretransfer\}** 从开始到文件传输即将开始所花费的时间（所有传输前的命令和特定协议的协商），单位-秒
- **%\{time_redirect\}** 所有重定向所耗费的时间（重定向域名寻址-->准备传输前），单位-秒
- **%\{time_starttransfer\}** 过程“发起请求连接-->接收到服务器的第一个字节响应”所耗费的时间（包括：请求/响应过程链路连接的耗时+服务器处理逻辑耗时），单位：秒
- **%\{time_total\}** 整个请求操作的总耗时（发起请求连接-->传输完毕），单位：秒

#### 案例：使用`curl`分析网站单次请求响应情况

之前公司的服务接口都是对外可访问的，后针对内部服务将对应的域名迁移变为内网域名。迁移后需要验证测试、预发布、生产每一台机器上对内网域名都是可访问且稳定的。

验证：是否可访问？此时改功能就需要用到 cURL 的 format 功能了。

![curl-format-demo.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/curl-format-demo.png)

先准备一份格式化文件`curl-format.txt`，内容如下：
```sh
## cat  curl-format.txt 
               url: %{redirect_url}\n
         remote_ip: %{remote_ip}\n
     response_code: %{response_code}\n
   time_namelookup: %{time_namelookup}\n
      time_connect: %{time_connect}\n
   time_appconnect: %{time_appconnect}\n
     time_redirect: %{time_redirect}\n
  time_pretransfer: %{time_pretransfer}\n
time_starttransfer: %{time_starttransfer}\n
                    ----------\n
time_total: %{time_total}\n 
```
示例：
```sh
## curl -w "@/tmp/curl-format.txt" -o /dev/null --connect-timeout 15  -s -L "xxx.com"

               url: https://www.xxx.com/
         remote_ip: 210.65.162.22
     response_code: 200
   time_namelookup: 0.640369
      time_connect: 1.190672
   time_appconnect: 1.126743
     time_redirect: 1.080580
  time_pretransfer: 2.007771
time_starttransfer: 3.333640
                    ----------
time_total: 5.689121
```

```shell
curl -s -o /dev/null -I -w "%{response_code} %{redirect_url}\n" http://www.example.org/
```

### 总结

| 特性 | wget | axel | curl |
| ---- | ---- | ----- | ----- |
| 作用 | 下载文件 |  下载文件 | “资源传输” |
| 开源 | 是 | 是 | 是 |
| 支持协议| HTTP, HTTPS, FTP, FTPS | HTTP(S)，FTP | 基本的网络通用协议都支持（支持30多种协议） |
| 可交互 | 否 | 否 | 否 | 
| 是否支持递归下载 | 是 | 否 | 否 |
| 跨平台 | 不支持 X-Windows | 不支持 X-Windows | [支持跨平台客户端](https://ec.haxx.se/get-curl) |
| 使用难易 | 简单，可配置少 | 简单 |功能丰富，可自定义的配置多，有一定的使用门槛 |

- 三者都是不可以交互的命令行工具，这意味着 `wget`、`axel` 和 `curl` 都可以直接在 `Shell` 脚本、`crontab`等工具中被使用
- `wget` 是一个无需依赖其他扩展的独立、简单的程序，专注于下载且支持递归下载，如果遇到访问链接`301`、`302`等情况会自动进行跳转然后进行下载
- `axel` 针对 HTTP(S)/FTP 
- `curl` 是一个功能完备的网络请求工具-更多的用途是：① 从stdin读取数据将网络请求结果输出到stdout；② 更多的协议、提供了更大的自定义操作功能，如：并发测试、下载数据、上传数据、获取响应报头进行分析...

#### 使用建议：

1. 如果是下载小型文件优先使用`wget`
2. 下载较大文件或在服务器上下载文件，优先考虑 `axel`（因为服务器上下载文件，需要考虑限速，否则过多的占用出口带宽会导致用户访问服务异常）
3. 复杂情况使用 `curl`

最后可以看一下：[《10个例子教你学会wget命令》](https://github.com/lujun9972/linux-document/blob/master/examples/10%20wget%20command%20examples.org)、[《curl使用实例》](https://blog.csdn.net/fdipzone/article/details/78828617)、[21 个 curl 练习](https://zhuanlan.zhihu.com/p/95745653) 实战练习一下！或者可以写一个脚本并发请求百度页面分析每个请求的报头信息。


## Linux JSON 格式化工具 - `jq`

`JSON-JavaScript Object Notation` 是一种轻量级的数据交换格式。由于其简单、便于阅读、便于编写的特性，逐渐替代了一部分`xml`的职责在数据交换领域占有一定地位，绝大部分的语言也都提供了对`JSON`文本的解析，详细可阅读：[什么是`JSON`](https://www.json.cn/wiki.html)、[各主流语言的`JSON`解析代码](https://www.json.cn/code.html)。

`Linux` 平台上处理文本的工具堪称是经典，例如：`sed`、`awk`、`grep`、`find`...，但如果返回结果是 `JSON` 格式，使用上述提到的文本处理工具也可以获取到对应的值，但成本稍微复杂一点（并且还有可能不准确），如下：

![jq-use-awk-to-get-json-value.png](https://minsonlee.github.io/images/article/jq-use-awk-to-get-json-value.png)

在桌面系统中，我们可以通过一些网站提供的工具（如：[http://json.cn/](http://json.cn/)）或浏览器插件（[`FeHelper`](https://www.baidufe.com/fehelper/index/index.html)）可以很方便的解析 `JSON` 数据并快速得到我们想要的结果。

但是在 `Shell` 编程中，就需要自己通过`grep`、`awk`、`sed`等工具组合进行“曲线救国”了，非常麻烦且匹配出来的结果有时还不太准确！后来在网上一搜...好家伙，原来`jq`这个工具从 `2013` 年就出来了，真是孤陋寡闻了！

正如 [`jq` 的官网](https://stedolan.github.io/jq/)所说：`jq`是一个用 `C` 语言编写的独立没有任何依赖的开源工具，你可以使用 `jq` 来切割、过滤、映射和转换 `JSON` 结构化数据，而可以用 `sed`、`awk`、`grep`更加轻松、专注、友好的处理文本。

- `jq` 的官网：https://stedolan.github.io/jq/
- `jq` 的指南：https://stedolan.github.io/jq/tutorial/
- `jq` 的手册：https://stedolan.github.io/jq/manual/
- `jq` 的安装：https://stedolan.github.io/jq/download/ 【安装完毕后可以通过 `jq -V` 验证是否安装成功】


### 使用

1. **在 `jq` 中英文状态下的点号-`.`表示整个`JSON`结构**（还可以通过管道将父级节点）
2. **获取对象的值：`.key`**
3. **获取数组的值：`.key[0]`**

#### 格式化 `json` 文本

`JSON` 实际只是一种特殊格式的字符串，有些情况下服务器返回的数据虽然是 `JSON` 的，但是如果响应头中的 `Content-Type` 不是 `application/json`，那么客服端是不会进行美化打印的。可以通过管道将 `JSON` 格式的文本传给 `jq` 进行格式化打印输出。

```sh
echo '{"text":"这是一个json格式的文本"}' | jq .
```

![jq-format-json.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/jq-format-json.png)

#### 获取对象的值

![jq-get-object-json.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/jq-get-object-json.png)

#### 获取数组的值

```sh
# 获取数组下所有的 `name` 属性值
echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' | jq '.[].name'

# 获取数组下所有的 `name` 属性值 ==> 利用管道将父节点作为 `JSON` 整个节点
echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' | jq '.[] | .name'

# 获取指定数组下`name`属性
echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' | jq '.[0].name'
```

![jq-get-array-json.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/jq-get-array-json.png)

#### 自定义输出数组

```sh
curl -s http://httpbin.org/anything | jq '. | {"方法": .method, "链接": .url}'
```

![jq-customer-output-json.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/jq-customer-output-json.png)

#### 压缩 `JSON` 为字符串

```sh
curl -s http://httpbin.org/anything | jq -c
```

![jq-zip-json-to-string.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/jq-zip-json-to-string.png)


## Linux YAML 读取工具 - yq

yq is a portable command-line YAML processor [(https://github.com/mikefarah/yq/)](https://github.com/mikefarah/yq/)
See [https://mikefarah.gitbook.io/yq/](https://mikefarah.gitbook.io/yq/) for detailed documentation and examples.

安装

```sh
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64

sudo chmod a+x /usr/local/bin/yq

yq --version
```

使用 `yq eval --help` 查看帮助文档，因为觉得它的帮助文档已经写得非常详尽，不做阐释

```yaml
apiVersion: v1
kind: Service
metadata:
  name: db-event-producer
  namespace: erc-dev
  labels:
    app: db-event-producer
spec:
  ports:
    - port: 8080
      targetPort: 8080
      name: http
  selector:
    app: db-event-producer
  type: ClusterIP
```

```sh
# 读取整个配置文件
yq e test.yaml

# 读取文件下某一个 key
yq e '.apiVersion' test.yaml # map 读取
yq e '.spec.ports[0].name' ./test.yaml # 数组读取
```



## Web压测工具-ab、siege、wrk

- 参考阅读：http://www.ha97.com/tag/%e5%8e%8b%e5%8a%9b%e6%b5%8b%e8%af%95
- `HTTP` 测试网站：http://httpbin.org/
- `FTP` 测试网站：http://speedtest.tele2.net/、https://test.rebex.net/

### Apache Bench（ab）

[`Apache Bench（ab）`](https://www.tutorialspoint.com/apache_bench/index.htm)是一个对`HTTP Web`服务器（**基于`HTTP/HTTPS`协议**）进行负载测试和基准测试的**开源免费、跨平台**的**单线程**命令行工具。

如果此前你已经安装了 `Apache Web Server`，那么 `ab` 工具应该也是一起自动安装了的。当然`ab`也可以单独作为`Apache`实用工具单独安装。

**注意：**

1. `ab`的负载测试类似于`DOS`攻击，没有指令可以在运行测试时按特定间隔增加/减少并发性（即：不能梯度加压测试或梯度减压测试-[JMeter可以实现加压测试](https://blog.csdn.net/qq_36396763/article/details/89472691)，但使用上没有`ab`简单）
2. 不论将 `ab` 的并发数设置到多大，`ab` 始终是通过**单线程**的方式来执行的，因此：当需要进行量级非常大的高并发测试时，`ab`本身单线程的处理能力却成了瓶颈从而导致**并发测试结果不准确**（一下子发起的请求或请求返回来的结果太多，`ab`自身处理不过来）！

> 原句：Apache Bench uses only one operating system thread irrespective of the concurrency level (specified by the -c flag). Therefore, when benchmarking high-capacity servers, a single instance of Apache Bench can itself be a bottleneck. To completely saturate the target URL, it is better to use additional instances of Apache Bench in parallel, if your server has multiple processor cores.

**因此：`ab` 更适合单一`URL`的非精准压力测试，如：服务端的接口！**

#### 安装

```sh
# Ubuntu/Debian
apt-get install apache2-utils

# RHEL/CentOS/Fedora
yum -y install httpd-tools
```

安装完毕之后，可以使用 `ab -V` 或 `ab -h` 验证安装是否成功！

![ab-verify-apache-bench-installation.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/ab-verify-apache-bench-installation.png)

#### 使用说明

`ab` 的功能定位都很简单，用法：`ab [options] [http[s]://]hostname[:port]/path`。

![ab-multiple-requests-testing.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/ab-multiple-requests-testing.png)

#### 参数

##### 请求设置

| 参数 | 作用 |
| ---- | ---- |
| -X <proxy:port> | 设置代理信息 |
| -P <proxy_user:proxy_password> | 设置代理网络认证 |
| -A <user:password> |  添加基本网络请求认证 |
| -E <certfile> |  指定客户端私钥证书 |
| -B <address> |  绑定出口`IP`地址 |
| -H <Header_string> |  设置额外请求头信息，如：'Accept-Encoding: gzip' （该参数可重复添加多个值）|
| -C <key=value> | 为请求头附加`Cookie`信息（该参数可重复添加多个值） |
| -n <requests> |  发起的请求次数 |
| -c <concurrency> |  并发请求数（！！！注意：并发数设置不能大于请求总数） |
| -t <timelimit> |  设置整个测试过程的时间限制-默认没有限制 |
| -s <timeout> |  设置测试过程中每一个请求的等待时间-默认为 30 秒 |
| -b <windowsize> |  设置`TCP`发送/接收缓冲区的大小，单位-字节 |
| -T <content-type> |  为`POST/PUT`请求设置`Header`中的`Content-type`。如：`'application/x-www-form-urlencoded'`-默认`'text/plain'` |
| -k | 使用 `HTTP KeepAlive` 持久连接功能 |
| -i |  使用 `HEAD` 而不是 `GET` 请求方式 |
| -m <method> | 设置`HTTP`请求方法 |
| -p <postfile> |  `POST`请求的文件数据（**记得设置`-T`参数**） |
| -u <putfile> |  `PUT`请求的文件数据 （**记得设置`-T`参数**） |

##### 打印结果

| 参数 | 作用 |
| ---- | ---- |
| -v <verbosity_level> |  设置输出信息的详细程度（1-打印测试结果；2-在上一个等级基础上额外增加打印请求头+打印警告信息；3-在上一个等级基础上额外增加打印响应头；） |
| -w |  用`HTML table` 方式将结果打印在`stdout`（通过管道重定向到文件便于查看、邮件） |
| -x <attributes> | 当使用`-w`参数输出时，在`<table>`标签的属性输出 |
| -y <attributes> | 当使用`-w`参数输出时，在`<tr>`标签的属性输出 |
| -z <attributes> | 当使用`-w`参数输出时，在`<td>`、`<th>`标签的属性输出 |
| -d | 不要显示请求百分比-毫秒时刻表 |
| -S | 不要打印结果 `warning` 级别信息 |
| -q | 当执行超过150个请求时，不显示进度 |
| -l | 接受可变的文档长度（用于动态页面） |
| -g <filename> | 将请求统计数据输出到文件（颇为鸡肋） |
| -e <filename> | 将请求进度-百分比数据输出到文件（颇为鸡肋） |
| -r | 不要在`socket`接收错误时退出 |

#### 结果分析

##### 服务器信息

- **Server Software** - `Web`服务器的名称，对应`HTTP Respone Headers`中`Server`的值，因此该值不一定有或正确
- **Server Hostname** - 服务器主机名
- **Server Port** - 服务器端口（80-http；443-https）
- **SSL/TLS Protocol** - 客户端和服务器之间协商的协议参数（只有使用了`SSL`才会有值）
- **Server Temp Key** - 服务器临时密钥信息（不一定有该结果）
- **TLS Server Name** - 公钥服务器名称

##### 传输信息

- **Document Path** - 测试的页面路径
- **Document Length** - 页面大小

##### （重点）压测结果

- **Concurrency Level** - 并发数（同一时间发起的）
- **Time taken for tests** - 整个测试过程的耗时
- **Complete requests** - 成功的请求数
- **Failed requests** - 失败的请求数
- **Total transferred** - 整个测试过程网络传输量（单位：字节）
- **HTML transferred** - 整个测试过程`HTML`传输量（单位：字节）
- **Requests per second** - 吞吐率（`RPS`-单位：reqs/s） = 成功总请求数(`Complete requests`) / 测试过程耗时（`Time taken for tests`）
- **Time per request** - 用户平均请求等待时间 = 总时间（`Time taken for tests`） / (总请求数-`Complete requests` / 并发用户数-`Concurrent Level`)
- **Time per request（across all concurrent requests）** - 服务器平均等待时间 = 总时间-`Time taken for tests` / 成功总请求数-`Complete requests`
- **Transfer rate** - 平均网络传输流量（可以帮助排除是否存在网络流量过大导致响应时间延长的问题）

##### 网络连接耗时-毫秒

> 格式：最小值、平均值、中位数、最大值

- **Connect** - `TCP` 连接耗时
- **Processing** - 服务端处理耗时
- **Waiting** - 等待耗时
- **Total** - 完整请求耗时


推荐阅读：
- [Apache的ab进行并发性能测试的注意点](http://www.piaoyi.org/linux/apache-ab-test.html)

### Siege

[`Siege`](http://xstarcd.github.io/wiki/shell/siege.html)是一个`HTTP Web`服务器负载测试和基准测试的**开源免费**的命令行工具。其支持：`HTTP`、`HTTPS`、`FTP`协议，但只能运行在类`Unix`系统之下（不支持`Windows`系统）。

相比于`ab`，`siege` 的压测更贴近真实用户，因为：
1. `siege`单次请求过程中是**模拟用户浏览器访问行为**，会将结果中涉及的资源链接都进行加载
2. `siege`可以支持从一堆链接中**随机**的进行访问

**因此：`siege` 更适合页面级`URL`的压力测试！**

#### 安装

```sh
# 1. 下载源码包
cd /tmp && wget -o /tmp/siege-latest.tar.gz http://download.joedog.org/siege/siege-latest.tar.gz

# 2. 解压源码包
tar -zxvf siege-latest.tar.gz

# 3. cd 进入解压目录，配置安装位置
./configure

# 4. 编译安装
make && make install
```

安装完毕之后，可以使用 `siege -V` 或 `siege -C` 验证安装是否成功！

![siege-verify-siege-installation.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/siege-verify-siege-installation.png)

#### 使用说明

`siege` 的功能定位都很单一-压测页面，用法：[`siege <options> [url]`](https://www.joedog.org/siege-manual/)。

![siege-multiple-requests-testing.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/siege-multiple-requests-testing.png)

##### 参数

注意：不同版本，参数支持不一样！！！

| 参数 | 作用 |
| ---- | ---- |
| -V, --version | 打印版本信息 |
| -h, --help | 打印帮助信息 |
| -C, --config | 打印当前`siege`配置信息 |
| -v, --verbose | 详细模式-打印详细信息 |
| -q, --quiet | 静默模式-不打印详细信息并抑制输出 |
| -p, --print | 打印模式-打印请求的`HTML`页面信息 |
| -c, --concurrent=NUM | 设置并发数-默认是每次10个并发
| -r, -reps=NUM | 设置请求次数 |
| -t, --time=NUMm | 持续长时间压测（S-秒, M-分, H-小时）
| -d, --delay=NUM | 在每个请求前随机的延迟指定时间（单位-秒） |
| -b, --benchmark | 请求之间没有延迟 |
| -i, --internet | 模拟用户请求，从`-f`指定的`URLs`中随机选择访问一条`URL` |
| -f, --file=FILE | 指定`URLs`文件 |
| -R, --rc=FILE | 指定`siege`的运行配置文件-默认的为`$HOME/.siegerc` |
| -l, --log[=FILE] | 将统计数据保存到日志文件中（可在`.siegerc`中自定义日志文件） |
| -m, --mark="string" | |
| -H, --header="string" | 设置`Request Headers` |
| -A, --user-agent="string" | 设置`User-Agent`的值 |
| -T, --content-type="string" | 设置 `Content-Type` 的值 |
| --json-output | 设置输出结果为 `json` 格式（注意：该参数会抑制详细模式的输出） |

`-f` 参数可以指定`URLs`文件，格式如下：
- `GET`请求-urls.txt
```txt
server=172.0.0.1:80
http://${server}/q?k1=v1&k2=v2
```

- `POST` 请求
```txt
server=172.0.0.1:80
http://${server}/q POST k1=v1&k2=v2
```

**!!!注意：使用 `siege` 进行请求的 `URL` 参数中若含有特殊字符或空格，需要先进行 `urlencode`，请求的时候加上 `-H 'Content-Type: application/x-www-form-urlencoded'` 请求头！**

##### 使用案例

公司的服务进行了服务器迁移，需要对迁移后的服务器、数据库等进行压测，其步骤如下：
1. 从`Nginx`的访问日志中拉取一天的数据下来，取出其中的访问 `URL` 放到 `urls.txt`中
2. 结合`Kibana`看板，查看流量高峰时段（由于是国外业务，高峰时段在下午的14:30-17:00之间）
3. 绑定新机器`hosts`，使用`siege`持续不断对新服务压测


```sh
# 单页面压测-对百度首页发起200个并发，100组请求，总共：2万次
siege -c 200 -r 100 https://www.baidu.com
```

```sh
# 每次都随机从urls.txt中列出所有的网址选取一条进行请求
siege -c 200 -r 100 -f urls.txt -i
```

```sh
# 每次都随机从urls.txt中列出所有的网址选取一条进行请求，每次请求之间不需要延迟
siege -c 200 -r 100 -f urls.txt -i -b
```

#### 结果分析

- **transactions** - 完成请求总次数
- **availability** - 请求成功率
- **elapsed_time** - 整个测试过程使用时间（单位-秒）
- **data_transferred** - 整个测试过程共传输数据字节大小
- **response_time** - 响应时间，显示网络连接的速度
- **transaction_rate** - 平均每秒完成的处理次数
- **throughput** - 平均每秒传送数据
- **concurrency** - 实际最高并发连接数
- **successful_transactions** - 成功处理次数
- **tailed_transactions** - 失败处理次数
- **longest_transaction** - 传输消耗最长的时间
- **shortest_transaction** - 传输消耗最短的时间


#### 使用`siege`可能会遇到的问题

1. `siege-4.0.4`以上版本`-v`详细模式无效

导致该问题的产生是因为`json output`的值为`true`（可以通过`siege -C` 查看当前加载的配置文件所在位置），抑制了详细模式、`stdout`的其余输出。

![siege-error-verbose-invalid.png](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/article/siege-error-verbose-invalid.png)

2. `siege-4.0.4`以上版本记录`log`日志失败-无法自动创建日志文件

将`~/.siege/siege.conf`的 `show-logfile` 配置设置为 `false` 抑制记录日志文件。如果需要记录日志文件，新版本需要先手动创建日志文件且保证权限无误才可以写入记录日志。

3. 修改`siege`最大并发数

根据机器的情况，`siege`默认的并发用户数是 `255`，由于`HTTP`是短连接，而机器的端口范围是：`0-65535`，如果想不限制并发数只需要将`~/.siege/siege.conf`配置中的`limit`属性值设置为 `65535` 即可！

但是，需要注意的是：
1. `siege` 工具每个并发都启用一个新的线程来执行比较消耗性能，因此设置的该值的时候请根据实际情况设置用户数量
2. 若`limit`设置为`65536`（即：不限制并发上限），当并发数太高的时候 `siege` 很容易将本地机器的端口耗尽，从而影响到其他程序的运行

4. 修复`siege`报`aborted due to excessive socket failure`问题（超过了`siege`的`TCP`连接数）

与“问题3-最大并发数”一样的原因导致的，只需要将`~/.siege/siege.conf`配置中的`failures`属性值设置为 `65535` 即可！

### 总结

1. 什么是`PV`、`UV`、`QPS`、`TPS`、`RT`、`Load-系统负载`、并发数、吞吐率？
    - [什么是PV、UV、TPS、QPS及影响服务端性能的因素](https://blog.csdn.net/Bao_jingyu/article/details/94391007)
    - https://blog.csdn.net/qq_39416311/article/details/84892625
    - [系统吞吐量（TPS）、用户并发量、性能测试概念和公式](http://www.ha97.com/5095.html)
    - [QPS 和并发：如何衡量服务器端性能](https://blog.csdn.net/Dallin0408/article/details/78853884)
    - [服务器-宝并发](https://blog.csdn.net/dallin0408/category_7356237.html)
2. 如何通过`TPS`估算需要多少台服务器？
3. 如何估算最大并发数？
4. Web开发中什么级别算是真正的高并发？
5. 做并发压测的时候，应当如何较为准确的评估并发数设置为多少合适呢？
6. 服务器性能监控应当监控哪些指标？如何查看这些指标？这些指标如何定义的？https://zhuanlan.zhihu.com/p/90303333

### wrk

- [怎样压测Web应用的性能？压测工具与测量、分析方法-李佶澳](https://www.lijiaocn.com/%E6%96%B9%E6%B3%95/2018/11/02/webserver-benchmark-method.html)
- [wrk用lua脚本构建复杂的http压力测试 – 峰云就她了](https://xiaorui.cc/archives/5098)
- [性能测试入门及JMeter、Gatling、ab、Siege、Wrk、Locust工具简介_gatling国产性能测试工具_johnny233的博客-CSDN博客](https://blog.csdn.net/lonelymanontheway/article/details/104601516)
- [Web 压力测试工具 wrk 安装及使用_Rock笔记 个人资源整理站](https://tytrock.com/topics/293)
- [几乎所有的WEB压力测试工具 WEB压力测试工具大全 , 流水理鱼](https://www.iamle.com/archives/2173.html)
- [小巧而强大的wrk压测工具 | Escape](https://www.escapelife.site/posts/4b014d0b.html)
- [web压力测试工具wrk安装及使用 - python技术的魅力 - SegmentFault 思否](https://segmentfault.com/a/1190000014591330)
- [HTTP 性能测试工具 wrk 使用介绍-谢先斌的博客](https://www.xiexianbin.cn/http/test/wrk/index.html)
- [HTTP 压测工具之 wrk | 独特的留白](https://zhoujunwen.com/2022/%E5%B7%A5%E5%85%B7/HTTP%E5%8E%8B%E6%B5%8B%E5%B7%A5%E5%85%B7%E4%B9%8Bwrk/index.html)
- [Web「性能测试」知多少？ - Jartto's blog](http://jartto.wang/2020/04/05/about-wrk/)
- [使用wrk一键式压测后台接口](http://www.fridayhaohao.com/articles/23/)
- [如何进行C100K性能测试 - SRE.im](https://sre.im/c100k-performance-test/)
- [29 最容易失准的性能测试？你需要压测工具界的“悍马”wrk](https://learn.lianglianglee.com/%E4%B8%93%E6%A0%8F/OpenResty%E4%BB%8E%E5%85%A5%E9%97%A8%E5%88%B0%E5%AE%9E%E6%88%98/29%20%E6%9C%80%E5%AE%B9%E6%98%93%E5%A4%B1%E5%87%86%E7%9A%84%E6%80%A7%E8%83%BD%E6%B5%8B%E8%AF%95%EF%BC%9F%E4%BD%A0%E9%9C%80%E8%A6%81%E5%8E%8B%E6%B5%8B%E5%B7%A5%E5%85%B7%E7%95%8C%E7%9A%84%E2%80%9C%E6%82%8D%E9%A9%AC%E2%80%9Dwrk.md)





## 网络工具

- https://www.zhihu.com/question/23042131
- https://support.huaweicloud.com/dns_faq/dns_faq_015.html
- https://www.cnblogs.com/zgq123456/p/9935597.html
- https://www.jianshu.com/p/ce96444f17d3
- https://www.cnblogs.com/EasonJim/p/10017100.html
- https://blog.csdn.net/qq_39686022/article/details/97215965
- https://zhuanlan.zhihu.com/p/354603203
- https://www.cnblogs.com/pipci/p/10496039.html#:~:text=%2Fetc%2Fresolv.conf%E5%AE%83,%E7%A9%BA%E6%A0%BC%E9%9A%94%E5%BC%80%E7%9A%84%E5%8F%82%E6%95%B0%E3%80%82
- https://cloud.tencent.com/developer/article/1366044?from=10680
- https://www.zhihu.com/question/48085305/answer/109256904
- https://www.whbwiki.com/2161.html
- https://cloud.tencent.com/developer/article/1366027
- https://www.huaweicloud.com/zhishi/ask018.html
- https://serverfault.com/questions/118923/difference-between-etc-hosts-and-etc-resolv-conf
- https://blog.csdn.net/qq_41201816/article/details/88760259
- Linux中的curl，telnet，ping测试网络指令区别 https://kknews.cc/code/3692bqg.html
- linux检测主机网络配置和状况的命令是,Linux常用网络状态测试命令
 https://www.elefans.com/category/jswz/da39e3f9fa9677afe638c77a09b2a416.html
- Linux：10个实用的网络和监控命令 https://cloud.tencent.com/developer/article/1072025

### ping

### traceroute

显示数据包到主机之间的路径，用于排查数据传输链路缓慢问题。

- [traceroute命令进行路由跟踪](http://c.biancheng.net/view/6408.html)
- [traceroute命令](https://blog.csdn.net/bangdingshouji/article/details/70805247)
- [Traceroute 详解](https://www.gingerdoc.com/traceroute-detail)

### nslookup（DNS查询工具）

[nslookup](https://blog.csdn.net/violet_echo_0908/article/details/52033725) 用于查询 DNS 的记录，查看域名解析是否正常，在网络故障的时候用来诊断网络问题.

`nslookup [<option>] <domain> [<dns-server>]`

### dig (Domain Information Groper-DNS 查询工具）

![a zine page about dig](https://wizardzines.com/comics/dig/dig.png)

`dig` 查询域名解析结果及解释

```sh
$ dig news.qq.com

; <<>> DiG 9.10.6 <<>> news.qq.com
这是 dig 程序的版本号与要查询的域名

;; global options: +cmd
;; Got answer:
以下是要获取的内容。

;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47559
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 0
这个是返回应答的头部信息：
1. opcode：操作码，QUERY 代表查询操作；
2. status: 状态，NOERROR 代表没有错误;
3. id：编号，在 DNS 协议中通过编号匹配返回和查询；
4. flags: 标志，含义如下:
   - qr：query，查询标志，代表是查询操作
   - rd：recursion desired，代表希望进行递归查询操作;
   - ra：recursive available，代表查询的服务器支持递归查询操作;
5. QUERY 查询数，与下面 QUESTION SECTION 的记录数一一对应；
6. ANSWER 结果数，与下面的 ANSWER SECTION 的记录数一一对应；
7. AUTHORITY 权威回复数，如果查询结果由管理域名的域名服务器而不是缓存服务器提供的，则称为权威回复。
             0 表示所有结果都不是权威回复；
8. ADDITIONAL 额外记录数；

;; QUESTION SECTION:
;news.qq.com.           IN  A
查询部分,从左到右部分意义如下:
1、要查询的域名；
2、要查询信息的类别，IN 代表类别为 IP 协议，即 Internet。
3、查询的记录类型，A 记录(Address)代表要查询 IPv4 地址。

;; ANSWER SECTION:
news.qq.com.        136 IN  CNAME   https.qq.com.
https.qq.com.       476 IN  A   125.39.52.26
回应部分，从左到右各部分意义：
1、对应的域名
2、TTL，time to live，缓存时间，单位秒，代表缓存域名服务器可以在缓存中保存的期限。
3、查询信息的类别
4、查询的记录类型，CNAME 表示别名记录，A 记录(Address)代表 IPv4 地址。
5、域名对应的 ip 地址。

;; Query time: 56 msec
;; SERVER: 202.106.0.20#53(202.106.0.20)
查询使用的服务器地址和端口,其实就是本地 DNS 域名服务器
;; WHEN: Thu Jul 11 15:59:37 CST 2019
;; MSG SIZE  rcvd: 65
查询的时间与回应的大小，收到 65 字节的应答数据。
```

`dig` 解析域名详细过程

```sh
$ dig +trace news.qq.com

; <<>> DiG 9.10.6 <<>> +trace news.qq.com
;; global options: +cmd
.           432944  IN  NS  g.root-servers.net.
.           432944  IN  NS  k.root-servers.net.
.           432944  IN  NS  b.root-servers.net.
.           432944  IN  NS  h.root-servers.net.
.           432944  IN  NS  i.root-servers.net.
.           432944  IN  NS  f.root-servers.net.
.           432944  IN  NS  d.root-servers.net.
.           432944  IN  NS  e.root-servers.net.
.           432944  IN  NS  j.root-servers.net.
.           432944  IN  NS  l.root-servers.net.
.           432944  IN  NS  c.root-servers.net.
.           432944  IN  NS  m.root-servers.net.
.           432944  IN  NS  a.root-servers.net.
;; Received 228 bytes from 202.106.0.20#53(202.106.0.20) in 45 ms
这些就是神秘的根域名服务器，由本地 DNS 服务器返回了所有根域名服务器地址。

com.            172800  IN  NS  g.gtld-servers.net.
com.            172800  IN  NS  a.gtld-servers.net.
com.            172800  IN  NS  b.gtld-servers.net.
com.            172800  IN  NS  m.gtld-servers.net.
com.            172800  IN  NS  d.gtld-servers.net.
com.            172800  IN  NS  c.gtld-servers.net.
com.            172800  IN  NS  j.gtld-servers.net.
com.            172800  IN  NS  h.gtld-servers.net.
com.            172800  IN  NS  f.gtld-servers.net.
com.            172800  IN  NS  l.gtld-servers.net.
com.            172800  IN  NS  e.gtld-servers.net.
com.            172800  IN  NS  k.gtld-servers.net.
com.            172800  IN  NS  i.gtld-servers.net.
;; Received 1171 bytes from 192.36.148.17#53(i.root-servers.net) in 57 ms
这里显示的是 .com 域名的 13 条 NS 记录，本地 DNS 服务器向这些顶级域名服务器发出查询请求，
询问 qq.com 的 NS 记录。

qq.com.         172800  IN  NS  ns1.qq.com.
qq.com.         172800  IN  NS  ns2.qq.com.
qq.com.         172800  IN  NS  ns3.qq.com.
qq.com.         172800  IN  NS  ns4.qq.com.
;; Received 805 bytes from 192.48.79.30#53(j.gtld-servers.net) in 331 ms
这里显示的是 qq.com 的 4 条 NS 记录，由 j.gtld-servers.net 这台服务器最先返回。
然后本地 DNS 服务器向这四台服务器查询下一级域名 news.qq.com 的 NS 记录。

news.qq.com.        86400   IN  NS  ns-cnc1.qq.com.
news.qq.com.        86400   IN  NS  ns-cnc2.qq.com.
;; Received 180 bytes from 58.144.154.100#53(ns4.qq.com) in 37 ms
这里显示的是 news.qq.com 的 NS 记录，它们是由上面的 ns4.qq.com 域名服务器返回的。
然后本地 DNS 服务器向这两台机器查询 news.qq.com 的主机名。

news.qq.com.        600 IN  CNAME   https.qq.com.
https.qq.com.       600 IN  A   125.39.52.26
;; Received 76 bytes from 223.167.83.104#53(ns-cnc2.qq.com) in 29 ms
这是上面的 ns-cnc2.qq.com 返回的最终查询结果：
news.qq.com 是 https.qq.com 的别名，而 https.qq.com 的 A 记录地址是 125.39.52.26
```

- [工程师最容易搞错的域名知识](https://zhuanlan.zhihu.com/p/73291638)
- [How to use dig](https://jvns.ca/blog/2021/12/04/how-to-use-dig/)

### netstat（查看网络状况）

- 查看端口是否在被监听 `netstat -atnl | grep <port>` 端口状态是不是LISTEN

### telnet

文章参考于：
- https://www.cnblogs.com/PatrickLiu/p/8556762.html
- https://wangchujiang.com/linux-command/c/telnet.html

telnet 命令可以用于登录远程主机，对远程主机进行管理。但是因为该协议采用明文传送报文，安全性不好，很多 Linux 服务器都不开放 telnet 服务，而改用更安全的 ssh 方式了。但 一些内网机器依然是会开放 telnet 服务的，便于排查问题。

![telnet Connection refused](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/telnet-refused.png)

telnet 经常被用来测试网络、指定服务端口是否正常开放。

- 检查是否安装 telnet 服务

```shell
# CentOS 安装 telnet
# telnet 是挂在 xinetd 底下的，所以同时查看是否安装了 xinetd 服务
rpm -qa | grep telnet
rpm -qa | grep xinetd

# 如果没有安装，则进行安装
yum install xinetd telnet telnet-server -y

# Ubuntu 安装 telnet
apt list --installed | grep telnet # 是否安装 telnet 客户端
apt list --installed | grep telnetd # 是否安装 telnet 服务端
apt list --installed | grep xinetd # 是否安装 xinetd 服务

sudo apt install -y telnet telnetd xinetd # 安装对应服务
```

- [How do I see what packages are installed on Ubuntu Linux?](https://www.cyberciti.biz/faq/apt-get-list-packages-are-installed-on-ubuntu-linux/)


- 检查 telnet 服务状态

```shell
# 查看 telnet 的 23 端口有没有开启
netstat -atnl | grep 23

# 查看 telnet.socket 服务是否开启（如果没有开启，需要 systemctl start telnet.socket）
systemctl status telnet.socket

# 查看 xinetd.service 服务（开启 telnet.socket 服务后需要重启一下 xineted 服务）
systemctl status xinetd.service # 通过 service xinetd status 管理
```


- 配置 telnet 服务

`/etc/xinetd.d/telnet` 可能不存在，直接创建即可，创建完，重启 xinetd 服务。

[xinetd Configuration Files](https://web.mit.edu/rhel-doc/3/rhel-rg-en-3/s1-tcpwrappers-xinetd-config.html)

```
# 通过 chkconfig 设置开机自启： chkconfig telnet on
# 然后通过 chkconfig --list 可以查看到对应服务设置了开启

# flags           = REUSE    #REUSE表示可以被多次访问，不定义默认也是REUSE
# socket_type     = stream # 套接字类型
# wait            = no  # 是否等待，UDP协议应该设置为不等待，TCP的看需要
# user            = root # 运行telnet服务的身份
# server          = /usr/sbin/in.telnetd #定义telnet服务应用程序路径
# log_type        = FILE /var/log/telnet.log #自定义日志路径
# log_on_failure  += USERID  #登录失败返回用户的执行者识别编号
# disable         = no  # 启用，yes 禁用
# only_from       = 192.168.0.0/16 # 只允许这个网段的 IP 访问
# no_access       = # 指定不不允许访问的 IP
# access_times    = 9:00-18:00  # 指定允许连接的时间段
# bind            = 172.16.100.1 # 只允許監聽在此IP的端口上
# cps             = 10   30  # 每秒鐘只接受10個請求 超過以後臨時禁用30秒
# per_source      = 1  # 每個單獨的IP在同一時間只允許發起一個請求
# instances       =  100    # 最多允許100個用戶同時連接
# banner          =/etc/telnet.banner # 指定文件，顯示文件內容為歡迎標語

service telnet
{
        flags           = REUSE
        socket_type     = stream
        wait            = no
        user            = root
        server          = /usr/sbin/in.telnetd
        log_on_failure  += USERID
        disable         = no
}
```

- 检查防火墙是否开放 23 端口对外访问：要看是通过 iptables 还是 firwall 进行管理的，具体情况具体看。

```shell
vi /etc/services 
# 在文件中找 `telnet 23/tcp`、`telnet 23/udp` 意味着开放了 23 端口的访问.
```


- telnet 服务管理 `systemctl start/stop/reload/restart/try-restart/status <name>`
- 连接 : `telnet <ip/host> <port>`
- 断开： `ctrl+]` 断开当前 telnet 的服务端口，然后再输入 `quit` 或 `q` 退出。


### screen 的简单记录

https://www.cnblogs.com/mchina/archive/2013/01/30/2880680.html

- `screen -ls` 列出当前所有的会话
- `screen -S <yourname>` 新建一个叫 yourname 的会话
- `screen -d yourname` 远程操作离开名字叫 yourname 的会话（Ctrl-a/d 快捷键）
- `screen -r yourname` 恢复到 yourname 的会话连接
- `screen -d -r yourname` 结束当前会话并回到 yourname 这个会话
- `Ctrl + a + d` 暂时离开当前session，将目前的 screen session (可能含有多个 windows) 丢到后台执行

### tmux

Tmux 是一个终端复用器（terminal multiplexer），和 Screen 一样，但是比它更简单易用。

用户打开一个终端窗口（terminal window，以下简称"窗口"）临时连接上服务器，称为一个“会话（Session）”。

因为网络等各种原因，当前会话闪断之后，重新登录上去是找不回上一次的会话记录的，随着会话的中断，与之共存的进程也会被一并中断。

Tmux、Screen 等就是将`会话-窗口`进行解绑的工具，使得窗口中断而会话不会中断，会话中的命令也可以继续执行，等需要之后再让会话与其他的窗口进行绑定。

https://www.ruanyifeng.com/blog/2019/10/tmux.html

https://pragmaticpineapple.com/gentle-guide-to-get-started-with-tmux/

## 如何查看出口IP？

想查询自己的出口 IP 是多少，之前都是通过访问 [IP138.com](https://www.ip138.com/) 和 [IP.cn](https://ip.cn/) 的方式来得到出口 IP。今天碰到同事在问出口IP的问题，想了一下：命令行下如何查看自己的出口 IP (公网IP)呢？

在验证网上查阅的方法时，也遇到了一点小问题：之前一直用上述两个地址进行查询出口 IP，但是却没有仔细对比过，今天仔细一对比，居然发现两个站点给出的结果不一样。

问了公司的运维同事得到了解惑，遂记录于此。

**总结：**

- **同一个 WiFi 连接多台电脑，其出口 IP 不一定一样**
- **同一个网络环境访问不同的网站其出口 IP 不一定一样**
- **IP 的出口地址取决于 网络的NAT 和 网络出口策略**



### 国内出口查询：

- 网站：[ipw.cn/](https://ipw.cn/)、[ip138.com/](https://www.ip138.com/) 、 [cip.cc/](http://www.cip.cc/)、[IPIP](https://www.ipip.net/myip.html)

```shell
lms@LMS:~$ curl cip.cc

IP      : 14.xx.xx.xx4
地址    : 中国  广东  广州
运营商  : 电信

数据二  : 广东省广州市 | 电信

数据三  : 中国广东广州 | 电信

URL     : http://www.cip.cc/14.xx.xx.xx4
```

```shell
lms@LMS:~$ curl -s myip.ipip.net

当前 IP：14.xx.xx.xx4  来自于：中国 广东 广州  电信
```


### 国外出口IP查询

- 国外 https://ipinfo.io

```shell
lms@LMS:~$ curl ipinfo.io
{
  "ip": "103.xxxx.xxxx.97",
  "city": "Guangzhou",
  "region": "Guangdong",
  "country": "CN",
  "loc": "2x.xxx7,1xx.xxx0",
  "org": "AS137995 Shuangyu Communications Technology Co., Limited",
  "timezone": "Asia/Shanghai",
  "readme": "https://ipinfo.io/missingauth"
}
```

- 国外 https://ifconfig.me/

```shell
lms@LMS:~$ curl ifconfig.me

103.xxxx.xxxx.97
```

- 国外：http://ifconfig.io/

```shell
lms@LMS:~$ curl ifconfig.io

103.xxxx.xxxx.97
```

- 国外：http://httpbin.org/ip

```shell
lms@LMS:~$ curl httpbin.org/ip

{
  "origin": "103.xxxx.xxxx.97"
}
```

- https://checkip.amazonaws.com
- https://api.ipify.org
- https://icanhazip.com
- https://ipecho.net/plain
- https://checkipv4.dedyn.io

### 通过 Shell 脚本获取功出口 IP

```shell
#!/bin/bash

# This script try to ensure gets the current IP address (as assigned by the ISP) from
# OpenDNS and other online services as fallbacks

hosts=("checkip.amazonaws.com" "api.ipify.org" "ifconfig.me/ip" "icanhazip.com" "ipinfo.io/ip" "ipecho.net/plain" "checkipv4.dedyn.io")

CURL=`which curl`
DIG=`which dig`

check=$($DIG +short myip.opendns.com @resolver1.opendns.com A) 

if [ ! $? -eq 0 ] || [ -z "$check" ] || [[ ! $check =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Unable to get your public IP address by OpenDNS service, try to another way."
    count=${#hosts[@]}

    while [ -z "$check" ] && [[ $count -ne 0 ]]; do
        selectedhost=${hosts[ $RANDOM % ${#hosts[@]} ]}
        check=$($CURL -4s https://$selectedhost | grep '[^[:blank:]]') && {
            if [ -n "$check" ] && [[ $check =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                break
            else
                check=""
                count=$(expr $count - 1)
                echo "The host $selectedhost returned an invalid IP address."
            fi
        } || {
            check=""
            count=$(expr $count - 1)
            echo "The host $selectedhost did not respond."
        }
    done
fi

if [ -z "$check" ]; then
    echo "Unable to get your public IP address. Please check your internet connection."
    exit 1
fi

echo "Your public IP address is $check"

exit 0
```

## 用Linux命令行生成随机密码

- [利用pwgen、mkpasswd、tr自动更改密码](http://www.361way.com/autochangpasswd/396.html)
- [用Linux命令行生成随机密码的十种方法](https://www.361way.com/linux-random-password/3087.html)

方法很多，选择记录几种简单的。

方法1：通过 openssl 的随机函数

```shell
openssl rand -base64 32
```

方法2：通过 SHA 算法对日期进行加密并获得输出结果前 32 位字符

```shell

```