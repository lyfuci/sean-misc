# VNC 是什么
VNC 是 Virtual Network Console 的缩写，常用于远程控制linux系统，VNC由server、client和一组协议组成。

# 原理
服务器发送屏幕图像到客户端，客户端发送事件消息到服务器，通常会通过对比差异(仅传递不同帧之间的差异)来减少网络开销。

VNC默认使用5900到5906号TCP端口，而JAVA的VNC客户端使用5800至5806

# 安全性
VNC并非安全的协议，虽然密码传输经过加密，但仍然可以暴力破解，可通过SSH或者VPN传输增加安全性

# 安装
## centos 8 stream

yum install -y tigervnc-server

实际安装版本: tigervnc-server-1.11.0-9.el8

> tigervnc 使用端口号默认为 5900 + display

1. 添加用户display映射 /etc/tigervnc/vncserver.users.
2. 调整用户或者全局配置. See the
   vncsession(8) manpage for details. (OPTIONAL)
3. Run `systemctl enable vncserver@:<display>.service`
4. Run `systemctl start vncserver@:<display>.service`

> 1. 如果需要远程连接需要最好是使用 ssh tunnel
> 2. 远程直连的话需要把 config 里面的 localhost 设置为 no
> 3. 设置对应密码使用 vncpasswd 命令