# 同步文件
这个脚本使用 rsync 同步多个主机间的文件，免密需要提前配置即可不需要输入密码，能保证本机文件或者目录在目标机器相同位置也存在

常用于同步集群的配置

# demo
比如我有三台机器 host1 host2 host3

在host1上执行如下操作:
```bash
[root@host1 ~]# pwd
/root
[root@host1 ~]# mkdir test
[root@host1 ~]# echo aaa > test/aaa
[root@host1 ~]# ./xsync.sh test/
========== host1 ==============
sending incremental file list

sent 79 bytes  received 17 bytes  192.00 bytes/sec
total size is 4  speedup is 0.04
========== host2 ==============
sending incremental file list
test/
test/aaa

sent 129 bytes  received 39 bytes  112.00 bytes/sec
total size is 4  speedup is 0.02
========== host3 ==============
sending incremental file list
test/
test/aaa

sent 129 bytes  received 39 bytes  336.00 bytes/sec
total size is 4  speedup is 0.02

```


上面的操作就可以保证在 host2 和 host3 的 /root/test 文件夹内容和 host1完全一致