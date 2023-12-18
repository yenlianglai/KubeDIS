# Gitlab setup guide

## Get started

http://192.168.50.7:7777

user: admin
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

