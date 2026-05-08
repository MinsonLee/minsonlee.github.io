[TOC]
## chm阅读器：
1. Kchmviewer ==> sudo apt-get install kchmviewer
2. ChmSee -- 这个中文可能会乱码

# 解压
1. 7-zip
2. 命令
```
1. *.tar 用 tar –xvf 解压
2. *.gz 用 gzip -d或者gunzip 解压
3. *.tar.gz和*.tgz 用 tar –xzf 解压
4. *.bz2 用 bzip2 -d或者用bunzip2 解压
5. *.tar.bz2用tar –xjf 解压
6. *.Z 用 uncompress 解压
7. *.tar.Z 用tar –xZf 解压
8. *.rar 用 unrar e解压
9. *.zip 用 unzip 解压
```

## Markdown
1. Haroopad ==> sudo apt-get install Haroopad
2. Remarkable ==> sudo apt-get install remarkable

## Nginx
1. [Nginx安装](https://www.nginx.com/resources/wiki/start/topics/tutorials/installoptions/)
2. [Nginx安装--脚本之家](http://www.jb51.net/article/103703.htm)
2-1. [安装openssl报错](http://www.mamicode.com/info-detail-1474506.html)
3. [prce下载]( http://www.pcre.org/)
4. [Nginx安装](http://inotgaoshou.iteye.com/blog/962946)
4. [lamp安装](https://www.cnblogs.com/yangxia-test/p/4174372.html)

## ./configure参数
- Nginx检测配置
```
./configure --prefix=/data/lnamp/nginx1.13.8/ --with-http_stub_status_module --with-http_ssl_module --with-openssl=/usr/bin/openssl
```

## 查找软件路径
- whereis openssl 
- which openssl 
- find / | grep ".*openssl.*"