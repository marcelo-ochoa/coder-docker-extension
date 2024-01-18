#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export NODE_MAJOR=20
su -l coder /bin/sh -c "code-server --force --install-extension=Oracle.oracledevtools --install-extension=ms-dotnettools.vscode-dotnet-runtime"
