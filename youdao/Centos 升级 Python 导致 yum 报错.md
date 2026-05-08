## 背景描述
> CentOS 默认自带安装 Python，但安装都是 Python2.x 的版本。随着 Python 发展至 3.x 版本，Github 上非常多的工具都明码标价的写到：支持 `Python3`。于是决定对 CentOS 上的 Python 进行一波升级

## 问题描述
> 顺利升级到了 Python3.6 版本，重定了软连 `ln -s /usr/python3.6 /usr/python`，准备执行 `sudo yum install python36u-pip` 的时候，报错了，错误如下：

```sh
File "/usr/bin/yum", line 30
    except KeyboardInterrupt,^ e:
    
SyntaxError : invalid syntax
```
![https://img-blog.csdn.net/20160825153731032](https://img-blog.csdn.net/20160825153731032)

## 问题原因
`/usr/yum` 源码如下
```sh
#!/usr/bin/python
import sys
try:
    import yum
```

> - 由源码可看出：yum 是由 python 进行编写的，没升级前 yum 是可以正常运行的，升级后异常，鉴于：Python3.x 与 Python2.x 是不向下兼容版本的，大大的怀疑可能是 Python 版本升级导致
> - 查阅结果如下： yum 包管理是使用 python2.x 写的，我将 python2.x 升级到 python3.x，并将 `python` 的软连重定为了 `python3.6` 以后，由于 python 版本语法兼容性导致问题出现


## 问题解决方案
> `#!/usr/bin/python` 表明：该脚本为是一个 python 脚本，使用指定位置的 python 编译器进行编译该脚本

1. 可以将 `/bin/python` 的软连重写定义回 python2.x 的版本，那么系统默认的 python 编译器依然还是会使用 2.x 版本，但是：python3.x 的执行就需要每次都写 `python3.x xxx` 来执行，而我升级 python 的版本就是为了要将系统的默认版本改为 python3.x，显然这不符合我的初衷，也不推荐。
> 如果你需要使用 python2.x 版本的概率明显要大于 python3.x 版本的时候，还是比较推荐重写软连回 pyhton2.x 版本的。

2. 更改 `/bin/yum` 脚本：将  `#!/usr/bin/python` 改为 `#!/usr/bin/python2.7` 那么 yum 就会使用 `/usr/bin/python2.7` 的编译器进行编辑 yum 脚本了