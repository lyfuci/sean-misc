# maven
Apache Maven 是一个软件项目管理的综合性工具。基于项目对象模型 (POM) 的概念，Maven 可以利用相关信息处理项目的构建、报告和文档等相关内容。

这里不会对 maven 进行过多的介绍，仅针对一些特殊的使用场景提供一些现有的脚本。

## 使用场景
### 局域网上传工件到 repository
在某些场景下，需要上传工件到某些局域网的 maven 私服仓库，然后供其它局域网内的应用使用，但是私服无法直接出公网，这就需要上传本地的 maven 仓库到私服。

[deploy-to-private-repository.sh](./deploy-to-private-repository.sh)

需要指定这个脚本里面的 settings 和 url 变量，两个变量意义分别如下
settings： 配置了私服用户密码等信息的配置文件
url: 局域网私服的url
这个脚本会每两秒启动一个进程上传一个 jar 或者 pom 的工件。