#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export NODE_MAJOR=20
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common unzip lsb-release
install -m 0755 -d /etc/apt/keyrings
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
apt-get update && apt-get install -y google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
mv kubectl /usr/local/bin
chmod a+rx /usr/local/bin/kubectl
su -l coder /bin/sh -c "code-server --force --install-extension=redhat.vscode-yaml --install-extension=ms-azuretools.vscode-docker --install-extension=yzhang.markdown-all-in-one --install-extension=ms-kubernetes-tools.vscode-kubernetes-tools"
