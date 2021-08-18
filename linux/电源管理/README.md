# tuned 介绍
tuned 是一项守护程序，它会使用 udev 来监控联网装置，并且根据选择的配置文件对系统设置进行静态和动态的微调。它有许多为常见使用案例（例如高吞吐量、低延迟或者节电）的预定义配置文件，并且允许用户更改为每个配置文件定义的规则，还可以自定义如何对一个特定的设备进行微调。若要通过某个配置文件还原系统设置的所有更改，您可以切换到另一个配置文件，或者停用 tuned 守护程序。

# tuned 安装
`yum install -y tuned`

# 启动并设置开机启动服务
`systemctl enable tuned --now`
> 图形 target 默认自带了

# 操作
## 列出所有默认配置

`tuned-adm list`

## 当前的调优配置

`tuned-adm active`

## 切换配置
`tuned-adm profile desktop`

> 可以一次性激活多个配置，tuned 会尝试将它们合并

## 推荐配置
依据当前系统情况推荐配置
`tuned-adm recommand`