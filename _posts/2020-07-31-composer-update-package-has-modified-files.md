---
layout: post
title: "`Composer`错误：更新 `vendor` 提示本地有变更 `The package has modified files`"
date: 2020-07-31
tag: PHP,composer
---
## 背景
需要在测试环境维护一个稳定版本的全量项目包。写了一个脚部定时拉取最新的 `master` 分支代码，并自动更新对应的子模块。由于前期的 `.gitignore` 文件规范没处理好，因此导致了 `composer` 自动更新 `vendor` 的问题一直卡住，导致了 `vendor` 一直处于原始版本。

由于长期没有更新 `vendor` 目录，导致通过 `composer update` 的时候，不断有项目仓库跳出下述交互信息 `The package has modified files`，这对于通过脚部自动更新是极为不便的。 

```shell
- Updating erc_code/erc-core (v2.0.2 => 3.2.2):     
The package has modified files:
    M .gitignore
    M README.md
    M composer.json
    M src/Controller/MgController.php
    M src/Core/App.php
    M src/Core/DbModel.php
    M src/Core/HttpController.php
    M src/Core/Input.php
    M src/Core/Router.php
    M src/Exceptions/BadMethodCallException.php
    12 more files modified, choose "v" to view the full list
    Discard changes [y,n,v,d,s,?]
```

![when composer update show errors: package has modified files](/images/article/composer-update-error-package-has-modified-files.png)

## 解决方案
出现上述情况的原因：由于本地的`vendor`目录中存在了被修改或冲突的提交，导致了`composer`更新包时出现冲突错误。

最初`composer`遇到该情况是直接提示更新失败，后续`composer`作者`Seldaek`更新了这一[特性](https://github.com/composer/composer/pull/1188)，使得开发者可以自行选择处理方式。
### 设置`composer`变更配置
- `composer config --global discard-changes true` 直接忽略本地的变更，覆盖安装更新
- `composer config --global discard-changes stash` 将本地变更暂存`stash`到本地然后再更新

![composer-config-discard-changes](/images/article/composer-config-discard-changes.png)

### 屏蔽`composer update`交互信息
`composer update` 的时候添加 `-n` 参数，可以屏蔽弹出的交互信息

![composer-options-not-ask-interactive-question](/images/article/composer-options-not-ask-interactive-question.png)


转载请声明出处:[MinsonLee的博客:https://minsonlee.github.io](https://minsonlee.github.io)

扫描下方二维码，关注公众号，接收更多实时内容
![关注公众号：Leaders工作室](/images/article/WeChat/Leaders.png)