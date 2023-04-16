#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "${file(keypair)}" >> /home/ubuntu/ssmkd
sudo chown ubuntu:ubuntu /home/ubuntu/ssmkd
chmod 400 /home/ubuntu/ssmkd
sudo hostnamectl set-hostname bastion