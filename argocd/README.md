# Install argocd with helm

1. helm template . (for debug purpose)
2. helm install
3. need at least 2 nodes otherwise CRASHLOOPBACKOFF
4. need to enable ingress
5. need to install ingress-nginx and change the type to NodePort
6. set up nginx reverse proxy to access the nodePort ip


## Get Started

1. add the following to /etc/hosts

192.168.50.6      argocd.112a.internal

2. Access the UI
http://argocd.112a.internal

user: admin
password: ilovejoung112A


