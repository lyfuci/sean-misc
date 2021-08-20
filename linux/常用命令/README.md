{:toc}


# 文件
## 查找文件
### find
* 按用户查找

查找用户 user_name 的文件

`find / -user user_name`

* 按大小查找

查找大小199M-300M的文件

`find / -size +199M -300M`

* 按时间查找

1-2天修改过的文件

`find / -mtime -2 -mtime +1`

1-2分钟内修改过的文件

`find / -mmin -2 -mtime +1`

> find 命令常常会跟 -exec 部分来对查找到的部分进行下一步命令<br>
> exam:<br>
> find / -name default 2>>/dev/null -exec ls -alhd {} \; <br>
> 2>>/dev/null 排除部分异常信息


