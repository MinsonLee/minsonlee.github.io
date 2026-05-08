- GOPATH : 所有 Go 项目的依赖包都会被拉取下来到设定的 GOPATH 环境变量目录下，随着项目的增加，GOPATH 越来越大。
    - 然后去 $GOROOT/src 下去找对应的包
    - 最后再去 $GOPATH/src 目录下去找对应的包

如果不同项目对同一个包的依赖是不同版本的如何处理呢？？？GOPATH 是解决不了

- GOVENDOR : GOVENDOR 正是为了解决 GOPATH 不能解决的版本问题而诞生的一个打补丁方式
    - 如果 $GOPATH/src/<projectName>/vendor/ 存在，先去这个目录下找依赖
    - 找不到，再通过 GOPATH 的方式去寻找
    - 第三方依赖管理工具： glide、dep、go dep


- GOMOD : 在 `go 1.11` 版本推出，随着不断的完善，目前官方已经正是推荐大家使用这种方式来进行管理依赖包了。
    - 开启 GOMOD 模式 : `go env -w GO111MODULE=on` 【`go1.13` 版本之前默认是关闭GOMOD模式的】
    - 设置 GOPROXY 代理 : `go env -w GOPROXY=goproxy.cn,goproxy.io,direct`
    - 设置私有依赖包地址 : `go env -w GOPRIVATE="xxx"`
    - 初始化 GOMOD : `go mod init <mod_path>` 然后 。依赖包会被下载到 $GOPATH/pkg/mod/ 下
    - 获取依赖包 : `go get <url>[@version]` 即可，或者直接在代码里 import，编译的时候会自动的拉取。
    - 清理 go.sum 中的依赖包管理 : `go mod tidy`

```txt
usage: go mod init [module]

Init initializes and writes a new go.mod to the current directory,
in effect creating a new module rooted at the current directory.
The file go.mod must not already exist.
If possible, init will guess the module path from import comments
(see 'go help importpath') or from version control configuration.
To override this guess, supply the module path as an argument.
```

如何将 GOPATH 项目迁移到 GOMOD 中呢？？？

先执行 `go mod init <module_name>` 然后 `go build ./...` 自动将当前目录及子目录用到的依赖加到 go.sum 中。

`go build <go_file>` 编译指定的 GO 文件产生一个可执行程序，但是 `go build ./...` 只会进行编译检查，需要 `go install ./...` 才会进行递归编译产生可执行文件，这些可执行文件会被放到 `$GOPATH/bin/` 目录下

- https://time.geekbang.org/column/article/429941
- https://segmentfault.com/a/1190000020543746