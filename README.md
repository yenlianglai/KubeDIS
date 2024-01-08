# KubeDIS

**The purpose of this project is to:**

- Enable MLOps and future project deployment using Kubernetes.
- The cluster will be set up in Lab 112A, and it will serve as a platform for deploying and managing machine learning models and other projects.

## TODO

1. ~Test on minikube~
2. ~Setup Gitlab~
3. Helm chart compatibility
4. ~Setup local K8s cluster~
5. ~argoCD compatibility~ (public Gitlab project is now compatible)
6. KubeFlow

## Repo Description

This repo serves as a source repo for K8s manifests of applications runs on 112A local Kubernetes cluster.

[Check the sub READMEs for details.]

## Proposed Architecture

Argo + Github action + K8s

![Alt text](<Desired target state.png>)

## Keyword

- ArgoCD
- Github action
- Helm Chart
- K8s

## Related Materials

- https://blog.jks.coffee/on-premise-self-host-kubernetes-k8s-setup/
- https://medium.com/@mssantossousa/deploy-using-argocd-and-github-actions-888f7370e480
- https://medium.com/mlearning-ai/setting-up-a-local-mlops-dev-environment-part-1-a8b468329819
- https://github.com/kubeflow/kubeflow

Argo
- https://www.arthurkoziel.com/setting-up-argocd-with-helm/

## 雷 May be

Nvidia k8s plugin

- https://github.com/NVIDIA/k8s-device-plugin#preparing-your-gpu-nodes


## 雷
1. 關掉swap: swapoff -a && sed -i '/swap/d' /etc/fstab
2. 重開或第一次設定 kubeadm: 
    - sudo -s 
    - export KUBECONFIG=/etc/kubernetes/admin.conf
    - exit
    - sudo chown -R $USER $HOME/.kube
3. Worker node not READY - reset flannel:
    - kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


##  Kube Join
```
kubeadm join 192.168.50.54:6443
    --token 2zka9p.lqrv7p1hfdr07u09 \
    --discovery-token-ca-cert-hash sha256:ea2642699703bdbeed710eafd1539b8fa32e1fda7b11938446609408478b2dd2 \
    --cri-socket unix:///var/run/cri-dockerd.sock
```
