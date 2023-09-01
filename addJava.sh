#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export NODE_MAJOR=20
apt-get update
apt install -y ca-certificates-java openjdk-17-jdk
su -l coder /bin/sh -c "code-server --force --install-extension=redhat.java --install-extension=vscjava.vscode-java-debug --install-extension=vscjava.vscode-java-test --install-extension=vscjava.vscode-maven --install-extension=vscjava.vscode-java-dependency"
