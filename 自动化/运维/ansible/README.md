# Ansible 概念
ansible doc url click [here](https://docs.ansible.com/ansible-core/devel/).

## Inventory
Inventory 文件定义了一组被管理的主机和主机组, 分为 静态 Inventory 和 动态 Inventory ,静态 Inventory 为写死在文件中的内容，动态 Inventory 则是由脚本通过数据源对被管理的主机和主机组进行获取。

### 静态 Inventory
静态 Inventory 文件的常用格式有 **ini** 格式和 **yaml** 格式两种;

附带一些 默认组，**all** 和 **ungrouped** 分别代表 **所有** 主机和 **未分组** 的主机

指定组为 **localhost**的时候 就是仅对本机进行操作

复杂规则:
1. 一个主机可以属于多个组;
2. 组的 `:children` 属性可以包含其它组和主机;
3. 主机支持数字和字母的范围 `[a:z]` `[0:255]`

#### 查看 Inventory 包含的主机信息

file `./inventory` content: 
```ini
servera
serverb
serverc
serverd

[groupa]
servera

```

```bash
# 列出 inventory 文件 中 all 组 下面的所有主机
# -i 指定 inventory 文件 **可以指定多个**
ansible -i inventory all --list-hosts
```

inventory 文件读取顺序:
1. /etc/ansible/hosts (默认文件 不加 -i 参数的时候就会读取这个文件 )
2. -i 参数指定的文件 (一旦指定了 -i 参数就不会使用 /etc/ansible/hosts 文件了)

### 动态 inventory
动态 inventory 文件一般为一个脚本

* 必修: 脚本 `./dynamic_script.py --list` 的运行结果应该与 `ansible-inventory -i static_inventory --list` 格式一致
* 选修: `./dynamic_script.py --host hostname` 打印对应 host 的变量信息

## ansible 配置文件

### 查看当前使用的 配置文件

```bash
ansible --version
```

配置文件读取优先级(数字越大优先级越高):
1. `/etc/ansible/ansible.cfg`
2. `~/ansible.cfg`
3. `./ansible.cfg`(常用)
4. `ANSIBLE_CONFIG` 环境变量所指定的位置

### 配置文件的基本内容
```ini
# 基础配制
[defaults]
# inventory 文件的位置
inventory      = /etc/ansible/hosts
# 以什么用户远程登录
remote_user    = someuser
# 登录用户是否需要密码
ask_pass       = false

# 提权配置
[privilege_escalation]
# 需要提权
become          = true
# sudo 提权
become_method   = sudo
# 提权为 root 用户
become_user     = root
# 提权不需要输入密码
become_ask_pass = false


[inventory]
[paramiko_connection]
[ssh_connection]
[persistent_connection]
[accelerate]
[selinux]
[colors]
[diff]
```

## adhoc
adhoc 是一次性运行的命令，格式一般如下:

`ansible host-pattern -i inventory -m module -a 'args' `
* -m 模块
* -a 模块参数
* host-pattern 匹配主机和主机组的模式串
---
下面的参数playbook也能用
* -i inventory 文件
* -v 使用的配置变量 和 Facts变量
* -vv 使用的所有配置 和 task path
* -vvv 连接、用户、命令及参数、已经模块所有的缺失参数情况 `一般这一级debug常用`
* -vvvv 所有参数命令及结果详情
* --syntax-check

## ansible-doc
查看模块文档

### 查看所有模块文档
`ansible-doc -l`

### 查看模块文档详情
`ansible-doc module-name`

## 常用模块
官方提供的常见模块一般都是幂等的，模块参数描述的都是最终的状态

Files Modules:
* copy: 拷贝本地文件到被管理主机
* file: 文件、链接、目录的删除，设置权限、selinux上下文和其它文件属性等
* lineinfile: 确认文件内是否存在特殊的一行文本，或者替换一行文本
* synchronize: 使用 rsync 同步内容
* blockinfile: 插入、更新、删除一个被自定义标记行标记的多行文本块
* fetch: 与 copy 模块类似，但是方向相反，从被管理主机拷贝到控制节点
* stat: 跟 stat 命令一样获取文件状态信息
* sefcontext: 设置文件安全上下文

Software package modules:
* package: 管理包使用自动检测操作系统的本地包管理工具
* yum: centos
* apt: ubuntu
* dnf: centos
* gem: ruby gems
* pip: python packages from pypi

system modules
* firewalld: 管理端口和服务，使用firewalld
* reboot: 重启机器
* service: 管理服务
* user: 添加删除和管理用户
* selinux: selinux 上下文设置


net tools modules
* get_url: 使用http、https、ftp下载文件
* nmcli: 管理网络
* uri: 和web服务进行交互

## playbook 示例
下面的 playbook 保证 servera 上有一个uid为 2000 的 seansun 用户
```yaml
---
# first play
# play name (subject)
- name: this is my first play
  # remote_user: remoteuser # 设置remote user
  # become_method: sudo # 提权方法
  # become: true # 是否提权
  # gather_facts: false # 是否收集 fact 变量
  # play with (object)
  hosts:
    - servera
  # play what (predicate)
  tasks:
    - name: seansun exists with UID 4000
      user: # 模块名
        name: seansun # 模块参数
        uid: 2000
        state: present

```

## 变量
### 命名规则
1. 不要空格( )和点(.)，使用下划线(_)分割的变量命名方式
2. 不能以数字开头
3. 不要使用特殊符号( $ 等)

### 变量范围和优先级
1. 全局范围: command line 和 ansible configuration 里面设置的变量
2. play 范围: play 和相关结构中设置的变量
3. host 范围: inventory 中设置在主机组和单独的主机上，fact gathering 和 注册的 tasks 上的变量

inventory 中的变量会被 playbook 中的变量覆盖，playbook 中的变量会被命令行变量覆盖。

### playbook 中定义变量
```yaml
---
- name: I am a var demo
  hosts: all
  vars:
    vara: hello
    varb: world
```

### 命令行定义变量

参数 -e name=var

### 在 inventory 中定义变量

下面分别针对主机和主机组设置变量

`inventory` 文件:
```
servera name=var1
serverb name=var2
serverc name=var3
serverd name=var4

[groupa]
servera
serverb

[groupa:vars]
gname=groupa

```

### 变量文件中使用
1. playbook 同目录下定义变量文件 my_vars.yml
```yaml
user: lilei
home: /home/lileihome
```

2. 在playbook中使用

```yaml
---
- name: I am a var demo
  hosts: all
  vars_files:
    - my_vars.yml
```
> 一般在 ansible 和 docker-compose 这类所有文件都在一个目录中的文件，都建议使用相对路径，整个文件移动时不会出现路径需要调整的情况


### 变量打印
变量打印可以交给 debug 模块，示例如下
```yaml
---
- name: test debug
  hosts: localhost
  vars:
    first_name: wakaii
    first_val: じゃない
    second_name: aaa
  tasks:
    - debug:
        var: second_name
    - debug:
        msg: "{{first_name}} is {{first_val}}"
```
> var 直接输入变量名, msg 则是需要模板占位符和双引号 
> 嵌套变量不推荐 点 来引用如有个变量是 a.b.c ，推荐 a['b']['c']

## 变量
### register 变量

如果下一个 task 依赖上一个 task 的运行结果，这时候就需要有个变量能吧上一个 task 的结果记录下来;

```yaml
---
- name: register var demo
  hosts: localhost
  tasks:
    - name: install httpd
      yum:
        name: 
          - httpd
        state: latest
      register: install_result
    - debug:
       var: install_result
```

下图是成功运行打印的一个结果示例:
```
TASK [debug] ***************************************************************************************************************************************************************************************
ok: [localhost] => {
    "install_result": {
        "changed": true,
        "failed": false,
        "msg": "",
        "rc": 0,
        "results": [
            "Installed: httpd",
            "Installed: apr-util-openssl-1.6.1-6.el8.x86_64",
            "Installed: httpd-2.4.37-10.module+el8+2764+7127e69e.x86_64",
            "Installed: mod_http2-1.11.3-1.module+el8+2443+605475b7.x86_64",
            "Installed: httpd-filesystem-2.4.37-10.module+el8+2764+7127e69e.noarch",
            "Installed: apr-1.6.3-9.el8.x86_64",
            "Installed: httpd-tools-2.4.37-10.module+el8+2764+7127e69e.x86_64",
            "Installed: redhat-logos-httpd-80.7-1.el8.noarch",
            "Installed: apr-util-1.6.1-6.el8.x86_64",
            "Installed: apr-util-bdb-1.6.1-6.el8.x86_64"
        ]
    }
}
```
> task 运行错误时可能需要配合如 ignore_errors 等其它参数对流程进行控制，才能使 playbook 继续执行

### fact 变量
fact 变量是被控制主机上面被 **自动** 发现的变量，包括了大量的主机的相关信息，比如，主机名、内核信息、网卡信息、ip信息、操作系统版本、环境变量、CPU数量、内存信息、
磁盘信息等。

> setup 模块会自动的收集变量并可以在 playbook 中使用，可以使用 gather_facts 来禁用收集 facts 变量<br>
> 自定义fact变量，可以在被管理主机的 /etc/ansible/facts.d 下创建 .fact 结尾的文件,内容可以是 json 或者<br>
> ini 格式(没有考证，不过类似下面的格式)，动态创建 fact 的脚本输出必须是 json 格式
> 
> ```ini
>  [packages]
>  web_pkg = httpd
> ```

### magic 变量
可以使用 `ansible localhost -m debug -a 'var=hostvars'` 查看，里面都是主机和主机组相关的配置信息


### 变量使用

#### 变量加密
在实际环境中，可能遇到账号、密码、密钥等可能暴露的情况，这种情况下可以使用ansible-vault对相应的文件或者内容进行加密操作
##### 创建密文文件

`ansible-vault create secret.yml`

##### 修改密文文件内容

`ansible-vault edit secret.yml`

##### 修改密文文件密钥

`ansible-vault rekey secret.yml`

##### 查看

`ansible-vault view secret.yml`

##### 加密明文文件

`ansible-vault encrypt secret.yml`

##### 解密明文文件

`ansible-vault decrypt secret.yml`

> 上面需要密码的命令的面膜都可以通过  --vault-id some_file 传入，解决命令交互问题
> 一个vault-id 的格式是 tag@file, 多个密钥的输入可以用tag来进行标记，ansible会对所有密钥进行尝试


## 流程控制

### 循环控制
在 playbook 的 tasks 中加入 loop(yaml 列表) 元素来使task魂环

```yaml
---
- name: add users
  hosts: servera.lab.example.com
  vars:
    users:
      - name: user1
        group: group1
      - name: user2
        group: group2
  tasks:
  - name: add group
    group:
      name: "{{item.group}}"
      state: present
    loop: "{{users}}"
  - name: add user
    user:
      name: "{{item.name}}"
      group: "{{item.group}}"
      state: present
    loop: "{{users}}"
```

### 仅在特定条件下运行task
仅在没有 用户和组 的主机上添加对应用户和主机
```yaml
---
- name: add users
  hosts:
    - servera.lab.example.com
    - serverb.lab.example.com
  vars:
    doit: true
    users:
      - name: user1
        group: group1
      - name: user2
        group: group2
  tasks:
    - name: add group
      group:
        name: "{{item.group}}"
        state: present
      loop: "{{users}}"
      when: doit
    - name: add user
      user:
        name: "{{item.name}}"
        group: "{{item.group}}"
        state: present
      loop: "{{users}}"
      when: doit
```
> when 后面的条件是不需要引号和花括号的 且 loop 里面的 item 也能用来进行条件判断 <br>
> 常用判断符号: 
>  <br> 1. == 
>  <br> 2. != 
>  <br> 3. > 
>  <br> 4. < 
>  <br> 5. <= 
>  <br> 6. >= 
>  <br> 7. !=
>  <br> 8. is defined
>  <br> 9. is not defined
>  <br> 10. in  #用来判断元素在不在集合中
>  <br>   
> 连接符号: 
>  <br> 1. and
>  <br> 2. or


### 仅当收到 *变更* 通知时执行的任务(handlers)

```yaml
---
- name: check config and restart
  hosts: 
    - localhost
  tasks:
    - name: check config
      template:
        src: /var/lib/templates/demo.example.conf.template
        dest: /etc/httpd/conf.d/demo.example.conf
      notify:
        - restart apache
  handlers:
    - name: restart apache
      service:
        name: httpd
        state: restarted
```
> 只有 task 执行状态为 changed 的时候 handler 才会响应。 <br>
> 因为多个任务中途可能出现失败的情况，只要任意 task 失败 最终 handlers 都不会执行，
> 而下一次再次执行的时候已经完成的 task 一般不会为 changed 状态，所以 handler 此时就不会执行
> 需要在 playbook 的层级加入 force_handlers: true 参数 来让成功的 handler, 下面这个脚本
> 可以通过注释 force_handlers 来测试
> ```yaml
> ---
> - name: test failure
>   hosts: localhost
>   force_handlers: true
>   tasks:
>     - name: success task
>       command: /bin/true
>       notify: restart the database
>     - name: failure task
>       yum:
>         name: lkjsdkfj
>         state: latest
>   handlers:
>     - name: restart the database
>       command: echo "restart the database"
> ```


### 处理 task 执行失败

1. 忽略错误

  `ignore_errors`

2. 失败后强制执行 handler 进行处理 

  `force_handlers: true`

3. 自己处理失败

一般只在使用 shell 脚本的场景才会用到,因为shell 模块只判断 脚本有没有执行,执行过的状态就是 changed, 实际是否成功和changed需要自己判断

方式1：把这个任务标记为失败

```yaml
tasks:
  - name: run custom script
    shell: /usr/local/bin/mysh.sh
    regster: command_result
    failed_when: "'some words' in command_result.stdout"
```
也可以把这个任务标记为 changed
```yaml
tasks:
  - name: run custom script
    shell: /usr/local/bin/mysh.sh
    regster: command_result
    changed_when: "'some words' in command_result.stdout"
```


方式2：把其它任务标记为失败
```yaml
tasks:
  - name: run custom script
    shell: /usr/local/bin/mysh.sh
    register: command_result
    ignore_errors: true
  - name: report error
    fail: 
      msg: "some words in the output"
    when: "'some words' in command_result.stdout"
```

4. 定义一组逻辑的 task 放至同一个block中

对应 java 中的 try catch finally

block 块失败才会执行 rescue 块, 如论如何都会执行 always 块中的内容
```yaml
tasks:
  - name: Upgrade DB
    block:
      - name: upgrade the database
        shell:
          cmd: /usr/local/lib/upgrade-database
    rescue:
      - name: revert the database upgrade
        shell:
          cmd: /usr/local/lib/revert-database
    always:
      - name: always restart the database
        service:
          name: mariadb
          state: restarted

```

## Jinja2 模板
Jinja2模板是由 数据、变量和表达式等元素构成的模板，变量和表达式在使用时将被Jinja2模板引擎渲染

jinja2 模板一般配合 template 模板使用, 可以将对应的模板渲染之后的内容拷贝到被管理主机上，如下 :

最简单的用法:
```yaml
tasks:
  - name: template render
    vars:
      var_name: my name is xiaoming
    template:
      src: j2-template.j2
      dest: dest-config-file.txt
```
`j2.template.js` 的内容
```jinja2
{{ var_name }}
```

控制结构
1. 循环
```jinja2
{# comment #}
{% for user in users %}
  {{ user }}
{% endfor %}
```
2. 带条件循环
```jinja2
{% for myuser in users if not myuser == 'root' %}
  {{ myuser }}
{% endfor %}
```

3. 条件判断
只有当 finished 是 true 的时候会输出 result 变量
```jinja2
{% if finished %}
  {{ result }}
{% else %}
  {{ another_result }}
{% endif %}
```

## ansible role
role 你可以根据已知的文件结构自动加载相关的vars, files, tasks, handlers 和其他 Ansible artifacts。 将您的内容按 role 分组后，您可以轻松地重复使用它们并与其他用户共享。

role 的目录结构
```yaml
tasks/
handlers/
library/
files/
templates/
vars/
defaults/
meta/
```

* tasks/main.yml - the main list of tasks that the role executes.

* handlers/main.yml - handlers, which may be used within or outside this role.

* library/my_module.py - modules, which may be used within this role (see Embedding modules and plugins in roles for more information).

* defaults/main.yml - default variables for the role (see Using Variables for more information). These variables have the lowest priority of any variables available, and can be easily overridden by any other variable, including inventory variables.

  defaults 下面的变量任何地方的变量都能替换它 

* vars/main.yml - other variables for the role (see Using Variables for more information).

  vars 目录下面定义的变量不能被inventory里面的变量覆盖，但是可以被playbook里面的变量覆盖

* files/main.yml - files that the role deploys.

* templates/main.yml - templates that the role deploys.

* meta/main.yml - metadata for the role, including role dependencies.

  定义依赖
```yaml
dependencies:
  - role: rolea
    vara: vala
  - role: roleb
    varb: valb
```

### role 的使用

ansible 会在 当前目录下的 roles 子目录查找 role，也可以通过 [defaults] 下的 roles_path 来定义查找 role 的位置
默认位置如下 ~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles

一个使用 role 的格式如下
```yaml

---
- name: role demo
  hosts: some_hosts
  roles:
    - role: arole
    - role: brole
      vara: a
      varb: b
```

### 定义了 role 的 playbook task 执行的优先级

1. pre_tasks
2. role 的tasks
3. plabook的 tasks
4. post_tasks

### role 的创建
`ansible-galaxy init demo-role`

### role 的下载
`ansible-galaxy collection install`

### role 的查找
`ansible-galaxy search 'role_name'`

### role 的详细信息
`ansible-galaxy info 'role_name'`

### 安装依赖的 role
`ansible-galaxy install -r roles/requirements.yml`

### 列出目前可使用的role
`ansible-galaxy list`

### 删除role
`ansible-galaxy remove role_name`


## 特殊说明
### hosts 匹配
hosts 字段支持的基本操作

| 描述      | pattern(s) | 目标 |
| ----------- | ----------- | ----------- |
| All hosts | all (or *)       |  |
| One host | host1        | |
| Multiple hosts | host1:host2 (or host1,host2)| |
| One group | webservers        | |
| Multiple groups | webservers:dbservers        | all hosts in webservers plus all hosts in dbservers  |
| Excluding groups | webservers:!atlanta| all hosts in webservers except those in atlanta |
| Intersection of groups | webservers:!atlanta| any hosts in webservers that are also in staging |

此外，hosts 还支持以下特性
1. 支持*通配符
2. 支持 python 切片(数组)
3. 支持 正则表达式， 

详情参见[这里](https://docs.ansible.com/ansible/latest/user_guide/intro_patterns.html#intro-patterns)

### 引用多个 inventory 文件

如果引用了多个 inventory 文件，a文件中引用了b文件中的组作为子组，则应该在a中加入b中这个子组的空组，避免b中删除被引用的组后，组缺失导致的相关问题。

### playbook 中的 serial 参数

这个参数在管理大量的主机的时候可以管理一次性执行的最大主机数量，应用在滚动更新等场景, serial 个主机执行完成 playbook 后才开始下一批 serial个主机执行

### ansible.cfg 中的 forks 参数
指定并行运行的线程数

### import 和 include
import 是静态导入，在执行之前脚本就会变成最终的样子，操作对象一般是playbook
include 是动态导入，在执行之前脚本的内容是不存在的，操作对象一般是task

import_* 的优势是提前渲染，可以在引入的地方，直接使用导入的内容的 name 或者其它信息,但是一些条件判断，如 when 则每个 task 都会带上，会执行很多次
include_* 的优势是动态渲染，在引入的地方,使用 loop 来动态执行，如 when 之类的 task 执行判断，只针对整个被 include 的文件进行判断，只有一次

支持的操作符 
* import_playbook
* import_tasks
