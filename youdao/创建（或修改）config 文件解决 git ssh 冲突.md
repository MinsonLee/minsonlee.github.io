1.  在 `~/.ssh` 下创建 config 文件

```sh
touch config # 创建config文件
vim config # 编辑此文件
```

1.  添加不同 Host 的配置

```config
# Host 相当于取一个别名，可以自定义为任意的名字，推荐就以 HostName 的值为别名
Host github # 取别名为 github
HostName github.com # 别名对应的主机名，也就是仓库对应地址中的主机名
PreferredAuthentications publickey # 固定写法
IdentityFile ~/.ssh/id_rsa_github # 读取哪一个 ssh-key 的私钥
```

