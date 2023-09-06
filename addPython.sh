#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt install -y python3-pip python3-venv
su -l coder /bin/sh -c "code-server --force --install-extension=ms-python.python"
