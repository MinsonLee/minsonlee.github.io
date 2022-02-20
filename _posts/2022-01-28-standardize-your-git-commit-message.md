---
layout: post
title: Git commit 提交规范-约定式提交
date: 2022-01-28
tags: [Git,规范]
---

## 为什么要约定式提交？

在团队里进行代码协作，一旦人员离职要自己顶上维护代码时，很多时候需要依靠搜索代码关键词或`Git`提交日志的方式来定位代码或改动。

奈何，经常有同事使用 `ff`、`tt`、一连 30 几个的`bugfix`提交信息且无具体内容，甚至有部分同事更是使用 `Emoji` 表情来书写提交信息，导致 git commit log 一片混乱。

大家约定好提交日志信息的规范（就像[语义化版本 Semver](https://semver.org/)一样），好处很多，就如阮一峰老师的文章[《Commit message 和 Change log 编写指南》](https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)写到一样：

1. 提供更多的历史信息，方便快速浏览
2. 可以过滤某些 commit （比如文档改动），便于快速查找信息
3. 可以直接从 commit 自动生成 Change log 或 基于提交的类型，自动决定语义化的版本变更
4. 向同事、公众与其他利益关系者传达变化的性质
5. **==让人们探索一个更加结构化的提交历史，以便降低对你的项目做出贡献的难度==**


## 约定式提交

[AngularJS Commit Message 提交规范](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#-commit-message-formatd) 是目前被认可并推广使用的，各大厂的提交规范也大都引用改编于它。

甚至有网友弄了一个类似 Semver 一样的规范文档：[《约定式提交 1.0.0》](https://www.conventionalcommits.org/zh-hans/v1.0.0/)。这里基于 AngularJS 提交规范，结合网上的一些其他规范建议，简单汇总记录一下。


```
<type>[(<option scope>)]: <short summary>
<BLANK LINE>
[<body>]
<BLANK LINE>
[<footer>]
```

```
<类型>[(<可选 范围>)]: <主题>
// 空一行
[<可选 内容>]
// 空一行
[<可选 脚注>]
```
格式基本都是如下，不同点在对于 `type` 的分类。

### Header

#### type

**`<type>` 类型说明**

- `build`: 影响构建系统或外部依赖的变化 (例如: gulp, broccoli, npm, composer, vendor 的一些变化)
- `chore`：构建过程或辅助工具的变动【和 `build` 一样，一些规范也使用这个】
- `ci`: 配置脚本的变更（configuration）
- `docs`: 文档变更（Documentation）
- `style`：格式调整（不影响代码运行的变动，如：格式化代码、修改代码注释）
- `feat`: 新功能（A new feature）
- `fix`: 修补Bug（bug fix）
- `perf`: 性能优化（performance）【有些】
- `refactor`: 重构（既不是新增功能，也不是bug修复或性能优化）
- `test`: 增加或修改测试
- `revert: the commit <SHA>`: 回退一个 commit 提交


破坏性变更必须通过把 `!` 直接放在 `:` 前面标记出来。什么是破坏性变更？可以查看 [Stack Overflow](https://stackoverflow.com/questions/21703216/what-is-a-breaking-change-in-software) 或 [Breaking-change Meaning](https://www.yourdictionary.com/breaking-change) 的解释。

> 破坏性变更，即：不兼容变动。当前的修改可能会导致系统的其他部分异常，需要其他引用的模块也修改才能正常运行。


#### scope

**`<option scope>` 说明：** 用于说明 `commit` 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。

#### summary

**`<short summary>` 主题说明：**

- `summary` 是本次 commit 信息的一个简短汇总，不宜太长（尽量在 50 字内）
- 以动词开头，使用第一人称现在时进行描述。如，使用 "change" 而不是 "changed" 也不是 "changes"
- 首字母小写
- 结尾不加句号 .
- 个人建议：可考虑在结尾加上工作需求唯一表示或开源项目的 issue 号

### Body

Body 部分是对本次 commit 的详细描述，可以分成多行。

- 以动词开头，使用第一人称现在时进行描述。如："fix" 而不是 "fixed"、"fixes".
- 解释修改动机：为什么要做这个修改？你可以说明一下修改前后的对比及改变所带来的影响


### Footer

脚注一般用于写 `BREAKING CHANGE: <description>` 或 类似 [git trailer format](https://git-scm.com/docs/git-interpret-trailers) 这样的惯例，用于书写详细的改动。

1、不兼容变动

对于不兼容改变需要 `<type>!:summary` 备注为不兼容改动，并在脚注中使用 `BREAKING CHANGE: <description>` 写明白变更动机

2、关闭 Issue

如果当前 commit 针对某个 issue，那么可以在 Footer 部分关闭这个 issue 。如：`Closes #234`、`Closes #123, #245, #992`


### 特殊的 Revert

当前 commit 用于撤销以前的 commit，则必须以 `revert:` 开头，后面跟着被撤销 Commit 的 Header 信息，并在 Body 中写明白撤销的 commit SHA

## 阅读附录
- [阮一峰老师博客：Commit message 和 Change log 编写指南](https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)
- [约定式提交 1.0.0](https://www.conventionalcommits.org/zh-hans/v1.0.0/)
- [Angular Commit Message 提交规范](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#-commit-message-formatd)
- [如何规范你的Git commit？](https://zhuanlan.zhihu.com/p/182553920)