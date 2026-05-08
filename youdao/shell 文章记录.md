
## 关于 Shell 的坑

- [网道-阮一峰-Bash 脚本教程](https://wangdoc.com/bash/)
- [常见的Shell大坑](https://chen3961.github.io/2019/06/10/Ten-black-hole-in-bash/)

1、`=` 两边不能有空格，如：`hello = "hello"` 这是错误的写法，`hello="hello"` 这是正确的写法

2、谜一样的分割

```shell
a=( "Over Great Wall" "Hello world" )
for i in ${a[@]}
do
	echo $i
done
echo "-------------------"
for ((i=0;i<${#a[@]};i++))
do
	echo ${a[$i]}
done
```

输出的结果

```txt
Over
Great
Wall
Hello
world
-------------------
Over Great Wall
Hello world
```

`[@]`是游标的意思，想遍历数组中的元素用的是：`${a[@]}` 这么个奇怪的符号；想获取数组的长度用 `${#a[@]}`。

**！！！注意：两者的结果可能不一致**

3、谜一样的分割-2

`a=A b=B ls` 能正常赋值并运行，但是 `ls ll` 却只会被当成一条命令

4、对于 `+=` 算数运算符的理解

`((...))` 语法可以进行整数的算术运算，当在 `(( a += 1))` 表示算数运算符：加等于； 

但是...

`+=` 在其余情况下表示的是：追加！

如：


## Shell 获取传递参数

- [.sh获取所有传递参数_如何在Linux中给shell脚本传参数，位置参数变量简单应用案例...](https://blog.csdn.net/weixin_39884832/article/details/113039246)
1. `$0` 命令自身
2. `$n` 命令后的第 n 个参数
3. `$*` 不含 `$0` 的其余所有参数
4. `$@` 含 `$0` 的所有参数
5. `$#` 表示 `$*` 的个数
6. `$?` 获取上一条命令执行的返回值
7. `$_` 获取上一条命令的最后一个参数（`alt + .` 快捷键可以键入）

## 优秀荐读

- [京东技术：Shell在日常工作中的应用实践](https://mp.weixin.qq.com/s/ZADE9oh9zOxRCopAyKJn-Q)