- https://wiki.ubuntu.org.cn/%E9%A6%96%E9%A1%B5

## 如何将 Ubuntu 操作系统升级到最新版本

1、 查看当前 Ubuntu 版本

```sh
cat /etc/os-release 
# 或
# sudo apt-get update && apt-get install -y lsb-release && apt-get clean all
lsb_release -a
# 或
uname -a
```

2、升级操作

`/etc/update-manager/release-upgrades` 文件中 `Prompt=lts` 决定了升级的版本选型

- `lts` : LTS （长期支持）版本：5年更新支持（首选）
- `normal` : 正常发行版本：6个月更新支持，可能存在问题

```sh
# 更新当前版本
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get clean
sudo apt-get autoremove
# 安装 Update Manager Core 包
sudo apt-get install update-manager-core
# 升级到最新版本
sudo do-release-upgrade -d
```