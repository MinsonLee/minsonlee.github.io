Window 7 下如果你想玩 Docker，可以通过 DockerToolbox 进行安装，但问题是真的很多，因为这个方式还是依赖于虚拟机-VirtualBox、Git等客户端，需要格外注意的是 DockerToolbox 和 VirtualBox 的版本搭配。

如果是个人学习使用，建议转战 `Window10 + WSL2`，如果钱允许可以买台云服务器或换个 `Mac Book`，当然最好的还是到 `Linux` 上面玩。

## 问题

- 当前系统：Windows 7
- 问题：**启动 `Docker Quickstart Terminal` 的时候，报下述错误**
```
缺少快捷方式：Windows 正在查找 bash.exe 。如果想亲自查找文件，请点击"浏览"。
```

![缺少快捷方式 bash.exe](5AA1F72FB2EA44C4ABE629559AB8BFC8)

## 导致原因
1、在安装 Docker 环境前，我就已经安装了 Git 或 VirtualBox 等工具，所以在使用 Docker Toolbox 安装 Docker 套装时，没有勾选同步安装 Git 和 VirtualBox 等应用程序

2、`Docker Quickstart Terminal` 启动时无法找到 Git 安装目录下的 `bash.exe` 程序， `Docker Quickstart Terminal` 默认会去加载 `C:\Program Files\Git\bin\bash.exe`，因此导致上述报错：**缺少快捷方式**

![Docker Quickstart Terminal 属性](9F6F7982351A42B9B42AB8089732EAA1)


## 解决措施
> 点击 "浏览"，选择 Git 安装目录下 `bin>bash.exe` 程序即可解决(该方式只能单次解决问题)

将 `Docker Quickstart Terminal` 快捷方式属性下的 `目标` 中的 `bash.exe` 路径修改为 ` Git 安装目录 > bin > bash.exe` 即可。