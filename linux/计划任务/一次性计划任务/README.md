[toc]


# 一次性计划任务

## 前提条件
1.安装 at
```bash
yum install at
```
2. atd 在运行
```bash
systemctl status atd
```


## 增加一次性计划任务
```bash
at 00:07 2021-08-19
> touch /home/user/newfile
> <EOT>
```
> 1. 结束一次性计划任务使用 ctrl+D
> 2. 一般是直接执行一个脚本，而不是分开的命令

## 查询一次性计划任务列表

```bash
[root@iscsi-server ~]# atq
4       Thu Aug 19 01:00:00 2021 a root
5       Fri Aug 20 00:01:00 2021 a root
6       Fri Aug 20 00:01:00 2021 a root
```

## 查询一次性计划任务详情

```bash
atq -c 6
```
> 可以看到实际上一次性计划任务是用`/bin/sh`或者自己指定的 SHELL 执行这一段脚本

## 删除一次性计划任务

```bash
atrm 4
```

## 控制一次性计划任务的使用权限
/etc/at.allow 和 /etc/at.deny 文件决定了谁可以提交一次性计划任务和谁不能提交一次性计划任务

白名单规则优于黑明单，建议只使用一个名单