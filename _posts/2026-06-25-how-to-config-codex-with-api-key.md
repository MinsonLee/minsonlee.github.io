---
layout: post
title: "Codex CLI 使用 API Key 与多模型 Provider 配置指南"
date: 2026-06-25
tags: [AI, Codex]
---

# 

本文整理了两个问题：

1. 如何用 API Key 方式使用 Codex CLI，以及它如何运作、配置。
2. 如何在 Codex CLI 中同时接入其他非 OpenAI 模型，例如 DeepSeek，以及如何选择使用。


---

## 1. Codex CLI 的几个核心概念

使用 Codex CLI 时，最好把下面几件事分开理解：

| 概念 | 作用 | 常见位置 |
| --- | --- | --- |
| 认证方式 | 决定你用 ChatGPT 登录还是 API Key 登录 | `codex login` / `~/.codex/auth.json` |
| 凭据缓存 | 保存登录后的 token 或 API key | `~/.codex/auth.json` 或 Windows 系统 keyring |
| 模型 Provider | 决定请求发往哪个 API endpoint | `~/.codex/config.toml` |
| 默认模型 | 决定默认使用哪个模型 | `model` / `review_model` |
| 运行权限 | 决定 Codex 能否读写文件、联网、执行命令 | sandbox / approval 配置 |
| Profile | 在多个 provider/model 组合之间切换 | `~/.codex/<profile>.config.toml` |

> 注意：我是 Linux 环境安装开发，所以 windows 环境下没有做过多的验证

调用链如下：

```text
codex / codex exec
  -> 读取 ~/.codex/config.toml
  -> 读取所选 profile，例如 ~/.codex/deepseek.config.toml
  -> 获取认证信息，例如 ~/.codex/auth.json 或 env_key 指定的环境变量
  -> 根据 model_provider 找到对应 base_url
  -> 按 wire_api 指定的协议发送请求
```

---

## 2. API Key 登录方式

### 2.1 推荐的持久登录方式

适合本机日常交互使用：

```bash
export OPENAI_API_KEY="你的 OpenAI API Key"
printenv OPENAI_API_KEY | codex login --with-api-key
unset OPENAI_API_KEY
codex login status
```

关键点：

- `codex login --with-api-key` 从 stdin 读取 API key。
- 登录成功后，Codex 会缓存认证信息。
- 之后直接运行 `codex` 或 `codex exec`，会复用缓存的认证。
- `unset OPENAI_API_KEY` 是为了避免 API key 长期暴露在 shell 环境变量里。

检查登录状态：

```bash
codex login status
```

退出登录并清理缓存凭据：

```bash
codex logout
```

### 2.2 非交互的一次性 API Key

适合 CI、脚本和临时自动化：

```bash
CODEX_API_KEY="你的 OpenAI API Key" codex exec --json "summarize this repository"
```

注意：

- `CODEX_API_KEY` 主要用于 `codex exec` 这类非交互运行。
- 不建议把 `OPENAI_API_KEY` 或 `CODEX_API_KEY` 配成 CI job-level 环境变量后再运行不可信仓库代码。
- 更安全的做法是尽量缩小 key 的作用范围，只在单条命令或单个 step 内暴露。

---

## 3. auth.json 是什么，是否应该手写

默认情况下，Codex 的状态目录是：

```text
~/.codex
```

认证缓存通常在：

```text
~/.codex/auth.json
```

这个文件由 Codex 自动维护，不建议手写。它可能保存类似下面的结构：

```json
{
  "auth_mode": "apikey",
  "OPENAI_API_KEY": "<redacted>"
}
```

实际文件里会有真实 key 或 token，所以要把它当密码处理：

- 不要提交到 Git。
- 不要贴到 issue、聊天、日志里。
- 不要复制给别人。
- 不建议拿它来存 DeepSeek、Claude、Gemini 等第三方 provider 的 key。

### 3.1 credential store 配置

可以在 `~/.codex/config.toml` 中配置 CLI 凭据存储方式：

```toml
# file | keyring | auto
cli_auth_credentials_store = "auto"
```

更安全但依赖系统环境的配置：

```toml
cli_auth_credentials_store = "keyring"
```

如果从 file 切到 keyring，可能需要重新登录：

```bash
export OPENAI_API_KEY="你的 OpenAI API Key"
printenv OPENAI_API_KEY | codex login --with-api-key
unset OPENAI_API_KEY
```

---

## 4. config.toml 的基本结构

用户级配置文件：

```text
~/.codex/config.toml
```

示例：

