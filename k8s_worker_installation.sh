#!/bin/bash

# This script is for setting up a Kubernetes worker node.
# It includes steps to disable swap, install Docker, configure Docker, install Kubernetes components,
# install cri-dockerd, configure network settings, and join the cluster.

# Run as root

set -e

kubeadm reset -f --cri-socket unix:///var/run/cri-dockerd.sock

# Step 1: Disable swap
swapoff -a && sed -i '/swap/d' /etc/fstab

# Step 2: Install Docker
echo "Installing Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 3: Configure Docker
echo "Configuring Docker..."
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "tag": "{{.Name}}",
    "max-size": "2m",
    "max-file": "2"
  },
  "default-address-pools": [
    {
      "base": "172.31.0.0/16",
      "size": 24
    }
  ],
  "bip": "172.7.0.1/16"
}
EOF

# Step 4: Start Docker on boot
sudo systemctl enable docker && \
sudo systemctl start docker

# Step 5: Install Kubernetes components
echo "Installing Kubernetes components..."
sudo apt-get update && \
sudo apt-get install -y apt-transport-https ca-certificates curl gpg && \
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null && \
sudo apt-get update -y && \
sudo apt-get install -y kubelet kubeadm kubectl && \
sudo apt-mark hold kubelet kubeadm kubectl

# Step 6: Install cri-dockerd
echo "Installing cri-dockerd..."

## Fetch the latest stable version of Go
GO_LATEST_URL="https://go.dev/VERSION?m=text"
GO_VERSION=1.21.6
GO_TAR="go$GO_VERSION.linux-amd64.tar.gz"
GO_URL="https://dl.google.com/go/$GO_TAR"

## Define cri-dockerd version and architecture
VERSION="<replace_with_desired_version>"
ARCH="<replace_with_your_architecture>"

## Step 1: Install Go
echo "Downloading and installing the latest stable version of Go..."
wget $GO_URL
tar -C /usr/local -xzf $GO_TAR

## Add Go to PATH
export PATH=$PATH:/usr/local/go/bin

## Step 2: Clone and build cri-dockerd
echo "Cloning and building cri-dockerd..."
git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd
make cri-dockerd

## Step 3: Install cri-dockerd
echo "Installing cri-dockerd..."
mkdir -p /usr/local/bin
install -o root -g root -m 0755 cri-dockerd /usr/local/bin/cri-dockerd
install packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable --now cri-docker.socket

## Cleanup
echo "Cleaning up..."
cd ..
rm -rf cri-dockerd
rm -f $GO_TAR
rm -rf /usr/local/go
echo "cri-dockerd installation complete."


# Step 7: Network setup
# [Insert network setup script here]

## Create a file to load necessary kernel modules for Kubernetes
echo "Creating module load configuration for Kubernetes..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

## Load the kernel modules
echo "Loading kernel modules..."
sudo modprobe overlay
sudo modprobe br_netfilter

## Set sysctl parameters for Kubernetes networking
echo "Configuring sysctl parameters for Kubernetes networking..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

## Apply sysctl parameters without restarting
echo "Applying sysctl parameters..."
sudo sysctl --system

## Verify the configuration
echo "Verifying the configuration..."

## Check if kernel modules are loaded
echo "Checking kernel modules..."
if lsmod | grep -q br_netfilter; then
    echo "br_netfilter module is loaded."
else
    echo "br_netfilter module is NOT loaded."
fi

if lsmod | grep -q overlay; then
    echo "overlay module is loaded."
else
    echo "overlay module is NOT loaded."
fi

## Check if sysctl parameters are set
echo "Checking sysctl parameters..."
SYSCTL_PARAMS=(
    "net.bridge.bridge-nf-call-iptables"
    "net.bridge.bridge-nf-call-ip6tables"
    "net.ipv4.ip_forward"
)

for param in "${SYSCTL_PARAMS[@]}"; do
    value=$(sysctl -n $param)
    if [ "$value" -eq 1 ]; then
        echo "$param is set to 1."
    else
        echo "$param is NOT set to 1."
    fi
done

# Step 8: Join the cluster
echo "Joining the Kubernetes cluster..."
kubeadm join 192.168.50.54:6443 --token clcau5.gdr8xerg706spa2l --discovery-token-ca-cert-hash sha256:ea2642699703bdbeed710eafd1539b8fa32e1fda7b11938446609408478b2dd2 --cri-socket unix:///var/run/cri-dockerd.sock --v=5
