# 简介
Registry 是一个无状态、高度可扩展的服务器端应用程序，用于存储和分发 Docker 镜像。

## bootstrap 脚本

[bootstrap.sh](script/bootstrap.sh)

这个脚本提供了一下三个功能以便简要操作 registry
1. 列出所有 repository 
```shell
./bootstrap.sh $registry_url list
```
2. 列出 repository 下 的所有tag
```shell
./bootstrap.sh $registry_url list $repo
```
3. 删除特定 repository:tag
```shell
./bootstrap.sh $registry_url delete $repo $tag
```

> 需要依据脚本先登录 registry 以提供 base authentication