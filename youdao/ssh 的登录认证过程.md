# 互联网加解密一二事
[TOC]

> - https://juejin.im/post/6844903638117122056
> - http://www.wxtlife.com/2016/03/27/%E8%AF%A6%E8%A7%A3https%E6%98%AF%E5%A6%82%E4%BD%95%E7%A1%AE%E4%BF%9D%E5%AE%89%E5%85%A8%E7%9A%84%EF%BC%9F

## 对称加密

## 非对称加密

## 摘要算法

> 验证签名、防篡改

## `CA`证书验证



## SSH 安全登录认证的两种方式

`ssh` 命令是 `openssh` 套件中的客户端连接工具，可以让我们通过 **SSH 加密协议** 进行远程主机访问，从而实现对远程服务器的管理工作。

通过 `ssh -vvv <user>@<remote>` 的方式，可以 Debug 打印显示出 SSH 的认证过程，可以通过 `ssh -vvv user@example.com -E log_file` 或 `ssh -vvv user@example.com > log_file 2>&1` 的方式将认证过程的日志输出到文件中。

```txt
OpenSSH_8.2p1 Ubuntu-4ubuntu0.5, OpenSSL 1.1.1f  31 Mar 2020
debug1: Reading configuration data /home/lms/.ssh/config
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 19: include /etc/ssh/ssh_config.d/*.conf matched no files
debug1: /etc/ssh/ssh_config line 21: Applying options for *
debug2: resolve_canonicalize: hostname 10.4.133.200 is address
debug2: ssh_connect_direct
debug1: Connecting to 10.4.133.200 [10.4.133.200] port 63305.
debug1: Connection established.
debug1: identity file /home/lms/.ssh/id_rsa type -1
debug1: identity file /home/lms/.ssh/id_rsa-cert type -1
debug1: identity file /home/lms/.ssh/id_dsa type -1
debug1: identity file /home/lms/.ssh/id_dsa-cert type -1
debug1: identity file /home/lms/.ssh/id_ecdsa type -1
debug1: identity file /home/lms/.ssh/id_ecdsa-cert type -1
debug1: identity file /home/lms/.ssh/id_ecdsa_sk type -1
debug1: identity file /home/lms/.ssh/id_ecdsa_sk-cert type -1
debug1: identity file /home/lms/.ssh/id_ed25519 type -1
debug1: identity file /home/lms/.ssh/id_ed25519-cert type -1
debug1: identity file /home/lms/.ssh/id_ed25519_sk type -1
debug1: identity file /home/lms/.ssh/id_ed25519_sk-cert type -1
debug1: identity file /home/lms/.ssh/id_xmss type -1
debug1: identity file /home/lms/.ssh/id_xmss-cert type -1
debug1: Local version string SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
debug1: Remote protocol version 2.0, remote software version OpenSSH_7.4
debug1: match: OpenSSH_7.4 pat OpenSSH_7.0*,OpenSSH_7.1*,OpenSSH_7.2*,OpenSSH_7.3*,OpenSSH_7.4*,OpenSSH_7.5*,OpenSSH_7.6*,OpenSSH_7.7* compat 0x04000002
debug2: fd 3 setting O_NONBLOCK
debug1: Authenticating to 10.4.133.200:63305 as 'localhostwww'
debug3: put_host_port: [10.4.133.200]:63305
debug3: hostkeys_foreach: reading file "/home/lms/.ssh/known_hosts"
debug3: record_hostkey: found key type ECDSA in file /home/lms/.ssh/known_hosts:16
debug3: load_hostkeys: loaded 1 keys from [10.4.133.200]:63305
debug3: order_hostkeyalgs: prefer hostkeyalgs: ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521
debug3: send packet: type 20
debug1: SSH2_MSG_KEXINIT sent
debug3: receive packet: type 20
debug1: SSH2_MSG_KEXINIT received
debug2: local client KEXINIT proposal
debug2: KEX algorithms: curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256,ext-info-c
debug2: host key algorithms: ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,sk-ecdsa-sha2-nistp256-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,sk-ecdsa-sha2-nistp256@openssh.com,ssh-ed25519,sk-ssh-ed25519@openssh.com,rsa-sha2-512,rsa-sha2-256,ssh-rsa
debug2: ciphers ctos: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
debug2: ciphers stoc: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
debug2: MACs ctos: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
debug2: MACs stoc: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
debug2: compression ctos: none,zlib@openssh.com,zlib
debug2: compression stoc: none,zlib@openssh.com,zlib
debug2: languages ctos:
debug2: languages stoc:
debug2: first_kex_follows 0
debug2: reserved 0
debug2: peer server KEXINIT proposal
debug2: KEX algorithms: curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1
debug2: host key algorithms: ssh-rsa,rsa-sha2-512,rsa-sha2-256,ecdsa-sha2-nistp256,ssh-ed25519
debug2: ciphers ctos: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,aes128-cbc,aes192-cbc,aes256-cbc,blowfish-cbc,cast128-cbc,3des-cbc
debug2: ciphers stoc: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,aes128-cbc,aes192-cbc,aes256-cbc,blowfish-cbc,cast128-cbc,3des-cbc
debug2: MACs ctos: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
debug2: MACs stoc: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
debug2: compression ctos: none,zlib@openssh.com
debug2: compression stoc: none,zlib@openssh.com
debug2: languages ctos:
debug2: languages stoc:
debug2: first_kex_follows 0
debug2: reserved 0
debug1: kex: algorithm: curve25519-sha256
debug1: kex: host key algorithm: ecdsa-sha2-nistp256
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug3: send packet: type 30
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug3: receive packet: type 31
debug1: Server host key: ecdsa-sha2-nistp256 SHA256:sZEKUPOhf9MTXZJ09fcc+GejVJ4NBkngF/PadVHTDBs
debug3: put_host_port: [10.4.133.200]:63305
debug3: put_host_port: [10.4.133.200]:63305
debug3: hostkeys_foreach: reading file "/home/lms/.ssh/known_hosts"
debug3: record_hostkey: found key type ECDSA in file /home/lms/.ssh/known_hosts:16
debug3: load_hostkeys: loaded 1 keys from [10.4.133.200]:63305
debug3: hostkeys_foreach: reading file "/home/lms/.ssh/known_hosts"
debug3: record_hostkey: found key type ECDSA in file /home/lms/.ssh/known_hosts:16
debug3: load_hostkeys: loaded 1 keys from [10.4.133.200]:63305
debug1: Host '[10.4.133.200]:63305' is known and matches the ECDSA host key.
debug1: Found key in /home/lms/.ssh/known_hosts:16
debug3: send packet: type 21
debug2: set_newkeys: mode 1
debug1: rekey out after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug3: receive packet: type 21
debug1: SSH2_MSG_NEWKEYS received
debug2: set_newkeys: mode 0
debug1: rekey in after 134217728 blocks
debug1: Will attempt key: /home/lms/.ssh/id_rsa
debug1: Will attempt key: /home/lms/.ssh/id_dsa
debug1: Will attempt key: /home/lms/.ssh/id_ecdsa
debug1: Will attempt key: /home/lms/.ssh/id_ecdsa_sk
debug1: Will attempt key: /home/lms/.ssh/id_ed25519
debug1: Will attempt key: /home/lms/.ssh/id_ed25519_sk
debug1: Will attempt key: /home/lms/.ssh/id_xmss
debug2: pubkey_prepare: done
debug3: send packet: type 5
debug3: receive packet: type 7
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_input_ext_info: server-sig-algs=<rsa-sha2-256,rsa-sha2-512>
debug3: receive packet: type 6
debug2: service_accept: ssh-userauth
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug3: send packet: type 50
debug3: receive packet: type 51
debug1: Authentications that can continue: publickey,gssapi-keyex,gssapi-with-mic,password
debug3: start over, passed a different list publickey,gssapi-keyex,gssapi-with-mic,password
debug3: preferred gssapi-with-mic,publickey,keyboard-interactive,password
debug3: authmethod_lookup gssapi-with-mic
debug3: remaining preferred: publickey,keyboard-interactive,password
debug3: authmethod_is_enabled gssapi-with-mic
debug1: Next authentication method: gssapi-with-mic
debug1: Unspecified GSS failure.  Minor code may provide more information
No Kerberos credentials available (default cache: FILE:/tmp/krb5cc_1000)


debug1: Unspecified GSS failure.  Minor code may provide more information
No Kerberos credentials available (default cache: FILE:/tmp/krb5cc_1000)


debug2: we did not send a packet, disable method
debug3: authmethod_lookup publickey
debug3: remaining preferred: keyboard-interactive,password
debug3: authmethod_is_enabled publickey
debug1: Next authentication method: publickey
debug1: Trying private key: /home/lms/.ssh/id_rsa
debug3: sign_and_send_pubkey: RSA SHA256:7bbEHo2WKqXRVUSVtcWVi9BI2SAZcapv1Dl4eHz+gIU
debug3: sign_and_send_pubkey: signing using rsa-sha2-512 SHA256:7bbEHo2WKqXRVUSVtcWVi9BI2SAZcapv1Dl4eHz+gIU
debug3: send packet: type 50
debug2: we sent a publickey packet, wait for reply
debug3: receive packet: type 51
debug1: Authentications that can continue: publickey,gssapi-keyex,gssapi-with-mic,password
debug1: Trying private key: /home/lms/.ssh/id_dsa
debug3: no such identity: /home/lms/.ssh/id_dsa: No such file or directory
debug1: Trying private key: /home/lms/.ssh/id_ecdsa
debug3: no such identity: /home/lms/.ssh/id_ecdsa: No such file or directory
debug1: Trying private key: /home/lms/.ssh/id_ecdsa_sk
debug3: no such identity: /home/lms/.ssh/id_ecdsa_sk: No such file or directory
debug1: Trying private key: /home/lms/.ssh/id_ed25519
debug3: no such identity: /home/lms/.ssh/id_ed25519: No such file or directory
debug1: Trying private key: /home/lms/.ssh/id_ed25519_sk
debug3: no such identity: /home/lms/.ssh/id_ed25519_sk: No such file or directory
debug1: Trying private key: /home/lms/.ssh/id_xmss
debug3: no such identity: /home/lms/.ssh/id_xmss: No such file or directory
debug2: we did not send a packet, disable method
debug3: authmethod_lookup password
debug3: remaining preferred: ,password
debug3: authmethod_is_enabled password
debug1: Next authentication method: password
```

