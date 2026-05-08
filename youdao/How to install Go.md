[toc]
## 1.How To Install Go
官方网站：http://golang.org,下载对应平台的安装包
> 如果是x86的系统可以就下载i386的，如果是x64的系统，则安装amd64即可
> 【Go语言在Windows下的的安装包有两种：msi和zip的,zip的是免安装的，解压在配置一些环境变量之后就可以使用,msi则是安装程序,会自动帮你设置好环境变量(但可能会遗漏)】

## 2.How to setting the PATH for Go ?
- [x] GOROOT：Go的安装目录
- [x] GOPATH：用于存放Go语言Package的目录，这个目录不能在Go的安装目录中
- [x] GOBIN：Go二进制文件存放目录【Windows下写成%GOROOT%\bin就好,Linux下写为$GOROOT/bin】
- [x] GOOS：操作系统【windows | linux】
- [x] GOARCH：指定系统环境，i386表示x86，amd64表示x64
- [x] PATH：需要将GOBIN加在PATH变量的最后，方便在命令行下运行Go【Windows使用分号;作为路径的分割,Linux使用冒号:作为PATH中路径的分割】
> 安装完毕之后,可以使用`go env`检验是否已经设置完毕

![`go env` 检查环境变量](http://r12f-cdn.azureedge.net/r12f-assets/post_assets/2013-10-01-learning-golang-1-building-dev-environment-on-windows/go-env.png)