[toc]

# 简述

Secure Shell (SSH) 是一种加密网络协议，用于在不安全的网络上安全地运行网络服务。典型应用包括远程命令行、登录和远程命令执行，但任何网络服务都可以通过 SSH 进行保护。

常见用法:
* 登录及文件传输
* 隧道(端口转发)


# 用法示例
## 登录及文件传输
这可能是 ssh 最常用的用法了，使用 ssh 登录仅需使用客户端连接到指定服务器的 IP 端口即可, 在此就不赘述了。文件传输的用法可以参见 sftp 和 scp 相关协议。

## 隧道(端口转发)
隧道一般是指在不兼容的网络上传输数据( ipv4 和 ipv6 的数据传输 )，或在不安全网络上提供一个安全路径( ssh )。
这里说明一下端口转发的两种常见用法。


### 本地端口转发
下面的命令将访问 local_ip:local_port 的请求转发到 remote_ip:remote_port
```shell
ssh -L local_ip:local_port:remote_ip:remote_port -p ssh_port username@ssh_ip
```

### 远端端口转发
下面的命令将ssh_ip 主机可感知的 remote_ip:remote_port (一般来说就是 ssh_ip 主机的相关 ip 和端口)收到的请求转发到本地的 local_ip:local_port (local_ip:local_port不一定是本机，可以是本机可访问的别的机器的配置)

```shell
ssh -gfNCR remote_ip:remote_port:local_ip:local_port -p ssh_port username@ssh_ip
```

> 注意: 可能需要配置 sshd_config 文件的 `GatewayPorts yes` 才能把别的机器访问 remote_ip:port 的请求转发过来
> 要允许转发, 可能还需要开启 `AllowTcpForwarding` 等相关参数