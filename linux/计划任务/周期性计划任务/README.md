[toc]


# 周期性计划任务

## 前提条件
1.安装 cronie
```bash
yum install cronie
```
2. crond 在运行
```bash
systemctl status crond
```


## 编辑计划任务

### 编辑当前用户的 crontab
```bash
crontab -e
```
> 1. 只有root用户能使用-u 参数指定查看别人的计划任务
> 2. 一般是直接执行一个脚本，而不是分开的命令

进入计划任务编辑之后操作和 vi 一样，格式遵循如下格式:
```crond
* * * * * /path/to/script
```
> 前面五个字段分别为 分 时 日 月 周几
### 全局计划任务文件编辑
```
vi /etc/crontab
```
> 这个文件编辑的主要不同是在 时间 和 执行的脚本命令 中间需要增加 user-name 来指定用户


## 查询周期计划任务列表

```bash
crontab -l
```

## 删除周期性计划任务
也是编辑时即可删除

## 控制周期性计划任务的使用权限
/etc/cron.allow 和 /etc/cron.deny 文件决定了谁可以提交周期性计划任务和谁不能提交周期性计划任务

白名单规则优于黑明单，建议只使用一个名单

## 特殊用法
### 精确到秒的控制

`* * * * * sleep 5; /path/to/script`
这个示例表示每分钟的第五秒执行指定脚本
