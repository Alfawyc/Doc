### rancher+k3s高可用部署

- linux：centos7.9
- rancher：2.3.11
- k3s：1.20.8+k3s1

#### k3s安装

> k3s集群中有两种类型的节点，Server节点和Agent节点。Server节点和Agent节点都可以运行工作负载。Server节点运行Kubernetes Master。对于运行Rancher Server的集群，建议使用两个Server节点，不需要Agent节点。具体请参考[推荐架构](https://docs.rancher.cn/docs/rancher2/overview/architecture-recommendations/_index)

1. 部署外部数据库，这里使用mysql(5.7)作为外部数据库，[集群数据存储选项](https://docs.rancher.cn/docs/k3s/installation/datastore/_index/)

2. 部署k3s-server节点

> 如果要部署多个server节点，只需要在机器上运行以下命令

```powershell
# 默认安装的是最新版的k3s
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn \
sh -s - server \
--datastore-endpoint='mysql://username:password@tcp(127.0.0.1:3306)/k3s'

# 如果要指定版本可以使用以下命令
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn \
INSTALL_K3S_VERSION=v1.20.8+k3s1 \
sh -s - server \
--datastore-endpoint='mysql://username:password@tcp(127.0.0.1:3306)/k3s'
```

3. 运行完毕后使用以下命名查看部署情况

```bash
# k3s kubectl get nodes

NAME      STATUS   ROLES    AGE   VERSION
local60   Ready    master   77m   v1.17.15+k3s1
local57   Ready    master   67m   v1.17.15+k3s1
```

```bash
# k3s kubectl get pods --all-namespaces

NAMESPACE       NAME                                      READY   STATUS      RESTARTS   AGE
kube-system     coredns-854c77959c-nvjnc                  1/1     Running     0          54m
kube-system     local-path-provisioner-5ff76fc89d-g45m4   1/1     Running     0          54m
kube-system     metrics-server-86cbb8457f-wwjwm           1/1     Running     0          54m
kube-system     helm-install-traefik-97tlt                0/1     Completed   0          54m
kube-system     svclb-traefik-9c8kz                       2/2     Running     0          53m
kube-system     svclb-traefik-8npf9                       2/2     Running     0          53m
cattle-system   cattle-cluster-agent-84696f7c8b-856bj     1/1     Running     0          53m
kube-system     traefik-6f9cbd9bd4-fmbn7                  1/1     Running     0          53m
fleet-system    fleet-agent-d59db746-d499l                1/1     Running     0          52m
```

#### k3s的卸载

在使用脚本安装k3s时，已提供了脚本卸载脚本



1. k3s-server的卸载

```
/usr/local/bin/k3s-uninstall.sh
```

2. k3s-agent的卸载

```
/usr/local/bin/k3s-agent-uninstall.sh
```

#### helm安装

参考文档[安装Helm](https://helm.sh/zh/docs/intro/install/)

1. 首先选择一个helm版本并下载[release](https://github.com/helm/helm/releases)，解压并将可执行文件移动到环境变量目录下

```
wget https://get.helm.sh/helm-v3.6.0-linux-amd64.tar.gz

tar -zxvf helm-v3.6.0-linux-amd64.tar.gz

mv linux-amd64/helm /usr/local/bin/helm
```

2. 查看helm是否可用

```
# helm version
```

#### 安装Rancher

1. 添加rancher地址

```
helm repo add rancher-stable http://rancher-mirror.oss-cn-beijing.aliyuncs.com/server-charts/stable
```

2. 为rancher创建namesapce

```
kubectl create namespace cattle-system
```

3. 选择ssl选项

Rancher Server 默认需要 SSL/TLS 配置来保证访问的安全性。有三种SSL方式可以选择，生产自己的证书请参考[生成自签名 SSL 证书](https://docs.rancher.cn/docs/rancher2/installation/resources/advanced/self-signed-ssl/_index)，

- Rancher 生成的自签名证书

- Let's Encrypt

- 使用您自己的证书

4. 通过Helm安装Rancher

```
# 配置环境变量
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# 执行安装命令  rancher.my.org使用自己的域名替换
helm install rancher rancher-stable/rancher \
 --namespace cattle-system \
 --set hostname=rancher.my.org \
 --set ingress.tls.source=secret
```

5. 验证Ranchers是否成功部署

```
# kubectl -n cattle-system rollout status deploy/rancher

Waiting for deployment "rancher" rollout to finish: 0 of 3 updated replicas are available...
deployment "rancher" successfully rolled out

# kubectl -n cattle-system get deploy rancher

NAME      READY   UP-TO-DATE   AVAILABLE   AGE
rancher   3/3     3            3           166m
```

#### 安装成功使用域名登录Rancher UI界面

