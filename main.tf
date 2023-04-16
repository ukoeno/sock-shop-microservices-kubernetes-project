# Ansible Security Group
resource "aws_security_group" "Ansible_SG" {
  name        = "${var.name}-Ansible-sg"
  description = "Allow Inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Allow ssh access"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  ingress {
    description = "Allow inbound traffic"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  ingress {
    description = "Allow inbound traffic"
    from_port   = var.proxy_port4
    to_port     = var.proxy_port4
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_access]
  }

  tags = {
    Name = "${var.name}-Ansible_SG"
  }
}


# Jenkins Security Group
resource "aws_security_group" "Jenkins_SG" {
  name        = "${var.name}-Jenkins-sg"
  description = "Allow Inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Allow ssh access"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  ingress {
    description = "Allow proxy access"
    from_port   = var.proxy_port1
    to_port     = var.proxy_port1
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  ingress {
    description = "Allow inbound traffic"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_access]
  }

  tags = {
    Name = "${var.name}-Jenkins_SG"
  }
}

#LC ALB Security Group
resource "aws_security_group" "ALB_SG" {
  name        = "${var.name}-ALB-sg"
  description = "Allow Inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Allow ssh access"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  ingress {
    description = "Allow proxy access"
    from_port   = var.proxy_port3
    to_port     = var.proxy_port3
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  ingress {
    description = "Allow proxy access"
    from_port   = var.proxy_port5
    to_port     = var.proxy_port5
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  ingress {
    description = "Allow inbound traffic"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_access]
  }

  tags = {
    Name = "${var.name}-ALB_SG"
  }
}

#Bastion Security Group
resource "aws_security_group" "Bastion_SG" {
  name        = "${var.name}-bastion-sg"
  description = "Allow Inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Allow ssh access"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

    ingress {
    description = "Allow inbound traffic"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
    #cidr_blocks = [var.personal_addy] # my computer ip address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_access]
  }

  tags = {
    Name = "${var.name}-bastion_SG"
  }
}

#Nodes (Master and Worker) Security Group
resource "aws_security_group" "Nodes_SG" {
  name        = "${var.name}-Nodes_SG"
  description = "Allow Inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Allow ssh access"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  ingress {
    from_port   = var.proxy_port4
    to_port     = var.proxy_port4
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  ingress {
    from_port   = var.proxy_port5
    to_port     = var.proxy_port5
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }
  ingress {
    from_port   = var.proxy_port7
    to_port     = var.proxy_port7
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }
  ingress {
    from_port   = var.proxy_port6
    to_port     = var.proxy_port6
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_access]
  }


    ingress {
    description = "Allow inbound traffic"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_access]
  }

  tags = {
    Name = "${var.name}-bastion_SG"
  }
}