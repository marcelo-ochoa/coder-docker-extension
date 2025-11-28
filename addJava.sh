#!/bin/bash

dnf update
dnf install -y java-latest-openjdk-devel
su -l coder /bin/sh -c "code-server --force --install-extension=redhat.java --install-extension=vscjava.vscode-java-debug --install-extension=vscjava.vscode-java-test --install-extension=vscjava.vscode-maven --install-extension=vscjava.vscode-java-dependency"
