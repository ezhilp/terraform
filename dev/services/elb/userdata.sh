#!/bin/bash -v

sudo apt-get update -y

sudo apt-get install -y nginx > /tmp/nginx.log

sudo apt-get install unzip

sudo mkdir -p /opt/terraform
sudo cd /opt/terraform
sudo wget https://releases.hashicorp.com/terraform/0.6.6/terraform_0.6.6_linux_amd64.zip
sudo unzip terraform_0.6.6_linux_amd64.zip -d /opt/terraform

sudo mv ~/.bashrc.1 ~/.bashrc | sed '4 i\PATH=$PATH:/opt/terraform' ~/.bashrc > ~/.bashrc.1
sudo mv ~/.bashrc.1 ~/.bashrc | sed '6 i\alias tfm=terraform' ~/.bashrc > ~/.bashrc.1
sudo source ~/.bashrc

sudo apt install awscli -y

sudo cd /mnt
sudo git clone https://github.com/ezhilp/terraform.git > out.log 2>&1