**注意：`~/.ssh` 下的 `id_rsa` 和 `config` 文件权限不能太过开放（0600 即可），否则会报错导致走密码验证方式（这是一个很容易让人忽略的排查点）！！！**

### 基于口令的安全认证登录

![SSH 密码验证](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/ssh-auth-by-pwd.png)


### 基于密钥免密安全验证登录

![SSH 密钥验证](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/ssh-auth-for-private-key.png)

### `man-in-the-middle`(中间人)攻击

![man-in-the-middle 中间人攻击示意图](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/man-in-the-middle.png)

### 两种验证方式的优缺点

1. 密钥+验签方式能有效的防止中间人方式攻击：私钥在谁的手上，谁就拥有主动权！
2. 口令验证登录：每次都需要人为确认信息，安全但效率低

### `~/.ssh` 下面的文件

> - 数据防偷窥：公钥加密，私钥解密
> - 数据防篡改：私钥签名，公钥验证

#### 公钥/私钥

##### 应用场景

1. 公钥加密，私钥解密 ==> 加密场景（数据防泄密）==> 会涉及两对公/私钥
2. 私钥签名，公钥验签 ==> 签名场景（数据防篡改）==> 仅涉及一对公/私钥


##### 根据私钥推断公钥信息

```sh
ssh-keygen -y -f <private_key_file> > <public_key_filepath>
```

