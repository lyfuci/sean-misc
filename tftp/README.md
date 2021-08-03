# tftp 是什么
tftp 是小型文件传输协议(Trivial File Transfer Protocol, TFTP) 默认端口69,使用UDP，所以通常在局域网内使用，协议较为简单，没有其它更为健壮的文件传输协议的许多功能，如删除等操作。 


# 数据类型
1. netascii 对应 ftp 中的 ASCII
2. octet 对应 ftp 中的 image
3. mail 目前已废弃

# 通信流程
1. 初始化主机A送一个读请求（RRQ）或写请求（WRQ）包给主机B，包含了文件名和传输模式。
2. B向A发一个ACK包应答，同时也通知了A其余送往B包应该发送的端口号。 
3. 源主机向目的主机送编过号的数据包，除了最后一个都应该包含一个全尺寸的数据块。目的主机用编号的ACK包应答所有的数据包。 
4. 最终的数据包必须包含少于最大尺寸的数据块以表明这是最后一个包。如果被传输文件正好是尺寸块的整数倍，源主机最后送的数据包就是0字节的。 


# 安装 
## centos
```bash

yum install -y tftp-server
systemctl start tftp-server --now
```
