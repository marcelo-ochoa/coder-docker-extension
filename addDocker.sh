#!/bin/bash

dnf update
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
su -l coder /bin/sh -c "code-server --force --install-extension=redhat.vscode-yaml --install-extension=ms-azuretools.vscode-docker --install-extension=yzhang.markdown-all-in-one"