```toml
model_provider = "OpenAI"
model = "gpt-5.5"
review_model = "gpt-5.5"
model_reasoning_effort = "xhigh"
disable_response_storage = true
network_access = "enabled"
windows_wsl_setup_acknowledged = true

[model_providers.OpenAI]
name = "OpenAI"
base_url = "https://example.internal/openai/v1"
wire_api = "responses"
requires_openai_auth = true
```

字段解释：

| 字段 | 含义 |
| --- | --- |
| `model_provider` | 默认使用哪个 provider |
| `model` | 默认对话/编码模型 |
| `review_model` | `codex review` 默认使用的模型 |
| `model_reasoning_effort` | 推理强度，取决于模型/后端是否支持 |
| `disable_response_storage` | 请求后端不存储响应，是否生效取决于后端支持 |
| `network_access` | 是否允许 Codex 使用网络能力 |
| `base_url` | provider 的 API 地址 |
| `wire_api` | Codex 使用的接口协议；当前 custom provider 只能使用 `responses` |
| `requires_openai_auth` | 是否使用 Codex 的 OpenAI 登录认证缓存 |
| `env_key` | 从哪个环境变量读取该 provider 的 API key |

---

## 5. `requires_openai_auth` 与 `env_key` 的区别

这是最容易混淆的地方。

### 5.1 OpenAI 登录缓存模式

适合 OpenAI 官方 endpoint，或通过代理访问 OpenAI 模型：

```toml
[model_providers.openai-proxy]
name = "OpenAI Proxy"
base_url = "https://example.internal/openai/v1"
wire_api = "responses"
requires_openai_auth = true
```

这种模式下：

- 先用 `codex login --with-api-key` 登录。
- Codex 从 `auth.json` 或 keyring 读取 OpenAI API key。
- 不需要 `env_key`。
- 如果同时写了 `requires_openai_auth = true` 和 `env_key`，`env_key` 可能不会按你预期生效。

### 5.2 Provider-specific 环境变量模式

适合 DeepSeek、Claude、Gemini、OpenRouter 等非 OpenAI provider：

```toml
[model_providers.deepseek]
name = "DeepSeek"
base_url = "https://example.internal/openai/v1"
wire_api = "responses"
env_key = "DEEPSEEK_API_KEY"
requires_openai_auth = false
```

运行前设置：

```bash
export DEEPSEEK_API_KEY="你的 DeepSeek API Key"
codex --profile deepseek
```

这种模式下：

- 不走 `~/.codex/auth.json` 里的 OpenAI 登录缓存。
- Codex 从 `DEEPSEEK_API_KEY` 读取第三方 provider 的 key。
- DeepSeek key 不应写进 `auth.json`。

---

## 6. 同时接入 OpenAI 与 DeepSeek 的推荐结构

推荐目录结构：

```text
~/.codex/
  config.toml
  auth.json                     # Codex 自动维护，不手写
  openai.config.toml
  deepseek.config.toml
  deepseek-fast.config.toml
```

设计思路：

- `config.toml`：定义所有 provider，以及一个默认 provider/model。
- `auth.json`：只让 Codex 管理 OpenAI 登录缓存。
- `*.config.toml`：定义不同 profile，用于快速切换 provider/model。

---

## 7. 示例：主配置 config.toml

```toml
# ~/.codex/config.toml

model_provider = "OpenAI"
model = "gpt-5.5"
review_model = "gpt-5.5"

model_reasoning_effort = "xhigh"
disable_response_storage = true
network_access = "enabled"
windows_wsl_setup_acknowledged = true

[model_providers.OpenAI]
name = "OpenAI"
base_url = "https://claude-relay-service.int.zuzuche.com/openai/v1"
wire_api = "responses"
requires_openai_auth = true

[model_providers.deepseek]
name = "DeepSeek via Responses Relay"
base_url = "https://你的-relay.example.com/openai/v1"
wire_api = "responses"
env_key = "DEEPSEEK_API_KEY"
env_key_instructions = "export DEEPSEEK_API_KEY=..."
request_max_retries = 4
stream_max_retries = 5
stream_idle_timeout_ms = 300000

[features]
goals = true

[projects."/home/lms"]
trust_level = "trusted"
```

说明：

- `OpenAI` provider 走 `requires_openai_auth = true`，复用 `codex login --with-api-key` 的 OpenAI 登录缓存。
- `deepseek` provider 走 `env_key = "DEEPSEEK_API_KEY"`，不写入 `auth.json`。
- `base_url` 是否能直连 DeepSeek，取决于后端是否兼容 Codex 需要的 `responses` 协议。

