#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export NODE_MAJOR=20
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common unzip lsb-release
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
     "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
     tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "docker:x:999:coder" >> /etc/group
