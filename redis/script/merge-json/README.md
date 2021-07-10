# 前提（prerequisite）
安装的redis中带有 [redis-json](https://oss.redislabs.com/redisjson/commands/?undefined#overview) 相关模块，并在配置文件中load。

也可以直接拉取相关 [镜像](https://hub.docker.com/r/redislabs/redismod) 使用

# 需求
在用redis存储数据时碰到了需要将多个部分数据合并，并在判断数据已经完整后将data3存入另一个set并等待其它任务读取的情况。

> 目前(2021-07-10)redis-json尚未提供merge的实现。

# 思路
一般认为网络的传输效率相比计算机的计算效率是十分低下，所以为了减少网络传输的次数redis一般使用pipeline,或者lua script对数据进行处理。

此处提供一个脚本，可以将如下数据合并，实际效果为: 
data1 + data2 = data3

data1:
```json
{
  "a": "a",
  "b": "b"
}
```
data2:
```json
{
  "b": "d",
  "c": "c"
}
```

data2:
```json
{
  "a": "a",
  "b": "d",
  "c": "c"
}
```

# 其它实现
作者使用java作为主要开发语言，其实还有可以用hash数据结构实现相同的效果，不过需要遍历 data object 的所有字段，然后使用pipeline的形式进行数据传输。
