---
layout: post
title: StarShip 定制 Windows Terninal
date: 2022-06-27
tags: [Tools,WSL2]
---

## StarShip 定制 Windows Terninal

[StarShip 终端订制指南](https://starship.rs/zh-CN/)

### 1. 安装  Nerd Font 系列的字体

如果是 Windows 一定要通过 “管理员身份” 打开 powershell，然后执行：

```powershell
choco install firacode
```

其他 OS 安装方式：https://github.com/tonsky/FiraCode/wiki/Installing

安装完字体后，在 WSL 的设置中将字体设置为新安装的 Fira Code

### 2. 安装 StarShip

```sh
# Windows 
scoop install starship

# Linux
curl -fsSL https://starship.rs/install.sh | sh
```

### 3. 启动 starship

Windows Powershell 下通过 `echo $PROFILE` 找到 powershell 启动配置文件（不存在则自行创建一个），然后打开文件，末尾添加：`Invoke-Expression (&starship init powershell)`

Linux 下：`vi /etc/bash.bashrc`，末尾添加 `eval "$(starship init bash)"`


### 4. 配置 `~/.config/starship.toml`

```config
command_timeout = 500
format = "$directory$git_branch$time$cmd_duration$character"
[line_break]
disabled = true

[character]
success_symbol = "[➜](bold green) "
error_symbol = "[✗](bold red) "

[cmd_duration]
min_time = 500
format = "took [$duration](bold yellow) "

[directory]
read_only = "🔒"
use_os_path_sep = true
truncate_to_repo = false
format = "[$path]($style)[$read_only]($read_only_style) "

[git_branch]
always_show_remote = true
symbol = "  "
style = "bold #e8ec00 inverted"
format = "on [$branch$symbol$remote_name/$remote_branch]($style) "

[time]
disabled = false
format = '[ 🕙 $time ]($style) '
time_format = "%I:%M:%S %p"
utc_time_offset = "+8"
style = "bold bg:#8a15e2"

[git_commit]
disabled = true

[git_state]
disabled = true

[git_status]
disabled = true

[package]
disabled = true
```