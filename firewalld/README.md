# firewalld 介绍、

Firewalld 提供了可被动态管理的防火墙，并且支持以 network/firewall zone 的概念定义网络连接和接口的可信级别。 支持IPv4,IPv6防火墙设置，以太网桥和IP sets. 

它是运行时(runtime)和持久化(permanent)配置分离的。他也提供了接口来给应用和服务直接添加防火墙规则。

## firewalld的优点
runtime 环境的配置修改会立刻生效，不需要重启服务和守护进程。
使用 firewalld D-Bus 接口对于应用、服务和用户来说都非常容易适配防火墙配置。这些接口是完整的，并且firewall-cmd, firewall-config, fireall-applet等防火墙配置工具都在使用。

因为分离了运行时和持久化的配置，所以可以用运行时配置进行评估实践。运行时配置只在下次服务 reload 或 restart 和系统重启之前生效，之后持久化的配置会被再次加载。
运行时的配置，如果被评估为没有问题，也能直接用命令行将运行时配置变为持久化的配置。

## 概念
zone: interface + rule构成


## 调整rule

### 调整端口规则

在默认的zone里面放行一个9888的tcp端口
```bash
firewall-cmd --add-port=9888/tcp
```

在默认zone里面删除一个9888的tcp端口
```bash
firewall-cmd --remove-port=9888/tcp
```

### 调整服务规则

预先定义好的规则可以在目录 /usr/lib/firewalld/services 下面查找，比如 vnc-server.xml 具体内容如下:
```xml
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>Virtual Network Computing Server (VNC)</short>
  <description>A VNC server provides an external accessible X session. Enable this option if you plan to provide a VNC server with direct access. The access will be possible for displays :0 to :3. If you plan to provide access with SSH, do not open this option and use the via option of the VNC viewer.</description>
  <port protocol="tcp" port="5900-5903"/>
</service>
```
在一个service文件里面能定义多个端口和协议的组合

在默认zone里面增加一个协议
```bash
firewall-cmd --add-service=vnc-server
```
在默认zone里面删除一个协议
```bash
firewall-cmd --remove-service=vnc-server
```

### 调整 rich-rules

在默认zone里面添加一个rich rule
```bash
firewall-cmd --add-rich-rule='rule family="ipv4" source address="3.3.3.3/32" destination address="2.2.2.3/32" service name="dns" drop'
```
在默认zone里面删除一个rich rule
```bash
firewall-cmd --remove-rich-rule='rule family="ipv4" source address="3.3.3.3/32" destination address="2.2.2.3/32" service name="dns" drop'
```

## 持久化临时(runtime)规则

firewall-cmd --runtime-to-permanent