#!/bin/bash

curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
sudo yum install -y git
sudo yum install -y gitlab-runner
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo usermod -a -G docker vagrant
newgrp docker
usermod -a -G docker gitlab-runner
echo "gitlab-runner ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
sudo service docker start
