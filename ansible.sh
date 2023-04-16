#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo apt-get update -y 
sudo apt install python3-pip -y
sudo pip3 install boto boto3 botocore
sudo apt-add-repository ppa:ansible/ansible 
sudo apt-get install ansible -y
sudo -i
sudo touch /etc/ansible/stage_hosts
sudo chown ubuntu:ubuntu /etc/ansible/stage_hosts
sudo chown ubuntu:ubuntu /etc/ansible/hosts
sudo chown -R ubuntu:ubuntu /etc/ansible && chmod +x /etc/ansible
sudo bash -c 'echo "StrictHostKeyChecking No" >> /etc/ssh/ssh_config'
sudo chmod 400 /home/ubuntu/ssmkd
sudo chmod 777 /etc/ansible/hosts
sudo chmod 777 /etc/ansible/stage_hosts
sudo touch /home/ubuntu/playbooks/ha-ip.yml
sudo echo ha_prv_ip: "${HA_priv_ip}" >> /home/ubuntu/playbooks/ha-ip.yml
sudo echo Stage_ha_prv_ip: "${Stage_HA_priv_ip}" >> /home/ubuntu/playbooks/ha-ip.yml
sudo echo "[Prod_HAproxy]" >> /etc/ansible/hosts
sudo echo "${Prod_HAproxy} ansible_ssh_private_key_file=/home/ubuntu/ssmkd" >> /etc/ansible/hosts
sudo echo "[Main_master]" >> /etc/ansible/hosts
sudo echo "${Master_1} ansible_ssh_private_key_file=/home/ubuntu/ssmkd" >> /etc/ansible/hosts
sudo echo "[Member_master]" >> /etc/ansible/hosts
sudo echo "${Member_master_1} ansible_ssh_private_key_file=/home/ubuntu/ssmkd" >> /etc/ansible/hosts
sudo echo "${Member_master_2} ansible_ssh_private_key_file=/home/ubuntu/ssmkd" >> /etc/ansible/hosts
sudo echo "[Worker]" >> /etc/ansible/hosts
sudo echo "${Worker} ansible_ssh_private_key_file=/home/ubuntu/ssmkd" >> /etc/ansible/hosts
sudo echo "[Stage_HAproxy]" >> /etc/ansible/stage_hosts
sudo echo "${Stage_HAproxy} ansible_ssh_private_key_file=/home/ubuntu/ssmkd" >> /etc/ansible/stage_hosts
sudo echo "[Stage_Main_master]" >> /etc/ansible/stage_hosts
sudo echo "${Stage_Master_1} ansible_ssh_private_key_file=/home/ubuntu/ssmkd" >> /etc/ansible/stage_hosts
sudo echo "[Stage_Member_master]" >> /etc/ansible/stage_hosts
sudo echo "${Stage_Member_master_1} ansible_ssh_private_key_file=/home/ubuntu/ssmkd" >> /etc/ansible/stage_hosts
sudo echo "${Stage_Member_master_2} ansible_ssh_private_key_file=/home/ubuntu/ssmkd" >> /etc/ansible/stage_hosts
sudo echo "[Worker]" >> /etc/ansible/stage_hosts
sudo echo "${Stage_Worker} ansible_ssh_private_key_file=/home/ubuntu/ssmkd" >> /etc/ansible/stage_hosts
sudo chmod 400 /home/ubuntu/ssmkd
sudo su -c "ansible-playbook /home/ubuntu/playbooks/Installation.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/MainMaster.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/MemberMaster.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/JoinWorker.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/HA_Proxy.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/deployment.yml" ubuntu
sudo su -c "ansible-playbook -i /etc/ansible/stage_hosts /home/ubuntu/playbooks/Installation.yml" ubuntu 
sudo su -c "ansible-playbook -i /etc/ansible/stage_hosts /home/ubuntu/playbooks/StageMainMaster.yml" ubuntu 
sudo su -c "ansible-playbook -i /etc/ansible/stage_hosts /home/ubuntu/playbooks/StageMemMaster.yml" ubuntu 
sudo su -c "ansible-playbook -i /etc/ansible/stage_hosts /home/ubuntu/playbooks/StageJoinWorker.yml" ubuntu 
sudo su -c "ansible-playbook -i /etc/ansible/stage_hosts /home/ubuntu/playbooks/Stage_HAproxy.yml" ubuntu 
sudo su -c "ansible-playbook -i /etc/ansible/stage_hosts /home/ubuntu/playbooks/deployment.yml" ubuntu