---

## 8. DeepSeek 接入的兼容性重点

DeepSeek 官方 OpenAI 格式接口当前是 Chat Completions 风格：

```text
https://api.deepseek.com/chat/completions
```

而 Codex custom provider 当前通常使用：

```toml
wire_api = "responses"
```

这意味着直接这样写不一定能成功：

```toml
[model_providers.deepseek]
name = "DeepSeek"
base_url = "https://api.deepseek.com"
wire_api = "responses"
env_key = "DEEPSEEK_API_KEY"
```

如果 DeepSeek 官方 endpoint 不支持 OpenAI Responses API，Codex 可能会请求 `/responses`，从而出现 404、unsupported endpoint 或类似错误。

更稳妥的架构是：

```text
Codex CLI
  -> OpenAI Responses API 格式
  -> 你的 relay/router/proxy
  -> DeepSeek Chat Completions API
```

也就是说，`base_url` 最好指向一个能把 Responses API 转发/翻译到 DeepSeek Chat Completions 的 relay。

---

## 9. 示例：DeepSeek profile

创建：

```text
~/.codex/deepseek.config.toml
```

内容：

```toml
# ~/.codex/deepseek.config.toml

model_provider = "deepseek"
model = "deepseek-v4-pro"
review_model = "deepseek-v4-pro"

model_reasoning_effort = "high"
model_reasoning_summary = "none"
model_verbosity = "medium"
```

使用：

```bash
export DEEPSEEK_API_KEY="你的 DeepSeek API Key"
codex --profile deepseek
```

非交互使用：

```bash
export DEEPSEEK_API_KEY="你的 DeepSeek API Key"
codex exec --profile deepseek "检查当前项目结构"
```

---

## 10. 示例：DeepSeek fast profile

创建：

```text
~/.codex/deepseek-fast.config.toml
```

内容：

```toml
# ~/.codex/deepseek-fast.config.toml

model_provider = "deepseek"
model = "deepseek-v4-flash"
review_model = "deepseek-v4-flash"

model_reasoning_effort = "medium"
model_reasoning_summary = "none"
model_verbosity = "low"
```

使用：

```bash
export DEEPSEEK_API_KEY="你的 DeepSeek API Key"
codex --profile deepseek-fast
```

---

## 11. 示例：OpenAI profile

创建：

```text
~/.codex/openai.config.toml
```

内容：

```toml
# ~/.codex/openai.config.toml

model_provider = "OpenAI"
model = "gpt-5.5"
review_model = "gpt-5.5"

model_reasoning_effort = "xhigh"
model_reasoning_summary = "auto"
model_verbosity = "medium"
```

使用：

```bash
codex --profile openai
```

---

## 12. 使用时如何选择模型或 provider

### 12.1 默认启动

使用 `~/.codex/config.toml` 中的默认值：

```bash
codex
```

### 12.2 指定 profile

```bash
codex --profile openai
codex --profile deepseek
codex --profile deepseek-fast
```

### 12.3 非交互模式指定 profile

```bash
codex exec --profile deepseek "帮我重构这个函数"
```

### 12.4 临时覆盖模型

```bash
codex --profile deepseek --model deepseek-v4-flash
```

### 12.5 临时覆盖 provider 和 model

```bash
codex \
  -c model_provider='"deepseek"' \
  -c model='"deepseek-v4-pro"'
```

`-c` 的值会按 TOML 解析，所以字符串建议写成带引号的 TOML 字符串：

```bash
-c model='"deepseek-v4-pro"'
```

---

## 13. DeepSeek 模型名注意事项

截至 2026-07-20，DeepSeek 官方 API 文档列出的 V4 模型包括：

```text
deepseek-v4-flash
deepseek-v4-pro
```

旧模型名：

```text
deepseek-chat
deepseek-reasoner
```

DeepSeek 官方文档说明这两个旧名称将在 2026-07-24 15:59 UTC 停止使用；当前阶段它们分别指向 `deepseek-v4-flash` 的非思考模式和思考模式。

因此新配置建议优先使用：

```toml
model = "deepseek-v4-pro"
```

或：

```toml
model = "deepseek-v4-flash"
```

如果你的 relay 只支持旧模型名，需要以 relay 的模型列表为准，但应尽快迁移。

---

## 14. 第三方 key 的更安全做法：auth command

如果不想把 DeepSeek key 长期暴露在环境变量里，也可以让 provider 通过命令动态获取 bearer token。

示例：

