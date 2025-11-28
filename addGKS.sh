#!/bin/bash

dnf  update
tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el10-$(arch)
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key-v10.gpg
EOM
dnf install -y libxcrypt-compat google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(arch)/kubectl"
mv kubectl /usr/local/bin
chmod a+rx /usr/local/bin/kubectl
su -l coder /bin/sh -c "code-server --force --install-extension=redhat.vscode-yaml --install-extension=ms-azuretools.vscode-docker --install-extension=yzhang.markdown-all-in-one --install-extension=ms-kubernetes-tools.vscode-kubernetes-tools"
