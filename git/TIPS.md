## TIPS1 linux 上的直接管理
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