## 概念介绍
分布式版本管理系统

### 文件状态
常见关注的状态如下

* untracked: 未跟踪
* tracked file is modified: 跟踪的文件发生了改变
* tracked file is modified and staged with git: 跟踪的文件发生了改变并且被 git add 添加到了暂存区

## 最基础配置
### 安装
centos
```bash
yum install -y git
```

### 设置用户名和邮箱
添加提交时的名字和邮箱
```bash
git config --global user.name "Your Name"
git config --global user.email "Your Email"
```
执行完之后会在 ~/.gitconfig 文件中添加如下内容
```gitconfig
[user]
    name = Your Name
    email = Your Email
```

### 创建版本库
```bash
git init
```

### 基础操作

```bash
git add <file> # 添加文件到暂存区
git commit -m <message> # 提交暂存区到仓库区
git status # 查看仓库状态
git push <upstream> <branch_name> # 推送到远程仓库
```

### 版本回退

#### 查看历史记录
```bash
git log --graph #其他常用选项 --pretty=oneline
```

#### 回退到某一版本
```bash
git reset --hard <commit_id> # 回退到某一版本
git reflog                   # 查看历史头指针位置
```

结合 `git log` 和 `git reset` 可以轻松的实现回滚相关操作

## TIPS
可能有些时候需要直接在某个linux主机上进行开发一些自动化运维脚本， 但是需要版本管理的时候却发现需要不断使用 `git status` 来查看文件是否被编辑。

下面提供了一段注释来辅助进行git文件变化的命令行提示:

```
source /usr/share/git-core/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export PS1='[\u@\h \W$(declare -F __git_ps1 &>/dev/null && __git_ps1 " (%s)")]\$ '
```

三种状态解释:
* +: 跟踪的文件发生了改变并且被 git add 添加到了暂存区
* *: 跟踪的文件发生了改变
* %: 有未跟踪到的文件