```toml
[model_providers.deepseek]
name = "DeepSeek via Responses Relay"
base_url = "https://你的-relay.example.com/openai/v1"
wire_api = "responses"

[model_providers.deepseek.auth]
command = "/usr/local/bin/get-deepseek-token"
timeout_ms = 5000
refresh_interval_ms = 300000
```

这种模式下：

- 不要同时设置 `env_key`。
- `get-deepseek-token` 应只输出 token，不要输出日志和多余内容。
- 适合接企业密钥管理系统、vault、内部 SSO token 服务等。

---

## 15. 常用排查命令

查看 Codex 版本：

```bash
codex --version
```

查看帮助：

```bash
codex --help
codex login --help
codex exec --help
```

查看认证状态：

```bash
codex login status
```

检查安装、配置、认证、网络等：

```bash
codex doctor --summary
codex doctor --json
```

测试 DeepSeek profile：

```bash
export DEEPSEEK_API_KEY="你的 DeepSeek API Key"
codex exec --profile deepseek "hello"
```

如果遇到 `/responses` not found、404、unsupported endpoint：

```text
大概率不是 auth.json 问题，而是 DeepSeek 官方 endpoint 与 Codex 当前 wire_api = "responses" 不兼容。
应改为接入 Responses-compatible relay/proxy。
```

---

## 16. 常见坑

### 16.1 把 DeepSeek key 写进 auth.json

不推荐。

`auth.json` 是 Codex 管理 OpenAI/ChatGPT 登录缓存的地方。DeepSeek 这类 provider 应通过 `env_key` 或 `auth.command` 配置。

### 16.2 同时写 requires_openai_auth 和 env_key

例如：

```toml
[model_providers.OpenAI]
requires_openai_auth = true
env_key = "OPENAI_API_KEY"
```

这会让语义变得混乱。推荐二选一：

OpenAI 登录缓存模式：

```toml
requires_openai_auth = true
```

普通环境变量 key 模式：

```toml
env_key = "SOME_PROVIDER_API_KEY"
requires_openai_auth = false
```

### 16.3 以为 API key 登录等于 ChatGPT 登录

API key 登录使用 OpenAI Platform 计费和组织设置，不等于 ChatGPT Plus/Pro/Team/Enterprise 登录。

某些依赖 ChatGPT workspace、Cloud Task、Connector、Remote Control 的功能，可能仍要求 ChatGPT 登录，而不是 API key 登录。

### 16.4 直接把 API key 放进项目文件

不要把 key 写进：

```text
.env
README.md
.codex/config.toml
AGENTS.md
脚本源码
CI 日志
```

第三方 provider 推荐使用环境变量或 credential helper。

### 16.5 误以为 `CODEX_API_KEY` 支持所有模式

`CODEX_API_KEY` 更适合 `codex exec` 这类非交互命令。交互式日常使用建议使用：

```bash
printenv OPENAI_API_KEY | codex login --with-api-key
```

---

## 17. 推荐最终方案

如果你希望 OpenAI 和 DeepSeek 共存，推荐采用：

```text
OpenAI：
  - 使用 codex login --with-api-key
  - 由 Codex 管理 ~/.codex/auth.json 或 keyring
  - provider 配 requires_openai_auth = true

DeepSeek：
  - 不写 auth.json
  - provider 配 env_key = "DEEPSEEK_API_KEY"
  - 用 ~/.codex/deepseek.config.toml 切换 profile
  - 优先通过 Responses-compatible relay 接入
```

日常使用：

```bash
# OpenAI 默认
codex

# OpenAI profile
codex --profile openai

# DeepSeek
export DEEPSEEK_API_KEY="你的 DeepSeek API Key"
codex --profile deepseek

# DeepSeek 快速模型
export DEEPSEEK_API_KEY="你的 DeepSeek API Key"
codex --profile deepseek-fast
```

---

## 18. 参考资料

- OpenAI Codex authentication 文档：<https://learn.chatgpt.com/codex/auth>
- OpenAI Codex non-interactive mode 文档：<https://learn.chatgpt.com/codex/non-interactive-mode>
- OpenAI Codex environment variables 文档：<https://learn.chatgpt.com/codex/config-file/environment-variables>
- OpenAI Codex config reference：<https://developers.openai.com/codex/config-reference>
- OpenAI Codex advanced config / profiles：<https://developers.openai.com/codex/config-advanced>
- DeepSeek Models & Pricing：<https://api-docs.deepseek.com/quick_start/pricing>
- DeepSeek Change Log：<https://api-docs.deepseek.com/updates/>
