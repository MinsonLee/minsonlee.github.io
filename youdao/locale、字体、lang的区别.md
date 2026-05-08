> - https://blogs.gnome.org/raywang/2007/01/29/locale-%E8%AE%BE%E5%AE%9A/
> - https://blogs.gnome.org/raywang/2007/01/29/gdb%e8%b0%83%e8%af%95%e7%b2%be%e7%b2%b9%e5%8f%8a%e4%bd%bf%e7%94%a8%e5%ae%9e%e4%be%8b%e8%bd%ac/
> - https://blog.csdn.net/hansoft/article/details/958375
> - https://blog.csdn.net/wlwlwlwl015/article/details/51482065
> - https://zj-linux-guide.readthedocs.io/zh_CN/latest/tool-install-configure/[LOCALE]%E5%AD%97%E7%AC%A6%E9%9B%86%E8%AE%BE%E7%BD%AE/
> - https://liyucang-git.github.io/2019/06/17/%E5%BD%BB%E5%BA%95%E5%BC%84%E6%87%82Unicode%E7%BC%96%E7%A0%81/
> - [简单谈一谈字符编码这点事儿](http://chengxu.org/p/519.html)
> - 如何修改 locale ： https://cloud.tencent.com/developer/article/1671446

`locale` 指的的是当前操作系统的语言环境，如：你当前系统是用中文、英文、还是泰文，但要注意这仅仅是你当前系统本身的语言环境，跟你通过浏览器上网能否正常浏览中文、英语、法语这些没有直接关系。在 Linux 下，所有支持的语言环境配置都放在 `/usr/share/i18n/locales` 目录下

`fonts` 指的是字体。假如我当前将系统语言设置为英语的语言环境，那我浏览一个中文网站是不是就不能浏览或者是乱码了呢？这显然是不合理也不利于网络传播的。

具体的过程如下：网页内容通过网络传输到我们的电脑上以后，浏览器自身会根据网页中设定的**字符集编码**（若没有设定，则浏览器自身进行相应判断），根据网 页采用的字符集，在用户计算机本地操作系统的字体库中寻找合适的**字体**，然后通过文字渲染工具把相应的文字在屏幕上显示出来。

因此，虽然我们指定了系统的语言环境，但是我们可以发现操作系统本身依然会安装很多字体文件（Windows 系统在 `C:\Windows\Fonts` 文件夹下；Linux 系统在 `/usr/share/fonts` 文件下）。一般常见的字体文件格式有 `*.ttf` - TrueTypes字体文件， `*.ttc` - TrueTypesCollection字体文件（`ttc`文件实际是 Microsoft 开发出来的一种新字体格式标准，其实就是多个`ttf`文件的合集，共享同一笔划信息，可以有效地节省了字体文件所占空间，增加了共享性）。

上面还提到了一个**字符集编码**的概念。在 Linux 下，所有的字符集编码方式都放在 `/usr/share/i18n/charmaps` 目录下

==总结：`locale` 决定了你看到的系统习惯以及能输入什么语言；而字体是将对应语言渲染出来的载体==

```cmd
# Windows 下通过 powershell 获取语言环境
Get-Host

Get-UICulture
```

![Windwos Get Locale With Command](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/windows-get-locale-with-commond.png)

```cmd
# Windows 获取(设置)编码字符集：https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/chcp
chcp
```

Code page | Country/region or language
-----|----------
936 | 中国 - 简体中文(GB2312)
949 | 韩文
950 | 繁体中文(Big5)
1200 | Unicode
1201 | Unicode (Big-Endian)
52936 | 简体中文(HZ)
65000 | Unicode (UTF-7)
65001 | Unicode (UTF-8)

![Windows chcp](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/windows-chcp.png)

```shell
$ locale

LANG=zh_CN.UTF-8 # 语言
LC_CTYPE="zh_CN.UTF-8" # 语言符号及其分类
LC_NUMERIC="zh_CN.UTF-8" # 数字
LC_TIME="zh_CN.UTF-8" # 时间
LC_COLLATE="zh_CN.UTF-8" # 比较和排序习惯
LC_MONETARY="zh_CN.UTF-8" # 货币单位
LC_MESSAGES="zh_CN.UTF-8" # 提示信息及菜单信息等
LC_PAPER="zh_CN.UTF-8" # 默认纸张尺寸大小信息
LC_NAME="zh_CN.UTF-8" # 姓名书写方式
LC_ADDRESS="zh_CN.UTF-8" # 地址书写方式
LC_TELEPHONE="zh_CN.UTF-8" # 电话号码
LC_MEASUREMENT="zh_CN.UTF-8" # 度量衡表达方式
LC_IDENTIFICATION="zh_CN.UTF-8" # 对locale自身包含信息的概述
LC_ALL=

# 优先级：LC_ALL > LC_* > LANG
```


通过 html2pdf 在服务器将日语/韩语页面渲染，转为 PDF 文件，发现文件的日语、韩语字体乱码。


通过 `yum install -y fonts-japanese-0.20061016-6.fc7.noarch.rpm` 和 `yum install -y fonts-korean-1.0.11-9.1.1.noarch.rpm`

- [如何在CentOS安装RPM包](https://www.myfreax.com/how-to-install-rpm-packages-on-centos/)
- [fonts rpm 包](https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/7/Fedora/x86_64/os/Fedora/)
- [google-noto-sans-korean-fonts-20141117-5.el7.noarch.rpm](https://centos.pkgs.org/7/centos-x86_64/google-noto-sans-korean-fonts-20141117-5.el7.noarch.rpm.html)
- [CentOS package 包](http://mirror.centos.org/)