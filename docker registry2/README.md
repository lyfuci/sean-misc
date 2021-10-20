# 简介
Registry 是一个无状态、高度可扩展的服务器端应用程序，用于存储和分发 Docker 镜像。

## 安装
### docker 安装
1. 安装docker并配置镜像加速
```shell
yum install -y yum-utils

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce docker-ce-cli containerd.io --allowerasing

systemctl enable docker --now

sudo mkdir -p /etc/docker

sudo tee /etc/docker/daemon.json << 'EOF'
{
"registry-mirrors": ["https://mycustom.registry.mirrors"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

2. 拉取registry镜像
```shell
docker pull registry
```

3.启动容器
```shell
docker run --privileged -d -v /opt/docker-registry:/var/lib/registry:Z -p 5000:5000 --restart=always --name registry registry:latest
```

4. 测试仓库是否可用
```shell
curl http://localhost:50000/v2/
```

5. 创建自签名证书支持tls加密
```shell
#创建证书存放目录
mkdir -p /opt/docker-registry/certs/

#生成私钥
cd /opt/docker-registry/certs/
openssl genrsa 2048 > server.key
cat > csr.cnf <<END
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C = CN
ST = Guangdong
L = Shenzhen
O = Nanshan
OU = sean
CN = registry.seansun.xyz
END

openssl req -new -key server.key -config csr.cnf -out server.csr
#自签证书
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```


6. 运行容器
```shell
docker rm -f registry

docker run --privileged -d -v /opt/docker-registry:/var/lib/registry:Z \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/var/lib/registry/certs/server.crt \
-e REGISTRY_HTTP_TLS_KEY=/var/lib/registry/certs/server.key \
-p 5000:5000 --restart=always \
--name registry registry:latest
```


7. 创建htpasswd文件支持认证
```shell
mkdir /opt/docker-registry/auth
yum -y install httpd-tools
htpasswd -Bbn sean abcdef >> /opt/docker-registry/auth/htpasswd
```


8. 运行容器
```shell
docker rm -f registry
docker run --privileged -d -v /opt/docker-registry:/var/lib/registry:Z \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/var/lib/registry/certs/server.crt \
-e REGISTRY_HTTP_TLS_KEY=/var/lib/registry/certs/server.key \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
-e REGISTRY_AUTH_HTPASSWD_PATH=/var/lib/registry/auth/htpasswd \
-p 5000:5000 --restart=always \
--name registry registry:latest
#更换了证书之后，重启一下docker
systemctl restart docker
```

9. 配置客户端
```shell
#安装docker
yum install -y yum-utils
yum-config-manager  --add-repo  https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io --allowerasing
systemctl enable docker --now
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json << 'EOF'
{
"registry-mirrors": ["https://mycustom.registry.mirrors"],
"insecure-registries": ["https://registry.seansun.xyz:5000"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
#拉取测试镜像
docker pull httpd
docker pull centos
#配置解析
cat > /etc/hosts <<END
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4
::1 localhost localhost.localdomain localhost6 localhost6.localdomain6
10.163.5.101 registry.seansun.xyz
END
#创建指定仓库的ca证书存放目录并放入ca证书
mkdir /etc/docker/certs.d/registry.seansun.xyz:5000/ -p
cp server.crt /etc/docker/certs.d/registry.seansun.xyz:5000/ca.crt
#重新配置私有仓库
cat > /etc/docker/daemon.json <<END
{
"registry-mirrors": ["https://mycustom.registry.mirrors"],
"insecure-registries": ["https://registry.seansun.xyz:5000"]
}
END
#修改tag
docker tag httpd registry.seansun.xyz:5000/httpd:latest
docker tag centos registry.seansun.xyz:5000/centos:latest
#登陆仓库
docker login registry.seansun.xyz:5000
Username: sean
Password: abcdef
#push镜像
docker push registry.seansun.xyz:5000/httpd:latest
#查看仓库中有哪些镜像
curl -u sean:abcdef -X GET https://registry.seansun.xyz:5000/v2/_catalog -k


```




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