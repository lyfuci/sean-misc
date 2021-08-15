[toc]

# VDO简介
Virtual Data Optimizer(VDO)以重复数据删除（deduplication）、压缩和精简置备的形式为 Linux 提供内联数据降低。当您设置 VDO 卷时，您可以指定一个块设备来构建 VDO 卷以及您要存在的逻辑存储量。

在托管活跃虚拟机或容器时,红帽建议使用 10:1 逻辑与物理比例置备存储：也就是说,如果您使用 1TB 物理存储,您将会把它显示为 10TB 逻辑存储。
对于对象存储,如 Ceph 提供的类型,红帽建议您使用 3:1 逻辑与物理比例：1TB 物理存储将显示为 3TB 逻辑存储。
在这两种情况下,您只要将文件系统放在 VDO 出示的逻辑设备之上,然后直接将其用作分布式云存储构架的一部分。

由于 VDO 是迅速置备的，所以文件系统和应用程序只会看到使用中的逻辑空间，且不知道可用的实际物理空间。使用脚本来监控实际可用空间并在使用超过阈值时生成警报：例如,当 VDO 卷达到 80% 时。

# 使用步骤
## 安装软件

`yum install kmod-kvdo vod -y`

## 创建 vdo 的分区

`vdo create --name=voddemo --device=/dev/sdb --vdoLogicalSize=100G`

上面的命令执行完成后会告诉我们应该用哪个设备(example: /dev/mapper/voddemo)来访问了vdo处理之后的设备

我们有一个 10G 的硬盘 /dev/sdb，将 /dev/sdb 当做一个一个逻辑大小 _100G_ 的分区使用，这符合上面说的容器理论场景的放缩比例，但是实际上应该不会有这么小的容器专用分区

## 格式化
mkfs.ext4 或者 mkfs.xfs 来对 /dev/mapper/voddemo 进行格式化

## 然后进行挂载
### 临时挂载
`mount /dev/mapper/voddemo /voddemo`

### 持久挂载
/etc/fstab
```
/dev/mapper/voddemo /voddemo  xfs defaults,_netdev 0 0
```
如果 VDO 卷位于需要网络的块设备中,如 iSCSI,请添加 _netdev 挂载选项。


# 操作指令

* `vdo --help` # 查看vdo 相关指令


* `vdostats --human-readable` # 以人可读的情况展示vdo相关块设备


