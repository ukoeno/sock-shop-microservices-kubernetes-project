# VPC
module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
  azs                    = [var.az1, var.az2]
  private_subnets        = [var.prv-sn1, var.prv-sn2, var.prv-sn3, var.prv-sn4]
  public_subnets         = [var.pub-sn1, var.pub-sn2]
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  tags = {
    Terraform = "true"
    Name      = "${var.name}-vpc"
  }
}

# Security Group
module "sg" {
  source = "./ssmkd_module/sg"
  vpc    = module.vpc.vpc_id
}

# Keypair
module "key_pair" {
  source     = "terraform-aws-modules/key-pair/aws"
  key_name   = var.keyname
  public_key = file("~/keypairs/ssmkd.pub")
}

# Create Prod Master Nodes
module "Master_Nodes" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${var.name}-Master_Nodes"
  ami                    = var.ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.nodes-sg-id]
  subnet_id              = module.vpc.private_subnets[0]
  count                  = var.Master-count

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "${var.name}-Master_Nodes${count.index}"
  }
}

# Create Stage Master Nodes
module "Stage_Master_Nodes" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${var.name}-Stage_Master_Nodes"
  ami                    = var.ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.nodes-sg-id]
  subnet_id              = module.vpc.private_subnets[1]
  count                  = var.Stage_Master-count

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "${var.name}-Stage_Master_Nodes${count.index}"
  }
}

# Create Stage Worker Nodes
module "Nodes" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${var.name}-Stage_Worker_Nodes"
  ami                    = var.ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.nodes-sg-id]
  subnet_id              = module.vpc.private_subnets[0]
  count                  = var.Worker-count

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "${var.name}-Stage_Worker_Nodes${count.index}"
  }
}

# Bastion Host
module "Bastion" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${var.name}-Nodes"
  ami                    = var.ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.bastion-sg-id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data              = templatefile("./user_data/bastion.sh",
  {
     keypair = "~/keypairs/ssmkd"
  }
  )


  tags = {
    Terraform = "true"
    Name      = "${var.name}-Bastion"
  }
}
# Jenkins Instance
module "Jenkins" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = var.name
  ami                    = var.ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.jenkins-sg-id]
  subnet_id              = module.vpc.private_subnets[0]
  user_data              = file("./user_data/jenkins.sh")
  tags = {
    Terraform = "true"
    Name      = "${var.name}-Jenkins"
  }
}
# PROD HAroxy Server
module "PROD_HAproxy" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = var.name
  ami                    = var.ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.nodes-sg-id]
  subnet_id              = module.vpc.private_subnets[0]
  user_data = templatefile("./user_data/Prod_HAproxy.sh",
    {
      Master_1        = module.Master_Nodes[0].private_ip,
      Member_master_1 = module.Master_Nodes[1].private_ip,
      Member_master_2 = module.Master_Nodes[2].private_ip,
    }
  )
  tags = {
    Terraform = "true"
    Name      = "${var.name}-PROD_HAproxy"
  }
}
# STAGE HAroxy Server
module "STAGE_HAproxy" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = var.name
  ami                    = var.ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.nodes-sg-id]
  subnet_id              = module.vpc.private_subnets[0]
  user_data = templatefile("./user_data/Stage_HAproxy.sh",
    {
      Stage_Master_1        = module.Stage_Master_Nodes[0].private_ip,
      Stage_Member_master_1 = module.Stage_Master_Nodes[1].private_ip,
      Stage_Member_master_2 = module.Stage_Master_Nodes[2].private_ip
    }
  )
  tags = {
    Terraform = "true"
    Name      = "${var.name}-STAGE_HAproxy"
  }
}
# Ansible Instance
module "Ansible" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = var.name
  ami                    = var.ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.ansible-sg-id]
  subnet_id              = module.vpc.private_subnets[1]
  user_data = templatefile("./user_data/ansible.sh",
    {
      HA_priv_ip            = module.PROD_HAproxy.private_ip,
      Prod_HAproxy          = module.PROD_HAproxy.private_ip,
      Master_1              = module.Master_Nodes[0].private_ip,
      Member_master_1       = module.Master_Nodes[1].private_ip,
      Member_master_2       = module.Master_Nodes[2].private_ip,
      Worker                = module.Nodes[0].private_ip,
      Stage_HA_priv_ip      = module.STAGE_HAproxy.private_ip,
      Stage_HAproxy         = module.STAGE_HAproxy.private_ip,
      Stage_Master_1        = module.Stage_Master_Nodes[0].private_ip,
      Stage_Member_master_1 = module.Stage_Master_Nodes[1].private_ip,
      Stage_Member_master_2 = module.Stage_Master_Nodes[2].private_ip,
      Stage_Worker          = module.Nodes[1].private_ip

    }
  )
  tags = {
    Terraform = "true"
    Name      = "${var.name}-Ansible"
  }
}

resource "null_resource" "ansible_configure" {
  connection {
    type                = "ssh"
    host                = module.Ansible.private_ip
    user                = "ubuntu"
    private_key         = file("~/keypairs/ssmkd")
    bastion_host        = module.Bastion.public_ip
    bastion_user        = "ubuntu"
    bastion_private_key = file("~/keypairs/ssmkd")
  }
  provisioner "file" {
    source      = "./playbooks"
    destination = "/home/ubuntu/playbooks"
  }
  provisioner "file" {
    source      = "~/keypairs/ssmkd"
    destination = "/home/ubuntu/ssmkd"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ansible",
      "sudo chmod 400 /home/ubuntu/ssmkd"

    ]
  }
}
# Production Elastic Load Balancer
module "Prod_elb" {
  source = "./ssmkd_module/Prod_ELB"
  Prod_id = module.Nodes[0].id
  subnet_id1 = module.vpc.public_subnets[0]
  subnet_id2 = module.vpc.public_subnets[1]
  security_id = module.sg.alb-sg-id
}

# Stage Elastic Load Balancer
module "Stage_elb" {
  source = "./ssmkd_module/Stage_ELB"
  Stage_id = module.Nodes[1].id
  subnet_id1 = module.vpc.public_subnets[0]
  subnet_id2 = module.vpc.public_subnets[1]
  security_id = module.sg.alb-sg-id
}