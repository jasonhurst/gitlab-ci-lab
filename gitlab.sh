#!/bin/bash
sudo yum install -y curl policycoreutils-python openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd
sudo firewall-cmd --permanent --add-service=http
sudo systemctl reload firewalld
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
sudo yum install -y gitlab-ce-11.10.4-ce.0.el7.x86_64
sudo sed -i 's#external_url .*#external_url '"'"'http://192.168.100.10'"'"'#' /etc/gitlab/gitlab.rb
sudo gitlab-ctl reconfigure