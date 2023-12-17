# KubeDIS

**The purpose of this project is to:**

- Enable MLOps and future project deployment using Kubernetes.
- The cluster will be set up in Lab 112A, and it will serve as a platform for deploying and managing machine learning models and other projects.

## TODO

1. ~Test on minikube~
2. Setup Gitlab
3. Helm chart compatibility
4. Setup local K8s cluster
5. argoCD compatibility
6. KubeFlow

## Repo Description

This repo serves as a source repo for K8s manifests of applications runs on 112A local Kubernetes cluster.

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
3. Worker node not READY:
    -


##  Kube Join
kubeadm join 192.168.50.54:6443 --token alpsqj.xuuruur0v2jh8fwj \
	--discovery-token-ca-cert-hash sha256:6c81e7d2b94b0b47d5e31625551d650c25255fd795e81b5b962b159a7f327dab