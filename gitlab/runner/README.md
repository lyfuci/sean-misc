# 简介
GitLab Runner 是一个与 GitLab CI/CD 配合使用以在pipeline中运行job的应用程序。

可以在通过 gitlab-runner 的镜像相关介绍进行 runner 的注册。

## 在注册之后 toml 文件中配置大致如下
```toml
concurrent = 5
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "docker runner for nanshan"
  url = "$gitlab_access_url"
  token = "mytoken"
  executor = "docker"
  clone_url = "$gitlab_clone_url"
  environment = ["DOCKER_AUTH_CONFIG={\"auths\":{\"$registry_url\":{\"auth\":\"$registry_auth_base64\"}}}"]
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
  [runners.docker]
    tls_verify = false
    image = "$default_image"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache", "/var/run/docker.sock:/var/run/docker.sock"]
    shm_size = 0
```