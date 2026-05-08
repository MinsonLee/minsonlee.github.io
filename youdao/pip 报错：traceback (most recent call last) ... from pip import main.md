```sh
$ pip --version

Traceback (most recent call last):
File "/usr/local/bin/pip", line 9, in <module>
from pip import main
```

导致原因：`pip`的版本和当前默认`python`不兼容导致！


解决方法：

1. 将 `/usr/bin/pip` 文件中：

```python
from pip import  main
if __name__ == '__main__':
    sys.exit(main())
```

改为：
```python
from pip import __main__
if __name__ == '__main__':
    sys.exit(__main__._main())
```

2. 重新安装`pip`
```sh
# 获取 pip 安装 python 脚本
wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py 

# 使用默认的`python`执行安装脚本
sudo python /tmp/get-pip.py
```

- https://www.cnblogs.com/chax/p/9409353.html