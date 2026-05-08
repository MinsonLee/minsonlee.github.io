```sh
# 安装依赖扩展，可通过`yum list | grep 包名`查看是否已经安装
yum -y groupinstall development # 先预先安装

yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel


# 下载Python最新源码：https://www.python.org/downloads/source/
# 国外访问速度太慢，尝试国内地址：https://www.newbe.pro/Mirrors/Mirrors-Python/
curl -L "https://mirrors.huaweicloud.com/python/3.9.0/Python-3.9.0.tgz" -o /tmp/Python-3.9.0.tgz

# 解压
cd /tmp/ && tar -zxf /tmp/Python-3.9.0.tgz 

# 编译前配置安装位置
mkdir -p /apps/python3.9.0 && ./configure --prefix=/apps/python3.9.0

# 编译安装
make install

# 添加二进制可执行文软链到/usr/local/bin目录下，便于全局使用
ln -s /apps/python3.9.0/bin/python3 /usr/local/bin/python3
ln -s /apps/python3.9.0/bin/pip3 /usr/local/bin/pip3

# 检验是否安装成功，打印 Python3 Version、pip3 Version
python3 -V
pip -V
```
![print python3 version](00B362CD3912440AA0CF659C66C74524)

> 本来我想卸载 python2 版本及修改 python 的软链，使用`yum remove python`发现卸载失败，网上查了一下：建议不要卸载，因为Python2 和 Python3 的差异较大，部分Linux系统工具依赖python执行，因此系统不予直接卸载