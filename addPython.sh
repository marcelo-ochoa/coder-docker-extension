#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

su -l coder /bin/sh -c "code-server --force --install-extension=ms-python.python"
