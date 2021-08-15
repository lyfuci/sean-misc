[toc]



# 按需挂载
在使用时自动挂载

# 安装软件
yum install autofs

# 启动软件
启动并开机启动

`systemctl enable autofs --now` 

# 文件配置
`/etc/auto.master` 文件内容:

```txt
/misc /etc/auto.misc
```
表示按照 `/etc/auto.misc` 的配置按需挂载到 `/misc` 目录

`/etc/auto.misc` 文件内容:

```txt
cd    -fstype=iso9660,ro,nosuid,nodev :/dev/cdrom
```
表示访问 `cd` 这个目录时 以指定的参数 将 `/dev/cdrom` 设备挂载到这个目录