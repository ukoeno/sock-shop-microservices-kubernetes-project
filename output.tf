output "bastion-sg-id" {
  value = aws_security_group.Bastion_SG.id
}

output "ansible-sg-id" {
  value = aws_security_group.Ansible_SG.id
}

output "jenkins-sg-id" {
  value = aws_security_group.Jenkins_SG.id
}

output "alb-sg-id" {
  value = aws_security_group.ALB_SG.id
}

output "nodes-sg-id" {
  value = aws_security_group.Nodes_SG.id
}


