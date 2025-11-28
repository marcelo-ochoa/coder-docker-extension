#!/bin/bash

dnf update
dnf install -y python3-pip python3-virtualenv
su -l coder /bin/sh -c "code-server --force --install-extension=ms-python.python"
