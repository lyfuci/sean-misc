# 高效使用 Ansible 的方法
* Keep Things Simple(保持事物的简单)
  * 保持 playbook 的可读性
    * 使用注释保持可读性
    * 大面积使用对齐的空格和注释
    * 复杂配置使用 j2 模板
    * 使用 yaml 原生语法，不要使用折叠式(folded)的写法
  * 使用现有模块
    * ansible 自带模块，一般具有幂等性
  * 传承 **一种标准** 的代码风格

* Stay Organized(保持项目是有组织的)
  * 保持变量名称的命名风格
    * 扁平的命名空间，能一眼看出变量的作用。例如，apache_tls_port 等
    * role 或 group 中的变量带上 role 或 group 的名字前缀
  * 标准化项目目录结构
    * 区分细化各种 playbook 的功能
  * 使用动态的 inventory
    * 目前各种云平台都有提供动态 inventory 的功能
  * 使用 分组(inventory) 的优势
    * 注意 host 会继承 组变量，重复时会使用最后一个加载的变量
  * 使用 role 来重用你的代码
  * 在中心节点上运行 ansible-playbook

* Test Often(经常测试)
  * 测试 task 的结果
  * 使用 Block/Rescue 来回复或者回滚
  * 尽量用最新版本的 ansible 开发 playbook
  * 使用测试工具
    * --check or --syntax-check
    * ansible-lint 

# 管理 inventory

## inventory 插件介绍
每种 inventory 格式的支持都是通过插件的形式实现的，激活插件的位置在 ansible.cfg 的 inventory 块下的 enable_plugins 指令。

常用插件有如下几种
* host_list
* script
* auto
* yaml
* ini
* toml


## yaml 格式的 inventory
一个典型的 yaml 格式的 inventory 如下所示。

```yaml
workstation:
  hosts:
    host1.example.com:
    host2.example.com: # 这里的主机名不一定是真是的主机名，可以是别名, 然后在 ansible_host 变量中指定真实的主机名
      key1: value2
    host3.example.com:
  vars:
    key2: value2
```

yaml 格式可以以嵌套的形式来一层一层的定义组和主机，也可以使用扁平的形式来定义组和主机。

其中也包含了一些特殊的组名  all (表示所有的主机) 和 ungrouped (表示没有分组的主机)。

不同格式的配置可以通过 ansible-inventory 命令来进行转换和查看，所以这里就不介绍其它命令了。

下面的 demo 把一个 ini 格式的 inventory 转换成 yaml 格式的 inventory。

```shell
ansible-inventory --yaml -i inventory --list --output inventory.yaml
```

> TIPS: 需要注意一下，转换之后的结果虽然等价，但是写法可能不一定是最优的,且一定不要在有定义变量的 ini 格式 inventory, 转换后还继续编辑，除非你完全理解你在做什么。 

## yaml 排障

**冒号后面跟着空格**
```yaml
title: Ansible: Best Practices # the second colon produces a error
file: Not:a:problem # No space after the colon means no special treatment
simple: 'Quoting the value with the : character solve this problem'
double: "Double quotes also work with the : but permit escaped characters like \n"
```

**变量作为一个值的开始**

ansible 会把以 `{{ variable }}` 开头的值当做变量，但是任何以 { 开头的值在 yaml 中都会解析为对象，所以需要双引号把开头带变量的值引用起来。 foo: "{{ variable }} rest of the value"

通常来说，当使用下面任何一个字符时都需要使用双引号引用起来。

[] {} > | * & ! % # \ @ ,

**明白字符串和布尔、浮点的差别**

```yaml
active: yes # this is a boolean
active_str: "yes" # this is a string
```
```yaml
temperature: 36.5 # this is a float
version: "2.0" # this is a string
```


## 管理 inventory 变量
变量可以让项目重用且更灵活，可以在下面的位置定义变量
1. 在 role defaults 和 vars 中描述变量
2. 在 inventory 中可以定义 主机变量和主机组变量
3. 在 playbook 或者 inventory 下的 group_vars 或者 host_vars 子目录中的变量文件
4. 在 playbook、role 或 task 中

原则:
1. 保持简单
   1. 尽可能只在少数几个地方定义变量
2. 不要重复自身
   1. 不要重复定义相同的变量
3. 在一个较小、可读的文件中组织变量
   1. 比如 group_vars 目录下定义 web_server 目录下定义 firewall.yaml 定义所有关于防火墙相关的变量

### 变量的优先级和合并
从低到高如下:

1. 命令行参数
   1. 命令行的参数会覆盖配置文件中的参数
   2. 命令行中的参数除了 -e 指定的变量，拥有最高的优先级，其它的优先级都是最低的，比如 -u 指定 用户
2. role defaults 变量
   1. 在 rolename/defaults 中设置的变量值
3. 主机和主机组变量
   1. 可以在多个位置设置
      1. inventory 或者动态 inventory 中定义的 主机组 变量
      2. all 主机组在 inventory 的 group_vars/all 中定义的变量
      3. all 主机组在 playbook 的 group_vars/all 中定义的变量
      4. 自定义 主机组在 inventory 的 group_vars/all 中定义的变量
      5. 自定义 主机组在 playbook 的 group_vars/all 中定义的变量
      6. inventory 或者动态 inventory 中定义的 主机 变量
      7. inventory host_vars 子目录下的 主机 变量
      8. playbook host_vars 子目录下的 主机 变量
      9. facts 变量或者缓存的 facts 变量
4. play 下的变量
   1. play 下的 vars 部分
   2. vars_prompt 部分
   3. vars_files 部分
   4. rolename/vars 部分
   5. 当前 block 下的 vars 部分
   6. 当前 task 下的 vars 部分
   7. 使用 include_vars 动态加载
   8. set_fact 模块 或者 register 记录的 针对 特定主机的变量
   9. include_role 的 vars 部分
   10. include_tasks 的 vars 部分
5. 额外变量 (extra vars)
   1. 命令行中使用 -e 指定的变量 

### 从 inventory 中分离变量
比较好的一个分离结果如下，按照主机组分离变量，然后在 playbook 中引用。

![split-vars-from-inventory.png](../img/split-vars-from-inventory.png)

### 特殊的 inventory 变量
* ansible_connection: 连接方式
  * ssh
  * local
* ansible_host: 实际ip 或者 全限定主机名，ansible 实际连接的主机
* ansible_port: 实际连接的端口
* ansible_user: ansible 在没配置的情况下，默认使用运行 playbook 当前用户，指定之后会使用该用户连接
* ansible_become_user: 提权用户，可以使用 ansible_become_method 指定提权方式
* ansible_python_interpreter: python 解释器路径

> inventory_hostname: ansible 中的主机名
> ansible_host: 实际连接的主机名或者 ip
> ansible_facts['hostname']: ansible 收集的主机名，非全限定名
> ansible_facts['fqdn']: ansible 收集的全限定主机名


# 管理 task 执行
