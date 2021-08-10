# pxe+kickstart 自动化部署
_pxe_ : (Preboot Execution Environment的缩写,即预启动执行环境)是由Intel设计的一种网络协议，可使计算机通过网络启动安装系统，同时也是一种使用网络接口启动计算机的机制，其不依赖本地数据存储设备或本地已安装的系统；协议分为client端和server端，PXE client在网卡的boot ROM中启动，当计算机开机引导时，BIOS把PXE client调入内存执行，并显示出命令菜单，经用户选择需要安装的系统后，PXE client将放置在远端的操作系统通过网络下载到本地运行；

_kickstart_ : 记录安装linux安装过程的文件，一般在已经装好的系统里面的 `/root/anaconda-ks.cfg` 可以找到


# 实现过程
角色 server(提供pxe + kickstart 服务)/client(待安装操作系统的主机)
1. client 存在有pxe芯片的网卡(一般都支持)
2. 服务端至少有 dhcp、tftp、文件服务(ftp、http、nfs)三种服务
3. bios 通过网卡的pxe功能向 server(dhcp) 请求ip
4. server(dhcp) 向 client 返回 ip 、 next-server 和 pxelinux.0 文件 (pxelinux.0和其它配置文件都可以通过安装 syslinux 在 /usr/share/syslinux 目录中找到，仅 default 文件需要手工编写)
5. 读取 pxelinux.0 文件之后 会从 next-server(tftp) 读取配置文件 tftp-root/pxelinux.cfg/default 获取引导启动的菜单项
6. 等待用户选择安装系统后，client 向 server (tftp) 发出提供内核文件vmlinuz和文件系统initrd.img请求 
7. server(tftp) 收到 client 请求后，提供 vmlinuz 和 initrd.img 文件
8. client 执行 vmlinux 和 .img 文件 ,依据 default 文件中的配置 向 server(文件服务) 请求相关 kickstart 脚本和安装软件包的文件，进行自动安装

//TODO: 添加示例文件