##### 可以公钥加密，私钥解密吗？

RSA 是一种非对称加密方式的算法，公私钥是互逆的，理论上当然是可以。但是...公钥是公开在网上，任何人都有可能获取得到的，这意味着：你打造了一把任何人都有钥匙的门锁来锁住秘密，那这不意味着其实谁都有可能开到这扇门嘛。



#### `~/.ssh/known_hosts`的作用

SSH 会把你每个你访问过计算机的公钥（public key）都记录在 `~/.ssh/known_hosts` 文件中，当下次访问相同计算机时，OpenSSH 会通过该文件核对公钥信息进行密钥验证。

##### `Host key has changed`解决方法

这个情况往往出现在我们当前主机信息发生了变更，登录远程主机时，当前本地主机的 `公钥文件` 与 `IP/主机` 信息映射不对，就会发生这个错误。

- 方法1： `rm -rf ~/.ssh/known_hosts` 删除文件，所有登录都需要重新进行验证
- 方法2： `vi ~/.ssh/known_hosts` 删除错误提示中指定行，但这个操作相对比较麻烦
- 方法3： `ssh-keygen -R <ip/host>` 清除旧信息（推荐！！！）

```sh
ssh-keygen -f "/home/lms/.ssh/known_hosts" -R "193.112.22.71"
```




