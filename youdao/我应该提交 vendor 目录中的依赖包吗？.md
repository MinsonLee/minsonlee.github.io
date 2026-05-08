# 我应该提交 vendor 目录中的依赖包吗？

[TOC]

> - 来源：composer 中文文档
> - 链接：https://docs.phpcomposer.com/faqs/should-i-commit-the-dependencies-in-my-vendor-directory.html
> - 库的锁文件：https://docs.phpcomposer.com/02-libraries.html#Lock-file


## 关于 composer.lock 导致发布失败复盘

### 问题

**描述：** 
> 在 ERC 的 account.api 项目中，发现项目中依赖，只有 composer.json 跟了版本依赖，而： composer.lock 和 vendor 都没有跟随依赖版本走

**导致问题“错”施**
> - 将 composer.lock 添加到了版本跟踪
> - 将 vendor 目录进行了版本忽略


### 原因
1. ERC 的发布是直接使用 composer update 命令进行检查依赖是否更新或需要安装，并没有使用 install 命令
    - 线上或预发布的依赖并不是没有根据 composer.lock 来创建依赖关系，可能会导致生产/预发布环境的 vendor 目录和测试环境不一致
2. 原目录中 composer.lock 文件已经存在，composer update 会更新 composer.lock 文件，此时再使用 git pull 代码的时候，composer.lock 文件会冲突，导致发布失败





## 文章

一般情况下**不建议**。`vendor` 目录（或者你安装依赖的其它目录）都应该被添加进 `.gitignore/` `svn:ignore/`等等。

**最好这么做，然后让所有开发人员使用 Composer 来安装依赖包**。同样，build server、CI、deployment tools 等等，应进行修改，使运行 Composer 成为其项目引导的一部分。

虽然在某些环境下提交它是很让人心动的，但它将导致一些问题：

- 当你更新代码时，将极大的增加 VCS 仓库的体积和差异。
- 在你自己的 VCS 中将产生与你依赖的资源包重复的历史记录。
- 通过 git 的一个 git 仓库安装添加依赖，将把它们视作子模块。这是有问题的，因为它们并不是真正的子模块，并且你将会遇到这些问题。


如果你真的觉得你必须这样做，你有几个选择：

1. 限制自己安装标记版本（无 dev 版本），这样你只会得到 zip 压缩的安装，并避免 git“子模块”出现的问题。
2. 使用 --prefer-dist 或在 config 选项中设置 preferred-install 为 dist。
3. 在每一个依赖安装后删除其下的 .git 文件夹，然后你就可以添加它们到你的 git repo 中。你可以运行 rm -rf vendor/**/.git 命令快捷的操作，但这意味着你在运行 composer update 命令前需要先删除磁盘中的依赖文件。
4. 新增一个 .gitignore 规则（vendor/.git）来忽略 vendor 下所有 .git 目录。这种方法不需要你在运行 composer update 命令前删除你磁盘中的依赖文件。





## 关于 ERC 发布系统的思考？
1. 为什么 ERC 建议开发者将 vendor 目录提交到版本控制中？

>- 预发布/生产机在美国，gitlab服务在香港，发布代码到测试/预发布/生产 时， composer 拉取组件的速度，太慢了...导致发布过程异常的冗余 ==> 建立内部镜像源，优化拉取速度
>- 当前PHP的版本仍然比较旧，每次发布的时候都重新 composer install 完全重新安装依赖，有可能新安装的依赖中会有 PHP7 的新特性语法等出现，导致代码报错






## 扩展阅读
- 关于 Composer 的定位：https://docs.phpcomposer.com/00-intro.html#Dependency-management
- 最佳实践系列（一）—— 漫谈 PHP 组件、框架、Composer 那些事：https://laravelacademy.org/post/4506.html
- 彻底搞懂Composer自动加载原理：https://zhuanlan.zhihu.com/p/30785203
- composer.lock文件的作用：https://www.jb51.net/article/79140.htm
- 一次因composer错误使用引发的问题与解决：https://www.jb51.net/article/157420.htm
- PHPer 需要了解的 5 个 Composer 小技巧：https://www.jb51.net/article/53881.htm
- composer使用实践：https://teroy.github.io/2017/03/11/composer/
- composer使用与原理分析：http://bazingafeng.com/2016/10/27/composer-introduction/

## 疑问点
1. ERC 预发布/生产环境发布代码的流程是如何的？
    1. 在一个全新的目录下 git clone 代码，然后执行 composer，最后软连到服务器项目根目录下【如果走这样一种方式，那么应该不会导致 composer.lock 冲突啊？】
    2. 在固定某个目录下 git clone 代码（有旧代码残余），然后执行 composer，最后软连到服务器项目根目录下