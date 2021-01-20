---
layout: post
title: MySQL命令行神器-mycli
date: 2021-01-20
tags: [Tools,mysql]
---

`MySQL` 的客户端很多首推 `Navicat`，但工作中总是避免不了要在漆黑的命令行下操作 `MySQL`，使用其自带的 `mysql-client` 工具体验并不算太好。

`MyCLI` 是一款使用 `python` 语言开发的支持 `MySQL`、`MariaDB` 和 `Percona` 数据库的终端工具，具有提示、自动补全、使用高危命令时二次确认等等人性化的功能。同时 `mycli` 命令完全继承了 `mysql` 命令中的参数，因此熟悉 `mysql` 的人都能快速上手使用，学习成本低！

`MyCLI` 基于 `Python` 开发，因此安装 `MyCLI` 需要先安装 `Python` 和 `Python`包管理器-`Pip`。

1. [查看是否安装 python](https://www.runoob.com/python3/python3-install.html)

```sh
python --version
```

2. [查看是否安装 pip](https://www.runoob.com/w3cnote/python-pip-install-usage.html)

```sh
pip --version
```


3. [安装 `mycli`](https://www.mycli.net/install)

```sh
pip install mycli
```

![mycli-install-verify.png](/images/article/mycli-install-verify.png)

`MyCLI` 对应文档，个人觉得是非常好：简单、明了！没有像其他手册一样，长篇大论，一股脑子输出，详细使用可查看下述文档或输入 `mycli --help` 查看帮助说明，不再赘述！

- `MyCLI` 的官网：[https://www.mycli.net/](https://www.mycli.net/)
- `MyCLI` 的手册：[https://www.mycli.net/docs](https://www.mycli.net/docs)
- `MyCLI` 的配置文件说明：[https://www.mycli.net/config](https://www.mycli.net/config)【首次使用`mycli`时会自动创建`~/.myclirc`】
- 网易游戏基础架构平台-知乎介绍（中文简介）：https://zhuanlan.zhihu.com/p/101697361
