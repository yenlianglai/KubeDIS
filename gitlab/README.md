# Setup with docker

## Get started

http://192.168.50.7:7777

user: root
password: ilovejoung112A

## install Gitlab 

docker compose up -d

## Set up root password

1. docker exec -ti [image digest] /bin/bash
2. gitlab-rails console -e production
3. user = User.where(id: 1).first
4. user.password = 'ilovejoung112A'
5. user.password_confirmation = 'ilovejoung112A'
6. user.save
7. exit

## enable ssh for docker gitlab
https://forum.gitlab.com/t/git-clone-over-ssh/77148/5



# Setup with Helm

## Useful material

1. https://blog.csdn.net/networken/article/details/132113051s
2. https://ost.51cto.com/posts/12308
3. https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/baremetal.md


```
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --values values.yaml
```
