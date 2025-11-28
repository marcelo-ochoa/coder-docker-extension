#!/bin/bash

dnf update
dnf -y install dnf-plugins-core
dnf install nodejs -y
npm install -g express-generator
