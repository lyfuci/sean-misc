[toc]

# SELinux简介
安全增强型 Linux（SELinux）是一种采用安全架构的 Linux® 系统，它能够让管理员更好地管控哪些人可以访问系统。它最初是作为 Linux 内核的一系列补丁，由美国国家安全局（NSA）利用 Linux 安全模块（LSM）开发而成。

SELinux 于 2000 年发布到开源社区，并于 2003 年集成到上游 Linux 内核中。

# 配置文件
`/etc/sysconfig/selinux` 可以在配置文件中配置允许模式、强制模式还是处于禁用状态，以及要加载哪个策略。

# SELinux 标签和类型强制访问控制
类型强制访问控制和标签是 SELinux 中最为重要的两个概念。

SELinux 可作为标签系统运行，也就是说，系统中的所有文件、进程和端口都具有与之关联的 SELinux 标签。标签可以按照逻辑将目标组合分类。在启动过程中，内核负责管理标签。

标签的格式为 user:role:type:level（level 为可选项）。User、role 和 level 用于类似 [MLS](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/mls) 的更高级的 SELinux 实施中。标签类型对于目标策略而言最为重要。

SELinux 利用类型强制访问控制来强制执行系统中定义的策略。类型强制访问控制是 SELinux 策略的一部分，它定义了特定类型的进程能否访问标记为特定类型的文件。

# 自主访问控制（DAC）与强制访问控制（MAC）
传统上，Linux 和 UNIX 系统都采用 DAC。SELinux 是 Linux 采用 MAC 机制的一个示例。

对于 DAC 而言，文件和进程都有相应的所有者。您可以让用户拥有某个文件，让群组拥有某个文件，或让其他人（可以是其他任何人）拥有某个文件。用户可以更改自己文件的权限。

根用户对 DAC 系统拥有完全访问控制权。如果您拥有根访问权限，则可以访问其他任何用户的文件，或在系统上执行任何操作。

但在像 SELinux 这样的 MAC 系统上，访问权限有相应的管理设置策略。即使主目录上的 DAC 设置发生更改，SELinux 策略也会阻止其他用户或进程访问目录，从而保证系统的安全。

SELinux 策略可以让您针对性设置，并且涵盖大量进程。您可以对 SELinux 进行更改，以限制用户、文件、目录等等之间的访问。

# 文件上下文操作
一般来说MLS可能使用的不会很多，更多的针对文件系统的可能是针对文件系统来打上上下文类型标记，也就是selinux 标签中的第三个字段
## 查看指定文件的 selinux 上下文
`ls -Z`

## 修改指定文件的安全上下文
把 a 文件的安全上下文变成wawawa
`chcon -t wawawa a`

> 如果文件安全上下文配置的是其他类型，则恢复操作会让简单的修改文件安全上下文变成配置的规则中的上下文


## 查看 selinux 文件安全上下文的生成规则
`semanage fcontext -l`
## 添加 selinux 文件安全上下文的生成规则
增加一条规则把/var/my/web/page目录及下面的所有文件的类型修改为my_type
`semanage fcontext -a -t my_type '/var/my/web/page(/.*)?'`
> my_type 应该是实际支持的类型
## 恢复不正确的上下文
`restorecon -r /dir/to/restore`

> 在根目录下创建 .autorelabel 重启之后会自动恢复不正确的上下文

# 端口上下文操作
## 查询所有端口上下文标签
`semanage port -l`

## 添加端口
给 12345/tcp 增加 http_port_t 类型的安全上下文标签
`semanage port -a -t http_port_t -p tcp 12345`


# selinux boolean 值
布尔值是 SELinux 中功能的开/关设置。开/关 SELinux 功能的设置有数百种，而且许多设置已预定义。您可以通过运行 getsebool -a，找出系统中已设置的布尔值。

## 获取 boolean 值，及附带的描述
`semanage boolean -l`

## 设置 boolean 值
开启
`setsebool -P samba_create_home_dirs on`
`semanage boolean -m virt_use_comm -1`
关闭
`setsebool -P samba_create_home_dirs off`
`semanage boolean -m virt_use_comm -0`

