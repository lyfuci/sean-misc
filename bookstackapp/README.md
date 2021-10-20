# 简介
BookStack 是一个简单的、自托管的、易于使用的平台，用于组织和存储信息。


## 第三方认证
### gitlab
在使用 bookstack 时可以依赖 gitlab 相关功能进行 Oauth 认证，以下对相关环境变量进行描述。

```shell
# gitlab oauth 
GITLAB_APP_ID
GITLAB_APP_SECRET
# BookStack access url
APP_URL
# gitlab access url
GITLAB_BASE_URI
# enable auto register when use gitlab login
GITLAB_AUTO_REGISTER=true
# locale
APP_LANG=zh_CN
```

详细的描述文档在 [这里](https://www.bookstackapp.com/docs/admin/third-party-auth/#gitlab) ,上面仅补充了自动注册和中文变量,个人使用觉得比较实用，故记录一下。