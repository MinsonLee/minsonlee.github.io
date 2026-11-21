---
layout: post
title: "Linux 下为所有用户安装 pnmp/fnm/Node.js"
date: 2026-11-20
tags: [AI, Linux, Node.js]
---

> 本文仅适合个人开发环境，共享 Store 只适合互相信任的用户和进程操作 pnpm，生产是没有必要的!

越来越多的 AI 工具都以来 `Node.js`，本文简单记录 [`Node.js`](https://nodejs.org/en/download) 提到的几款软件关系、区别和全局安装。

```txt
                Node.js 开发环境
                       |
                +------+------+
                |             |
               nvm           fnm
                |             |
                +------+------+
                       |
                    Node.js
                       |
                +------+------+
                |             |
               npm           pnpm
                |             |
               npx           pnx(pnpm dlx 的简称别名)
```

| 工具       | 全称 / 含义         | 核心职责     | 主要用途              | 是否需要安装           |
| -------- | -------------------- | ------------ | --------------------- | --------------------- |
| **nvm**  | Node Version Manager | Node.js 版本管理 | 安装、切换、管理多个 Node.js 版本 | 需要单独安装 |
| **fnm**  | Fast Node Manager    | Node.js 版本管理 | 与 nvm 类似，但更注重速度         | 需要单独安装 |
| **npm**  | Node Package Manager | 包管理器         | 安装、卸载、更新项目依赖          | 随 Node.js 一起安装 |
| **pnpm** | Performant npm       | 包管理器         | 高效管理项目依赖，节省磁盘空间    | 需要单独安装或通过 Corepack 管理 |
| **npx**  | npm Package Executor | 包执行器         | 临时下载并执行 npm 包中的命令     | npm 5.2+ 内置的命令       |
| **pnx**  | pnpm dlx Package Executor | 包执行器         | 临时下载并执行 npm 包中的命令     | npm 5.2+ 内置的命令       |

- `nvm`、`fnm` : 都是负责管理 Node.js 版本，二选一即可
- `npm`、`pnpm` : 都是 Node.js 的包管理器，二选一即可
- `npx` 是安装 `npm` 时附带安装的命令，相当于“用完即弃”的临时容器，`pnpm dlx` 与之类似

`nvm` 其实就是一个 `Shell` 工具脚本，`npm` 是 `Node.js` 官方自带的包管理工具。但是...AI 也推荐 `fnm` + `pnpm`，据说是真的很快、省内存。

![Rewrite It In Rust - RIIR](https://i.imgur.com/Ih6m5Bq.png)




## 为所有用户进行安装 `pnpm`

### 省流总结：

- [`PNPM_VERSION` 版本信息](https://github.com/pnpm/pnpm/tags)，如：`PNPM_VERSION=v12.21.0`，默认是 `latest`
- [`PNPM_HOME` 应用程序主目录](https://pnpm.io/cli/setup)，默认是：`~/.pnmp`
- `PNPM_NO_MODIFY_PATH=1` 不自动添加到 `PATH` 路径中

可以通过定义上述 3 个环境变量改变安装脚步的位置！

### 独立安装脚本

在 [`pnpm installation` 文档](https://pnpm.io/installation) 中推荐使用的 `curl -fsSL https://get.pnpm.io/install.sh | sh -` 独立安装脚步，默认只为当前用户安装 `pnpm`。

由于只有我一个人使用，用户切换不多，基本 4 个用户之间切换使用而已，所以我希望为本地电脑的所有用户都能使用 `pnmp/node/npm`

```pre
# 独立脚本默认目录结构
/home/用户A/.pnpm/
├── bin/
│   ├── node
│   ├── pnpm
│   └── ...
├── global/
└── store/
│
/home/用户B/.pnpm/
├── bin/
│   ├── node
│   ├── pnpm
│   └── ...
├── global/
└── store/

# 下方是我希望的目录结构
/apps/pnpm/
├── bin/
│   ├── node
│   ├── pnpm
│   └── ...
├── global/
└── store/
```
下载 `https://get.pnpm.io/install.sh` 脚本看了一下，其中 `download_and_install()` 函数负责检查并到 GitHub 下载对应版本二进制文件到 `/tmp` 目录下，最终 `Linux` 系统是下载执行 [`/tmp/xxxx/pnpm pm setup --force`](https://pnpm.io/zh/cli/setup) 命令进行自举安装。

所以回到 `pnpm` 自身，细看 [`pnpm pm setup`](https://pnpm.io/zh/cli/setup) 文档，该命令主要就是将正在运行的 `/tmp/xxx/pnpm` 应用程序安装到 `PNPM_HOME` 并初始化，默认会将 `export PNPM_HOME` 添加到 "～/$SHELL.${SHELL}rc" 的 `$PATH` 中。


1. 假设安装在全局路径 `/apps/pnpm` 下，先自己创建好目录并设置权限
```sh
sudo groupadd -f AI # 创建用户组
sudo install -d -o $(whoami) -g AI -m 2775 "/apps/pnpm" # 创建目录并设置权限
sudo chmod -R g+rwX /apps/pnpm # 子目录授权：a-all;u-user;g-group;o-other
sudo find /apps/pnpm -type d -exec chmod g+s {} + # 自动继承所属组
```
2. 执行 `curl -fsSL https://get.pnpm.io/install.sh | env PNPM_HOME="/apps/pnpm" PNPM_NO_MODIFY_PATH=1 sh -` 进行安装
3. 将 `$PNPM_HOME` 信息添加到 `$PATH` 路径加载
```sh
# 先备份源配置文件
sudo cp -a /etc/bash.bashrc /etc/bash.bashrc.bak
# 实际此时 `pnpm` 已经安装完成，只是没有添加到 `$PATH` 路径中，系统无法方便的进行使用而已
env PNPM_HOME="/apps/pnpm" /apps/pnpm/bin/pnpm setup --no-modify-path | tail -n 5 | sudo tee -a /etc/bash.bashrc
# 更新当前窗口环境变量信息
source /etc/bash.bashrc
```
> 如果默认 `SHELL` 是 `BASH`，安装脚本没有预设 `PNPM_NO_MODIFY_PATH=1` 则 `PNPM_HOME` 只会加到当前安装用户的 `~/.bashrc` 路径下，所以需要手动将下列信息添加到全局配置加载文件中，如：`/etc/profile` 或 `/etc/profile.d/pnpm.sh` 或 `/etc/bash.bashrc` 中，最后手动 `source <file>` 生效

### 验证安装：

- 是否安装成功：`pnpm --version`
- 安装目录信息：`echo "$PNPM_HOME"`
- 验证安装目录：`which pnpm pn pnx`
- 验证目录：`pnpm root`、`pnpm root -g`、`pnpm store path`



### 更新、删除全局包或卸载

- 更新：`pnpm self-update`
- 移除全局已安装的包：`pnpm ls -g` 列出所有全局包，通过 `pnpm rm -g <pkg> ...` 删除或 `rm -rf "$(pnpm root -g <pkg>)"`
- 删除全局存储： `rm -rf "$(pnpm store path)" "$(pnpm root)"`
- 删除存储目录：`$XDG_STATE_HOME/pnpm` 或 `~/.local/state/pnpm`
- 删除缓存目录：`$XDG_CACHE_HOME/pnpm` 或 `~/.cache/pnpm` 注意每个用户的缓存目录是不一样的(`pnpm cache path`)
- 移除 `CLI` 程序：`rm -rf "$PNPM_HOME"` 或如果使用的 `npm` 安装则 `npm rm -g pnpm` 移除

### 使用 `pnpm` 管理多版本 `Node.js`


`pnpm 12` 支持使用命令: [`pnpm runtime set node [<version:-latest>] [-g]`](https://pnpm.io/cli/runtime) 安装 `Node.js`，而且 `pnpm 12` 也支持 `.nvmrc` 或 `.node-version` 进行项目级的 `node` 自动切换。

> `-g` 参数可以作为全局扩展进行安装

```sh
# 安装 Node.js 22
pnpm runtime set node 22 -g

# 安装 Node.js LTS
pnpm runtime set node lts -g
```

但是 `pnpm` 只负责安装，版本的切换依赖项目`package.json`，如：

```json
{
    "devEngines": {
        "runtime": {
            "name": "node",
            "version": "22.16.0",
            "onFail": "download"
        }
    },
    "engines": {
        "node": ">=22 <23",
        "runtime": {
            "name": "node",
            "version": "22.16.0",
            "onFail": "download"
        }
    }
}
```

然后执行 `pnpm install` 时会下载 `*.runtime.version` 对应版本的运行时，并记录更新在项目的 `lockfile` 中。

- `pnpm runtime set` 非全局运行时安装通常在项目目录的`<project_path>/node_modules` 目录下
- `pnpm ls` 则是项目级别的扩展查询
- `pnpm bin` 查看项目使用的 `node`
- `pnpm runtime set -g` 安装目录可以通过 `pnpm store path` 命令查看
- `pnpm ls -g` 可以查看当前全局安装
- `pnpm bin -g` 查看全局使用的 `node`
> 全局运行时一般在 "$PNPM_PATH/bin" 目录下且有`.pnpm-shim-v1-xx-target` 格式文本文件控制具体路径


## `fnm` 真的还需要吗？

`AI` 一直推荐安装多版本 `node` 的时候使用 `fnm`，但是我发现最新的 `pnpm@v12` 功能已经和 `fnm` 重合了。`fnm` 似乎不是必须的...

| 对比维度            | pnpm                 | fnm           |
| --------------- | -------------------- | ------------- |
| 核心定位            | 包管理器             | Node.js 版本管理器 |
| 安装多个 Node.js    | 支持  | 支持 |
| 安装指定版本         | 支持                   | 支持            |
| 全局版本管理         | 支持                   | 支持            |
| 项目版本识别         | 支持                   | 支持            |
| 自动切换版本         | 项目 Runtime / Shim 机制 | Shell Hook    |
| `.nvmrc`           | 新版支持                 | 支持            |
| `.node-version`    | 新版支持                 | 支持            |
| Shell 依赖         | 不依赖传统切换 Hook         | 需要配置 Shell    |
| 管理 npm/pnpm      | 核心功能之一               | 不负责           |
| 管理 Bun/Deno      | 支持                   | 不负责           |


**区别：**
- fnm：修改当前 Shell 的 PATH 环境，如 `eval "$(fnm env --use-on-cd --shell bash)"`
- pnpm 12 的机制不只是简单地安装多个 Node.js，而是通过 Context-aware global shims（上下文感知的全局命令垫片），让不同项目使用各自指定的 Node.js 版本

使用 `fnm` + `pnpm` 理想的规划是：

```pre
/apps/
├── fnm/
│   ├── aliases/
│   ├──── default --> v22.x.x
│   ├── node-versions/
│   ├──── v20.x.x
│   ├──── v24.x.x
│   ├──── v26.x.x
│   └── ...
│
└── pnpm/
    └── ...

/usr/local/bin/
└── fnm
```

`fnm` 负责专业的多版本管理，`pnpm` 则替代 `npm` 完成专业的包管理。


### 测试
- 创建用户组：sudo groupadd -f nodejs
- 创建用户并加入用户组：sudo useradd -m -g nodejs -G nodejs nodejs1
- 设置登录密码：sudo passwd nodejs1
- 创建共享目录并设置权限: sudo install -d -o root -g nodejs -m 2775 "/apps/fnm"
- 初始化共享目录：
```sh
sudo chgrp -R nodejs /apps/fnm
sudo chmod -R g+rwX /apps/fnm
sudo find /apps/fnm -type d -exec chmod g+s {} +
```
- 设置全局 `FNM_DIR`:
```sh
sudo tee /etc/profile.d/fnm.sh >/dev/null <<'EOF'
export FNM_DIR="/apps/fnm"
EOF
```
- 配置 Bash 自动加载 fnm,配置 `/etc/bash.bashrc`
```bash
# fnm shared configuration
export FNM_DIR="/apps/fnm"

# Initialize fnm for interactive shells
if [[ $- == *i* ]] && command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd --shell bash)"
fi
```
- 安装 fnm : `curl -fsSL https://fnm.vercel.app/install | sudo bash -s -- --install-dir /usr/local/bin --skip-shell`
- 禁止使用 `sudo fnm` 执行，避免 `sudo fnm install` 安装 Node.js 造成共享目录下文件归属和权限混乱

新建 `/usr/local/bin/fnm`，然后 `sudo chmod 755 /usr/local/bin/fnm` 权限：

```bash
#!/usr/bin/env bash

if [[ "$EUID" -eq 0 ]]; then
    echo "Error: Do not run fnm as root."
    echo "Please run fnm as a normal user."
    exit 1
fi

exec /apps/fnm/fnm "$@"
```

- 命令：
       - which fnm
       - fnm --version
       - fnm install 24
       - fnm list
       - fnm use 24
- 处理不同用户的默认版本，不要使用共享的 `fnm default 22`,而是每个用户在自己的 ~/.bashrc 中设置默认版本，如：`fnm use 24 --silent-if-unchanged`
- 如果是项目级版本，则通过 `.node-version` 和 `.nvmrc` 控制

!!! pnpm 方式多个用户共享可写目录会带来权限、配置隔离和安全问题，如果为每个单独版本用户设置不同的 `PNPM_HOME` 则会造成版本相同时，磁盘空间的重复占用。两者选其一...但是真的需要这么复杂吗？？

此时：fnm 则会更加方便。

```
/apps/fnm/
   node-versions/
      v20.x.x/
      v22.x.x/
      v24.x.x/
   aliases/
      default → v22.x.x
```

最终：个人开发，使用 fnm + pnpm