#### `~/.ssh/authorized_keys`的作用
> https://www.ssh.com/ssh/authorized_keys/openssh#location-of-the-authorized-keys-file

#### `~/.ssh/config` 的作用

ssh_config 文件是 SSH 的配置文件，可以简化我们 SSH 命令操作的输入信息、个性化配置不同服务器的 SSH 验证信息...

[ssh_config 配置文件](https://linux.die.net/man/5/ssh_config) 可以查看该配置文件的详细格式信息。

- `~/.ssh/config` 用于配置当前用户的 ssh 配置
- `/etc/ssh/ssh_config` 用于配置系统全局用户的 ssh 信息

```config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
# SSH 密码登录命令 : ssh -l <user> hostname -p <pwd>
# SSH 密钥登录命令 : ssh -l <user> hostname -i <identity_file>

# 配置 Host <name> 然后就可以通过 ssh <name> 方式进行登录.(简化输入信息)
Host example
    # 设置 IP 或 HostName(即:Domain . IP 和 Domain 在 hosts 文件中指定就好)
    HostName 10.4.xxxxx
    # login name 登录用户
    User xxxx
    # 连接端口
    Port 6xxx
    # 私钥路径:若配置了密钥登录，可免密登陆.比较方便
    # 可以针对不同的服务器配置不同的密钥对
    IdentityFile "~/.ssh/id_rsa"

Host example2
    ...
```

当我们用 SSH 连一台新机器、密钥对改动时候，总会提醒 ` Are you sure you want to continue connecting (yes/no)?  ` 需要用户手动的确认是否需要信任连接。这是因为 SSH 在 `known_hosts` 文件中没有发现该机器的 SHA256 校验信息或校验信息不正确，因此需要用户手动输入 yes/no 来决定当前链接是否信任？是否需要更新 `known_hosts`  其中的信息。但大多数情况我们都是直接输入 yes 确认的。

我们可以通过 `-o StrictHostKeyChecking=no` 参数跳过上述检验，也不会当然也不会新增或更新 known_hosts。

`ssh -o StrictHostKeyChecking=no -l <user> hostname -p <port> -i <identity_file>`

![Are you sure you want to continue connecting (yes/no/[fingerprint])?](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/ssh-knowhost-continue-connecting.png)

当然我们也可以将这一配置直接设置在 config 文件中，让所有链接都跳过这一校验，但这是一个不安全的操作，因此在服务器上还是别开，本地为了方便可以操作。

```config
StrictHostKeyCheckin no # 指定主机密钥检查的级别，可以设置为 yes、no 或 ask
```


- [SSH Config 那些你所知道和不知道的事](https://deepzz.com/post/how-to-setup-ssh-config.html)
- [ssh_config(5) - Linux man page](https://linux.die.net/man/5/ssh_config)
- [SSH第一次连接新主机时不询问是否继续](https://blog.csdn.net/qq_31547771/article/details/119035808)

### 如何配置服务器免密登录

- ssh、scp的使用：https://blog.csdn.net/mmd0308/article/details/73770007
- https://zhuanlan.zhihu.com/p/116025492
- linux expect详解：https://www.cnblogs.com/lzrabbit/p/4298794.html

```sh
# 生成密钥
 ssh-keygen -t rsa -C "youremai@email.com"

# 将公钥上传到服务器，此时需要输入密码的
ssh-copy-id -i ~/.ssh/id_rsa.pub root@remote-ip-or-address

# 上述的命令等同于三个步骤
# 1. 将公钥上传至
scp id_rsa.pub  <user>@<remote-ip-or-address>:/tmp
# 2. 将公钥添加到 许可密钥 文件中
cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys
# 3. 删除公钥文件
rm  /tmp/id_rsa.pub
```

- `authorized_keys`的权限不能太开放：`chmod 600 authorized_keys`


### SSH 跳板机登录

- [ssh 通过跳板机直连跳板机内网服务器](https://outmanzzq.github.io/2018/11/20/ssh-connect-through-springboard/)
- [利用ssh穿越多个跳板机最简单最高效的办法](https://blog.51cto.com/u_15214399/2823352)
- [SSH通过跳板机连接服务器](https://morland96.github.io/2017/10/31/ssh-jump/)
- [超详细：jumpserver堡垒机入门到掌握](https://www.leoheng.com/2021/01/25/%E8%B6%85%E8%AF%A6%E7%BB%86%EF%BC%9Ajumpserver%E5%A0%A1%E5%9E%92%E6%9C%BA%E5%85%A5%E9%97%A8%E5%88%B0%E6%8E%8C%E6%8F%A1/)
- [案例——只允许跳板机登录生产环境](https://blog.csdn.net/qq_21419995/article/details/80787388)
- [ssh登陆之忽略known_hosts文件](https://blog.csdn.net/yasaken/article/details/7348441)

![SSH jumpserver](https://cdn.jsdelivr.net/gh/MinsonLee/minsonlee.github.io/images/pig/20220321220444.png)


1. 如何通过跳板机连接目标机器？

```sh
ssh -J <jumpuSer>@<jumpServer>[:jumpServerPort] <tagUser>@<tagServer> -p <tagPort>
```

2. 通过 ~/.ssh/config 或 /etc/ssh_config 配置跳板机登录

```config
Host <name>
    HostName tagServer
    User <tagUser>
    Port <tagPort>
    ProxyCommand ssh <jumpuser>@<jumpserver> -W %h:%p
```

通过 `-o` 指定登录验证条件

```sh
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o CheckHostIP=false -p $port -i /home/super/.ssh/walle_key www@$1
```


## HTTPS 是如何工作的？

### HTTPS 作用

- 对内容进行加密，建立一个信息安全通道，保证数据传输安全
- 身份认证，确认网站的真实性
- 保证数据的完整性，防止内容被篡改

**SSL 加密的方式并不是为了防止数据被拦截导致数据泄漏，最主要是防止数据不会被篡改！**


## 抓包代理是个怎么回事？

### HTTPS 抓包为什么需要安装第三方证书？

http://www.361way.com/ssh-public-key/3662.html

https://developer.aliyun.com/article/628175